package repo

import "fmt"

type RepositoryDayKcals struct {
	db *PostgresDB
}

func NewRepositoryDayKcals() *RepositoryDayKcals {
	db := GetDatabaseInstance()
	return &RepositoryDayKcals{db: db}
}

func (r *RepositoryDayKcals) GetKcalByDietIdAndDayNum(dietID int, dayNum int) (float64, error) {
	// fetch kcal goal
	var dayKcalGoal float64
	err := r.db.DB.QueryRow(`
		SELECT kcal
		FROM day_kcals
		WHERE day_num = $1 AND diet_id = $2
	`, dayNum, dietID).Scan(&dayKcalGoal)
	if err != nil {
		return 0, fmt.Errorf("failed to fetch max dayGoal: %w", err)
	}
	return dayKcalGoal, nil
}
