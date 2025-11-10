package repo

import "github.com/0x41gawor/dietonez/internal/service/model"

type RepositoryDishLabels struct {
	db *PostgresDB
}

func NewRepositoryDishLabels() *RepositoryDishLabels {
	db := GetDatabaseInstance()
	return &RepositoryDishLabels{db: db}
}

func (r *RepositoryDishLabels) GetByDishId(dishID int) ([]model.Label, error) {
	const q = `
	SELECT
		l.label,
		l.color
	FROM dish_label_bridge dl
	JOIN dish_labels l ON dl.label_id = l.id
	WHERE dl.dish_id = $1
	`
	rows, err := r.db.DB.Query(q, dishID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var labels []model.Label
	for rows.Next() {
		var label model.Label
		if err := rows.Scan(&label.Label, &label.Color); err != nil {
			return nil, err
		}
		labels = append(labels, label)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}

	return labels, nil
}
