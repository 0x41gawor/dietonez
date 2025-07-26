package service

import (
	"context"
	"database/sql"
	"fmt"
	"time"

	"github.com/0x41gawor/dietonez/internal/repo"
	"github.com/0x41gawor/dietonez/internal/service/model"
)

type ServiceShoppingList struct {
	db *sql.DB
}

func NewServiceShoppingList() *ServiceShoppingList {
	db := repo.GetDatabaseInstance().DB
	return &ServiceShoppingList{db: db}
}

func (s *ServiceShoppingList) Get(ctx context.Context, date time.Time) (*model.ShoppingList, error) {

	//dodajmy offset do date w celu testów
	// TESTOWY OFFSET (np. +3 dni)
	date = date.AddDate(0, 0, 4)

	var activeDietID int
	var startDate time.Time

	err := s.db.QueryRowContext(ctx, `
		SELECT active_diet, start_date
		FROM diet_context
		LIMIT 1
	`).Scan(&activeDietID, &startDate)

	// Walidacja: startDate musi być poniedziałkiem
	if startDate.Weekday() != time.Monday {
		return nil, fmt.Errorf("invalid start_date: expected Monday, got %s", startDate.Weekday().String())
	}

	if err != nil {
		if err == sql.ErrNoRows {
			return nil, fmt.Errorf("no active diet set in context")
		}
		return nil, fmt.Errorf("failed to fetch active diet: %w", err)
	}

	print("Active Diet ID: ", activeDietID, "\n")
	print("Start Date: ", startDate.String(), "\n")
	print("Current Date: ", date.String(), "\n")

	var maxSlotNum int
	err = s.db.QueryRowContext(ctx, `
		SELECT MAX(slot_num)
		FROM diet_slots
		WHERE diet_id = $1
	`, activeDietID).Scan(&maxSlotNum)

	if err != nil {
		return nil, fmt.Errorf("failed to fetch max slot_num: %w", err)
	}

	print("Max slot_num: ", maxSlotNum, "\n")

	// Obliczenie różnicy dni (startDate → date) +1
	daysBetween := int(date.Sub(startDate).Hours()/24) + 1
	if daysBetween <= 0 {
		return nil, fmt.Errorf("current date is before start date")
	}
	print("Days between: ", daysBetween, "\n")

	// Dzień tygodnia
	weekday := date.Weekday()
	print("Weekday: ", weekday.String(), "\n")

	maxDietDay := maxSlotNum / 30 * 7
	currentDietDay := daysBetween % maxDietDay

	print("Current diet day num: ", currentDietDay, "\n")
	print("Max   diet  day  num: ", maxDietDay, "\n")

	freshSlotsRange := getFreshSlotsRange(currentDietDay, maxDietDay)
	fmt.Printf("Fresh slot range: %v\n", freshSlotsRange)

	return nil, nil
}

func getFreshSlotsRange(currentDietDay, maxDietDay int) []int {
	if currentDietDay <= 0 {
		return []int{}
	}

	// Specjalny przypadek: ostatni dzień całej diety
	if currentDietDay == maxDietDay {
		return []int{1, 2, 3, 4, 5}
	}

	posInWeek := (currentDietDay - 1) % 7

	// Sobota (6‑ty dzień licząc od poniedziałku = 0) → brak slotów
	if posInWeek == 5 {
		return []int{}
	}

	weekNum := (currentDietDay - 1) / 7

	// Offset w tygodniu z korektą na brak soboty
	var posOffset int
	if posInWeek < 5 { // pon–pt
		posOffset = posInWeek
	} else { // niedziela
		posOffset = 5
	}

	// Globalny indeks „slotowego” dnia
	index := weekNum*6 + posOffset

	start := 6 + index*5

	return []int{start, start + 1, start + 2, start + 3, start + 4}
}
