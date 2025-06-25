package repo

import "database/sql"

type RepositoryIngredientShopStyle struct {
	db        *sql.DB
	tableName string
}

func NewRepositoryIngredientShopStyle(db *sql.DB) *RepositoryIngredientShopStyle {
	return &RepositoryIngredientShopStyle{
		db:        db,
		tableName: "ingredient_shop_styles",
	}
}

func (r *RepositoryIngredientShopStyle) ReadNameById(id int64) (string, error) {
	query := "SELECT name FROM " + r.tableName + " WHERE id = $1"

	var name string
	err := r.db.QueryRow(query, id).Scan(&name)
	if err != nil {
		return "", err
	}

	return name, nil
}
