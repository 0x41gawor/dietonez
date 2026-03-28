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
2026-03-23	29	Pre-Workout	250
2026-03-24	177	Lunch	35
2026-03-24	178	Lunch	30
2026-03-24	179	Lunch	130
2026-03-26	177	Lunch	45
2026-03-26	178	Lunch	32
2026-03-21	10	Pre-Workout	10
2026-03-26	179	Lunch	120
2026-03-26	250	Post-Workout	1
2026-03-26	6	Post-Workout	2
2026-03-26	7	Post-Workout	25
2026-03-26	127	Pre-Workout	4
2026-03-22	91	Supper	150
2026-03-22	102	Supper	40
2026-03-23	177	Post-Workout	15
2026-03-23	178	Post-Workout	2.4
2026-03-23	179	Post-Workout	9.6
2026-03-23	26	Post-Workout	160
2026-03-23	27	Post-Workout	90
2026-03-24	252	Breakfast	1
2026-03-23	110	Breakfast	1
2026-03-23	252	Breakfast	1
2026-03-24	281	Breakfast	1
2026-03-26	1	Pre-Workout	220
2026-03-25	245	Pre-Workout	50
2026-03-25	25	Pre-Workout	50
2026-03-25	218	Pre-Workout	25
2026-03-25	260	Post-Workout	80
2026-03-25	6	Post-Workout	2
2026-03-25	146	Post-Workout	35
2026-03-26	25	Breakfast	30
2026-03-26	26	Breakfast	80
2026-03-26	197	Pre-Workout	91
2026-03-26	25	Pre-Workout	40
2026-03-27	29	Breakfast	250
2026-03-27	101	Breakfast	50
2026-03-27	2	Breakfast	100
2026-03-27	3	Breakfast	200
2026-03-28	148	Lunch	150
2026-03-22	260	Breakfast	80
2026-03-28	149	Lunch	1
2026-03-28	1	Lunch	100
2026-03-28	25	Lunch	30
2026-03-22	6	Breakfast	2
2026-03-28	15	Lunch	10
2026-03-22	7	Breakfast	30
2026-03-28	26	Lunch	90
2026-03-28	132	Pre-Workout	75
2026-03-28	89	Pre-Workout	90
2026-03-22	163	Breakfast	15
2026-03-22	1	Breakfast	150
2026-03-28	52	Pre-Workout	15
2026-03-22	245	Breakfast	40
2026-03-28	127	Pre-Workout	20
2026-03-28	261	Pre-Workout	10
2026-03-22	26	Breakfast	90
2026-03-28	186	Pre-Workout	20
2026-03-28	248	Pre-Workout	1
2026-03-22	24	Breakfast	130
2026-03-21	177	Post-Workout	38
2026-03-21	178	Post-Workout	32
2026-03-21	179	Post-Workout	70
2026-03-21	177	Supper	0.5
2026-03-21	178	Supper	6
2026-03-21	179	Supper	37.5
2026-03-22	177	Lunch	38
2026-03-22	178	Lunch	32
2026-03-22	179	Lunch	70
2026-03-22	218	Lunch	25
2026-03-23	1	Pre-Workout	300
2026-03-23	199	Pre-Workout	1
2026-03-23	26	Pre-Workout	90
2026-03-25	199	Pre-Workout	1
2026-03-21	5	Breakfast	6
2026-03-21	6	Breakfast	3
2026-03-21	146	Breakfast	50
2026-03-23	91	Supper	150
2026-03-23	102	Supper	40
2026-03-24	190	Post-Workout	1
2026-03-25	151	Breakfast	1
2026-03-25	252	Breakfast	1
2026-03-25	1	Pre-Workout	220
2026-03-26	107	Breakfast	150
2026-03-26	23	Breakfast	200
2026-03-26	24	Breakfast	120
2026-03-26	268	Breakfast	100
2026-03-26	166	Breakfast	10
2026-03-22	177	Post-Workout	80
2026-03-22	178	Post-Workout	67
2026-03-22	179	Post-Workout	178
2026-03-21	1	Pre-Workout	220
2026-03-21	197	Pre-Workout	50
2026-03-21	25	Pre-Workout	50
2026-03-24	1	Pre-Workout	300
2026-03-24	199	Pre-Workout	1
2026-03-27	166	Breakfast	15
2026-03-21	163	Breakfast	35
2026-03-21	61	Lunch	2
2026-03-24	116	Post-Workout	1
2026-03-21	42	Lunch	120
2026-03-25	111	Lunch	1
2026-03-27	148	Lunch	150
2026-03-27	51	Lunch	250
2026-03-21	52	Lunch	8
2026-03-27	163	Lunch	30
2026-03-21	67	Lunch	1
2026-03-21	66	Lunch	1
2026-03-21	17	Lunch	30
2026-03-27	248	Lunch	1
2026-03-27	223	Pre-Workout	1
2026-03-21	22	Lunch	100
2026-03-23	201	Lunch	131
2026-03-23	200	Lunch	160
2026-03-23	178	Lunch	10
\.


--
-- Data for Name: day_kcals; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.day_kcals (diet_id, day_num, kcal) FROM stdin;
5	0	2900
5	7	2900
5	8	2900
5	9	2900
4	0	2700
4	1	2700
4	2	2700
4	3	2700
4	4	2700
4	5	2700
4	6	2700
5	55	2800
5	1	2900
5	2	2900
5	3	2900
5	4	2900
5	5	2900
5	6	2800
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
4	7	2700
4	8	2700
4	9	2700
4	10	2700
4	11	2700
5	48	2800
5	49	2900
5	50	2900
5	51	2900
5	52	2900
5	53	2900
5	54	2900
4	12	2700
4	13	2700
\.


--
-- Data for Name: diet_context; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.diet_context (active_diet, start_date, current_weight) FROM stdin;
5	2026-02-02	83.5
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
5	31	\N
5	32	\N
5	33	\N
5	66	\N
5	67	\N
5	68	\N
5	101	\N
5	102	\N
5	103	\N
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
5	3	21
5	4	24
5	5	144
5	6	21
5	7	151
5	8	23
5	9	24
5	10	144
5	11	23
5	12	151
5	13	65
5	14	24
5	15	149
5	16	65
5	17	153
5	18	30
5	19	24
5	20	149
5	21	65
5	22	157
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
5	38	19
5	39	24
5	40	147
5	41	19
5	42	151
5	43	34
5	44	24
5	45	147
5	46	34
5	47	151
5	48	39
5	49	24
5	50	146
5	51	39
5	52	154
5	53	30
5	54	24
5	55	146
5	56	39
5	57	158
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
5	73	16
5	74	24
5	75	144
5	76	16
5	77	151
5	78	62
5	79	24
5	80	144
5	81	62
5	82	151
5	83	63
5	84	24
5	85	149
5	86	63
5	87	155
5	88	30
5	89	24
5	90	149
5	91	63
5	92	159
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
5	108	31
5	109	24
5	110	147
5	111	31
5	112	151
5	113	35
5	114	24
5	115	147
5	116	35
5	117	151
5	118	36
5	119	24
5	120	146
5	121	36
5	122	156
5	123	30
5	124	24
5	125	146
5	126	36
5	127	160
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
5	143	38
5	144	24
5	145	144
5	146	38
5	147	151
5	148	23
5	149	24
5	150	144
5	151	23
5	152	151
5	153	64
5	154	24
5	155	149
5	156	64
5	157	153
5	158	30
5	159	24
5	160	149
5	161	64
5	162	157
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
5	178	152
5	179	24
5	180	147
5	181	152
5	182	151
5	183	34
5	184	24
5	185	147
5	186	34
5	187	151
5	188	15
5	189	24
5	190	146
5	191	15
5	192	154
5	193	30
5	194	24
5	195	146
5	196	15
5	197	158
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
5	213	22
5	214	24
5	215	144
5	216	22
5	217	151
5	218	62
5	219	24
5	220	144
5	221	62
5	222	151
5	223	14
5	224	24
5	225	149
5	226	14
5	227	155
5	228	30
5	229	24
5	230	149
5	231	14
5	232	159
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
5	248	26
5	249	24
5	250	148
5	251	26
5	252	151
5	253	35
5	254	24
5	255	147
5	256	35
5	257	151
5	258	17
5	259	24
5	260	146
5	261	17
5	262	156
5	263	30
5	264	24
5	265	146
5	266	17
5	267	160
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
5	2026-01-30	Breakfast	LCPA - łosoś/pomarańcz/kefir	146
5	2026-01-30	Lunch	20Kurczak: Gyros (M)	17
5	2026-01-30	Pre-Workout	PW HOME 3 (PT)	160
5	2026-01-30	Post-Workout	FF Subway nowe smaki	135
5	2026-01-30	Supper	Kazeina M	24
5	2026-01-31	Breakfast	11M Owsianka - żurawinowa	122
5	2026-02-13	Breakfast	LCPA - łosoś/pomarańcz/kefir	146
5	2026-01-31	Pre-Workout	PW HOME 3	156
5	2026-02-05	Supper	Kazeina M	24
5	2026-01-31	Supper	Kazeina M	24
5	2026-02-13	Lunch	20Kurczak: Mexicano (M)	39
5	2026-02-13	Pre-Workout	PW HOME 1 (PT)	158
5	2026-02-06	Pre-Workout	PW HOME 0 (PT)	157
5	2026-02-13	Supper	Kazeina M	24
5	2026-02-11	Post-Workout	\N	\N
5	2026-02-12	Supper	\N	\N
5	2026-02-13	Post-Workout	FF Double Zinger (KFC)	30
5	2026-02-14	Breakfast	11M Owsianka - jagodowa - lean	143
5	2026-02-07	Supper	Kazeina M	24
5	2026-01-31	Lunch	\N	\N
5	2026-01-31	Post-Workout	kfc wyżerka	\N
5	2026-02-04	Post-Workout	tosty	\N
5	2026-02-05	Post-Workout	20Kurczak: Asian Stri-Fry (M)	65
5	2026-02-14	Lunch	\N	\N
5	2026-02-14	Pre-Workout	\N	\N
5	2026-02-14	Post-Workout	\N	\N
5	2026-02-14	Supper	\N	\N
5	2026-02-16	Breakfast	FF Mlekovita SBA + bieluch	150
5	2026-02-06	Breakfast	tosty	\N
5	2026-02-02	Breakfast	FF Mlekovita SBA + bieluch	150
5	2026-02-02	Lunch	FF Lawasz z kurczakiem 160g (W Bułce)	130
5	2026-02-02	Pre-Workout	PW WORK 	151
5	2026-02-02	Post-Workout	11Wieprz: Musztardowo-miodowa (M)	21
5	2026-02-16	Lunch	FF Lawasz z kurczakiem 160g (W Bułce)	130
5	2026-02-03	Breakfast	LCPA - jaja/pomarańcz/kefir	144
5	2026-02-03	Lunch	11Wieprz: Musztardowo-miodowa (M)	21
5	2026-02-03	Pre-Workout	PW WORK 	151
5	2026-02-03	Post-Workout	13Wątróbka: groch/cebula (M)	23
5	2026-02-03	Supper	Kazeina M	24
5	2026-02-05	Lunch	tosty	\N
5	2026-02-06	Lunch	20Kurczak: Asian Stri-Fry (M)	65
5	2026-02-16	Pre-Workout	PW WORK 	151
5	2026-02-06	Post-Workout	Dobre kurde	\N
5	2026-02-04	Pre-Workout	PW WORK 	151
5	2026-02-16	Post-Workout	11Wieprz: Spaghetti Napoli (M)	16
5	2026-02-04	Supper	Kazeina M	24
5	2026-02-06	Supper	szproty bułka	\N
5	2026-02-01	Breakfast	baton skyr	\N
5	2026-02-01	Lunch	bałkański posiłek	\N
5	2026-02-01	Supper	czekolada	\N
5	2026-02-02	Supper	\N	\N
5	2026-02-04	Breakfast	LCPA - jaja/pomarańcz/kefir	144
5	2026-02-16	Supper	Kazeina M	24
5	2026-02-04	Lunch	FF Kebab King mały lawasz kurczak bez sosu	32
5	2026-02-05	Breakfast	LCPA - twaróg/kiwi/kefir	149
5	2026-02-17	Breakfast	LCPA - jaja/pomarańcz/kefir	144
5	2026-02-05	Pre-Workout	PW HOME 0	153
5	2026-02-07	Breakfast	naleśniki	\N
5	2026-02-17	Lunch	11Wieprz: Spaghetti Napoli (M)	16
5	2026-02-07	Post-Workout	FF Subway nowe smaki	135
5	2026-02-07	Pre-Workout	\N	\N
5	2026-02-07	Lunch	łososik makaronik batonik	\N
5	2026-02-08	Breakfast	owsianka od Natalii	\N
5	2026-02-08	Lunch	kurczak i chipsy	\N
5	2026-02-08	Post-Workout	gnocchi Natki	\N
5	2026-02-09	Breakfast	LCPA - twaróg/kiwi/kefir	149
5	2026-02-10	Pre-Workout	PW WORK 	151
5	2026-02-10	Supper	Kazeina M	24
5	2026-02-17	Pre-Workout	PW WORK 	151
5	2026-02-09	Lunch	12Wołowina: Stek z frytkami (M)	34
5	2026-02-17	Post-Workout	13Wątróbka: mediterrean (M)	62
5	2026-02-09	Pre-Workout	kanapki jakieś	\N
5	2026-02-17	Supper	Kazeina M	24
5	2026-02-09	Post-Workout	bułka	\N
5	2026-02-09	Supper	\N	\N
5	2026-02-10	Breakfast	putka bajgiel + mleko	\N
5	2026-02-10	Lunch	FF Lawasz z kurczakiem 160g (W Bułce)	130
5	2026-02-10	Post-Workout	12Wołowina: Stek z frytkami (M)	34
5	2026-02-11	Breakfast	LCPA - jaja/kiwi/kefir	147
5	2026-02-11	Pre-Workout	PW WORK 	151
5	2026-02-11	Supper	Kazeina M	24
5	2026-02-11	Lunch	kurczak w cieście	\N
5	2026-02-12	Breakfast	LCPA - łosoś/pomarańcz/kefir	146
5	2026-02-12	Lunch	20Kurczak: Mexicano (M)	39
5	2026-02-12	Pre-Workout	PW HOME 1	154
5	2026-02-12	Post-Workout	FF Double Zinger (KFC)	30
5	2026-02-18	Pre-Workout	PW WORK 	151
5	2026-02-18	Post-Workout	20Kurczak: Kottu (M)	63
5	2026-02-18	Supper	Kazeina M	24
5	2026-02-19	Supper	\N	\N
5	2026-02-18	Breakfast	putka + sba	\N
5	2026-02-20	Pre-Workout	\N	\N
5	2026-02-18	Lunch	FF Lawasz z kurczakiem 160g (W Bułce)	130
5	2026-02-19	Breakfast	LCPA - twaróg/kiwi/kefir	149
5	2026-02-19	Lunch	20Kurczak: Kottu (M)	63
5	2026-02-19	Pre-Workout	PW HOME 2	155
5	2026-02-19	Post-Workout	FF Double Zinger (KFC)	30
5	2026-02-20	Breakfast	LCPA - twaróg/kiwi/kefir	149
5	2026-02-20	Lunch	20Kurczak: Kottu (M)	63
5	2026-02-20	Post-Workout	\N	\N
5	2026-02-21	Breakfast	23M Tosty - Żywiecka - kimchi i szpinak	113
5	2026-02-20	Supper	\N	\N
5	2026-02-21	Lunch	33Łosoś - Frytki i Sos Czosnkowy (M)	66
5	2026-02-23	Breakfast	FF Mlekovita SBA + bieluch	150
5	2026-02-23	Pre-Workout	PW WORK 	151
5	2026-02-22	Breakfast	tosty	\N
5	2026-02-21	Post-Workout	\N	\N
5	2026-02-21	Supper	\N	\N
5	2026-02-21	Pre-Workout	syf	\N
5	2026-02-22	Lunch	kurczak orzo	\N
5	2026-02-23	Post-Workout	baton skyr	\N
5	2026-02-25	Lunch	FF Wrap Wołowina BBQ	126
5	2026-02-24	Breakfast	LCPA - jaja/kiwi/kefir	147
5	2026-02-23	Supper	\N	\N
5	2026-02-23	Lunch	FF Lawasz z kurczakiem 160g (W Bułce)	130
5	2026-02-25	Breakfast	LCPA - jaja/kiwi/kefir	147
5	2026-02-25	Pre-Workout	PW WORK 	151
5	2026-02-25	Supper	Kazeina M	24
5	2026-02-25	Post-Workout	12Wołowina: Burgery i frytki (M)	35
5	2026-02-24	Pre-Workout	PW WORK 	151
5	2026-02-24	Post-Workout	12Wołowina: Burgery i frytki (M)	35
5	2026-02-24	Lunch	FF Lawasz z kurczakiem 160g (W Bułce)	130
5	2026-02-24	Supper	\N	\N
5	2026-02-26	Breakfast	LCPA - łosoś/pomarańcz/kefir	146
5	2026-02-26	Lunch	20Kurczak: Słodko-kwaśny (M)	36
5	2026-02-26	Pre-Workout	PW HOME 3	156
5	2026-02-26	Post-Workout	FF Double Zinger (KFC)	30
5	2026-02-27	Breakfast	LCPA - łosoś/pomarańcz/kefir	146
5	2026-02-27	Pre-Workout	PW HOME 3 (PT)	160
5	2026-02-27	Post-Workout	FF Subway nowe smaki	135
5	2026-02-27	Supper	Kazeina M	24
5	2026-02-26	Supper	\N	\N
5	2026-02-27	Lunch	20Kurczak: Słodko-kwaśny (M)	36
5	2026-02-28	Pre-Workout	PW HOME 3	156
5	2026-02-28	Supper	Kazeina M	24
5	2026-02-28	Breakfast	23M Tosty - Żywiecka - kimchi i szpinak + orange	114
5	2026-03-17	Breakfast	FF Bajgiel i bieluch	42
5	2026-02-28	Post-Workout	\N	\N
5	2026-02-28	Lunch	obiad mamy	\N
5	2026-03-02	Breakfast	FF Mlekovita SBA + bieluch	150
5	2026-03-02	Lunch	FF Lawasz z kurczakiem 160g (W Bułce)	130
5	2026-03-02	Pre-Workout	PW WORK 	151
5	2026-03-02	Supper	Kazeina M	24
5	2026-03-02	Post-Workout	\N	\N
5	2026-03-01	Pre-Workout	pizza	\N
5	2026-03-03	Pre-Workout	PW WORK 	151
5	2026-03-03	Supper	Kazeina M	24
5	2026-03-03	Breakfast	LCPA - twaróg/kiwi/kefir	149
5	2026-03-17	Lunch	FF Lawasz z kurczakiem 160g (W Bułce)	130
5	2026-03-03	Lunch	bistro - wafelek	\N
5	2026-03-03	Post-Workout	FF Double Zinger (KFC)	30
5	2026-03-04	Pre-Workout	PW WORK 	151
5	2026-03-04	Supper	Kazeina M	24
5	2026-03-04	Breakfast	LCPA - twaróg/kiwi/kefir	149
5	2026-03-04	Lunch	FF Lawasz z kurczakiem 160g (W Bułce)	130
5	2026-03-04	Post-Workout	FF Lawasz z kurczakiem 160g (W Bułce)	130
5	2026-03-05	Breakfast	LCPA - twaróg/kiwi/kefir	149
5	2026-03-05	Pre-Workout	PW HOME 0	153
5	2026-03-05	Post-Workout	FF Double Zinger (KFC)	30
5	2026-03-05	Supper	Kazeina M	24
5	2026-03-05	Lunch	13Wątróbka: mediterrean (M)	62
5	2026-03-06	Breakfast	LCPA - twaróg/kiwi/kefir	149
5	2026-03-06	Lunch	20Kurczak: Pad thai (M)	64
5	2026-03-06	Pre-Workout	PW HOME 0 (PT)	157
5	2026-03-06	Post-Workout	FF Subway klasyczek	134
5	2026-03-06	Supper	Kazeina M	24
5	2026-03-07	Breakfast	24M Tosty - Ricotta  + miód&maliny&migdały - lean	142
5	2026-03-07	Lunch	33Łosoś - Chilli-Limonka (M)	68
5	2026-03-07	Pre-Workout	PW HOME 0	153
5	2026-03-07	Post-Workout	33Łosoś - Chilli-Limonka (M)	68
5	2026-03-07	Supper	Kazeina M	24
5	2026-03-09	Breakfast	FF Mlekovita SBA + bieluch	150
5	2026-03-09	Lunch	FF Sałatka Cezar Duża + Bułka z chia	29
5	2026-03-09	Pre-Workout	PW WORK 	151
5	2026-03-09	Post-Workout	31Dorsz: ryż/warzywa (M)	152
5	2026-03-09	Supper	Kazeina M	24
5	2026-03-10	Breakfast	LCPA - jaja/kiwi/kefir	147
5	2026-03-10	Lunch	31Dorsz: ryż/warzywa (M)	152
5	2026-03-10	Pre-Workout	PW WORK 	151
5	2026-03-10	Post-Workout	12Wołowina: Stek z frytkami (M)	34
5	2026-03-10	Supper	Kazeina M	24
5	2026-03-11	Breakfast	LCPA - jaja/kiwi/kefir	147
5	2026-03-11	Lunch	12Wołowina: Stek z frytkami (M)	34
5	2026-03-11	Pre-Workout	PW WORK 	151
5	2026-03-11	Post-Workout	20Kurczak: Tikka Masala (M)	15
5	2026-03-11	Supper	Kazeina M	24
5	2026-03-12	Breakfast	LCPA - łosoś/pomarańcz/kefir	146
5	2026-03-12	Lunch	20Kurczak: Tikka Masala (M)	15
5	2026-03-12	Pre-Workout	PW HOME 1	154
5	2026-03-12	Post-Workout	FF Double Zinger (KFC)	30
5	2026-03-12	Supper	Kazeina M	24
5	2026-03-13	Breakfast	LCPA - łosoś/pomarańcz/kefir	146
5	2026-03-13	Lunch	20Kurczak: Tikka Masala (M)	15
5	2026-03-13	Pre-Workout	PW HOME 1 (PT)	158
5	2026-03-13	Post-Workout	FF Subway nowe smaki	135
5	2026-03-13	Supper	Kazeina M	24
5	2026-03-14	Breakfast	11M Owsianka - jagodowa - lean	143
5	2026-03-14	Lunch	33Łosoś - Frytki i Sos Czosnkowy (M)	66
5	2026-03-14	Pre-Workout	PW HOME 1	154
5	2026-03-14	Post-Workout	33Łosoś - Frytki i Sos Czosnkowy (M)	66
5	2026-03-14	Supper	Kazeina M	24
5	2026-03-16	Supper	Kazeina M	24
5	2026-03-16	Lunch	\N	\N
5	2026-03-17	Post-Workout	FF Double Zinger (KFC)	30
5	2026-03-16	Breakfast	11M Owsianka - jagodowa	103
5	2026-03-16	Post-Workout	FF Double Zinger (KFC)	30
5	2026-03-16	Pre-Workout	PW HOME 2	155
5	2026-03-17	Pre-Workout	PW WORK 	151
5	2026-03-18	Breakfast	LCPA - jaja/pomarańcz/kefir	144
5	2026-03-18	Pre-Workout	PW WORK 	151
5	2026-03-18	Supper	Kazeina M	24
5	2026-03-17	Supper	\N	\N
5	2026-03-18	Lunch	FF Wrap Wołowina BBQ	126
5	2026-03-21	Breakfast	23M Tosty - Żywiecka - kimchi i szpinak	113
5	2026-03-18	Post-Workout	grander	\N
5	2026-03-19	Breakfast	LCPA - twaróg/kiwi/kefir	149
5	2026-03-19	Lunch	20Kurczak: Wrap (M)	14
5	2026-03-19	Pre-Workout	PW HOME 2	155
5	2026-03-19	Post-Workout	FF Double Zinger (KFC)	30
5	2026-03-19	Supper	Kazeina M	24
5	2026-03-20	Breakfast	LCPA - twaróg/kiwi/kefir	149
5	2026-03-20	Lunch	20Kurczak: Wrap (M)	14
5	2026-03-20	Pre-Workout	PW HOME 2 (PT)	159
5	2026-03-20	Post-Workout	FF Subway klasyczek	134
5	2026-03-20	Supper	Kazeina M	24
5	2026-03-21	Pre-Workout	PW HOME 2	155
5	2026-03-21	Lunch	20Kurczak: Wrap (M)	14
5	2026-03-21	Supper	mc flurry na pół	\N
5	2026-03-22	Lunch	lasagne	\N
5	2026-03-21	Post-Workout	lasagne	\N
5	2026-03-23	Pre-Workout	PW WORK 	151
5	2026-03-23	Supper	Kazeina M	24
5	2026-03-24	Pre-Workout	PW WORK 	151
5	2026-03-23	Breakfast	elo	\N
5	2026-03-24	Breakfast	elo	\N
5	2026-03-24	Post-Workout	FF Double Zinger (KFC)	30
5	2026-03-23	Lunch	FF Lawasz z kurczakiem 160g (W Bułce)	130
5	2026-03-24	Lunch	\N	\N
5	2026-03-23	Post-Workout	owoce i serek	\N
5	2026-03-25	Breakfast	LCPA - jaja/kiwi/kefir	147
5	2026-03-25	Pre-Workout	PW WORK 	151
5	2026-03-24	Supper	\N	\N
5	2026-03-25	Lunch	FF Sałatka Cobb Duża + Bułka z chia	28
5	2026-03-26	Pre-Workout	PW HOME 3	156
5	2026-03-25	Post-Workout	\N	\N
5	2026-03-25	Supper	\N	\N
5	2026-03-26	Breakfast	LCPA - twaróg/pomarańcz/kefir	145
5	2026-03-26	Post-Workout	\N	\N
5	2026-03-26	Supper	\N	\N
5	2026-03-26	Lunch	chinol	\N
5	2026-03-27	Breakfast	11M Owsianka - jagodowa	103
5	2026-03-27	Lunch	tuna fryta	\N
5	2026-03-27	Supper	\N	\N
5	2026-03-27	Post-Workout	\N	\N
5	2026-03-27	Pre-Workout	rollo Żabka	\N
5	2026-03-28	Post-Workout	\N	\N
5	2026-03-28	Supper	\N	\N
5	2026-03-28	Breakfast	\N	\N
5	2026-03-28	Lunch	tuńczyk+ skyr	\N
5	2026-03-28	Pre-Workout	obiad mamy	\N
\.


--
-- Data for Name: diets; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.diets (id, name, descr) FROM stdin;
5	LeanBulk Theta (Wiosna 2026)	Lean bulk 2900 +0.18kg/week
4	Ilness-fallback	2700 kcal TDEE (na 8k kroków) i łatwe/szybkie/smaczne dania
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
36	MainMeal	20Kurczak: Słodko-kwaśny (M)	
17	MainMeal	20Kurczak: Gyros (M)	
77	Breakfast	23A Tosty - Żywiecka	
63	MainMeal	20Kurczak: Kottu (M)	
62	MainMeal	13Wątróbka: mediterrean (M)	
22	MainMeal	11Wieprz: Schab pieczony (M)	
38	MainMeal	11Wieprz: Penne&Pesto (M)	
148	Breakfast	LCPA - łosoś/kiwi/kefir	
158	Pre-Workout	PW HOME 1 (PT)	
64	MainMeal	20Kurczak: Pad thai (M)	
25	Supper	Twaróg klinek chudy	
14	MainMeal	20Kurczak: Wrap (M)	
90	Breakfast	32M Jajecznica - Mexicano + pomarańcza&pestki dyni	
54	MainMeal	11A Red Meat - Pork - (schab, polędwiczka)	
34	MainMeal	12Wołowina: Stek z frytkami (M)	
41	MainMeal	40Hallouumi: Quinoa/Grillowana Papryka	
30	MainMeal	FF Double Zinger (KFC)	
88	Pre-Workout	XJ2 - Jebaniec na zimno (sernik)	
39	MainMeal	20Kurczak: Mexicano (M)	
32	MainMeal	FF Kebab King mały lawasz kurczak bez sosu	
55	MainMeal	12A Red Meat - Beef - (Stek, Kotlet)	
79	Breakfast	24A Tosty - Ricotta (na słodko)	
56	MainMeal	13A Red Meat - Liver - (Wątróbka)	
57	MainMeal	20A - Poultry - (Kurczak, Indyk)	
58	MainMeal	31A - Fish - Lean - (Dorsz, Miruna)	
18	MainMeal	33Łosoś - Salsa Awokado (M)	
15	MainMeal	20Kurczak: Tikka Masala (M)	
85	Breakfast	40M Kanapki  - Indyk&Awokado	
19	MainMeal	31Dorsz: cytrynowo-pietruszkowy (M)	
20	MainMeal	40Krewetki: Masło/Czosnek	
26	MainMeal	31Miruna: jak nad morzem (M)	
31	MainMeal	31Miruna: kluski&dżem (M)	
24	Supper	Kazeina M	
66	MainMeal	33Łosoś - Frytki i Sos Czosnkowy (M)	
113	Breakfast	23M Tosty - Żywiecka - kimchi i szpinak	
67	MainMeal	33Łosoś - Ziemniaki w mundurkach z dipem (M)	
68	MainMeal	33Łosoś - Chilli-Limonka (M)	
16	MainMeal	11Wieprz: Spaghetti Napoli (M)	
106	Breakfast	40M Kanapki - Masło orzechowe & Banan Marchew obok	
95	Breakfast	21M Tosty - Konserwowa + jabłko i marchew	
94	Breakfast	21M Tosty - Konserwowa + pomarańcza i marchew	
35	MainMeal	12Wołowina: Burgery i frytki (M)	
59	MainMeal	32A - Fish - Semi-fatty - (Pstrąg)	
91	Breakfast	33M Jajecznica - Na słodko + płatki&maliny&mleko&miód	
60	MainMeal	33A - Fish - Fatty - (Łosoś, Halibut)	
61	MainMeal	40A - Extras - (Krewetki, Tofu, Halloumi)	
65	MainMeal	20Kurczak: Asian Stri-Fry (M)	
92	Breakfast	33M Jajecznica - Na słodko + banan/migdały/tosy/peanut-butter	
160	Pre-Workout	PW HOME 3 (PT)	
83	Breakfast	40M Kanapki - Masło orzechowe & Banan	
23	MainMeal	13Wątróbka: groch/cebula (M)	
84	Breakfast	40M Kanapki - Kefir Protein Shake	
93	Breakfast	33M Jajecznica - Na słodko + kiwi/kefir/orzechy	
163	MainMeal	XJ3 Chipotle hot pockets 10x	
159	Pre-Workout	PW HOME 2 (PT)	
157	Pre-Workout	PW HOME 0 (PT)	
103	Breakfast	11M Owsianka - jagodowa	
42	Breakfast	FF Bajgiel i bieluch	
107	Breakfast	40M Kanapki  - Indyk&Awokado + jabłko	
98	Breakfast	24M Tosty - Ricotta + banan&kakao&chia	
96	Breakfast	21M Tosty - Konserwowa + shake(masło orzechowe&truskawki	
73	Breakfast	11A Owsianka	
80	Breakfast	40A Kanapki	
6	Breakfast	31A Jajecznica - Tuńczyk	
76	Breakfast	22A Tosty - Krakowska	
78	Breakfast	21A Tosty - Konserwowa	
33	Breakfast	33A Jajecznica - Na słodko	
81	Breakfast	FF Kanapka z szarpaną wołowiną i bieluch + kiwi	
7	Breakfast	32A Jajecznica - Mexicano	
86	Pre-Workout	XJ1 Waniliowy Jebaniec (Sernik)	
82	Breakfast	40M Kanapka z serkiem wiejskim	
74	Breakfast	12A Jaglanka	
87	MainMeal	XJ1 - Pizza białkowa	
89	Breakfast	32M Jajecznica - Mexicano + kefir i szpinak	
102	Breakfast	11M Owsianka - wiśniowa	
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
112	Breakfast	33M Jajecznica - Na słodko + kiwi/orzechy/siemie	
114	Breakfast	23M Tosty - Żywiecka - kimchi i szpinak + orange	
115	Breakfast	23M Tosty - Żywiecka - shake(jagody, siemie)	
116	Breakfast	23M Tosty - Żywiecka - shake(kiwi, szpinak)	
97	Breakfast	24M Tosty - Ricotta  + miód&maliny&migdały	
117	Breakfast	24M Tosty - Ricotta - shake(kiwi, szpinak)	
118	Breakfast	24A Tosty - Ricotta + orange	
119	Breakfast	13M Ryżanka - marchew tarta/mango/cynamon	
75	Breakfast	13A Ryżanka	
120	Breakfast	13M Ryżanka - mango/chia/jagody	
21	MainMeal	11Wieprz: Musztardowo-miodowa (M)	
155	Pre-Workout	PW HOME 2	
156	Pre-Workout	PW HOME 3	
161	Pre-Workout	XJ4 - Pudding Czekoladowy	
149	Breakfast	LCPA - twaróg/kiwi/kefir	
121	Breakfast	13M Ryżanka - truskawki/miód/kakao	
150	Breakfast	FF Mlekovita SBA + bieluch	
123	Pre-Workout	XJ3 - Jebańcowe obłoczki	
124	MainMeal	XJ2 - Arepas de Victor	
28	MainMeal	FF Sałatka Cobb Duża + Bułka z chia	
125	MainMeal	FF Sałatka Awokado Rybak Duża + Bułka z chia	
127	MainMeal	FF Sałatka z kurczakiem (Putka)	
130	MainMeal	FF Lawasz z kurczakiem 160g (W Bułce)	
134	MainMeal	FF Subway klasyczek	
135	MainMeal	FF Subway nowe smaki	
153	Pre-Workout	PW HOME 0	
154	Pre-Workout	PW HOME 1	
151	Pre-Workout	PW WORK 	
147	Breakfast	LCPA - jaja/kiwi/kefir	
131	Breakfast	Weź suple po obiedzie (kiwi)	
137	Breakfast	Weź suple po obiedzie (pomarańcza)	
146	Breakfast	LCPA - łosoś/pomarańcz/kefir	
126	MainMeal	FF Wrap Wołowina BBQ 	
138	MainMeal	FF Nachos Sanwich bez sosu (Kebab King)	
139	Pre-Workout	Skyr + pomarańcza	
140	Pre-Workout	Skyr + kiwi	
141	Breakfast	24M Tosty - Ricotta + banan&kakao&chia - lean	
152	MainMeal	31Dorsz: ryż/warzywa (M)	
142	Breakfast	24M Tosty - Ricotta  + miód&maliny&migdały - lean	
143	Breakfast	11M Owsianka - jagodowa - lean	
144	Breakfast	LCPA - jaja/pomarańcz/kefir	
162	MainMeal	XJ3 - Chicken Breast Calzone	
145	Breakfast	LCPA - twaróg/pomarańcz/kefir	
122	Breakfast	11M Owsianka - żurawinowa	
\.


--
-- Data for Name: ingredient_amounts; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.ingredient_amounts (dish_id, ingredient_id, amount) FROM stdin;
93	4	4
93	58	1
93	27	100
93	23	100
153	1	220
153	36	200
153	197	50
153	25	50
153	11	10
153	16	10
93	10	10
142	123	6
77	5	6
77	6	3
77	146	50
142	147	100
142	164	120
107	8	2
142	25	20
107	34	100
80	8	2
107	153	100
29	112	1
29	150	1
85	8	2
85	23	200
85	34	100
85	153	100
85	19	80
85	18	30
85	52	5
155	1	220
121	4	2
121	144	80
121	3	200
121	29	100
121	25	20
121	16	20
155	197	50
155	143	150
86	4	3
86	1	150
86	155	1
86	156	10
155	25	50
155	137	15
155	11	10
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
15	42	120
152	44	150
152	47	150
152	139	100
152	255	50
152	78	10
152	71	1
152	79	1
152	72	1
152	34	50
15	22	75
15	46	100
15	70	20
15	52	8
15	67	1
15	68	10
15	69	10
17	51	250
17	42	120
17	22	100
17	52	8
17	17	40
17	76	30
17	19	20
17	77	1
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
161	1	400
161	11	30
161	25	30
123	1	150
123	4	1
123	157	40
123	170	100
123	171	7
28	111	1
28	150	1
161	16	30
161	156	20
125	150	1
125	173	1
145	107	150
145	23	200
26	51	350
26	108	200
26	22	50
26	59	20
145	24	120
145	166	10
145	268	100
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
25	107	150
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
156	1	220
32	118	1
156	197	50
156	143	150
156	25	50
156	15	14
156	31	10
16	49	110
16	89	120
16	6	1
62	84	100
62	94	125
16	46	100
74	145	100
74	4	1
74	3	100
62	91	200
62	30	150
62	53	50
62	52	8
62	69	10
143	2	100
87	6	2
87	152	1
87	158	60
87	157	50
87	4	1
87	38	50
87	9	30
16	73	60
143	3	200
16	52	8
16	17	30
16	56	10
143	4	1
143	106	100
16	74	20
78	5	6
78	6	3
78	9	50
81	151	1
81	134	1
81	27	100
16	75	1
16	66	1
158	1	220
158	197	60
158	143	150
158	25	60
82	8	2
82	152	1
82	24	100
82	10	10
82	25	10
83	8	2
83	39	30
83	26	90
83	13	1
158	12	12
158	31	18
159	1	220
159	197	60
159	143	150
99	145	100
99	4	1
99	3	100
99	165	40
99	25	10
99	11	10
16	71	1
16	72	1
159	25	60
159	137	20
84	8	2
84	23	200
84	4	2
84	39	20
159	11	10
35	58	2
160	1	220
160	197	60
160	143	150
31	122	130
31	108	180
31	121	100
160	25	60
160	15	20
160	31	10
31	126	100
150	252	1
150	134	1
31	73	50
150	27	100
35	128	1
35	51	80
35	126	50
35	20	50
35	22	10
35	59	10
35	19	20
35	21	20
35	60	5
35	62	10
65	87	100
65	42	120
65	139	150
65	137	15
103	2	100
103	3	200
103	4	1
103	106	100
103	39	40
65	52	8
65	25	10
65	74	30
65	56	10
111	4	4
111	58	1
111	53	150
111	27	100
111	166	20
111	15	10
65	129	15
65	68	3
65	71	1
65	72	1
104	8	2
104	167	200
104	166	20
104	24	100
104	148	60
54	89	100
55	43	100
56	94	100
57	42	100
58	47	100
59	131	100
60	83	100
61	86	100
108	8	2
108	23	200
108	168	60
108	24	100
108	133	100
108	30	100
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
157	1	220
157	36	200
157	197	60
157	25	60
157	11	15
101	145	100
101	4	1
101	14	100
101	3	100
101	25	30
101	11	10
62	72	1
157	16	10
163	42	1135
126	174	1
66	51	200
66	83	120
66	22	60
66	133	100
66	56	10
66	55	5
6	4	4
6	148	50
6	149	1
163	275	500
33	4	4
163	22	520
163	158	70
163	25	60
163	186	30
163	74	10
34	43	150
34	51	200
34	18	100
34	126	50
34	52	5
34	55	20
34	71	1
34	72	1
36	44	100
36	42	120
36	38	100
36	25	20
36	60	40
36	62	60
36	52	6
22	84	100
22	89	150
22	52	20
22	73	100
36	17	30
36	73	20
36	129	10
151	1	300
151	164	250
151	26	90
151	199	1
20	87	100
20	86	200
20	127	20
20	88	15
20	56	20
20	28	20
20	55	10
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
90	4	4
90	149	1
90	24	100
90	65	30
90	64	30
90	12	20
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
64	87	100
64	42	100
64	4	1
64	127	10
64	52	8
64	73	40
41	85	100
41	95	100
41	161	15
41	17	50
41	52	6
41	28	10
41	55	10
64	62	40
64	25	10
64	56	10
64	74	20
64	129	15
64	69	10
64	55	10
154	1	220
75	144	80
75	4	2
75	3	200
120	144	80
120	4	2
120	3	200
120	37	100
120	106	50
154	197	50
154	143	150
154	25	50
154	12	12
154	31	12
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
147	4	3
147	23	200
147	27	100
146	23	200
139	1	300
139	24	150
38	71	1
38	79	2
38	72	1
18	83	120
18	130	100
18	34	80
18	18	50
18	52	8
18	63	40
18	82	50
18	69	10
18	57	1
68	140	100
68	83	120
68	142	2
68	19	30
68	56	10
68	129	10
68	141	10
146	253	100
146	24	120
146	15	10
162	42	350
162	6	3
162	153	100
162	261	70
162	262	20
162	19	50
162	66	1
162	263	10
162	264	10
162	55	20
162	71	1
162	72	1
162	57	1
24	91	150
24	102	40
21	256	100
21	89	100
21	25	35
21	257	80
21	255	50
21	59	30
21	52	8
21	90	1
112	27	100
112	31	10
23	96	100
23	91	200
23	94	120
23	62	200
23	30	150
23	97	1
23	90	2
113	5	6
113	6	3
113	146	50
113	23	100
113	30	50
67	132	350
67	83	120
67	53	50
67	154	30
148	23	200
148	253	100
148	27	100
148	15	10
67	56	5
67	78	10
67	55	5
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
122	2	100
122	169	70
122	4	1
122	3	100
14	61	2
98	6	3
98	147	100
98	26	100
98	11	10
98	16	10
98	123	6
14	42	120
14	22	75
14	52	8
79	123	6
79	6	2
79	147	100
14	67	1
117	123	6
117	6	2
117	147	100
117	27	100
117	23	100
117	166	15
117	30	50
149	107	150
63	61	2
14	17	30
14	59	10
63	42	120
97	6	2
97	147	100
97	164	120
97	15	15
97	25	20
97	123	6
63	4	1
63	135	1
63	126	80
63	73	40
63	52	6
14	20	20
141	123	6
141	147	100
141	26	100
141	11	10
14	21	10
39	45	100
39	42	120
39	65	50
39	64	50
39	52	6
39	67	1
39	62	20
39	17	20
39	63	20
39	57	1
19	85	150
19	47	120
19	52	8
19	28	30
19	73	100
19	54	10
19	55	10
19	71	1
19	72	1
14	66	1
14	57	1
63	62	30
63	129	20
63	69	10
149	23	200
149	27	100
149	10	10
149	268	100
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
38	Ananas	g	100	Świeże	55	0.4	0.2	13.6	200	f
17	Papryka czerwona	g	100	Świeże	32	1.3	0.5	6.6	200	f
18	Rukola	g	100	Świeże	25	2.6	0.7	3.6	200	f
19	Pomidor	g	100	Świeże	19	0.9	0.2	4.1	200	f
20	Ogórek kiszony	g	100	Świeże	13	1.1	0.1	1.4	310	f
21	Sałata lodowa (Asda)	g	100	Świeże	14	1.2	0.5	1.4	200	f
22	Jogur grecki XXL (Pilos)	g	100	Lidl	123	3.6	10	4.7	730	f
23	Kefir (Robico)	g	100	Lidl	47	3	2	4.2	740	f
24	Pomarańcza	g	100	Świeże	47	0.9	0.2	11.3	200	f
59	Musztarda sarepska (Kamis)	g	100	Zapasy	101	3.7	5.1	8.3	2000	f
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
68	Imbir świeży	g	100	Świeże	80	1.8	0.7	17.8	350	f
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
67	Papryka słodka 22g (Kamis)	szczypta	1	Zapasy	3	0.1	0.1	0.6	350	f
61	Tortilla pszenna wraps 245g (PANO)	sztuka	1	Lidl	195	5.9	4.6	31.9	120	f
62	Cebula	g	100	Świeże	33	1.4	0.4	6.9	200	f
63	Cebula czerwona	g	100	Świeże	30	1.4	0.4	6.9	200	f
64	Kukurydza złocista	g	100	Lidl	94	3.2	1	19	310	f
65	Fasola	g	100	Lidl	288	21.4	1.6	61.6	310	f
10	Orzechy włoskie (Alesto)	g	100	Zapasy	712	15.5	69.1	3.7	410	f
66	Oregano	szczypta	1	Zapasy	3	0.1	0	0.7	350	f
69	Kolendra świeża	g	100	Zapasy	23	2.1	0.3	3.7	350	f
39	Masło orzechowe (GO ON)	g	100	Zapasy	581	17	46	12	1210	f
11	Nasiona chia (Promienie słoneczne)	g	100	Zapasy	489	14.3	32.1	50	410	t
15	Migdały	g	100	Zapasy	604	24.1	52	20.5	400	f
25	Miód lipowy (Bartnik)	g	100	Zapasy	333	0.3	0	83	1210	f
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
116	Frytki Duże (KFC)	porcja	1	Na żywo	268	4.1	12	35	5000	f
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
100	Morele suszone	g	100	Zapasy	301	5.4	1.2	72.2	400	f
127	Orzeszki ziemne prażone, niesolone (Alesto) 500g	g	100	Zapasy	610	25.8	49.2	11.6	400	f
76	Ogórek zielony	g	100	Świeże	14	0.7	0.1	2.9	200	f
106	Jagody mrożone	g	100	Lidl	65	0.8	1.1	10	890	f
82	Pomidorki koktajlowe	g	100	Świeże	19	1	0.2	2.9	200	f
108	Miruna Nowozelandzka filet (Marinero)	g	100	Lidl	78	16	1.5	0	500	f
109	Skyr pitny naturalny (Piątnica) 330g	opakowanie	1	Świeże	211	25.1	5.9	14.2	700	f
1	Skyr naturalny Jogurt typu Islandzkiego (Piątnica) 450g	g	100	Lidl	64	12	0	4.1	700	f
98	Mięta liście	g	100	Świeże	43	3.8	0.7	5.3	200	f
122	Makaron conchiglie (Pastani)	g	100	Lidl	354	12	1.5	71	900	f
123	Tosty pszenny (Z dobrej piekarni)	kromka	1	Lidl	61	1.9	0.3	12.3	190	f
124	Kiełbasa krakowska sucha (Olewnik)	g	100	Lidl	130	32	8	1.2	650	f
125	Krewetki białe Vannamei (225g)	g	100	Lidl	90	20	1	0.5	810	f
128	Burger wołowy Lidl (1 sztuka 110g)	sztuka	1	Lidl	240	20.9	16.5	1.1	500	f
131	Pstrąg Tęczowy Łososiowy (Targ rybny)	g	100	Lidl	197	18.8	13.5	0	500	f
132	Ziemniaki	g	100	Lidl	87	1.9	0.1	20.5	200	f
133	Brokuły	g	100	Świeże	31	3	0.4	5.2	200	f
134	Serek Naturalny Bieluch (150g)	opakowanie	1	Na żywo	191	12.9	12.8	6	730	f
87	Makaron ryżowy wstążki	g	100	Lidl	350	6.2	0.1	81.3	900	f
90	Tymianek	szczypta	1	Zapasy	0	0	0	0	350	t
101	Kazeina micelarna (Biały Puch)	g	100	Lidl	355	80	1.6	5.2	5000	f
113	Bowl Toskański Kurczak (Salad Story)	porcja	1	Świeże	583	32	27	53	5000	f
92	Rozmaryn szuszony	szczypta	1	Zapasy	3	0.1	0.1	0.6	350	t
73	Marchew	g	100	Świeże	33	1	0.2	8.7	200	f
89	Schab wieprzowy 9 plastrów (Rzeźnik)	g	100	Lidl	128	24	4	0	500	f
126	Kapusta pekińska	g	100	Świeże	16	1	0	3	200	f
121	Łowicz Dżem 100% owoców czarna porzeczka 210g (Łowicz)	g	100	Lidl	132	1.1	0.5	28	1205	f
136	Spaghetti pełnoziarniste (Combino)	g	100	Lidl	350	15.4	2.7	62	900	f
165	Rodzynki Jumbo (Alesto)	g	100	Zapasy	331	3	2	72	400	f
139	Chińska mieszanka warzyw 450g (Proste Historie)	g	100	Lidl	28	1.6	0.3	3.4	815	f
140	Ryż jaśminiowy	g	100	Lidl	349	6.8	0.8	78	900	f
141	Chilli świeże lub suszone	g	100	Świeże	0	0	0	0	200	f
137	Orzechy nerkowca	g	100	Zapasy	554	18.2	43.8	30.4	400	f
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
138	Kurkuma	szczypta	1	Zapasy	0	0	0	0	350	f
173	Sałatka Awokado Rybak (Salad Story)	porcja	1	Na żywo	530	32.76	27.43	32.76	5000	f
72	Pieprz czarny mielony	szczypta	1	Zapasy	0	0	0	0	350	t
77	Tzatziki przyprawa	szczypta	1	Zapasy	0	0	0	0	350	t
172	Mąka kukurydziana biała PAN 1kg (google: Mąka kukurydziana precooked (Harina PAN))	g	100	Lidl	357	78	2	75.5	2000	f
142	Limonka	sztuka	1	Świeże	28	0.7	0.2	10	200	f
166	Orzechy laskowe łuskane (Alesto)	g	100	Zapasy	658	15	61	6.7	400	f
149	Bułka orkiszowa	sztuka	1	Na żywo	200	6.4	1.6	40	100	f
177	Białko (clean)	g	100	Na żywo	400	100	0	0	5000	f
186	Majonez Lekki (Winiary)	g	100	Lidl	338	1.1	33.2	8.4	2000	f
185	Protein pillow o smaku karmelowym (Brownfield)	g	100	Lidl	437	20	18	52	1200	f
151	Kanapka z szarpaną wołowiną (Galeria Wypieków Lubaszka)	sztuka	1	Na żywo	588	25	22.14	70.2	5000	f
187	Schab pieczony 	g	100	Lidl	291	30.4	18.7	0.3	2000	f
103	Danone YoPro Jogurt smak straciatella 160g (Danone YoPro)	sztuka	1	Na żywo	91	15	0.8	5.8	5000	f
169	Żurawina suszona 200g (Alesto)	g	100	Lidl	338	0.7	1.2	78	400	f
190	MC Crispy (Mac Donald's)	sztuka	1	Na żywo	550	27	23	56	2000	f
161	Pestki słonecznika 500g (Alesto)	g	100	Zapasy	616	21.4	53.9	5.1	400	f
183	Szynka z fileta indyka (Pikok)	g	100	Lidl	115	19	3	2.7	600	f
184	Orzechy laskowe prażone (Alesto)	g	100	Zapasy	722	14.3	70.5	3.5	400	t
167	Kimchi ostre (Freshona)	g	100	Lidl	46	1.8	0.4	8	310	f
148	Tuńczyk w puszce 170g (Nixe)	g	100	Lidl	109	25.4	0.8	0	320	f
170	Białka jaj	g	100	Lidl	50	11	0.2	0.7	1100	f
156	Erytrytol	g	100	Zapasy	0	0	0	0	5000	t
175	Sałatka z kurczakiem 330g (Putka)	porcja	1	Na żywo	676.5	33	4	73	5000	f
176	ChaiKola	sztuka	1	Na żywo	118.8	0	0	28.7	5000	f
178	Tłuszcz (clean)	g	100	Na żywo	900	0	100	0	5000	f
174	Wrap Wołowina Bekon (Salad Story)	porcja	1	Na żywo	710.2	29.8	36.9	63.7	5000	f
193	Prince Polo XXL 50g	sztuka	1	Na żywo	266	2.3	15	30	2000	f
99	Przyprawa meksykańska (Naturalny Koszyk)	g	100	Zapasy	218	9.3	5.8	19.6	350	t
150	Bułka z chia (Galeria Wypieków Lubaszka)	sztuka	1	Na żywo	279	9.9	8.46	38.7	5000	f
179	Węglowodany (clean)	g	100	Na żywo	400	0	0	100	5000	f
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
252	SBA protein milkshake truskawka (Mlekovita) 350ml	sztuka	1	Na żywo	207	26	2.5	17	2000	f
256	Kasza gryczana (Lidl) kcal	g	100	Lidl	347	13.5	3.1	63.4	2000	f
251	Napoleonka ciasto	g	100	Na żywo	268	9.2	6.3	43	2000	f
255	Jarmuż	g	100	Świeże	51	2.9	1.5	4.4	2000	f
191	Frytki małe (Mc Donald's)	porcja	1	Na żywo	231	2.7	11.2	28.8	2000	f
192	Ketchup extra hot (kotlin)	g	100	Lidl	99	1.4	0.5	21	2000	f
248	Baton protein crisp (GO ON) 50g	sztuka	1	Na żywo	238	10	12	23	2000	f
253	Łosoś norweski wędzony na zimno plastry (Nautica) 100g	g	100	Lidl	174	20	10.4	0	2000	f
254	Kurczaker (Żabka) 190g	sztuka	1	Na żywo	406	26	15	40	2000	f
257	Brzoskwinie	g	100	Świeże	46	0.9	0.2	9.5	2000	f
247	Żelki ogólna estymata	g	100	Na żywo	343	6.9	0.5	77	2000	f
258	WPC 80 (KFD Nutrition)	g	100	Lidl	417	79	7	10	2000	f
259	Dzik salty Carmel Protein Bar	sztuka	1	Na żywo	278	30	9.5	19	2000	f
218	Czekolada (ogólna estymata)	g	100	Na żywo	546	7.6	29.7	59.4	2000	f
260	Chleb 3 ziarna(SPC)	g	100	Lidl	274	9.6	4.8	46	2000	f
261	Śmietana 12% (Piątnica) 400g	g	100	Lidl	134	2.7	12	3.9	2000	f
262	Grana Padano (Milbona) 200g	g	100	Lidl	398	33	29	0	2000	f
263	Papryka wędzona przyprawa	g	100	Zapasy	289	15	13	56	2000	f
264	Musztarda Dijon (Kania) 180g	g	100	Lidl	149	7.2	11	1.8	2000	f
265	Czekolada Milka Mmmax Choco Jelly	g	100	Lidl	516	5.5	27	62	2000	f
266	jogurt śmietankowy (Maluta) 220g	sztuka	1	Na żywo	237.6	6.16	19.8	8.8	2000	f
267	Muesli z owocami o orzechami (Vitanella) 420g	g	100	Lidl	398	8	12.6	59.4	2000	f
268	Frulove (In jelly)	g	100	Lidl	45	2.6	0.5	19	2000	f
269	Baton Muesli Bar (Vitanella) 40g	sztuka	1	Na żywo	190	4.4	9.6	21	2000	f
270	Naleśniki z serem (Piotr i Paweł)	g	100	Lidl	170	8	3.4	26	2000	f
271	Ptasie Mleczko (Wedel) 1 porcja	porcja	1	Na żywo	43	0.2	2.3	5.5	2000	f
272	Lay's Fromage (Lay's) 140g	g	100	Na żywo	525	6.8	32	50	2000	f
273	protein cream (Maribel) 180g	g	100	Lidl	561	24	43	26	2000	f
274	Prince Polo małe 17.5g	sztuka	1	Lidl	93	0.8	5.2	10	2000	f
275	Mąka samorosnąca (Polskie Młyny) typ 480	g	100	Lidl	354	12	1.5	73	2000	f
276	sok z manho	g	100	Lidl	49	0	0.5	13	2000	f
277	bułka sznytka (Lubaszka) 60g	sztuka	1	Lidl	160	4.7	1.3	31.8	2000	f
278	ser mimolette	g	100	Lidl	320	25.3	23.9	0	2000	f
279	Choco wafer (Milka)	sztuka	1	Lidl	161	2	9.3	16.8	2000	f
280	Chicken bites (Chef Select)	g	100	Lidl	213	17	8.7	12	2000	f
282	nóżka z kurczaka (KFC)	sztuka	1	Na żywo	169	15	9.5	6.1	2000	f
283	chleb baltonowski	g	100	Lidl	257	7.7	1.5	51.5	2000	f
284	Maxi King (Kinder) 35g	sztuka	1	Na żywo	182	2.3	13.1	13.4	2000	f
281	tortilla z tuńczykiem (Putka) 290g	porcja	1	Lidl	475	13	20	61	2000	f
285	Grander (KFC)	sztuka	1	Na żywo	756	37	38	61	2000	f
\.


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.recipes (dish_id, time_total, what_before, preparation, when_start) FROM stdin;
148				
42				
63			1. Podsmaż mięso na 5 g oleju, odstaw.\n2. Na tej samej patelni podsmaż cebulę, czosnek, marchew i kapustę.\n3. Dodaj przyprawę curry i łyżkę sosu sojowego.\n4. Wbij jajko i zamieszaj, aż się zetnie.\n5. Dorzuć mięso i pokrojone paski tortilli.\n6. Wlej 2–3 łyżki mleczka kokosowego (opcjonalnie) i smaż 1–2 minuty, mieszając jak „na wok”.\n7. Pod koniec polej resztą oleju i ewentualnie dopraw do smaku.	
76				
23			**RANO**\n- Przepłucz groch, zalej zimną wodą (w całości pokryty), przykryj i wstaw do lodówki.\n\n**WIECZOREM**\n1. Wątróbkę pokrój na duże kawałki, wrzuć do miski z oliwą, majerankiem i tymiankiem. Odstaw na 10–15 min (lodówka).\n2. Wymień wodę w grochu i gotuj 10–15 min na małym ogniu.\n3. W tym czasie pokrój cebulę w pióra i jabłko w półplastry. Na patelnię daj odrobinę oliwy, zeszklij cebulę 4–5 min, dodaj jabłko na 1–2 min. Potem przesuń je na bok lub zdejmij z patelni.\n4. Na tę samą, dobrze rozgrzaną patelnię wrzuć wątróbkę. Smaż 60–90 s na stronę na dużym ogniu.\n5. Dopraw solą i pieprzem, dodaj z powrotem cebulę i jabłko, dorzuć szpinak i podgrzewaj razem ~30 s.\n	
157				
158				
25				
159				
36	ok. 25–30 minut		Ryż: ugotuj ryż (100 g suchego) według instrukcji (ok. 12 min).\nKurczak: pokrój filet w kostkę, dopraw solą i pieprzem. Usmaż na 6 g oliwy, aż będzie złoty.\nWarzywa: pokrój paprykę, cebulę i marchew w słupki/plastry. Dodaj na patelnię do kurczaka i podsmażaj 3–4 minuty.\nAnanas: dorzuć kostki ananasa, zamieszaj.\nSos słodko-kwaśny: wymieszaj w kubku sos sojowy, keczup, ocet i cukier/miód + 50 ml wody. Wlej na patelnię, duś całość 3–4 minuty, aż zgęstnieje.\nPodanie: podaj na ryżu.	
147				
26			Mirunę pieprzem przed. Cyk do piekarnika frytki też. Potem sos miliona jezior z jogurtu greckiego, musztardy i ketchupu.	
32				
160				
85			Zblenduj lub rozgnieć awokado z odrobiną soku z cytryny i szczyptą soli.\nPosmaruj nim 2 z 3 kromek chleba.\nUłóż szynkę, rukolę i pomidora.\nSkrop całość łyżeczką oliwy z oliwek.\nPopij 200 ml kefiru (probio).	
18				
6				
14				
149				
19				
38				
96				
68			1. Łososia posmaruj mieszanką sosu sojowego, czosnku i soku z limonki.\n2. Odstaw na 10–15 min, potem smaż lub piecz.\n3. W tym czasie ugotuj ryż jaśminowy.\n4. Podawaj z odrobiną chili i sokiem z limonki na wierzchu.	
20				
16			Marchew zetrzyj, ser roladę ustrzycką zetrzyj	
113				
66				
78				
34			Frytki i steka soczyście solisz.\n\nZ jogurtu, kapusty, soku z cytryny i pieprzu robisz sałatkę jak mama kiedyś :'(\n\n	
67			1. Ziemniaki dokładnie umyj, ugotuj w osolonej wodzie ok 20minut\n2. Łososia piecz\n3. W tym czasie przygotuj dip jogurtowy: jogurt + chrzan lub musztarga + koper + sokz z cytryny + szczypta soli\n	
77				
35			Dwa burgery z jednego kotleta\n\nFrytki szybko easy w Air Fryierze	
15				
17			Krojenie kurczaka:\nBardzo cienko, staraj się imitować kebsa, znajdź jak idą paski włókien na kurczaka i krój prosopadle do nich.\n\nDaj przyprawę do Gyrosa.\n\nSosik:\nTzatziki, Oregano (mało), Kolendra świeża, czosnek, trochę soku z cytryny.\nJak masz ogóre to daj.	
24				
39				
21				
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
112				
114				
115				
97				
30				
87			Składniki na ciasto {serek wiejski 200g, jajko jedno, mąka 50g, przyprawy}.\n\nPiekarnik 220 grzej. Potem mieszasz ciasto i cyk na blaszke cieniutko uformowane koło i pieczemy 15 minut aż się przypiecze fajnie. Teraz smarowanie koncentratem i serem znowu do piekarnika na 5 minut, i cyk dodatki już na zimno\n\nhttps://www.tiktok.com/@orzechowskam/video/7494611420756053270	
150				
152			https://www.odzywiajsiezdrowo.pl/dorsz-z-ryzem-i-warzywami/\n\n1. Dorsza ułóż w naczyniu żaroodpornym. Na rybie połóż koperek. Dopraw pieprzem.\n2. Warzywa oprósz ziołami i skrop oliwą. Przykryj.\n3. Wszystkie składniki piecz 20 minut w piekarniku nagrzanym do 200 C (możesz ugotować na parze lub upiec w rękawie).\n4. Ryż ugotuj według przepisu na opakowaniu. 	
161			1. Do prostokątnego, podłużnego, szklanego naczynia wrzuć wszystkie składniki i wymieszaj.\n2. Odstaw na 4-5h do lodówki lub (optimal) na całą noc.	
153				
154				
151				
88			https://www.tiktok.com/@orzechowskam/video/7490104352544247062\n\nZrób galaretke według przepisu (ale mniej ilości wody niż zakłada producent), ale nie ścinaj jeszcze. Z twarogu i skyra robisz masę blendowaniem. Połowę galaretki wlewasz do masy. Znowu miksujesz. Do foremki na dół układasz biszkopty i przelewasz na to masę w całości i odstawiasz do lodówki. Reszta galaretki też do lodowki. Oba na 30minut (ale sprawdzaj w trakcie, może być nawet 45 min. Potem dokładasz owoce, zalewasz galaretką i znowu do lodówki aż zastygnie max.	
94				
99				
100				
101				
155				
156				
65			1. Kurczaka pokrój w kostkę. W misce wymieszaj z sosem sojowym, miodem, imbirem, kurkumą, czosnkiem i szczyptą soli.\n2. Odstaw na 10–15 min, żeby się zamarynował.\n3. W tym czasie ugotuj makaron ryżowy (zalewając wrzątkiem na 8–10 min), następnie odcedź i przepłucz.\n4. Na dużej patelni lub woku rozgrzej 10 g oliwy, usmaż kurczaka na złoto z każdej strony.\n5. Dorzuć chińską mieszankę warzyw, smaż razem 5–6 min, aż warzywa będą gorące i lekko chrupiące.\n6. Dodaj makaron, pozostałe 5 g oliwy, nerkowce i ewentualnie kilka kropel sosu sojowego do smaku.\n7. Wymieszaj całość, smaż jeszcze 1–2 min, żeby wszystko się połączyło i miód lekko skarmelizował.	
162			https://youtu.be/lkeZpzkA16o\n\n1. Blend a whole chicken breast (with salt, garlic, paprika, dijon mustard)\n2. Spread it thin layer on the bakin tray (from whole breast you should get 2 pieces - future calzones).\n3. Spread creeme cheese as a next layer on top (oregano, black pepper, citromle)\n4. Add tomatoes, cheese and ham as next layer.\n5. Fold it with the help of paper.\n6. Add grana padno sprikled cheese on top.\n7. Bake it 25minutes, 190C, Up-Down termoobieg.	
116				
144				
62			1. Zagotuj wodę cały czajnik\n2. Wątróbkę pokrój\n3. Nagrzej oliwę na patelni\n4. Wstaw kaszę bulgur do gara na 10 min\n5. Wątróbkę zacznij smażyć standardowo\n6. Krój w tym czasie jabłka\n7. Dodaj je razem ze szpinakiem jak już się wątróbka zarumieni\n8. W tym czasie robisz sosik z jogurtu, kolendry i pieprzu.	
117				
118				
41	ok. 25–30 minut	nic – wszystko zrobisz na świeżo.	3. **Przygotowanie:**\n    - Komosę dobrze przepłucz i gotuj 12–15 minut w proporcji 1:2. Pod koniec dodaj 1/2 łyżki oliwy i sok z cytryny.\n    - Paprykę i cukinię pokrój w plastry i grilluj na patelni lub w piekarniku (ok. 10 minut, aż zmiękną i lekko się przypieką).\n    - Halloumi pokrój w plastry 1–1,5 cm, smaż na suchej patelni po ok. 1–2 minuty z każdej strony, aż się zarumieni.\n    - Podawaj na ciepło: komosa na spód, warzywa i halloumi na wierzchu. Posyp zieleniną i dopraw do smaku.	ok. 25–30 minut przed posiłkiem
146				
145				
163			https://www.facebook.com/reel/876554731671137\n\nZamiast 100g chipotle peppers to dajemy koncentrat 50g + papryka wędzona + miód\n\n	
120				
119				
121				
122				
64			1. Makaron ryżowy zalej wrzątkiem i odstaw na 8–10 minut, aż zmięknie. Odcedź i przepłucz zimną wodą.\n2. Na 5 g oleju podsmaż drobno pokrojoną cebulę, czosnek i marchewkę (może być w julienne).\n3. Dodaj pokrojonego kurczaka, smaż do zarumienienia.\n4. Zsuń składniki na bok patelni, wbij jajko i zamieszaj, aż się zetnie.\n5. Dodaj makaron i sos sojowy + miód + sok z limonki (to Twoja wersja sosu Pad Thai).\n6. Wymieszaj wszystko i smaż jeszcze 2–3 minuty na średnim ogniu.\n7. Zdejmij z ognia, polej resztą oleju i posyp posiekanymi orzeszkami ziemnymi.\n8. Podaj z odrobiną świeżej kolendry lub szczypiorku.	
123			https://www.tiktok.com/@orzechowskam/video/7503142575449345282\n\nDwie miski:\n- w jednej misce ubijasz na bardzo puszystą i bardzo sztywną pianę białka jaj i to jedno jajko\n- w drugiej ubijamy zaś resztę składników\n\nPotem puszystą pianę przenosisz delikatnie łyżką do tej drugiej miski i łączysz ze sobą obie masy ale łyżko (nie mikserem), żeby nie stracić puszystości. Potem tę masę cyk na suchą nagrzaną patelnie układasz po łyżce masy i smażysz po obu stronach.\n\nJak już widzisz po bokach, że na spodzie już jest takie fajne brązowe, to podważając najpierw sobie to na spokojnie z każdej strony robisz CYK OBROCIK.\n\n	
124			Ciasto\n- Do miski: 120 g mąki kukurydzianej + sól.\n- Stopniowo dodawaj 200–230 ml bardzo ciepłej wody + 100 g białek jaj.\n- Mieszaj → zagnieć → odstaw na 3-5 min (mąka pije wodę).\n- Uformuj 2 grube krążki (ok. 2 cm).\n\nKurczak - zamarynuj w jakiś przyprawach, usmaż na patelni, uduś z papryką.\n\nSmażenie\n- Patelnia średnia moc.\n- 1–2 min z każdej strony, aż zrobi się lekka skorupka.\n\nPieczenie / dopieczenie\n- Przerzuć na piekarnik 200°C, 8–10 min (to robi różnicę: będą puszyste i mokre w środku, chrupiące na zewnątrz) Aczkolwiek Victor dawał bezpośrednio z patelni i było puszyste oraz mokre.\n\nNadzienie\n- Kurczaka rozszarp widelcem.\n- Otwórz arepę nożem do połowy i wypełnij:\nnajpierw kurczak\n- Potem stracciatella	
125				
126				
127				
130				
134				
135				
131				
137				
138				
139				
140				
141				
142				
143				
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

SELECT pg_catalog.setval('public.dishes_id_seq', 163, true);


--
-- Name: ingredient_labels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.ingredient_labels_id_seq', 1, false);


--
-- Name: ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.ingredients_id_seq', 285, true);


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

