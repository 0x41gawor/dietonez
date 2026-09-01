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
2026-08-30	112	Lunch	1.5
2026-08-30	221	Post-Workout	1
2026-08-26	25	Pre-Workout	50
2026-08-26	16	Pre-Workout	6
2026-08-29	268	Breakfast	160
2026-08-29	23	Breakfast	185
2026-08-26	245	Pre-Workout	78
2026-08-29	51	Lunch	170
2026-08-29	52	Lunch	8
2026-08-29	17	Lunch	40
2026-08-29	76	Lunch	30
2026-08-26	24	Supper	1
2026-08-29	77	Lunch	1
2026-08-29	42	Lunch	180
2026-08-29	22	Lunch	70
2026-08-29	332	Supper	0.5
2026-09-01	291	Pre-Workout	2
2026-08-29	223	Post-Workout	1
2026-08-30	367	Breakfast	369
2026-08-30	368	Post-Workout	50
2026-08-30	336	Post-Workout	40
2026-08-25	26	Pre-Workout	270
2026-08-25	291	Pre-Workout	2
2026-08-25	164	Pre-Workout	250
2026-08-27	1	Pre-Workout	220
2026-08-30	248	Supper	1
2026-08-30	91	Supper	140
2026-09-01	199	Pre-Workout	1
2026-08-29	2	Pre-Workout	95
2026-08-29	334	Post-Workout	1
2026-08-31	173	Lunch	1
2026-08-25	91	Supper	150
2026-08-25	102	Supper	40
2026-08-25	27	Supper	1
2026-08-31	26	Pre-Workout	270
2026-08-31	291	Pre-Workout	2
2026-08-31	164	Pre-Workout	250
2026-08-31	89	Post-Workout	120
2026-09-01	26	Pre-Workout	90
2026-08-26	128	Lunch	1
2026-08-26	58	Lunch	1
2026-08-27	197	Pre-Workout	70
2026-08-27	25	Pre-Workout	50
2026-08-31	257	Post-Workout	80
2026-08-27	102	Supper	40
2026-08-27	27	Supper	1
2026-08-31	255	Post-Workout	50
2026-08-29	107	Breakfast	100
2026-08-31	52	Post-Workout	8
2026-08-31	91	Supper	150
2026-08-30	1	Pre-Workout	220
2026-08-31	102	Supper	40
2026-09-01	164	Pre-Workout	250
2026-08-30	15	Pre-Workout	10
2026-08-31	25	Post-Workout	40
2026-08-31	59	Post-Workout	40
2026-08-26	91	Supper	150
2026-08-26	102	Supper	40
2026-08-26	51	Lunch	200
2026-08-26	1	Pre-Workout	220
2026-08-30	245	Pre-Workout	40
2026-08-30	25	Pre-Workout	30
2026-08-26	137	Pre-Workout	12
2026-08-26	11	Pre-Workout	10
2026-08-27	252	Breakfast	1
2026-08-29	1	Pre-Workout	220
2026-08-27	311	Breakfast	1
2026-08-28	16	Pre-Workout	5
2026-09-01	332	Supper	1
2026-08-25	252	Breakfast	1
2026-08-25	311	Breakfast	1
2026-08-31	4	Breakfast	3
2026-08-28	366	Pre-Workout	60
2026-09-01	335	Supper	1
2026-08-31	71	Breakfast	1
2026-08-29	16	Pre-Workout	5
2026-08-29	11	Pre-Workout	5
2026-08-31	72	Breakfast	1
2026-09-01	311	Breakfast	1
2026-08-29	25	Pre-Workout	30
2026-08-25	212	Lunch	2
2026-08-25	213	Lunch	2
2026-08-25	204	Lunch	2
2026-08-29	91	Supper	150
2026-08-29	102	Supper	40
2026-08-29	127	Breakfast	11
2026-08-31	252	Breakfast	1
2026-08-27	112	Lunch	1.5
2026-08-31	49	Post-Workout	50
2026-08-31	335	Supper	1
2026-08-25	139	Post-Workout	100
2026-08-25	255	Post-Workout	50
2026-08-25	78	Post-Workout	10
2026-08-25	71	Post-Workout	1
2026-08-25	79	Post-Workout	1
2026-08-25	72	Post-Workout	1
2026-08-26	23	Breakfast	200
2026-08-26	253	Breakfast	100
2026-08-26	15	Breakfast	15
2026-08-25	44	Post-Workout	100
2026-08-25	47	Post-Workout	120
2026-09-01	102	Supper	40
2026-09-01	89	Lunch	120
2026-09-01	52	Lunch	8
2026-09-01	25	Lunch	40
2026-09-01	59	Lunch	40
2026-09-01	49	Lunch	50
2026-09-01	89	Post-Workout	120
2026-09-01	255	Post-Workout	50
2026-09-01	52	Post-Workout	8
2026-09-01	25	Post-Workout	40
2026-09-01	59	Post-Workout	40
2026-09-01	49	Post-Workout	50
2026-08-27	127	Pre-Workout	15
2026-08-26	163	Lunch	10
2026-08-27	177	Post-Workout	43
2026-08-27	178	Post-Workout	47
2026-08-26	186	Lunch	10
2026-08-26	128	Post-Workout	1
2026-08-27	179	Post-Workout	59
2026-08-26	58	Post-Workout	1
2026-09-01	252	Breakfast	1
2026-08-26	163	Post-Workout	10
2026-08-26	186	Post-Workout	10
2026-08-28	23	Breakfast	200
2026-08-28	253	Breakfast	100
2026-08-28	15	Breakfast	15
2026-08-28	51	Lunch	170
2026-08-28	52	Lunch	8
2026-08-28	17	Lunch	40
2026-08-28	76	Lunch	30
2026-08-28	77	Lunch	1
2026-08-28	1	Pre-Workout	220
2026-08-28	15	Pre-Workout	10
2026-08-28	115	Post-Workout	1
2026-08-28	116	Post-Workout	1
2026-08-28	91	Supper	150
2026-08-28	102	Supper	40
2026-08-28	42	Lunch	180
2026-08-28	22	Lunch	70
2026-08-28	25	Pre-Workout	50
\.


--
-- Data for Name: day_kcals; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.day_kcals (diet_id, day_num, kcal) FROM stdin;
7	50	2500
7	51	2500
7	52	2500
7	53	2500
7	54	2500
7	55	2500
7	0	2500
7	1	2500
7	2	2500
7	3	2500
7	4	2500
7	5	2500
7	6	2500
7	7	2500
7	8	2500
7	9	2500
7	10	2500
7	11	2500
7	12	2500
7	13	2500
7	14	2500
7	15	2500
7	16	2500
7	17	2500
7	18	2500
7	19	2500
7	20	2500
7	21	2500
7	22	2500
7	23	2500
7	24	2500
7	25	2500
7	26	2500
7	27	2500
7	28	2500
7	29	2500
7	30	2500
7	31	2500
7	32	2500
7	33	2500
7	34	2500
7	35	2500
7	36	2500
7	37	2500
7	38	2500
7	39	2500
7	40	2500
7	41	2500
7	42	2500
7	43	2500
7	44	2500
7	45	2500
7	46	2500
7	47	2500
7	48	2500
7	49	2500
\.


--
-- Data for Name: diet_context; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.diet_context (active_diet, start_date, current_weight) FROM stdin;
7	2026-07-06	83
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
7	0	150
7	1	194
7	2	198
7	3	166
7	4	24
7	5	147
7	6	166
7	7	198
7	8	166
7	9	24
7	10	147
7	11	173
7	12	198
7	13	173
7	14	24
7	15	149
7	16	175
7	17	203
7	18	175
7	19	24
7	20	149
7	21	175
7	22	203
7	23	191
7	24	24
7	25	148
7	26	190
7	27	203
7	28	20
7	29	24
7	30	147
7	31	190
7	32	203
7	33	196
7	34	24
7	35	150
7	36	28
7	37	198
7	38	183
7	39	24
7	40	147
7	41	183
7	42	198
7	43	183
7	44	24
7	45	147
7	46	171
7	47	198
7	48	171
7	49	24
7	50	148
7	51	177
7	52	212
7	53	177
7	54	24
7	55	148
7	56	177
7	57	212
7	58	191
7	59	24
7	60	149
7	61	187
7	62	212
7	63	195
7	64	24
7	65	147
7	66	187
7	67	212
7	68	195
7	69	24
7	70	150
7	71	130
7	72	198
7	73	169
7	74	24
7	75	147
7	76	169
7	77	198
7	78	169
7	79	24
7	80	147
7	81	174
7	82	198
7	83	174
7	84	24
7	85	149
7	86	182
7	87	219
7	88	182
7	89	24
7	90	149
7	91	182
7	92	219
7	93	191
7	94	24
7	95	148
7	96	188
7	97	219
7	98	196
7	99	24
7	100	147
7	101	188
7	102	219
7	103	196
7	104	24
7	105	150
7	106	130
7	107	198
7	108	186
7	109	24
7	110	147
7	111	186
7	112	198
7	113	186
7	114	24
7	115	147
7	116	170
7	117	198
7	118	170
7	119	24
7	120	148
7	121	179
7	122	198
7	123	179
7	124	24
7	125	148
7	126	179
7	127	224
7	128	191
7	129	24
7	130	149
7	131	189
7	132	224
7	133	195
7	134	24
7	135	147
7	136	189
7	137	224
7	138	195
7	139	24
7	140	150
7	141	130
7	142	198
7	143	167
7	144	24
7	145	147
7	146	167
7	147	198
7	148	167
7	149	24
7	150	147
7	151	173
7	152	198
7	153	173
7	154	24
7	155	149
7	156	178
7	157	203
7	158	178
7	159	24
7	160	149
7	161	177
7	162	203
7	163	191
7	164	24
7	165	148
7	166	190
7	167	203
7	168	196
7	169	24
7	170	147
7	171	190
7	172	203
7	173	196
7	174	24
7	175	150
7	176	130
7	177	198
7	178	184
7	179	24
7	180	147
7	181	184
7	182	198
7	183	184
7	184	24
7	185	147
7	186	171
7	187	198
7	188	171
7	189	24
7	190	148
7	191	180
7	192	212
7	193	180
7	194	24
7	195	148
7	196	180
7	197	212
7	198	191
7	199	24
7	200	149
7	201	187
7	202	212
7	203	195
7	204	24
7	205	147
7	206	187
7	207	212
7	208	195
7	209	24
7	210	150
7	211	130
7	212	198
7	213	168
7	214	24
7	215	147
7	216	168
7	217	198
7	218	168
7	219	24
7	220	147
7	221	174
7	222	198
7	223	174
7	224	24
7	225	149
7	226	181
7	227	219
7	228	181
7	229	24
7	230	149
7	231	181
7	232	219
7	233	191
7	234	24
7	235	148
7	236	188
7	237	219
7	238	196
7	239	24
7	240	147
7	241	188
7	242	219
7	243	196
7	244	24
7	245	150
7	246	130
7	247	198
7	248	185
7	249	24
7	250	148
7	251	185
7	252	198
7	253	185
7	254	24
7	255	147
7	256	170
7	257	198
7	258	170
7	259	24
7	260	148
7	261	176
7	262	224
7	263	176
7	264	24
7	265	148
7	266	176
7	267	224
7	268	191
7	269	24
7	270	148
7	271	189
7	272	224
7	273	195
7	274	24
7	275	147
7	276	189
7	277	224
7	278	195
7	279	24
\.


--
-- Data for Name: diet_slots_counter; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.diet_slots_counter (diet_id, day, meal, name, dish_id) FROM stdin;
7	2026-07-03	Supper	\N	\N
7	2026-07-16	Breakfast	LCPA - łosoś/kefir	148
7	2026-07-03	Post-Workout	curry corner	\N
7	2026-07-03	Pre-Workout	PW HOME 1	154
7	2026-07-11	Breakfast	LCPA - łosoś/kefir	148
7	2026-07-11	Lunch	33Łosoś - Salsa Awokado (R0)	188
7	2026-07-11	Pre-Workout	PW HOME 2	155
7	2026-07-12	Breakfast	LCPA - jajówa/kefir	147
7	2026-07-12	Pre-Workout	PW HOME 2	155
7	2026-07-12	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-07-11	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-07-11	Post-Workout	\N	\N
7	2026-07-16	Pre-Workout	PW HOME 1	154
7	2026-07-12	Lunch	hindus	\N
7	2026-07-12	Post-Workout	hindus	\N
7	2026-07-16	Lunch	13Wątróbka: mediterrean (R0)	174
7	2026-07-17	Lunch	20Kurczak: Mexicano (R0)	177
7	2026-07-17	Pre-Workout	PW HOME 1	154
7	2026-07-16	Post-Workout	FF Double Zinger (KFC) (R0)	191
7	2026-07-16	Supper	\N	\N
7	2026-07-17	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-07-17	Post-Workout	20Kurczak: Mexicano (R0)	177
7	2026-07-17	Breakfast	LCPA - jajówa/kefir	147
7	2026-07-27	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-07-28	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-07-29	Breakfast	LCPA - jajówa/kefir	147
7	2026-07-29	Pre-Workout	PW WORK 	151
7	2026-07-29	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-07-27	Lunch	12Wołowina: Burgery i frytki (R0)	170
7	2026-07-27	Breakfast	LCPA - jajówa/kefir	147
7	2026-07-27	Pre-Workout	PW HOME 0	153
7	2026-07-27	Post-Workout	12Wołowina: Burgery i frytki (R0)	170
7	2026-07-28	Breakfast	LCPA - Mlekovita SBA + primo	150
7	2026-08-24	Post-Workout	33Łosoś - Frytki i Sos Czosnkowy (M)	66
7	2026-08-25	Pre-Workout	PW WORK (R2)	198
7	2026-07-28	Lunch	FF Sałatka Awokado Rybak Duża + Bułka z chia	125
7	2026-07-28	Pre-Workout	PW WORK	151
7	2026-07-28	Post-Workout	31Miruna: kluski&dżem (R0)	186
7	2026-08-25	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-07-29	Post-Workout	31Miruna: kluski&dżem (R0)	186
7	2026-07-29	Lunch	FF Lawasz z kurczakiem 160g (W Bułce)	130
7	2026-07-30	Pre-Workout	PW HOME 3	156
7	2026-07-30	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-07-30	Breakfast	LCPA - jajówa/kefir	147
7	2026-07-30	Lunch	31Miruna: kluski&dżem (R0)	186
7	2026-07-30	Post-Workout	\N	\N
7	2026-07-31	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-08-25	Breakfast	LCPA - Mlekovita SBA + primo	150
7	2026-07-31	Breakfast	Skyr i miodek	148
7	2026-07-31	Lunch	\N	\N
7	2026-07-31	Pre-Workout	\N	\N
7	2026-07-31	Post-Workout	\N	\N
7	2026-08-25	Lunch	FF Subway klasyczek	134
7	2026-08-29	Breakfast	LCPA - twaróg/kefir	149
7	2026-08-26	Lunch	12Wołowina: Burgery i frytki (R0)	170
7	2026-08-03	Breakfast	pół dzika z kawą	\N
7	2026-08-26	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-08-03	Supper	\N	\N
7	2026-08-25	Post-Workout	31Dorsz: ryż/warzywa (R0)	184
7	2026-08-03	Lunch	granola z kefirem, reszta dzika	\N
7	2026-08-03	Pre-Workout	penne z kurczakiem	\N
7	2026-08-03	Post-Workout	Burggir	\N
7	2026-08-04	Breakfast	\N	\N
7	2026-08-04	Lunch	\N	\N
7	2026-08-26	Breakfast	LCPA - łosoś/kefir	148
7	2026-08-04	Post-Workout	\N	\N
7	2026-08-04	Supper	\N	\N
7	2026-08-04	Pre-Workout	PW HOME 0	153
7	2026-08-05	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-08-05	Breakfast	\N	\N
7	2026-08-05	Lunch	\N	\N
7	2026-08-05	Pre-Workout	PW HOME 0	153
7	2026-08-29	Lunch	20Kurczak: Gyros (R0)	176
7	2026-08-05	Post-Workout	pizza	\N
7	2026-08-11	Breakfast	LCPA - jajówa/kefir	147
7	2026-08-11	Lunch	31Dorsz: ryż/warzywa (R0)	184
7	2026-08-11	Post-Workout	31Dorsz: ryż/warzywa (R0)	184
7	2026-08-11	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-08-11	Pre-Workout	PW HOME 2 (R2)	219
7	2026-08-12	Breakfast	LCPA - jajówa/kefir	147
7	2026-08-12	Lunch	12Wołowina: Stek z frytkami (R0)	171
7	2026-08-12	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-08-26	Post-Workout	12Wołowina: Burgery i frytki (R0)	170
7	2026-08-12	Pre-Workout	PW HOME 1 (R3)	213
7	2026-08-28	Breakfast	LCPA - łosoś/kefir	148
7	2026-08-12	Post-Workout	12Wołowina: Stek z frytkami (R0)	171
7	2026-08-20	Post-Workout	FF Subway klasyczek	134
7	2026-08-24	Breakfast	LCPA - Mlekovita SBA + primo	150
7	2026-08-24	Lunch	FF Lawasz z kurczakiem 160g (W Bułce)	130
7	2026-08-24	Pre-Workout	PW WORK (R2)	198
7	2026-08-24	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-08-28	Lunch	20Kurczak: Gyros (R0)	176
7	2026-08-26	Pre-Workout	PW HOME 2 (R2)	219
7	2026-08-27	Pre-Workout	PW HOME 3 (R2)	224
7	2026-08-27	Breakfast	LCPA - Mlekovita SBA + primo	150
7	2026-08-28	Pre-Workout	PW HOME 3 (R2)	224
7	2026-08-27	Lunch	FF Sałatka Cezar Duża (R0)	192
7	2026-08-28	Post-Workout	FF Double Zinger (KFC) (R0)	191
7	2026-08-28	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-08-27	Post-Workout	tacos	\N
7	2026-08-27	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-08-29	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-08-29	Post-Workout	\N	\N
7	2026-08-30	Breakfast	\N	\N
7	2026-08-29	Pre-Workout	PW HOME 0	153
7	2026-08-30	Pre-Workout	PW HOME 3 (R2)	224
7	2026-08-30	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-08-30	Post-Workout	rxiala	\N
7	2026-08-30	Lunch	elo	\N
7	2026-08-31	Lunch	FF Sałatka Awokado Rybak Duża (R0)	194
7	2026-08-31	Pre-Workout	PW WORK (R2)	198
7	2026-08-31	Post-Workout	11Wieprz: Musztardowo-miodowa (R0)	166
7	2026-08-31	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-08-31	Breakfast	LCPA - jajówa/kefir	147
7	2026-07-13	Breakfast	LCPA - Mlekovita SBA + primo	150
7	2026-07-13	Lunch	FF Lawasz z kurczakiem 160g (W Bułce)	130
7	2026-07-13	Pre-Workout	PW WORK 	151
7	2026-07-13	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-07-14	Pre-Workout	PW WORK 	151
7	2026-07-15	Pre-Workout	PW WORK 	151
7	2026-07-15	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-07-13	Post-Workout	13Wątróbka: mediterrean (R0)	174
7	2026-07-14	Breakfast	LCPA - twaróg/kefir	149
7	2026-07-14	Lunch	FF Wrap Wołowina BBQ (Salad Story)	126
7	2026-08-06	Breakfast	LCPA - twaróg/kefir	149
7	2026-07-14	Post-Workout	strefa kibica	\N
7	2026-07-14	Supper	lodowka	\N
7	2026-07-15	Breakfast	LCPA - Mlekovita SBA + primo	150
7	2026-07-15	Post-Workout	FF Double Zinger (KFC) (R0)	191
7	2026-07-15	Lunch	FF Wrap Wołowina BBQ (Salad Story)	126
7	2026-07-18	Breakfast	LCPA - twaróg/kefir	149
7	2026-07-18	Lunch	33Łosoś - Frytki i Sos Czosnkowy (R0)	187
7	2026-07-18	Pre-Workout	PW HOME 1	154
7	2026-07-18	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-07-18	Post-Workout	33Łosoś - Frytki i Sos Czosnkowy (R0)	187
7	2026-07-22	Pre-Workout	PW WORK 	151
7	2026-07-22	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-07-22	Lunch	FF Sałatka z kurczakiem (Putka)	127
7	2026-08-06	Lunch	20Kurczak: Pad thai (R0)	178
7	2026-07-22	Breakfast	LCPA - Mlekovita SBA + primo	150
7	2026-07-23	Pre-Workout	PW HOME 2	155
7	2026-07-23	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-07-22	Post-Workout	11Wieprz: Spaghetti Napoli (R0)	169
7	2026-07-23	Breakfast	LCPA - jajówa/kefir	147
7	2026-07-23	Lunch	12Wołowina: Stek z frytkami (R0)	171
7	2026-07-23	Post-Workout	12Wołowina: Stek z frytkami (R0)	171
7	2026-07-24	Pre-Workout	PW HOME 2	155
7	2026-07-24	Post-Workout	FF Double Zinger (KFC) (R0)	191
7	2026-07-24	Breakfast	LCPA - łosoś/kefir	148
7	2026-07-24	Lunch	20Kurczak: Kottu (R0)	182
7	2026-07-25	Breakfast	LCPA - łosoś/kefir	148
7	2026-07-25	Pre-Workout	PW HOME 2	155
7	2026-07-25	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-07-24	Supper	\N	\N
7	2026-07-25	Lunch	20Kurczak: Kottu (R0)	182
7	2026-08-06	Pre-Workout	PW HOME 0 (R1)	202
7	2026-08-06	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-07-25	Post-Workout	pizza	\N
7	2026-08-01	Breakfast	\N	\N
7	2026-08-01	Lunch	\N	\N
7	2026-08-01	Pre-Workout	\N	\N
7	2026-08-01	Post-Workout	\N	\N
7	2026-08-01	Supper	\N	\N
7	2026-08-02	Post-Workout	\N	\N
7	2026-08-02	Supper	\N	\N
7	2026-08-02	Pre-Workout	lody	\N
7	2026-08-02	Lunch	sushi z ojcem	\N
7	2026-08-02	Breakfast	śniadanie mistrzów	\N
7	2026-08-08	Pre-Workout	PW HOME 0 (R1)	202
7	2026-08-08	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-08-09	Pre-Workout	PW HOME 0 (R1)	202
7	2026-08-09	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-08-10	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-08-15	Pre-Workout	PW HOME 1 (R2)	212
7	2026-08-15	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-08-07	Breakfast	LCPA - twaróg/kefir	149
7	2026-08-07	Pre-Workout	PW HOME 0 (R1)	202
7	2026-08-07	Post-Workout	FF Double Zinger (KFC) (R0)	191
7	2026-08-07	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-08-07	Lunch	20Kurczak: Pad thai (R0)	178
7	2026-08-16	Pre-Workout	PW HOME 1 (R2)	212
7	2026-08-06	Post-Workout	20Kurczak: Pad thai (R0)	178
7	2026-08-08	Lunch	33Łosoś - Frytki i Sos Czosnkowy (R0)	187
7	2026-08-08	Breakfast	LCPA - twaróg/kefir	149
7	2026-08-08	Post-Workout	\N	\N
7	2026-08-09	Breakfast	LCPA - twaróg/kefir	149
7	2026-08-09	Lunch	33Łosoś - Frytki i Sos Czosnkowy (R0)	187
7	2026-08-09	Post-Workout	\N	\N
7	2026-08-10	Breakfast	LCPA - jajówa/kefir	147
7	2026-08-10	Lunch	31Dorsz: ryż/warzywa (R0)	184
7	2026-08-10	Pre-Workout	PW HOME 0 (R2)	203
7	2026-08-10	Post-Workout	FF Double Zinger (KFC) (R0)	191
7	2026-08-13	Lunch	20Kurczak: Tikka Masala (R0)	180
7	2026-08-13	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-08-14	Breakfast	LCPA - łosoś/kefir	148
7	2026-08-14	Pre-Workout	PW HOME 1 (R2)	212
7	2026-08-14	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-08-16	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-08-13	Breakfast	LCPA - twaróg/kefir	149
7	2026-08-15	Breakfast	pizza w nocy	149
7	2026-08-13	Pre-Workout	PW HOME 1	154
7	2026-08-13	Post-Workout	FF Double Zinger (KFC) (R0)	191
7	2026-08-18	Breakfast	LCPA - Mlekovita SBA + primo	150
7	2026-08-14	Lunch	20Kurczak: Tikka Masala (R0)	180
7	2026-08-14	Post-Workout	20Kurczak: Tikka Masala (R0)	180
7	2026-08-15	Lunch	20Kurczak: Tikka Masala (R0)	180
7	2026-08-18	Lunch	FF Lawasz z kurczakiem 160g (W Bułce)	130
7	2026-08-16	Breakfast	LCPA - twaróg/kefir	149
7	2026-08-19	Lunch	FF Karkówka (Straight From the Grate)	165
7	2026-08-18	Post-Workout	\N	\N
7	2026-08-18	Supper	\N	\N
7	2026-08-15	Post-Workout	20Kurczak: Tikka Masala (R0)	180
7	2026-08-16	Lunch	20Kurczak: Tikka Masala (R0)	180
7	2026-08-16	Post-Workout	\N	\N
7	2026-08-18	Pre-Workout	PW WORK (R2)	198
7	2026-08-19	Pre-Workout	PW WORK (R2)	198
7	2026-08-19	Post-Workout	\N	\N
7	2026-08-19	Supper	\N	\N
7	2026-08-19	Breakfast	LCPA - Mlekovita SBA + primo	150
7	2026-08-20	Breakfast	LCPA - twaróg/kefir	149
7	2026-08-20	Lunch	20Kurczak: Wrap (R0)	181
7	2026-08-20	Pre-Workout	PW HOME 2 (R2)	219
7	2026-08-21	Pre-Workout	PW HOME 2 (R2)	219
7	2026-08-21	Post-Workout	FF Double Zinger (KFC) (R0)	191
7	2026-08-21	Breakfast	LCPA - twaróg/kefir	149
7	2026-08-20	Supper	\N	\N
7	2026-08-21	Lunch	20Kurczak: Wrap (R0)	181
7	2026-08-21	Supper	\N	\N
7	2026-08-22	Breakfast	LCPA - jajówa/kefir	147
7	2026-08-22	Lunch	33Łosoś - Frytki i Sos Czosnkowy (M)	66
7	2026-07-04	Breakfast	LCPA - jajówa/kefir	147
7	2026-07-04	Post-Workout	\N	\N
7	2026-07-04	Supper	\N	\N
7	2026-07-05	Lunch	33Łosoś - Frytki i Sos Czosnkowy (R0)	187
7	2026-07-05	Breakfast	\N	\N
7	2026-07-19	Pre-Workout	PW HOME 1	154
7	2026-07-19	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-07-19	Lunch	33Łosoś - Frytki i Sos Czosnkowy (R0)	187
7	2026-07-19	Breakfast	\N	\N
7	2026-07-06	Breakfast	LCPA - Mlekovita SBA + primo	150
7	2026-07-06	Lunch	FF Lawasz z kurczakiem 160g (W Bułce)	130
7	2026-07-06	Pre-Workout	PW WORK 	151
7	2026-07-06	Post-Workout	11Wieprz: Schab pieczony (R0)	168
7	2026-07-06	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-07-05	Post-Workout	obiadeiro	\N
7	2026-07-19	Post-Workout	\N	\N
7	2026-07-05	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-07-20	Breakfast	LCPA - Mlekovita SBA + primo	150
7	2026-07-20	Lunch	FF Lawasz z kurczakiem 160g (W Bułce)	130
7	2026-07-20	Pre-Workout	PW WORK 	151
7	2026-07-20	Post-Workout	11Wieprz: Spaghetti Napoli (R0)	169
7	2026-07-20	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-07-21	Pre-Workout	PW WORK 	151
7	2026-07-21	Post-Workout	11Wieprz: Spaghetti Napoli (R0)	169
7	2026-07-21	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-07-21	Breakfast	LCPA - Mlekovita SBA + primo	150
7	2026-07-21	Lunch	FF Wrap Wołowina BBQ (Salad Story)	126
7	2026-08-17	Breakfast	LCPA - Mlekovita SBA + primo	150
7	2026-07-04	Lunch	33Łosoś - Frytki i Sos Czosnkowy (R0)	187
7	2026-07-04	Pre-Workout	PW HOME 1	154
7	2026-07-05	Pre-Workout	PW HOME 1	154
7	2026-08-17	Lunch	FF Lawasz z kurczakiem 160g (W Bułce)	130
7	2026-08-17	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-08-17	Pre-Workout	PW WORK	151
7	2026-08-17	Post-Workout	FF Double Zinger (KFC) (M)	30
7	2026-09-01	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-09-01	Breakfast	LCPA - Mlekovita SBA + primo	150
7	2026-09-01	Lunch	11Wieprz: Musztardowo-miodowa (R0)	166
7	2026-09-01	Post-Workout	11Wieprz: Musztardowo-miodowa (R0)	166
7	2026-09-01	Pre-Workout	PW WORK (R1)	197
7	2026-07-02	Lunch	tuna ramen	\N
7	2026-07-03	Lunch	tuna ramen	\N
7	2026-07-07	Pre-Workout	PW WORK 	151
7	2026-07-08	Pre-Workout	PW WORK 	151
7	2026-07-09	Lunch	20Kurczak: Wrap (R0)	181
7	2026-07-09	Pre-Workout	PW HOME 2	155
7	2026-07-09	Post-Workout	FF Double Zinger (KFC) (R0)	191
7	2026-07-10	Breakfast	LCPA - twaróg/kiwi/kefir	149
7	2026-07-10	Lunch	20Kurczak: Wrap (R0)	181
7	2026-07-26	Breakfast	Naleśnik i skyr	147
7	2026-08-22	Pre-Workout	PW HOME 2 (R2)	219
7	2026-07-07	Breakfast	LCPA - Mlekovita SBA + primo	150
7	2026-07-07	Post-Workout	11Wieprz: Spaghetti Napoli (R0)	169
7	2026-07-07	Lunch	11Wieprz: Spaghetti Napoli (R0)	169
7	2026-07-08	Lunch	11Wieprz: Spaghetti Napoli (R0)	169
7	2026-07-08	Post-Workout	11Wieprz: Spaghetti Napoli (R0)	169
7	2026-07-07	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-07-26	Pre-Workout	\N	\N
7	2026-07-10	Pre-Workout	PW HOME 2	155
7	2026-07-26	Post-Workout	\N	\N
7	2026-07-26	Supper	\N	\N
7	2026-07-26	Lunch	kanapka Żabka	\N
7	2026-07-08	Breakfast	LCPA - jajówa/kefir	147
7	2026-07-08	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-07-09	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-07-09	Breakfast	LCPA - jajówa/kefir	147
7	2026-07-10	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-07-10	Post-Workout	20Kurczak: Wrap (R0)	181
7	2026-08-23	Breakfast	LCPA - jajówa/kefir	147
7	2026-08-23	Lunch	33Łosoś - Salsa Awokado (R0)	188
7	2026-08-23	Pre-Workout	PW HOME 2 (R2)	219
7	2026-08-23	Post-Workout	40Krewetki: Masło/Czosnek (R0)	196
7	2026-08-23	Supper	Kazeina [Snacks: kiwi, jabłko]	24
7	2026-08-22	Post-Workout	\N	\N
7	2026-08-22	Supper	\N	\N
\.


--
-- Data for Name: diets; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.diets (id, name, descr) FROM stdin;
7	Redu Iota (lipiec-start 2026, R0)	base 2650, level R0 (main dishes na R0, reszta bez zmian, gotowanie ndz, wt, czw, sb)
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
197	Pre-Workout	PW WORK (R1)	
62	MainMeal	13Wątróbka: mediterrean (M)	
17	MainMeal	20Kurczak: Gyros (M)	
64	MainMeal	20Kurczak: Pad thai (M)	
187	MainMeal	33Łosoś - Frytki i Sos Czosnkowy (R0)	
189	MainMeal	33Łosoś - Ziemniaki w mundurkach z dipem (R0)	
211	Pre-Workout	PW HOME 1 (R1)	
217	Pre-Workout	PW HOME 2 (R1)	
225	Pre-Workout	PW HOME 3 (R1)	
212	Pre-Workout	PW HOME 1 (R2)	
219	Pre-Workout	PW HOME 2 (R2)	
224	Pre-Workout	PW HOME 3 (R2)	
213	Pre-Workout	PW HOME 1 (R3)	
218	Pre-Workout	PW HOME 2 (R3)	
222	Pre-Workout	PW HOME 3 (R3)	
226	Pre-Workout	PW HOME 3 (R4)	
214	Pre-Workout	PW HOME 1 (R4)	
216	Pre-Workout	PW HOME 2 (R4)	
215	Pre-Workout	PW HOME 1 (R5)	
220	Pre-Workout	PW HOME 2 (R5)	
223	Pre-Workout	PW HOME 3 (R5)	
210	Supper	Snack: kiwi	
207	Supper	Snack kiwi + baton crisp	
208	Supper	Snack: kiwi + baton tiramisu	
209	Supper	Snack: kiwi + jabłko	
22	MainMeal	11Wieprz: Schab pieczony (M)	
34	MainMeal	12Wołowina: Stek z frytkami (M)	
23	MainMeal	13Wątróbka: chleb/cebula (M)	
36	MainMeal	20Kurczak: Słodko-kwaśny (M)	
63	MainMeal	20Kurczak: Kottu (M)	
163	MainMeal	XJ3 - Chipotle hot pockets 10x	
38	MainMeal	11Wieprz: Penne&Pesto (M)	
14	MainMeal	20Kurczak: Wrap (M)	
165	MainMeal	FF Karkówka (Straight From the Grate)	
65	MainMeal	20Kurczak: Asian Stri-Fry (M)	
54	MainMeal	11A Red Meat - Pork - (schab, polędwiczka)	
88	MainMeal	XJ2 - Jebaniec na zimno (sernik)	
39	MainMeal	20Kurczak: Mexicano (M)	
174	MainMeal	13Wątróbka: mediterrean (R0)	
15	MainMeal	20Kurczak: Tikka Masala (M)	
148	Breakfast	LCPA - łosoś/kefir	
156	Pre-Workout	PW HOME 3	
26	MainMeal	31Miruna: jak nad morzem (M)	
68	MainMeal	33Łosoś - Chilli-Limonka (M)	
190	MainMeal	33Łosoś - Chilli-Limonka (R0)	
117	MainMeal	YY  shake(kiwi, szpinak)	
149	Breakfast	LCPA - twaróg/kefir	
200	Pre-Workout	PW WORK  (R5)	
198	Pre-Workout	PW WORK (R2)	
199	Pre-Workout	PW WORK  (R3)	
24	Supper	Kazeina [Snacks: kiwi, jabłko]	
66	MainMeal	33Łosoś - Frytki i Sos Czosnkowy (M)	
169	MainMeal	11Wieprz: Spaghetti Napoli (R0)	
16	MainMeal	11Wieprz: Spaghetti Napoli (M)	
201	Pre-Workout	PW WORK  (R4)	
35	MainMeal	12Wołowina: Burgery i frytki (M)	
170	MainMeal	12Wołowina: Burgery i frytki (R0)	
171	MainMeal	12Wołowina: Stek z frytkami (R0)	
21	MainMeal	11Wieprz: Musztardowo-miodowa (M)	
166	MainMeal	11Wieprz: Musztardowo-miodowa (R0)	
173	MainMeal	13Wątróbka: chleb/cebula (R0)	
155	Pre-Workout	PW HOME 2	
55	MainMeal	12A Red Meat - Beef - (Stek, Kotlet)	
56	MainMeal	13A Red Meat - Liver - (Wątróbka)	
57	MainMeal	20A - Poultry - (Kurczak, Indyk)	
58	MainMeal	31A - Fish - Lean - (Dorsz, Miruna)	
19	MainMeal	31Dorsz: cytrynowo-pietruszkowy (M)	
20	MainMeal	40Krewetki: Masło/Czosnek	
31	MainMeal	31Miruna: kluski&dżem (M)	
67	MainMeal	33Łosoś - Ziemniaki w mundurkach z dipem (M)	
188	MainMeal	33Łosoś - Salsa Awokado (R0)	
18	MainMeal	33Łosoś - Salsa Awokado (M)	
59	MainMeal	32A - Fish - Semi-fatty - (Pstrąg)	
60	MainMeal	33A - Fish - Fatty - (Łosoś, Halibut)	
61	MainMeal	40A - Extras - (Krewetki, Tofu, Halloumi)	
113	MainMeal	YY  Tosty - Żywiecka - kimchi i szpinak	
30	MainMeal	FF Double Zinger (KFC) (M)	
41	MainMeal	40Hallouumi: Kuskus/Grillowana Papryka	
191	MainMeal	FF Double Zinger (KFC) (R0)	
194	MainMeal	FF Sałatka Awokado Rybak Duża (R0)	
86	MainMeal	XJ1 Waniliowy Jebaniec (Sernik)	
87	MainMeal	XJ1 - Pizza białkowa	
29	MainMeal	FF Sałatka Cezar Duża + Bułka z chia	
161	MainMeal	XJ4 - Pudding Czekoladowy	
195	MainMeal	40Hallouumi: Kuskus/Grillowana Papryka (R0)	
196	MainMeal	40Krewetki: Masło/Czosnek (R0)	
182	MainMeal	20Kurczak: Kottu (R0)	
167	MainMeal	11Wieprz: Penne&Pesto (R0)	
183	MainMeal	31Dorsz: cytrynowo-pietruszkowy (R0)	
184	MainMeal	31Dorsz: ryż/warzywa (R0)	
185	MainMeal	31Miruna: jak nad morzem (R0)	
186	MainMeal	31Miruna: kluski&dżem (R0)	
192	MainMeal	FF Sałatka Cezar Duża (R0)	
193	MainMeal	FF Sałatka Cobb Duża (R0)	
176	MainMeal	20Kurczak: Gyros (R0)	
178	MainMeal	20Kurczak: Pad thai (R0)	
180	MainMeal	20Kurczak: Tikka Masala (R0)	
142	MainMeal	YY Tosty - Ricotta  + miód&maliny&migdały	
143	MainMeal	YY  Owsianka - jagodowa - lean	
168	MainMeal	11Wieprz: Schab pieczony (R0)	
150	Breakfast	LCPA - Mlekovita SBA + primo	
151	Pre-Workout	PW WORK 	
147	Breakfast	LCPA - jajówa/kefir	
153	Pre-Workout	PW HOME 0	
202	Pre-Workout	PW HOME 0 (R1)	
203	Pre-Workout	PW HOME 0 (R2)	
204	Pre-Workout	PW HOME 0 (R3)	
205	Pre-Workout	PW HOME 0 (R4)	
206	Pre-Workout	PW HOME 0 (R5)	
154	Pre-Workout	PW HOME 1	
123	MainMeal	XJ3 - Jebańcowe obłoczki	
124	MainMeal	XJ2 - Arepas de Victor	
28	MainMeal	FF Sałatka Cobb Duża + Bułka z chia	
125	MainMeal	FF Sałatka Awokado Rybak Duża + Bułka z chia	
127	MainMeal	FF Sałatka z kurczakiem (Putka)	
139	MainMeal	Skyr + pomarańcza	
130	MainMeal	FF Lawasz z kurczakiem 160g (W Bułce)	
134	MainMeal	FF Subway klasyczek	
135	MainMeal	FF Subway nowe smaki	
140	MainMeal	Skyr + kiwi	
152	MainMeal	31Dorsz: ryż/warzywa (M)	
126	MainMeal	FF Wrap Wołowina BBQ (Salad Story) 	
175	MainMeal	20Kurczak: Asian Stri-Fry (R0)	
162	MainMeal	XJ3 - Chicken Breast Calzone	
177	MainMeal	20Kurczak: Mexicano (R0)	
179	MainMeal	20Kurczak: Słodko-kwaśny (R0)	
181	MainMeal	20Kurczak: Wrap (R0)	
\.


--
-- Data for Name: ingredient_amounts; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.ingredient_amounts (dish_id, ingredient_id, amount) FROM stdin;
139	24	1
139	1	300
177	45	50
177	42	120
224	1	220
224	197	50
224	143	200
224	25	40
224	15	10
224	31	10
177	65	50
177	64	50
177	52	6
177	67	1
35	58	2
177	62	20
177	17	20
177	63	20
35	128	1
35	51	80
213	1	220
177	57	1
35	126	50
213	197	50
213	143	200
35	20	50
35	59	10
189	83	150
189	132	200
29	112	1
29	150	1
213	25	25
189	53	50
189	154	30
189	56	5
189	78	10
189	55	5
189	73	50
213	12	10
213	31	10
222	1	220
86	4	3
86	1	150
86	155	1
86	156	10
222	197	50
222	143	200
222	25	25
222	15	10
222	31	10
226	1	220
226	197	40
147	4	3
147	23	200
147	71	1
147	72	1
155	137	12
179	42	150
179	44	50
179	38	100
35	19	20
35	21	20
35	60	5
35	62	10
170	128	1
179	60	40
179	25	20
179	62	60
179	52	6
179	17	30
179	73	20
179	129	10
155	11	10
226	143	200
226	25	20
170	58	1
170	51	100
152	44	150
152	47	150
152	139	100
152	255	50
152	78	10
152	71	1
152	79	1
152	72	1
152	34	50
170	126	50
170	20	50
170	59	10
170	19	20
156	1	220
156	197	70
156	143	200
156	25	50
156	15	10
156	31	10
212	1	220
212	197	55
212	143	200
212	25	40
212	12	10
212	31	10
200	1	300
200	26	180
200	164	250
184	44	100
184	47	150
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
184	34	50
184	139	100
184	255	50
184	78	10
184	71	1
184	79	1
184	72	1
199	291	2
199	164	150
199	26	270
201	26	180
201	291	2
201	164	250
140	1	300
140	27	100
218	1	220
218	197	50
218	143	200
218	25	25
218	137	12
218	11	10
216	1	220
216	197	40
216	143	200
216	25	20
170	21	20
170	60	5
170	62	10
17	51	250
87	6	2
87	152	1
87	158	60
87	157	50
87	4	1
87	38	50
87	9	30
17	42	120
17	22	100
17	52	8
17	17	40
17	76	30
216	137	12
216	11	10
17	77	1
178	42	100
178	87	50
215	1	220
215	197	35
215	143	200
215	25	10
178	4	1
178	127	10
215	12	10
215	31	10
220	1	220
220	197	35
220	143	200
211	1	220
211	197	55
211	143	200
211	25	50
211	12	10
178	52	8
178	73	40
220	25	10
220	137	12
211	31	10
217	1	220
217	197	55
220	11	10
24	27	1
24	91	150
24	102	40
178	62	40
31	122	130
31	108	180
31	121	100
178	25	10
178	129	15
178	69	10
41	85	100
41	95	100
41	161	15
41	17	50
41	52	6
41	28	10
41	55	10
178	55	10
31	126	100
15	44	100
15	42	120
15	22	75
31	73	50
15	46	100
15	70	20
217	143	200
217	25	50
217	137	12
15	52	8
26	51	350
26	108	200
26	22	50
26	59	20
217	11	10
225	1	220
225	197	55
225	143	200
191	115	1
191	116	1
126	174	1
26	60	10
26	17	100
193	111	1
193	150	1
192	112	1
66	51	200
66	83	120
225	25	50
225	15	10
225	31	10
219	1	220
219	197	50
219	143	200
219	25	40
219	137	12
219	11	10
66	22	60
66	56	10
66	55	5
66	73	100
182	61	1.5
182	42	120
182	4	1
54	89	100
55	43	100
56	94	100
57	42	100
182	135	1
58	47	100
59	131	100
60	83	100
61	86	100
182	126	80
182	73	40
182	52	6
182	62	30
182	129	20
182	69	10
187	83	150
187	51	100
187	22	60
187	73	30
187	56	10
148	23	200
148	253	100
148	15	15
187	55	5
149	23	200
149	107	125
149	268	80
149	10	15
150	252	1
150	311	1
226	15	10
226	31	10
214	1	220
214	197	40
214	143	200
194	173	1
214	25	20
214	12	10
34	51	200
34	43	150
34	126	50
163	42	1135
214	31	10
34	52	5
171	43	150
171	51	120
163	275	500
171	126	50
163	22	520
163	158	70
163	25	60
163	186	30
163	74	10
36	44	100
36	42	120
36	38	100
36	25	20
36	60	40
36	62	60
36	52	6
171	52	5
36	17	30
36	73	20
36	129	10
223	1	220
223	197	35
223	143	200
223	25	10
223	15	10
20	87	100
20	86	200
20	127	20
20	88	15
20	56	20
20	28	20
20	55	10
223	31	10
21	256	100
21	89	100
21	25	35
21	257	80
21	255	50
21	59	30
21	52	8
23	293	180
202	1	220
202	36	200
202	197	55
202	25	50
202	11	10
202	16	10
23	91	200
23	94	120
169	49	85
181	61	1
181	42	150
181	22	75
181	52	8
181	66	1
181	67	1
181	17	30
181	59	10
181	20	20
181	21	10
181	57	1
169	89	120
169	46	100
169	73	60
204	1	220
204	36	200
204	197	50
204	25	25
23	62	200
174	94	150
88	159	1
88	107	125
88	1	150
88	160	30
88	29	100
88	36	50
204	11	10
204	16	10
169	52	8
16	49	110
16	89	120
16	6	1
16	46	100
16	73	60
205	1	220
205	36	200
205	197	40
205	25	20
174	91	200
174	84	50
174	30	150
174	53	50
174	52	8
205	11	10
205	16	10
16	52	8
174	69	10
176	51	170
176	42	120
176	22	100
176	52	8
176	17	40
176	76	30
176	77	1
64	87	100
64	42	100
64	4	1
64	127	10
64	52	8
64	73	40
64	62	40
64	25	10
64	129	15
64	69	10
64	55	10
180	42	120
180	44	50
180	22	75
180	46	100
180	70	20
180	52	8
68	140	100
68	83	120
68	142	2
68	19	30
68	56	10
68	129	10
68	141	10
68	73	100
166	89	120
166	256	50
166	25	35
166	257	80
153	1	220
153	36	200
166	255	50
195	85	50
167	89	120
167	130	75
167	30	100
167	80	30
167	10	10
165	309	1
167	56	20
167	52	8
167	71	1
167	79	2
167	72	1
166	59	30
166	52	8
173	293	120
173	94	120
173	62	200
153	197	70
153	25	50
153	11	10
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
195	95	100
195	17	50
195	161	10
195	52	6
195	28	10
195	55	10
196	87	50
196	86	200
196	127	20
38	71	1
38	79	2
38	72	1
196	88	15
196	56	20
196	28	20
196	55	10
197	291	2
197	164	150
153	16	10
203	1	220
203	36	200
203	197	50
203	25	40
203	11	10
203	16	10
173	91	150
62	84	100
197	199	1
197	26	90
188	83	120
188	34	80
188	130	50
188	18	50
65	42	120
65	87	100
65	139	150
65	25	20
65	137	15
65	52	8
65	74	30
65	56	10
65	129	15
65	68	3
65	71	1
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
65	72	1
188	52	8
188	63	40
188	82	50
188	69	10
188	57	1
18	83	120
18	130	100
18	34	80
18	18	50
18	52	8
18	63	40
18	82	50
175	87	50
175	42	120
175	139	150
175	25	20
175	137	15
175	52	8
142	123	6
142	6	3
175	74	30
175	56	10
175	129	15
175	68	3
175	71	1
175	72	1
18	69	10
18	57	1
142	147	100
142	25	20
143	4	2
143	2	80
143	106	100
143	3	200
210	27	1
207	27	1
207	248	1
208	27	1
208	312	1
209	27	1
209	91	120
22	84	100
22	89	150
22	52	20
22	73	150
117	23	250
62	94	125
117	26	100
117	27	100
117	166	15
117	30	50
117	258	20
206	1	220
206	36	200
206	197	35
62	91	200
62	30	150
113	5	6
113	6	3
113	146	50
113	23	100
113	30	50
67	132	350
67	83	120
67	53	50
67	154	30
206	25	10
206	11	10
206	16	10
117	37	100
62	53	50
62	52	8
67	56	5
67	78	10
67	55	5
168	89	150
168	84	50
168	52	20
62	69	10
190	83	150
190	142	2
190	140	50
190	324	10
190	19	30
190	56	10
151	164	250
168	73	200
190	129	10
190	141	10
190	73	100
151	199	1
151	26	90
151	291	2
154	1	220
154	197	70
154	143	200
124	172	120
124	71	1
124	170	100
124	42	150
124	147	50
124	55	10
124	72	1
124	17	20
198	291	2
198	26	270
198	164	250
154	25	50
30	117	1
30	116	1
154	31	10
154	12	10
14	61	2
14	42	120
14	22	75
14	52	8
14	67	1
155	1	220
155	197	70
155	143	200
63	61	2
14	17	30
14	59	10
63	42	120
63	4	1
63	135	1
63	126	80
63	73	40
63	52	6
14	20	20
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
155	25	50
183	85	110
183	47	120
183	73	100
183	52	8
183	28	30
183	54	10
183	55	10
183	71	1
183	72	1
185	51	230
185	108	200
185	22	50
185	59	20
185	60	10
185	55	10
185	71	2
185	72	1
186	122	100
186	108	180
186	121	70
186	126	100
186	73	50
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
24	Pomarańcza	sztuka	1	Świeże	84	1.62	0.36	29.34	200	f
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
15	Migdały	g	100	Zapasy	604	24.1	52	20.5	400	t
59	Musztarda sarepska (Kamis)	g	100	Zapasy	101	3.7	5.1	8.3	2000	f
26	Banan	g	100	Świeże	97	1	0.3	21.8	200	f
25	Miód lipowy (Bartnik)	g	100	Zapasy	333	0.3	0	83	1210	t
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
27	Kiwi 75g	sztuka	1	Na żywo	48	0.8	0.3	10.5	200	f
61	Tortilla pszenna wraps 245g (PANO)	sztuka	1	Lidl	195	5.9	4.6	31.9	120	f
62	Cebula	g	100	Świeże	33	1.4	0.4	6.9	200	f
63	Cebula czerwona	g	100	Świeże	30	1.4	0.4	6.9	200	f
64	Kukurydza złocista	g	100	Lidl	94	3.2	1	19	310	f
65	Fasola	g	100	Lidl	288	21.4	1.6	61.6	310	f
66	Oregano	szczypta	1	Zapasy	3	0.1	0	0.7	350	t
67	Papryka słodka 22g (Kamis)	szczypta	1	Zapasy	3	0.1	0.1	0.6	350	t
69	Kolendra świeża	g	100	Zapasy	23	2.1	0.3	3.7	350	f
39	Masło orzechowe (GO ON)	g	100	Zapasy	581	17	46	12	1210	f
11	Nasiona chia (Promienie słoneczne)	g	100	Zapasy	489	14.3	32.1	50	410	t
10	Orzechy włoskie (Alesto)	g	100	Zapasy	712	15.5	69.1	3.7	410	t
12	Pestki dyni (Alesto)	g	100	Zapasy	579	24.4	45.6	15.2	410	f
57	Czosnek granulowany	szczypta	1	Zapasy	0	0	0	0	350	t
80	Pesto (Barilla)	g	100	Lidl	482	4.7	46	9.8	2000	f
88	Masło Extra Osełka 82% Tłusczu	g	100	Lidl	744	0.7	82	0.7	2000	f
96	Groch żółty łuskany połówki	g	100	Lidl	379	23.8	1.4	60.2	2000	f
107	Twaróg klinek chudy (Delikate)	g	100	Lidl	96	20	0.2	3.5	735	f
115	Zinger (KFC)	sztuka	1	Na żywo	438	26.7	23.3	37.6	5000	f
117	Zinger Double (KFC)	sztuka	1	Na żywo	590	41	29	41	5000	f
111	Sałatka Cobb Powiększona (Salad Story)	porcja	1	Na żywo	440	32	28	15	5000	f
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
112	Sałatka Cezar (Salad Story) powiększona = 1.5 porcji	porcja	1	Na żywo	316	24	18	14.2	5000	f
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
127	Orzeszki ziemne prażone, niesolone (Alesto) 500g	g	100	Zapasy	610	25.8	49.2	11.6	400	t
16	Belbake Kakao Ekstra Ciemne o Obniżonej zawartości Tłuszczu (belbake)	g	100	Zapasy	309	24	11	13	800	f
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
100	Morele suszone	g	100	Zapasy	301	5.4	1.2	72.2	400	t
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
139	Chińska mieszanka warzyw 450g (Proste Historie)	g	100	Lidl	28	1.6	0.3	3.4	815	f
140	Ryż jaśminiowy	g	100	Lidl	349	6.8	0.8	78	900	f
141	Chilli świeże lub suszone	g	100	Świeże	0	0	0	0	200	f
161	Pestki słonecznika 500g (Alesto)	g	100	Zapasy	616	21.4	53.9	5.1	400	t
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
138	Kurkuma	szczypta	1	Zapasy	0	0	0	0	350	t
166	Orzechy laskowe łuskane (Alesto)	g	100	Zapasy	658	15	61	6.7	400	t
173	Sałatka Awokado Rybak (Salad Story)	porcja	1	Na żywo	530	32.76	27.43	32.76	5000	f
72	Pieprz czarny mielony	szczypta	1	Zapasy	0	0	0	0	350	t
77	Tzatziki przyprawa	szczypta	1	Zapasy	0	0	0	0	350	t
172	Mąka kukurydziana biała PAN 1kg (google: Mąka kukurydziana precooked (Harina PAN))	g	100	Lidl	357	78	2	75.5	2000	f
142	Limonka	sztuka	1	Świeże	28	0.7	0.2	10	200	f
137	Orzechy nerkowca	g	100	Zapasy	554	18.2	43.8	30.4	400	t
149	Bułka orkiszowa	sztuka	1	Na żywo	200	6.4	1.6	40	100	f
177	Białko (clean)	g	100	Na żywo	400	100	0	0	5000	f
186	Majonez Lekki (Winiary)	g	100	Lidl	338	1.1	33.2	8.4	2000	f
185	Protein pillow o smaku karmelowym (Brownfield)	g	100	Lidl	437	20	18	52	1200	f
151	Kanapka z szarpaną wołowiną (Galeria Wypieków Lubaszka)	sztuka	1	Na żywo	588	25	22.14	70.2	5000	f
187	Schab pieczony 	g	100	Lidl	291	30.4	18.7	0.3	2000	f
103	Danone YoPro Jogurt smak straciatella 160g (Danone YoPro)	sztuka	1	Na żywo	91	15	0.8	5.8	5000	f
169	Żurawina suszona 200g (Alesto)	g	100	Lidl	338	0.7	1.2	78	400	f
190	MC Crispy (Mac Donald's)	sztuka	1	Na żywo	550	27	23	56	2000	f
165	Rodzynki Jumbo (Alesto)	g	100	Zapasy	331	3	2	72	400	t
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
286	Twix baton 51g	sztuka	1	Na żywo	251	2.5	12.4	32.5	2000	f
287	Bułka tyrolska (Putka) 90g	sztuka	1	Na żywo	289	9.3	5	48	2000	f
313	baton oshee crispy wafer 37g	sztuka	1	Lidl	189	10	12.9	9.3	2000	f
288	Kentucky Gold Grander (KFC) 320g	sztuka	1	Na żywo	842	36	45	78	2000	f
289	shake truskawka (KFC) mały 180ml	sztuka	1	Na żywo	258	4.5	9	39	2000	f
290	Karkówka (Straight From The Grate)	porcja	1	Na żywo	1150	42	60	85	2000	f
291	Skyr smakowy (Piątnica) 150g	sztuka	1	Na żywo	129	14.4	0	18	2000	f
292	Gołąbki (ogólna estymata)	g	100	Na żywo	103	7.5	4.3	9.2	2000	f
293	Chleb pszenny (ogólna estymata)	g	100	Świeże	258	9.3	1.4	51.6	2000	f
294	Kurczaker long (Żabka)	sztuka	1	Na żywo	374	18.48	15.4	36.96	2000	f
295	Steki wołowe z udźca (Biedronka) 400g	g	100	Lidl	201	23	4.3	0.5	2000	f
296	Gruszka	g	100	Lidl	57	0.3	0.5	15.5	2000	f
297	Gonzales (Pasibus)	sztuka	1	Na żywo	854	27	55	59	2000	f
298	Standard (Pasibus)	sztuka	1	Na żywo	789	32	52	47	2000	f
299	Włoski pastuch (Pasibus)	sztuka	1	Na żywo	920	37	59	47	2000	f
300	Klasyk (Pasibus)	sztuka	1	Na żywo	616	29	33	59	2000	f
301	Bebek (Pasibus)	sztuka	1	Na żywo	882	36	58	53	2000	f
302	Frytki (Pasibus) M,Ś,D 80,120,175g	g	100	Na żywo	297	3	16	34	2000	f
303	Jack Daniel's Coca-Cola 330ml	sztuka	1	Na żywo	195	0	0	26	2000	f
263	Papryka wędzona przyprawa	g	100	Zapasy	289	15	13	56	2000	t
304	krówka (ogólna estymata)	g	100	Lidl	424	3.2	12	76	2000	f
305	maxi meal słony karmel (Bakoma) 500g	sztuka	1	Na żywo	500	33.5	23.5	35	2000	f
306	crispy chicken (burger king)	sztuka	1	Na żywo	489	18	29	39	2000	f
307	Seven days double 110g	sztuka	1	Na żywo	496	6	30	48	2000	f
308	Kentucky Gold Wrapper (KFC) 350g	sztuka	1	Na żywo	1197	42	77	91	2000	f
309	Karkówka (Straight from the Grate)	porcja	1	Na żywo	1200	45	80	100	2000	f
310	karpatka	g	100	Na żywo	210	2.6	11	25	2000	f
311	Zott Primo 200g	sztuka	1	Na żywo	126	9.8	6	8.4	2000	f
312	Baton protein tiramisuu (GO ON) 45g	sztuka	1	Na żywo	194	11.7	10.4	17.6	2000	f
314	Kurczak Bac Bo (Le Asia Food)	porcja	1	Na żywo	700	40	25	72	2000	f
315	Koreczki śledziowe z suszonymi pomidorami (Seko 220g) 140g same mięso trochę olej	porcja	1	Lidl	350	17.2	27.7	8	2000	f
316	satino o smaku czekoladowym (Bakoma) 165g	sztuka	1	Lidl	145	3.6	4	23.4	2000	f
317	Pulled chicken salsa (El Tequito) 550g	g	100	Lidl	138	17.5	6.5	2	2000	f
318	Toffifee (Storck)1/15 z 125g	sztuka	1	Na żywo	43.4	0.5	2.42	4.9	2000	f
319	Ser żółty gouda (Hochland)	g	100	Lidl	352	25	28	0	2000	f
320	Oliwki czarne (1 sztuka)	sztuka	1	Lidl	4	0.01	0.39	0	2000	f
321	wonder  protein bar GO ON 45g	sztuka	1	Lidl	188	12.6	9.5	16.2	2000	f
322	Tuńczyk pieczony z pieprzem (Seamor)	g	100	Lidl	131	30	1.2	0	2000	f
323	Makaron Ramen (House of Asia) 300g	g	100	Lidl	358	12	1.1	74	2000	f
324	Pasta Pad Thai (TODO) 113g	g	100	Lidl	265	1.8	5.3	52	2000	f
331	Baton knoppers ten dobry (Storck) 40g	sztuka	1	Na żywo	212.4	3.36	20.88	12.64	2000	f
332	Grejpfrut 260g	sztuka	1	Na żywo	104	1.6	0.5	20.5	2000	f
333	Oreo 1 sztuka 11g	sztuka	1	Na żywo	52	0.6	2.1	7.5	2000	f
334	Knopper wafelek ten mały (Storck) 25g	sztuka	1	Na żywo	137	2.2	8.3	13.1	2000	f
353	kanapka Żabka high protein 27g białka kurczak pieczony, szusozne pomidory (Tomcio Paluch)	sztuka	1	Na żywo	443	27	24.5	24.5	2000	f
354	Nektarynka (115g)	sztuka	1	Na żywo	58	1	0.2	12.2	2000	f
355	Dżem z czarnych porzeczek (Herbapol)	g	100	Lidl	127	0.5	0.5	30	2000	f
356	Skyr jogurt pitny jagoda borówka (Bakoma) 300g	sztuka	1	Na żywo	225	20.1	4.2	26.7	2000	f
357	baton purella super foods matcha & yuzu protein crunchy	g	100	Na żywo	419	24	14	49	2000	f
358	baton miodowy kłos słonecznik 	sztuka	1	Na żywo	187	4.7	6.9	26	2000	f
359	penne z kurczakiem (chef select) 400g	porcja	1	Lidl	568	41.6	18	64.4	2000	f
360	piwo smakowe 0% 500ml	opakowanie	1	Lidl	120	0	0	30	2000	f
361	precelki solone (Lidl) 250g	g	100	Lidl	403	13	8.3	68	2000	f
362	pizza capricciosa (Szkolna)	g	100	Lidl	250	11	9	31	2000	f
363	ketchup słodka Ania (rybak)	g	100	Lidl	97	0.9	0.2	22	2000	f
325	karkówka z tłuszczem surowa (OE)	g	100	Lidl	235	17	18	0	2000	f
326	lion baton 43g	sztuka	1	Na żywo	208	2.11	9.85	27.91	2000	f
327	Bułka dyniowo-słonecznikowa (Putka) 85g	sztuka	1	Na żywo	287	11	8.5	43	2000	f
328	Bułka Tyrolska (Putka) 90g	sztuka	1	Na żywo	260	8.4	4.5	43	2000	f
329	Bułka wiejska (Galeria Wypieków Lubaszka) 95g	sztuka	1	Na żywo	220	6.75	3.9	37.8	2000	f
330	elitesse 23g	sztuka	1	Na żywo	121	1.6	6.67	13.57	2000	f
335	Kiwi gold 115g	sztuka	1	Na żywo	57	1.2	0.5	13.5	2000	f
336	winogrono białe (1x garść = 70g)	g	100	Na żywo	71	0.5	0.2	16.1	2000	f
337	fking delicious sauce cherry (All nutrition) 280g	g	100	Lidl	99	0.5	0.5	38	2000	f
338	Chicker Gold (Chef Select) 172g	sztuka	1	Na żywo	490	18.9	24.1	46.4	2000	f
339	Chicker Louisiana BBQ (Chef Select) 172g	sztuka	1	Na żywo	384	16.2	13.8	46.4	2000	f
340	Mint Pudina Chicken (hinduska estymata)	g	100	Lidl	170	25	6	3	2000	f
341	Naan (hinduska estymata)	g	100	Lidl	310	9	7	58	2000	f
342	WW baton	sztuka	1	Na żywo	230	3.1	12.1	26.6	2000	f
343	Corona Zero 330ml	sztuka	1	Na żywo	56	0.6	0	12	2000	f
344	Baton Snickers (51g)	sztuka	1	Na żywo	246	4.4	11.5	31	2000	f
345	Czerwone curry (house of Asia) 113g	g	100	Na żywo	103	5	2.4	8.8	2000	f
346	Wrap Tuńczyk Awokado	porcja	1	Na żywo	518	25.7	19.1	56.1	2000	f
347	Aperitivo (Franzini)	g	100	Na żywo	70	0	0	10	2000	f
348	Lays Zielona Cebulka	g	100	Na żywo	519	6.3	31	53	2000	f
350	ciastka Choco cookies (Milka) dwa 27g	porcja	1	Na żywo	135	0.22	6.6	17	2000	f
351	pizza capricciosa (Chef Select)	porcja	1	Na żywo	848	43.6	18.4	122.8	2000	f
352	Fasolka szparagowa gotowana	g	100	Na żywo	33	2.1	0.2	4.5	2000	f
349	czekolada gorzka kakao 64% (Wedel) 3 kostki = 15g	g	15	Lidl	76	1.4	5	5.4	2000	f
364	Brownie z cukini (Kuchnia Siostry Anny)	g	100	Na żywo	151	10.2	5.02	22	2000	f
365	Nutlove crunch (All nutrition) 200g	g	108	Lidl	515	3.5	8.8	12	2000	f
366	Płatki z pełnego ziarna pszenicy (Carrefour Classic)	g	100	Lidl	359	9.8	2.7	68	2000	f
367	Gorąca Pizza na Wynos Tex-Mex - Żabka	g	100	Na żywo	215	10	7	27	2000	f
368	Smiej żelki Mlekoduszki (nimm2) 90g	g	100	Na żywo	322	6.6	0.2	74	2000	f
\.


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: kartezjusz
--

COPY public.recipes (dish_id, time_total, what_before, preparation, when_start) FROM stdin;
23			Przyprawy: Majeranek, Tymianek\n	
17			Krojenie kurczaka:\nBardzo cienko, staraj się imitować kebsa, znajdź jak idą paski włókien na kurczaka i krój prosopadle do nich.\n\nDaj przyprawę do Gyrosa.\n\nSosik:\nTzatziki, Oregano (mało), Kolendra świeża, czosnek, trochę soku z cytryny.\nJak masz ogóre to daj.	
198				
63			1. Podsmaż mięso na 5 g oleju, odstaw.\n2. Na tej samej patelni podsmaż cebulę, czosnek, marchew i kapustę.\n3. Dodaj przyprawę curry i łyżkę sosu sojowego.\n4. Wbij jajko i zamieszaj, aż się zetnie.\n5. Dorzuć mięso i pokrojone paski tortilli.\n6. Wlej 2–3 łyżki mleczka kokosowego (opcjonalnie) i smaż 1–2 minuty, mieszając jak „na wok”.\n7. Pod koniec polej resztą oleju i ewentualnie dopraw do smaku.	
15				
26			Mirunę pieprzem przed. Cyk do piekarnika frytki też. Potem sos miliona jezior z jogurtu greckiego, musztardy i ketchupu.	
68			1. Łososia posmaruj mieszanką sosu sojowego, czosnku i soku z limonki.\n2. Odstaw na 10–15 min, potem smaż lub piecz.\n3. W tym czasie ugotuj ryż jaśminowy.\n4. Podawaj z odrobiną chili i sokiem z limonki na wierzchu.	
190			1. Łososia posmaruj mieszanką sosu sojowego, czosnku i soku z limonki.\n2. Odstaw na 10–15 min, potem smaż lub piecz.\n3. W tym czasie ugotuj ryż jaśminowy.\n4. Podawaj z odrobiną chili i sokiem z limonki na wierzchu.	
199				
66				
187				
148				
189			1. Ziemniaki dokładnie umyj, ugotuj w osolonej wodzie ok 20minut\n2. Łososia piecz\n3. W tym czasie przygotuj dip jogurtowy: jogurt + chrzan lub musztarga + koper + sokz z cytryny + szczypta soli\n	
36	ok. 25–30 minut		Ryż: ugotuj ryż (100 g suchego) według instrukcji (ok. 12 min).\nKurczak: pokrój filet w kostkę, dopraw solą i pieprzem. Usmaż na 6 g oliwy, aż będzie złoty.\nWarzywa: pokrój paprykę, cebulę i marchew w słupki/plastry. Dodaj na patelnię do kurczaka i podsmażaj 3–4 minuty.\nAnanas: dorzuć kostki ananasa, zamieszaj.\nSos słodko-kwaśny: wymieszaj w kubku sos sojowy, keczup, ocet i cukier/miód + 50 ml wody. Wlej na patelnię, duś całość 3–4 minuty, aż zgęstnieje.\nPodanie: podaj na ryżu.	
167				
14				
24				
19				
38				
210				
208				
20				
113				
209				
22			Oliwę wlej tak po prostu do michy, bo za suchei za mało fatu	
67			1. Ziemniaki dokładnie umyj, ugotuj w osolonej wodzie ok 20minut\n2. Łososia piecz\n3. W tym czasie przygotuj dip jogurtowy: jogurt + chrzan lub musztarga + koper + sokz z cytryny + szczypta soli\n	
149				
191				
194				
197				
16			Marchew zetrzyj, ser roladę ustrzycką zetrzyj	
35			Dwa burgery z jednego kotleta\n\nFrytki szybko easy w Air Fryierze	
39				
34			Frytki i steka soczyście solisz.\n\nZ jogurtu, kapusty, soku z cytryny i pieprzu robisz sałatkę jak mama kiedyś :'(\n\n	
147			- 2–3 jajka do kubka\n- widelcem 10 sek mieszania\n- mikrofalówka:\n- 40 sek → zamieszaj\n- 30–40 sek → gotowe	
54				
55				
56				
57				
58				
59				
60				
61				
188			Gdy łosoś się piecze a makaron gotuje robisz Salsę:\n1. Awokado na papkę gnieciesz albo blendujesz.\n2. Cebulkę kroisz w kosteczki.\n3. Całość do miski.\n4. Zalewasz oliwą, kolendrą i czosnkiem.\n5. Salsa gotowa.	
18			Gdy łosoś się piecze a makaron gotuje robisz Salsę:\n1. Awokado na papkę gnieciesz albo blendujesz.\n2. Cebulkę kroisz w kosteczki.\n3. Całość do miski.\n4. Zalewasz oliwą, kolendrą i czosnkiem.\n5. Salsa gotowa.	
21			Przyprawy: Tymianek.	
166				
29				
86			Wrzuć składniki do miski zamiksuj, przelej do formy piecz 30-40minut.\n\nhttps://youtube.com/shorts/SspgxK9oPdY?si=BwNy4Kk_tkYL1las	
200				
31				
28				
30				
87			Składniki na ciasto {serek wiejski 200g, jajko jedno, mąka 50g, przyprawy}.\n\nPiekarnik 220 grzej. Potem mieszasz ciasto i cyk na blaszke cieniutko uformowane koło i pieczemy 15 minut aż się przypiecze fajnie. Teraz smarowanie koncentratem i serem znowu do piekarnika na 5 minut, i cyk dodatki już na zimno\n\nhttps://www.tiktok.com/@orzechowskam/video/7494611420756053270	
152			https://www.odzywiajsiezdrowo.pl/dorsz-z-ryzem-i-warzywami/\n\n1. Dorsza ułóż w naczyniu żaroodpornym. Na rybie połóż koperek. Dopraw pieprzem.\n2. Warzywa oprósz ziołami i skrop oliwą. Przykryj.\n3. Wszystkie składniki piecz 20 minut w piekarniku nagrzanym do 200 C (możesz ugotować na parze lub upiec w rękawie).\n4. Ryż ugotuj według przepisu na opakowaniu. 	
193				
192				
161			1. Do prostokątnego, podłużnego, szklanego naczynia wrzuć wszystkie składniki i wymieszaj.\n2. Odstaw na 4-5h do lodówki lub (optimal) na całą noc.	
151				
165				
153				
195	ok. 25–30 minut	nic – wszystko zrobisz na świeżo.	3. **Przygotowanie:**\n    - Komosę dobrze przepłucz i gotuj 12–15 minut w proporcji 1:2. Pod koniec dodaj 1/2 łyżki oliwy i sok z cytryny.\n    - Paprykę i cukinię pokrój w plastry i grilluj na patelni lub w piekarniku (ok. 10 minut, aż zmiękną i lekko się przypieką).\n    - Halloumi pokrój w plastry 1–1,5 cm, smaż na suchej patelni po ok. 1–2 minuty z każdej strony, aż się zarumieni.\n    - Podawaj na ciepło: komosa na spód, warzywa i halloumi na wierzchu. Posyp zieleniną i dopraw do smaku.	ok. 25–30 minut przed posiłkiem
196				
154				
201				
150				
211				
217				
225				
212				
219				
224				
213				
218				
222				
226				
214				
216				
215				
220				
223				
168			Oliwę wlej tak po prostu do michy, bo za suchei za mało fatu	
88			https://www.tiktok.com/@orzechowskam/video/7490104352544247062\n\nZrób galaretke według przepisu (ale mniej ilości wody niż zakłada producent), ale nie ścinaj jeszcze. Z twarogu i skyra robisz masę blendowaniem. Połowę galaretki wlewasz do masy. Znowu miksujesz. Do foremki na dół układasz biszkopty i przelewasz na to masę w całości i odstawiasz do lodówki. Reszta galaretki też do lodowki. Oba na 30minut (ale sprawdzaj w trakcie, może być nawet 45 min. Potem dokładasz owoce, zalewasz galaretką i znowu do lodówki aż zastygnie max.	
176			Krojenie kurczaka:\nBardzo cienko, staraj się imitować kebsa, znajdź jak idą paski włókien na kurczaka i krój prosopadle do nich.\n\nDaj przyprawę do Gyrosa.\n\nSosik:\nTzatziki, Oregano (mało), Kolendra świeża, czosnek, trochę soku z cytryny.\nJak masz ogóre to daj.	
178			1. Makaron ryżowy zalej wrzątkiem i odstaw na 8–10 minut, aż zmięknie. Odcedź i przepłucz zimną wodą.\n2. Na 5 g oleju podsmaż drobno pokrojoną cebulę, czosnek i marchewkę (może być w julienne).\n3. Dodaj pokrojonego kurczaka, smaż do zarumienienia.\n4. Zsuń składniki na bok patelni, wbij jajko i zamieszaj, aż się zetnie.\n5. Dodaj makaron i sos sojowy + miód + sok z limonki (to Twoja wersja sosu Pad Thai).\n6. Wymieszaj wszystko i smaż jeszcze 2–3 minuty na średnim ogniu.\n7. Zdejmij z ognia, polej resztą oleju i posyp posiekanymi orzeszkami ziemnymi.\n8. Podaj z odrobiną świeżej kolendry lub szczypiorku.	
180				
177				
65			1. Kurczaka pokrój w kostkę. W misce wymieszaj z sosem sojowym, miodem, imbirem, kurkumą, czosnkiem i szczyptą soli.\n2. Odstaw na 10–15 min, żeby się zamarynował.\n3. W tym czasie ugotuj makaron ryżowy (zalewając wrzątkiem na 8–10 min), następnie odcedź i przepłucz.\n4. Na dużej patelni lub woku rozgrzej 10 g oliwy, usmaż kurczaka na złoto z każdej strony.\n5. Dorzuć chińską mieszankę warzyw, smaż razem 5–6 min, aż warzywa będą gorące i lekko chrupiące.\n6. Dodaj makaron, pozostałe 5 g oliwy, nerkowce i ewentualnie kilka kropel sosu sojowego do smaku.\n7. Wymieszaj całość, smaż jeszcze 1–2 min, żeby wszystko się połączyło i miód lekko skarmelizował.	
175			1. Kurczaka pokrój w kostkę. W misce wymieszaj z sosem sojowym, miodem, imbirem, kurkumą, czosnkiem i szczyptą soli.\n2. Odstaw na 10–15 min, żeby się zamarynował.\n3. W tym czasie ugotuj makaron ryżowy (zalewając wrzątkiem na 8–10 min), następnie odcedź i przepłucz.\n4. Na dużej patelni lub woku rozgrzej 10 g oliwy, usmaż kurczaka na złoto z każdej strony.\n5. Dorzuć chińską mieszankę warzyw, smaż razem 5–6 min, aż warzywa będą gorące i lekko chrupiące.\n6. Dodaj makaron, pozostałe 5 g oliwy, nerkowce i ewentualnie kilka kropel sosu sojowego do smaku.\n7. Wymieszaj całość, smaż jeszcze 1–2 min, żeby wszystko się połączyło i miód lekko skarmelizował.	
179	ok. 25–30 minut		Ryż: ugotuj ryż (100 g suchego) według instrukcji (ok. 12 min).\nKurczak: pokrój filet w kostkę, dopraw solą i pieprzem. Usmaż na 6 g oliwy, aż będzie złoty.\nWarzywa: pokrój paprykę, cebulę i marchew w słupki/plastry. Dodaj na patelnię do kurczaka i podsmażaj 3–4 minuty.\nAnanas: dorzuć kostki ananasa, zamieszaj.\nSos słodko-kwaśny: wymieszaj w kubku sos sojowy, keczup, ocet i cukier/miód + 50 ml wody. Wlej na patelnię, duś całość 3–4 minuty, aż zgęstnieje.\nPodanie: podaj na ryżu.	
162			https://youtu.be/lkeZpzkA16o\n\n1. Blend a whole chicken breast (with salt, garlic, paprika, dijon mustard)\n2. Spread it thin layer on the bakin tray (from whole breast you should get 2 pieces - future calzones).\n3. Spread creeme cheese as a next layer on top (oregano, black pepper, citromle)\n4. Add tomatoes, cheese and ham as next layer.\n5. Fold it with the help of paper.\n6. Add grana padno sprikled cheese on top.\n7. Bake it 25minutes, 190C, Up-Down termoobieg.	
202				
203				
181				
204				
205				
206				
155				
156				
169			Marchew zetrzyj, ser roladę ustrzycką zetrzyj	
170			Dwa burgery z jednego kotleta\n\nFrytki szybko easy w Air Fryierze	
173			\n	
62			1. Zagotuj wodę cały czajnik\n2. Wątróbkę pokrój\n3. Nagrzej oliwę na patelni\n4. Wstaw kaszę bulgur do gara na 10 min\n5. Wątróbkę zacznij smażyć standardowo\n6. Krój w tym czasie jabłka\n7. Dodaj je razem ze szpinakiem jak już się wątróbka zarumieni\n8. W tym czasie robisz sosik z jogurtu, kolendry i pieprzu.	
139				
174			1. Zagotuj wodę cały czajnik\n2. Wątróbkę pokrój\n3. Nagrzej oliwę na patelni\n4. Wstaw kaszę bulgur do gara na 10 min\n5. Wątróbkę zacznij smażyć standardowo\n6. Krój w tym czasie jabłka\n7. Dodaj je razem ze szpinakiem jak już się wątróbka zarumieni\n8. W tym czasie robisz sosik z jogurtu, kolendry i pieprzu.	
64			1. Makaron ryżowy zalej wrzątkiem i odstaw na 8–10 minut, aż zmięknie. Odcedź i przepłucz zimną wodą.\n2. Na 5 g oleju podsmaż drobno pokrojoną cebulę, czosnek i marchewkę (może być w julienne).\n3. Dodaj pokrojonego kurczaka, smaż do zarumienienia.\n4. Zsuń składniki na bok patelni, wbij jajko i zamieszaj, aż się zetnie.\n5. Dodaj makaron i sos sojowy + miód + sok z limonki (to Twoja wersja sosu Pad Thai).\n6. Wymieszaj wszystko i smaż jeszcze 2–3 minuty na średnim ogniu.\n7. Zdejmij z ognia, polej resztą oleju i posyp posiekanymi orzeszkami ziemnymi.\n8. Podaj z odrobiną świeżej kolendry lub szczypiorku.	
182			1. Podsmaż mięso na 5 g oleju, odstaw.\n2. Na tej samej patelni podsmaż cebulę, czosnek, marchew i kapustę.\n3. Dodaj przyprawę curry i łyżkę sosu sojowego.\n4. Wbij jajko i zamieszaj, aż się zetnie.\n5. Dorzuć mięso i pokrojone paski tortilli.\n6. Wlej 2–3 łyżki mleczka kokosowego (opcjonalnie) i smaż 1–2 minuty, mieszając jak „na wok”.\n7. Pod koniec polej resztą oleju i ewentualnie dopraw do smaku.	
163			https://www.facebook.com/reel/876554731671137\n\nZamiast 100g chipotle peppers to dajemy koncentrat 50g + papryka wędzona + miód\n\n	
185			Mirunę pieprzem przed. Cyk do piekarnika frytki też. Potem sos miliona jezior z jogurtu greckiego, musztardy i ketchupu.	
142				
143				
123			https://www.tiktok.com/@orzechowskam/video/7503142575449345282\n\nDwie miski:\n- w jednej misce ubijasz na bardzo puszystą i bardzo sztywną pianę białka jaj i to jedno jajko\n- w drugiej ubijamy zaś resztę składników\n\nPotem puszystą pianę przenosisz delikatnie łyżką do tej drugiej miski i łączysz ze sobą obie masy ale łyżko (nie mikserem), żeby nie stracić puszystości. Potem tę masę cyk na suchą nagrzaną patelnie układasz po łyżce masy i smażysz po obu stronach.\n\nJak już widzisz po bokach, że na spodzie już jest takie fajne brązowe, to podważając najpierw sobie to na spokojnie z każdej strony robisz CYK OBROCIK.\n\n	
124			Ciasto\n- Do miski: 120 g mąki kukurydzianej + sól.\n- Stopniowo dodawaj 200–230 ml bardzo ciepłej wody + 100 g białek jaj.\n- Mieszaj → zagnieć → odstaw na 3-5 min (mąka pije wodę).\n- Uformuj 2 grube krążki (ok. 2 cm).\n\nKurczak - zamarynuj w jakiś przyprawach, usmaż na patelni, uduś z papryką.\n\nSmażenie\n- Patelnia średnia moc.\n- 1–2 min z każdej strony, aż zrobi się lekka skorupka.\n\nPieczenie / dopieczenie\n- Przerzuć na piekarnik 200°C, 8–10 min (to robi różnicę: będą puszyste i mokre w środku, chrupiące na zewnątrz) Aczkolwiek Victor dawał bezpośrednio z patelni i było puszyste oraz mokre.\n\nNadzienie\n- Kurczaka rozszarp widelcem.\n- Otwórz arepę nożem do połowy i wypełnij:\nnajpierw kurczak\n- Potem stracciatella	
125				
127				
117				
130				
207				
41	ok. 25–30 minut	nic – wszystko zrobisz na świeżo.	3. **Przygotowanie:**\n    - Komosę dobrze przepłucz i gotuj 12–15 minut w proporcji 1:2. Pod koniec dodaj 1/2 łyżki oliwy i sok z cytryny.\n    - Paprykę i cukinię pokrój w plastry i grilluj na patelni lub w piekarniku (ok. 10 minut, aż zmiękną i lekko się przypieką).\n    - Halloumi pokrój w plastry 1–1,5 cm, smaż na suchej patelni po ok. 1–2 minuty z każdej strony, aż się zarumieni.\n    - Podawaj na ciepło: komosa na spód, warzywa i halloumi na wierzchu. Posyp zieleniną i dopraw do smaku.	ok. 25–30 minut przed posiłkiem
171			Frytki i steka soczyście solisz.\n\nZ jogurtu, kapusty, soku z cytryny i pieprzu robisz sałatkę jak mama kiedyś :'(\n\n	
183				
184			https://www.odzywiajsiezdrowo.pl/dorsz-z-ryzem-i-warzywami/\n\n1. Dorsza ułóż w naczyniu żaroodpornym. Na rybie połóż koperek. Dopraw pieprzem.\n2. Warzywa oprósz ziołami i skrop oliwą. Przykryj.\n3. Wszystkie składniki piecz 20 minut w piekarniku nagrzanym do 200 C (możesz ugotować na parze lub upiec w rękawie).\n4. Ryż ugotuj według przepisu na opakowaniu. 	
134				
135				
186				
126				
140				
\.


--
-- Name: diet_labels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.diet_labels_id_seq', 1, false);


--
-- Name: diets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.diets_id_seq', 7, true);


--
-- Name: dish_labels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.dish_labels_id_seq', 6, true);


--
-- Name: dishes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.dishes_id_seq', 226, true);


--
-- Name: ingredient_labels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.ingredient_labels_id_seq', 1, false);


--
-- Name: ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kartezjusz
--

SELECT pg_catalog.setval('public.ingredients_id_seq', 368, true);


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

