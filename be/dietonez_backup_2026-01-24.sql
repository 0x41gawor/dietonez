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
-- Name: diet_slots_counter; Type: TABLE; Schema: public; Owner: kartezjusz
--

CREATE TABLE public.diet_slots_counter (
    diet_id integer NOT NULL,
    day date NOT NULL,
    meal public.meal_slot NOT NULL,
    name text,
    dish_id integer
);


ALTER TABLE public.diet_slots_counter OWNER TO kartezjusz;

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
    path numeric DEFAULT 2000 NOT NULL,
    is_present boolean DEFAULT false NOT NULL
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
2026-01-22	41	Pre-Workout	94
2026-01-19	24	Breakfast	120
2026-01-21	176	Pre-Workout	1
2026-01-19	25	Pre-Workout	40
2026-01-19	250	Pre-Workout	1
2026-01-19	186	Post-Workout	20
2026-01-19	1	Post-Workout	60
2026-01-19	251	Supper	94
2026-01-22	24	Breakfast	150
2026-01-22	51	Lunch	250
2026-01-22	42	Lunch	150
2026-01-22	52	Lunch	8
2026-01-22	17	Lunch	40
2026-01-22	76	Lunch	30
2026-01-20	51	Lunch	40
2026-01-20	202	Lunch	30
2026-01-20	248	Pre-Workout	2
2026-01-20	252	Pre-Workout	1
2026-01-20	122	Post-Workout	125
2026-01-20	251	Supper	94
2026-01-22	19	Lunch	20
2026-01-22	77	Lunch	1
2026-01-22	1	Pre-Workout	300
2026-01-22	11	Pre-Workout	10
2026-01-22	117	Post-Workout	1
2026-01-17	61	Lunch	2
2026-01-17	1	Lunch	100
2026-01-17	186	Lunch	40
2026-01-18	248	Pre-Workout	1
2026-01-18	249	Pre-Workout	1
2026-01-18	177	Post-Workout	40
2026-01-18	178	Post-Workout	60
2026-01-23	24	Breakfast	150
2026-01-18	179	Post-Workout	157.7
2026-01-23	1	Pre-Workout	300
2026-01-23	26	Pre-Workout	110
2026-01-23	41	Pre-Workout	50
2026-01-23	11	Pre-Workout	10
2026-01-24	24	Breakfast	150
2026-01-24	132	Lunch	350
2026-01-24	83	Lunch	150
2026-01-24	53	Lunch	50
2026-01-24	154	Lunch	30
2026-01-24	56	Lunch	5
2026-01-24	78	Lunch	10
2026-01-24	55	Lunch	5
2026-01-24	1	Pre-Workout	300
2026-01-24	26	Pre-Workout	110
2026-01-24	41	Pre-Workout	50
2026-01-24	14	Pre-Workout	150
2026-01-24	11	Pre-Workout	10
2026-01-24	102	Supper	40
2026-01-25	24	Breakfast	150
2026-01-25	172	Lunch	120
2026-01-25	42	Lunch	150
2026-01-25	170	Lunch	100
2026-01-25	147	Lunch	50
2026-01-25	17	Lunch	20
2026-01-25	55	Lunch	10
2026-01-25	71	Lunch	1
2026-01-25	72	Lunch	1
2026-01-25	159	Pre-Workout	1
2026-01-25	107	Pre-Workout	125
2026-01-25	1	Pre-Workout	150
2026-01-25	160	Pre-Workout	30
2026-01-25	29	Pre-Workout	100
2026-01-25	36	Pre-Workout	50
2026-01-25	204	Post-Workout	1
2026-01-25	208	Post-Workout	1
2026-01-25	212	Post-Workout	2
2026-01-25	213	Post-Workout	2
2026-01-25	102	Supper	40
2026-01-21	202	Post-Workout	30
2026-01-22	2	Breakfast	84
2026-01-21	52	Lunch	6
2026-01-21	56	Lunch	10
2026-01-21	78	Lunch	20
2026-01-21	71	Lunch	1
2026-01-22	23	Breakfast	200
2026-01-21	79	Lunch	1
2026-01-21	72	Lunch	1
2026-01-21	89	Lunch	150
2026-01-21	122	Lunch	120
2026-01-21	25	Lunch	50
2026-01-21	24	Breakfast	120
2026-01-22	102	Breakfast	44
2026-01-22	137	Breakfast	15
2026-01-22	1	Lunch	100
2026-01-22	177	Pre-Workout	5.1
2026-01-22	178	Pre-Workout	6.1
2026-01-22	179	Pre-Workout	31.9
2026-01-22	25	Pre-Workout	50
2026-01-23	51	Lunch	250
2026-01-23	42	Lunch	150
2026-01-23	52	Lunch	8
2026-01-23	17	Lunch	40
2026-01-23	76	Lunch	30
2026-01-23	19	Lunch	20
2026-01-23	77	Lunch	1
2026-01-23	1	Lunch	100
2026-01-24	26	Breakfast	90
2026-01-24	91	Breakfast	120
2026-01-19	26	Pre-Workout	170
2026-01-18	179	Lunch	115
2026-01-21	118	Post-Workout	1
2026-01-23	91	Lunch	120
2026-01-23	25	Pre-Workout	50
2026-01-23	115	Post-Workout	1
2026-01-19	52	Post-Workout	6
2026-01-19	201	Lunch	131
2026-01-19	200	Lunch	160
2026-01-19	178	Lunch	10
2026-01-19	1	Pre-Workout	300
2026-01-23	220	Post-Workout	5
2026-01-23	116	Post-Workout	0.8
2026-01-19	91	Pre-Workout	120
2026-01-19	56	Post-Workout	10
2026-01-19	78	Post-Workout	20
2026-01-19	71	Post-Workout	1
2026-01-19	79	Post-Workout	1
2026-01-19	72	Post-Workout	1
2026-01-20	118	Lunch	1
2026-01-20	27	Breakfast	200
2026-01-19	89	Post-Workout	150
2026-01-19	122	Post-Workout	120
2026-01-20	47	Post-Workout	140
2026-01-20	28	Post-Workout	30
2026-01-21	248	Pre-Workout	1
2026-01-20	54	Post-Workout	10
2026-01-20	55	Post-Workout	10
2026-01-20	71	Post-Workout	1
2026-01-20	72	Post-Workout	1
2026-01-17	25	Pre-Workout	40
2026-01-17	245	Pre-Workout	50
2026-01-17	246	Pre-Workout	40
2026-01-17	247	Post-Workout	25
2026-01-17	223	Post-Workout	1
2026-01-18	177	Lunch	36
2026-01-18	178	Lunch	62
2026-01-17	24	Breakfast	150
2026-01-17	83	Lunch	150
2026-01-17	52	Lunch	8
2026-01-17	57	Lunch	1
2026-01-17	1	Pre-Workout	300
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
3	0	2600
3	1	2600
2	24	2900
2	25	2900
2	26	2900
2	27	2900
2	28	2900
2	29	2900
2	30	2900
2	31	2900
2	32	2900
3	2	2600
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
3	3	2600
5	9	2900
5	0	2900
4	0	2700
4	1	2700
4	2	2700
4	3	2700
4	4	2700
4	5	2700
5	7	2900
5	8	2900
2	50	2900
2	51	2900
2	52	2900
2	53	2900
2	54	2900
2	55	2900
3	4	2600
3	5	2600
3	6	2600
3	7	2600
3	8	2600
3	9	2600
3	10	2600
3	11	2600
3	12	2600
3	13	2600
3	14	2600
3	15	2600
3	16	2600
3	17	2600
3	18	2600
3	19	2600
3	20	2600
3	21	2600
3	22	2600
3	23	2600
3	24	2600
3	25	2600
3	26	2600
3	27	2600
4	6	2700
5	55	2800
4	7	2700
4	8	2700
4	9	2700
4	10	2700
4	11	2700
5	1	2900
5	2	2900
5	3	2900
5	4	2900
5	5	2900
5	6	2800
4	12	2700
4	13	2700
5	10	2900
5	11	2900
5	12	2900
5	13	2800
5	14	2900
5	15	2900
5	16	2900
5	17	2900
5	18	2900
5	19	2900
5	20	2800
5	21	2900
5	22	2900
5	23	2900
5	24	2900
5	25	2900
5	26	2900
5	27	2800
5	28	2900
5	29	2900
5	30	2900
5	31	2900
5	32	2900
5	33	2900
5	34	2800
5	35	2900
5	36	2900
5	37	2900
5	38	2900
5	39	2900
5	40	2900
5	41	2800
5	42	2900
5	43	2900
5	44	2900
5	45	2900
5	46	2900
5	47	2900
5	48	2800
5	49	2900
5	50	2900
5	51	2900
5	52	2900
5	53	2900
5	54	2900
\.


--
-- Data for Name: diet_context; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.diet_context (active_diet, start_date, current_weight) FROM stdin;
3	2026-01-05	83.32
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
4	32	\N
4	33	\N
4	67	\N
4	68	\N
3	65	\N
3	66	\N
3	67	\N
3	68	\N
4	0	143
4	1	125
4	2	139
4	3	16
4	4	24
4	5	143
4	6	130
4	7	139
4	8	16
4	9	24
4	10	143
4	11	130
4	12	139
4	13	14
4	14	24
4	15	141
4	16	14
4	17	140
4	18	30
4	19	24
4	20	141
4	21	66
4	22	140
4	23	30
4	24	24
4	25	141
4	26	66
4	27	140
4	28	26
4	29	24
4	30	117
4	31	26
4	34	24
4	35	120
4	36	29
4	37	139
4	38	21
4	39	24
4	40	120
4	41	130
4	42	139
4	43	21
4	44	24
4	45	120
4	46	130
4	47	139
4	48	15
4	49	24
4	50	142
4	51	15
4	52	140
4	53	30
4	54	24
4	55	142
4	56	66
4	57	140
4	58	30
4	59	24
4	60	142
4	61	66
4	62	140
4	63	31
4	64	24
4	65	117
4	66	31
4	69	24
3	135	\N
3	136	\N
3	137	\N
3	138	\N
3	0	131
3	1	130
3	2	132
3	3	34
3	4	24
3	5	131
3	6	34
3	7	132
3	9	24
3	10	131
1	105	\N
1	106	\N
1	107	\N
1	108	\N
1	109	\N
1	111	\N
1	112	\N
1	18	63
1	2	5
3	8	\N
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
5	31	\N
5	32	\N
5	33	\N
5	66	\N
5	67	\N
5	68	\N
5	101	\N
5	102	\N
5	103	\N
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
3	11	125
3	12	132
3	13	15
3	14	24
3	15	137
3	16	15
3	17	133
3	18	30
3	19	24
3	20	137
3	21	64
3	22	133
3	23	32
3	24	24
3	25	137
3	26	68
3	27	133
3	28	68
3	29	24
3	30	137
3	31	124
3	32	88
3	33	135
3	34	24
3	35	131
3	36	29
3	37	72
3	38	23
3	39	24
3	40	131
3	41	23
3	42	72
3	43	35
3	44	24
3	45	131
3	46	35
3	47	72
3	48	14
3	49	24
3	50	137
3	51	14
3	52	3
3	53	30
3	54	24
3	55	137
3	56	63
3	57	3
3	58	138
3	59	24
3	60	137
3	61	18
3	62	3
3	63	18
3	64	24
3	69	24
3	70	131
3	71	130
3	72	132
3	73	37
3	74	24
3	75	131
3	76	37
3	77	132
3	78	19
3	79	24
3	80	131
3	81	19
3	82	132
3	83	17
3	84	24
3	85	137
3	86	17
3	87	133
3	88	30
3	89	24
3	90	137
3	91	38
3	92	133
3	93	32
3	94	24
3	95	137
3	96	67
3	97	133
3	98	67
3	99	24
3	100	137
3	101	124
3	102	88
3	103	134
3	104	24
3	105	131
3	106	28
3	107	72
3	108	62
3	109	24
3	110	131
3	111	62
3	112	72
3	113	21
3	114	24
3	115	131
3	116	21
3	117	72
3	118	39
3	119	24
3	120	137
3	121	39
3	122	136
3	123	30
3	124	24
3	125	137
3	126	65
3	127	136
3	128	32
3	129	24
3	130	137
3	131	66
3	132	136
3	133	66
3	134	24
3	139	24
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
5	136	\N
5	137	\N
5	138	\N
5	171	\N
5	172	\N
5	173	\N
5	206	\N
5	207	\N
5	208	\N
5	241	\N
5	242	\N
5	243	\N
5	276	\N
5	277	\N
5	278	\N
5	0	150
5	1	130
5	2	151
5	3	23
5	4	24
5	5	144
5	6	23
5	7	151
5	8	21
5	9	24
5	10	144
5	11	21
5	12	151
5	13	65
5	14	24
5	15	149
5	16	64
5	17	153
5	18	30
5	19	24
5	20	149
5	21	64
5	22	153
5	23	134
5	24	24
5	25	141
5	26	68
5	27	153
5	28	68
5	29	24
5	30	141
5	34	24
5	35	150
5	36	28
5	37	151
5	38	34
5	39	24
5	40	147
5	41	34
5	42	151
5	43	19
5	44	24
5	45	147
5	46	19
5	47	151
5	48	39
5	49	24
5	50	146
5	51	15
5	52	154
5	53	30
5	54	24
5	55	146
5	56	15
5	57	154
5	58	135
5	59	24
5	60	143
5	61	66
5	62	154
5	63	66
5	64	24
5	65	143
5	69	24
5	70	150
5	71	130
5	72	151
5	73	62
5	74	24
5	75	144
5	76	62
5	77	151
5	78	16
5	79	24
5	80	144
5	81	16
5	82	151
5	83	63
5	84	24
5	85	149
5	86	14
5	87	155
5	88	30
5	89	24
5	90	149
5	91	14
5	92	155
5	93	134
5	94	24
5	95	113
5	96	18
5	97	155
5	98	18
5	99	24
5	100	113
5	104	24
5	105	150
5	106	29
5	107	151
5	108	35
5	109	24
5	110	147
5	111	35
5	112	151
5	113	31
5	114	24
5	115	147
5	116	31
5	117	151
5	118	36
5	119	24
5	120	146
5	121	17
5	122	156
5	123	30
5	124	24
5	125	146
5	126	17
5	127	156
5	128	135
5	129	24
5	130	122
5	131	67
5	132	156
5	133	67
5	134	24
5	135	122
5	139	24
5	140	150
5	141	130
5	142	151
5	143	23
5	144	24
5	145	144
5	146	23
5	147	151
5	148	38
5	149	24
5	150	144
5	151	38
5	152	151
5	153	64
5	154	24
5	155	149
5	156	65
5	157	153
5	158	30
5	159	24
5	160	149
5	161	65
5	162	153
5	163	134
5	164	24
5	165	142
5	166	68
5	167	153
5	168	68
5	169	24
5	170	142
5	174	24
5	175	150
5	176	29
5	177	151
5	178	34
5	179	24
5	180	147
5	181	34
5	182	151
5	183	152
5	184	24
5	185	147
5	186	152
5	187	151
5	188	15
5	189	24
5	190	146
5	191	39
5	192	154
5	193	30
5	194	24
5	195	146
5	196	39
5	197	154
5	198	135
5	199	24
5	200	143
5	201	66
5	202	154
5	203	66
5	204	24
5	205	143
5	209	24
5	210	150
5	211	130
5	212	151
5	213	62
5	214	24
5	215	144
5	216	62
5	217	151
5	218	22
5	219	24
5	220	144
5	221	22
5	222	151
5	223	14
5	224	24
5	225	149
5	226	63
5	227	155
5	228	30
5	229	24
5	230	149
5	231	63
5	232	155
5	233	134
5	234	24
5	235	113
5	236	18
5	237	155
5	238	18
5	239	24
5	240	113
5	244	24
5	245	150
5	246	28
5	247	151
5	248	35
5	249	24
5	250	148
5	251	35
5	252	151
5	253	26
5	254	24
5	255	147
5	256	26
5	257	151
5	258	17
5	259	24
5	260	146
5	261	36
5	262	156
5	263	30
5	264	24
5	265	146
5	266	36
5	267	156
5	268	135
5	269	24
5	270	122
5	271	67
5	272	156
5	273	67
5	274	24
5	275	122
5	279	24
\.


--
-- Data for Name: diet_slots_counter; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.diet_slots_counter (diet_id, day, meal, name, dish_id) FROM stdin;
2	2025-12-23	Pre-Workout	M 3 Skyr + 2Banany&Jabłko	5
2	2025-12-23	Post-Workout	12M Wołowina stek - z frytkami	34
2	2025-12-31	Lunch	40M Hallouumi - quinoa + grillowana papryka	41
2	2025-12-25	Pre-Workout	M 7 Skyr - Wiśnie&Orzechy	72
2	2025-12-31	Post-Workout	\N	\N
2	2025-12-25	Breakfast	12A Jaglanka- banan&orzechy laskowe	100
2	2025-12-26	Breakfast	12A Jaglanka- banan&orzechy laskowe	100
2	2025-12-24	Pre-Workout	M 3 Skyr + 2Banany&Jabłko	5
2	2025-12-22	Lunch	11M Wieprzowina schab – pieczony z ziołami	22
2	2025-12-22	Breakfast	12A Jaglanka- banan&orzechy laskowe	100
2	2025-12-22	Post-Workout	12M Wołowina stek - z frytkami	34
2	2025-12-24	Post-Workout	13M Wątróbka - klasyczek cebula	23
2	2025-12-24	Supper	custom	\N
2	2025-12-27	Lunch	33M Łosoś - Ziemniory	67
2	2025-12-29	Pre-Workout	M 0 Skyr - Miód + Banan&Jabłko	1
2	2025-12-23	Supper	Masakra	25
2	2025-12-30	Pre-Workout	M 0 Skyr - Miód + Banan&Jabłko	1
2	2025-12-31	Pre-Workout	M 0 Skyr - Miód + Banan&Jabłko	1
2	2026-01-01	Breakfast	40M Kanapki - Masło orzechowe & Banan Marchew obok	106
2	2026-01-01	Lunch	20M Kurczak filet - Asian Stri-Fry 	65
2	2026-01-01	Pre-Workout	M 4 Skyr - 2banany&migdały	70
2	2026-01-01	Post-Workout	20M Kurczak filet - Pad thai 	64
2	2026-01-01	Supper	Kazeina	24
2	2026-01-02	Post-Workout	FF Double Zinger (KFC)	30
2	2025-12-22	Pre-Workout	M 6 Skyr - Peanut Butter + Banan	3
2	2026-01-02	Lunch	\N	\N
2	2025-12-22	Supper	chuj	\N
2	2025-12-23	Breakfast	12M Jaglanka- rnel	99
2	2025-12-25	Post-Workout	20M Kurczak filet - Penne&Pesto 	38
2	2025-12-25	Supper	Kazeina	24
2	2025-12-24	Breakfast	12A Jaglanka- banan&orzechy laskowe	100
2	2025-12-24	Lunch	12M Wołowina stek - z frytkami	34
2	2026-01-02	Pre-Workout	M 0 Skyr - Miód + Banan&Jabłko	1
2	2026-01-02	Supper	\N	\N
2	2026-01-02	Breakfast	Sałatka łososiowa mamy z chlebem i szynką	\N
2	2026-01-03	Breakfast	\N	\N
2	2025-12-23	Lunch	12M Wołowina stek - z frytlami	34
2	2025-12-26	Lunch	20M Kurczak filet - Penne&Pesto 	38
2	2025-12-26	Pre-Workout	M 7 Skyr - Wiśnie&Orzechy	72
2	2025-12-26	Post-Workout	FF Kebab King mały lawasz kurczak bez sosu	32
2	2025-12-26	Supper	Kazeina	24
2	2025-12-27	Breakfast	11M Owsianka - jagodowa	103
2	2025-12-27	Pre-Workout	M 7 Skyr - Wiśnie&Orzechy	72
2	2025-12-27	Post-Workout	33M Łosoś - Ziemniaki w mundurkach z dipem	67
2	2025-12-27	Supper	Kazeina	24
2	2026-01-03	Lunch	Obiad u mamy kurczak, ziemniaki	\N
2	2025-12-25	Lunch	12M Wołowina stek - z frytlami	34
3	2026-01-12	Breakfast	Weź suple po obiedzie (kiwi)	131
2	2026-01-04	Supper	\N	\N
2	2025-12-29	Lunch	31M Miruna - kluski&dżem	31
2	2026-01-03	Pre-Workout	Skyr musli i miodek	70
2	2026-01-05	Pre-Workout	M 1 Skyr - Miód kakao banan	69
2	2025-12-30	Post-Workout	40M Hallouumi - quinoa + grillowana papryka	41
2	2026-01-03	Supper	\N	\N
2	2025-12-31	Supper	Kazeina	24
2	2025-12-28	Breakfast	\N	\N
2	2025-12-29	Breakfast	Empty	\N
2	2025-12-30	Breakfast	Empty	\N
2	2025-12-31	Breakfast	Empty	\N
2	2025-12-29	Post-Workout	FF Double Zinger (KFC)	30
2	2025-12-29	Supper	\N	\N
2	2025-12-30	Lunch	31M Miruna - kluski&dżem	31
2	2025-12-30	Supper	\N	\N
2	2026-01-03	Post-Workout	Nachos	\N
2	2026-01-05	Supper	Kazeina	24
2	2026-01-05	Lunch	FF - Lawasz z kurczakiem 160g (W Bułce)	130
2	2026-01-04	Breakfast	zapiekanka orlen	\N
2	2026-01-04	Lunch	Kołacz	\N
3	2026-01-12	Pre-Workout	M 7 Skyr - Wiśnie&Orzechy	72
2	2026-01-04	Pre-Workout	sushi rainbow	\N
2	2026-01-04	Post-Workout	Cappy pomarańcza	\N
2	2026-01-05	Post-Workout	Szynka smażona	\N
2	2026-01-05	Breakfast	pierrot	\N
3	2026-01-11	Breakfast	Weź suple po obiedzie (pomarańcza)	137
3	2026-01-11	Pre-Workout	XJ2 - Jebaniec na zimno (sernik)	88
3	2026-01-11	Post-Workout	FF Subway nowe smaki	135
3	2026-01-11	Supper	Kazeina	24
2	2026-01-06	Breakfast	\N	\N
2	2026-01-06	Post-Workout	\N	\N
2	2026-01-08	Breakfast	\N	\N
2	2026-01-06	Lunch	\N	\N
3	2026-01-07	Lunch	12M Wołowina stek - z frytkami	34
3	2026-01-06	Post-Workout	Pizza i Pringlesy	\N
3	2026-01-06	Pre-Workout	Skyr z Puchatkiem	3
3	2026-01-07	Pre-Workout	Skyr z Puchatkiem	3
2	2026-01-06	Pre-Workout	\N	\N
3	2026-01-06	Breakfast	Kiełbasa z cebulą	\N
2	2026-01-07	Breakfast	\N	\N
2	2026-01-07	Lunch	\N	\N
2	2026-01-08	Lunch	\N	\N
2	2026-01-07	Pre-Workout	\N	\N
2	2026-01-07	Supper	\N	\N
2	2026-01-07	Post-Workout	\N	\N
2	2026-01-08	Pre-Workout	\N	\N
2	2026-01-08	Supper	\N	\N
2	2026-01-08	Post-Workout	\N	\N
3	2026-01-06	Supper	\N	\N
2	2026-01-06	Supper	\N	\N
3	2026-01-07	Post-Workout	20M Kurczak filet - Tikka Masala 	15
2	2026-01-09	Supper	\N	\N
2	2026-01-10	Breakfast	\N	\N
2	2026-01-10	Lunch	\N	\N
2	2026-01-10	Pre-Workout	\N	\N
3	2026-01-12	Lunch	FF Lawasz z kurczakiem 160g (W Bułce)	130
3	2026-01-11	Lunch	żabka	\N
2	2026-01-09	Breakfast	\N	\N
2	2026-01-09	Lunch	\N	\N
2	2026-01-09	Pre-Workout	\N	\N
2	2026-01-09	Post-Workout	\N	\N
2	2026-01-10	Post-Workout	\N	\N
2	2026-01-10	Supper	\N	\N
3	2026-01-06	Lunch	\N	\N
3	2026-01-12	Supper	\N	\N
3	2026-01-12	Post-Workout	Popeys con Damie	\N
3	2026-01-07	Breakfast	Weź suple po obiedzie (kiwi)	131
3	2026-01-24	Post-Workout	\N	\N
3	2026-01-18	Lunch	pierogi z dzika + ciasto półkruche	\N
3	2026-01-17	Supper	\N	\N
3	2026-01-17	Post-Workout	zabka rollo	\N
3	2026-01-08	Breakfast	Weź suple po obiedzie (pomarańcza)	137
3	2026-01-08	Pre-Workout	M 5 Skyr Pro - Maliny&Chia + Banan	133
3	2026-01-08	Post-Workout	FF Double Zinger (KFC)	30
3	2026-01-18	Pre-Workout	batonik i skyr	\N
3	2026-01-18	Post-Workout	gyoza i bean katsu	\N
3	2026-01-18	Supper	\N	\N
3	2026-01-10	Breakfast	Weź suple po obiedzie (pomarańcza)	137
3	2026-01-10	Pre-Workout	M 5 Skyr Pro - Maliny&Chia + Banan	133
3	2026-01-20	Lunch	FF Kebab King mały lawasz kurczak bez sosu	32
3	2026-01-20	Pre-Workout	carrefour	\N
3	2026-01-19	Supper	napoleonka	\N
3	2026-01-20	Supper	napoleonka	\N
3	2026-01-21	Breakfast	Weź suple po obiedzie (kiwi)	131
3	2026-01-09	Breakfast	Weź suple po obiedzie (pomarańcza)	137
3	2026-01-21	Pre-Workout	M 8 Skyr + miód + musli	132
3	2026-01-09	Pre-Workout	M 5 Skyr Pro - Maliny&Chia + Banan	133
3	2026-01-13	Breakfast	Weź suple po obiedzie (kiwi)	131
3	2026-01-13	Pre-Workout	M 7 Skyr - Wiśnie&Orzechy	72
3	2026-01-13	Supper	Kazeina	24
3	2026-01-05	Supper	Kazeina	24
3	2026-01-07	Supper	\N	\N
3	2026-01-08	Lunch	20M Kurczak filet - Tikka Masala 	15
3	2026-01-08	Supper	\N	\N
3	2026-01-09	Lunch	12M Wołowina stek - z frytkami	34
3	2026-01-21	Lunch	11M Wieprzowina schab - Śmietankowo-Koperkowy	37
3	2026-01-09	Post-Workout	FF Kebab King mały lawasz kurczak bez sosu	32
3	2026-01-09	Supper	\N	\N
3	2026-01-10	Lunch	FF Kebab King mały lawasz kurczak bez sosu	32
3	2026-01-22	Breakfast	Weź suple po obiedzie (pomarańcza)	137
3	2026-01-14	Breakfast	Weź suple po obiedzie (kiwi)	131
3	2026-01-14	Pre-Workout	M 7 Skyr - Wiśnie&Orzechy	72
3	2026-01-14	Supper	Kazeina	24
3	2026-01-10	Post-Workout	Lasagne mamy	\N
3	2026-01-10	Supper	\N	\N
3	2026-01-13	Lunch	FF Sałatka Cezar Duża + Bułka z chia	29
3	2026-01-13	Post-Workout	13M Wątróbka - klasyczek cebula	23
3	2026-01-14	Lunch	13M Wątróbka - klasyczek cebula	23
3	2026-01-14	Post-Workout	12M Wołowina kotlet - dwa burger + frytki	35
3	2026-01-15	Breakfast	Weź suple po obiedzie (pomarańcza)	137
3	2026-01-15	Lunch	20M Kurczak filet - Wrap	14
3	2026-01-15	Pre-Workout	M 6 Skyr - Peanut Butter + Banan	3
3	2026-01-15	Post-Workout	FF Double Zinger (KFC)	30
3	2026-01-16	Breakfast	Weź suple po obiedzie (pomarańcza)	137
3	2026-01-17	Breakfast	Weź suple po obiedzie (pomarańcza)	137
3	2026-01-17	Lunch	33M Łosoś - Salsa awokado	18
3	2026-01-17	Pre-Workout	M 6 Skyr - Peanut Butter + Banan	3
3	2026-01-22	Lunch	20M Kurczak filet - Gyros	17
3	2026-01-22	Pre-Workout	M 5 Skyr Pro - Maliny&Chia + Banan	133
3	2026-01-15	Supper	\N	\N
3	2026-01-16	Lunch	20M Kurczak filet - Wrap	14
3	2026-01-22	Post-Workout	FF Double Zinger (KFC)	30
3	2026-01-16	Pre-Workout	M 5 Skyr - Maliny&Chia + Banan	2
3	2026-01-16	Supper	kiełba z bułką	\N
3	2026-01-16	Post-Workout	cinema city	\N
3	2026-01-19	Breakfast	Weź suple po obiedzie (kiwi)	131
3	2026-01-19	Lunch	FF Lawasz z kurczakiem 160g (W Bułce)	130
3	2026-01-19	Pre-Workout	M 8 Skyr + miód + musli	132
3	2026-01-19	Post-Workout	11M Wieprzowina schab - Śmietankowo-Koperkowy	37
3	2026-01-20	Breakfast	Weź suple po obiedzie (kiwi)	131
3	2026-01-20	Post-Workout	31M Dorsz filet - cytrynowo-pietruszkowy	19
3	2026-01-23	Breakfast	Weź suple po obiedzie (pomarańcza)	137
3	2026-01-23	Pre-Workout	M 5 Skyr Pro - Maliny&Chia + Banan	133
3	2026-01-24	Breakfast	Weź suple po obiedzie (pomarańcza)	137
3	2026-01-24	Lunch	33M Łosoś - Ziemniaki w mundurkach z dipem	67
3	2026-01-24	Pre-Workout	M 5 Skyr Pro - Maliny&Chia + Banan	133
3	2026-01-24	Supper	Kazeina	24
3	2026-01-25	Breakfast	Weź suple po obiedzie (pomarańcza)	137
3	2026-01-25	Lunch	XJ2 - Arepas de Victor	124
3	2026-01-25	Pre-Workout	XJ2 - Jebaniec na zimno (sernik)	88
3	2026-01-25	Post-Workout	FF Subway klasyczek	134
3	2026-01-25	Supper	Kazeina	24
3	2026-01-21	Post-Workout	FF Kebab King mały lawasz kurczak bez sosu	32
3	2026-01-21	Supper	\N	\N
3	2026-01-22	Supper	\N	\N
3	2026-01-23	Lunch	20M Kurczak filet - Gyros	17
3	2026-01-23	Post-Workout	\N	\N
3	2026-01-23	Supper	\N	\N
\.


--
-- Data for Name: diets; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.diets (id, name, descr) FROM stdin;
3	Janmadan2026	Rekomp 2600 post przerywany
2	Lean Bulk Zeta	Baza 2900, adjust w trakcie
4	Ilness-fallback	2700 kcal TDEE (na 8k kroków) i łatwe/szybkie/smaczne dania
1	Reverse Diet 	Reverse diet przed Sri-Lanka
5	Masa	Lean bulk 2900 +0.18kg/week
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
38	MainMeal	11M Wieprzowina schab - Penne&Pesto 	
148	Breakfast	LCPA - łosoś/kiwi/kefir	
22	MainMeal	11M Wieprzowina schab – Pieczony z ziołami	
24	Supper	Kazeina	
25	Supper	Twaróg klinek chudy	
37	MainMeal	Archived 11M Wieprzowina schab - Śmietankowo-Koperkowy	
90	Breakfast	32M Jajecznica - Mexicano + pomarańcza&pestki dyni	
54	MainMeal	11A Red Meat - Pork - (schab, polędwiczka)	
1	Pre-Workout	M 0 Skyr - Miód + Banan&Jabłko	
20	MainMeal	40M Krewetki - masło/czosnek	
30	MainMeal	FF Double Zinger (KFC)	
88	Pre-Workout	XJ2 - Jebaniec na zimno (sernik)	
17	MainMeal	20M Kurczak filet - Gyros	
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
42	Breakfast	FF Bajgiel i bieluch	
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
98	Breakfast	24M Tosty - Ricotta + banan&kakao&chia	
96	Breakfast	21M Tosty - Konserwowa + shake(masło orzechowe&truskawki	
73	Breakfast	11A Owsianka	
65	MainMeal	20M Kurczak filet - Asian Stri-Fry 	
67	MainMeal	33M Łosoś - Ziemniaki w mundurkach z dipem	
80	Breakfast	40A Kanapki	
6	Breakfast	31A Jajecznica - Tuńczyk	
35	MainMeal	12M Wołowina kotlet - dwa burger + frytki	
68	MainMeal	33M Łosoś - Chilli-limonka z ryżem	
76	Breakfast	22A Tosty - Krakowska	
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
149	Breakfast	LCPA - twaróg/kiwi/kefir	
21	MainMeal	11M Wieprzowina polędwiczka - Musztardowo-miodowa	
155	Pre-Workout	PW HOME2 Skyr/Musli-Miód/Polifenole/Mikro	
156	Pre-Workout	PW HOME3 Skyr/Musli-Miód/Polifenole/Mikro	
147	Breakfast	LCPA - jaja/kiwi/kefir	
121	Breakfast	13M Ryżanka - truskawki/miód/kakao	
150	Breakfast	FF Mlekovita SBA + bieluch	
122	Breakfast	11M Owsianka - żurawinowa	
152	MainMeal	31M Dorsz - ryż/warzywa	
123	Pre-Workout	XJ3 - Jebańcowe obłoczki	
124	MainMeal	XJ2 - Arepas de Victor	
28	MainMeal	FF Sałatka Cobb Duża + Bułka z chia	
125	MainMeal	FF Sałatka Awokado Rybak Duża + Bułka z chia	
127	MainMeal	FF Sałatka z kurczakiem (Putka)	
151	Pre-Workout	PW WORK Skyr/Banan/Polifenole/Bułka	
130	MainMeal	FF Lawasz z kurczakiem 160g (W Bułce)	
133	Pre-Workout	M 5 Skyr Pro - Maliny&Chia + Banan	
134	MainMeal	FF Subway klasyczek	
135	MainMeal	FF Subway nowe smaki	
131	Breakfast	Weź suple po obiedzie (kiwi)	
137	Breakfast	Weź suple po obiedzie (pomarańcza)	
132	Pre-Workout	M 8 Skyr + miód + musli	
136	Pre-Workout	M 8 Skyr + Truskawki mrożone + miód	
126	MainMeal	FF Wrap Wołowina BBQ 	
138	MainMeal	FF Nachos Sanwich bez sosu (Kebab King)	
139	Pre-Workout	Skyr + pomarańcza	
140	Pre-Workout	Skyr + kiwi	
141	Breakfast	24M Tosty - Ricotta + banan&kakao&chia - lean	
142	Breakfast	24M Tosty - Ricotta  + miód&maliny&migdały - lean	
143	Breakfast	11M Owsianka - jagodowa - lean	
154	Pre-Workout	PW HOME1 Skyr/Musli-Miód/Polifenole/Mikro	
153	Pre-Workout	PW HOME0 Skyr/Musli-Miód/Polifenole/Mikro	
144	Breakfast	LCPA - jaja/pomarańcz/kefir	
145	Breakfast	LCPA - twaróg/pomarańcz/kefir	
146	Breakfast	LCPA - łosoś/pomarańcz/kefir	
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
142	123	6
77	5	6
77	6	3
77	146	50
142	147	100
142	164	120
36	129	10
107	8	2
142	25	20
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
72	1	300
72	26	100
72	143	150
72	25	50
72	10	10
72	91	150
3	1	300
3	26	110
3	39	30
3	73	120
136	1	300
136	25	50
136	26	90
136	29	100
136	91	120
136	197	50
138	198	1
140	1	300
140	27	100
118	123	6
118	6	2
110	4	4
110	149	1
110	148	100
110	27	100
110	12	15
118	147	100
118	24	100
69	1	300
32	118	1
69	25	40
69	16	20
69	26	80
71	1	300
71	27	200
71	26	100
71	31	10
74	145	100
74	4	1
74	3	100
143	2	100
87	6	2
87	152	1
87	158	60
87	157	50
87	4	1
87	38	50
87	9	30
143	3	200
143	4	1
143	106	100
78	5	6
78	6	3
78	9	50
81	151	1
81	134	1
81	27	100
145	107	150
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
145	23	150
145	24	120
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
146	253	100
146	23	200
146	24	120
147	4	3
147	23	200
147	27	100
149	107	150
149	23	150
149	27	100
148	23	200
148	253	100
31	126	100
148	27	100
150	252	1
150	134	1
31	73	50
150	27	100
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
151	1	300
151	164	250
67	56	5
67	78	10
67	55	5
151	26	180
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
151	199	1
1	1	300
1	26	160
1	91	150
1	25	20
153	1	300
153	36	200
153	25	45
153	11	10
153	16	10
153	197	60
154	1	300
154	197	60
154	143	150
154	12	10
154	31	10
154	25	45
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
17	51	250
17	42	150
17	22	100
17	52	8
17	17	40
17	76	30
17	19	20
17	77	1
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
38	130	150
130	201	131
130	200	160
130	178	10
134	208	1
134	204	1
134	213	2
134	212	2
135	210	1
135	207	1
135	214	2
135	215	2
38	89	100
38	80	40
38	30	100
38	10	10
38	56	20
38	52	8
131	27	200
137	24	150
132	1	300
132	197	50
132	25	50
132	26	90
132	91	120
139	1	300
139	24	150
38	71	1
38	79	2
38	72	1
152	47	150
152	44	150
152	78	10
152	139	100
152	79	1
152	71	1
152	72	1
155	1	300
155	197	60
155	143	150
155	25	45
155	137	10
155	11	10
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
144	4	3
144	23	200
114	5	6
114	6	3
114	146	50
114	23	100
114	167	100
114	30	50
114	24	100
144	24	120
42	110	1
42	134	1
115	5	6
115	6	3
115	146	50
115	23	100
115	106	100
115	31	10
42	27	100
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
30	117	1
30	116	1
21	89	100
21	85	120
21	91	150
21	25	30
21	52	8
98	6	3
98	147	100
98	26	100
98	11	10
98	16	10
98	123	6
21	59	20
21	71	1
21	90	1
79	123	6
79	6	2
79	147	100
21	72	1
133	1	300
133	26	110
133	41	50
133	14	150
117	123	6
117	6	2
117	147	100
117	27	100
117	23	100
117	166	15
117	30	50
133	11	10
156	1	300
97	6	2
97	147	100
97	164	120
97	15	15
97	25	20
97	123	6
156	197	60
156	143	150
156	25	45
156	15	12
156	31	10
141	123	6
141	147	100
141	26	100
141	11	10
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

COPY public.ingredients (id, name, unit, default_amount, shop_style, kcal, proteins, fats, carbs, path, is_present) FROM stdin;
55	Sok z cytryny (Citromle)	g	100	Lidl	13	0	0	3.2	2000	f
60	Ketchu pikantny (Pudliszki)	g	100	Lidl	144	1.1	0.1	3.4	2000	f
2	Płatki owsiane górskie (Crownfield)	g	100	Lidl	354	12.5	6.3	55.9	1200	f
3	Mleko UHT 1.5% tłuszczu (Mleczna Dolina)	g	100	Lidl	46	3.3	1.5	4.8	790	f
4	Jaja kurze (60g)	sztuka	1	Lidl	84	7.5	5.8	0.4	1100	f
6	Regionalne szlaki Rolada Ustrzycka Wędzona (1 plaster 20g)	porcja	1	Lidl	58	5	4	0.4	680	f
7	Krakus Kiełbasa Krakowska sucha z szynki 144g (2x72g)	g	100	Lidl	182	31	6.3	0.3	650	f
8	Chleb Żytni z Ziarnami Żyta krojony (Piekarnia Lidla) (1 kromka 90g)	kromka	1	Lidl	180	4.8	1.3	33.3	100	f
9	Szynka konserwowa wieprzowa (Pikok)	g	100	Lidl	99	19	1.6	2	610	f
12	Pestki dyni (Alesto)	g	100	Zapasy	579	24.4	45.6	15.2	410	t
31	Siemię lniane (Witpak)	g	100	Zapasy	507	25	31	39	400	t
56	Czosnek	g	100	Świeże	152	6.4	0.5	32.6	200	f
14	Maliny mrożone (Lidl)	g	100	Lidl	49	1.3	0.3	5.3	890	f
15	Migdały	g	100	Zapasy	604	24.1	52	20.5	400	f
17	Papryka czerwona	g	100	Świeże	32	1.3	0.5	6.6	200	f
18	Rukola	g	100	Świeże	25	2.6	0.7	3.6	200	f
19	Pomidor	g	100	Świeże	19	0.9	0.2	4.1	200	f
20	Ogórek kiszony	g	100	Świeże	13	1.1	0.1	1.4	310	f
21	Sałata lodowa (Asda)	g	100	Świeże	14	1.2	0.5	1.4	200	f
22	Jogur grecki XXL (Pilos)	g	100	Lidl	123	3.6	10	4.7	730	f
23	Kefir (Robico)	g	100	Lidl	47	3	2	4.2	740	f
24	Pomarańcza	g	100	Świeże	47	0.9	0.2	11.3	200	f
25	Miód lipowy (Bartnik)	g	100	Lidl	333	0.3	0	83	1210	f
26	Banan	g	100	Świeże	97	1	0.3	21.8	200	f
27	Kiwi	g	100	Świeże	60	0.9	0.5	13.9	200	f
28	Pietruszka Natka	g	100	Świeże	49	4.4	0.4	9	200	f
29	Truskawki mrożone	g	100	Lidl	33	0.7	0.4	7.6	890	f
30	Szpinak baby (Vita Fresh)	g	100	Lidl	22	2.9	0	0.8	200	f
71	Sól biała	szczypta	1	Zapasy	0	0	0	0	350	t
32	Mandarynka (1 sztuka 60g)	sztuka	1	Świeże	27	0.4	0.1	6.7	200	f
33	Pistacje (Alesto)	g	100	Lidl	605	26.5	49.2	10.3	400	f
34	Awokado	g	100	Świeże	169	2	15.3	7.4	200	f
36	Borówka amerykańska	g	100	Świeże	57	0.8	0.4	11.5	200	f
37	Mango	g	100	Świeże	69	0.5	0.3	15.3	200	f
38	Ananas	g	100	Lidl	55	0.4	0.2	13.6	200	f
40	Serek wiejski wysokobiałkowy (Pilos) (1 sztuka 200g)	sztuka	1	Lidl	184	28	6	4.6	720	f
41	Musli crunchy z orzeszkami (Crownfield)	g	100	Lidl	467	11	18	62	1200	f
42	Filet z piersi kurczaka (Kurczak z zielonych Ferm)	g	100	Lidl	112	24	1.6	0.2	500	f
43	Irish beef	g	100	Lidl	243	17.3	18	0.1	500	f
45	Ryż basmati (Plony Natury)	g	100	Lidl	358	8.7	0.8	79	900	f
46	Pomidory bez skóry krojone (Baresa)	g	100	Lidl	27	1.3	0.2	4	900	f
47	Dorsz atlantycki	g	100	Lidl	83	19.1	0.7	0.5	500	f
48	Mięso mielone wołowe (Rzeźnik)	g	100	Lidl	256	18	20	0	500	f
49	Tagliatelle (Tiradell)	g	100	Lidl	354	12.4	1.5	71.2	900	f
50	Frytki z batatów (Harvest Basket)	g	100	Lidl	145	2	5	21.1	820	f
51	Frytki karbowane do piekarnika (Aviko)	g	100	Lidl	152	2.4	4.5	24.3	820	f
52	Oliwa z oliwek	g	100	Zapasy	897	0	99.6	0.2	370	t
53	Jogurt naturalny (Fruvita)	g	100	Lidl	71	4.4	3	6.5	730	f
54	Skórka z cytryny	g	100	Świeże	47	1.5	0.3	16	200	f
13	Cynamon	łyżeczka	1	Zapasy	7	0.1	0	0.8	350	t
70	Garam masala (Kolpol)	g	100	Zapasy	462	11.2	13.2	59.6	350	t
59	Musztarda sarepska (Kamis)	g	100	Lidl	101	3.7	5.1	8.3	2000	f
61	Tortilla pszenna wraps 245g (PANO)	sztuka	1	Lidl	195	5.9	4.6	31.9	120	f
62	Cebula	g	100	Świeże	33	1.4	0.4	6.9	200	f
63	Cebula czerwona	g	100	Świeże	30	1.4	0.4	6.9	200	f
64	Kukurydza złocista	g	100	Lidl	94	3.2	1	19	310	f
65	Fasola	g	100	Lidl	288	21.4	1.6	61.6	310	f
66	Oregano	szczypta	100	Zapasy	3	0.1	0	0.7	350	f
67	Papryka słodka 22g (Kamis)	szczypta	1	Lidl	3	0.1	0.1	0.6	350	f
68	Imbir świeży	g	100	Lidl	80	1.8	0.7	17.8	350	f
69	Kolendra świeża	g	100	Lidl	23	2.1	0.3	3.7	350	f
11	Nasiona chia (Promienie słoneczne)	g	100	Zapasy	489	14.3	32.1	50	410	t
10	Orzechy włoskie (Alesto)	g	100	Zapasy	712	15.5	69.1	3.7	410	t
39	Masło orzechowe (GO ON)	g	100	Lidl	581	17	46	12	1210	f
57	Czosnek granulowany	szczypta	1	Zapasy	0	0	0	0	350	t
80	Pesto (Barilla)	g	100	Lidl	482	4.7	46	9.8	2000	f
88	Masło Extra Osełka 82% Tłusczu	g	100	Lidl	744	0.7	82	0.7	2000	f
96	Groch żółty łuskany połówki	g	100	Lidl	379	23.8	1.4	60.2	2000	f
107	Twaróg klinek chudy (Delikate)	g	100	Lidl	96	20	0.2	3.5	735	f
115	Zinger (KFC)	sztuka	1	Na żywo	438	26.7	23.3	37.6	5000	f
117	Zinger Double (KFC)	sztuka	1	Na żywo	590	41	29	41	5000	f
111	Sałatka Cobb Powiększona (Salad Story)	porcja	1	Na żywo	440	32	28	15	5000	f
112	Sałatka Cezar (Salad Story)	porcja	1	Na żywo	426	36	25	13	5000	f
118	Kebab - mały lawasz z kurczakiem bez sosu (Kebab King)	sztuka	1	Na żywo	618	37.1	23.2	68.4	5000	f
104	Protein pudding Chocolate Valio 180g	sztuka	1	Na żywo	148	19.8	2.7	10.8	5000	f
110	Bajgiel Bekon & Kurczak (Putka)	sztuka	1	Na żywo	403	19.8	11.9	52.2	5000	f
75	Bazylia suszona 10g (Prymat)	szczypta	1	Zapasy	0	0	0	0	350	t
130	Pastani pełne ziarno makaron penne (Pastani Pełne Ziarno)	g	100	Lidl	176	7.9	1.6	30	900	f
5	Chleb tostowy z mąką pełnoziarnistą (1 kromka 22g)	kromka	1	Lidl	53	1.8	0.6	9.5	180	f
35	Sardynka w sosie pomidorowym (LISNER)	g	100	Lidl	232	12	41	3	320	f
44	Ryż biały długoziarnisty (Plony Natury)	g	100	Lidl	351	7.5	0.8	78	900	f
74	Szczypiorek	g	100	Świeże	35	4.1	0.8	4.2	200	f
16	Belbake Kakao Ekstra Ciemne o Obniżonej zawartości Tłuszczu (belbake)	g	100	Zapasy	309	24	11	13	800	t
102	Kazeina SFD 750g (Truskawkowa)	g	100	Zapasy	390	70	3.7	19.2	5000	t
78	Koperek	g	100	Świeże	26	2.8	0.4	2.8	200	f
97	Majeranek suszony	szczypta	1	Zapasy	3	0.1	0.1	0.6	350	t
81	Fasola czerwona	g	100	Lidl	96	8	0.5	10	310	f
83	Łosoś atlantycki świeży filet ze skórą	g	100	Lidl	220	19	16	0	500	f
84	Kasza bulgur (Plony Natury)	g	100	Lidl	332	12	1.5	63	900	f
85	Kasza Kuskus (Plony Natury)	g	100	Lidl	355	14	2	68	900	f
86	Krewetki białe (Marinero)	g	100	Lidl	64	14.4	0.7	0	810	f
58	Bułka wieloziarnista (Lidl) 1 sztuka 60g	sztuka	1	Świeże	173	4.2	4.2	19.2	100	f
79	Zioła prowansalskie	szczypta	1	Zapasy	0	0	0	0	350	t
91	Jabłko	g	100	Świeże	50	0.4	0.4	12.1	200	f
129	Sos sojowy Tao Tao 150ml	g	100	Zapasy	27	3.8	0.1	2.7	360	t
93	Cukinia	g	100	Świeże	17	1.2	0.1	3.2	200	f
94	Wątróbka drobiowa (Muhlenhof)	g	100	Lidl	136	19.1	6.3	0	500	f
95	Ser Halloumi EKTOS	g	100	Lidl	317	20	25	3	699	f
114	Nachos Sandwich (Kebab King)	porcja	1	Na żywo	1056	65	44	99	5000	f
98	Mięta liście	g	100	Lidl	43	3.8	0.7	5.3	200	f
100	Morele suszone	g	100	Lidl	301	5.4	1.2	72.2	400	f
76	Ogórek zielony	g	100	Świeże	14	0.7	0.1	2.9	200	f
106	Jagody mrożone	g	100	Lidl	65	0.8	1.1	10	890	f
82	Pomidorki koktajlowe	g	100	Świeże	19	1	0.2	2.9	200	f
108	Miruna Nowozelandzka filet (Marinero)	g	100	Lidl	78	16	1.5	0	500	f
109	Skyr pitny naturalny (Piątnica) 330g	opakowanie	1	Świeże	211	25.1	5.9	14.2	700	f
1	Skyr naturalny Jogurt typu Islandzkiego (Piątnica) 450g	g	100	Lidl	64	12	0	4.1	700	f
122	Makaron conchiglie (Pastani)	g	100	Lidl	354	12	1.5	71	900	f
123	Tosty pszenny (Z dobrej piekarni)	kromka	1	Lidl	61	1.9	0.3	12.3	190	f
124	Kiełbasa krakowska sucha (Olewnik)	g	100	Lidl	130	32	8	1.2	650	f
125	Krewetki białe Vannamei (225g)	g	100	Lidl	90	20	1	0.5	810	f
127	Orzeszki ziemne prażone, niesolone (Alesto) 500g	g	100	Lidl	610	25.8	49.2	11.6	400	f
128	Burger wołowy Lidl (1 sztuka 110g)	sztuka	1	Lidl	240	20.9	16.5	1.1	500	f
105	Maliny świeże	g	100	Świeże	43	1.3	0.3	12	200	f
131	Pstrąg Tęczowy Łososiowy (Targ rybny)	g	100	Lidl	197	18.8	13.5	0	500	f
132	Ziemniaki	g	100	Lidl	87	1.9	0.1	20.5	200	f
133	Brokuły	g	100	Świeże	31	3	0.4	5.2	200	f
134	Serek Naturalny Bieluch (150g)	opakowanie	1	Na żywo	191	12.9	12.8	6	730	f
87	Makaron ryżowy wstążki	g	100	Lidl	350	6.2	0.1	81.3	900	f
90	Tymianek	szczypta	1	Zapasy	0	0	0	0	350	t
101	Kazeina micelarna (Biały Puch)	g	100	Lidl	355	80	1.6	5.2	5000	f
113	Bowl Toskański Kurczak (Salad Story)	porcja	1	Świeże	583	32	27	53	5000	f
116	Frytki Duże (KFC)	porcja	1	Świeże	268	4.1	12	35	5000	f
92	Rozmaryn szuszony	szczypta	1	Zapasy	3	0.1	0.1	0.6	350	t
73	Marchew	g	100	Świeże	33	1	0.2	8.7	200	f
89	Schab wieprzowy 9 plastrów (Rzeźnik)	g	100	Lidl	128	24	4	0	500	f
126	Kapusta pekińska	g	100	Świeże	16	1	0	3	200	f
121	Łowicz Dżem 100% owoców czarna porzeczka 210g (Łowicz)	g	100	Lidl	132	1.1	0.5	28	1205	f
136	Spaghetti pełnoziarniste (Combino)	g	100	Lidl	350	15.4	2.7	62	900	f
138	Kurkuma	szczypta	1	Lidl	0	0	0	0	350	f
139	Chińska mieszanka warzyw 450g (Proste Historie)	g	100	Lidl	28	1.6	0.3	3.4	815	f
140	Ryż jaśminiowy	g	100	Lidl	349	6.8	0.8	78	900	f
141	Chilli świeże lub suszone	g	100	Świeże	0	0	0	0	200	f
142	Limonka	g	30	Świeże	0	0	0	0	200	f
143	Wiśnie mrożone	g	100	Lidl	40	0.9	0.5	10	890	f
144	Ryżowe płatki błyskawiczne 500g (Melvit)	g	100	Lidl	350	7	0.4	79	1200	f
145	Płatki Jaglane (Crownfield)	g	100	Lidl	363	10	2.5	74	1200	f
146	Żywiecka wieprzowa ekstra (Pikok)	g	100	Lidl	224	24	14	0.6	600	f
147	Ricotta (Loviito)	g	100	Lidl	127	7.7	9	3.9	600	f
152	Serel wiejski lekki 3% tłusczu 200g (Pilos)	sztuka	1	Lidl	162	22	6	4.8	720	f
153	Szynka Filet wędzony z Piersi Indyka 100g (Pikok)	g	100	Lidl	138	20.7	5.4	1.7	600	f
154	Chrzan tarty (Kania) 190g	g	100	Lidl	171	2.4	10	17.5	2000	f
155	Budyń smak śmietankowy z cukerem 60g (Winiary)	porcja	1	Lidl	118	4.3	1.8	13.9	2000	f
157	Mąka pszenna typ 480	g	100	Lidl	350	12	1.5	71	2000	f
158	Koncentrat pomidorowy 90g (Pudliszki)	g	100	Lidl	442	4.9	0.8	18.2	2000	f
159	Galaretka o smaku truskawkowym (Dr Oetker) 72g i z tego wychodzi 572g galaretki (1 porcja)	porcja	1	Lidl	280	9.6	0	60	2000	f
160	Biszkopty z Pieczątką (Tastino)	g	100	Lidl	367	9.5	5.4	71	2000	f
162	Burak ćwikłowy	g	100	Świeże	43	1.6	0.2	10	2000	f
164	Maliny świeże	g	100	Świeże	53	1.2	0.7	12	200	f
163	Ketchup pikantny (Pudliszki) 500g	g	100	Lidl	144	1.1	0.1	34	2000	f
168	Mozarella light (Pilos) 125g	g	100	Lidl	157	19	8.5	1	600	f
171	Proszek do pieczenia	g	100	Lidl	53	0	0	28	2000	f
166	Orzechy laskowe łuskane (Alesto)	g	100	Zapasy	658	15	61	6.7	400	t
149	Bułka orkiszowa	sztuka	1	Świeże	200	6.4	1.6	40	100	f
173	Sałatka Awokado Rybak (Salad Story)	porcja	1	Na żywo	530	32.76	27.43	32.76	5000	f
72	Pieprz czarny mielony	szczypta	1	Zapasy	0	0	0	0	350	t
77	Tzatziki przyprawa	szczypta	1	Zapasy	0	0	0	0	350	t
172	Mąka kukurydziana biała PAN 1kg (google: Mąka kukurydziana precooked (Harina PAN))	g	100	Lidl	357	78	2	75.5	2000	f
174	Wrap Wołowina BBQ (Salad Story)	porcja	1	Na żywo	727.2	31	36	69.8	5000	f
178	Clean tłuszcz (czyste, samo, pure)	g	100	Lidl	900	0	100	0	5000	f
179	Clean węglowodany (czyste, samo, pure)	g	100	Lidl	400	0	0	100	5000	f
183	Sznka z fileta indyka (Pikok)	g	100	Lidl	115	19	3	2.7	600	f
186	Majonez Lekki (Winiary)	g	100	Lidl	338	1.1	33.2	8.4	2000	f
185	Protein pillow o smaku karmelowym (Brownfield)	g	100	Lidl	437	20	18	52	1200	f
151	Kanapka z szarpaną wołowiną (Galeria Wypieków Lubaszka)	sztuka	1	Na żywo	588	25	22.14	70.2	5000	f
187	Schab pieczony 	g	100	Lidl	291	30.4	18.7	0.3	2000	f
103	Danone YoPro Jogurt smak straciatella 160g (Danone YoPro)	sztuka	1	Na żywo	91	15	0.8	5.8	5000	f
169	Żurawina suszona 200g (Alesto)	g	100	Lidl	338	0.7	1.2	78	400	f
190	MC Crispy (Mac Donald's)	sztuka	1	Na żywo	550	27	23	56	2000	f
161	Pestki słonecznika 500g (Alesto)	g	100	Zapasy	616	21.4	53.9	5.1	400	f
165	Rodzynki Jumbo (Alesto)	g	100	Lidl	331	3	2	72	400	f
184	Orzechy laskowe prażone (Alesto)	g	100	Zapasy	722	14.3	70.5	3.5	400	t
167	Kimchi ostre (Freshona)	g	100	Lidl	46	1.8	0.4	8	310	f
148	Tuńczyk w puszce 170g (Nixe)	g	100	Lidl	109	25.4	0.8	0	320	f
170	Białka jaj	g	100	Lidl	50	11	0.2	0.7	1100	f
156	Erytrytol	g	100	Zapasy	0	0	0	0	5000	t
175	Sałatka z kurczakiem 330g (Putka)	porcja	1	Na żywo	676.5	33	4	73	5000	f
176	ChaiKola	sztuka	1	Na żywo	118.8	0	0	28.7	5000	f
177	Clean białko (czyste, samo, pure)	g	100	Lidl	400	100	0	0	5000	f
137	Orzechy nerkowca	g	100	Zapasy	554	18.2	43.8	30.4	400	t
193	Prince Polo XXL 50g	sztuka	1	Na żywo	266	2.3	15	30	2000	f
99	Przyprawa meksykańska (Naturalny Koszyk)	g	100	Zapasy	218	9.3	5.8	19.6	350	t
150	Bułka z chia (Galeria Wypieków Lubaszka)	sztuka	1	Na żywo	279	9.9	8.46	38.7	5000	f
194	Burrata (Pilos)	g	100	Lidl	254	10	23	1.8	2000	f
195	Active protein blue ser w plastrach (Ryki)	porcja	1	Lidl	34	5.3	1.4	0	2000	f
240	Protein Booster Pokket Choco (Dawtona) 180g	sztuka	1	Na żywo	195	20	0.9	24	2000	f
135	Curry przyprawa	szczypta	1	Zapasy	20	1	1	1	5000	t
196	Farfalle z pszenicy durum (Combino)	g	100	Lidl	350	12.5	1.2	70.5	2000	f
198	Nachos Sandwich bez sosu (Kebab King)	porcja	1	Na żywo	1020	64	44	90	2000	f
199	Bułka owsiano-orkiszowa (Galeria Wypieków Lubaszka) 100g	sztuka	1	Na żywo	277	8.7	3	52	2000	f
200	Kebab z kurczaka (Morliny) 400g	g	100	Na żywo	171	15	11	2.6	2000	f
201	Lawasz Ormiański – LA-VA – 5 x 65 g	g	100	Na żywo	308	9.9	4.2	57	2000	f
202	Sos czosnkowy (Fanex)	g	100	Na żywo	445	0.7	46	6.6	2000	f
203	Woda	g	100	Lidl	0	0	0	0	2000	f
197	Musli tropikalne (Vitanella)	g	100	Lidl	364	9.4	7.3	60.2	2000	f
204	Kurczak BBQ (Subway) 15cm 241g	porcja	1	Na żywo	312	20	3	49	2000	f
205	Chipotle Szynka i Pepperoni (Subway) 15cm 207g	porcja	1	Na żywo	374	19	17	37	2000	f
206	Włosky B.M.T (Subway) 15cm 231g	porcja	1	Na żywo	400	20	16	42	2000	f
207	Paski z kurczaka (Subway) 15cm 223g	porcja	1	Na żywo	282	20	3	42	2000	f
208	Kurczak Teriyaki (Subway) 15cm 241g	porcja	1	Na żywo	296	20	3	45	2000	f
209	Stek z serem (Subway) 15cm 235g	porcja	1	Na żywo	336	21	7	47	2000	f
210	Tuńczyk (Subway) 15cm 241g	porcja	1	Na żywo	365	19	13	43	2000	f
211	T.L.C Teriyaki (Subway) 15cm 226g	porcja	1	Na żywo	271	21	3	39	2000	f
213	Sos Sweet onion (Subway) porcja na sub 15cm 18g	porcja	1	Na żywo	30	0	0	7	2000	f
215	Sos Musztarda pełnoziarnista miodowa (Subway) porcja na sub 15cm 14g	porcja	1	Na żywo	29	0	2	3	2000	f
212	Sos Cezar (Subway) porcja na sub 15cm 14g	porcja	1	Na żywo	54	0	5	1	2000	f
216	Sos Majonez (Subway) porcja na sub 15cm 14	porcja	1	Na żywo	48	0	5	1	2000	f
214	Sos Wegański czosnkowy (Subway) porcja na sub 15cm 14g	porcja	100	Na żywo	53	0	5	2	2000	f
217	Kakao puchatek	g	100	Lidl	370	4.5	2.1	80	2000	f
218	Czekolada (ogólna estymata)	g	100	Lidl	546	7.6	29.7	59.4	2000	f
219	Pringles Cheese & Onion (Pringles) 165g	g	100	Lidl	516	6.1	29	56	2000	f
220	Hot Wings 1sztuka (KFC) 34g 	sztuka	1	Na żywo	114	7	7.4	5	2000	f
221	Wołowiner extra cheddar (żabka)	sztuka	1	Na żywo	390.26	26.86	17.38	33.18	2000	f
222	Kebab Rollo z wołowiną (żabka) 280g	sztuka	1	Na żywo	711.2	26.32	39.2	58.8	2000	f
223	Kebab rollo z kurczakiem (Żabka) 280g	sztuka	1	Na żywo	621	33.6	21.84	68	2000	f
224	5 skrzydełek classic (Popeyes)	porcja	1	Na żywo	733	51	50	21	2000	f
225	5 skrzydełek classic z sosem Bold BBQ (Popeyes)	porcja	1	Na żywo	777	49	46	47	2000	f
226	5 skrzydełek z sosem Hot Lemon Pepper (Popeyes)	porcja	1	Na żywo	813	51	51	39	2000	f
227	5 polędwiczek z kurczaka classic (Popeyes)	porcja	1	Na żywo	803	63	45	37	2000	f
228	5 polędwiczek z kurczaka spcy (Popeyes)	porcja	1	Na żywo	734	54	42	36	2000	f
229	8 nuggetsów z kurczaka (Popeyes)	porcja	1	Na żywo	646	41	24	21	2000	f
230	8 nuggetsów z kurczaka (Popeyes)	porcja	1	Na żywo	646	41	39	33	2000	f
231	Kanapka chicken sandwich classic (Popeyes)	porcja	1	Na żywo	715	35	39	57	2000	f
232	Kanapka chicken sandwich pikantna (Popeyes)	porcja	1	Na żywo	713	33	43	54	2000	f
233	Kanapka chicken sandwich deluxe classic (Popeyes)	porcja	1	Na żywo	753	34	47	52	2000	f
234	Kanapka chicken sandwich deluxe pikantna (Popeyes)	porcja	1	Na żywo	738	32	45	58	2000	f
235	Kanapka coleslaw chicken sandwich classic (Popeyes)	porcja	1	Na żywo	672	27	41	49	2000	f
236	Kanapka voodo chicken sandwich (Popeyes)	porcja	1	Na żywo	808	30	51	61	2000	f
237	Frytki Classic Średnie (Popeyes)	porcja	1	Na żywo	317	4.1	15	43	2000	f
238	Frytki z przyprawą Cajun średnie (Popeyes)	porcja	1	Na żywo	299	3.6	14	42	2000	f
239	Snickers baton 51g	sztuka	1	Na żywo	246	4.4	11.5	31	2000	f
241	Riso protein (muller) 180g	sztuka	1	Na żywo	171	13.5	5.22	17.1	2000	f
242	Skyr+ jogurt typu islandzkiego waniliowy (Maluta) 200g	sztuka	1	Na żywo	158	15.64	0	24	2000	f
243	Nachosy klasyczne duże, sos 1 serowy, 1 salsa (Cinema City) 140g nachos + 160g sosy	porcja	1	Na żywo	832	15.6	41	96	2000	f
244	Popcorn duży solony, bez dodatków (Cinema City) 200g	porcja	1	Na żywo	811	20	10	160	2000	f
245	Granola z maliną i smoczym owocem (Crownfield)	g	100	Lidl	403	10	13	54	2000	f
246	Dark chocolate (Meltie)	g	100	Lidl	563	11	46	18	2000	f
249	Skyr jogurt pitny Malina&Nektarynka (Piątnica) 330ml	sztuka	1	Na żywo	264	21.45	5	33	2000	f
250	Bułka Rustiko (Putka) 85g	sztuka	1	Na żywo	255	8.5	7.1	37	2000	f
251	Napoleonka ciasto	g	100	Na żywo	193	3	6.2	31	2000	f
252	SBA protein milkshake truskawka (Mlekovita) 350ml	sztuka	1	Na żywo	207	26	2.5	17	2000	f
191	Frytki małe (Mc Donald's)	porcja	1	Na żywo	231	2.7	11.2	28.8	2000	f
192	Ketchup extra hot (kotlin)	g	100	Lidl	99	1.4	0.5	21	2000	f
247	Żelki ogólna estymata	g	100	Lidl	343	6.9	0.5	77	2000	f
248	Baton protein crisp (GO ON) 50g	sztuka	1	Na żywo	238	10	12	23	2000	f
253	Łosoś norweski wędzony na zimno plastry (Nautica) 100g	g	100	Lidl	174	20	10.4	0	2000	f
\.


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.recipes (dish_id, time_total, what_before, preparation, when_start) FROM stdin;
42				
76				
37				
147				
19				
149				
24				
25				
148				
34			Frytki i steka soczyście solisz.\n\nZ jogurtu, kapusty, soku z cytryny i pieprzu robisz sałatkę jak mama kiedyś :'(\n\n	
13			Ten przepis był dla mnie ciężki w przygotowaniu oraz ma słabe makro, gdyż mięso mielone wołowe jest mocno tłuste, kotlety trzeba lepić jakoś mi to nie wychodziło (mimo, że dobre w sumie, może kiedyś do niego wrócę)	
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
21				
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
7				
90				
91				
92				
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
30				
17			Krojenie kurczaka:\nBardzo cienko, staraj się imitować kebsa, znajdź jak idą paski włókien na kurczaka i krój prosopadle do nich.\n\nDaj przyprawę do Gyrosa.\n\nSosik:\nTzatziki, Oregano (mało), Kolendra świeża, czosnek, trochę soku z cytryny.\nJak masz ogóre to daj.	
87			Składniki na ciasto {serek wiejski 200g, jajko jedno, mąka 50g, przyprawy}.\n\nPiekarnik 220 grzej. Potem mieszasz ciasto i cyk na blaszke cieniutko uformowane koło i pieczemy 15 minut aż się przypiecze fajnie. Teraz smarowanie koncentratem i serem znowu do piekarnika na 5 minut, i cyk dodatki już na zimno\n\nhttps://www.tiktok.com/@orzechowskam/video/7494611420756053270	
150				
151				
152			https://www.odzywiajsiezdrowo.pl/dorsz-z-ryzem-i-warzywami/\n\n1. Dorsza ułóż w naczyniu żaroodpornym. Na rybie połóż koperek. Dopraw pieprzem.\n2. Warzywa oprósz ziołami i skrop oliwą. Przykryj.\n3. Wszystkie składniki piecz 20 minut w piekarniku nagrzanym do 200 C (możesz ugotować na parze lub upiec w rękawie).\n4. Ryż ugotuj według przepisu na opakowaniu. 	
153				
154				
88			https://www.tiktok.com/@orzechowskam/video/7490104352544247062\n\nZrób galaretke według przepisu (ale mniej ilości wody niż zakłada producent), ale nie ścinaj jeszcze. Z twarogu i skyra robisz masę blendowaniem. Połowę galaretki wlewasz do masy. Znowu miksujesz. Do foremki na dół układasz biszkopty i przelewasz na to masę w całości i odstawiasz do lodówki. Reszta galaretki też do lodowki. Oba na 30minut (ale sprawdzaj w trakcie, może być nawet 45 min. Potem dokładasz owoce, zalewasz galaretką i znowu do lodówki aż zastygnie max.	
65			1. Kurczaka pokrój w kostkę. W misce wymieszaj z sosem sojowym, miodem, imbirem, kurkumą, czosnkiem i szczyptą soli.\n2. Odstaw na 10–15 min, żeby się zamarynował.\n3. W tym czasie ugotuj makaron ryżowy (zalewając wrzątkiem na 8–10 min), następnie odcedź i przepłucz.\n4. Na dużej patelni lub woku rozgrzej 10 g oliwy, usmaż kurczaka na złoto z każdej strony.\n5. Dorzuć chińską mieszankę warzyw, smaż razem 5–6 min, aż warzywa będą gorące i lekko chrupiące.\n6. Dodaj makaron, pozostałe 5 g oliwy, nerkowce i ewentualnie kilka kropel sosu sojowego do smaku.\n7. Wymieszaj całość, smaż jeszcze 1–2 min, żeby wszystko się połączyło i miód lekko skarmelizował.	
155				
156				
94				
99				
100				
101				
116				
146				
144				
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
130				
133				
134				
135				
131				
137				
132				
136				
138				
139				
140				
141				
142				
143				
145				
\.


--
-- Name: diet_labels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.diet_labels_id_seq', 1, false);


--
-- Name: diets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.diets_id_seq', 5, true);


--
-- Name: dish_labels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.dish_labels_id_seq', 6, true);


--
-- Name: dishes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.dishes_id_seq', 156, true);


--
-- Name: ingredient_labels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.ingredient_labels_id_seq', 1, false);


--
-- Name: ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.ingredients_id_seq', 253, true);


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
-- Name: diet_slots_counter diet_slots_counter_pkey; Type: CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.diet_slots_counter
    ADD CONSTRAINT diet_slots_counter_pkey PRIMARY KEY (diet_id, day, meal);


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
-- Name: diet_slots_counter diet_slots_counter_diet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.diet_slots_counter
    ADD CONSTRAINT diet_slots_counter_diet_id_fkey FOREIGN KEY (diet_id) REFERENCES public.diets(id) ON DELETE CASCADE;


--
-- Name: diet_slots_counter diet_slots_counter_dish_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kartezjusz
--

ALTER TABLE ONLY public.diet_slots_counter
    ADD CONSTRAINT diet_slots_counter_dish_id_fkey FOREIGN KEY (dish_id) REFERENCES public.dishes(id);


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

