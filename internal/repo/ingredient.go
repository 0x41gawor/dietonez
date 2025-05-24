package repo

import (
	"database/sql"
	"fmt"

	"github.com/0x41gawor/dietonez/internal/repo/entity"
)

type RepositoryIngredient struct {
	db        *sql.DB
	tableName string
}

func NewRepositoryIngredients(db *sql.DB) *RepositoryIngredient {
	return &RepositoryIngredient{
		db:        db,
		tableName: "ingredients",
	}
}

func (r *RepositoryIngredient) Create(e *entity.Ingredient) (int64, error) {
	query := fmt.Sprintf("INSERT INTO %s (name, default_amount, unit_id, shop_style_id) VALUES ($1, $2, $3, $4) RETURNING id", r.tableName)
	var id int64
	err := r.db.QueryRow(query, e.Name, e.DefaultAmount, e.UnitId, e.ShopStyleId).Scan(&id)
	return id, err
}

func (r *RepositoryIngredient) Read(id int64) (*entity.Ingredient, error) {
	query := fmt.Sprintf("SELECT id, name, default_amount, unit_id, shop_style_id FROM %s WHERE id = $1", r.tableName)

	var ing entity.Ingredient
	err := r.db.QueryRow(query, id).Scan(&ing.Id, &ing.Name, &ing.DefaultAmount, &ing.UnitId, &ing.ShopStyleId)
	if err != nil {
		return nil, err
	}

	return &ing, nil
}

func (r *RepositoryIngredient) FindAllIds() ([]int64, error) {
	query := fmt.Sprintf("SELECT id FROM %s", r.tableName)

	rows, err := r.db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var ids []int64
	for rows.Next() {
		var id int64
		if err := rows.Scan(&id); err != nil {
			return nil, err
		}
		ids = append(ids, id)
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	return ids, nil
}
