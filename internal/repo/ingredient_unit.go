package repo

import (
	"database/sql"

	"github.com/0x41gawor/dietonez/internal/repo/entity"
)

type RepositoryIngredientUnit struct {
	db        *sql.DB
	tableName string
}

func NewRepositoryIngredientUnit(db *sql.DB) *RepositoryIngredientUnit {
	return &RepositoryIngredientUnit{
		db:        db,
		tableName: "ingredient_units",
	}
}

func (r *RepositoryIngredientUnit) ReadAll() ([]*entity.IngredientUnit, error) {
	query := "SELECT id, name FROM " + r.tableName

	rows, err := r.db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var units []*entity.IngredientUnit
	for rows.Next() {
		var unit entity.IngredientUnit
		if err := rows.Scan(&unit.Id, &unit.Name); err != nil {
			return nil, err
		}
		units = append(units, &unit)
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	return units, nil
}

func (r *RepositoryIngredientUnit) ReadNameById(id int64) (string, error) {
	query := "SELECT name FROM " + r.tableName + " WHERE id = $1"

	var name string
	err := r.db.QueryRow(query, id).Scan(&name)
	if err != nil {
		return "", err
	}

	return name, nil
}
