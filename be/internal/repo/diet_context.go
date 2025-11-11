package repo

import "github.com/0x41gawor/dietonez/internal/service/model"

type RepositoryDietContext struct {
	db *PostgresDB
}

func NewRepositoryDietContext() *RepositoryDietContext {
	db := GetDatabaseInstance()
	return &RepositoryDietContext{db: db}
}

func (r *RepositoryDietContext) Get() (*model.DietContext, error) {
	const q = `
	SELECT
		active_diet,
		start_date,
		current_weight
	FROM diet_context
	LIMIT 1
	`
	var dc model.DietContext
	err := r.db.DB.QueryRow(q).Scan(&dc.ActiveDietID, &dc.StartDate, &dc.CurrentWeight)
	if err != nil {
		return nil, err
	}
	return &dc, nil
}
