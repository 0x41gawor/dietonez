package service

import (
	"context"
	"database/sql"
	"fmt"

	"github.com/0x41gawor/dietonez/internal/repo"
	"github.com/0x41gawor/dietonez/internal/service/model"
)

type ServiceDiets struct {
	db *sql.DB
}

func NewServiceDiets() *ServiceDiets {
	db := repo.GetDatabaseInstance().DB
	return &ServiceDiets{db: db}
}

func (s *ServiceDiets) ListAll(ctx context.Context) ([]*model.DietShort, error) {
	// Główne diety
	const qDiets = `
		SELECT d.id, d.name, d.descr
		FROM diets d
		ORDER BY d.id;
	`

	rows, err := s.db.QueryContext(ctx, qDiets)
	if err != nil {
		return nil, fmt.Errorf("query diets: %w", err)
	}
	defer rows.Close()

	// Mapa ID → DietShort (do późniejszego uzupełnienia labelami)
	dietMap := make(map[int]*model.DietShort)
	var out []*model.DietShort

	for rows.Next() {
		var d model.DietShort
		if err := rows.Scan(&d.ID, &d.Name, &d.Descr); err != nil {
			return nil, fmt.Errorf("scan diet: %w", err)
		}
		d.Labels = []model.Label{}
		dietMap[d.ID] = &d
		out = append(out, &d)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("rows err: %w", err)
	}

	// Etykiety do każdej diety
	const qLabels = `
		SELECT dlb.diet_id, l.label, l.color
		FROM diet_label_bridge dlb
		JOIN diet_labels l ON l.id = dlb.label_id;
	`

	labelRows, err := s.db.QueryContext(ctx, qLabels)
	if err != nil {
		return nil, fmt.Errorf("query labels: %w", err)
	}
	defer labelRows.Close()

	for labelRows.Next() {
		var dietID int
		var lbl model.Label
		if err := labelRows.Scan(&dietID, &lbl.Label, &lbl.Color); err != nil {
			return nil, fmt.Errorf("scan label: %w", err)
		}
		if diet, ok := dietMap[dietID]; ok {
			diet.Labels = append(diet.Labels, lbl)
		}
	}
	if err := labelRows.Err(); err != nil {
		return nil, fmt.Errorf("label rows err: %w", err)
	}

	return out, nil
}

func (s *ServiceDiets) Create(ctx context.Context, in *model.DietPost) (*model.DietGet, error) {
	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return nil, fmt.Errorf("begin tx: %w", err)
	}
	defer tx.Rollback()

	// 1. Insert diet
	const qDiet = `
		INSERT INTO diets (name, descr)
		VALUES ($1, $2)
		RETURNING id;
	`
	var dietID int
	err = tx.QueryRowContext(ctx, qDiet, in.Name, in.Descr).Scan(&dietID)
	if err != nil {
		return nil, fmt.Errorf("insert diet: %w", err)
	}

	// 2. Insert labels
	if len(in.Labels) > 0 {
		const qLabel = `
			INSERT INTO diet_label_bridge (diet_id, label_id)
			SELECT $1, id FROM diet_labels
			WHERE label = $2 AND color = $3;
		`
		stmt, err := tx.PrepareContext(ctx, qLabel)
		if err != nil {
			return nil, fmt.Errorf("prepare labels: %w", err)
		}
		defer stmt.Close()

		for _, lbl := range in.Labels {
			_, err := stmt.ExecContext(ctx, dietID, lbl.Label, lbl.Color)
			if err != nil {
				return nil, fmt.Errorf("insert label: %w", err)
			}
		}
	}

	// 3. Oblicz liczbę tygodni
	weekCount := len(in.Weeks)
	if weekCount == 0 {
		return nil, fmt.Errorf("cannot create diet with 0 weeks")
	}
	const mealsPerDay = 5
	const daysPerWeek = 6
	const slotsPerWeek = mealsPerDay * daysPerWeek // = 30

	// 4. Insert pustych slotów
	const qEmptySlot = `
		INSERT INTO diet_slots (diet_id, slot_num, dish_id)
		VALUES ($1, $2, NULL);
	`
	stmtSlot, err := tx.PrepareContext(ctx, qEmptySlot)
	if err != nil {
		return nil, fmt.Errorf("prepare slot insert: %w", err)
	}
	defer stmtSlot.Close()

	totalSlots := weekCount * slotsPerWeek
	for i := 1; i <= totalSlots; i++ {
		_, err := stmtSlot.ExecContext(ctx, dietID, i)
		if err != nil {
			return nil, fmt.Errorf("insert empty slot #%d: %w", i, err)
		}
	}

	// 5. Uzupełnij sloty z danymi (slot_num → dish_id)
	const qUpdateSlot = `
		UPDATE diet_slots SET dish_id = $1
		WHERE diet_id = $2 AND slot_num = $3;
	`
	stmtUpdate, err := tx.PrepareContext(ctx, qUpdateSlot)
	if err != nil {
		return nil, fmt.Errorf("prepare slot update: %w", err)
	}
	defer stmtUpdate.Close()

	// Mapowanie meal string → index
	mealIndex := map[string]int{
		"Breakfast":    0,
		"Lunch":        1,
		"Pre-Workout":  2,
		"Post-Workout": 3,
		"Supper":       4,
	}
	// Mapowanie day string → index
	dayIndex := map[string]int{
		"Monday":    0,
		"Tuesday":   1,
		"Wednesday": 2,
		"Thursday":  3,
		"Friday":    4,
		"Saturday":  5,
	}

	for _, week := range in.Weeks {
		for _, day := range week.Days {
			di, ok := dayIndex[day.Name]
			if !ok {
				return nil, fmt.Errorf("invalid day name: %s", day.Name)
			}
			for _, slot := range day.Slots {
				mi, ok := mealIndex[slot.Meal]
				if !ok {
					return nil, fmt.Errorf("invalid meal name: %s", slot.Meal)
				}
				slotNum := (week.Num-1)*slotsPerWeek + di*mealsPerDay + mi + 1
				_, err := stmtUpdate.ExecContext(ctx, slot.Dish.ID, dietID, slotNum)
				if err != nil {
					return nil, fmt.Errorf("update slot_num %d: %w", slotNum, err)
				}
			}
		}
	}

	if err := tx.Commit(); err != nil {
		return nil, fmt.Errorf("commit: %w", err)
	}

	return s.GetByID(ctx, dietID)
}

func (s *ServiceDiets) GetByID(ctx context.Context, id int) (*model.DietGet, error) {
	// 1. Pobierz dietę
	const qDiet = `
		SELECT id, name, descr
		FROM diets
		WHERE id = $1;
	`
	var d model.DietGet
	err := s.db.QueryRowContext(ctx, qDiet, id).Scan(&d.ID, &d.Name, &d.Descr)
	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, fmt.Errorf("query diet: %w", err)
	}

	// 2. Pobierz etykiety
	const qLabels = `
		SELECT l.label, l.color
		FROM diet_label_bridge b
		JOIN diet_labels l ON l.id = b.label_id
		WHERE b.diet_id = $1;
	`
	rows, err := s.db.QueryContext(ctx, qLabels, id)
	if err != nil {
		return nil, fmt.Errorf("query labels: %w", err)
	}
	defer rows.Close()

	d.Labels = []model.Label{}
	for rows.Next() {
		var lbl model.Label
		if err := rows.Scan(&lbl.Label, &lbl.Color); err != nil {
			return nil, fmt.Errorf("scan label: %w", err)
		}
		d.Labels = append(d.Labels, lbl)
	}

	// 3. Pobierz sloty
	const qSlots = `
		SELECT slot_num, d.id, d.name, 
		       COALESCE(SUM(ia.amount / i.default_amount * i.kcal), 0),
		       COALESCE(SUM(ia.amount / i.default_amount * i.proteins), 0),
		       COALESCE(SUM(ia.amount / i.default_amount * i.fats), 0),
		       COALESCE(SUM(ia.amount / i.default_amount * i.carbs), 0)
		FROM diet_slots s
		JOIN dishes d ON d.id = s.dish_id
		LEFT JOIN ingredient_amounts ia ON ia.dish_id = d.id
		LEFT JOIN ingredients i ON i.id = ia.ingredient_id
		WHERE s.diet_id = $1 AND s.dish_id IS NOT NULL
		GROUP BY s.slot_num, d.id, d.name
		ORDER BY s.slot_num;
	`

	slotRows, err := s.db.QueryContext(ctx, qSlots, id)
	if err != nil {
		return nil, fmt.Errorf("query slots: %w", err)
	}
	defer slotRows.Close()

	// pomocnicza mapa slot_num → dish
	slotMap := make(map[int]model.DishGetShort)
	for slotRows.Next() {
		var (
			slotNum int
			dish    model.DishGetShort
		)
		if err := slotRows.Scan(&slotNum, &dish.ID, &dish.Name, &dish.Kcal, &dish.Protein, &dish.Fat, &dish.Carbs); err != nil {
			return nil, fmt.Errorf("scan slot: %w", err)
		}
		slotMap[slotNum] = dish
	}

	// 4. Zrekonstruuj tygodnie i dni
	const mealsPerDay = 5
	const daysPerWeek = 6
	const slotsPerWeek = mealsPerDay * daysPerWeek

	var weeks []model.WeekGet
	for weekNum := 1; ; weekNum++ {
		start := (weekNum - 1) * slotsPerWeek
		found := false

		var days []model.DayGet
		for dayIndex := 0; dayIndex < daysPerWeek; dayIndex++ {
			dayName := [...]string{"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}[dayIndex]
			var slots []model.SlotGet

			for mealIndex, meal := range [...]string{"Breakfast", "Lunch", "Pre-Workout", "Post-Workout", "Supper"} {
				slotNum := start + dayIndex*mealsPerDay + mealIndex + 1
				if dish, ok := slotMap[slotNum]; ok {
					found = true
					slots = append(slots, model.SlotGet{
						Meal: meal,
						Dish: dish,
					})
				}
			}

			days = append(days, model.DayGet{
				Name:    dayName,
				Slots:   slots,
				Summary: model.Summary{}, // TODO: Calculate summary for the day
				Left:    model.Left{},
			})
		}

		if !found {
			break // koniec, nie ma kolejnych tygodni
		}

		weeks = append(weeks, model.WeekGet{
			Num:  weekNum,
			Days: days,
		})
	}

	d.Weeks = weeks
	return &d, nil
}

func (s *ServiceDiets) Update(ctx context.Context, in *model.DietPut) (*model.DietGet, error) {
	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return nil, fmt.Errorf("begin tx: %w", err)
	}
	defer tx.Rollback()

	// 1. Update basic diet info
	const qUpdate = `
		UPDATE diets SET name = $1, descr = $2
		WHERE id = $3;
	`
	_, err = tx.ExecContext(ctx, qUpdate, in.Name, in.Descr, in.ID)
	if err != nil {
		return nil, fmt.Errorf("update diet: %w", err)
	}

	// 2. Replace labels
	_, err = tx.ExecContext(ctx, `DELETE FROM diet_label_bridge WHERE diet_id = $1`, in.ID)
	if err != nil {
		return nil, fmt.Errorf("clear labels: %w", err)
	}

	if len(in.Labels) > 0 {
		const qLabel = `
			INSERT INTO diet_label_bridge (diet_id, label_id)
			SELECT $1, id FROM diet_labels
			WHERE label = $2 AND color = $3;
		`
		stmt, err := tx.PrepareContext(ctx, qLabel)
		if err != nil {
			return nil, fmt.Errorf("prepare label insert: %w", err)
		}
		defer stmt.Close()
		for _, lbl := range in.Labels {
			_, err := stmt.ExecContext(ctx, in.ID, lbl.Label, lbl.Color)
			if err != nil {
				return nil, fmt.Errorf("insert label: %w", err)
			}
		}
	}

	// 3. Update slots (delete → insert empty → fill with dish IDs)
	_, err = tx.ExecContext(ctx, `DELETE FROM diet_slots WHERE diet_id = $1`, in.ID)
	if err != nil {
		return nil, fmt.Errorf("delete old slots: %w", err)
	}

	weekCount := len(in.Weeks)
	const mealsPerDay = 5
	const daysPerWeek = 6
	slotsPerWeek := mealsPerDay * daysPerWeek
	totalSlots := weekCount * slotsPerWeek
	const qEmptySlot = `
		INSERT INTO diet_slots (diet_id, slot_num, dish_id)
		VALUES ($1, $2, NULL);
	`
	stmtSlot, err := tx.PrepareContext(ctx, qEmptySlot)
	if err != nil {
		return nil, fmt.Errorf("prepare slot insert: %w", err)
	}
	defer stmtSlot.Close()
	for i := 1; i <= totalSlots; i++ {
		_, err := stmtSlot.ExecContext(ctx, in.ID, i)
		if err != nil {
			return nil, fmt.Errorf("insert empty slot #%d: %w", i, err)
		}
	}

	const qUpdateSlot = `
		UPDATE diet_slots SET dish_id = $1
		WHERE diet_id = $2 AND slot_num = $3;
	`
	stmtUpdate, err := tx.PrepareContext(ctx, qUpdateSlot)
	if err != nil {
		return nil, fmt.Errorf("prepare slot update: %w", err)
	}
	defer stmtUpdate.Close()

	mealIndex := map[string]int{
		"Breakfast":    0,
		"Lunch":        1,
		"Pre-Workout":  2,
		"Post-Workout": 3,
		"Supper":       4,
	}
	days := []string{"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
	dayIndex := map[string]int{}
	for i, d := range days {
		dayIndex[d] = i
	}

	for _, week := range in.Weeks {
		for _, day := range week.Days {
			di, ok := dayIndex[day.Name]
			if !ok {
				return nil, fmt.Errorf("invalid day: %s", day.Name)
			}
			for _, slot := range day.Slots {
				mi, ok := mealIndex[slot.Meal]
				if !ok {
					return nil, fmt.Errorf("invalid meal: %s", slot.Meal)
				}
				slotNum := (week.Num-1)*slotsPerWeek + di*mealsPerDay + mi + 1
				_, err := stmtUpdate.ExecContext(ctx, slot.Dish.ID, in.ID, slotNum)
				if err != nil {
					return nil, fmt.Errorf("update slot %d: %w", slotNum, err)
				}
			}
		}
	}

	if err := tx.Commit(); err != nil {
		return nil, fmt.Errorf("commit: %w", err)
	}

	return s.GetByID(ctx, in.ID)
}

func (s *ServiceDiets) Delete(ctx context.Context, id int) error {
	// 1. Check if active
	const qCheck = `
		SELECT 1 FROM diet_contexts
		WHERE active_diet = $1;
	`
	var exists int
	err := s.db.QueryRowContext(ctx, qCheck, id).Scan(&exists)
	if err == nil {
		return fmt.Errorf("diet is active and cannot be deleted")
	}
	if err != sql.ErrNoRows {
		return fmt.Errorf("check active diet: %w", err)
	}

	// 2. Delete diet
	const qDelete = `
		DELETE FROM diets WHERE id = $1;
	`
	_, err = s.db.ExecContext(ctx, qDelete, id)
	if err != nil {
		return fmt.Errorf("delete diet: %w", err)
	}

	return nil
}
