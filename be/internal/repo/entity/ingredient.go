package entity

type Ingredient struct {
	Id            int64
	Name          string
	DefaultAmount float64
	UnitId        int64
	ShopStyleId   int64
}
