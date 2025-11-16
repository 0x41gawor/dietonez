--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13 (Debian 15.13-1.pgdg120+1)
-- Dumped by pg_dump version 15.13 (Debian 15.13-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: meal; Type: TYPE; Schema: public; Owner: kartezjusz
--

CREATE TYPE public.meal AS ENUM (
    'Breakfast',
    'MainMeal',
    'Pre-Workout',
    'Supper'
);


ALTER TYPE public.meal OWNER TO kartezjusz;

--
-- Name: meal_slot; Type: TYPE; Schema: public; Owner: kartezjusz
--

CREATE TYPE public.meal_slot AS ENUM (
    'Breakfast',
    'Lunch',
    'Pre-Workout',
    'Post-Workout',
    'Supper'
);


ALTER TYPE public.meal_slot OWNER TO kartezjusz;

--
-- Name: shop_style; Type: TYPE; Schema: public; Owner: kartezjusz
--

CREATE TYPE public.shop_style AS ENUM (
    'Lidl',
    'G.S',
    'Świeże',
    'Zapasy',
    'Na żywo'
);


ALTER TYPE public.shop_style OWNER TO kartezjusz;

--
-- Name: unit; Type: TYPE; Schema: public; Owner: kartezjusz
--

CREATE TYPE public.unit AS ENUM (
    'g',
    'porcja',
    'sztuka',
    'kromka',
    'łyżeczka',
    'łyżka',
    'opakowanie',
    'szczypta'
);


ALTER TYPE public.unit OWNER TO kartezjusz;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: counter; Type: TABLE; Schema: public; Owner: kartezjusz
--

CREATE TABLE public.counter (
    day date NOT NULL,
    ingredient_id bigint NOT NULL,
    meal public.meal_slot NOT NULL,
    amount double precision NOT NULL
);


ALTER TABLE public.counter OWNER TO kartezjusz;

--
-- Name: day_kcals; Type: TABLE; Schema: public; Owner: kartezjusz
--

CREATE TABLE public.day_kcals (
    diet_id integer NOT NULL,
    day_num integer NOT NULL,
    kcal integer NOT NULL
);


ALTER TABLE public.day_kcals OWNER TO kartezjusz;

--
-- Name: diet_context; Type: TABLE; Schema: public; Owner: kartezjusz
--

CREATE TABLE public.diet_context (
    active_diet integer,
    start_date date,
    current_weight double precision
);


ALTER TABLE public.diet_context OWNER TO kartezjusz;

--
-- Name: diet_label_bridge; Type: TABLE; Schema: public; Owner: kartezjusz
--

CREATE TABLE public.diet_label_bridge (
    diet_id integer NOT NULL,
    label_id integer NOT NULL
);


ALTER TABLE public.diet_label_bridge OWNER TO kartezjusz;

--
-- Name: diet_labels; Type: TABLE; Schema: public; Owner: kartezjusz
--

CREATE TABLE public.diet_labels (
    id integer NOT NULL,
    label text NOT NULL,
    color text NOT NULL
);


ALTER TABLE public.diet_labels OWNER TO kartezjusz;

--
-- Name: diet_labels_id_seq; Type: SEQUENCE; Schema: public; Owner: kartezjusz
--

CREATE SEQUENCE public.diet_labels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.diet_labels_id_seq OWNER TO kartezjusz;

--
-- Name: diet_labels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kartezjusz
--

ALTER SEQUENCE public.diet_labels_id_seq OWNED BY public.diet_labels.id;


--
-- Name: diet_slots; Type: TABLE; Schema: public; Owner: kartezjusz
--

CREATE TABLE public.diet_slots (
    diet_id integer NOT NULL,
    slot_num integer NOT NULL,
    dish_id integer
);


ALTER TABLE public.diet_slots OWNER TO kartezjusz;

--
-- Name: diets; Type: TABLE; Schema: public; Owner: kartezjusz
--

CREATE TABLE public.diets (
    id integer NOT NULL,
    name text NOT NULL,
    descr text
);


ALTER TABLE public.diets OWNER TO kartezjusz;

--
-- Name: diets_id_seq; Type: SEQUENCE; Schema: public; Owner: kartezjusz
--

CREATE SEQUENCE public.diets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.diets_id_seq OWNER TO kartezjusz;

--
-- Name: diets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kartezjusz
--

ALTER SEQUENCE public.diets_id_seq OWNED BY public.diets.id;


--
-- Name: dish_label_bridge; Type: TABLE; Schema: public; Owner: kartezjusz
--

CREATE TABLE public.dish_label_bridge (
    dish_id integer NOT NULL,
    label_id integer NOT NULL
);


ALTER TABLE public.dish_label_bridge OWNER TO kartezjusz;

--
-- Name: dish_labels; Type: TABLE; Schema: public; Owner: kartezjusz
--

CREATE TABLE public.dish_labels (
    id integer NOT NULL,
    label text NOT NULL,
    color text NOT NULL
);


ALTER TABLE public.dish_labels OWNER TO kartezjusz;

--
-- Name: dish_labels_id_seq; Type: SEQUENCE; Schema: public; Owner: kartezjusz
--

CREATE SEQUENCE public.dish_labels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dish_labels_id_seq OWNER TO kartezjusz;

--
-- Name: dish_labels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kartezjusz
--

ALTER SEQUENCE public.dish_labels_id_seq OWNED BY public.dish_labels.id;


--
-- Name: dishes; Type: TABLE; Schema: public; Owner: kartezjusz
--

CREATE TABLE public.dishes (
    id integer NOT NULL,
    meal public.meal NOT NULL,
    name text NOT NULL,
    descr text
);


ALTER TABLE public.dishes OWNER TO kartezjusz;

--
-- Name: dishes_id_seq; Type: SEQUENCE; Schema: public; Owner: kartezjusz
--

CREATE SEQUENCE public.dishes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dishes_id_seq OWNER TO kartezjusz;

--
-- Name: dishes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kartezjusz
--

ALTER SEQUENCE public.dishes_id_seq OWNED BY public.dishes.id;


--
-- Name: ingredient_amounts; Type: TABLE; Schema: public; Owner: kartezjusz
--

CREATE TABLE public.ingredient_amounts (
    dish_id integer NOT NULL,
    ingredient_id integer NOT NULL,
    amount double precision NOT NULL
);


ALTER TABLE public.ingredient_amounts OWNER TO kartezjusz;

--
-- Name: ingredient_label_bridge; Type: TABLE; Schema: public; Owner: kartezjusz
--

CREATE TABLE public.ingredient_label_bridge (
    ingredient_id integer NOT NULL,
    label_id integer NOT NULL
);


ALTER TABLE public.ingredient_label_bridge OWNER TO kartezjusz;

--
-- Name: ingredient_labels; Type: TABLE; Schema: public; Owner: kartezjusz
--

CREATE TABLE public.ingredient_labels (
    id integer NOT NULL,
    label text NOT NULL,
    color text NOT NULL
);


ALTER TABLE public.ingredient_labels OWNER TO kartezjusz;

--
-- Name: ingredient_labels_id_seq; Type: SEQUENCE; Schema: public; Owner: kartezjusz
--

CREATE SEQUENCE public.ingredient_labels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ingredient_labels_id_seq OWNER TO kartezjusz;

--
-- Name: ingredient_labels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kartezjusz
--

ALTER SEQUENCE public.ingredient_labels_id_seq OWNED BY public.ingredient_labels.id;


--
-- Name: ingredients; Type: TABLE; Schema: public; Owner: kartezjusz
--

CREATE TABLE public.ingredients (
    id integer NOT NULL,
    name text NOT NULL,
    unit public.unit NOT NULL,
    default_amount double precision NOT NULL,
    shop_style public.shop_style NOT NULL,
    kcal double precision,
    proteins double precision,
    fats double precision,
    carbs double precision,
    path numeric DEFAULT 2000 NOT NULL
);


ALTER TABLE public.ingredients OWNER TO kartezjusz;

--
-- Name: ingredients_id_seq; Type: SEQUENCE; Schema: public; Owner: kartezjusz
--

CREATE SEQUENCE public.ingredients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ingredients_id_seq OWNER TO kartezjusz;

--
-- Name: ingredients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kartezjusz
--

ALTER SEQUENCE public.ingredients_id_seq OWNED BY public.ingredients.id;


--
-- Name: recipes; Type: TABLE; Schema: public; Owner: kartezjusz
--

CREATE TABLE public.recipes (
    dish_id integer NOT NULL,
    time_total text,
    what_before text,
    preparation text,
    when_start text
);


ALTER TABLE public.recipes OWNER TO kartezjusz;

--
-- Name: diet_labels id; Type: DEFAULT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.diet_labels ALTER COLUMN id SET DEFAULT nextval('public.diet_labels_id_seq'::regclass);


--
-- Name: diets id; Type: DEFAULT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.diets ALTER COLUMN id SET DEFAULT nextval('public.diets_id_seq'::regclass);


--
-- Name: dish_labels id; Type: DEFAULT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.dish_labels ALTER COLUMN id SET DEFAULT nextval('public.dish_labels_id_seq'::regclass);


--
-- Name: dishes id; Type: DEFAULT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.dishes ALTER COLUMN id SET DEFAULT nextval('public.dishes_id_seq'::regclass);


--
-- Name: ingredient_labels id; Type: DEFAULT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.ingredient_labels ALTER COLUMN id SET DEFAULT nextval('public.ingredient_labels_id_seq'::regclass);


--
-- Name: ingredients id; Type: DEFAULT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.ingredients ALTER COLUMN id SET DEFAULT nextval('public.ingredients_id_seq'::regclass);


--
-- Data for Name: counter; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.counter (day, ingredient_id, meal, amount) FROM stdin;
2025-11-09	26	Breakfast	100
2025-11-07	42	Lunch	150
2025-11-07	4	Lunch	1
2025-11-07	52	Lunch	8
2025-11-07	62	Lunch	40
2025-11-07	73	Lunch	40
2025-11-07	25	Lunch	10
2025-11-07	56	Lunch	10
2025-11-09	187	Breakfast	100
2025-11-07	129	Lunch	15
2025-11-07	69	Lunch	10
2025-11-07	55	Lunch	10
2025-11-11	4	Breakfast	4
2025-11-11	149	Breakfast	1
2025-11-07	1	Pre-Workout	300
2025-11-11	27	Breakfast	100
2025-11-11	148	Breakfast	50
2025-11-11	96	Lunch	100
2025-11-11	94	Lunch	150
2025-11-11	91	Lunch	150
2025-11-11	162	Lunch	50
2025-11-11	88	Lunch	10
2025-11-11	30	Lunch	50
2025-11-11	97	Lunch	1
2025-11-11	62	Lunch	30
2025-11-11	71	Lunch	1
2025-11-11	72	Lunch	1
2025-11-11	1	Pre-Workout	300
2025-11-11	26	Pre-Workout	80
2025-11-11	25	Pre-Workout	40
2025-11-11	16	Pre-Workout	20
2025-11-11	43	Post-Workout	200
2025-11-11	51	Post-Workout	200
2025-11-11	18	Post-Workout	100
2025-11-11	73	Post-Workout	50
2025-11-11	19	Post-Workout	50
2025-11-11	126	Post-Workout	50
2025-11-11	52	Post-Workout	5
2025-11-11	55	Post-Workout	20
2025-11-11	71	Post-Workout	1
2025-11-11	72	Post-Workout	1
2025-11-11	107	Supper	150
2025-11-07	26	Pre-Workout	160
2025-11-07	15	Pre-Workout	10
2025-11-12	26	Pre-Workout	80
2025-11-12	25	Pre-Workout	40
2025-11-12	44	Post-Workout	100
2025-11-12	42	Post-Workout	150
2025-11-12	22	Post-Workout	75
2025-11-07	127	Lunch	20
2025-11-09	23	Breakfast	100
2025-11-08	83	Lunch	250
2025-11-10	3	Breakfast	138
2025-11-10	27	Breakfast	100
2025-11-10	2	Breakfast	100
2025-11-10	14	Breakfast	100
2025-11-10	102	Breakfast	50
2025-11-10	16	Breakfast	18
2025-11-13	4	Breakfast	4
2025-11-13	149	Breakfast	1
2025-11-13	148	Breakfast	100
2025-11-13	27	Breakfast	100
2025-11-13	12	Breakfast	15
2025-11-13	44	Lunch	100
2025-11-13	42	Lunch	150
2025-11-08	8	Breakfast	2
2025-11-13	22	Lunch	75
2025-11-13	46	Lunch	100
2025-11-13	70	Lunch	20
2025-11-13	52	Lunch	8
2025-11-13	67	Lunch	1
2025-11-13	68	Lunch	10
2025-11-08	23	Breakfast	200
2025-11-13	69	Lunch	10
2025-11-13	1	Pre-Workout	300
2025-11-13	26	Pre-Workout	110
2025-11-08	56	Lunch	10
2025-11-08	102	Supper	40
2025-11-09	8	Breakfast	2
2025-11-13	14	Pre-Workout	150
2025-11-19	5	Breakfast	5
2025-11-13	11	Pre-Workout	10
2025-11-13	44	Post-Workout	100
2025-11-13	42	Post-Workout	150
2025-11-05	91	Breakfast	140
2025-11-12	46	Post-Workout	100
2025-11-05	183	Breakfast	42
2025-11-13	38	Post-Workout	100
2025-11-13	62	Post-Workout	60
2025-11-05	9	Breakfast	41
2025-11-05	184	Breakfast	20
2025-11-05	24	Pre-Workout	120
2025-11-05	16	Pre-Workout	10
2025-11-13	60	Post-Workout	20
2025-11-09	85	Lunch	150
2025-11-09	47	Lunch	150
2025-11-09	52	Lunch	8
2025-11-09	28	Lunch	30
2025-11-09	73	Lunch	30
2025-11-09	54	Lunch	10
2025-11-09	55	Lunch	10
2025-11-09	71	Lunch	1
2025-11-09	72	Lunch	1
2025-11-09	1	Pre-Workout	300
2025-11-09	26	Pre-Workout	110
2025-11-09	14	Pre-Workout	150
2025-11-09	11	Pre-Workout	10
2025-11-09	87	Post-Workout	100
2025-11-09	127	Post-Workout	20
2025-11-09	102	Supper	40
2025-11-05	185	Supper	74
2025-11-05	3	Supper	95
2025-11-12	70	Post-Workout	20
2025-11-12	52	Post-Workout	8
2025-11-12	67	Post-Workout	1
2025-11-12	68	Post-Workout	10
2025-11-12	69	Post-Workout	10
2025-11-12	107	Supper	150
2025-11-13	25	Post-Workout	10
2025-11-13	52	Post-Workout	6
2025-11-08	26	Pre-Workout	100
2025-11-13	17	Post-Workout	30
2025-11-13	73	Post-Workout	20
2025-11-13	129	Post-Workout	10
2025-11-13	102	Supper	40
2025-11-09	86	Post-Workout	300
2025-11-14	4	Breakfast	4
2025-11-14	58	Breakfast	1
2025-11-14	53	Breakfast	150
2025-11-14	27	Breakfast	100
2025-11-14	105	Breakfast	100
2025-11-14	166	Breakfast	20
2025-11-14	15	Breakfast	10
2025-11-14	44	Lunch	100
2025-11-14	42	Lunch	150
2025-11-14	38	Lunch	100
2025-11-14	62	Lunch	60
2025-11-14	60	Lunch	20
2025-11-14	25	Lunch	10
2025-11-14	52	Lunch	6
2025-11-14	17	Lunch	30
2025-11-14	73	Lunch	20
2025-11-14	129	Lunch	10
2025-11-14	1	Pre-Workout	300
2025-11-14	26	Pre-Workout	110
2025-11-14	14	Pre-Workout	150
2025-11-14	11	Pre-Workout	10
2025-11-14	118	Post-Workout	1
2025-11-14	102	Supper	40
2025-11-15	4	Breakfast	4
2025-11-15	58	Breakfast	1
2025-11-15	53	Breakfast	150
2025-11-15	27	Breakfast	100
2025-11-15	105	Breakfast	100
2025-11-15	31	Breakfast	10
2025-11-15	51	Lunch	200
2025-11-15	83	Lunch	150
2025-11-15	22	Lunch	60
2025-11-15	133	Lunch	100
2025-11-15	12	Lunch	10
2025-11-15	30	Lunch	30
2025-11-15	19	Lunch	30
2025-11-15	56	Lunch	10
2025-11-15	55	Lunch	5
2025-11-15	1	Pre-Workout	300
2025-11-15	26	Pre-Workout	110
2025-11-15	14	Pre-Workout	150
2025-11-15	11	Pre-Workout	10
2025-11-15	51	Post-Workout	200
2025-11-15	83	Post-Workout	150
2025-11-15	22	Post-Workout	60
2025-11-15	133	Post-Workout	100
2025-11-15	12	Post-Workout	10
2025-11-15	30	Post-Workout	30
2025-11-15	19	Post-Workout	30
2025-11-15	56	Post-Workout	10
2025-11-15	55	Post-Workout	5
2025-11-15	102	Supper	40
2025-11-16	102	Supper	40
2025-11-17	151	Breakfast	1
2025-11-17	134	Breakfast	1
2025-11-17	27	Breakfast	100
2025-11-17	111	Lunch	1
2025-11-17	150	Lunch	1
2025-11-17	1	Pre-Workout	300
2025-11-17	27	Pre-Workout	200
2025-11-17	26	Pre-Workout	100
2025-11-17	31	Pre-Workout	10
2025-11-17	122	Post-Workout	120
2025-11-17	89	Post-Workout	150
2025-11-17	53	Post-Workout	100
2025-11-17	52	Post-Workout	8
2025-11-17	56	Post-Workout	10
2025-11-17	78	Post-Workout	20
2025-11-12	1	Lunch	50
2025-11-07	87	Lunch	112
2025-11-12	186	Lunch	20
2025-11-05	167	Breakfast	100
2025-11-05	58	Lunch	1
2025-11-05	60	Lunch	30
2025-11-05	51	Lunch	166
2025-11-05	25	Pre-Workout	35
2025-11-05	42	Post-Workout	140
2025-11-06	39	Breakfast	40
2025-11-06	25	Lunch	30
2025-11-06	26	Pre-Workout	178
2025-11-06	185	Post-Workout	125
2025-11-06	3	Post-Workout	158
2025-11-07	177	Post-Workout	28
2025-11-07	178	Post-Workout	24.64
2025-11-07	179	Post-Workout	47.6
2025-11-08	39	Breakfast	64
2025-11-08	91	Breakfast	112
2025-11-09	52	Post-Workout	8
2025-11-10	125	Lunch	300
2025-11-10	87	Lunch	100
2025-11-10	52	Lunch	8
2025-11-08	51	Lunch	400
2025-11-08	186	Lunch	40
2025-11-08	1	Lunch	90
2025-11-10	163	Lunch	40
2025-11-10	177	Pre-Workout	4.5
2025-11-10	178	Pre-Workout	21.6
2025-11-10	179	Pre-Workout	44.3
2025-11-17	71	Post-Workout	1
2025-11-17	79	Post-Workout	1
2025-11-17	72	Post-Workout	1
2025-11-17	107	Supper	150
2025-11-18	5	Breakfast	6
2025-11-18	6	Breakfast	3
2025-11-18	146	Breakfast	50
2025-11-18	23	Breakfast	100
2025-11-05	8	Breakfast	2
2025-11-18	167	Breakfast	100
2025-11-18	30	Breakfast	50
2025-11-18	122	Lunch	120
2025-11-05	128	Lunch	1
2025-11-18	89	Lunch	150
2025-11-18	53	Lunch	100
2025-11-18	52	Lunch	8
2025-11-18	56	Lunch	10
2025-11-05	19	Lunch	20
2025-11-05	21	Lunch	20
2025-11-05	62	Lunch	10
2025-11-05	1	Pre-Workout	300
2025-11-18	78	Lunch	20
2025-11-18	71	Lunch	1
2025-11-05	87	Post-Workout	100
2025-11-05	139	Post-Workout	150
2025-11-05	137	Post-Workout	15
2025-11-05	52	Post-Workout	8
2025-11-05	25	Post-Workout	10
2025-11-05	74	Post-Workout	30
2025-11-05	56	Post-Workout	10
2025-11-05	129	Post-Workout	15
2025-11-05	68	Post-Workout	3
2025-11-05	71	Post-Workout	1
2025-11-05	72	Post-Workout	1
2025-11-18	79	Lunch	1
2025-11-18	72	Lunch	1
2025-11-18	1	Pre-Workout	300
2025-11-18	27	Pre-Workout	200
2025-11-18	26	Pre-Workout	100
2025-11-18	31	Pre-Workout	10
2025-11-18	58	Post-Workout	2
2025-11-18	128	Post-Workout	1
2025-11-06	8	Breakfast	2
2025-11-18	51	Post-Workout	100
2025-11-18	126	Post-Workout	50
2025-11-06	27	Breakfast	100
2025-11-06	73	Breakfast	70
2025-11-18	20	Post-Workout	50
2025-11-06	87	Lunch	100
2025-11-06	42	Lunch	150
2025-11-06	139	Lunch	150
2025-11-06	137	Lunch	15
2025-11-06	52	Lunch	8
2025-11-06	74	Lunch	30
2025-11-06	56	Lunch	10
2025-11-06	129	Lunch	15
2025-11-06	68	Lunch	3
2025-11-06	71	Lunch	1
2025-11-06	72	Lunch	1
2025-11-06	1	Pre-Workout	300
2025-11-06	15	Pre-Workout	10
2025-11-18	22	Post-Workout	10
2025-11-18	59	Post-Workout	10
2025-11-18	19	Post-Workout	20
2025-11-18	21	Post-Workout	20
2025-11-18	60	Post-Workout	5
2025-11-18	62	Post-Workout	10
2025-11-18	107	Supper	150
2025-11-12	2	Breakfast	100
2025-11-12	3	Breakfast	150
2025-11-12	101	Breakfast	40
2025-11-12	26	Breakfast	100
2025-11-12	94	Lunch	200
2025-11-06	102	Supper	40
2025-11-07	8	Breakfast	2
2025-11-07	34	Breakfast	100
2025-11-07	153	Breakfast	100
2025-11-07	91	Breakfast	100
2025-11-07	19	Breakfast	80
2025-11-07	18	Breakfast	30
2025-11-07	52	Breakfast	5
2025-11-07	55	Breakfast	30
2025-11-12	44	Lunch	100
2025-11-12	52	Lunch	8
\.


--
-- Data for Name: day_kcals; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.day_kcals (diet_id, day_num, kcal) FROM stdin;
1	-5	2600
1	-4	2700
1	-3	2530
1	-2	2750
1	-1	2750
2	0	2900
2	1	2900
2	2	2900
2	3	2900
2	4	2900
2	5	2900
2	6	2900
2	7	2900
2	8	2900
2	9	2900
2	10	2900
2	11	2900
2	12	2900
2	13	2900
2	14	2900
2	15	2900
2	16	2900
2	17	2900
2	18	2900
2	19	2900
2	20	2900
1	0	2600
1	1	2700
1	2	2530
1	3	2750
1	4	2750
1	5	2600
1	6	2790
1	7	2790
1	8	2530
1	9	2750
1	10	2750
1	11	2600
1	12	2790
1	13	2790
1	14	2700
1	15	2530
1	16	2750
1	17	2750
1	18	2600
1	19	2790
1	20	2790
1	21	0
1	22	0
1	23	2900
1	24	0
2	21	2900
2	22	2900
2	23	2900
1	28	0
1	29	0
1	30	0
1	31	0
1	32	0
1	33	0
1	34	0
1	35	0
1	36	0
1	37	0
1	38	0
1	39	0
1	40	0
1	41	0
1	25	0
1	26	0
1	27	0
2	24	2900
2	25	2900
2	26	2900
2	27	2900
2	28	2900
2	29	2900
2	30	2900
2	31	2900
2	32	2900
2	33	2900
2	34	2900
2	35	2900
2	36	2900
2	37	2900
2	38	2900
2	39	2900
2	40	2900
2	41	2900
2	42	2900
2	43	2900
2	44	2900
2	45	2900
2	46	2900
2	47	2900
2	48	2900
2	49	2900
2	50	2900
2	51	2900
2	52	2900
2	53	2900
2	54	2900
2	55	2900
\.


--
-- Data for Name: diet_context; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.diet_context (active_diet, start_date, current_weight) FROM stdin;
2	2025-10-06	82.5
\.


--
-- Data for Name: diet_label_bridge; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.diet_label_bridge (diet_id, label_id) FROM stdin;
\.


--
-- Data for Name: diet_labels; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.diet_labels (id, label, color) FROM stdin;
\.


--
-- Data for Name: diet_slots; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.diet_slots (diet_id, slot_num, dish_id) FROM stdin;
1	105	\N
1	106	\N
1	107	\N
1	108	\N
1	109	\N
1	111	\N
1	112	\N
1	2	5
1	113	\N
1	114	\N
1	120	\N
1	122	\N
1	131	\N
1	132	\N
1	133	\N
1	134	\N
1	135	\N
1	136	\N
1	137	\N
1	138	\N
1	139	\N
1	0	6
1	1	20
1	3	35
1	4	24
1	5	6
1	6	20
1	7	3
1	8	35
1	9	24
1	10	6
1	11	20
1	12	3
1	13	35
1	14	24
1	15	6
1	16	20
1	17	3
1	18	35
1	19	24
1	20	6
1	21	20
1	22	3
1	23	35
1	24	24
1	25	6
1	26	20
1	27	3
1	28	35
1	29	24
1	30	6
1	31	20
1	32	3
1	33	35
1	34	24
1	35	6
1	36	20
1	37	3
1	38	35
1	39	24
1	40	6
1	41	20
1	42	3
1	43	35
1	44	24
1	45	6
1	46	20
1	47	3
1	48	35
1	49	24
1	50	6
1	51	20
1	52	3
1	53	35
1	54	24
1	55	6
1	56	20
1	57	3
1	58	35
1	59	25
1	60	6
1	61	20
1	62	3
1	63	35
1	64	24
1	65	6
1	66	20
1	67	3
1	68	35
1	69	24
1	70	6
1	71	20
1	72	3
1	73	35
1	74	24
1	75	6
1	76	20
1	77	3
1	78	35
1	79	24
1	80	6
1	81	20
1	82	3
1	83	35
1	84	24
1	85	6
1	86	20
1	87	3
1	88	35
1	89	24
1	90	6
1	91	20
1	92	3
1	93	35
1	94	24
1	95	6
1	96	20
1	97	3
1	98	35
1	99	24
1	100	6
1	101	20
1	102	3
1	103	35
1	104	24
1	110	6
1	115	33
1	116	16
1	117	1
1	118	39
1	119	25
1	121	34
1	123	30
1	124	24
1	125	6
1	126	14
1	127	1
1	128	14
1	129	24
1	130	6
2	30	\N
2	31	\N
2	32	\N
2	33	\N
2	100	\N
2	101	\N
2	102	\N
2	103	\N
2	135	\N
2	136	\N
2	137	\N
2	138	\N
2	139	\N
2	205	\N
2	206	\N
2	207	\N
2	208	\N
2	275	\N
2	276	\N
2	277	\N
2	278	\N
2	0	81
2	1	29
2	2	1
2	3	21
2	4	25
2	5	82
2	6	21
2	7	1
2	8	35
2	9	25
2	10	83
2	11	35
2	12	1
2	13	65
2	14	25
2	15	84
2	16	65
2	17	70
2	18	64
2	19	24
2	20	85
2	21	64
2	22	70
2	23	30
2	24	24
2	25	85
2	26	68
2	27	70
2	28	68
2	29	24
2	34	24
2	35	42
2	36	28
2	37	69
2	38	23
2	39	25
2	40	7
2	41	23
2	42	69
2	43	34
2	44	25
2	45	7
2	46	34
2	47	69
2	48	39
2	49	25
2	50	7
2	51	39
2	52	2
2	53	15
2	54	24
2	55	91
2	56	15
2	57	2
2	58	32
2	59	24
2	60	92
2	61	66
2	62	2
2	63	66
2	64	24
2	65	93
2	66	31
2	67	2
2	68	41
2	69	24
2	70	81
2	71	126
2	72	71
2	73	16
2	74	25
2	75	94
2	76	16
2	77	71
2	78	35
2	79	25
2	80	95
2	81	35
2	82	71
2	83	63
2	84	25
2	85	96
2	86	63
2	87	3
2	88	14
2	89	24
2	90	97
2	91	14
2	92	3
2	93	30
2	94	24
2	95	98
2	96	18
2	97	3
2	98	18
2	99	24
2	104	24
2	105	42
2	106	29
2	107	5
2	108	62
2	109	25
2	110	99
2	111	62
2	112	5
2	113	34
2	114	25
2	115	100
2	116	34
2	117	5
2	118	17
2	119	25
2	120	101
2	121	17
2	122	72
2	123	38
2	124	24
2	125	102
2	126	38
2	127	72
2	128	32
2	129	24
2	130	103
2	131	67
2	132	72
2	133	67
2	134	24
2	140	81
2	141	125
2	142	1
2	143	22
2	144	25
2	145	104
2	146	22
2	147	1
2	148	35
2	149	25
2	150	104
2	151	35
2	152	1
2	153	65
2	154	25
2	155	106
2	156	65
2	157	70
2	158	64
2	159	24
2	160	107
2	161	64
2	162	70
2	163	30
2	164	24
2	165	105
2	166	68
2	167	70
2	168	68
2	169	24
2	170	108
2	171	19
2	172	2
2	173	20
2	174	24
2	175	42
2	176	29
2	177	69
2	178	23
2	179	25
2	180	109
2	181	23
2	182	69
2	183	34
2	184	25
2	185	6
2	186	34
2	187	69
2	188	15
2	189	25
2	190	110
2	191	15
2	192	2
2	193	36
2	194	24
2	195	111
2	196	36
2	197	2
2	198	32
2	199	24
2	200	112
2	201	66
2	202	2
2	203	66
2	204	24
2	209	24
2	210	81
2	211	28
2	212	71
2	213	37
2	214	25
2	215	113
2	216	37
2	217	71
2	218	35
2	219	25
2	220	114
2	221	35
2	222	71
2	223	63
2	224	25
2	225	115
2	226	63
2	227	3
2	228	14
2	229	24
2	230	117
2	231	14
2	232	3
2	233	30
2	234	24
2	235	118
2	236	18
2	237	3
2	238	18
2	239	24
2	240	118
2	241	26
2	242	2
2	243	41
2	244	24
2	245	42
2	246	126
2	247	5
2	248	62
2	249	25
2	250	119
2	251	62
2	252	5
2	253	34
2	254	25
2	255	120
2	256	34
2	257	5
2	258	17
2	259	25
2	260	121
2	261	17
2	262	72
2	263	38
2	264	24
2	265	102
2	266	38
2	267	72
2	268	32
2	269	24
2	270	122
2	271	67
2	272	72
2	273	67
2	274	24
2	279	24
\.


--
-- Data for Name: diets; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.diets (id, name, descr) FROM stdin;
2	Lean Bulk Zeta	Baza 2900, adjust w trakcie
1	Reverse Diet 	Reverse diet przed Sri-Lanka
\.


--
-- Data for Name: dish_label_bridge; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.dish_label_bridge (dish_id, label_id) FROM stdin;
54	4
54	2
20	2
55	2
55	4
56	2
56	4
57	3
31	2
31	5
14	2
14	3
15	2
15	3
37	2
37	4
16	2
16	4
19	2
19	5
\.


--
-- Data for Name: dish_labels; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.dish_labels (id, label, color) FROM stdin;
1	redu	#000000
2	masa	#000000
3	kurczak	#FF9966
5	chuda ryba	#009BFF
6	tłusta ryba	#7FCDFF
4	red-meat	#D10000
\.


--
-- Data for Name: dishes; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.dishes (id, meal, name, descr) FROM stdin;
77	Breakfast	23A Tosty - Żywiecka	
24	Supper	Kazeina	
25	Supper	Twaróg klinek chudy	
90	Breakfast	32M Jajecznica - Mexicano + pomarańcza&pestki dyni	
54	MainMeal	11A Red Meat - Pork - (schab, polędwiczka)	
1	Pre-Workout	M 0 Skyr - Miód + Banan&Jabłko	
20	MainMeal	40M Krewetki - masło/czosnek	
88	Pre-Workout	XJ2 - Jebaniec na zimno (sernik)	
30	MainMeal	FF Double Zinger (KFC)	
32	MainMeal	FF Kebab King mały lawasz kurczak bez sosu	
55	MainMeal	12A Red Meat - Beef - (Stek, Kotlet)	
79	Breakfast	24A Tosty - Ricotta (na słodko)	
56	MainMeal	13A Red Meat - Liver - (Wątróbka)	
57	MainMeal	20A - Poultry - (Kurczak, Indyk)	
58	MainMeal	31A - Fish - Lean - (Dorsz, Miruna)	
31	MainMeal	31M Miruna - kluski&dżem	
85	Breakfast	40M Kanapki  - Indyk&Awokado	
14	MainMeal	20M Kurczak filet - Wrap	
15	MainMeal	20M Kurczak filet - Tikka Masala 	
37	MainMeal	11M Wieprzowina schab - Śmietankowo-Koperkowy	
106	Breakfast	40M Kanapki - Masło orzechowe & Banan Marchew obok	
95	Breakfast	21M Tosty - Konserwowa + jabłko i marchew	
94	Breakfast	21M Tosty - Konserwowa + pomarańcza i marchew	
16	MainMeal	11M Wieprzowina polędwiczka - Spaghetti Napoli	
59	MainMeal	32A - Fish - Semi-fatty - (Pstrąg)	
91	Breakfast	33M Jajecznica - Na słodko + płatki&maliny&mleko&miód	
60	MainMeal	33A - Fish - Fatty - (Łosoś, Halibut)	
61	MainMeal	40A - Extras - (Krewetki, Tofu, Halloumi)	
13	MainMeal	Archived Wołowina mielona - kofta grecka	
92	Breakfast	33M Jajecznica - Na słodko + banan/migdały/tosy/peanut-butter	
83	Breakfast	40M Kanapki - Masło orzechowe & Banan	
84	Breakfast	40M Kanapki - Kefir Protein Shake	
93	Breakfast	33M Jajecznica - Na słodko + kiwi/kefir/orzechy	
19	MainMeal	31M Dorsz filet - cytrynowo-pietruszkowy	
26	MainMeal	31M Miruna - jak nad morzem	
36	MainMeal	20M Kurczak filet - Słodko-kwaśny	
103	Breakfast	11M Owsianka - jagodowa	
39	MainMeal	20M Kurczak filet - Mexicano 	
17	MainMeal	20M Kurczak filet - Gyros	
107	Breakfast	40M Kanapki  - Indyk&Awokado + jabłko	
40	MainMeal	32M Pstrąg - ziemniaki&zioła	
2	Pre-Workout	M 5 Skyr - Maliny&Chia + Banan	
3	Pre-Workout	M 6 Skyr - Peanut Butter + Banan	
5	Pre-Workout	M 3 Skyr + 2Banany&Jabłko	
69	Pre-Workout	M 1 Skyr - Miód kakao banan	
70	Pre-Workout	M 4 Skyr - 2banany&migdały	
71	Pre-Workout	M 2 Skyr - 2kiwi&banan&siemię	
18	MainMeal	33M Łosoś - Salsa awokado	
72	Pre-Workout	M 7 Skyr - Wiśnie&Orzechy	
64	MainMeal	20M Kurczak filet - Pad thai 	
21	MainMeal	11M Wieprzowina polędwiczka - Musztardowo-miodowa	
98	Breakfast	24M Tosty - Ricotta + banan&kakao&chia	
96	Breakfast	21M Tosty - Konserwowa + shake(masło orzechowe&truskawki	
38	MainMeal	20M Kurczak filet - Penne&Pesto 	
73	Breakfast	11A Owsianka	
65	MainMeal	20M Kurczak filet - Asian Stri-Fry 	
67	MainMeal	33M Łosoś - Ziemniaki w mundurkach z dipem	
80	Breakfast	40A Kanapki	
6	Breakfast	31A Jajecznica - Tuńczyk	
35	MainMeal	12M Wołowina kotlet - dwa burger + frytki	
68	MainMeal	33M Łosoś - Chilli-limonka z ryżem	
76	Breakfast	22A Tosty - Krakowska	
42	Breakfast	FF Bajgiel i bieluch	
78	Breakfast	21A Tosty - Konserwowa	
33	Breakfast	33A Jajecznica - Na słodko	
81	Breakfast	FF Kanapka z szarpaną wołowiną i bieluch + kiwi	
7	Breakfast	32A Jajecznica - Mexicano	
86	Pre-Workout	XJ1 Waniliowy Jebaniec (Sernik)	
82	Breakfast	40M Kanapka z serkiem wiejskim	
74	Breakfast	12A Jaglanka	
41	MainMeal	40M Hallouumi - quinoa + grillowana papryka	
87	MainMeal	XJ1 - Pizza białkowa	
89	Breakfast	32M Jajecznica - Mexicano + kefir i szpinak	
113	Breakfast	23M Tosty - Żywiecka - kimchi i szpinak	
102	Breakfast	11M Owsianka - wiśniowa	
63	MainMeal	20M Kurczak filet - Kottu 	
62	MainMeal	13M Wątróbka - śródziemnomorska	
99	Breakfast	12M Jaglanka- rodzynki&miód&chia	
22	MainMeal	11M Wieprzowina schab – pieczony z ziołami	
29	MainMeal	FF Sałatka Cezar Duża + Bułka z chia	
100	Breakfast	12A Jaglanka- banan&orzechy laskowe	
101	Breakfast	12M Jaglanka- malinki&miód&chia	
108	Breakfast	40A Kanapki - Mozarella - copy	
104	Breakfast	40M Kanapki - z Kimchi i tuńczykiem	
109	Breakfast	31M Jajecznica - Tuńczyk + kiwi	
105	Breakfast	40A Kanapki - Mozarella	
111	Breakfast	33M Jajecznica - Na słodko + kiwi/orzechy	
110	Breakfast	31M Jajecznica - Tuńczyk + kiwi i pestki dyni	
66	MainMeal	33M Łosoś - Frytki i sos czosnkowy	
112	Breakfast	33M Jajecznica - Na słodko + kiwi/orzechy/siemie	
23	MainMeal	13M Wątróbka - klasyczek cebula	
114	Breakfast	23M Tosty - Żywiecka - kimchi i szpinak + orange	
115	Breakfast	23M Tosty - Żywiecka - shake(jagody, siemie)	
116	Breakfast	23M Tosty - Żywiecka - shake(kiwi, szpinak)	
97	Breakfast	24M Tosty - Ricotta  + miód&maliny&migdały	
117	Breakfast	24M Tosty - Ricotta - shake(kiwi, szpinak)	
118	Breakfast	24A Tosty - Ricotta + orange	
119	Breakfast	13M Ryżanka - marchew tarta/mango/cynamon	
75	Breakfast	13A Ryżanka	
34	MainMeal	12M Wołowina stek - z frytkami	
120	Breakfast	13M Ryżanka - mango/chia/jagody	
121	Breakfast	13M Ryżanka - truskawki/miód/kakao	
122	Breakfast	11M Owsianka - żurawinowa	
123	Pre-Workout	XJ3 - Jebańcowe obłoczki	
124	MainMeal	XJ2 - Arepas de Victor	
28	MainMeal	FF Sałatka Cobb Duża + Bułka z chia	
125	MainMeal	FF Sałatka Awokado Rybak Duża + Bułka z chia	
126	MainMeal	FF - Wrap Wołowina BBQ 	
127	MainMeal	FF Sałatka z kurczakiem (Putka)	
\.


--
-- Data for Name: ingredient_amounts; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.ingredient_amounts (dish_id, ingredient_id, amount) FROM stdin;
93	4	4
93	58	1
93	27	100
93	23	100
36	44	100
36	42	150
36	38	100
36	62	60
36	60	20
36	25	10
36	52	6
36	17	30
36	73	20
93	10	10
77	5	6
77	6	3
77	146	50
36	129	10
107	8	2
107	34	100
80	8	2
107	153	100
29	112	1
29	150	1
63	61	2
85	8	2
85	23	200
85	34	100
85	153	100
85	19	80
85	18	30
85	52	5
63	42	150
63	4	1
121	4	2
121	144	80
121	3	200
121	29	100
121	25	20
121	16	20
63	135	1
63	126	80
86	4	3
86	1	150
86	155	1
86	156	10
63	73	40
63	62	30
63	129	10
63	69	10
107	91	100
107	19	80
107	18	30
107	52	5
107	55	30
109	4	4
109	149	1
109	148	50
102	2	100
102	3	200
102	4	1
102	143	100
102	15	40
109	27	100
15	44	100
15	42	150
15	22	75
15	46	100
15	70	20
15	52	8
15	67	1
15	68	10
15	69	10
14	61	2
14	42	150
14	22	75
14	52	8
14	67	1
14	17	30
14	59	10
14	20	20
14	21	10
14	57	1
14	66	1
19	85	150
19	47	150
19	52	8
19	28	30
19	73	30
19	54	10
19	55	10
19	71	1
19	72	1
73	2	100
73	4	1
73	3	200
76	5	6
76	6	3
76	124	50
92	4	4
92	26	100
92	15	20
92	39	20
91	4	4
91	3	150
96	5	6
96	6	3
96	27	100
91	2	50
91	14	100
96	39	25
96	29	100
91	25	10
91	31	5
91	58	1
96	9	50
96	23	100
123	1	150
123	4	1
123	157	40
123	170	100
123	171	7
28	111	1
28	150	1
125	150	1
125	173	1
62	45	100
62	94	150
62	12	20
62	22	40
62	18	80
62	52	8
62	62	30
62	56	10
26	51	350
26	108	200
26	22	50
26	59	20
62	28	10
62	71	1
62	90	1
62	72	1
62	30	30
26	60	10
26	55	10
26	71	2
26	72	1
106	8	2
106	26	90
106	27	100
106	39	30
106	73	70
106	13	1
24	102	40
25	107	150
21	89	150
21	85	80
21	91	150
118	123	6
118	6	2
110	4	4
110	149	1
110	148	100
110	27	100
110	12	15
118	147	100
118	24	100
21	25	30
69	1	300
32	118	1
30	117	1
69	25	40
69	16	20
69	26	80
71	1	300
71	27	200
71	26	100
21	52	8
21	59	20
21	71	1
21	90	1
71	31	10
74	145	100
74	4	1
74	3	100
21	72	1
21	133	100
87	6	2
87	152	1
87	158	60
87	157	50
87	4	1
87	38	50
87	9	30
42	110	1
42	134	1
42	27	100
42	91	120
78	5	6
78	6	3
78	9	50
81	151	1
81	134	1
81	27	100
65	87	100
65	42	150
65	139	150
82	8	2
82	152	1
82	24	100
82	10	10
82	25	10
83	8	2
83	39	30
83	26	90
83	13	1
65	137	15
65	52	8
65	25	10
99	145	100
99	4	1
99	3	100
99	165	40
99	25	10
99	11	10
65	56	10
65	129	15
84	8	2
84	23	200
84	4	2
84	39	20
65	68	3
65	71	1
65	72	1
65	74	30
31	122	130
31	108	180
31	121	100
31	126	100
31	73	50
17	51	250
17	42	150
17	22	100
17	52	8
17	76	30
17	19	20
17	77	1
17	17	40
103	2	100
103	3	200
103	4	1
103	106	100
103	39	40
111	4	4
111	58	1
111	53	150
111	27	100
111	105	100
111	166	20
111	15	10
104	8	2
104	167	200
104	166	20
104	24	100
104	148	60
18	83	150
18	130	150
18	34	50
66	51	200
54	89	100
55	43	100
56	94	100
57	42	100
66	83	150
58	47	100
59	131	100
60	83	100
61	86	100
66	22	60
66	133	100
66	12	10
66	30	30
66	19	30
13	48	150
13	45	50
13	22	50
13	56	20
13	52	8
13	67	1
13	55	10
13	66	1
66	56	10
66	55	5
108	8	2
108	23	200
108	168	60
108	24	100
108	133	100
108	30	100
37	122	120
37	89	150
37	53	100
37	52	8
37	56	10
37	78	20
37	71	1
37	79	1
37	72	1
108	19	100
108	91	160
105	8	2
105	23	200
105	27	100
105	168	60
105	133	100
105	19	100
105	18	50
105	73	50
112	4	4
112	58	1
112	53	150
40	132	400
40	131	150
40	56	20
40	73	30
40	133	30
101	145	100
101	4	1
101	14	100
101	3	100
101	25	30
101	11	10
40	55	20
40	28	10
40	78	10
2	1	300
2	26	110
2	14	150
2	11	10
122	2	100
122	169	70
122	4	1
122	3	100
122	31	15
126	174	1
68	83	150
68	140	100
68	52	8
68	30	50
68	56	10
6	4	4
6	148	50
6	149	1
68	129	10
33	4	4
68	141	10
68	142	30
67	132	350
67	83	150
67	53	50
67	154	30
68	19	30
67	56	5
67	78	10
67	55	5
5	1	300
5	26	160
5	91	150
70	1	300
70	26	160
70	15	10
22	84	100
22	89	150
22	52	20
22	73	100
1	1	300
1	26	160
1	91	150
1	25	20
3	1	300
3	26	110
3	39	30
72	1	300
72	143	150
72	10	10
72	25	30
20	87	100
20	86	200
20	127	20
20	88	15
20	56	20
20	28	20
20	55	10
39	45	100
39	42	150
39	65	30
39	64	50
39	52	6
39	67	1
39	62	20
39	17	20
39	63	20
39	57	1
64	87	100
64	42	150
16	49	100
16	89	150
16	6	1
16	46	100
16	12	10
16	52	8
16	62	30
16	73	60
16	17	30
64	4	1
64	127	10
64	52	8
64	62	40
64	73	40
64	25	10
64	56	10
64	74	20
64	129	15
64	69	10
64	55	10
16	30	30
16	56	10
16	74	20
16	66	1
16	71	1
16	75	1
16	72	1
22	67	1
22	92	1
88	159	1
88	107	125
88	1	150
88	160	30
88	29	100
88	36	50
7	4	4
7	149	1
7	65	30
7	64	30
7	17	150
7	24	100
89	4	4
89	149	1
89	65	30
89	64	30
89	23	200
89	30	50
22	17	30
22	56	10
22	93	20
22	71	1
22	72	1
35	58	2
90	4	4
90	149	1
90	24	100
90	65	30
90	64	30
90	12	20
35	128	1
35	51	100
35	126	50
35	22	10
35	59	10
35	19	20
35	21	20
35	60	5
35	62	10
35	20	50
95	5	6
95	6	4
95	91	120
95	9	50
95	73	50
95	60	40
94	5	6
94	6	3
94	24	120
94	9	50
94	73	50
94	60	40
22	30	50
100	145	100
100	4	1
100	26	90
100	166	20
100	3	100
38	130	150
38	42	150
38	80	40
38	10	10
38	56	20
38	52	8
38	30	100
38	71	1
38	79	2
38	72	1
18	18	50
18	52	8
18	63	40
18	82	50
18	69	10
18	57	1
41	85	100
41	95	100
41	161	15
41	17	50
41	52	6
41	28	10
41	55	10
75	144	80
75	4	2
75	3	200
120	144	80
120	4	2
120	3	200
120	37	100
120	106	50
34	43	200
34	51	200
34	18	100
34	73	50
34	19	50
34	126	50
34	55	20
34	71	1
34	72	1
34	52	5
127	175	1
112	27	100
112	105	100
112	31	10
23	96	100
23	94	150
23	91	150
23	162	50
23	88	10
23	97	1
23	62	30
23	71	1
23	72	1
23	30	50
113	5	6
113	6	3
113	146	50
113	167	100
113	30	50
113	23	100
114	5	6
114	6	3
114	146	50
114	23	100
114	167	100
114	30	50
114	24	100
115	5	6
115	6	3
115	146	50
115	23	100
115	106	100
115	31	10
119	144	80
119	4	2
119	3	200
119	73	100
119	37	60
119	13	1
116	5	6
116	6	3
116	146	50
116	23	100
116	27	100
116	30	50
124	172	120
124	71	1
124	170	100
124	42	150
124	147	50
124	55	10
124	72	1
124	17	20
98	6	3
98	147	100
98	26	100
98	11	10
98	16	10
98	123	6
79	123	6
79	6	2
79	147	100
117	123	6
117	6	2
117	147	100
117	27	100
117	23	100
117	166	15
117	30	50
97	6	2
97	147	100
97	164	120
97	15	15
97	25	20
97	123	6
\.


--
-- Data for Name: ingredient_label_bridge; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.ingredient_label_bridge (ingredient_id, label_id) FROM stdin;
\.


--
-- Data for Name: ingredient_labels; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.ingredient_labels (id, label, color) FROM stdin;
\.


--
-- Data for Name: ingredients; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.ingredients (id, name, unit, default_amount, shop_style, kcal, proteins, fats, carbs, path) FROM stdin;
55	Sok z cytryny (Citromle)	g	100	Lidl	13	0	0	3.2	2000
60	Ketchu pikantny (Pudliszki)	g	100	Lidl	144	1.1	0.1	3.4	2000
2	Płatki owsiane górskie (Crownfield)	g	100	Lidl	354	12.5	6.3	55.9	1200
3	Mleko UHT 1.5% tłuszczu (Mleczna Dolina)	g	100	Lidl	46	3.3	1.5	4.8	790
4	Jaja kurze (60g)	sztuka	1	Lidl	84	7.5	5.8	0.4	1100
6	Regionalne szlaki Rolada Ustrzycka Wędzona (1 plaster 20g)	porcja	1	Lidl	58	5	4	0.4	680
7	Krakus Kiełbasa Krakowska sucha z szynki 144g (2x72g)	g	100	Lidl	182	31	6.3	0.3	650
8	Chleb Żytni z Ziarnami Żyta krojony (Piekarnia Lidla) (1 kromka 90g)	kromka	1	Lidl	180	4.8	1.3	33.3	100
9	Szynka konserwowa wieprzowa (Pikok)	g	100	Lidl	99	19	1.6	2	610
10	Orzechy włoskie (Alesto)	g	100	Zapasy	712	15.5	69.1	3.7	410
11	Nasiona chia (Promienie słoneczne)	g	100	Zapasy	489	14.3	32.1	50	410
12	Pestki dyni (Alesto)	g	100	Zapasy	579	24.4	45.6	15.2	410
56	Czosnek	g	100	Świeże	152	6.4	0.5	32.6	200
14	Maliny mrożone (Lidl)	g	100	Lidl	49	1.3	0.3	5.3	890
15	Migdały	g	100	Zapasy	604	24.1	52	20.5	400
17	Papryka czerwona	g	100	Świeże	32	1.3	0.5	6.6	200
18	Rukola	g	100	Świeże	25	2.6	0.7	3.6	200
19	Pomidor	g	100	Świeże	19	0.9	0.2	4.1	200
20	Ogórek kiszony	g	100	Świeże	13	1.1	0.1	1.4	310
21	Sałata lodowa (Asda)	g	100	Świeże	14	1.2	0.5	1.4	200
22	Jogur grecki XXL (Pilos)	g	100	Lidl	123	3.6	10	4.7	730
23	Kefir (Robico)	g	100	Lidl	47	3	2	4.2	740
24	Pomarańcza	g	100	Świeże	47	0.9	0.2	11.3	200
25	Miód lipowy (Bartnik)	g	100	Lidl	333	0.3	0	83	1210
26	Banan	g	100	Świeże	97	1	0.3	21.8	200
27	Kiwi	g	100	Świeże	60	0.9	0.5	13.9	200
28	Pietruszka Natka	g	100	Świeże	49	4.4	0.4	9	200
29	Truskawki mrożone	g	100	Lidl	33	0.7	0.4	7.6	890
30	Szpinak baby (Vita Fresh)	g	100	Lidl	22	2.9	0	0.8	200
31	Siemię lniane (Witpak)	g	100	Zapasy	507	25	31	39	400
32	Mandarynka (1 sztuka 60g)	sztuka	1	Świeże	27	0.4	0.1	6.7	200
33	Pistacje (Alesto)	g	100	Lidl	605	26.5	49.2	10.3	400
34	Awokado	g	100	Świeże	169	2	15.3	7.4	200
36	Borówka amerykańska	g	100	Świeże	57	0.8	0.4	11.5	200
37	Mango	g	100	Świeże	69	0.5	0.3	15.3	200
38	Ananas	g	100	Lidl	55	0.4	0.2	13.6	200
40	Serek wiejski wysokobiałkowy (Pilos) (1 sztuka 200g)	sztuka	1	Lidl	184	28	6	4.6	720
41	Musli crunchy z orzeszkami (Crownfield)	g	100	Lidl	467	11	18	62	1200
42	Filet z piersi kurczaka (Kurczak z zielonych Ferm)	g	100	Lidl	112	24	1.6	0.2	500
43	Irish beef	g	100	Lidl	243	17.3	18	0.1	500
45	Ryż basmati (Plony Natury)	g	100	Lidl	358	8.7	0.8	79	900
46	Pomidory bez skóry krojone (Baresa)	g	100	Lidl	27	1.3	0.2	4	900
47	Dorsz atlantycki	g	100	Lidl	83	19.1	0.7	0.5	500
48	Mięso mielone wołowe (Rzeźnik)	g	100	Lidl	256	18	20	0	500
49	Tagliatelle (Tiradell)	g	100	Lidl	354	12.4	1.5	71.2	900
50	Frytki z batatów (Harvest Basket)	g	100	Lidl	145	2	5	21.1	820
51	Frytki karbowane do piekarnika (Aviko)	g	100	Lidl	152	2.4	4.5	24.3	820
52	Oliwa z oliwek	g	100	Lidl	897	0	99.6	0.2	370
53	Jogurt naturalny (Fruvita)	g	100	Lidl	71	4.4	3	6.5	730
54	Skórka z cytryny	g	100	Świeże	47	1.5	0.3	16	200
57	Czosnek granulowany	szczypta	1	Zapasy	0	0	0	0	350
59	Musztarda sarepska (Kamis)	g	100	Lidl	101	3.7	5.1	8.3	2000
61	Tortilla pszenna wraps 245g (PANO)	sztuka	1	Lidl	195	5.9	4.6	31.9	120
62	Cebula	g	100	Świeże	33	1.4	0.4	6.9	200
63	Cebula czerwona	g	100	Świeże	30	1.4	0.4	6.9	200
64	Kukurydza złocista	g	100	Lidl	94	3.2	1	19	310
65	Fasola	g	100	Lidl	288	21.4	1.6	61.6	310
66	Oregano	szczypta	100	Zapasy	3	0.1	0	0.7	350
67	Papryka słodka 22g (Kamis)	szczypta	1	Lidl	3	0.1	0.1	0.6	350
68	Imbir świeży	g	100	Lidl	80	1.8	0.7	17.8	350
69	Kolendra świeża	g	100	Lidl	23	2.1	0.3	3.7	350
70	Garam masala (Kolpol)	g	100	Zapasy	462	11.2	13.2	59.6	350
71	Sól biała	szczypta	1	Zapasy	0	0	0	0	350
39	Masło orzechowe (GO ON)	g	100	Lidl	581	17	46	12	1210
13	Cynamon	łyżeczka	1	Zapasy	7	0.1	0	0.8	350
80	Pesto (Barilla)	g	100	Lidl	482	4.7	46	9.8	2000
88	Masło Extra Osełka 82% Tłusczu	g	100	Lidl	744	0.7	82	0.7	2000
96	Groch żółty łuskany połówki	g	100	Lidl	379	23.8	1.4	60.2	2000
101	Kazeina micelarna (Biały Puch)	g	100	Lidl	355	80	1.6	5.2	2000
107	Twaróg klinek chudy (Delikate)	g	100	Lidl	96	20	0.2	3.5	735
113	Bowl Toskański Kurczak (Salad Story)	porcja	1	Świeże	583	32	27	53	2000
116	Frytki Duże (KFC)	porcja	1	Świeże	268	4.1	12	35	2000
102	Kazeina SFD 750g (Truskawkowa)	g	100	Zapasy	390	70	3.7	19.2	2000
115	Zinger (KFC)	sztuka	1	Na żywo	438	26.7	23.3	37.6	2000
117	Zinger Double (KFC)	sztuka	1	Na żywo	590	41	29	41	2000
111	Sałatka Cobb Powiększona (Salad Story)	porcja	1	Na żywo	440	32	28	15	2000
112	Sałatka Cezar (Salad Story)	porcja	1	Na żywo	426	36	25	13	2000
118	Kebab - mały lawasz z kurczakiem bez sosu (Kebab King)	sztuka	1	Na żywo	618	37.1	23.2	68.4	2000
114	Nachos Sandwich (Kebab King)	porcja	1056	Na żywo	1056	65	44	99	2000
104	Protein pudding Chocolate Valio 180g	sztuka	1	Na żywo	148	19.8	2.7	10.8	2000
103	Danone YoPro Jogurt smak straciatella 160g (Danone YoPro)	sztuka	1	Na żywo	91	15	0.8	5.8	2000
130	Pastani pełne ziarno makaron penne (Pastani Pełne Ziarno)	g	100	Lidl	176	7.9	1.6	30	900
1	Skyr Piątnica Jogurt typu Islandzkiego naturalny 450g	g	100	Lidl	64	12	0	4.1	700
5	Chleb tostowy z mąką pełnoziarnistą (1 kromka 22g)	kromka	1	Lidl	53	1.8	0.6	9.5	180
16	Belbake Kakao Ekstra Ciemne o Obniżonej zawartości Tłuszczu (belbake)	g	100	Zapasy	309	24	11	13	800
35	Sardynka w sosie pomidorowym (LISNER)	g	100	Lidl	232	12	41	3	320
44	Ryż biały długoziarnisty (Plony Natury)	g	100	Lidl	351	7.5	0.8	78	900
74	Szczypiorek	g	100	Świeże	35	4.1	0.8	4.2	200
75	Bazylia suszona 10g (Prymat)	szczypta	1	Zapasy	0	0	0	0	350
110	Bajgiel Bekon & Kurczak (Putka)	sztuka	1	Na żywo	403	19.8	11.9	52.2	2000
78	Koperek	g	100	Świeże	26	2.8	0.4	2.8	200
79	Zioła prowansalskie	szczypta	1	Zapasy	0	0	0	0	350
81	Fasola czerwona	g	100	Lidl	96	8	0.5	10	310
83	Łosoś atlantycki świeży filet ze skórą	g	100	Lidl	220	19	16	0	500
84	Kasza bulgur (Plony Natury)	g	100	Lidl	332	12	1.5	63	900
85	Kasza Kuskus (Plony Natury)	g	100	Lidl	355	14	2	68	900
86	Krewetki białe (Marinero)	g	100	Lidl	64	14.4	0.7	0	810
58	Bułka wieloziarnista (Lidl) 1 sztuka 60g	sztuka	1	Świeże	173	4.2	4.2	19.2	100
90	Tymianek	szczypta	1	Zapasy	0	0	0	0	350
91	Jabłko	g	100	Świeże	50	0.4	0.4	12.1	200
92	Rozmaryn szuszony	szczypta	1	Zapasy	3	0.1	0.1	0.6	350
93	Cukinia	g	100	Świeże	17	1.2	0.1	3.2	200
94	Wątróbka drobiowa (Muhlenhof)	g	100	Lidl	136	19.1	6.3	0	500
95	Ser Halloumi EKTOS	g	100	Lidl	317	20	25	3	699
97	Majeranek suszony	szczypta	1	Zapasy	3	0.1	0.1	0.6	350
98	Mięta liście	g	100	Lidl	43	3.8	0.7	5.3	200
100	Morele suszone	g	100	Lidl	301	5.4	1.2	72.2	400
76	Ogórek zielony	g	100	Świeże	14	0.7	0.1	2.9	200
106	Jagody mrożone	g	100	Lidl	65	0.8	1.1	10	890
82	Pomidorki koktajlowe	g	100	Świeże	19	1	0.2	2.9	200
108	Miruna Nowozelandzka filet (Marinero)	g	100	Lidl	78	16	1.5	0	500
109	Skyr pitny naturalny (Piątnica) 330g	opakowanie	1	Świeże	211	25.1	5.9	14.2	700
119	Skyr jogurt typu islandzkiego z jagodami 150g (Piątnica)	opakowanie	1	Lidl	123	14.4	0	16.5	700
120	Skyr Jogurt typu islandzkiego z mango i marakują 150g (Piątnica)	opakowanie	1	Świeże	123	14.4	0	16.5	700
122	Makaron conchiglie (Pastani)	g	100	Lidl	354	12	1.5	71	900
123	Tosty pszenny (Z dobrej piekarni)	kromka	1	Lidl	61	1.9	0.3	12.3	190
124	Kiełbasa krakowska sucha (Olewnik)	g	100	Lidl	130	32	8	1.2	650
125	Krewetki białe Vannamei (225g)	g	100	Lidl	90	20	1	0.5	810
127	Orzeszki ziemne prażone, niesolone (Alesto) 500g	g	100	Lidl	610	25.8	49.2	11.6	400
128	Burger wołowy Lidl (1 sztuka 110g)	sztuka	1	Lidl	240	20.9	16.5	1.1	500
105	Maliny świeże	g	100	Świeże	43	1.3	0.3	12	200
131	Pstrąg Tęczowy Łososiowy (Targ rybny)	g	100	Lidl	197	18.8	13.5	0	500
132	Ziemniaki	g	100	Lidl	87	1.9	0.1	20.5	200
133	Brokuły	g	100	Świeże	31	3	0.4	5.2	200
134	Serek Naturalny Bieluch (150g)	opakowanie	1	Na żywo	191	12.9	12.8	6	730
87	Makaron ryżowy wstążki	g	100	Lidl	350	6.2	0.1	81.3	900
129	Sos sojowy Tao Tao 150ml	g	100	Zapasy	27	3.8	0.1	2.7	360
72	Pieprz czarny mielony	szczypta	1	Zapasy	0	0	0	0	350
73	Marchew	g	100	Świeże	33	1	0.2	8.7	200
77	Tzatziki przyprawa	szczypta	1	Zapasy	0	0	0	0	350
89	Schab wieprzowy 9 plastrów (Rzeźnik)	g	100	Lidl	128	24	4	0	500
126	Kapusta pekińska	g	100	Świeże	16	1	0	3	200
169	Żurawina suszona 200g (Alesto)	g	100	Lidl	338	0.7	1.2	78	2000
150	Bułka z chia (Galeria Wypieków Lubaszka)	sztuka	1	Na żywo	279	9.9	8.46	38.7	2000
151	Kanapka z szarpaną wołowiną (Galeria Wypieków Lubaszka)	sztuka	1	Lidl	588	25	22.14	70.2	2000
121	Łowicz Dżem 100% owoców czarna porzeczka 210g (Łowicz)	g	100	Lidl	132	1.1	0.5	28	1205
136	Spaghetti pełnoziarniste (Combino)	g	100	Lidl	350	15.4	2.7	62	900
138	Kurkuma	szczypta	1	Lidl	0	0	0	0	350
139	Chińska mieszanka warzyw 450g (Proste Historie)	g	100	Lidl	28	1.6	0.3	3.4	815
140	Ryż jaśminiowy	g	100	Lidl	349	6.8	0.8	78	900
141	Chilli świeże lub suszone	g	100	Świeże	0	0	0	0	200
142	Limonka	g	30	Świeże	0	0	0	0	200
143	Wiśnie mrożone	g	100	Lidl	40	0.9	0.5	10	890
144	Ryżowe płatki błyskawiczne 500g (Melvit)	g	100	Lidl	350	7	0.4	79	1200
145	Płatki Jaglane (Crownfield)	g	100	Lidl	363	10	2.5	74	1200
146	Żywiecka wieprzowa ekstra (Pikok)	g	100	Lidl	224	24	14	0.6	600
147	Ricotta (Loviito)	g	100	Lidl	127	7.7	9	3.9	600
152	Serel wiejski lekki 3% tłusczu 200g (Pilos)	sztuka	1	Lidl	162	22	6	4.8	720
153	Szynka Filet wędzony z Piersi Indyka 100g (Pikok)	g	100	Lidl	138	20.7	5.4	1.7	600
154	Chrzan tarty (Kania) 190g	g	100	Lidl	171	2.4	10	17.5	2000
155	Budyń smak śmietankowy z cukerem 60g (Winiary)	porcja	1	Lidl	118	4.3	1.8	13.9	2000
157	Mąka pszenna typ 480	g	100	Lidl	350	12	1.5	71	2000
158	Koncentrat pomidorowy 90g (Pudliszki)	g	100	Lidl	442	4.9	0.8	18.2	2000
159	Galaretka o smaku truskawkowym (Dr Oetker) 72g i z tego wychodzi 572g galaretki (1 porcja)	porcja	1	Lidl	280	9.6	0	60	2000
160	Biszkopty z Pieczątką (Tastino)	g	100	Lidl	367	9.5	5.4	71	2000
162	Burak ćwikłowy	g	100	Świeże	43	1.6	0.2	10	2000
161	Pestki słonecznika 500g (Alesto)	g	100	Zapasy	616	21.4	53.9	5.1	2000
163	Ketchup pikantny (Pudliszki) 500g	g	100	Lidl	144	1.1	0.1	34	2000
164	Maliny świeże	g	100	Świeże	53	1.2	0.7	12	2000
165	Rodzynki Jumbo (Alesto)	g	100	Lidl	331	3	2	72	2000
166	Orzechy laskowe łuskane (Alesto)	g	100	Zapasy	658	15	61	6.7	2000
167	Kimchi ostre (Freshona)	g	100	Lidl	46	1.8	0.4	8	2000
148	Tuńczyk w puszce 170g (Nixe)	g	100	Lidl	109	25.4	0.8	0	2000
168	Mozarella light (Pilos) 125g	g	100	Lidl	157	19	8.5	1	2000
170	Białka jaj	g	100	Lidl	50	11	0.2	0.7	2000
171	Proszek do pieczenia	g	100	Lidl	53	0	0	28	2000
135	Curry przyprawa	szczypta	1	Zapasy	20	1	1	1	2000
149	Bułka orkiszowa	sztuka	1	Świeże	200	6.4	1.6	40	100
156	Erytrytol	g	100	Zapasy	0	0	0	0	2000
137	Orzechy nerkowca	g	100	Zapasy	554	18.2	43.8	30.4	400
99	Przyprawa meksykańska (Naturalny Koszyk)	g	100	Zapasy	218	9.3	5.8	19.6	350
172	Mąka kukurydziana biała PAN 1kg (google: Mąka kukurydziana precooked (Harina PAN))	g	100	Lidl	357	78	2	75.5	2000
173	Sałatka Awokado Rybak (Salad Story)	porcja	1	Na żywo	530	32.76	27.43	32.76	2000
174	Wrap Wołowina BBQ (Salad Story)	porcja	1	Na żywo	727.2	31	36	69.8	2000
175	Sałatka z kurczakiem 330g (Putka)	porcja	1	Na żywo	676.5	33	4	73	2000
176	ChaiKola	sztuka	1	Na żywo	118.8	0	0	28.7	2000
177	Clean białko (czyste, samo, pure)	g	100	Lidl	400	100	0	0	2000
178	Clean tłuszcz (czyste, samo, pure)	g	100	Lidl	900	0	100	0	2000
179	Clean węglowodany (czyste, samo, pure)	g	100	Lidl	400	0	0	100	2000
183	Sznka z fileta indyka (Pikok)	g	100	Lidl	115	19	3	2.7	2000
186	Majonez Lekki (Winiary)	g	100	Lidl	338	1.1	33.2	8.4	2000
184	Orzechy laskowe prażone (Alesto)	g	100	Zapasy	722	14.3	70.5	3.5	2000
185	Protein pillow o smaku karmelowym (Brownfield)	g	100	Lidl	437	20	18	52	2000
187	Schab pieczony 	g	100	Lidl	291	30.4	18.7	0.3	2000
\.


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.recipes (dish_id, time_total, what_before, preparation, when_start) FROM stdin;
76				
37				
19				
17				
24				
25				
34			Frytki i steka soczyście solisz.\n\nZ jogurtu, kapusty, soku z cytryny i pieprzu robisz sałatkę jak mama kiedyś :'(\n\n	
13			Ten przepis był dla mnie ciężki w przygotowaniu oraz ma słabe makro, gdyż mięso mielone wołowe jest mocno tłuste, kotlety trzeba lepić jakoś mi to nie wychodziło (mimo, że dobre w sumie, może kiedyś do niego wrócę)	
30				
16			Marchew zetrzyj, ser roladę ustrzycką zetrzyj	
26			Mirunę pieprzem przed. Cyk do piekarnika frytki też. Potem sos miliona jezior z jogurtu greckiego, musztardy i ketchupu.	
32				
40	ok. 35 min		1. Przygotowanie ryby:\n- Pstrąga umyj i osusz.\n- Do środka włóż plasterki cytryny, przeciśnięty czosnek i koperek.\n- Skrop oliwą (ok. 5 g) i posyp solą, pieprzem.\n2. Pieczenie:\n- Ryba: do piekarnika 190 °C, ok. 20–25 minut (w naczyniu żaroodpornym lub na papierze do pieczenia).\n- Ziemniaki: ugotuj w osolonej wodzie lub upiecz obok ryby, skropione resztą oliwy.\n3. Warzywa:\n- Brokuła podziel na różyczki, marchew na plastry. Ugotuj na parze ok. 8 minut, aż będą al dente.\n4. Podanie:\nNa talerzu ułóż ziemniaki, obok brokuła i marchew, a na wierzchu pstrąga.\nSkrop sokiem z cytryny.	
85			Zblenduj lub rozgnieć awokado z odrobiną soku z cytryny i szczyptą soli.\nPosmaruj nim 2 z 3 kromek chleba.\nUłóż szynkę, rukolę i pomidora.\nSkrop całość łyżeczką oliwy z oliwek.\nPopij 200 ml kefiru (probio).	
18				
6				
67			1. Ziemniaki dokładnie umyj, ugotuj w osolonej wodzie ok 20minut\n2. Łososia piecz\n3. W tym czasie przygotuj dip jogurtowy: jogurt + chrzan lub musztarga + koper + sokz z cytryny + szczypta soli\n	
36	ok. 25–30 minut		Ryż: ugotuj ryż (100 g suchego) według instrukcji (ok. 12 min).\nKurczak: pokrój filet w kostkę, dopraw solą i pieprzem. Usmaż na 6 g oliwy, aż będzie złoty.\nWarzywa: pokrój paprykę, cebulę i marchew w słupki/plastry. Dodaj na patelnię do kurczaka i podsmażaj 3–4 minuty.\nAnanas: dorzuć kostki ananasa, zamieszaj.\nSos słodko-kwaśny: wymieszaj w kubku sos sojowy, keczup, ocet i cukier/miód + 50 ml wody. Wlej na patelnię, duś całość 3–4 minuty, aż zgęstnieje.\nPodanie: podaj na ryżu.	
38				
96				
15				
68			1. Łososia posmaruj mieszanką sosu sojowego, czosnku i soku z limonki.\n2. Odstaw na 10–15 min, potem smaż lub piecz.\n3. W tym czasie ugotuj ryż jaśminowy.\n4. Podawaj z odrobiną chili i sokiem z limonki na wierzchu.	
20				
14				
39				
64			1. Makaron ryżowy zalej wrzątkiem i odstaw na 8–10 minut, aż zmięknie. Odcedź i przepłucz zimną wodą.\n2. Na 5 g oleju podsmaż drobno pokrojoną cebulę, czosnek i marchewkę (może być w julienne).\n3. Dodaj pokrojonego kurczaka, smaż do zarumienienia.\n4. Zsuń składniki na bok patelni, wbij jajko i zamieszaj, aż się zetnie.\n5. Dodaj makaron i sos sojowy + miód + sok z limonki (to Twoja wersja sosu Pad Thai).\n6. Wymieszaj wszystko i smaż jeszcze 2–3 minuty na średnim ogniu.\n7. Zdejmij z ognia, polej resztą oleju i posyp posiekanymi orzeszkami ziemnymi.\n8. Podaj z odrobiną świeżej kolendry lub szczypiorku.	
78				
2				
63			1. Podsmaż mięso na 5 g oleju, odstaw.\n2. Na tej samej patelni podsmaż cebulę, czosnek, marchew i kapustę.\n3. Dodaj przyprawę curry i łyżkę sosu sojowego.\n4. Wbij jajko i zamieszaj, aż się zetnie.\n5. Dorzuć mięso i pokrojone paski tortilli.\n6. Wlej 2–3 łyżki mleczka kokosowego (opcjonalnie) i smaż 1–2 minuty, mieszając jak „na wok”.\n7. Pod koniec polej resztą oleju i ewentualnie dopraw do smaku.	
69				
77				
5				
70				
35			Dwa burgery z jednego kotleta	
3				
71				
62				
72				
73				
54				
55				
56				
57				
58				
59				
60				
61				
74				
1				
33				
79				
80				
29				
83				
81				
86			Wrzuć składniki do miski zamiksuj, przelej do formy piecz 30-40minut.\n\nhttps://youtube.com/shorts/SspgxK9oPdY?si=BwNy4Kk_tkYL1las	
82				
84				
89				
42				
7				
90				
91				
92				
21				
93				
31				
95				
98				
75				
28				
102				
103				
104				
22			Oliwę wlej tak po prostu do michy, bo za suchei za mało fatu	
106				
107			Zblenduj lub rozgnieć awokado z odrobiną soku z cytryny i szczyptą soli.\nPosmaruj nim 2 z 3 kromek chleba.\nUłóż szynkę, rukolę i pomidora.\nSkrop całość łyżeczką oliwy z oliwek.\nPopij 200 ml kefiru (probio).	
105				
108				
109				
110				
111				
66				
112				
23				
113				
114				
115				
97				
87			Składniki na ciasto {serek wiejski 200g, jajko jedno, mąka 50g, przyprawy}.\n\nPiekarnik 220 grzej. Potem mieszasz ciasto i cyk na blaszke cieniutko uformowane koło i pieczemy 15 minut aż się przypiecze fajnie. Teraz smarowanie koncentratem i serem znowu do piekarnika na 5 minut, i cyk dodatki już na zimno\n\nhttps://www.tiktok.com/@orzechowskam/video/7494611420756053270	
88			https://www.tiktok.com/@orzechowskam/video/7490104352544247062\n\nZrób galaretke według przepisu (ale mniej ilości wody niż zakłada producent), ale nie ścinaj jeszcze. Z twarogu i skyra robisz masę blendowaniem. Połowę galaretki wlewasz do masy. Znowu miksujesz. Do foremki na dół układasz biszkopty i przelewasz na to masę w całości i odstawiasz do lodówki. Reszta galaretki też do lodowki. Oba na 30minut (ale sprawdzaj w trakcie, może być nawet 45 min. Potem dokładasz owoce, zalewasz galaretką i znowu do lodówki aż zastygnie max.	
65			1. Kurczaka pokrój w kostkę. W misce wymieszaj z sosem sojowym, miodem, imbirem, kurkumą, czosnkiem i szczyptą soli.\n2. Odstaw na 10–15 min, żeby się zamarynował.\n3. W tym czasie ugotuj makaron ryżowy (zalewając wrzątkiem na 8–10 min), następnie odcedź i przepłucz.\n4. Na dużej patelni lub woku rozgrzej 10 g oliwy, usmaż kurczaka na złoto z każdej strony.\n5. Dorzuć chińską mieszankę warzyw, smaż razem 5–6 min, aż warzywa będą gorące i lekko chrupiące.\n6. Dodaj makaron, pozostałe 5 g oliwy, nerkowce i ewentualnie kilka kropel sosu sojowego do smaku.\n7. Wymieszaj całość, smaż jeszcze 1–2 min, żeby wszystko się połączyło i miód lekko skarmelizował.	
94				
99				
100				
101				
116				
117				
118				
41	ok. 25–30 minut	nic – wszystko zrobisz na świeżo.	3. **Przygotowanie:**\n    - Komosę dobrze przepłucz i gotuj 12–15 minut w proporcji 1:2. Pod koniec dodaj 1/2 łyżki oliwy i sok z cytryny.\n    - Paprykę i cukinię pokrój w plastry i grilluj na patelni lub w piekarniku (ok. 10 minut, aż zmiękną i lekko się przypieką).\n    - Halloumi pokrój w plastry 1–1,5 cm, smaż na suchej patelni po ok. 1–2 minuty z każdej strony, aż się zarumieni.\n    - Podawaj na ciepło: komosa na spód, warzywa i halloumi na wierzchu. Posyp zieleniną i dopraw do smaku.	ok. 25–30 minut przed posiłkiem
120				
119				
121				
122				
123			https://www.tiktok.com/@orzechowskam/video/7503142575449345282\n\nDwie miski:\n- w jednej misce ubijasz na bardzo puszystą i bardzo sztywną pianę białka jaj i to jedno jajko\n- w drugiej ubijamy zaś resztę składników\n\nPotem puszystą pianę przenosisz delikatnie łyżką do tej drugiej miski i łączysz ze sobą obie masy ale łyżko (nie mikserem), żeby nie stracić puszystości. Potem tę masę cyk na suchą nagrzaną patelnie układasz po łyżce masy i smażysz po obu stronach.\n\nJak już widzisz po bokach, że na spodzie już jest takie fajne brązowe, to podważając najpierw sobie to na spokojnie z każdej strony robisz CYK OBROCIK.\n\n	
124			Ciasto\n- Do miski: 120 g mąki kukurydzianej + sól.\n- Stopniowo dodawaj 200–230 ml bardzo ciepłej wody + 100 g białek jaj.\n- Mieszaj → zagnieć → odstaw na 3-5 min (mąka pije wodę).\n- Uformuj 2 grube krążki (ok. 2 cm).\n\nKurczak - zamarynuj w jakiś przyprawach, usmaż na patelni, uduś z papryką.\n\nSmażenie\n- Patelnia średnia moc.\n- 1–2 min z każdej strony, aż zrobi się lekka skorupka.\n\nPieczenie / dopieczenie\n- Przerzuć na piekarnik 200°C, 8–10 min (to robi różnicę: będą puszyste i mokre w środku, chrupiące na zewnątrz) Aczkolwiek Victor dawał bezpośrednio z patelni i było puszyste oraz mokre.\n\nNadzienie\n- Kurczaka rozszarp widelcem.\n- Otwórz arepę nożem do połowy i wypełnij:\nnajpierw kurczak\n- Potem stracciatella	
125				
126				
127				
\.


--
-- Name: diet_labels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.diet_labels_id_seq', 1, false);


--
-- Name: diets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.diets_id_seq', 2, true);


--
-- Name: dish_labels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.dish_labels_id_seq', 6, true);


--
-- Name: dishes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.dishes_id_seq', 128, true);


--
-- Name: ingredient_labels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.ingredient_labels_id_seq', 1, false);


--
-- Name: ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.ingredients_id_seq', 189, true);


--
-- Name: counter day_ing_meal_unique; Type: CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.counter
    ADD CONSTRAINT day_ing_meal_unique UNIQUE (day, ingredient_id, meal);


--
-- Name: day_kcals day_kcals_pkey; Type: CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.day_kcals
    ADD CONSTRAINT day_kcals_pkey PRIMARY KEY (diet_id, day_num);


--
-- Name: diet_label_bridge diet_label_bridge_pkey; Type: CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.diet_label_bridge
    ADD CONSTRAINT diet_label_bridge_pkey PRIMARY KEY (diet_id, label_id);


--
-- Name: diet_labels diet_labels_pkey; Type: CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.diet_labels
    ADD CONSTRAINT diet_labels_pkey PRIMARY KEY (id);


--
-- Name: diet_slots diet_slots_pkey; Type: CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.diet_slots
    ADD CONSTRAINT diet_slots_pkey PRIMARY KEY (diet_id, slot_num);


--
-- Name: diets diets_pkey; Type: CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.diets
    ADD CONSTRAINT diets_pkey PRIMARY KEY (id);


--
-- Name: dish_label_bridge dish_label_bridge_pkey; Type: CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.dish_label_bridge
    ADD CONSTRAINT dish_label_bridge_pkey PRIMARY KEY (dish_id, label_id);


--
-- Name: dish_labels dish_labels_pkey; Type: CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.dish_labels
    ADD CONSTRAINT dish_labels_pkey PRIMARY KEY (id);


--
-- Name: dishes dishes_pkey; Type: CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.dishes
    ADD CONSTRAINT dishes_pkey PRIMARY KEY (id);


--
-- Name: ingredient_amounts ingredient_amounts_pkey; Type: CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.ingredient_amounts
    ADD CONSTRAINT ingredient_amounts_pkey PRIMARY KEY (dish_id, ingredient_id);


--
-- Name: ingredient_label_bridge ingredient_label_bridge_pkey; Type: CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.ingredient_label_bridge
    ADD CONSTRAINT ingredient_label_bridge_pkey PRIMARY KEY (ingredient_id, label_id);


--
-- Name: ingredient_labels ingredient_labels_pkey; Type: CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.ingredient_labels
    ADD CONSTRAINT ingredient_labels_pkey PRIMARY KEY (id);


--
-- Name: ingredients ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.ingredients
    ADD CONSTRAINT ingredients_pkey PRIMARY KEY (id);


--
-- Name: recipes recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (dish_id);


--
-- Name: day_kcals day_kcals_diet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.day_kcals
    ADD CONSTRAINT day_kcals_diet_id_fkey FOREIGN KEY (diet_id) REFERENCES public.diets(id) ON DELETE CASCADE;


--
-- Name: diet_context diet_context_active_diet_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.diet_context
    ADD CONSTRAINT diet_context_active_diet_fkey FOREIGN KEY (active_diet) REFERENCES public.diets(id);


--
-- Name: diet_label_bridge diet_label_bridge_diet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.diet_label_bridge
    ADD CONSTRAINT diet_label_bridge_diet_id_fkey FOREIGN KEY (diet_id) REFERENCES public.diets(id) ON DELETE CASCADE;


--
-- Name: diet_label_bridge diet_label_bridge_label_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.diet_label_bridge
    ADD CONSTRAINT diet_label_bridge_label_id_fkey FOREIGN KEY (label_id) REFERENCES public.diet_labels(id) ON DELETE CASCADE;


--
-- Name: diet_slots diet_slots_diet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.diet_slots
    ADD CONSTRAINT diet_slots_diet_id_fkey FOREIGN KEY (diet_id) REFERENCES public.diets(id) ON DELETE CASCADE;


--
-- Name: diet_slots diet_slots_dish_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.diet_slots
    ADD CONSTRAINT diet_slots_dish_id_fkey FOREIGN KEY (dish_id) REFERENCES public.dishes(id);


--
-- Name: dish_label_bridge dish_label_bridge_dish_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.dish_label_bridge
    ADD CONSTRAINT dish_label_bridge_dish_id_fkey FOREIGN KEY (dish_id) REFERENCES public.dishes(id) ON DELETE CASCADE;


--
-- Name: dish_label_bridge dish_label_bridge_label_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.dish_label_bridge
    ADD CONSTRAINT dish_label_bridge_label_id_fkey FOREIGN KEY (label_id) REFERENCES public.dish_labels(id) ON DELETE CASCADE;


--
-- Name: counter fk_ingredient; Type: FK CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.counter
    ADD CONSTRAINT fk_ingredient FOREIGN KEY (ingredient_id) REFERENCES public.ingredients(id) ON DELETE CASCADE;


--
-- Name: ingredient_amounts ingredient_amounts_dish_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.ingredient_amounts
    ADD CONSTRAINT ingredient_amounts_dish_id_fkey FOREIGN KEY (dish_id) REFERENCES public.dishes(id) ON DELETE CASCADE;


--
-- Name: ingredient_amounts ingredient_amounts_ingredient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.ingredient_amounts
    ADD CONSTRAINT ingredient_amounts_ingredient_id_fkey FOREIGN KEY (ingredient_id) REFERENCES public.ingredients(id) ON DELETE CASCADE;


--
-- Name: ingredient_label_bridge ingredient_label_bridge_ingredient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.ingredient_label_bridge
    ADD CONSTRAINT ingredient_label_bridge_ingredient_id_fkey FOREIGN KEY (ingredient_id) REFERENCES public.ingredients(id) ON DELETE CASCADE;


--
-- Name: ingredient_label_bridge ingredient_label_bridge_label_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.ingredient_label_bridge
    ADD CONSTRAINT ingredient_label_bridge_label_id_fkey FOREIGN KEY (label_id) REFERENCES public.ingredient_labels(id) ON DELETE CASCADE;


--
-- Name: recipes recipes_dish_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_dish_id_fkey FOREIGN KEY (dish_id) REFERENCES public.dishes(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

