-- Po połączeniu z bazą:
-- \c dietonez_db
DROP TABLE IF EXISTS recipe_ingredients;
DROP TABLE IF EXISTS recipes;
DROP TABLE IF EXISTS recipe_categories;
DROP TABLE IF EXISTS recipe_labels;
DROP TABLE IF EXISTS ingredients;
DROP TABLE IF EXISTS ingredient_shop_styles;
DROP TABLE IF EXISTS ingredient_units;

-- === Tabele bazowe ===

CREATE TABLE ingredient_shop_styles (
  id SMALLSERIAL PRIMARY KEY,
  name VARCHAR(32) NOT NULL UNIQUE
);

INSERT INTO ingredient_shop_styles (name) VALUES
  ('Lidl'),
  ('Świeże'),
  ('Zapasy');

CREATE TABLE ingredient_units (
  id SMALLSERIAL PRIMARY KEY,
  name VARCHAR(32) NOT NULL UNIQUE
);

INSERT INTO ingredient_units (name) VALUES
  ('g'),
  ('porcja'),
  ('sztuka'),
  ('kromka'),
  ('łyżeczka'),
  ('opakowanie');

CREATE TABLE ingredients (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  default_amount DECIMAL(10,2) NOT NULL,
  unit_id SMALLINT NOT NULL REFERENCES ingredient_units(id),
  shop_style_id SMALLINT NOT NULL REFERENCES ingredient_shop_styles(id)
);

INSERT INTO ingredients (name, default_amount, unit_id, shop_style_id) VALUES
  ('Płatki owsiane górskie', 100, 1, 1),
  ('Mleko 1.5% UHT', 200, 1, 1),
  ('Jaja kurze', 1, 3, 1),
  ('Maliny', 100, 1, 2),
  ('Papryka słodka', 1, 5, 3);

-- === Etykiety i kategorie ===

CREATE TABLE recipe_labels (
  id SMALLSERIAL PRIMARY KEY,
  name VARCHAR(32) NOT NULL UNIQUE
);

INSERT INTO recipe_labels (name) VALUES
  ('redu'),
  ('masa');

CREATE TABLE recipe_categories (
  id SMALLSERIAL PRIMARY KEY,
  name VARCHAR(32) NOT NULL UNIQUE
);

INSERT INTO recipe_categories (name) VALUES
  ('breakfast'),
  ('main_meal'),
  ('pre_workout'),
  ('supper');

-- === Przepisy i składniki przepisu ===

CREATE TABLE recipes (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  label_id SMALLINT REFERENCES recipe_labels(id),
  category_id SMALLINT NOT NULL REFERENCES recipe_categories(id),
  instructions TEXT NOT NULL,
  protein DECIMAL(6,2) NOT NULL,
  fat DECIMAL(6,2) NOT NULL,
  carbs DECIMAL(6,2) NOT NULL,
  kcal DECIMAL(6,2) NOT NULL
);

CREATE TABLE recipe_ingredients (
  recipe_id INTEGER NOT NULL REFERENCES recipes(id),
  ingredient_id INTEGER NOT NULL REFERENCES ingredients(id),
  amount DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (recipe_id, ingredient_id)
);