-- ENUM types
CREATE TYPE unit AS ENUM ('g', 'porcja', 'sztuka', 'kromka', 'łyżeczka', 'łyżka', 'opakowanie', 'szczypta');
CREATE TYPE shop_style AS ENUM ('Lidl', 'G.S', 'Świeże', 'Zapasy');
CREATE TYPE meal AS ENUM ('Breakfast', 'Main Meal', 'Pre-Workout', 'Post-Workout');

-- ingredient
CREATE TABLE ingredient (
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

-- ingredient_label
CREATE TABLE ingredient_label (
    id SERIAL PRIMARY KEY,
    label TEXT NOT NULL,
    color TEXT NOT NULL
);

-- ingredient_label_bridge
CREATE TABLE ingredient_label_bridge (
    ingredient_id INT REFERENCES ingredient(id) ON DELETE CASCADE,
    label_id INT REFERENCES ingredient_label(id) ON DELETE CASCADE,
    PRIMARY KEY (ingredient_id, label_id)
);

-- ingredient_amount
CREATE TABLE ingredient_amount (
    dish_id INT NOT NULL,
    ingredient_id INT NOT NULL,
    amount FLOAT NOT NULL,
    PRIMARY KEY (dish_id, ingredient_id),
    FOREIGN KEY (dish_id) REFERENCES dish(id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES ingredient(id) ON DELETE CASCADE
);

-- dish
CREATE TABLE dish (
    id SERIAL PRIMARY KEY,
    meal meal NOT NULL,
    name TEXT NOT NULL,
    descr TEXT
);

-- dish_label
CREATE TABLE dish_label (
    id SERIAL PRIMARY KEY,
    label TEXT NOT NULL,
    color TEXT NOT NULL
);

-- dish_label_bridge
CREATE TABLE dish_label_bridge (
    dish_id INT REFERENCES dish(id) ON DELETE CASCADE,
    label_id INT REFERENCES dish_label(id) ON DELETE CASCADE,
    PRIMARY KEY (dish_id, label_id)
);

-- recipe
CREATE TABLE recipe (
    dish_id INT PRIMARY KEY REFERENCES dish(id) ON DELETE CASCADE,
    time_total TEXT,
    what_before TEXT,
    preparation TEXT,
    when_start TEXT
);

-- diet
CREATE TABLE diet (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    descr TEXT
);

-- diet_label
CREATE TABLE diet_label (
    id SERIAL PRIMARY KEY,
    label TEXT NOT NULL,
    color TEXT NOT NULL
);

-- diet_label_bridge
CREATE TABLE diet_label_bridge (
    diet_id INT REFERENCES diet(id) ON DELETE CASCADE,
    label_id INT REFERENCES diet_label(id) ON DELETE CASCADE,
    PRIMARY KEY (diet_id, label_id)
);

-- diet_slot
CREATE TABLE diet_slot (
    diet_id INT NOT NULL,
    slot_num INT NOT NULL,
    dish_id INT REFERENCES dish(id),
    PRIMARY KEY (diet_id, slot_num),
    FOREIGN KEY (diet_id) REFERENCES diet(id) ON DELETE CASCADE
);

-- day_kcal
CREATE TABLE day_kcal (
    diet_id INT REFERENCES diet(id) ON DELETE CASCADE,
    day_num INT NOT NULL,
    kcal INT NOT NULL,
    PRIMARY KEY (diet_id, day_num)
);

-- diet_context
CREATE TABLE diet_context (
    activeDiet INT REFERENCES diet(id),
    currentWeek INT,
    currentWeekday INT,
    currentWeight FLOAT
);