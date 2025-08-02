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
-- Name: shop_style; Type: TYPE; Schema: public; Owner: kartezjusz
--

CREATE TYPE public.shop_style AS ENUM (
    'Lidl',
    'G.S',
    'Świeże',
    'Zapasy'
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
    carbs double precision
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
-- Data for Name: day_kcals; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.day_kcals (diet_id, day_num, kcal) FROM stdin;
\.


--
-- Data for Name: diet_context; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.diet_context (active_diet, start_date, current_weight) FROM stdin;
1	2025-07-28	82
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
1	1	6
1	2	29
1	3	1
1	4	22
1	5	24
1	6	7
1	7	22
1	8	2
1	9	14
1	10	24
1	11	8
1	12	14
1	13	27
1	14	16
1	15	24
1	16	9
1	17	16
1	18	4
1	19	20
1	20	25
1	21	10
1	22	20
1	23	5
1	24	18
1	25	25
1	26	11
1	27	18
1	28	27
1	29	30
1	30	25
\.


--
-- Data for Name: diets; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.diets (id, name, descr) FROM stdin;
1	Reverse Diet 	Reverse diet przed Sri-Lanka
\.


--
-- Data for Name: dish_label_bridge; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.dish_label_bridge (dish_id, label_id) FROM stdin;
\.


--
-- Data for Name: dish_labels; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.dish_labels (id, label, color) FROM stdin;
\.


--
-- Data for Name: dishes; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.dishes (id, meal, name, descr) FROM stdin;
1	Pre-Workout	W1 Skyr&Miód + Banan&Jabłko	
3	Pre-Workout	W3 Skyr&Peanut Butter + Banan	
2	Pre-Workout	W2 Skyr&Maliny&Chia + Banan	
4	Pre-Workout	W4 YoPRO&Valio + Borówka&Banan	
5	Pre-Workout	W5 Skyr + Banan&Maliny	
6	Breakfast	B13 Kanapki + Smoothie	
7	Breakfast	B14 Kanapki + Smoothie	
8	Breakfast	B15 Kanapki + sardynki i kefir	
9	Breakfast	B16 Owsianka na kefirze	
14	MainMeal	M05 Kurczak filet - wrap	
13	MainMeal	M04 Wołowina mielona - kofta grecka	
15	MainMeal	M06 Kurczak filet - Tikka Masala	
16	MainMeal	M07 Kurczak filet - Spaghetti Napoli	
17	MainMeal	M08 Kurczak filet - Gyros	
19	MainMeal	M14 Dorsz filet - cytrynowo-pietruszkowy	
20	MainMeal	M15 Krewetki - masło/czosnek	
21	MainMeal	M17 Wieprzowina polędwiczka - musztardowo-miodowa	
22	MainMeal	M18 Wieprzowina schab – pieczony z ziołami	
23	MainMeal	M19 Wątróbka drobiowa - klasyczek	
24	Supper	Kazeina	
25	Supper	Twaróg klinek chudy	
26	MainMeal	Mx Miruna jak nad morzem	
18	MainMeal	M13 Łosoś filet - salsa awokado	
27	Pre-Workout	W6 Sam skyr	
28	MainMeal	Sałatka Cobb Duża	
29	MainMeal	Sałatka Cezar Duża	
10	Breakfast	B17 Owsianka mango	
30	MainMeal	Double Zinger (KFC)	
11	Breakfast	B18 Owsianka owoce	
\.


--
-- Data for Name: ingredient_amounts; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.ingredient_amounts (dish_id, ingredient_id, amount) FROM stdin;
1	1	300
1	25	20
1	26	110
1	91	150
3	1	300
3	39	20
3	26	110
2	1	300
2	11	10
2	14	100
2	26	110
4	26	110
4	36	250
4	103	1
4	104	1
5	1	300
5	105	250
5	26	110
6	8	2
6	9	60
6	23	200
6	26	110
6	37	150
6	39	15
6	11	10
6	20	20
6	17	30
6	27	75
7	8	2
7	9	60
7	23	100
7	27	75
7	26	110
7	11	10
7	20	20
7	17	30
8	8	2
8	9	60
8	23	100
8	35	90
9	2	80
9	4	1
9	23	200
9	26	110
9	11	10
9	25	10
9	39	20
13	22	50
13	45	50
13	48	150
13	52	8
13	55	10
13	56	20
13	66	1
13	67	1
14	42	150
14	61	1
14	52	8
14	22	75
14	59	10
14	17	30
14	20	20
14	21	10
14	66	1
14	57	1
14	67	1
15	42	150
15	44	50
15	52	8
15	22	75
15	46	100
15	68	10
15	69	10
15	70	20
15	67	1
16	42	150
16	49	50
16	52	8
16	46	100
16	62	30
16	56	10
16	73	30
16	74	20
16	75	1
16	66	1
16	71	1
16	72	1
17	42	150
17	51	150
17	52	8
17	22	50
17	19	20
17	77	1
17	76	30
19	47	150
19	52	8
19	54	10
19	55	10
19	71	1
19	72	1
19	73	30
19	85	50
19	28	30
20	86	200
20	87	50
20	88	10
20	56	20
20	55	10
20	28	20
21	89	150
21	85	50
21	52	8
21	91	150
21	59	10
21	25	10
21	90	1
21	71	1
21	72	1
22	89	150
22	84	50
22	52	8
22	56	10
22	92	1
22	67	1
22	73	30
22	93	20
22	17	30
22	71	1
22	72	1
23	94	150
23	96	50
23	62	30
23	91	150
23	97	1
23	88	10
23	71	1
23	72	1
24	102	40
25	107	150
26	108	200
26	51	150
26	22	50
26	59	10
26	60	10
26	71	2
26	72	1
26	55	10
18	83	150
18	34	50
18	84	50
18	52	8
18	63	40
18	82	50
18	69	10
18	57	1
27	1	300
28	111	1
29	112	1
10	2	80
10	3	200
10	37	150
10	106	150
10	26	110
10	4	1
10	11	10
30	117	1
11	2	80
11	3	200
11	26	110
11	4	1
11	31	10
11	106	100
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

COPY public.ingredients (id, name, unit, default_amount, shop_style, kcal, proteins, fats, carbs) FROM stdin;
1	Skyr Piątnica Jogurt typu Islandzkiego naturalny 450g	g	100	Lidl	64	12	0	4.1
2	Płatki owsiane górskie (Crownfield)	g	100	Lidl	354	12.5	6.3	55.9
3	Mleko UHT 1.5% tłuszczu (Mleczna Dolina)	g	100	Lidl	46	3.3	1.5	4.8
4	Jaja kurze (60g)	sztuka	1	Lidl	84	7.5	5.8	0.4
5	Chleb tostowy z mąką pełnoziarnistą (1 kromka 22g)	kromka	1	Lidl	53	1.8	0.6	9.5
6	Regionalne szlaki Rolada Ustrzycka Wędzona (1 plaster 20g)	porcja	1	Lidl	58	5	4	0.4
7	Krakus Kiełbasa Krakowska sucha z szynki 144g (2x72g)	g	100	Lidl	182	31	6.3	0.3
8	Chleb Żytni z Ziarnami Żyta krojony (Piekarnia Lidla) (1 kromka 90g)	kromka	1	Lidl	180	4.8	1.3	33.3
9	Szynka konserwowa wieprzowa (Pikok)	g	100	Lidl	99	19	1.6	2
10	Orzechy włoskie (Alesto)	g	100	Zapasy	712	15.5	69.1	3.7
11	Nasiona chia (Promienie słoneczne)	g	100	Zapasy	489	14.3	32.1	50
12	Pestki dyni (Alesto)	g	100	Zapasy	579	24.4	45.6	15.2
13	Cynamon	łyżeczka	1	Lidl	7	0.1	0	0.8
14	Maliny mrożone (Lidl)	g	100	Lidl	49	1.3	0.3	5.3
15	Migdały	g	100	Zapasy	604	24.1	52	20.5
16	Belbake Kakao Ekstra Ciemne o Obniżonej zawartości Tłuszczu (belbake)	g	100	Zapasy	309	24	11	13
17	Papryka czerwona	g	100	Świeże	32	1.3	0.5	6.6
18	Rukola	g	100	Świeże	25	2.6	0.7	3.6
19	Pomidor	g	100	Świeże	19	0.9	0.2	4.1
20	Ogórek kiszony	g	100	Świeże	13	1.1	0.1	1.4
21	Sałata lodowa (Asda)	g	100	Świeże	14	1.2	0.5	1.4
22	Jogur grecki XXL (Pilos)	g	100	Lidl	123	3.6	10	4.7
23	Kefir (Robico)	g	100	Lidl	47	3	2	4.2
24	Pomarańcza	g	100	Świeże	47	0.9	0.2	11.3
25	Miód lipowy (Bartnik)	g	100	Lidl	333	0.3	0	83
26	Banan	g	100	Świeże	97	1	0.3	21.8
27	Kiwi	g	100	Świeże	60	0.9	0.5	13.9
28	Pietruszka Natka	g	100	Świeże	49	4.4	0.4	9
29	Truskawki mrożone	g	100	Lidl	33	0.7	0.4	7.6
30	Szpinak baby (Vita Fresh)	g	100	Lidl	22	2.9	0	0.8
31	Siemię lniane (Witpak)	g	100	Zapasy	507	25	31	39
32	Mandarynka (1 sztuka 60g)	sztuka	1	Świeże	27	0.4	0.1	6.7
33	Pistacje (Alesto)	g	100	Lidl	605	26.5	49.2	10.3
34	Awokado	g	100	Świeże	169	2	15.3	7.4
35	Sardynka w sosie pomidorowym (LISNER)	g	100	Lidl	232	12	41	3
36	Borówka amerykańska	g	100	Świeże	57	0.8	0.4	11.5
37	Mango	g	100	Świeże	69	0.5	0.3	15.3
38	Ananas	g	100	Lidl	55	0.4	0.2	13.6
39	Masło orzechowe (GO ON)	g	100	Lidl	581	17	46	12
40	Serek wiejski wysokobiałkowy (Pilos) (1 sztuka 200g)	sztuka	1	Lidl	184	28	6	4.6
41	Musli crunchy z orzeszkami (Crownfield)	g	100	Lidl	467	11	18	62
42	Filet z piersi kurczaka (Kurczak z zielonych Ferm)	g	100	Lidl	112	24	1.6	0.2
43	Irish beef	g	100	Lidl	243	17.3	18	0.1
44	Ryż biały długoziarnisty (Plony Natury)	g	100	Lidl	351	7.5	0.8	78
45	Ryż basmati (Plony Natury)	g	100	Lidl	358	8.7	0.8	79
46	Pomidory bez skóry krojone (Baresa)	g	100	Lidl	27	1.3	0.2	4
47	Dorsz atlantycki	g	100	Lidl	83	19.1	0.7	0.5
48	Mięso mielone wołowe (Rzeźnik)	g	100	Lidl	256	18	20	0
49	Tagliatelle (Tiradell)	g	100	Lidl	354	12.4	1.5	71.2
50	Frytki z batatów (Harvest Basket)	g	100	Lidl	145	2	5	21.1
51	Frytki karbowane do piekarnika (Aviko)	g	100	Lidl	152	2.4	4.5	24.3
52	Oliwa z oliwek	g	100	Lidl	897	0	99.6	0.2
53	Jogurt naturalny (Fruvita)	g	100	Lidl	71	4.4	3	6.5
54	Skórka z cytryny	g	100	Świeże	47	1.5	0.3	16
55	Sok z cytryny (Citromle)	g	100	Lidl	13	0	0	3.2
56	Czosnek	g	100	Lidl	152	6.4	0.5	32.6
57	Czosnek granulowany	szczypta	1	Zapasy	0	0	0	0
58	Bułka wieloziarnista (Lidl) 1 sztuka 60g	g	1	Lidl	173	4.2	4.2	19.2
59	Musztarda sarepska (Kamis)	g	100	Lidl	101	3.7	5.1	8.3
60	Ketchu pikantny (Pudliszki)	g	100	Lidl	144	1.1	0.1	3.4
61	Tortilla pszenna wraps 245g (PANO)	sztuka	1	Lidl	195	5.9	4.6	31.9
62	Cebula	g	100	Świeże	33	1.4	0.4	6.9
63	Cebula czerwona	g	100	Świeże	30	1.4	0.4	6.9
64	Kukurydza złocista	g	100	Lidl	94	3.2	1	19
65	Fasola	g	100	Lidl	288	21.4	1.6	61.6
66	Oregano	szczypta	100	Zapasy	3	0.1	0	0.7
67	Papryka słodka 22g (Kamis)	szczypta	1	Lidl	3	0.1	0.1	0.6
68	Imbir świeży	g	100	Lidl	80	1.8	0.7	17.8
69	Kolendra świeża	g	100	Lidl	23	2.1	0.3	3.7
70	Garam masala (Kolpol)	g	100	Zapasy	462	11.2	13.2	59.6
71	Sól biała	szczypta	1	Zapasy	0	0	0	0
72	Pieprz czarny mielony	szczypta	1	Zapasy	0	0	0	0
73	Marchew	g	100	Świeże	33	1	0.2	8.7
74	Szczypiorek	g	100	Świeże	35	4.1	0.8	4.2
75	Bazylia suszona 10g (Prymat)	szczypta	1	Zapasy	0	0	0	0
76	Ogórek zielony	g	100	Lidl	14	0.7	0.1	2.9
77	Tzatziki przyprawa	szczypta	1	Zapasy	0	0	0	0
78	Koperek	g	100	Świeże	26	2.8	0.4	2.8
79	Zioła prowansalskie	szczypta	1	Zapasy	0	0	0	0
80	Pesto (Barilla)	g	100	Lidl	482	4.7	46	9.8
81	Fasola czerwona	g	100	Lidl	96	8	0.5	10
83	Łosoś atlantycki świeży filet ze skórą	g	100	Lidl	220	19	16	0
84	Kasza bulgur (Plony Natury)	g	100	Lidl	332	12	1.5	63
85	Kasza Kuskus (Plony Natury)	g	100	Lidl	355	14	2	68
86	Krewetki białe (Marinero)	g	100	Lidl	64	14.4	0.7	0
87	Makaron ryżowy wstążki	g	100	Lidl	350	6.2	0.1	81.3
88	Masło Extra Osełka 82% Tłusczu	g	100	Lidl	744	0.7	82	0.7
89	Schab wieprzowy 9 plastrów (Rzeźnik)	g	100	Lidl	128	24	4	0
90	Tymianek	szczypta	1	Zapasy	0	0	0	0
91	Jabłko	g	100	Świeże	50	0.4	0.4	12.1
92	Rozmaryn szuszony	szczypta	1	Zapasy	3	0.1	0.1	0.6
93	Cukinia	g	100	Lidl	17	1.2	0.1	3.2
94	Wątróbka drobiowa (Muhlenhof)	g	100	Lidl	136	19.1	6.3	0
95	Ser Halloumi EKTOS	g	100	Lidl	317	20	25	3
96	Groch żółty łuskany połówki	g	100	Lidl	379	23.8	1.4	60.2
97	Majeranek suszony	szczypta	1	Zapasy	3	0.1	0.1	0.6
98	Mięta liście	g	100	Lidl	43	3.8	0.7	5.3
99	Przyprawa meksykańska (Naturalny Koszyk)	g	100	Lidl	218	9.3	5.8	19.6
100	Morele suszone	g	100	Lidl	301	5.4	1.2	72.2
101	Kazeina micelarna (Biały Puch)	g	100	Lidl	355	80	1.6	5.2
103	Danone YoPro Jogurt smak straciatella 160g (Danone YoPro)	sztuka	1	Świeże	91	15	0.8	5.8
104	Protein pudding Chocolate Valio 180g	sztuka	1	Lidl	148	19.8	2.7	10.8
105	Maliny świeże	g	100	Lidl	43	1.3	0.3	12
106	Jagody mrożone	g	100	Lidl	65	0.8	1.1	10
82	Pomidorki koktajlowe	g	100	Świeże	19	1	0.2	2.9
107	Twaróg klinek chudy (Delikate)	g	100	Lidl	96	20	0.2	3.5
108	Miruna Nowozelandzka filet (Marinero)	g	100	Lidl	78	16	1.5	0
109	Skyr pitny naturalny (Piątnica) 330g	opakowanie	1	Świeże	211	25.1	5.9	14.2
110	Bajgiel Bekon & Kurczak (Putka)	sztuka	1	Świeże	403	19.8	11.9	52.2
111	Sałatka Cobb Powiększona (Salad Story)	porcja	1	Świeże	440	32	28	15
112	Sałatka Cezar (Salad Story)	porcja	1	Świeże	426	36	25	13
113	Bowl Toskański Kurczak (Salad Story)	porcja	1	Świeże	583	32	27	53
114	Nachos Sandwich (Kebab King)	porcja	1056	Świeże	1056	65	44	99
115	Zinger (KFC)	sztuka	1	Świeże	438	26.7	23.3	37.6
116	Frytki Duże (KFC)	porcja	1	Świeże	268	4.1	12	35
117	Zinger Double (KFC)	sztuka	1	Świeże	590	41	29	41
118	Kebab - mały lawasz z kurczakiem bez sosu (Kebab King)	sztuka	1	Świeże	618	37.1	23.2	68.4
119	Skyr jogurt typu islandzkiego z jagodami 150g (Piątnica)	opakowanie	1	Lidl	123	14.4	0	16.5
120	Skyr Jogurt typu islandzkiego z mango i marakują 150g (Piątnica)	opakowanie	1	Świeże	123	14.4	0	16.5
102	Kazeina SFD 750g (Truskawkowa)	g	100	Zapasy	390	70	3.7	19.2
\.


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.recipes (dish_id, time_total, what_before, preparation, when_start) FROM stdin;
1				
3				
2				
4				
5				
6				
7				
8				
9				
13				
14				
15				
16			Marchew zetrzyj	
17				
19				
20				
21				
22				
23				
24				
25				
26			Mirunę pieprzem przed. Cyk do piekarnika frytki też. Potem sos miliona jezior z jogurtu greckiego, musztardy i ketchupu.	
18				
27				
28				
29				
10				
30				
11				
\.


--
-- Name: diet_labels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.diet_labels_id_seq', 1, false);


--
-- Name: diets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.diets_id_seq', 1, true);


--
-- Name: dish_labels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.dish_labels_id_seq', 1, false);


--
-- Name: dishes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.dishes_id_seq', 30, true);


--
-- Name: ingredient_labels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.ingredient_labels_id_seq', 1, false);


--
-- Name: ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.ingredients_id_seq', 120, true);


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

