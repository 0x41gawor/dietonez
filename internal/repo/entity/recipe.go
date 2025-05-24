package entity

type Recipe struct {
	Id           int64
	Name         string
	LabelId      int64
	CategoryId   int64
	Instructions string
	Protein      float32
	Fat          float32
	Carbs        float32
	Kcal         float32
}
