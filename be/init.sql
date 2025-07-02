-- Drop all tables (najpierw te zależne)
DROP TABLE IF EXISTS diet_contexts;
DROP TABLE IF EXISTS day_kcals;
DROP TABLE IF EXISTS diet_slots;
DROP TABLE IF EXISTS diet_label_bridge;
DROP TABLE IF EXISTS diet_labels;
DROP TABLE IF EXISTS diets;
DROP TABLE IF EXISTS recipes;
DROP TABLE IF EXISTS dish_label_bridge;
DROP TABLE IF EXISTS dish_labels;
DROP TABLE IF EXISTS ingredient_amounts;
DROP TABLE IF EXISTS dishes;
DROP TABLE IF EXISTS ingredient_label_bridge;
DROP TABLE IF EXISTS ingredient_labels;
DROP TABLE IF EXISTS ingredients;

-- Drop types
DROP TYPE IF EXISTS unit;
DROP TYPE IF EXISTS shop_style;
DROP TYPE IF EXISTS meal;

-- ENUM types (nowe definicje)
CREATE TYPE unit AS ENUM ('g', 'porcja', 'sztuka', 'kromka', 'łyżeczka', 'łyżka', 'opakowanie', 'szczypta');
CREATE TYPE shop_style AS ENUM ('Lidl', 'G.S', 'Świeże', 'Zapasy');
CREATE TYPE meal AS ENUM ('Breakfast', 'MainMeal', 'Pre-Workout', 'Supper');

-- ingredients
CREATE TABLE ingredients (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    unit unit NOT NULL,
    default_amount FLOAT NOT NULL,
    shop_style shop_style NOT NULL,
    kcal FLOAT,
    proteins FLOAT,
    fats FLOAT,
    carbs FLOAT
);

-- ingredient_labels
CREATE TABLE ingredient_labels (
    id SERIAL PRIMARY KEY,
    label TEXT NOT NULL,
    color TEXT NOT NULL
);

-- ingredient_label_bridge
CREATE TABLE ingredient_label_bridge (
    ingredient_id INT REFERENCES ingredients(id) ON DELETE CASCADE,
    label_id INT REFERENCES ingredient_labels(id) ON DELETE CASCADE,
    PRIMARY KEY (ingredient_id, label_id)
);

-- dishes
CREATE TABLE dishes (
    id SERIAL PRIMARY KEY,
    meal meal NOT NULL,
    name TEXT NOT NULL,
    descr TEXT
);

-- ingredient_amounts
CREATE TABLE ingredient_amounts (
    dish_id INT NOT NULL,
   ingredient_id INT NOT NULL,
    amount FLOAT NOT NULL,
    PRIMARY KEY (dish_id, ingredient_id),
    FOREIGN KEY (dish_id) REFERENCES dishes(id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(id) ON DELETE CASCADE
);

-- dish_labels
CREATE TABLE dish_labels (
    id SERIAL PRIMARY KEY,
    label TEXT NOT NULL,
    color TEXT NOT NULL
);

-- dish_label_bridges
CREATE TABLE dish_label_bridge (
    dish_id INT REFERENCES dishes(id) ON DELETE CASCADE,
    label_id INT REFERENCES dish_labels(id) ON DELETE CASCADE,
    PRIMARY KEY (dish_id, label_id)
);

-- recipes
CREATE TABLE recipes (
    dish_id INT PRIMARY KEY REFERENCES dishes(id) ON DELETE CASCADE,
    time_total TEXT,
    what_before TEXT,
    preparation TEXT,
    when_start TEXT
);

-- diets
CREATE TABLE diets (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    descr TEXT
);

-- diet_labels
CREATE TABLE diet_labels (
    id SERIAL PRIMARY KEY,
    label TEXT NOT NULL,
    color TEXT NOT NULL
);

-- diet_label_bridges
CREATE TABLE diet_label_bridge (
    diet_id INT REFERENCES diets(id) ON DELETE CASCADE,
    label_id INT REFERENCES diet_labels(id) ON DELETE CASCADE,
    PRIMARY KEY (diet_id, label_id)
);

-- diet_slots
CREATE TABLE diet_slots (
    diet_id INT NOT NULL,
    slot_num INT NOT NULL,
    dish_id INT REFERENCES dishes(id),
    PRIMARY KEY (diet_id, slot_num),
    FOREIGN KEY (diet_id) REFERENCES diets(id) ON DELETE CASCADE
);

-- day_kcals
CREATE TABLE day_kcals (
    diet_id INT REFERENCES diets(id) ON DELETE CASCADE,
    day_num INT NOT NULL,
    kcal INT NOT NULL,
    PRIMARY KEY (diet_id, day_num)
);

-- diet_contexts
CREATE TABLE diet_contexts (
    active_diet INT REFERENCES diets(id),
    current_week INT,
    current_weekday INT,
    current_weight FLOAT
);