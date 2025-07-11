/**
 * Auto‑generated TypeScript interfaces for Dietonez API v1.0.0 (2025‑07‑07).
 * Paste this file into `types.ts` and keep it in sync with backend schemas.
 */

/* ──────────────────────────────
 * Basic Enumerations
 * ────────────────────────────*/

export type Meal = 'Breakfast' | 'MainMeal' | 'PreWorkout' | 'Supper';

/* ──────────────────────────────
 * Label
 * ────────────────────────────*/

export interface Label {
  label: string;
  /** Hex color, e.g. "#4caf50". */
  color: string;
}

/* ──────────────────────────────
 * Ingredient Models
 * ────────────────────────────*/

export enum Unit {
  Gram = 'g',
  Portion = 'porcja',
  Piece = 'sztuka',
  Slice = 'kromka',
  Teaspoon = 'łyżeczka',
  Tablespoon = 'łyżka',
  Package = 'opakowanie',
  Pinch = 'szczypta',
}

export enum ShopStyle {
  Lidl = 'Lidl',
  Fresh = 'Świeże',
  Pantry = 'Zapasy',
}

export interface IngredientGetPut {
  id: number;
  name: string;
  kcal:  | null;
  protein: number | null;
  fat: number | null;
  carbs: number | null;
  unit: Unit;
  shopStyle: ShopStyle;
  default_amount?: number;
  labels?: Label[];
}

export interface IngredientMin {
  id: number;
  name: string;
}

export type IngredientPost = Omit<IngredientGetPut, 'id'>;

/* ──────────────────────────────
 * Dish‑related Models
 * ────────────────────────────*/

export interface DishGetShort {
  id: number;
  name: string;
  kcal: number;
  protein: number;
  fat: number;
  carbs: number;
  labels?: Label[];
}

export interface IngredientInDishGet {
  ingredient: IngredientGetPut;
  amount: number; // in unit of ingredient (g, ml, etc.)
}

export interface IngredientInDishPut {
  ingredient: IngredientMin;
  amount: number;
}

export interface Recipe {
  total_time: string;
  before: string;
  when_to_start: string;
  preparation: string;
}

export interface DishGet {
  id: number;
  name: string;
  meal: Meal;
  kcal: number;
  protein: number;
  fat: number;
  carbs: number;
  ingredients: IngredientInDishGet[];
  recipe: Recipe;
  labels?: Label[];
}

export interface DishPost {
  name: string;
  meal: Meal;
  ingredients: IngredientInDishPut[];
  recipe: Recipe;
  labels?: Label[];
}

export interface DishPut extends DishPost {
  id: number;
}

export interface DishMinPut {
  id: number;
}

/* ──────────────────────────────
 * Diet‑related Models
 * ────────────────────────────*/

export interface DietMin {
  id: number;
  name: string;
}

export interface DietShort extends DietMin {
  descr: string;
  labels?: Label[];
}

export interface SlotGet {
  meal: Meal;
  dish: DishGetShort;
}

export interface SlotPut {
  meal: Meal;
  dish: DishMinPut;
}

export interface Summary {
  goal: number;
  kcal: number;
  proteins: number;
  fats: number;
  carbs: number;
}

export interface Left {
  kcal: number;
  proteins: number;
  fats: number;
}

export interface DayGet {
  name: string;
  slots: SlotGet[];
  summary: Summary;
  left: Left;
}

export interface DayPut {
  name: string;
  slots: SlotPut[];
}

export interface WeekGet {
  num: number;
  days: DayGet[];
}

export interface WeekPut {
  num: number;
  days: DayPut[];
}

export interface DietGet {
  id: number;
  name: string;
  descr: string;
  weeks: WeekGet[];
  labels?: Label[];
}

export interface DietPost {
  name: string;
  descr: string;
  weeks: WeekPut[];
  labels?: Label[];
}

export interface DietPut extends DietPost {
  id: number;
}

export interface DietContext {
  activeDiet: DietMin;
  currentWeek: number;
  currentDay: number;
  weight: number;
}

/* ──────────────────────────────
 * Nutrition Tools
 * ────────────────────────────*/

export interface NutritionSummary {
  kcal: number;
  proteins: number;
  fats: number;
  carbs: number;
}

export interface DaySummaryRequest {
  dishes: DishMinPut[];
  goal: number;
}

export interface DaySummaryResponse {
  summary: Summary;
  left: Left;
}

/* ──────────────────────────────
 * Utility Types
 * ────────────────────────────*/

/** Paginated response wrapper for GET /ingredients */
export interface PaginatedIngredients {
  total: number;
  ingredients: IngredientGetPut[];
}

/** Generic ID wrapper used by some bulk endpoints. */
export interface BulkResponse {
  created?: number;
  updated?: number;
}