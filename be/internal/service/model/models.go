package model

import "time"

type Label struct {
	Label string `json:"label"`
	Color string `json:"color"`
}

type IngredientMin struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

type IngredientMinUnit struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
	Unit string `json:"unit"`
}

type IngredientIdNameUnit struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
	Unit string `json:"unit"`
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
	Path          int     `json:"path"`
}

type IngredientExport struct {
	Name string `json:"name"`
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

type IngredientInDishExport struct {
	Name   string `json:"name"`
	Amount string `json:"amount"`
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

type DishExport struct {
	Name        string                   `json:"name"`
	Ingredients []IngredientInDishExport `json:"ingredients"`
}

type DishInMenu struct {
	Dish    *DishGet `json:"dish"`
	SlotNum int      `json:"slot_num"`
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
	Meal string        `json:"meal"`
	Dish *DishGetShort `json:"dish"`
}

type SlotExport struct {
	Meal string      `json:"meal"`
	Dish *DishExport `json:"dish"`
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

type DayExport struct {
	Name  string       `json:"name"`
	Slots []SlotExport `json:"slots"`
}

type DayPut struct {
	Name  string    `json:"name"`
	Slots []SlotPut `json:"slots"`
	Goal  float64   `json:"goal"`
}

type WeekSummary struct {
	AvgKcal float64 `json:"avgKcal"`
	AvgProt float64 `json:"avgProt"`
	AvgFat  float64 `json:"avgFat"`
}

type WeekGet struct {
	Num     int         `json:"num"`
	Days    []DayGet    `json:"days"`
	Summary WeekSummary `json:"summary"`
}

type WeekExport struct {
	Num  int         `json:"num"`
	Days []DayExport `json:"days"`
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

type DietExport struct {
	Weeks []WeekExport `json:"weeks"`
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

type DietContextGet struct {
	ActiveDiet  DietMin   `json:"activeDiet"`
	StartDate   time.Time `json:"startDate"`
	CurrentWeek int       `json:"currentWeek"`
	CurrentDay  int       `json:"currentDay"`
	Weight      float64   `json:"weight"`
}

type DietContextPut struct {
	ActiveDiet DietMin   `json:"activeDiet"`
	StartDate  time.Time `json:"startDate"`
	Weight     float64   `json:"weight"`
}

type DishNamePatch struct {
	Name string `json:"name"`
}

type DietSlotPut struct {
	SlotNum int `json:"slot_num"`
	DishId  int `json:"dish_id"`
}

type DietContext struct {
	ActiveDietID  int
	StartDate     time.Time
	CurrentWeight float64
}

type UpdateIngredientStockRequest struct {
	IsPresent bool `json:"is_present"`
}
