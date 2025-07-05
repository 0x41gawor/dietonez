package model

type Label struct {
	Text  string `json:"text"`
	Color string `json:"color"`
}

type IngredientMin struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

type IngredientGetPut struct {
	ID            int     `json:"id"`
	Name          string  `json:"name"`
	Kcal          float64 `json:"kcal"`
	Protein       float64 `json:"protein"`
	Fat           float64 `json:"fat"`
	Carbs         float64 `json:"carbs"`
	Unit          string  `json:"unit"`
	ShopStyle     string  `json:"shopStyle"`
	DefaultAmount float64 `json:"default_amount"`
	Labels        []Label `json:"labels"`
}

type IngredientPost struct {
	Name          string  `json:"name"`
	Kcal          float64 `json:"kcal"`
	Protein       float64 `json:"protein"`
	Fat           float64 `json:"fat"`
	Carbs         float64 `json:"carbs"`
	Unit          string  `json:"unit"`
	ShopStyle     string  `json:"shopStyle"`
	DefaultAmount float64 `json:"default_amount"`
	Labels        []Label `json:"labels"`
}

type IngredientInDishGet struct {
	Ingredient IngredientGetPut `json:"ingredient"`
	Amount     float64          `json:"amount"`
}

type IngredientInDishPut struct {
	Ingredient IngredientMin `json:"ingredient"`
	Amount     float64       `json:"amount"`
}

type Recipe struct {
	TotalTime   string `json:"total_time"`
	Before      string `json:"before"`
	WhenToStart string `json:"when_to_start"`
	Preparation string `json:"preparation"`
}

type DishMin struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

type DishGetShort struct {
	ID      int     `json:"id"`
	Name    string  `json:"name"`
	Kcal    float64 `json:"kcal"`
	Protein float64 `json:"protein"`
	Fat     float64 `json:"fat"`
	Carbs   float64 `json:"carbs"`
	Labels  []Label `json:"labels"`
}

type DishGet struct {
	ID          int                   `json:"id"`
	Name        string                `json:"name"`
	Descr       string                `json:"descr"`
	Meal        string                `json:"meal"`
	Kcal        float64               `json:"kcal"`
	Protein     float64               `json:"protein"`
	Fat         float64               `json:"fat"`
	Carbs       float64               `json:"carbs"`
	Ingredients []IngredientInDishGet `json:"ingredients"`
	Recipe      Recipe                `json:"recipe"`
	Labels      []Label               `json:"labels"`
}

type DishPost struct {
	Name        string                `json:"name"`
	Meal        string                `json:"meal"`
	Descr       string                `json:"descr"`
	Ingredients []IngredientInDishPut `json:"ingredients"`
	Recipe      Recipe                `json:"recipe"`
	Labels      []Label               `json:"labels"`
}

type DishPut struct {
	ID          int                   `json:"id"`
	Name        string                `json:"name"`
	Descr       string                `json:"descr"`
	Meal        string                `json:"meal"`
	Ingredients []IngredientInDishPut `json:"ingredients"`
	Recipe      Recipe                `json:"recipe"`
	Labels      []Label               `json:"labels"`
}

type DishMinPut struct {
	ID int `json:"id"`
}

type SlotGet struct {
	Meal string       `json:"meal"`
	Dish DishGetShort `json:"dish"`
}

type SlotPut struct {
	Meal string     `json:"meal"`
	Dish DishMinPut `json:"dish"`
}

type Summary struct {
	Goal     float64 `json:"goal"`
	Kcal     float64 `json:"kcal"`
	Proteins float64 `json:"proteins"`
	Fats     float64 `json:"fats"`
	Carbs    float64 `json:"carbs"`
}

type Left struct {
	Kcal     float64 `json:"kcal"`
	Proteins float64 `json:"proteins"`
	Fats     float64 `json:"fats"`
}

type DayGet struct {
	Name    string    `json:"name"`
	Slots   []SlotGet `json:"slots"`
	Summary Summary   `json:"summary"`
	Left    Left      `json:"left"`
}

type DayPut struct {
	Name  string    `json:"name"`
	Slots []SlotPut `json:"slots"`
}

type WeekGet struct {
	Num  int      `json:"num"`
	Days []DayGet `json:"days"`
}

type WeekPut struct {
	Num  int      `json:"num"`
	Days []DayPut `json:"days"`
}

type DietMin struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

type DietShort struct {
	ID     int     `json:"id"`
	Name   string  `json:"name"`
	Descr  string  `json:"descr"`
	Labels []Label `json:"labels"`
}

type DietGet struct {
	ID     int       `json:"id"`
	Name   string    `json:"name"`
	Descr  string    `json:"descr"`
	Weeks  []WeekGet `json:"weeks"`
	Labels []Label   `json:"labels"`
}

type DietPost struct {
	Name   string    `json:"name"`
	Descr  string    `json:"descr"`
	Weeks  []WeekPut `json:"weeks"`
	Labels []Label   `json:"labels"`
}

type DietPut struct {
	ID     int       `json:"id"`
	Name   string    `json:"name"`
	Descr  string    `json:"descr"`
	Weeks  []WeekPut `json:"weeks"`
	Labels []Label   `json:"labels"`
}

type DietContext struct {
	ActiveDiet  DietMin `json:"activeDiet"`
	CurrentWeek int     `json:"currentWeek"`
	CurrentDay  int     `json:"currentDay"`
	Weight      float64 `json:"weight"`
}
