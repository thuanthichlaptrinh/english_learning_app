--
-- PostgreSQL database dump
--

\restrict XArqdT7gogVufntiBNj2pBvD3BnxIoeguSnapdGXiJrWY92g9vKWEC8aBWdXdur

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.flyway_schema_history OWNER TO postgres;

--
-- Name: game_session_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.game_session_details (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    is_correct boolean NOT NULL,
    time_taken integer,
    session_id bigint NOT NULL,
    vocab_id uuid NOT NULL
);


ALTER TABLE public.game_session_details OWNER TO postgres;

--
-- Name: game_session_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.game_session_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.game_session_details_id_seq OWNER TO postgres;

--
-- Name: game_session_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.game_session_details_id_seq OWNED BY public.game_session_details.id;


--
-- Name: game_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.game_sessions (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    accuracy double precision,
    correct_count integer NOT NULL,
    duration integer,
    finished_at timestamp(6) without time zone,
    score integer NOT NULL,
    started_at timestamp(6) without time zone NOT NULL,
    total_questions integer,
    game_id bigint NOT NULL,
    topic_id bigint,
    user_id uuid NOT NULL
);


ALTER TABLE public.game_sessions OWNER TO postgres;

--
-- Name: game_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.game_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.game_sessions_id_seq OWNER TO postgres;

--
-- Name: game_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.game_sessions_id_seq OWNED BY public.game_sessions.id;


--
-- Name: games; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.games (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    description character varying(500),
    name character varying(100) NOT NULL,
    rules_json text
);


ALTER TABLE public.games OWNER TO postgres;

--
-- Name: games_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.games_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.games_id_seq OWNER TO postgres;

--
-- Name: games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.games_id_seq OWNED BY public.games.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    content text,
    is_read boolean NOT NULL,
    title character varying(255) NOT NULL,
    type character varying(50),
    user_id uuid NOT NULL
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_id_seq OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: packages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.packages (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    name character varying(100) NOT NULL,
    version character varying(20) NOT NULL,
    topic_id bigint
);


ALTER TABLE public.packages OWNER TO postgres;

--
-- Name: packages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.packages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.packages_id_seq OWNER TO postgres;

--
-- Name: packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.packages_id_seq OWNED BY public.packages.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    description character varying(255),
    name character varying(50) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tokens (
    id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    expired boolean NOT NULL,
    refresh_token character varying(500),
    revoked boolean NOT NULL,
    token character varying(500) NOT NULL,
    user_id uuid NOT NULL
);


ALTER TABLE public.tokens OWNER TO postgres;

--
-- Name: topics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.topics (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    description character varying(500),
    name character varying(100) NOT NULL
);


ALTER TABLE public.topics OWNER TO postgres;

--
-- Name: topics_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.topics_id_seq OWNER TO postgres;

--
-- Name: topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.topics_id_seq OWNED BY public.topics.id;


--
-- Name: types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.types (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.types OWNER TO postgres;

--
-- Name: types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.types_id_seq OWNER TO postgres;

--
-- Name: types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.types_id_seq OWNED BY public.types.id;


--
-- Name: user_game_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_game_settings (
    id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    game_name character varying(50) NOT NULL,
    image_word_total_pairs integer,
    quick_quiz_time_per_question integer,
    quick_quiz_total_questions integer,
    word_definition_total_pairs integer,
    user_id uuid NOT NULL,
    CONSTRAINT user_game_settings_game_name_check CHECK (((game_name)::text = ANY (ARRAY[('QUICK_QUIZ'::character varying)::text, ('IMAGE_WORD_MATCHING'::character varying)::text, ('WORD_DEFINITION_MATCHING'::character varying)::text])))
);


ALTER TABLE public.user_game_settings OWNER TO postgres;

--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    user_id uuid NOT NULL,
    role_id bigint NOT NULL
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- Name: user_vocab_progress; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_vocab_progress (
    id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    ef_factor double precision NOT NULL,
    interval_days integer NOT NULL,
    last_reviewed date,
    next_review_date date,
    repetition integer NOT NULL,
    status character varying(50),
    times_correct integer NOT NULL,
    times_wrong integer NOT NULL,
    user_id uuid NOT NULL,
    vocab_id uuid NOT NULL
);


ALTER TABLE public.user_vocab_progress OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    activated boolean NOT NULL,
    activation_expired_date timestamp(6) without time zone,
    activation_key character varying(100),
    avatar character varying(255),
    banned boolean NOT NULL,
    current_level character varying(5),
    date_of_birth date,
    email character varying(100) NOT NULL,
    gender character varying(10) NOT NULL,
    name character varying(100) NOT NULL,
    next_activation_time timestamp(6) without time zone,
    password character varying(255) NOT NULL,
    status character varying(50),
    current_streak integer,
    last_activity_date date,
    longest_streak integer,
    total_study_days integer,
    CONSTRAINT users_current_level_check CHECK (((current_level)::text = ANY (ARRAY[('A1'::character varying)::text, ('A2'::character varying)::text, ('B1'::character varying)::text, ('B2'::character varying)::text, ('C1'::character varying)::text, ('C2'::character varying)::text])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: vocab; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vocab (
    id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    audio character varying(500),
    cefr character varying(10),
    example_sentence character varying(1000),
    img character varying(500),
    interpret character varying(1000),
    meaning_vi character varying(500),
    transcription character varying(100),
    word character varying(100) NOT NULL,
    word_type character varying(50),
    credit character varying(255)
);


ALTER TABLE public.vocab OWNER TO postgres;

--
-- Name: vocab_packages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vocab_packages (
    package_id bigint NOT NULL,
    vocab_id uuid NOT NULL
);


ALTER TABLE public.vocab_packages OWNER TO postgres;

--
-- Name: vocab_topics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vocab_topics (
    vocab_id uuid NOT NULL,
    topic_id bigint NOT NULL
);


ALTER TABLE public.vocab_topics OWNER TO postgres;

--
-- Name: vocab_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vocab_types (
    vocab_id uuid NOT NULL,
    type_id bigint NOT NULL
);


ALTER TABLE public.vocab_types OWNER TO postgres;

--
-- Name: game_session_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_session_details ALTER COLUMN id SET DEFAULT nextval('public.game_session_details_id_seq'::regclass);


--
-- Name: game_sessions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_sessions ALTER COLUMN id SET DEFAULT nextval('public.game_sessions_id_seq'::regclass);


--
-- Name: games id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games ALTER COLUMN id SET DEFAULT nextval('public.games_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: packages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.packages ALTER COLUMN id SET DEFAULT nextval('public.packages_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: topics id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.topics ALTER COLUMN id SET DEFAULT nextval('public.topics_id_seq'::regclass);


--
-- Name: types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types ALTER COLUMN id SET DEFAULT nextval('public.types_id_seq'::regclass);


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	<< Flyway Baseline >>	BASELINE	<< Flyway Baseline >>	\N	postgres	2025-11-03 02:06:19.978025	0	t
\.


--
-- Data for Name: game_session_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.game_session_details (id, created_at, updated_at, is_correct, time_taken, session_id, vocab_id) FROM stdin;
1	2025-10-10 20:29:33.999966	2025-10-10 20:29:33.999966	f	0	1	58b7563c-e5d6-4247-b3e7-af5b988f0fe1
2	2025-10-10 20:29:39.680493	2025-10-10 20:29:39.680493	t	0	1	58b7563c-e5d6-4247-b3e7-af5b988f0fe1
3	2025-10-10 20:30:01.71241	2025-10-10 20:30:01.71241	f	0	1	58b7563c-e5d6-4247-b3e7-af5b988f0fe1
4	2025-10-10 20:31:32.808091	2025-10-10 20:31:32.808091	f	0	1	1f4716d3-0144-486c-82aa-6495c04a6799
5	2025-10-10 20:31:47.535312	2025-10-10 20:31:47.535312	t	0	1	1f4716d3-0144-486c-82aa-6495c04a6799
6	2025-10-10 20:32:08.675039	2025-10-10 20:32:08.675039	f	0	1	e206b6cc-471c-4a64-a87c-df46ea12e232
7	2025-10-10 20:32:20.937695	2025-10-10 20:32:20.937695	f	0	1	e59b1c30-7f29-4932-8d6a-06925d737687
8	2025-10-10 20:32:34.912244	2025-10-10 20:32:34.912244	t	0	1	2438686e-3383-4faf-9910-381bf478bf51
9	2025-10-10 21:54:38.279347	2025-10-10 21:54:38.279347	t	0	2	88d2fae9-669e-4a72-9cb4-4d312e8da912
10	2025-10-10 21:55:19.242238	2025-10-10 21:55:19.242238	f	0	2	ab34318d-5656-4705-b2cf-187a06375d27
11	2025-10-10 21:55:23.729335	2025-10-10 21:55:23.729335	t	0	2	87d4927c-4a8f-48d9-93e3-71e8a35e0770
12	2025-10-10 21:55:26.28903	2025-10-10 21:55:26.28903	f	0	2	64edc678-01c8-4291-9fd0-efd330d6dead
13	2025-10-10 21:55:28.819546	2025-10-10 21:55:28.819546	t	0	2	c3d41e13-d185-40d8-83e8-9322dde44e2e
14	2025-10-11 12:49:51.784031	2025-10-11 12:49:51.784031	t	0	3	64edc678-01c8-4291-9fd0-efd330d6dead
15	2025-10-11 12:49:59.519997	2025-10-11 12:49:59.519997	f	0	3	c3d41e13-d185-40d8-83e8-9322dde44e2e
16	2025-10-11 12:50:05.79618	2025-10-11 12:50:05.79618	f	0	3	89680f43-6a58-4b4f-8e1d-e3c87244472e
17	2025-10-11 12:50:11.080798	2025-10-11 12:50:11.080798	t	0	3	5e53247f-dc44-425e-b70b-fce4cf245048
18	2025-10-11 12:50:16.503896	2025-10-11 12:50:16.503896	t	0	3	1f4716d3-0144-486c-82aa-6495c04a6799
19	2025-10-17 19:29:05.788114	2025-10-17 19:29:05.788114	f	\N	5	72b8c5e2-6168-4927-b758-9c46cbb1a602
20	2025-10-17 19:29:05.803934	2025-10-17 19:29:05.803934	f	\N	5	e59b1c30-7f29-4932-8d6a-06925d737687
21	2025-10-17 19:35:27.725547	2025-10-17 19:35:27.725547	t	\N	6	e206b6cc-471c-4a64-a87c-df46ea12e232
22	2025-10-17 19:35:27.727552	2025-10-17 19:35:27.727552	t	\N	6	64edc678-01c8-4291-9fd0-efd330d6dead
23	2025-10-18 08:21:51.730727	2025-10-18 08:21:51.730727	t	\N	7	c97b145b-085f-4f27-a01a-b0601bcd2e2c
24	2025-10-18 08:21:51.749915	2025-10-18 08:21:51.749915	t	\N	7	1095ba50-88c2-49c5-92f0-76064b90e0ca
25	2025-10-22 20:30:10.387585	2025-10-22 20:30:10.387585	t	\N	8	e2510cb1-8178-42de-904b-5e2cdc3680b5
26	2025-10-22 20:30:10.391435	2025-10-22 20:30:10.391435	t	\N	8	45ea8c80-2e55-4c0c-a429-1d96576fcadf
27	2025-10-22 20:30:10.394637	2025-10-22 20:30:10.394637	t	\N	8	1e8ae068-1f58-455c-ac7a-c697a8188e43
28	2025-10-22 20:54:08.478744	2025-10-22 20:54:08.478744	t	\N	9	841da8ef-9320-4f20-ac66-a7743299ae03
29	2025-10-22 20:54:08.483745	2025-10-22 20:54:08.483745	t	\N	9	f58dc7ab-3f9e-4ffc-a470-ebf4b60a5ff6
30	2025-10-22 20:54:08.486989	2025-10-22 20:54:08.486989	t	\N	9	72a0ffd4-cd07-41bb-9bcb-bda6491d5846
31	2025-10-23 00:22:38.349192	2025-10-23 00:22:38.349192	f	0	11	596c8b71-cfb5-4138-9a9f-c0ee6736e313
32	2025-10-23 00:22:49.088216	2025-10-23 00:22:49.088216	t	0	11	cdc8fb15-da7d-4399-91e8-f1198a3ddc23
33	2025-10-23 00:22:59.499385	2025-10-23 00:22:59.499385	t	0	11	cf0b9614-845c-4250-932c-7561eabc6d6f
34	2025-10-23 00:23:08.295929	2025-10-23 00:23:08.295929	t	0	11	67cec151-d0c1-443d-99fe-7f2b726f01b7
35	2025-10-23 00:23:17.596091	2025-10-23 00:23:17.596091	f	0	11	92e16207-f569-4b2b-931b-155bb1967da4
36	2025-10-23 00:59:50.708848	2025-10-23 00:59:50.708848	t	\N	13	41bcd0ee-915b-46d3-90e9-c1285d1bceee
37	2025-10-23 00:59:50.719778	2025-10-23 00:59:50.719778	t	\N	13	d0b068e5-3c67-427d-b572-b50190b87f3a
38	2025-10-23 00:59:50.725176	2025-10-23 00:59:50.725176	t	\N	13	9f281d66-8f92-409d-ba4f-279ff217567e
39	2025-10-28 22:29:03.695016	2025-10-28 22:29:03.695016	t	0	16	c64e91ed-a4de-40f0-ae4d-4dba3a15eab3
40	2025-10-28 22:31:22.64619	2025-10-28 22:31:22.64619	f	0	16	7850bc93-7891-4814-8917-57af1f272e90
41	2025-10-28 22:32:04.184102	2025-10-28 22:32:04.184102	t	0	16	b8adc413-e1ea-4cbc-bf3a-de5e54422c68
42	2025-10-28 22:32:07.637054	2025-10-28 22:32:07.637054	f	0	16	5f237721-d474-496a-aaef-af413c73ab94
43	2025-10-28 22:32:11.088142	2025-10-28 22:32:11.088142	f	0	16	6d4e0c8b-22b1-4078-bfbb-c42a47bdb1c2
44	2025-10-28 22:51:01.604393	2025-10-28 22:51:01.604393	f	20	17	a8fd5c97-43aa-433b-9b88-39cbae469032
45	2025-10-28 22:53:36.020906	2025-10-28 22:53:36.020906	t	5000	17	a932b9d4-688b-4109-8d88-43fb61e78137
58	2025-11-02 01:19:25.178788	2025-11-02 01:19:25.178788	f	10000	24	3e7b9a5f-58a7-4900-bce5-76c815e6eee0
59	2025-11-02 01:19:37.722602	2025-11-02 01:19:37.722602	t	10000	24	6ba28a5a-471e-4083-b91d-11b8d48461c9
60	2025-11-02 01:19:47.287935	2025-11-02 01:19:47.287935	f	10000	24	d134cb8c-4e65-4b8a-9805-3baecd222021
61	2025-11-02 01:19:51.231415	2025-11-02 01:19:51.231415	f	10000	24	6b3d66f1-95d4-4c80-89ab-c8626b42343c
62	2025-11-02 01:20:00.05311	2025-11-02 01:20:00.05311	f	10000	24	0f9b1333-caf2-47e2-9f5f-e10c0d19252e
63	2025-11-02 01:21:04.763392	2025-11-02 01:21:04.763392	t	\N	25	f58dc7ab-3f9e-4ffc-a470-ebf4b60a5ff6
64	2025-11-02 01:21:04.7684	2025-11-02 01:21:04.7684	t	\N	25	6abad213-f06c-43d5-953e-64ec4864f26d
65	2025-11-02 01:21:04.77392	2025-11-02 01:21:04.77392	t	\N	25	7a26dcad-4d50-4b0c-8c53-a23166043658
66	2025-11-02 01:21:32.649908	2025-11-02 01:21:32.649908	t	\N	26	97fa16a3-6483-4a5f-99f1-2c0fdc612769
67	2025-11-02 01:21:32.655447	2025-11-02 01:21:32.655447	t	\N	26	453d983a-41e1-4534-9d22-bec95353736f
68	2025-11-02 01:21:32.66041	2025-11-02 01:21:32.66041	t	\N	26	aee63a03-282c-4783-9659-7c4e58729e08
69	2025-11-04 19:35:31.002953	2025-11-04 19:35:31.002953	t	\N	28	f60b50e1-ab40-4fa2-b4b0-015adfa3f792
70	2025-11-04 19:35:31.03055	2025-11-04 19:35:31.03055	t	\N	28	45ea8c80-2e55-4c0c-a429-1d96576fcadf
71	2025-11-04 19:35:31.037232	2025-11-04 19:35:31.037232	t	\N	28	cad5490c-fb56-47d6-b305-0a405feac0a0
72	2025-11-04 19:43:58.946043	2025-11-04 19:43:58.946043	t	\N	29	a8fd5c97-43aa-433b-9b88-39cbae469032
73	2025-11-04 19:43:58.955739	2025-11-04 19:43:58.955739	t	\N	29	48178cb1-c1e4-472a-900d-4bf164a752a5
74	2025-11-04 19:43:58.962288	2025-11-04 19:43:58.962288	t	\N	29	f9860988-56b5-4f41-90db-ca52b721c304
75	2025-11-04 21:05:57.995294	2025-11-04 21:05:57.995294	f	10000	37	a81f2eb3-0178-4f9b-ac91-b2b8f97fc118
76	2025-11-04 21:06:20.594504	2025-11-04 21:06:20.595501	f	10000	37	4843714b-fcf2-4889-80b7-337fc38f60bd
77	2025-11-04 21:06:25.743245	2025-11-04 21:06:25.743245	f	10000	37	45b62747-23bc-4928-af2d-e8a40505fc0e
78	2025-11-04 21:06:29.13213	2025-11-04 21:06:29.13213	f	10000	37	105b4aad-e4b4-41cb-8f17-11501595a42c
79	2025-11-04 21:06:32.495233	2025-11-04 21:06:32.495233	f	10000	37	40618d78-8d5f-479f-96f7-e1dfd020be80
80	2025-11-04 21:07:21.843387	2025-11-04 21:07:21.843387	t	\N	38	9653310a-5c16-461d-a2dc-492a24677edd
81	2025-11-04 21:07:21.851931	2025-11-04 21:07:21.851931	t	\N	38	a8fd5c97-43aa-433b-9b88-39cbae469032
82	2025-11-04 21:07:21.854931	2025-11-04 21:07:21.854931	t	\N	38	af0916df-4290-42a5-a159-9daba0868084
83	2025-11-04 21:08:00.578979	2025-11-04 21:08:00.578979	t	\N	39	f95fa30c-31d8-45bf-ad42-d506cc4d55e1
84	2025-11-04 21:08:00.582996	2025-11-04 21:08:00.582996	t	\N	39	5adcfd89-1152-4748-b626-90cab5b913b7
85	2025-11-04 21:08:00.585992	2025-11-04 21:08:00.585992	t	\N	39	f022eed0-6488-4618-95db-c50d6a8bb51b
86	2025-11-05 00:51:14.665202	2025-11-05 00:51:14.665202	t	\N	40	8a623eb6-5c61-43a5-8b89-a019a1beee6b
87	2025-11-05 00:51:14.683973	2025-11-05 00:51:14.683973	t	\N	40	f022eed0-6488-4618-95db-c50d6a8bb51b
88	2025-11-05 00:51:14.723904	2025-11-05 00:51:14.723904	t	\N	40	94f51b7d-163c-44c0-889c-0240e935c91a
89	2025-11-05 00:56:48.740547	2025-11-05 00:56:48.740547	t	\N	41	31b5c2db-7017-4c1c-b314-6af119da397f
90	2025-11-05 00:56:48.747761	2025-11-05 00:56:48.747761	t	\N	41	7f57664a-79ef-4a88-8a99-31810d16ef69
91	2025-11-05 00:56:48.751856	2025-11-05 00:56:48.751856	t	\N	41	f1d68be1-44ce-4f0e-bffc-fa6f28b669b4
92	2025-11-05 01:03:27.93928	2025-11-05 01:03:27.93928	f	10000	44	3e7b9a5f-58a7-4900-bce5-76c815e6eee0
93	2025-11-05 01:03:33.249367	2025-11-05 01:03:33.249367	f	10000	44	99342083-9250-4be9-82a6-1131c091ce18
94	2025-11-05 01:03:37.522246	2025-11-05 01:03:37.522246	t	10000	44	45b62747-23bc-4928-af2d-e8a40505fc0e
95	2025-11-05 01:03:40.867509	2025-11-05 01:03:40.867509	f	10000	44	4306fb3b-f572-4498-9434-b89bb9741340
96	2025-11-05 01:03:44.307489	2025-11-05 01:03:44.307489	f	10000	44	62847eca-5dc3-44a7-b323-8abca1f30553
97	2025-11-05 17:21:46.191772	2025-11-05 17:21:46.191791	t	10000	45	62c3bcd6-606d-4458-b37a-f582609fdeb3
98	2025-11-05 17:21:49.395479	2025-11-05 17:21:49.395503	f	10000	45	4367d0a5-f9b1-4c92-b58d-c6735c7df2d5
99	2025-11-05 17:21:52.555678	2025-11-05 17:21:52.555699	f	10000	45	14fe6c8a-eac5-46c4-b1d5-62817daf1e78
100	2025-11-05 17:21:55.369736	2025-11-05 17:21:55.369755	t	10000	45	4b581df1-8c71-4a6d-8fbe-1600ef59acd9
101	2025-11-05 17:21:58.366994	2025-11-05 17:21:58.367018	t	10000	45	0ae6f709-7a8c-4ab9-a170-9780a3ab2790
102	2025-11-05 17:55:47.952422	2025-11-05 17:55:47.952455	f	10000	46	fa38c299-624b-4dd6-88b8-23f2f4a4008e
103	2025-11-05 17:55:51.978453	2025-11-05 17:55:51.978484	f	10000	46	a10ca209-b213-4931-9db3-39353bf1fc67
104	2025-11-05 17:55:54.924725	2025-11-05 17:55:54.924757	f	10000	46	7f410a5d-03f1-49ec-80a4-4bc282657f0f
105	2025-11-05 17:55:58.599177	2025-11-05 17:55:58.599205	f	10000	46	8b91ab1f-312a-4dac-9929-6667fc418a0f
106	2025-11-05 17:56:01.400158	2025-11-05 17:56:01.400186	f	10000	46	90452f4e-b01c-4497-bcf4-040afb5cbd2c
107	2025-11-05 17:58:43.652417	2025-11-05 17:58:43.65244	f	10000	47	1396744e-d891-401f-b5dd-3d052b8f6f96
108	2025-11-05 17:58:46.556606	2025-11-05 17:58:46.556641	f	10000	47	10109c3c-1c8b-436d-8ea5-d81adc6e3cb8
109	2025-11-05 17:58:49.162706	2025-11-05 17:58:49.162726	f	10000	47	98ae76c4-ceda-4285-978b-17455b34924d
110	2025-11-05 17:58:51.876868	2025-11-05 17:58:51.876894	t	10000	47	90ceb93e-2885-4594-b7fb-8826cbd6aed6
111	2025-11-05 17:58:54.946288	2025-11-05 17:58:54.946304	f	10000	47	26193f2b-c221-41a6-b94b-74b3106c0fcc
\.


--
-- Data for Name: game_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.game_sessions (id, created_at, updated_at, accuracy, correct_count, duration, finished_at, score, started_at, total_questions, game_id, topic_id, user_id) FROM stdin;
1	2025-10-10 20:26:20.578761	2025-10-10 20:32:34.929597	37.5	3	374	2025-10-10 20:32:34.9149	50	2025-10-10 20:26:20.577763	5	1	2	c4d17be2-52a3-4827-a3f3-a3c795576ebf
2	2025-10-10 21:53:31.659281	2025-10-10 21:55:28.827139	60	3	117	2025-10-10 21:55:28.824628	45	2025-10-10 21:53:31.648228	5	1	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf
3	2025-10-11 12:49:27.695548	2025-10-11 12:50:16.511992	60	3	48	2025-10-11 12:50:16.510482	45	2025-10-11 12:49:27.693751	5	1	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf
4	2025-10-17 19:24:39.658295	2025-10-17 19:24:39.658295	\N	0	\N	\N	0	2025-10-17 19:24:39.653296	4	2	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
5	2025-10-17 19:28:45.907356	2025-10-17 19:29:05.805934	0	0	19	2025-10-17 19:29:05.803935	0	2025-10-17 19:28:45.907357	2	2	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
6	2025-10-17 19:34:42.080935	2025-10-17 19:35:27.727552	100	2	45	2025-10-17 19:35:27.727552	35	2025-10-17 19:34:42.080936	2	2	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
7	2025-10-18 08:16:15.114424	2025-10-18 08:21:51.767995	100	2	336	2025-10-18 08:21:51.751439	35	2025-10-18 08:16:15.09067	2	2	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
8	2025-10-22 20:29:21.32397	2025-10-22 20:30:10.397728	100	3	49	2025-10-22 20:30:10.395803	4	2025-10-22 20:29:21.32278	3	2	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
9	2025-10-22 20:53:06.283347	2025-10-22 20:54:08.489003	100	3	62	2025-10-22 20:54:08.48699	18	2025-10-22 20:53:06.282339	3	2	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
10	2025-10-22 20:59:04.570743	2025-10-22 20:59:04.570743	\N	0	\N	\N	0	2025-10-22 20:59:04.569744	3	2	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
11	2025-10-23 00:20:53.050355	2025-10-23 00:23:17.601121	60	3	144	2025-10-23 00:23:17.600121	45	2025-10-23 00:20:53.038679	5	1	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
12	2025-10-23 00:25:46.44627	2025-10-23 00:25:46.44627	\N	0	\N	\N	0	2025-10-23 00:25:46.44527	5	1	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
13	2025-10-23 00:59:02.706228	2025-10-23 00:59:50.738452	100	3	\N	2025-10-23 00:59:50.728618	5	2025-10-23 00:59:02.703191	3	3	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
14	2025-10-28 21:57:40.744376	2025-10-28 21:57:40.744376	\N	0	\N	\N	0	2025-10-28 21:57:40.742454	5	1	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
15	2025-10-28 22:06:51.127303	2025-10-28 22:06:51.127303	\N	0	\N	\N	0	2025-10-28 22:06:51.126119	5	1	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
16	2025-10-28 22:28:48.256493	2025-10-28 22:32:11.104865	40	2	202	2025-10-28 22:32:11.091151	30	2025-10-28 22:28:48.254495	5	1	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
17	2025-10-28 22:50:41.589039	2025-10-28 22:53:36.026944	\N	1	\N	\N	10	2025-10-28 22:50:41.588042	5	1	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
18	2025-10-29 00:49:28.625481	2025-10-29 00:49:28.625481	\N	0	\N	\N	0	2025-10-29 00:49:28.623095	5	1	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
19	2025-10-31 20:50:36.769783	2025-10-31 20:50:36.769783	\N	0	\N	\N	0	2025-10-31 20:50:36.759194	5	1	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
20	2025-10-31 20:54:18.513	2025-10-31 20:54:18.513	\N	0	\N	\N	0	2025-10-31 20:54:18.512	3	3	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
21	2025-10-31 20:57:33.435358	2025-10-31 20:57:33.435358	\N	0	\N	\N	0	2025-10-31 20:57:33.435358	3	2	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
22	2025-10-31 20:58:19.359382	2025-10-31 20:58:19.359382	\N	0	\N	\N	0	2025-10-31 20:58:19.359382	3	2	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
23	2025-10-31 21:12:41.160566	2025-10-31 21:12:41.160566	\N	0	\N	\N	0	2025-10-31 21:12:41.160567	3	2	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
24	2025-11-02 01:19:13.557961	2025-11-02 01:20:00.225031	20	1	46	2025-11-02 01:20:00.057758	10	2025-11-02 01:19:13.556954	5	1	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
25	2025-11-02 01:20:15.684974	2025-11-02 01:21:04.844301	100	3	49	2025-11-02 01:21:04.774921	18	2025-11-02 01:20:15.683951	3	2	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
26	2025-11-02 01:20:22.058159	2025-11-02 01:21:32.71913	100	3	\N	2025-11-02 01:21:32.662416	5	2025-11-02 01:20:22.05816	3	3	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
27	2025-11-03 02:28:19.850035	2025-11-03 02:28:19.850035	\N	0	\N	\N	0	2025-11-03 02:28:19.840408	5	1	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
28	2025-11-04 19:34:55.255086	2025-11-04 19:35:31.072071	100	3	\N	2025-11-04 19:35:31.043035	5	2025-11-04 19:34:55.250573	3	3	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
29	2025-11-04 19:43:33.981014	2025-11-04 19:43:58.992229	100	3	\N	2025-11-04 19:43:58.965673	14	2025-11-04 19:43:33.980013	3	3	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
30	2025-11-04 20:11:07.104093	2025-11-04 20:11:07.104093	\N	0	\N	\N	0	2025-11-04 20:11:07.103049	5	1	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
31	2025-11-04 20:17:22.158412	2025-11-04 20:17:22.158412	\N	0	\N	\N	0	2025-11-04 20:17:22.151266	5	1	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
32	2025-11-04 20:29:19.560487	2025-11-04 20:29:19.560487	\N	0	\N	\N	0	2025-11-04 20:29:19.559469	3	3	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
33	2025-11-04 20:40:29.87438	2025-11-04 20:40:29.87438	\N	0	\N	\N	0	2025-11-04 20:40:29.873353	5	1	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
34	2025-11-04 20:43:01.181527	2025-11-04 20:43:01.181527	\N	0	\N	\N	0	2025-11-04 20:43:01.169519	5	1	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
35	2025-11-04 20:57:28.629168	2025-11-04 20:57:28.629168	\N	0	\N	\N	0	2025-11-04 20:57:28.617669	5	1	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
36	2025-11-04 21:00:32.8139	2025-11-04 21:00:32.8139	\N	0	\N	\N	0	2025-11-04 21:00:32.81271	5	1	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
37	2025-11-04 21:05:52.998304	2025-11-04 21:06:32.534431	0	0	39	2025-11-04 21:06:32.500234	0	2025-11-04 21:05:52.998305	5	1	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
38	2025-11-04 21:06:56.015851	2025-11-04 21:07:21.877428	100	3	\N	2025-11-04 21:07:21.860471	12	2025-11-04 21:06:56.014852	3	3	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
39	2025-11-04 21:07:34.565735	2025-11-04 21:08:00.603875	100	3	26	2025-11-04 21:08:00.585992	18	2025-11-04 21:07:34.564736	3	2	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
40	2025-11-05 00:50:45.252345	2025-11-05 00:51:14.830377	100	3	29	2025-11-05 00:51:14.724904	18	2025-11-05 00:50:45.24021	3	2	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
42	2025-11-05 00:51:44.161572	2025-11-05 00:51:44.161572	\N	0	\N	\N	0	2025-11-05 00:51:44.160572	5	1	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
41	2025-11-05 00:51:29.731838	2025-11-05 00:56:48.776229	100	3	319	2025-11-05 00:56:48.753239	18	2025-11-05 00:51:29.730825	3	2	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
43	2025-11-05 00:59:51.558935	2025-11-05 00:59:51.558935	\N	0	\N	\N	0	2025-11-05 00:59:51.557937	5	1	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
44	2025-11-05 01:03:22.568213	2025-11-05 01:03:44.332207	20	1	21	2025-11-05 01:03:44.311908	10	2025-11-05 01:03:22.568214	5	1	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
45	2025-11-05 17:20:14.404657	2025-11-05 17:21:58.431332	60	3	103	2025-11-05 17:21:58.383446	30	2025-11-05 17:20:14.402949	5	1	\N	146576d3-82a3-4196-84a7-87bb8884c98e
46	2025-11-05 17:55:21.702554	2025-11-05 17:56:01.473336	0	0	39	2025-11-05 17:56:01.407187	0	2025-11-05 17:55:21.687862	5	1	\N	146576d3-82a3-4196-84a7-87bb8884c98e
47	2025-11-05 17:58:34.051213	2025-11-05 17:58:54.987306	20	1	20	2025-11-05 17:58:54.951271	10	2025-11-05 17:58:34.050592	5	1	\N	c4d17be2-52a3-4827-a3f3-a3c795576ebf
\.


--
-- Data for Name: games; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.games (id, created_at, updated_at, description, name, rules_json) FROM stdin;
1	2025-10-10 19:37:01.371639	2025-10-10 19:37:01.372654	Trắc nghiệm phản xạ nhanh - True/False Lightning: Trả lời đúng/sai trong 3 giây	Quick Reflex Quiz	{\n  "type": "true_false",\n  "timePerQuestion": 3,\n  "totalQuestions": 10,\n  "scoring": {\n    "basePoints": 10,\n    "streakBonus": 5,\n    "speedBonus": 5\n  }\n}
2	2025-10-10 19:37:01.396609	2025-10-10 19:37:01.396609	Ghép thẻ hình ảnh với từ vựng - Tìm hình ảnh phù hợp với từ tiếng Anh	Image-Word Matching	{\n  "type": "image_matching",\n  "options": 4\n}
3	2025-10-10 19:37:01.399729	2025-10-10 19:37:01.399729	Ghép thẻ từ vựng với nghĩa - Tìm nghĩa đúng cho từ tiếng Anh	Word-Definition Matching	{\n  "type": "definition_matching",\n  "options": 4\n}
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, created_at, updated_at, content, is_read, title, type, user_id) FROM stdin;
\.


--
-- Data for Name: packages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.packages (id, created_at, updated_at, name, version, topic_id) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, created_at, updated_at, description, name) FROM stdin;
1	2025-10-03 15:35:03.575211	2025-10-03 15:35:03.575211	Quản trị hệ thống	ROLE_ADMIN
2	2025-10-03 15:35:03.607739	2025-10-03 15:35:03.607739	Người dùng	ROLE_USER
\.


--
-- Data for Name: tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tokens (id, created_at, updated_at, expired, refresh_token, revoked, token, user_id) FROM stdin;
cc581a53-3009-4740-8094-8b6cc69c8b24	2025-10-03 15:39:27.662	2025-10-03 15:45:29.407324	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6InRodWFubWluaC5kZXZAZ21haWwuY29tIiwiaWF0IjoxNzU5NDgwNzY3LCJleHAiOjE3NjAwODU1Njd9.g6l2_d1LGWBHYyfZTmqRFgdRDD0Zotd6lAk-v4YQNFM	t	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiI3YjlhMjEwZi1iMWMyLTQ0Y2YtOGZjNi03M2E3Y2U1NGJhZWEiLCJuYW1lIjoiTmd1eeG7hW4gVsSDbiBCIiwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0VSIl0sImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoidGh1YW5taW5oLmRldkBnbWFpbC5jb20iLCJpYXQiOjE3NTk0ODA3NjcsImV4cCI6MTc1OTU2NzE2N30.FFpoJChTCLvx69rYNn47s36AsGF8P5VNbL9ZHOGaNeE	7b9a210f-b1c2-44cf-8fc6-73a7ce54baea
06a97877-5b35-48d8-81a0-bfd365511020	2025-10-03 18:46:30.316829	2025-10-03 18:46:30.316829	f	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6InRodWFubWluaC5kZXZAZ21haWwuY29tIiwiaWF0IjoxNzU5NDkxOTkwLCJleHAiOjE3NjAwOTY3OTB9.xIgzDvfTL5A9q1YMc3SjRQ13lCXO6peAT7KAWbhwi8M	f	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiTmfDtCBNaW5oIFRodeG6rW4iLCJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwidXNlcklkIjoiN2I5YTIxMGYtYjFjMi00NGNmLThmYzYtNzNhN2NlNTRiYWVhIiwiaXNzIjoiY2FyZC13b3Jkcy5jb20iLCJzdWIiOiJ0aHVhbm1pbmguZGV2QGdtYWlsLmNvbSIsImlhdCI6MTc1OTQ5MTk5MCwiZXhwIjoxNzU5NTc4MzkwfQ.mHlvM76jsxvFC9KSgjUISbWsVOWjHUkUsVMGi23PHiY	7b9a210f-b1c2-44cf-8fc6-73a7ce54baea
01e75c45-05ce-4356-8ee5-c7a9c54ae1d5	2025-10-03 15:45:29.39623	2025-10-03 18:46:30.317823	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6InRodWFubWluaC5kZXZAZ21haWwuY29tIiwiaWF0IjoxNzU5NDgxMTI5LCJleHAiOjE3NjAwODU5Mjl9.ukBFM72UjiM0KZ-DALlRC76_dbhO_ccmUcMlL-iz6tE	t	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiTmd1eeG7hW4gVsSDbiBCIiwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0VSIl0sInVzZXJJZCI6IjdiOWEyMTBmLWIxYzItNDRjZi04ZmM2LTczYTdjZTU0YmFlYSIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoidGh1YW5taW5oLmRldkBnbWFpbC5jb20iLCJpYXQiOjE3NTk0ODExMjksImV4cCI6MTc1OTU2NzUyOX0.R9dIyJUoFLe0b4rTg2qRYR3MlO4xKkfrZ7r9Gs-QPzE	7b9a210f-b1c2-44cf-8fc6-73a7ce54baea
da26580c-8734-47f5-9582-4f85948ed646	2025-10-03 21:59:39.11643	2025-10-03 22:04:12.887105	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzU5NTAzNTc5LCJleHAiOjE3NjAxMDgzNzl9.Oee4Smxf1e-FxU2B1KW7SiXL41BcNy5d2XgXm9Fc67o	t	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwidXNlcklkIjoiYzRkMTdiZTItNTJhMy00ODI3LWEzZjMtYTNjNzk1NTc2ZWJmIiwibmFtZSI6Ik5ndXnhu4VuIFbEg24gQyIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiY2FyZHdvcmRzZ2FtZUBnbWFpbC5jb20iLCJpYXQiOjE3NTk1MDM1NzksImV4cCI6MTc1OTU4OTk3OX0.3lrXbzW9mJJVE4YgEBvQ2yUGlc3wap5oJGGr9lHaLtc	c4d17be2-52a3-4827-a3f3-a3c795576ebf
5f1c848e-697e-43c4-80e2-1de4cdfbb5cb	2025-10-03 22:04:27.733801	2025-10-09 17:35:14.335804	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzU5NTAzODY3LCJleHAiOjE3NjAxMDg2Njd9.eGrpMNdYpHNEt8L6blnuEU3wrz661ZAxKnirzm8J4jg	t	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwidXNlcklkIjoiYzRkMTdiZTItNTJhMy00ODI3LWEzZjMtYTNjNzk1NTc2ZWJmIiwibmFtZSI6Ik5ndXnhu4VuIFbEg24gQyIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiY2FyZHdvcmRzZ2FtZUBnbWFpbC5jb20iLCJpYXQiOjE3NTk1MDM4NjcsImV4cCI6MTc1OTU5MDI2N30.9yQ19e7vP2sVjFhzcRAb_LIDC4aD1D6axnHR21fIZPU	c4d17be2-52a3-4827-a3f3-a3c795576ebf
6f8ba76a-7dd4-4757-a6e0-87a3effb3c7e	2025-10-09 17:35:14.32637	2025-10-09 18:10:14.868009	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYwMDA2MTE0LCJleHAiOjE3NjA2MTA5MTR9.Wo5hxlzna0bdrCbhhfaGiiQwu4ZaGUC3KhHaJp4TtUU	t	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiTmd1eeG7hW4gVsSDbiBDIiwidXNlcklkIjoiYzRkMTdiZTItNTJhMy00ODI3LWEzZjMtYTNjNzk1NTc2ZWJmIiwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0VSIl0sImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiY2FyZHdvcmRzZ2FtZUBnbWFpbC5jb20iLCJpYXQiOjE3NjAwMDYxMTQsImV4cCI6MTc2MDA5MjUxNH0.KhLmsmktnwrO6DMFFBZzTmf65SYSSpKezmAs6i0gvIM	c4d17be2-52a3-4827-a3f3-a3c795576ebf
1fb82da7-65fb-4eec-a218-b829be178b59	2025-10-09 18:10:14.866005	2025-10-09 18:32:32.368642	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYwMDA4MjE0LCJleHAiOjE3NjA2MTMwMTR9.DeIu1VxkqN9Z8u8t7tDgJs4U_ZUqUQAYxlDvggT0-G8	t	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJjNGQxN2JlMi01MmEzLTQ4MjctYTNmMy1hM2M3OTU1NzZlYmYiLCJuYW1lIjoiTmd1eeG7hW4gVsSDbiBDIiwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0VSIl0sImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiY2FyZHdvcmRzZ2FtZUBnbWFpbC5jb20iLCJpYXQiOjE3NjAwMDgyMTQsImV4cCI6MTc2MDA5NDYxNH0.wUpLt6TuauqwN9S6U7RGxpIEy1LRlqsu3pZqwhHPcPo	c4d17be2-52a3-4827-a3f3-a3c795576ebf
4aab5bf1-36ea-4e6c-a700-8c3e43e87fba	2025-10-09 18:32:32.360574	2025-10-10 07:33:58.32464	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYwMDA5NTUyLCJleHAiOjE3NjA2MTQzNTJ9.eYrAqdrMzq2q4G5u4WOMxgcxNylm__CbBm_BJNferlo	t	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJjNGQxN2JlMi01MmEzLTQ4MjctYTNmMy1hM2M3OTU1NzZlYmYiLCJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwibmFtZSI6Ik5ndXnhu4VuIFbEg24gQyIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiY2FyZHdvcmRzZ2FtZUBnbWFpbC5jb20iLCJpYXQiOjE3NjAwMDk1NTIsImV4cCI6MTc2MDA5NTk1Mn0.4ls_RanOxLrVljVGC6AJu5YLY7VwCZF6RQouZzjufGE	c4d17be2-52a3-4827-a3f3-a3c795576ebf
5e046608-26fa-4d3a-9911-462c64f0e649	2025-10-10 07:33:58.314883	2025-10-11 12:48:58.724209	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYwMDU2NDM4LCJleHAiOjE3NjA2NjEyMzh9.c_W8OBxuLl3L6Tj4sFCPUQpIg3wakvQ2IGCmb8u2LX4	t	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiTmd1eeG7hW4gVsSDbiBDIiwidXNlcklkIjoiYzRkMTdiZTItNTJhMy00ODI3LWEzZjMtYTNjNzk1NTc2ZWJmIiwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0VSIl0sImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiY2FyZHdvcmRzZ2FtZUBnbWFpbC5jb20iLCJpYXQiOjE3NjAwNTY0MzgsImV4cCI6MTc2MDE0MjgzOH0.SOJxO_EsuE553Y-5wQ_HHzqyJSe-ZdTBTEjx7T3JZeM	c4d17be2-52a3-4827-a3f3-a3c795576ebf
2a2cea09-8bc6-4170-88df-7c1e932d951b	2025-10-11 12:48:58.712918	2025-10-13 17:48:06.514399	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYwMTYxNzM4LCJleHAiOjE3NjA3NjY1Mzh9.stuTeMZnyLtrtgCqSL24yATC0fc82FtABQuuy9IVle8	t	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJjNGQxN2JlMi01MmEzLTQ4MjctYTNmMy1hM2M3OTU1NzZlYmYiLCJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwibmFtZSI6Ik5ndXnhu4VuIFbEg24gQyIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiY2FyZHdvcmRzZ2FtZUBnbWFpbC5jb20iLCJpYXQiOjE3NjAxNjE3MzgsImV4cCI6MTc2MDI0ODEzOH0.I-y3So65zHslVoS43aTwkcVluKimob9fTXisxki7_M0	c4d17be2-52a3-4827-a3f3-a3c795576ebf
b9d3519b-0f60-408b-b07b-bc5dd03b9f3e	2025-10-13 17:48:06.503618	2025-10-16 23:30:24.69536	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYwMzUyNDg2LCJleHAiOjE3NjA5NTcyODZ9.1TSc0Zj1A3PVE2cN_gU_a2f1ZXRSX3RGdPP9BD5zKrU	t	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJjNGQxN2JlMi01MmEzLTQ4MjctYTNmMy1hM2M3OTU1NzZlYmYiLCJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwibmFtZSI6Ik5ndXnhu4VuIFbEg24gQyIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiY2FyZHdvcmRzZ2FtZUBnbWFpbC5jb20iLCJpYXQiOjE3NjAzNTI0ODYsImV4cCI6MTc2MDQzODg4Nn0.nflzNS6sWxZHPn1S4KMicWCLCGPJ5K3_rriLOjVBjjg	c4d17be2-52a3-4827-a3f3-a3c795576ebf
fa3621ef-bfe3-4424-9f90-6509ad2822c1	2025-10-17 10:50:15.323652	2025-10-18 11:01:50.875533	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYwNjczMDE1LCJleHAiOjE3NjEyNzc4MTV9.jqsLXqQYw-qVbn-11uhyBKlp2WaOMmIG6gUsxRkkCiY	t	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJjNGQxN2JlMi01MmEzLTQ4MjctYTNmMy1hM2M3OTU1NzZlYmYiLCJuYW1lIjoiTmd1eeG7hW4gVsSDbiBDIiwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0VSIl0sImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiY2FyZHdvcmRzZ2FtZUBnbWFpbC5jb20iLCJpYXQiOjE3NjA2NzMwMTUsImV4cCI6MTc2MDc1OTQxNX0.pf9LFIslBN5F-KPstgHvp6Z_hkZn_zzG_pdUscdgLRk	c4d17be2-52a3-4827-a3f3-a3c795576ebf
b526f564-7d5a-4e75-943d-cff41b45623a	2025-10-16 23:30:24.682982	2025-10-17 10:50:15.342263	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYwNjMyMjI0LCJleHAiOjE3NjEyMzcwMjR9.ZM_tU8l-fkcrmfsyvs_R136gHxnjszVbnkirGLHFJK4	t	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwidXNlcklkIjoiYzRkMTdiZTItNTJhMy00ODI3LWEzZjMtYTNjNzk1NTc2ZWJmIiwibmFtZSI6Ik5ndXnhu4VuIFbEg24gQyIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiY2FyZHdvcmRzZ2FtZUBnbWFpbC5jb20iLCJpYXQiOjE3NjA2MzIyMjQsImV4cCI6MTc2MDcxODYyNH0.n6Ht1369DIKLU_oc8lP-Zm4rl_H8Px_l0VQSVGBSVIE	c4d17be2-52a3-4827-a3f3-a3c795576ebf
99052fd3-3dfc-49cb-980b-34af3e3e401b	2025-10-18 11:01:50.865531	2025-10-18 20:15:53.889484	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYwNzYwMTEwLCJleHAiOjE3NjEzNjQ5MTB9.tO5ZM0zIq0BCbjLQ85MMeb39ebkW3v83TRFmZQI5RNI	t	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJjNGQxN2JlMi01MmEzLTQ4MjctYTNmMy1hM2M3OTU1NzZlYmYiLCJuYW1lIjoiTmd1eeG7hW4gVsSDbiBDIiwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0VSIl0sImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiY2FyZHdvcmRzZ2FtZUBnbWFpbC5jb20iLCJpYXQiOjE3NjA3NjAxMTAsImV4cCI6MTc2MDg0NjUxMH0.MihyUwgZbG8egfB0XjB3VT-6vNNVdgwZ6_LpSz9LwpI	c4d17be2-52a3-4827-a3f3-a3c795576ebf
96077ccf-2391-44a2-b237-8d80962f2c25	2025-10-18 20:15:53.878262	2025-10-22 20:01:43.859634	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYwNzkzMzUzLCJleHAiOjE3NjEzOTgxNTN9.t3dKlwakcAsJP6zRR2fD3i2Fx879emvRLN12b2LaggI	t	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiTmd1eeG7hW4gVsSDbiBDIiwidXNlcklkIjoiYzRkMTdiZTItNTJhMy00ODI3LWEzZjMtYTNjNzk1NTc2ZWJmIiwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0VSIl0sImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiY2FyZHdvcmRzZ2FtZUBnbWFpbC5jb20iLCJpYXQiOjE3NjA3OTMzNTMsImV4cCI6MTc2MDg3OTc1M30.BgUALv9irQ3xoULd5DZrPH--d-USpG381N0FS76OQ5o	c4d17be2-52a3-4827-a3f3-a3c795576ebf
71b91b4a-8707-4bd0-bcde-a76432db6595	2025-10-22 20:01:43.847113	2025-10-23 23:41:44.450334	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYxMTM4MTAzLCJleHAiOjE3NjE3NDI5MDN9.JVUjzi0qvE1p-I8fHD-_cUXqJrshARGXECoRw6yCLiI	t	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiTmd1eeG7hW4gVsSDbiBDIiwidXNlcklkIjoiYzRkMTdiZTItNTJhMy00ODI3LWEzZjMtYTNjNzk1NTc2ZWJmIiwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0VSIl0sImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiY2FyZHdvcmRzZ2FtZUBnbWFpbC5jb20iLCJpYXQiOjE3NjExMzgxMDMsImV4cCI6MTc2MTIyNDUwM30.zJwMv6m9KkI2HSMLywg63YM5Bc1orXce0G7lNmHeIrY	c4d17be2-52a3-4827-a3f3-a3c795576ebf
e758f191-3a9b-4e95-8508-4079f4cf6359	2025-10-23 23:41:44.442855	2025-10-24 12:36:08.934337	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYxMjM3NzA0LCJleHAiOjE3NjE4NDI1MDR9.53WzxSMtnUBEHY-s0UD3Ncbo5aSe1eaOtqd3GilFbDM	t	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwidXNlcklkIjoiYzRkMTdiZTItNTJhMy00ODI3LWEzZjMtYTNjNzk1NTc2ZWJmIiwibmFtZSI6Ik5ndXnhu4VuIFbEg24gQyIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiY2FyZHdvcmRzZ2FtZUBnbWFpbC5jb20iLCJpYXQiOjE3NjEyMzc3MDQsImV4cCI6MTc2MTMyNDEwNH0.6gN0h7P3eMoA0L7-Z7ZH-FyW7fhuRVs_rcV8bW2Zlg0	c4d17be2-52a3-4827-a3f3-a3c795576ebf
04177434-702f-4c1d-926c-930baa6c9021	2025-10-24 13:17:46.739193	2025-10-24 13:17:46.739193	f	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6Im10aHVhbnR0c2hvcDNAZ21haWwuY29tIiwiaWF0IjoxNzYxMjg2NjY2LCJleHAiOjE3NjE4OTE0NjZ9.L8jUaNqwtzL-z-26rEAK5S0kAInuRlUjLoA-xALoZ7A	f	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwibmFtZSI6Ik5ndXnhu4VuIFbEg24gQyIsInVzZXJJZCI6ImJjZGFhNTBjLWIzNmEtNGFhYS04N2VmLWNlYWY2NjFkOTc0ZSIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoibXRodWFudHRzaG9wM0BnbWFpbC5jb20iLCJpYXQiOjE3NjEyODY2NjYsImV4cCI6MTc2MTM3MzA2Nn0.T0f66abLMWYKXD27W1hNu_OlZQqHtlmEE9J3nkfGIBM	bcdaa50c-b36a-4aaa-87ef-ceaf661d974e
831a9b1f-67d8-4c8d-87cf-246e6b792c55	2025-10-24 12:36:08.922934	2025-10-24 20:04:13.537132	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYxMjg0MTY4LCJleHAiOjE3NjE4ODg5Njh9.5dOvx5fEdok5VR_qQab7dybw7lkm-DddSiNcypRXbGc	t	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJjNGQxN2JlMi01MmEzLTQ4MjctYTNmMy1hM2M3OTU1NzZlYmYiLCJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwibmFtZSI6Ik5ndXnhu4VuIFbEg24gQyIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiY2FyZHdvcmRzZ2FtZUBnbWFpbC5jb20iLCJpYXQiOjE3NjEyODQxNjgsImV4cCI6MTc2MTM3MDU2OH0.lBPrlxhK6G4FwdnLQgs0cVzjOoxfbGNqTliTtYcJsGA	c4d17be2-52a3-4827-a3f3-a3c795576ebf
4a55514e-dea3-4cd8-af07-db862a568184	2025-10-24 20:04:13.521817	2025-10-24 20:06:00.217627	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYxMzExMDUzLCJleHAiOjE3NjE5MTU4NTN9.DEJGTvt5vFKfwJnslFkS0Hr5tGHdIu_4ah9jkNEOFjA	t	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwidXNlcklkIjoiYzRkMTdiZTItNTJhMy00ODI3LWEzZjMtYTNjNzk1NTc2ZWJmIiwibmFtZSI6Ik5nw7QgTWluaCBUaHXhuq1uIDEiLCJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYxMzExMDUzLCJleHAiOjE3NjEzOTc0NTN9.oASkGMRp4CAL9t76UaWzzkE42ewDzkMUBv9MREIMAw4	c4d17be2-52a3-4827-a3f3-a3c795576ebf
2d54b2d3-922f-49be-8405-2ba7b56f13c2	2025-10-24 20:06:00.216015	2025-10-28 21:57:13.362228	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYxMzExMTYwLCJleHAiOjE3NjE5MTU5NjB9.uMh4MIqhQTF-TSLGJ40iPN0qrykMyOqbBPXhxws3nfg	t	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwidXNlcklkIjoiYzRkMTdiZTItNTJhMy00ODI3LWEzZjMtYTNjNzk1NTc2ZWJmIiwibmFtZSI6Ik5nw7QgTWluaCBUaHXhuq1uIDEiLCJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYxMzExMTYwLCJleHAiOjE3NjEzOTc1NjB9.f8YBNQWm_fmL6o5_-OcyN-oSZ8kfhycYLazHQyhWI6k	c4d17be2-52a3-4827-a3f3-a3c795576ebf
247439ad-da06-48df-8a19-8b8607d3a11b	2025-10-28 21:57:13.349461	2025-10-31 20:03:06.509503	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYxNjYzNDMzLCJleHAiOjE3NjIyNjgyMzN9.O9Jj02YpBy0kVIeMhz80UrlGKOuNdp5qzl1u4ZSqjoI	t	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwidXNlcklkIjoiYzRkMTdiZTItNTJhMy00ODI3LWEzZjMtYTNjNzk1NTc2ZWJmIiwibmFtZSI6Ik5nw7QgTWluaCBUaHXhuq1uIDEiLCJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYxNjYzNDMzLCJleHAiOjE3NjE3NDk4MzN9.WU4YQZ6BnnG6zYAR8U5FazRF2PszYUG0mtmcMkbgxgQ	c4d17be2-52a3-4827-a3f3-a3c795576ebf
11f49bf7-e092-438d-b94d-9e86c5b0d7b9	2025-11-01 12:40:04.404516	2025-11-01 12:40:07.789064	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYxOTc1NjA0LCJleHAiOjE3NjI1ODA0MDR9.4c7NwfOPobzO6twgUYpxqvW7NcWHEBg_7ydnBJIhSk4	t	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiTmfDtCBNaW5oIFRodeG6rW4gMSIsInVzZXJJZCI6ImM0ZDE3YmUyLTUyYTMtNDgyNy1hM2YzLWEzYzc5NTU3NmViZiIsImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYxOTc1NjA0LCJleHAiOjE3NjIwNjIwMDR9.qlcxxgkvhramxe5irbqbB8O1HzYlboUmleLEbKP_op0	c4d17be2-52a3-4827-a3f3-a3c795576ebf
117954ac-97fc-4255-b195-cc69531bf648	2025-10-31 20:03:06.493466	2025-11-01 12:40:04.415744	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYxOTE1Nzg2LCJleHAiOjE3NjI1MjA1ODZ9.mB3CCBPRI2GQlHINDkWmPRYjfgxgWAEeeEiN15yHHtc	t	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwidXNlcklkIjoiYzRkMTdiZTItNTJhMy00ODI3LWEzZjMtYTNjNzk1NTc2ZWJmIiwibmFtZSI6Ik5nw7QgTWluaCBUaHXhuq1uIDEiLCJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYxOTE1Nzg2LCJleHAiOjE3NjIwMDIxODZ9.rE0Iua12rz_qt6zLJD5hkU_Qzj3rxpTAmZP2WOeXXkw	c4d17be2-52a3-4827-a3f3-a3c795576ebf
94201680-e2b4-4ed7-b3de-072bba53583d	2025-11-01 12:40:07.788063	2025-11-02 01:18:47.065986	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYxOTc1NjA3LCJleHAiOjE3NjI1ODA0MDd9.Vg_5aCWgoL_O19vWFr71Zga3VkPgW_asKdYGOa1evSM	t	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiTmfDtCBNaW5oIFRodeG6rW4gMSIsInVzZXJJZCI6ImM0ZDE3YmUyLTUyYTMtNDgyNy1hM2YzLWEzYzc5NTU3NmViZiIsImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYxOTc1NjA3LCJleHAiOjE3NjIwNjIwMDd9.enQfRv5DX0e7_rgbm7Lstw90Km1yEco296HECOd-ckU	c4d17be2-52a3-4827-a3f3-a3c795576ebf
16850220-64c5-420e-acc8-6dc2c4129905	2025-11-02 01:18:47.052754	2025-11-03 02:19:47.169858	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMDIxMTI3LCJleHAiOjE3NjI2MjU5Mjd9.mVlKP6OMVja4CME4grtLCU_hzH1khxXhyw4HihYDp7w	t	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiTmfDtCBNaW5oIFRodeG6rW4gMSIsInVzZXJJZCI6ImM0ZDE3YmUyLTUyYTMtNDgyNy1hM2YzLWEzYzc5NTU3NmViZiIsImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMDIxMTI2LCJleHAiOjE3NjIxMDc1MjZ9.SA7T6XHjTX6Zlx6IRxzipvRuZbiDngE2YBi22Uo7XEs	c4d17be2-52a3-4827-a3f3-a3c795576ebf
081f812f-3f99-493d-8665-2ea24941f805	2025-11-03 02:19:47.156361	2025-11-04 19:33:22.870726	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMTExMTg3LCJleHAiOjE3NjI3MTU5ODd9.sfgTuQ4mfde-HwmVEgyVbZ6Ixm4TnLXXMUTfyy2foHY	t	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwidXNlcklkIjoiYzRkMTdiZTItNTJhMy00ODI3LWEzZjMtYTNjNzk1NTc2ZWJmIiwibmFtZSI6Ik5nw7QgTWluaCBUaHXhuq1uIDEiLCJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMTExMTg3LCJleHAiOjE3NjIxOTc1ODd9.Ecer0twFcq5YEkaqkv8Tzf-k2XO-3XIbXzytcRFgBWY	c4d17be2-52a3-4827-a3f3-a3c795576ebf
b9ec01e1-b839-4b91-8083-84c04821ae9f	2025-11-04 19:33:22.854457	2025-11-04 19:43:07.569038	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMjU5NjAyLCJleHAiOjE3NjI4NjQ0MDJ9.1DYgBI2bt_czBVa1A_52bGPXARpu89wtMqAFgH4eLpY	t	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwidXNlcklkIjoiYzRkMTdiZTItNTJhMy00ODI3LWEzZjMtYTNjNzk1NTc2ZWJmIiwibmFtZSI6Ik5nw7QgTWluaCBUaHXhuq1uIDEiLCJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMjU5NjAyLCJleHAiOjE3NjIzNDYwMDJ9._lh3R9fdivUrb7AHpcN98OtXKygKyauwEWNLNSZLSpQ	c4d17be2-52a3-4827-a3f3-a3c795576ebf
53b55df6-2ffc-4b6c-a98e-41821c064f2b	2025-11-04 19:43:07.556847	2025-11-04 20:00:29.049147	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMjYwMTg3LCJleHAiOjE3NjI4NjQ5ODd9.tgcIv6f7KzIHgrKMeXBZHlpctWDBJ6WPRJz4mINEicc	t	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwidXNlcklkIjoiYzRkMTdiZTItNTJhMy00ODI3LWEzZjMtYTNjNzk1NTc2ZWJmIiwibmFtZSI6Ik5nw7QgTWluaCBUaHXhuq1uIDEiLCJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMjYwMTg3LCJleHAiOjE3NjIzNDY1ODd9.0Tq1ZdBru5wF5mR1tChs42SRDoiEFZv5pqnRaRL53bg	c4d17be2-52a3-4827-a3f3-a3c795576ebf
dfbca439-4c52-448a-b344-b3bcab64627e	2025-11-04 20:00:29.038973	2025-11-04 20:10:27.681283	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMjYxMjI5LCJleHAiOjE3NjI4NjYwMjl9.ycoaS8-JAuM0c4duKZ5wWDjzx5KH6vFSJtvCZgCg9Ss	t	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJjNGQxN2JlMi01MmEzLTQ4MjctYTNmMy1hM2M3OTU1NzZlYmYiLCJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwibmFtZSI6Ik5nw7QgTWluaCBUaHXhuq1uIDEiLCJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMjYxMjI4LCJleHAiOjE3NjIzNDc2Mjh9.dnDJoEP_H2jS7aORlEqfjT4i2XD3hJnb_b9v_iI2M0g	c4d17be2-52a3-4827-a3f3-a3c795576ebf
53d022f3-adbf-4ac0-a323-1a636bb521b9	2025-11-04 20:10:27.67247	2025-11-04 20:28:33.590389	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMjYxODI3LCJleHAiOjE3NjI4NjY2Mjd9.c1pV3l53W374ZjMzDUlPUE6YG3fmLoYd6mPapLCq2Dc	t	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiTmfDtCBNaW5oIFRodeG6rW4gMSIsInVzZXJJZCI6ImM0ZDE3YmUyLTUyYTMtNDgyNy1hM2YzLWEzYzc5NTU3NmViZiIsImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMjYxODI3LCJleHAiOjE3NjIzNDgyMjd9.u2pATu7Jcml04gBdoWcGjo8GQUcwVzsT1hXMlzNSNQ8	c4d17be2-52a3-4827-a3f3-a3c795576ebf
dfecc65a-239f-4858-87ba-e0ae481b95a5	2025-11-04 20:28:33.578919	2025-11-04 20:40:13.960871	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMjYyOTEzLCJleHAiOjE3NjI4Njc3MTN9.Hb53BaWFrIcZuFC6X5Egkkv2yoLuKghRt1aiefeT16U	t	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiTmfDtCBNaW5oIFRodeG6rW4gMSIsInVzZXJJZCI6ImM0ZDE3YmUyLTUyYTMtNDgyNy1hM2YzLWEzYzc5NTU3NmViZiIsImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMjYyOTEzLCJleHAiOjE3NjIzNDkzMTN9.YXSRMGZdtMwK9o49b-ifrC9I6gG1dSH8q0vwgsMMDz4	c4d17be2-52a3-4827-a3f3-a3c795576ebf
3452131a-dc9d-4bf0-bfa3-9e2b6be6ebd2	2025-11-04 20:40:13.959871	2025-11-05 00:20:53.805362	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMjYzNjEzLCJleHAiOjE3NjI4Njg0MTN9.0pnWaiJO1KYdBEA7oaRtRT4ohIFXntcRGekGtSU6mfQ	t	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiTmfDtCBNaW5oIFRodeG6rW4gMSIsInVzZXJJZCI6ImM0ZDE3YmUyLTUyYTMtNDgyNy1hM2YzLWEzYzc5NTU3NmViZiIsImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMjYzNjEzLCJleHAiOjE3NjIzNTAwMTN9.o2E3md766ig2AipZbOSPHHFGOA0mNnqoPu3rzmTSA4g	c4d17be2-52a3-4827-a3f3-a3c795576ebf
29547db3-386f-4d82-94a2-ace5c6da0e30	2025-11-05 00:20:53.793118	2025-11-05 00:25:14.165486	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMjc2ODUzLCJleHAiOjE3NjI4ODE2NTN9.MAlIx3YJ-HuhDpKYs_XDfjaVIUj99Y-yxtBbZOv93xM	t	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwidXNlcklkIjoiYzRkMTdiZTItNTJhMy00ODI3LWEzZjMtYTNjNzk1NTc2ZWJmIiwibmFtZSI6Ik5nw7QgTWluaCBUaHXhuq1uIDEiLCJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMjc2ODUzLCJleHAiOjE3NjIzNjMyNTN9.9qWFOMU49fpfY_pyTUJ9fmiBmgEbKve_Ymyykok7bJg	c4d17be2-52a3-4827-a3f3-a3c795576ebf
2e9e7438-d80d-4509-8b50-201c2ecece00	2025-11-05 22:23:03.854705	2025-11-05 22:23:11.503727	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMzU2MTgzLCJleHAiOjE3NjI5NjA5ODN9.XdMgDVL2BqDQX-PZsw3plRYeVlP6IsX1x0OtPw6eWi4	t	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiTmfDtCBNaW5oIFRodeG6rW4gMSIsInVzZXJJZCI6ImM0ZDE3YmUyLTUyYTMtNDgyNy1hM2YzLWEzYzc5NTU3NmViZiIsImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMzU2MTgzLCJleHAiOjE3NjI0NDI1ODN9.PIPNgzheVhHBS8ZvcGZJsGc1m8BCjVjyuedal97EjsA	c4d17be2-52a3-4827-a3f3-a3c795576ebf
1b68d544-0e40-4382-ba48-c77920186dc1	2025-11-05 00:25:14.154655	2025-11-05 22:23:03.871184	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMjc3MTE0LCJleHAiOjE3NjI4ODE5MTR9.4JaIjjJdiviXHXquEv3cPtMK7z3uecvJ9jICizC37V8	t	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwibmFtZSI6Ik5nw7QgTWluaCBUaHXhuq1uIDEiLCJ1c2VySWQiOiJjNGQxN2JlMi01MmEzLTQ4MjctYTNmMy1hM2M3OTU1NzZlYmYiLCJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMjc3MTE0LCJleHAiOjE3NjIzNjM1MTR9.yJcP351XzrpbCrVksezV8pEi9VPTrEmv1Rti4FU3Rzw	c4d17be2-52a3-4827-a3f3-a3c795576ebf
a9f3c303-0705-4e3d-98f2-24268c9f9632	2025-11-05 22:23:11.502727	2025-11-05 17:14:06.11098	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMzU2MTkxLCJleHAiOjE3NjI5NjA5OTF9.ZIpt440pW02UafkgEK5dnhPY_33ZBXSkBy4yQ0imW34	t	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiTmfDtCBNaW5oIFRodeG6rW4gMSIsInVzZXJJZCI6ImM0ZDE3YmUyLTUyYTMtNDgyNy1hM2YzLWEzYzc5NTU3NmViZiIsImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMzU2MTkxLCJleHAiOjE3NjI0NDI1OTF9.ZKuHrL_ZWk1MJlE_lunzgXuMjTZd-B7bn5F1JNLxHMI	c4d17be2-52a3-4827-a3f3-a3c795576ebf
671664e1-651d-4df3-9e0c-3b69d2901cca	2025-10-24 14:20:50.010874	2025-11-05 17:12:47.894757	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImFkbWluMUBjYXJkd29yZHMuY29tIiwiaWF0IjoxNzYxMjkwNDUwLCJleHAiOjE3NjE4OTUyNTB9.SLrXczE96JCBb7Cj1lnjgTrOx0QaXGBk2Otv_0FBa_E	t	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX0FETUlOIiwiUk9MRV9VU0VSIl0sIm5hbWUiOiJRdeG6o24gdHLhu4sgdmnDqm4gMSIsInVzZXJJZCI6IjE0NjU3NmQzLTgyYTMtNDE5Ni04NGE3LTg3YmI4ODg0Yzk4ZSIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiYWRtaW4xQGNhcmR3b3Jkcy5jb20iLCJpYXQiOjE3NjEyOTA0NTAsImV4cCI6MTc2MTM3Njg1MH0.y9WteDvD5j7hhqSzvG4INQ3wWsIYqrYOIeXvMvQxcMQ	146576d3-82a3-4196-84a7-87bb8884c98e
27bf7567-32cd-43a9-b58e-565284432729	2025-11-05 17:13:18.247982	2025-11-05 17:13:18.24801	f	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImFkbWluMUBjYXJkd29yZHMuY29tIiwiaWF0IjoxNzYyMzYyNzk4LCJleHAiOjE3NjI5Njc1OTh9.4G0ExcRLh8zs8Kdhq-kjLMwSFbsy6obgGm4E7KM2tbw	f	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX0FETUlOIiwiUk9MRV9VU0VSIl0sInVzZXJJZCI6IjE0NjU3NmQzLTgyYTMtNDE5Ni04NGE3LTg3YmI4ODg0Yzk4ZSIsIm5hbWUiOiJRdeG6o24gdHLhu4sgdmnDqm4gMSIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiYWRtaW4xQGNhcmR3b3Jkcy5jb20iLCJpYXQiOjE3NjIzNjI3OTgsImV4cCI6MTc2MjQ0OTE5OH0.2deyqPt-BiNcT-uGqVVWEdFbdMfGi0CR21JAsdtycUs	146576d3-82a3-4196-84a7-87bb8884c98e
43565941-4d0c-4898-bc47-46c450139577	2025-11-05 17:12:47.879308	2025-11-05 17:13:18.249321	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImFkbWluMUBjYXJkd29yZHMuY29tIiwiaWF0IjoxNzYyMzYyNzY3LCJleHAiOjE3NjI5Njc1Njd9.vRW4hpcAZCnExddA5p13whA8qOVKcF5TaShpjlHwBQU	t	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX0FETUlOIiwiUk9MRV9VU0VSIl0sInVzZXJJZCI6IjE0NjU3NmQzLTgyYTMtNDE5Ni04NGE3LTg3YmI4ODg0Yzk4ZSIsIm5hbWUiOiJRdeG6o24gdHLhu4sgdmnDqm4gMSIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiYWRtaW4xQGNhcmR3b3Jkcy5jb20iLCJpYXQiOjE3NjIzNjI3NjcsImV4cCI6MTc2MjQ0OTE2N30.osFwicnTCsb1mYaKW-_JQPrHdLpUbrYeoIgYm9fD-sY	146576d3-82a3-4196-84a7-87bb8884c98e
287402af-dfb1-466e-b12f-69479c7840aa	2025-11-05 17:58:01.807081	2025-11-05 17:58:01.807118	f	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMzY1NDgxLCJleHAiOjE3NjI5NzAyODF9.hNogav1sTQWha491eaptq1qjnzKQWv55OC2Xk61U2Dw	f	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwibmFtZSI6Ik5nw7QgTWluaCBUaHXhuq1uIDEiLCJ1c2VySWQiOiJjNGQxN2JlMi01MmEzLTQ4MjctYTNmMy1hM2M3OTU1NzZlYmYiLCJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMzY1NDgxLCJleHAiOjE3NjI0NTE4ODF9.yYyx7nToim71xSSVNypwD4BWoWNFykXyqUHh5sZ9MiU	c4d17be2-52a3-4827-a3f3-a3c795576ebf
c59edf07-566f-41d5-9fa3-fc027eb3552d	2025-11-05 17:16:57.249456	2025-11-05 17:58:01.811883	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMzYzMDE3LCJleHAiOjE3NjI5Njc4MTd9.mUwAF0Gm9osIwOS6HpMiv2mvoqqEFjP8t4L9DRVgkAE	t	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwidXNlcklkIjoiYzRkMTdiZTItNTJhMy00ODI3LWEzZjMtYTNjNzk1NTc2ZWJmIiwibmFtZSI6Ik5nw7QgTWluaCBUaHXhuq1uIDEiLCJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYyMzYzMDE3LCJleHAiOjE3NjI0NDk0MTd9.lC5Vssg8KEHedtQIL_2Q1SLqGln4cdwlweaQM3nb3oc	c4d17be2-52a3-4827-a3f3-a3c795576ebf
\.


--
-- Data for Name: topics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.topics (id, created_at, updated_at, description, name) FROM stdin;
1	2025-10-03 18:31:16.437841	2025-10-03 18:31:16.437841	cập đến tất cả các khía cạnh liên quan đến thực phẩm, từ miêu tả các loại món ăn, hương vị, nguyên liệu, đến thói quen ăn uống và tầm quan trọng của thực phẩm trong văn hóa và sức khỏe. Để mô tả chủ đề này, bạn cần sử dụng từ vựng về ẩm thực như cuisine (ẩm thực), appetizer (món khai vị), dessert (món tráng miệng), các tính từ miêu tả hương vị như delicious, spicy, sweet, và các cụm từ liên quan đến bữa ăn như home-cooked meal (bữa ăn tự nấu), street food (đồ ăn đường phố).	Food
2	2025-10-03 18:31:59.275152	2025-10-03 18:31:59.275152	mô tả các loại đồ uống, hương vị, thành phần, nhiệt độ và sử dụng các mẫu câu giao tiếp liên quan đến việc gọi đồ uống. Chủ đề này bao gồm các loại phổ biến như nước (water), nước trái cây (juice), cà phê (coffee), trà (tea), bia (beer), rượu vang (wine) và các món đặc biệt hơn như sinh tố (smoothie) hay trà sữa (bubble tea).	Drink
44	2025-10-10 18:49:48.009839	2025-10-10 18:49:48.009839	Auto-generated from bulk import	family
45	2025-10-10 18:49:48.01281	2025-10-10 18:49:48.01281	Auto-generated from bulk import	people
46	2025-10-10 18:49:48.047089	2025-10-10 18:49:48.047089	Auto-generated from bulk import	school
47	2025-10-10 18:49:48.050443	2025-10-10 18:49:48.050443	Auto-generated from bulk import	study
48	2025-10-10 18:49:48.084624	2025-10-10 18:49:48.084624	Auto-generated from bulk import	work
49	2025-10-10 18:49:48.085636	2025-10-10 18:49:48.085636	Auto-generated from bulk import	jobs
50	2025-10-10 18:49:48.120162	2025-10-10 18:49:48.120162	Auto-generated from bulk import	travel
51	2025-10-10 18:49:48.121187	2025-10-10 18:49:48.121187	Auto-generated from bulk import	transport
52	2025-10-10 18:49:48.154699	2025-10-10 18:49:48.154699	Auto-generated from bulk import	sports
53	2025-10-10 18:49:48.155718	2025-10-10 18:49:48.155718	Auto-generated from bulk import	health
54	2025-10-10 18:49:48.186482	2025-10-10 18:49:48.186482	Auto-generated from bulk import	animals
55	2025-10-10 18:49:48.212027	2025-10-10 18:49:48.212027	Auto-generated from bulk import	nature
56	2025-10-10 18:49:48.239159	2025-10-10 18:49:48.239159	Auto-generated from bulk import	daily life
57	2025-10-10 18:49:48.263998	2025-10-10 18:49:48.263998	Auto-generated from bulk import	places
58	2025-10-10 18:49:48.287134	2025-10-10 18:49:48.287134	Auto-generated from bulk import	technology
59	2025-10-10 18:49:48.312132	2025-10-10 18:49:48.312132	Auto-generated from bulk import	emotions
60	2025-10-10 18:49:48.336462	2025-10-10 18:49:48.336462	Auto-generated from bulk import	environment
61	2025-10-10 18:49:48.359274	2025-10-10 18:49:48.359274	Auto-generated from bulk import	culture
62	2025-10-10 18:49:48.385307	2025-10-10 18:49:48.385307	Auto-generated from bulk import	science
63	2025-10-10 18:49:48.410134	2025-10-10 18:49:48.410134	Auto-generated from bulk import	education advanced
64	2025-10-10 18:49:48.435376	2025-10-10 18:49:48.435376	Auto-generated from bulk import	law
65	2025-10-10 18:49:48.437107	2025-10-10 18:49:48.437107	Auto-generated from bulk import	politics
66	2025-10-10 18:49:48.468461	2025-10-10 18:49:48.468461	Auto-generated from bulk import	business
67	2025-10-10 18:49:48.495879	2025-10-10 18:49:48.495879	Auto-generated from bulk import	art
68	2025-10-10 18:49:48.497147	2025-10-10 18:49:48.497147	Auto-generated from bulk import	literature
69	2025-10-10 18:49:48.526507	2025-10-10 18:49:48.526507	Auto-generated from bulk import	social media
70	2025-10-10 18:49:48.527507	2025-10-10 18:49:48.527507	Auto-generated from bulk import	communication
71	2025-10-10 18:49:49.373026	2025-10-10 18:49:49.373026	Auto-generated from bulk import	events
72	2025-10-10 18:49:49.374682	2025-10-10 18:49:49.374682	Auto-generated from bulk import	celebrations
73	2025-10-10 18:49:49.39619	2025-10-10 18:49:49.39619	Auto-generated from bulk import	medicine
74	2025-10-10 18:49:49.427994	2025-10-10 18:49:49.427994	Auto-generated from bulk import	fashion
75	2025-10-10 18:49:49.430075	2025-10-10 18:49:49.430075	Auto-generated from bulk import	trends
76	2025-10-10 18:49:49.44677	2025-10-10 18:49:49.44677	Auto-generated from bulk import	https:
77	2025-10-10 18:49:49.44777	2025-10-10 18:49:49.44777	Auto-generated from bulk import	commons.wikimedia.org
78	2025-10-10 18:49:49.449282	2025-10-10 18:49:49.449282	Auto-generated from bulk import	w
79	2025-10-10 18:49:49.450445	2025-10-10 18:49:49.450445	Auto-generated from bulk import	index.php?search=pattern
80	2025-10-10 18:49:49.452847	2025-10-10 18:49:49.452847	Auto-generated from bulk import	title=special:mediasearch
81	2025-10-10 18:49:49.453851	2025-10-10 18:49:49.453851	Auto-generated from bulk import	go=go
82	2025-10-10 18:49:49.45485	2025-10-10 18:49:49.45485	Auto-generated from bulk import	type=image (creative commons results)
83	2025-10-10 18:49:49.487267	2025-10-10 18:49:49.487267	Auto-generated from bulk import	geography
84	2025-10-10 18:49:49.525743	2025-10-10 18:49:49.525743	Auto-generated from bulk import	hobbies
85	2025-10-10 18:49:49.526858	2025-10-10 18:49:49.526858	Auto-generated from bulk import	leisure
86	2025-10-10 18:49:49.567063	2025-10-10 18:49:49.567063	Auto-generated from bulk import	cooking
87	2025-10-10 18:49:49.602812	2025-10-10 18:49:49.602812	Auto-generated from bulk import	employment
88	2025-10-10 18:49:49.632848	2025-10-10 18:49:49.632848	Auto-generated from bulk import	management
89	2025-10-10 18:49:49.661486	2025-10-10 18:49:49.661486	Auto-generated from bulk import	society
90	2025-10-10 18:49:49.678433	2025-10-10 18:49:49.678433	Auto-generated from bulk import	media
91	2025-10-10 18:49:49.679439	2025-10-10 18:49:49.679439	Auto-generated from bulk import	advertising
92	2025-10-10 18:49:49.712635	2025-10-10 18:49:49.712635	Auto-generated from bulk import	community
93	2025-10-10 18:49:49.714634	2025-10-10 18:49:49.714634	Auto-generated from bulk import	volunteering
94	2025-10-10 18:49:49.76451	2025-10-10 18:49:49.76451	Auto-generated from bulk import	fitness
95	2025-10-10 18:49:49.810336	2025-10-10 18:49:49.810336	Auto-generated from bulk import	storytelling
96	2025-10-10 18:49:49.842314	2025-10-10 18:49:49.842314	Auto-generated from bulk import	publishing
97	2025-10-10 18:49:49.898186	2025-10-10 18:49:49.898186	Auto-generated from bulk import	broadcasting
98	2025-10-10 18:49:50.015548	2025-10-10 18:49:50.015548	Auto-generated from bulk import	architecture
99	2025-10-10 18:49:50.046811	2025-10-10 18:49:50.046811	Auto-generated from bulk import	space
100	2025-10-10 18:49:50.076624	2025-10-10 18:49:50.076624	Auto-generated from bulk import	biology
101	2025-10-10 18:49:50.10522	2025-10-10 18:49:50.10522	Auto-generated from bulk import	physics
102	2025-10-10 18:49:50.133205	2025-10-10 18:49:50.133205	Auto-generated from bulk import	chemistry
103	2025-10-10 18:49:50.189259	2025-10-10 18:49:50.189259	Auto-generated from bulk import	geology
104	2025-10-10 18:49:50.219001	2025-10-10 18:49:50.219001	Auto-generated from bulk import	astronomy
105	2025-10-10 18:49:50.227499	2025-10-10 18:49:50.227499	Auto-generated from bulk import	engineering
106	2025-10-10 18:49:50.256013	2025-10-10 18:49:50.256013	Auto-generated from bulk import	agriculture
107	2025-10-10 18:49:50.311202	2025-10-10 18:49:50.311202	Auto-generated from bulk import	psychology
108	2025-10-10 18:49:50.34806	2025-10-10 18:49:50.34806	Auto-generated from bulk import	education
109	2025-10-10 18:49:50.349059	2025-10-10 18:49:50.349059	Auto-generated from bulk import	learning
110	2025-10-10 18:49:50.356817	2025-10-10 18:49:50.356817	Auto-generated from bulk import	arts
111	2025-10-10 18:49:50.404477	2025-10-10 18:49:50.404477	Auto-generated from bulk import	creativity
112	2025-10-10 18:49:50.417886	2025-10-10 18:49:50.417886	Auto-generated from bulk import	music
113	2025-10-10 18:49:50.4199	2025-10-10 18:49:50.4199	Auto-generated from bulk import	performance
114	2025-10-10 18:49:50.45278	2025-10-10 18:49:50.45278	Auto-generated from bulk import	dance
115	2025-10-10 18:49:50.477057	2025-10-10 18:49:50.477057	Auto-generated from bulk import	film
116	2025-10-10 18:49:50.515071	2025-10-10 18:49:50.515071	Auto-generated from bulk import	photography
117	2025-10-10 18:49:50.557632	2025-10-10 18:49:50.557632	Auto-generated from bulk import	design
118	2025-10-10 18:49:50.57559	2025-10-10 18:49:50.57559	Auto-generated from bulk import	innovation
119	2025-10-10 18:49:50.604107	2025-10-10 18:49:50.604107	Auto-generated from bulk import	economy
\.


--
-- Data for Name: types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.types (id, created_at, updated_at, name) FROM stdin;
1	2025-10-03 18:24:42.049167	2025-10-03 18:24:42.049167	noun
2	2025-10-03 18:24:52.139004	2025-10-03 18:24:52.139004	pronoun
3	2025-10-03 18:24:59.700555	2025-10-03 18:24:59.700555	verb
4	2025-10-03 18:25:07.281723	2025-10-03 18:25:07.281723	adjective
5	2025-10-03 18:25:15.601077	2025-10-03 18:25:15.602077	adverb
6	2025-10-03 18:25:22.326199	2025-10-03 18:25:22.326199	preposition
7	2025-10-03 18:25:32.76633	2025-10-03 18:25:32.76633	conjunction
8	2025-10-03 18:25:40.329458	2025-10-03 18:25:40.329458	determiner
10	2025-10-03 18:27:04.125955	2025-10-03 18:27:04.125955	interjection
12	2025-10-10 18:49:49.44577	2025-10-10 18:49:49.44577	mẫu hoa văn
\.


--
-- Data for Name: user_game_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_game_settings (id, created_at, updated_at, game_name, image_word_total_pairs, quick_quiz_time_per_question, quick_quiz_total_questions, word_definition_total_pairs, user_id) FROM stdin;
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_roles (user_id, role_id) FROM stdin;
df8e1bbc-cb19-4885-b855-083c1fd9a7d9	2
7b9a210f-b1c2-44cf-8fc6-73a7ce54baea	2
519693aa-312c-48b5-963d-75f425fbf0a3	2
c4d17be2-52a3-4827-a3f3-a3c795576ebf	2
bcdaa50c-b36a-4aaa-87ef-ceaf661d974e	2
1e851484-dc74-4eb6-a856-1b39d3071492	2
146576d3-82a3-4196-84a7-87bb8884c98e	1
146576d3-82a3-4196-84a7-87bb8884c98e	2
5e8f735d-2fde-4e70-9831-eb398531fda8	1
5e8f735d-2fde-4e70-9831-eb398531fda8	2
\.


--
-- Data for Name: user_vocab_progress; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_vocab_progress (id, created_at, updated_at, ef_factor, interval_days, last_reviewed, next_review_date, repetition, status, times_correct, times_wrong, user_id, vocab_id) FROM stdin;
e899dcf9-923c-4038-bbe7-eaa335c3f188	2025-11-02 01:20:00.222439	2025-11-02 01:20:00.222439	2.5	1	\N	\N	0	\N	0	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	0f9b1333-caf2-47e2-9f5f-e10c0d19252e
12bf5d36-67e6-4c8b-9cb7-2bea65136592	2025-10-10 20:29:34.015906	2025-10-10 20:30:01.718442	2.5	1	\N	\N	0	\N	1	2	c4d17be2-52a3-4827-a3f3-a3c795576ebf	58b7563c-e5d6-4247-b3e7-af5b988f0fe1
3b6aeddb-41e9-42af-a942-3d478df1bf9c	2025-10-22 20:54:08.482746	2025-11-02 01:21:04.765392	2.5	1	\N	\N	0	\N	2	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	f58dc7ab-3f9e-4ffc-a470-ebf4b60a5ff6
fa47026c-092c-4d54-9d65-2a45d02bbc9c	2025-10-10 20:32:34.928582	2025-10-10 20:32:34.928582	2.5	1	\N	\N	1	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	2438686e-3383-4faf-9910-381bf478bf51
c15b9092-b811-4056-ba53-3e8e141981ce	2025-10-10 21:54:38.291952	2025-10-10 21:54:38.291952	2.5	1	\N	\N	1	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	88d2fae9-669e-4a72-9cb4-4d312e8da912
8a8d1420-cb42-4107-b8f7-3947c2f6db39	2025-10-10 21:55:19.250118	2025-10-10 21:55:19.250118	2.5	1	\N	\N	0	\N	0	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	ab34318d-5656-4705-b2cf-187a06375d27
048810ab-444d-4381-969c-ae77c4f9c390	2025-10-10 21:55:23.734067	2025-10-10 21:55:23.734067	2.5	1	\N	\N	1	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	87d4927c-4a8f-48d9-93e3-71e8a35e0770
e7fa7727-1296-42ed-992f-7e68f0828762	2025-11-02 01:21:04.767399	2025-11-02 01:21:04.767399	2.5	1	\N	\N	0	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	6abad213-f06c-43d5-953e-64ec4864f26d
694ee422-cf76-4b2a-929b-e30247f2705a	2025-10-10 21:55:28.826635	2025-10-11 12:49:59.528141	2.5	1	\N	\N	0	\N	1	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	c3d41e13-d185-40d8-83e8-9322dde44e2e
1715d875-165a-4e93-8b52-b88c3e757826	2025-10-11 12:50:05.802372	2025-10-11 12:50:05.802372	2.5	1	\N	\N	0	\N	0	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	89680f43-6a58-4b4f-8e1d-e3c87244472e
e7f1967b-22ee-40bc-a80b-bf75f0a88f56	2025-10-11 12:50:11.088304	2025-10-11 12:50:11.088304	2.5	1	\N	\N	1	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	5e53247f-dc44-425e-b70b-fce4cf245048
3108877e-ec97-489b-afeb-e1d0e8d08368	2025-10-10 20:31:32.812087	2025-10-11 12:50:16.514255	2.5	6	\N	\N	2	\N	2	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	1f4716d3-0144-486c-82aa-6495c04a6799
dbf003a3-c89e-403b-9064-0f81e8b69346	2025-10-17 19:29:05.784943	2025-10-17 19:29:05.784943	2.5	1	\N	\N	0	\N	0	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	72b8c5e2-6168-4927-b758-9c46cbb1a602
e33b36c2-804a-4b94-aa5e-56bededc8abd	2025-10-10 20:32:20.941696	2025-10-17 19:29:05.807267	2.5	1	\N	\N	0	\N	0	2	c4d17be2-52a3-4827-a3f3-a3c795576ebf	e59b1c30-7f29-4932-8d6a-06925d737687
2bb410c0-3f85-4353-92ed-e437547412c6	2025-10-10 20:32:08.679618	2025-10-17 19:35:27.726552	2.5	1	\N	\N	0	\N	1	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	e206b6cc-471c-4a64-a87c-df46ea12e232
93d01609-76a0-4e67-be69-7197fb9e91ed	2025-10-10 21:55:26.293979	2025-10-17 19:35:27.728554	2.5	1	\N	\N	1	\N	2	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	64edc678-01c8-4291-9fd0-efd330d6dead
36339e51-7178-439c-afc7-276f1ceb5858	2025-10-18 08:21:51.718211	2025-10-18 08:21:51.718211	2.5	1	\N	\N	0	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	c97b145b-085f-4f27-a01a-b0601bcd2e2c
bc41763b-6299-405e-878d-aa6356ec7b65	2025-10-18 08:21:51.745436	2025-10-18 08:21:51.745436	2.5	1	\N	\N	0	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	1095ba50-88c2-49c5-92f0-76064b90e0ca
1199de1b-e7fc-4d2d-913e-b5b823c3f746	2025-10-22 20:30:10.386248	2025-10-22 20:30:10.386248	2.5	1	\N	\N	0	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	e2510cb1-8178-42de-904b-5e2cdc3680b5
4250a250-3d6e-44e0-9c16-593dc0e0e26c	2025-10-22 20:30:10.393629	2025-10-22 20:30:10.393629	2.5	1	\N	\N	0	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	1e8ae068-1f58-455c-ac7a-c697a8188e43
3a988aeb-a02d-4cb2-8df7-ee48a3014a7f	2025-10-22 20:54:08.477736	2025-10-22 20:54:08.477736	2.5	1	\N	\N	0	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	841da8ef-9320-4f20-ac66-a7743299ae03
a3983fe9-d1c5-492c-83f1-8d54e8584b75	2025-10-22 20:54:08.485989	2025-10-22 20:54:08.485989	2.5	1	\N	\N	0	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	72a0ffd4-cd07-41bb-9bcb-bda6491d5846
4ef04827-67b0-4533-a302-9dfc00d4edee	2025-10-23 00:22:38.361987	2025-10-23 00:22:38.361987	2.5	1	\N	\N	0	\N	0	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	596c8b71-cfb5-4138-9a9f-c0ee6736e313
c724be5a-a23d-447b-941f-f43ad2f5394c	2025-10-23 00:22:49.096222	2025-10-23 00:22:49.096222	2.5	1	\N	\N	1	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	cdc8fb15-da7d-4399-91e8-f1198a3ddc23
a79bb624-acd1-46f7-8f8e-ebb9f4b7f0e2	2025-10-23 00:22:59.503388	2025-10-23 00:22:59.503388	2.5	1	\N	\N	1	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	cf0b9614-845c-4250-932c-7561eabc6d6f
9611bdff-1e79-40a7-8a2c-9be345fa37d2	2025-10-23 00:23:08.299922	2025-10-23 00:23:08.299922	2.5	1	\N	\N	1	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	67cec151-d0c1-443d-99fe-7f2b726f01b7
86015427-97a2-4b42-b2a1-dda6ac8a94de	2025-10-23 00:23:17.601121	2025-10-23 00:23:17.601121	2.5	1	\N	\N	0	\N	0	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	92e16207-f569-4b2b-931b-155bb1967da4
97e5fc52-f4ff-42d8-b8b1-05dff66b59d9	2025-10-23 00:59:50.719273	2025-10-23 00:59:50.719273	2.5	1	\N	\N	0	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	41bcd0ee-915b-46d3-90e9-c1285d1bceee
e036bac9-4e74-4c85-837a-a72e09d69011	2025-10-23 00:59:50.72418	2025-10-23 00:59:50.72418	2.5	1	\N	\N	0	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	d0b068e5-3c67-427d-b572-b50190b87f3a
8bcf3a77-041c-437f-9b4a-7309d595f09a	2025-10-23 00:59:50.737453	2025-10-23 00:59:50.737453	2.5	1	\N	\N	0	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	9f281d66-8f92-409d-ba4f-279ff217567e
2a420414-7b98-4d2b-b48f-95988c140386	2025-10-28 22:29:03.710162	2025-10-28 22:29:03.710162	2.5	1	\N	\N	1	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	c64e91ed-a4de-40f0-ae4d-4dba3a15eab3
3a916174-30e4-4459-8d10-75ad468b1a0c	2025-10-28 22:31:22.650215	2025-10-28 22:31:22.650215	2.5	1	\N	\N	0	\N	0	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	7850bc93-7891-4814-8917-57af1f272e90
896e94c2-4636-45a3-8709-8a25a45a9f05	2025-10-28 22:32:04.19304	2025-10-28 22:32:04.19304	2.5	1	\N	\N	1	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	b8adc413-e1ea-4cbc-bf3a-de5e54422c68
394fbe8a-2693-492f-86de-67bc7b8b66db	2025-10-28 22:32:07.642484	2025-10-28 22:32:07.642484	2.5	1	\N	\N	0	\N	0	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	5f237721-d474-496a-aaef-af413c73ab94
d652c0d7-d29e-4ff5-9dc4-aad72d4821c3	2025-10-28 22:32:11.103857	2025-10-28 22:32:11.103857	2.5	1	\N	\N	0	\N	0	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	6d4e0c8b-22b1-4078-bfbb-c42a47bdb1c2
df1cc633-218c-4601-bfb7-8d55fa5b7b27	2025-10-28 22:53:36.024931	2025-10-28 22:53:36.024931	2.5	1	\N	\N	1	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	a932b9d4-688b-4109-8d88-43fb61e78137
0e745b94-2803-4e13-936e-bd010e415d58	2025-11-02 01:19:37.728124	2025-11-02 01:19:37.728124	2.5	1	\N	\N	1	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	6ba28a5a-471e-4083-b91d-11b8d48461c9
61f34714-c32b-4113-a892-eda3cba13612	2025-11-02 01:19:47.293391	2025-11-02 01:19:47.293391	2.5	1	\N	\N	0	\N	0	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	d134cb8c-4e65-4b8a-9805-3baecd222021
a54f7edb-61ac-4051-bb95-13d09d8fa310	2025-11-02 01:19:51.236457	2025-11-02 01:19:51.236457	2.5	1	\N	\N	0	\N	0	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	6b3d66f1-95d4-4c80-89ab-c8626b42343c
c18a660a-516a-4271-a251-62fff434b4d6	2025-11-02 01:21:04.772925	2025-11-02 01:21:04.772925	2.5	1	\N	\N	0	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	7a26dcad-4d50-4b0c-8c53-a23166043658
6256bb9d-c871-4c4c-a8f8-a6bfcb5414b8	2025-11-02 01:21:32.654447	2025-11-02 01:21:32.654447	2.5	1	\N	\N	0	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	97fa16a3-6483-4a5f-99f1-2c0fdc612769
9567bed2-34fa-4f15-bf0d-fe704fa5bfd8	2025-11-02 01:21:32.659145	2025-11-02 01:21:32.659145	2.5	1	\N	\N	0	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	453d983a-41e1-4534-9d22-bec95353736f
f7939e08-9cb8-48eb-a3b1-b5aaa5d47016	2025-11-02 01:21:32.718118	2025-11-02 01:21:32.718118	2.5	1	\N	\N	0	\N	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	aee63a03-282c-4783-9659-7c4e58729e08
3954e71d-6953-49d8-a025-ed62f0c9d74e	2025-10-31 20:05:28.78989	2025-11-03 02:20:00.979794	1.8599999999999997	1	2025-11-03	2025-11-04	0	KNOWN	2	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	aacc96ba-8409-4130-8d1b-006405af356a
c15ec178-fd55-4374-a45b-93eadbd885b8	2025-11-04 19:35:31.028547	2025-11-04 19:35:31.028547	2.5	1	2025-11-04	2025-11-05	0	NEW	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	f60b50e1-ab40-4fa2-b4b0-015adfa3f792
20327136-9605-477b-92f5-cbf543320574	2025-10-22 20:30:10.391435	2025-11-04 19:35:31.040175	2.5	1	2025-11-04	2025-11-05	0	NEW	2	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	45ea8c80-2e55-4c0c-a429-1d96576fcadf
dbe92f99-e8ea-4489-aaf0-d71b4391763a	2025-11-04 19:35:31.070422	2025-11-04 19:35:31.070422	2.5	1	2025-11-04	2025-11-05	0	NEW	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	cad5490c-fb56-47d6-b305-0a405feac0a0
65386172-1fcf-47d8-9686-267b25a2cb07	2025-11-04 19:43:58.961288	2025-11-04 19:43:58.961288	2.5	1	2025-11-04	2025-11-05	0	NEW	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	48178cb1-c1e4-472a-900d-4bf164a752a5
ae7e9055-1141-4f6b-bc3a-c474b285d1f0	2025-11-04 19:43:58.991223	2025-11-04 19:43:58.992229	2.5	1	2025-11-04	2025-11-05	0	NEW	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	f9860988-56b5-4f41-90db-ca52b721c304
6d076a00-a27f-46c8-bd6b-b4854bcc2aa3	2025-11-04 21:05:58.013382	2025-11-04 21:05:58.013382	2.5	1	2025-11-04	2025-11-05	0	NEW	0	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	a81f2eb3-0178-4f9b-ac91-b2b8f97fc118
907f656b-dd48-4e36-a44a-cfa52e847ee0	2025-11-04 21:06:20.606668	2025-11-04 21:06:20.606668	2.5	1	2025-11-04	2025-11-05	0	NEW	0	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	4843714b-fcf2-4889-80b7-337fc38f60bd
59cdb0d7-3ef1-4396-ac4b-652ef5f11902	2025-11-04 21:06:29.149276	2025-11-04 21:06:29.149276	2.5	1	2025-11-04	2025-11-05	0	NEW	0	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	105b4aad-e4b4-41cb-8f17-11501595a42c
fb6e0009-33d8-46db-a24a-b04f2d149126	2025-11-04 21:06:32.533422	2025-11-04 21:06:32.533422	2.5	1	2025-11-04	2025-11-05	0	NEW	0	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	40618d78-8d5f-479f-96f7-e1dfd020be80
1c6fe13d-37ac-4c33-993c-4b33c83b4247	2025-11-04 21:07:21.850931	2025-11-04 21:07:21.850931	2.5	1	2025-11-04	2025-11-05	0	NEW	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	9653310a-5c16-461d-a2dc-492a24677edd
00736302-3cd4-42b4-8f04-36b88d923ef1	2025-10-28 22:51:01.608652	2025-11-04 21:07:21.857439	2.5	1	2025-11-04	2025-11-05	0	NEW	2	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	a8fd5c97-43aa-433b-9b88-39cbae469032
b836bf28-20ea-44a7-8eef-584fccb6d408	2025-11-04 21:07:21.876418	2025-11-04 21:07:21.876418	2.5	1	2025-11-04	2025-11-05	0	NEW	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	af0916df-4290-42a5-a159-9daba0868084
1c0b5289-cba8-4c48-b6e0-d7a1b52e8120	2025-11-04 21:08:00.578472	2025-11-04 21:08:00.578472	2.5	1	2025-11-04	2025-11-05	0	NEW	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	f95fa30c-31d8-45bf-ad42-d506cc4d55e1
a559fb0a-687c-41d6-9911-6da3f9f0ab2b	2025-11-04 21:08:00.581995	2025-11-04 21:08:00.581995	2.5	1	2025-11-04	2025-11-05	0	NEW	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	5adcfd89-1152-4748-b626-90cab5b913b7
e274108e-c1a9-4efc-a875-4b757b961767	2025-11-05 00:51:14.657517	2025-11-05 00:51:14.657517	2.5	1	2025-11-05	2025-11-06	0	NEW	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	8a623eb6-5c61-43a5-8b89-a019a1beee6b
40e66a71-a73a-4be6-bafb-606e2be55244	2025-11-04 21:08:00.585992	2025-11-05 00:51:14.690737	2.5	1	2025-11-05	2025-11-06	0	NEW	2	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	f022eed0-6488-4618-95db-c50d6a8bb51b
7595cfd6-6f7e-4e22-8688-336865de080d	2025-11-02 01:19:25.190312	2025-11-05 01:03:27.95026	2.5	1	2025-11-05	2025-11-06	0	NEW	0	2	c4d17be2-52a3-4827-a3f3-a3c795576ebf	3e7b9a5f-58a7-4900-bce5-76c815e6eee0
e4964e32-4b8e-4f97-b3a3-50b2c42aa769	2025-11-04 21:06:25.751468	2025-11-05 01:03:37.528248	2.5	1	2025-11-05	2025-11-06	1	NEW	1	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	45b62747-23bc-4928-af2d-e8a40505fc0e
7005c1f8-1035-40e6-86eb-c4071d301cd5	2025-11-05 00:51:14.721469	2025-11-05 00:51:14.721469	2.5	1	2025-11-05	2025-11-06	0	NEW	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	94f51b7d-163c-44c0-889c-0240e935c91a
9feb499e-f1c2-4b1f-9ab9-53018a08de9d	2025-11-05 00:56:48.738547	2025-11-05 00:56:48.738547	2.5	1	2025-11-05	2025-11-06	0	NEW	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	31b5c2db-7017-4c1c-b314-6af119da397f
77ae3974-85e1-412c-b8c2-26b1d429577b	2025-11-05 00:56:48.74632	2025-11-05 00:56:48.74632	2.5	1	2025-11-05	2025-11-06	0	NEW	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	7f57664a-79ef-4a88-8a99-31810d16ef69
24f9d8f5-50f3-4a54-b752-63497dafdab8	2025-11-05 00:56:48.751856	2025-11-05 00:56:48.751856	2.5	1	2025-11-05	2025-11-06	0	NEW	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	f1d68be1-44ce-4f0e-bffc-fa6f28b669b4
89ad7998-8c9e-4ed7-934e-c3d45393eb88	2025-11-05 01:03:33.254414	2025-11-05 01:03:33.254414	2.5	1	2025-11-05	2025-11-06	0	NEW	0	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	99342083-9250-4be9-82a6-1131c091ce18
ae1335e4-e102-4b22-b381-e07fc19a1839	2025-11-05 01:03:40.872361	2025-11-05 01:03:40.872361	2.5	1	2025-11-05	2025-11-06	0	NEW	0	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	4306fb3b-f572-4498-9434-b89bb9741340
1034ddc4-1e09-4e36-bb5e-afb4408a66e5	2025-11-05 01:03:44.331207	2025-11-05 01:03:44.331207	2.5	1	2025-11-05	2025-11-06	0	NEW	0	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	62847eca-5dc3-44a7-b323-8abca1f30553
17ed3513-79a9-4c25-b82b-e22b46796d9a	2025-11-05 17:21:46.206092	2025-11-05 17:21:46.206117	2.5	1	2025-11-05	2025-11-06	1	NEW	1	0	146576d3-82a3-4196-84a7-87bb8884c98e	62c3bcd6-606d-4458-b37a-f582609fdeb3
76afc2f2-d922-4ef4-bd0d-3ab577f46c1c	2025-11-05 17:21:49.407281	2025-11-05 17:21:49.40732	2.5	1	2025-11-05	2025-11-06	0	NEW	0	1	146576d3-82a3-4196-84a7-87bb8884c98e	4367d0a5-f9b1-4c92-b58d-c6735c7df2d5
9819c65e-c41e-4a7a-a485-312805e70bcd	2025-11-05 17:21:52.575252	2025-11-05 17:21:52.57527	2.5	1	2025-11-05	2025-11-06	0	NEW	0	1	146576d3-82a3-4196-84a7-87bb8884c98e	14fe6c8a-eac5-46c4-b1d5-62817daf1e78
854c2640-1507-4bd2-a8d8-1a5a0281d1d1	2025-11-05 17:21:55.37964	2025-11-05 17:21:55.379657	2.5	1	2025-11-05	2025-11-06	1	NEW	1	0	146576d3-82a3-4196-84a7-87bb8884c98e	4b581df1-8c71-4a6d-8fbe-1600ef59acd9
b8a92e14-c2f7-4f90-a907-acbffaddf517	2025-11-05 17:21:58.429519	2025-11-05 17:21:58.429552	2.5	1	2025-11-05	2025-11-06	1	NEW	1	0	146576d3-82a3-4196-84a7-87bb8884c98e	0ae6f709-7a8c-4ab9-a170-9780a3ab2790
6b4aaf7d-e33f-41a5-8d0d-4e7dae8644a6	2025-11-05 17:55:47.978958	2025-11-05 17:55:47.979021	2.5	1	2025-11-05	2025-11-06	0	NEW	0	1	146576d3-82a3-4196-84a7-87bb8884c98e	fa38c299-624b-4dd6-88b8-23f2f4a4008e
bc04a526-df94-4c49-983f-1a0ab669fb20	2025-11-05 17:55:52.006548	2025-11-05 17:55:52.006578	2.5	1	2025-11-05	2025-11-06	0	NEW	0	1	146576d3-82a3-4196-84a7-87bb8884c98e	a10ca209-b213-4931-9db3-39353bf1fc67
710daa72-f2a1-4ac4-81fc-1c617d9667de	2025-11-05 17:55:54.935911	2025-11-05 17:55:54.935947	2.5	1	2025-11-05	2025-11-06	0	NEW	0	1	146576d3-82a3-4196-84a7-87bb8884c98e	7f410a5d-03f1-49ec-80a4-4bc282657f0f
22cffe5a-a1f8-4129-809a-56b1640712f8	2025-11-05 17:55:58.621596	2025-11-05 17:55:58.621621	2.5	1	2025-11-05	2025-11-06	0	NEW	0	1	146576d3-82a3-4196-84a7-87bb8884c98e	8b91ab1f-312a-4dac-9929-6667fc418a0f
c45b87e1-d6e1-4a95-be52-2629ca57bf60	2025-11-05 17:56:01.470656	2025-11-05 17:56:01.470686	2.5	1	2025-11-05	2025-11-06	0	NEW	0	1	146576d3-82a3-4196-84a7-87bb8884c98e	90452f4e-b01c-4497-bcf4-040afb5cbd2c
a8728897-2934-4e2a-b797-4eb094b62b1f	2025-11-05 17:58:43.674112	2025-11-05 17:58:43.674138	2.5	1	2025-11-05	2025-11-06	0	NEW	0	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	1396744e-d891-401f-b5dd-3d052b8f6f96
af65b169-d819-46a1-b1b2-08aa43d04fd4	2025-11-05 17:58:46.579644	2025-11-05 17:58:46.579675	2.5	1	2025-11-05	2025-11-06	0	NEW	0	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	10109c3c-1c8b-436d-8ea5-d81adc6e3cb8
7bacb34a-6870-476e-ba90-e05fe193fed9	2025-11-05 17:58:49.182578	2025-11-05 17:58:49.182595	2.5	1	2025-11-05	2025-11-06	0	NEW	0	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	98ae76c4-ceda-4285-978b-17455b34924d
73233e11-92f1-49a0-a05e-b83fddff5587	2025-11-05 17:58:51.88648	2025-11-05 17:58:51.886502	2.5	1	2025-11-05	2025-11-06	1	NEW	1	0	c4d17be2-52a3-4827-a3f3-a3c795576ebf	90ceb93e-2885-4594-b7fb-8826cbd6aed6
dc801012-6ee5-4bc7-987b-e3b241ce446f	2025-11-05 17:58:54.985864	2025-11-05 17:58:54.985889	2.5	1	2025-11-05	2025-11-06	0	NEW	0	1	c4d17be2-52a3-4827-a3f3-a3c795576ebf	26193f2b-c221-41a6-b94b-74b3106c0fcc
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, created_at, updated_at, activated, activation_expired_date, activation_key, avatar, banned, current_level, date_of_birth, email, gender, name, next_activation_time, password, status, current_streak, last_activity_date, longest_streak, total_study_days) FROM stdin;
df8e1bbc-cb19-4885-b855-083c1fd9a7d9	2025-10-03 15:35:14.544889	2025-10-03 15:35:14.544889	t	\N	\N	\N	f	A1	1990-01-01	ngominhthuan195@gmail.com	Nam	Nguyễn Văn A	\N	$2a$10$889uv5pTFnWYRNy0K2Pdeu21EINXA6WYjEdPh40xedi44dyHjaNPu	ACTIVE	\N	\N	\N	\N
519693aa-312c-48b5-963d-75f425fbf0a3	2025-10-03 15:38:44.462333	2025-10-03 15:38:44.462333	t	\N	\N	\N	f	A1	1990-01-01	mthuanttshop2@gmail.com	Nam	Nguyễn Văn B	\N	$2a$10$YJuFvE993uZ4EED4cdlP6ecZzmrgBPBnnZ3Ah0io89PLhDgQiz5ZK	ACTIVE	\N	\N	\N	\N
7b9a210f-b1c2-44cf-8fc6-73a7ce54baea	2025-10-03 15:37:42.985284	2025-10-03 15:45:48.24796	t	\N	\N	\N	f	A1	1990-01-01	thuanminh.dev@gmail.com	Nam	Ngô Minh Thuận	\N	$2a$10$e4NOL36W4wNpImvWYgqR3OIlp48wVFe5nBMvZHZIPFxPKqoxkrcli	ACTIVE	\N	\N	\N	\N
bcdaa50c-b36a-4aaa-87ef-ceaf661d974e	2025-10-24 13:16:19.056711	2025-10-24 13:16:19.056711	t	\N	\N	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/users%2Favatars%2F75a1bbef-e0e0-4a8c-80f3-09d867f883b8.png?alt=media	f	A1	1990-01-01	mthuanttshop3@gmail.com	Nam	Nguyễn Văn C	\N	$2a$10$.dGATyCtYQJhuW7SYX5f2O78HvyG/3lEIIrnqO1uzdvdGwf/BX6b.	ACTIVE	\N	\N	\N	\N
1e851484-dc74-4eb6-a856-1b39d3071492	2025-10-24 13:30:59.069775	2025-10-24 13:30:59.069775	t	\N	\N	\N	f	A1	1990-01-01	mthuanttshop4@gmail.com	Nam	Nguyễn Văn C	\N	$2a$10$SRmbgisKgDggL2jlPjlI6.YhM0eN3G9wq.uv/MQYMSWYv.i4ry00q	ACTIVE	\N	\N	\N	\N
5e8f735d-2fde-4e70-9831-eb398531fda8	2025-10-24 14:19:37.132423	2025-10-24 14:19:37.132423	t	\N	\N	\N	f	A1	1992-02-02	admin2@cardwords.com	Nam	Quản trị viên 2	\N	$2a$10$oxHZ2kchAG7ZV8l6twH2Qe8TBD0s2vLoTTLMzXUNqBPyW8V/o4Fii	\N	\N	\N	\N	\N
c4d17be2-52a3-4827-a3f3-a3c795576ebf	2025-10-03 21:59:06.90979	2025-11-05 17:14:02.627452	t	\N	\N	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/users%2Favatars%2F480fb030-5a97-4ea0-9812-ea71d6735d14.jpg?alt=media	f	A1	1990-01-01	cardwordsgame@gmail.com	Nam	Ngô Minh Thuận 1	\N	$2a$10$77un5aqr/1siC/oGTgCE6Oudmdj.7e7rZY/Vafd2BJRIvBwNwQGgC	ACTIVE	2	2025-11-05	2	11
146576d3-82a3-4196-84a7-87bb8884c98e	2025-10-24 14:19:37.043907	2025-11-05 17:21:58.432631	t	\N	\N	\N	f	A1	1990-01-01	admin1@cardwords.com	Nam	Quản trị viên 1	\N	$2a$10$l0huQHt087OzJsYnbR.3wO1r7.p3sEt7VVJlPXjeJg5j1zfhdH446	\N	1	2025-11-05	1	1
\.


--
-- Data for Name: vocab; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vocab (id, created_at, updated_at, audio, cefr, example_sentence, img, interpret, meaning_vi, transcription, word, word_type, credit) FROM stdin;
ad763e27-5b69-4861-96a5-a42a9dbce021	2025-10-10 18:49:48.034512	2025-10-17 19:04:43.257091	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8ec9a3c4-a3bb-4793-8584-ad5a9d6f6c5b.mp3?alt=media	A1	[Work] The baby was recorded carefully in the report. | [Problem] The baby broke suddenly, so we had to fix it. | [Story] A traveler found a baby near the old counter.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fbc8b46fd-8aa4-4d1a-a881-1a005b819072.jpg?alt=media	A very young child who requires care and attention.	em bé	ˈbeɪbi	baby	\N	
e2510cb1-8178-42de-904b-5e2cdc3680b5	2025-10-10 18:49:48.013314	2025-10-17 19:04:42.745517	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5668b814-c5c6-4b20-9b1d-98663c52c6c3.mp3?alt=media	A1	[Memory] This father reminds me of my childhood in the countryside. | [Hobby] He collects photos of fathers from different countries. | [Description] That father looks modern in the afternoon light.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F853d806c-aa9a-48c0-9733-f1f117547c14.jpeg?alt=media	A male parent who provides care and guidance to his children.	cha	ˈfɑːðə	father	\N	“Father with child.jpg” by Unknown author, source: https://commons.wikimedia.org/wiki/File:Father_with_child.jpg, license: Public Domain (https://creativecommons.org/publicdomain/mark/1.0/).
64edc678-01c8-4291-9fd0-efd330d6dead	2025-10-10 18:49:48.006662	2025-10-17 19:04:42.748015	null	A1	[Memory] This coffee reminds me of my childhood in the countryside. | [Hobby] He collects photos of coffees from different countries. | [Description] That coffee looks modern in the afternoon light.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F4214c909-a980-4d69-9259-d11b710f3853.jpeg?alt=media	A drink made from roasted coffee beans, known for its stimulating effect.	cà phê	ˈkɒfi	coffee	\N	“Coffee Beans Photographed in Macro.jpg” by Robert Knapp, source: https://commons.wikimedia.org/wiki/File:Coffee_Beans_Photographed_in_Macro.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).
87d4927c-4a8f-48d9-93e3-71e8a35e0770	2025-10-10 18:49:47.992149	2025-10-10 18:49:47.992149	null	A1	[Problem] The fish broke suddenly, so we had to fix it. | [Description] That fish looks safe in the afternoon light. | [Work] The fish was recorded carefully in the report.	\N	An aquatic animal eaten as food, known for its nutritional value.	cá	fɪʃ	fish	\N	
34c7d346-eac6-43ef-9b8d-847b8066fe56	2025-10-10 18:49:47.995913	2025-10-10 18:49:47.995913	null	A1	[Shopping] She compared three meats and chose the freshest one. | [Advice] Keep the meat away from traffic to stay safe. | [Hobby] He collects photos of meats from different countries.	\N	The flesh of animals used as food, rich in protein.	thịt	miːt	meat	\N	
1f4716d3-0144-486c-82aa-6495c04a6799	2025-10-10 18:49:47.999773	2025-10-10 18:49:47.999773	null	A1	[School] The teacher asked us to describe a egg in two sentences. | [Everyday] I put the egg on the shelf before dinner. | [Advice] Keep the egg away from sunlight to stay safe.	\N	A food item produced by birds, commonly used in cooking and baking.	trứng	eɡ	egg	\N	“Egg-3506222 1920.jpg” by congerdesign, source: https://commons.wikimedia.org/wiki/File:Egg-3506222_1920.jpg, license: CC0 1.0 (https://creativecommons.org/publicdomain/zero/1.0/).
5e53247f-dc44-425e-b70b-fce4cf245048	2025-10-09 18:17:35.098031	2025-10-09 18:17:35.098031	\N	A1	[Advice] Keep the apple away from rain to stay safe. | [School] The teacher asked us to describe a apple in two sentences. | [Shopping] She compared three apples and chose the freshest one.	\N	A round fruit with crisp flesh and a sweet or tart taste, often eaten raw or used in cooking.	quả táo	ˈæpl	apple	\N	Apple on desk” by Bapple4747, source: https://commons.wikimedia.org/wiki/File:Apple_on_desk.jpg, license: CC0 1.0 (https://creativecommons.org/publicdomain/zero/1.0/).
fb618efb-dd79-4c8a-a01d-704ea630b694	2025-10-10 18:49:48.02306	2025-10-17 19:04:42.89772	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb25bddde-a526-438e-844c-60c3fc2e41d7.mp3?alt=media	A1	[Story] A traveler found a sister near the old floor. | [Work] The sister was recorded carefully in the report. | [Everyday] I put the sister on the floor before dinner.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F8a592e53-49d2-43cf-ae53-e2d06ba42e09.jpg?alt=media	A female sibling who fosters close family ties.	chị/em gái	ˈsɪstə	sister	\N	“Sisters.jpg” by User:Khamul, source: https://commons.wikimedia.org/wiki/File:Sisters.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).
24339e86-67f9-408e-b3a3-166c182d6518	2025-10-10 18:49:48.030699	2025-10-17 19:04:43.313677	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7efc39fb-46b5-42fa-9a5f-b35a785d884f.mp3?alt=media	A1	[Memory] This daughter reminds me of my childhood in the countryside. | [Hobby] He collects photos of daughters from different countries. | [Description] That daughter looks modern in the afternoon light.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F3cdf1fe8-967c-4407-bdd9-2ff65a630103.jpg?alt=media	A female child in a family.	con gái	ˈdɔːtə	daughter	\N	
08e548ce-597a-4436-9dd4-a57170647d66	2025-10-10 18:49:48.037451	2025-10-10 18:49:48.037451	null	A1	[Everyday] I put the man on the bag before dinner. | [Story] A traveler found a man near the old bag. | [School] The teacher asked us to describe a man in two sentences.	\N	An adult male human, often contributing to society through various roles.	người đàn ông	mæn	man	\N	
bf58df5a-d024-4b7a-b4e4-0b6e07c5692c	2025-10-10 18:49:47.983988	2025-10-17 18:19:25.911928	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F89fd2310-f33d-402a-9308-ecaa2c919d33.mp3?alt=media	A1	[School] The teacher asked us to describe a water in two sentences. | [Everyday] I put the water on the bag before dinner. | [Advice] Keep the water away from fire to stay safe.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F4018283a-4dbf-4396-8ed2-b3ea4f49f8c2.jpeg?alt=media	A clear liquid essential for life, used for drinking, cooking, and cleaning.	nước	ˈwɔːtə	water	\N	
e38ad6ce-f5dd-47a6-be59-913ece323015	2025-10-10 18:49:48.11692	2025-10-17 19:01:51.146147	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F33a6fa9c-a051-4cf0-b009-c0da66c51cfb.mp3?alt=media	A2	[Memory] This manager reminds me of my childhood in the countryside. | [Hobby] He collects photos of managers from different countries. | [Description] That manager looks modern in the afternoon light.	\N	A person responsible for controlling or administering an organization or group.	quản lý	ˈmænɪdʒə	manager	\N	
28b70b3d-16a6-497f-8498-216a7d343bd9	2025-10-10 18:49:48.041259	2025-10-17 19:04:43.214223	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F152ece4a-36e0-47c6-9006-ec56229af269.mp3?alt=media	A1	[Memory] This woman reminds me of my childhood in the countryside. | [Hobby] He collects photos of womans from different countries. | [Description] That woman looks modern in the afternoon light.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fd25da32f-6f3d-4947-8744-440a0a4672f0.jpeg?alt=media	An adult female human, often influential in family or society.	người phụ nữ	ˈwʊmən	woman	\N	“Woman smiling.jpg” by Happy Sloth, source: https://commons.wikimedia.org/wiki/File:Woman_smiling.jpg, license: CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/).
0059b1b9-2bf4-4db9-8872-cdba778a7c4a	2025-10-10 18:49:48.056851	2025-10-17 19:04:43.72216	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4a99ec13-a5d4-4e25-84bf-290f697bc343.mp3?alt=media	A1	[Problem] The pencil broke suddenly, so we had to fix it. | [Description] That pencil looks safe in the afternoon light. | [Work] The pencil was recorded carefully in the report.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F9b2a1536-369e-4644-938b-e2a880a4ee50.jpg?alt=media	A writing tool with an erasable graphite core.	bút chì	ˈpensl	pencil	\N	
e45bd462-9ee0-40a0-9f6a-41f174e03d81	2025-10-10 18:49:48.060533	2025-10-17 19:04:43.871079	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2179a3fb-5dda-42dd-a05c-42ee735cef00.mp3?alt=media	A1	[Work] The school was recorded carefully in the report. | [Problem] The school broke suddenly, so we had to fix it. | [Story] A traveler found a school near the old bench.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fe98be88c-6545-45ee-ae23-bbe8f479aafd.jpg?alt=media	A place where students learn from teachers.	trường học	skuːl	school	\N	
1fe3a9a6-f87e-432a-8d18-461941881e3e	2025-10-10 18:49:48.071294	2025-10-17 19:04:43.918302	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F633babad-79ac-41e8-8384-07aeef1cdfd4.mp3?alt=media	A1	[Work] The homework was recorded carefully in the report. | [Problem] The homework broke suddenly, so we had to fix it. | [Story] A traveler found a homework near the old counter.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F72c9b6a8-b71d-49d5-a340-1b5b8a38f43c.jpg?alt=media	Tasks assigned by teachers to be done outside class.	bài tập về nhà	ˈhəʊmwɜːk	homework	\N	
6a11f8f5-fe19-4755-a962-bb5a0c345945	2025-10-10 18:49:48.067242	2025-10-17 19:04:44.122886	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F98984cf7-7a2e-430b-b289-3aaa7cd31e23.mp3?alt=media	A1	[Hobby] He collects photos of lessons from different countries. | [Shopping] She compared three lessons and chose the freshest one. | [Memory] This lesson reminds me of my childhood in the countryside.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F9428584b-9bbe-48a0-8840-db48c1e99473.jpg?alt=media	A period of learning or teaching on a specific topic.	bài học	ˈlesn	lesson	\N	
f1900639-c9bb-47a9-a4df-8997fea9ae8a	2025-10-10 18:49:48.086638	2025-10-10 18:49:48.086638	null	A1	[Shopping] She compared three jobs and chose the freshest one. | [Advice] Keep the job away from fire to stay safe. | [Hobby] He collects photos of jobs from different countries.	\N	A paid position of regular employment.	công việc	dʒɒb	job	\N	“Job fair.jpg” by US Department of Labor, source: https://commons.wikimedia.org/wiki/File:Job_fair.jpg, license: Public Domain (https://creativecommons.org/publicdomain/mark/1.0/).
aee63a03-282c-4783-9659-7c4e58729e08	2025-10-10 18:49:48.077097	2025-10-17 19:04:44.399737	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8766dd84-4f8e-4011-bd71-0ed35e25cd9b.mp3?alt=media	A1	[School] The teacher asked us to describe a library in two sentences. | [Everyday] I put the library on the desk before dinner. | [Advice] Keep the library away from dust to stay safe.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fad83df41-86ca-45b7-b14d-18e4a121411b.jpg?alt=media	A place where books and resources are stored for reading or study.	thư viện	ˈlaɪbrəri	library	\N	
7938c7b3-6a81-4fcd-844d-ede72c3e5182	2025-10-10 18:49:48.097156	2025-10-17 19:04:44.615193	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2100ac1b-a1ca-41e9-a38b-43575a90363e.mp3?alt=media	A2	[Everyday] I put the worker on the doorway before dinner. | [Story] A traveler found a worker near the old doorway. | [School] The teacher asked us to describe a worker in two sentences.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F04fb0e3e-77b3-440f-8ac1-5ac74f7769b1.jpg?alt=media	A person who does a particular job to earn money.	công nhân	ˈwɜːkə	worker	\N	
d9d403ee-cf64-424c-8e60-a14567b6c266	2025-10-10 18:49:48.104355	2025-10-17 19:04:44.924887	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F49fee623-9d04-42bf-b0c4-f60004209517.mp3?alt=media	A1	[Everyday] I put the doctor on the shelf before dinner. | [Story] A traveler found a doctor near the old shelf. | [School] The teacher asked us to describe a doctor in two sentences.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fb2bd48ea-cdde-4b43-94df-c7583d4a8fe4.jpg?alt=media	A person qualified to treat people who are ill.	bác sĩ	ˈdɒktə	doctor	\N	
5cc1da45-ca89-4c72-90d5-60c30b2cfaef	2025-10-10 18:49:48.113507	2025-10-17 19:04:45.192234	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0b71131c-d1cf-4526-b88a-6a5bc38eef07.mp3?alt=media	A1	[Story] A traveler found a driver near the old wall. | [Work] The driver was recorded carefully in the report. | [Everyday] I put the driver on the wall before dinner.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F01ff7d35-8d3c-465b-bf84-ab53ff4e02b9.jpg?alt=media	A person who drives a vehicle.	tài xế	ˈdraɪvə	driver	\N	
97fa16a3-6483-4a5f-99f1-2c0fdc612769	2025-10-10 18:49:48.109007	2025-10-17 19:01:51.105155	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8ad39497-6f69-4f29-acae-d6212c52e323.mp3?alt=media	A1	[Memory] This farmer reminds me of my childhood in the countryside. | [Hobby] He collects photos of farmers from different countries. | [Description] That farmer looks modern in the afternoon light.	\N	A person who owns or manages a farm.	nông dân	ˈfɑːmə	farmer	\N	“Indian farmer.jpg” by Yann, source: https://commons.wikimedia.org/wiki/File:Indian_farmer.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).
ab7b7066-6c3b-40ff-8231-1274cd87b060	2025-10-10 18:49:48.187483	2025-10-17 19:02:18.854125	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F10aeca48-7976-4f0b-bbc7-220622c38dcc.mp3?alt=media	A1	[Story] A traveler found a dog near the old floor. | [Work] The dog was recorded carefully in the report. | [Everyday] I put the dog on the floor before dinner.	\N	A domesticated carnivorous mammal kept as a pet or for work.	chó	dɒɡ	dog	\N	
86b7b2f4-5b79-4989-b5a8-4aa896601498	2025-10-10 18:49:48.05435	2025-10-17 19:04:43.654012	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6b4be171-670f-49be-a762-0a50616f3eac.mp3?alt=media	A1	[Memory] This pen reminds me of my childhood in the countryside. | [Hobby] He collects photos of pens from different countries. | [Description] That pen looks modern in the afternoon light.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fd1290767-dab6-4c0b-893a-ffed8fa86b5c.jpg?alt=media	A tool used for writing or drawing with ink.	bút mực	pen	pen	\N	
cc7a67ed-c412-463b-b1ae-ec999ebfd541	2025-10-10 18:49:48.179169	2025-10-17 19:04:45.714648	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5c1601ea-54bc-43f9-b907-1db98e945240.mp3?alt=media	A1	[Work] The player was recorded carefully in the report. | [Problem] The player broke suddenly, so we had to fix it. | [Story] A traveler found a player near the old bag.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fd5698e24-51a6-40f4-b2f5-433a4b8e518b.jpg?alt=media	A person taking part in a sport or game.	cầu thủ; người chơi	ˈpleɪə	player	\N	
1e8ae068-1f58-455c-ac7a-c697a8188e43	2025-10-10 18:49:48.16049	2025-10-17 19:04:45.744607	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F60afe60b-62df-441e-8c99-58981da8a956.mp3?alt=media	A1	[Health] Doctors say you should swim regularly to stay healthy. | [Weather] It's hard to swim when the sun is very strong. | [Tip] If you swim too fast at the start, you'll get tired quickly.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F495d0ac4-9ff8-4565-8924-d379c1d126f0.jpg?alt=media	To propel oneself through water using limbs.	bơi	swɪm	swim	\N	
31713db1-5f9e-4172-bfe9-30e0f1f44f54	2025-10-10 18:49:48.151044	2025-10-10 18:49:48.151044	null	A1	[School] The teacher asked us to describe a map in two sentences. | [Everyday] I put the map on the bench before dinner. | [Advice] Keep the map away from children to stay safe.	\N	A diagrammatic representation of an area of land or sea showing physical features.	bản đồ	mæp	map	\N	“World map.jpg” by CIA World Factbook, source: https://commons.wikimedia.org/wiki/File:World_map.jpg, license: Public Domain (https://creativecommons.org/publicdomain/mark/1.0/).
f33f8d0d-d2be-4096-ac65-dc876229a7d4	2025-10-10 18:49:48.132602	2025-10-17 19:01:51.413488	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbbc895ff-4afd-4db7-9fda-2c39b15148fd.mp3?alt=media	A1	[Everyday] I put the plane on the table before dinner. | [Story] A traveler found a plane near the old table. | [School] The teacher asked us to describe a plane in two sentences.	\N	An aircraft that flies through the air, used for long-distance travel.	máy bay	pleɪn	plane	\N	
5f6d0f07-e66d-443d-80d4-a3a4125970ee	2025-10-10 18:49:48.145552	2025-10-17 19:01:51.68463	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd59d995b-1227-4bad-9e58-3866f05a51c1.mp3?alt=media	A1	[Hobby] He collects photos of trips from different countries. | [Shopping] She compared three trips and chose the freshest one. | [Memory] This trip reminds me of my childhood in the countryside.	\N	A journey or excursion, especially for pleasure.	chuyến đi	trɪp	trip	\N	
088b3bc1-3254-4f71-a22f-fdec555a2f68	2025-10-10 18:49:48.13631	2025-10-17 19:01:51.479867	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F55ad6e77-9fa0-46d2-8292-a8804691dead.mp3?alt=media	A1	[School] The teacher asked us to describe a airport in two sentences. | [Everyday] I put the airport on the doorway before dinner. | [Advice] Keep the airport away from heat to stay safe.	\N	A place where aircraft take off and land, with facilities for passengers.	sân bay	ˈeəpɔːt	airport	\N	
b2bd866b-a85a-4222-8646-6284d014b3e5	2025-10-10 18:49:48.14965	2025-10-17 19:01:51.71252	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F77afd861-bafa-4617-bced-f42cc6f1fe89.mp3?alt=media	A1	[Problem] The holiday broke suddenly, so we had to fix it. | [Description] That holiday looks safe in the afternoon light. | [Work] The holiday was recorded carefully in the report.	\N	A day of festivity or recreation when no work is done.	kỳ nghỉ	ˈhɒlədeɪ	holiday	\N	
543e1a08-a254-4834-a3da-53209b0ac86f	2025-10-10 18:49:48.169006	2025-10-17 19:01:52.057032	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2fbec6b7-bd9c-42dc-98d3-76a97d471478.mp3?alt=media	A1	[Work] The tennis was recorded carefully in the report. | [Problem] The tennis broke suddenly, so we had to fix it. | [Story] A traveler found a tennis near the old counter.	\N	A game in which two or four players strike a ball with rackets over a net.	quần vợt	ˈtenɪs	tennis	\N	“Tennis player.jpg” by Carine06, source: https://commons.wikimedia.org/wiki/File:Tennis_player.jpg, license: CC BY-SA 2.0 (https://creativecommons.org/licenses/by-sa/2.0/).
d0b068e5-3c67-427d-b572-b50190b87f3a	2025-10-10 18:49:48.162929	2025-10-17 19:01:51.98404	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F592333c4-aaa4-42e9-bf01-8e9e9230535a.mp3?alt=media	A1	[Work] The football was recorded carefully in the report. | [Problem] The football broke suddenly, so we had to fix it. | [Story] A traveler found a football near the old bench.	\N	A game played by two teams of eleven players with a round ball.	bóng đá	ˈfʊtbɔːl	football	\N	“Football player.jpg” by Ben Sutherland, source: https://commons.wikimedia.org/wiki/File:Football_player.jpg, license: CC BY 2.0 (https://creativecommons.org/licenses/by/2.0/).
5d7bb7be-a862-4ee1-9206-ba4ab7383d4e	2025-10-10 18:49:48.171982	2025-10-17 19:01:52.103784	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F05bdbad6-b022-4daf-931c-01f7a64206df.mp3?alt=media	A2	[Advice] Keep the gym away from noise to stay safe. | [School] The teacher asked us to describe a gym in two sentences. | [Shopping] She compared three gyms and chose the freshest one.	\N	A place equipped for physical exercise and training.	phòng tập	dʒɪm	gym	\N	
0e199588-ffb8-459e-a9ba-e925afde0484	2025-10-10 18:49:48.17576	2025-10-17 19:01:52.273034	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6a1f36db-8014-4208-a6dd-56cacf2e1415.mp3?alt=media	A1	[Work] The exercise was recorded carefully in the report. | [Problem] The exercise broke suddenly, so we had to fix it. | [Story] A traveler found a exercise near the old table.	\N	Physical activity done to improve health or fitness.	bài tập; tập luyện	ˈeksəsaɪz	exercise	\N	
e829d14c-9a3b-4c71-9e6d-3c52df6e291b	2025-10-10 18:49:48.128688	2025-10-17 19:01:51.376565	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe169e395-4088-4474-b9e9-3fb1aa884b11.mp3?alt=media	A1	[Story] A traveler found a train near the old table. | [Work] The train was recorded carefully in the report. | [Everyday] I put the train on the table before dinner.	\N	A series of connected vehicles that run along a railway track.	tàu hỏa	treɪn	train	\N	
e0e43a0e-4abf-4437-986d-368d8e6d24b9	2025-10-10 18:49:48.189048	2025-10-10 18:49:48.189048	null	A1	[Hobby] He collects photos of cats from different countries. | [Shopping] She compared three cats and chose the freshest one. | [Memory] This cat reminds me of my childhood in the countryside.	\N	A small domesticated carnivorous mammal with soft fur, kept as a pet.	mèo	kæt	cat	\N	
41bcd0ee-915b-46d3-90e9-c1285d1bceee	2025-10-10 18:49:48.064519	2025-10-17 19:04:43.852664	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fde117342-7172-42c0-9371-efb5a7e92043.mp3?alt=media	A1	[Hobby] He collects photos of classrooms from different countries. | [Shopping] She compared three classrooms and chose the freshest one. | [Memory] This classroom reminds me of my childhood in the countryside.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F5f35e261-fb1c-4287-b282-7f1327b8c893.jpg?alt=media	A room where students attend lessons.	phòng học	ˈklɑːsruːm	classroom	\N	
2c8db310-fe7d-4a62-9ff8-6140759f109f	2025-10-10 18:49:48.201777	2025-10-17 19:05:52.151856	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd116943d-a151-4ddc-9e09-cbe32d53e16e.mp3?alt=media	A1	[Shopping] She compared three goats and chose the freshest one. | [Advice] Keep the goat away from heat to stay safe. | [Hobby] He collects photos of goats from different countries.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F1c918c95-9e68-4a10-ad1e-1462a4cdc331.jpg?alt=media	A hardy domesticated ruminant mammal with horns.	dê	ɡəʊt	goat	\N	
3a93694e-ce24-4f35-95b3-37dd5fde7689	2025-10-10 18:49:48.206616	2025-10-17 19:01:52.732244	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4a10a51d-270b-44c6-96f5-29b10f568c74.mp3?alt=media	A1	[Everyday] I put the duck on the table before dinner. | [Story] A traveler found a duck near the old table. | [School] The teacher asked us to describe a duck in two sentences.	\N	A swimming bird with a broad bill and webbed feet.	vịt	dʌk	duck	\N	“Duck swimming.jpg” by Bernard Spragg, source: https://commons.wikimedia.org/wiki/File:Duck_swimming.jpg, license: CC0 1.0 (https://creativecommons.org/publicdomain/zero/1.0/).
d539284f-c0ba-4a2b-997c-b292b9d86827	2025-10-10 18:49:48.205032	2025-10-17 19:01:52.684582	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F540d2b51-f3fa-4ea3-bf8c-804719ace5ba.mp3?alt=media	A1	[School] The teacher asked us to describe a chicken in two sentences. | [Everyday] I put the chicken on the bench before dinner. | [Advice] Keep the chicken away from heat to stay safe.	\N	A domesticated fowl kept for eggs or meat.	gà	ˈtʃɪkɪn	chicken	\N	“Chicken portrait.jpg” by Luis Miguel Bugallo Sánchez, source: https://commons.wikimedia.org/wiki/File:Chicken_portrait.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).
fdc1979e-e28d-4904-9ebc-6e22ba6e4f1e	2025-10-10 18:49:48.209538	2025-10-17 19:01:52.86973	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Faa78f738-de4e-485f-a0dc-bffd11705a45.mp3?alt=media	A1	[Problem] The rabbit broke suddenly, so we had to fix it. | [Description] That rabbit looks safe in the afternoon light. | [Work] The rabbit was recorded carefully in the report.	\N	A small burrowing mammal with long ears and soft fur.	thỏ	ˈræbɪt	rabbit	\N	“Rabbit in grass.jpg” by Aconcagua, source: https://commons.wikimedia.org/wiki/File:Rabbit_in_grass.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).
68706170-5a79-49be-9371-f0650fd14601	2025-10-10 18:49:48.215607	2025-10-17 19:01:52.970541	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff5c91dc5-5740-431e-b367-611548b7bb84.mp3?alt=media	A1	[Memory] This moon reminds me of my childhood in the countryside. | [Hobby] He collects photos of moons from different countries. | [Description] That moon looks modern in the afternoon light.	\N	The natural satellite of the earth, visible at night.	mặt trăng	muːn	moon	\N	“Full moon.jpg” by Gregory H. Revera, source: https://commons.wikimedia.org/wiki/File:Full_moon.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).
4c5c09be-4268-450d-87f8-af21a4dec46f	2025-10-10 18:49:48.219241	2025-10-17 19:01:53.047406	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fff477b39-6901-4de3-9bd8-36518f20b95b.mp3?alt=media	A1	[Work] The sky was recorded carefully in the report. | [Problem] The sky broke suddenly, so we had to fix it. | [Story] A traveler found a sky near the old desk.	\N	The region above the earth, appearing blue during the day.	bầu trời	skaɪ	sky	\N	“Blue sky with clouds.jpg” by Diego Delso, source: https://commons.wikimedia.org/wiki/File:Blue_sky_with_clouds.jpg, license: CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/).
63fd5fd0-dd1c-4bcc-83e0-200ea0337a2d	2025-10-10 18:49:48.217646	2025-10-17 19:01:52.985273	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7da41c31-489f-49ef-b01d-d1e40a469a5c.mp3?alt=media	A1	[School] The teacher asked us to describe a star in two sentences. | [Everyday] I put the star on the shelf before dinner. | [Advice] Keep the star away from dust to stay safe.	\N	A celestial body appearing as a luminous point in the night sky.	ngôi sao	stɑː	star	\N	
7a1f7fc7-6ec6-4d21-b2d6-49e160d4b0f2	2025-10-10 18:49:48.225319	2025-10-17 19:01:53.249979	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3dba2de5-b556-484c-8088-fcbbf55cdde7.mp3?alt=media	A1	[Advice] Keep the flower away from noise to stay safe. | [School] The teacher asked us to describe a flower in two sentences. | [Shopping] She compared three flowers and chose the freshest one.	\N	The reproductive structure of flowering plants, often colorful.	hoa	ˈflaʊə	flower	\N	“Red rose.jpg” by André Karwath, source: https://commons.wikimedia.org/wiki/File:Red_rose.jpg, license: CC BY-SA 2.5 (https://creativecommons.org/licenses/by-sa/2.5/).
6d247664-56b0-4e34-b36f-e8086e06ce4a	2025-10-10 18:49:48.234589	2025-10-17 19:01:53.36719	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb315ea84-2138-4242-9811-cdfa10e8af9e.mp3?alt=media	A1	[Work] The mountain was recorded carefully in the report. | [Problem] The mountain broke suddenly, so we had to fix it. | [Story] A traveler found a mountain near the old bench.	\N	A large natural elevation of the earth's surface.	núi	ˈmaʊntən	mountain	\N	
64cb0d69-d84e-43a4-87d1-6e3b9c888c24	2025-10-10 18:49:48.197519	2025-10-17 19:01:52.570608	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa00924d3-4644-4861-b946-d32d6c0eed75.mp3?alt=media	A1	[Memory] This horse reminds me of my childhood in the countryside. | [Hobby] He collects photos of horses from different countries. | [Description] That horse looks modern in the afternoon light.	\N	A large domesticated mammal used for riding or work.	ngựa	hɔːs	horse	\N	“Horse in field.jpg” by Dirk Ingo Franke, source: https://commons.wikimedia.org/wiki/File:Horse_in_field.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).
21a1882b-4e95-4e7f-8ec6-df31df1b25d4	2025-10-10 18:49:48.088973	2025-10-17 19:04:44.392239	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8cef3a89-784f-4dd8-9485-9507d85a779c.mp3?alt=media	A1	[Story] A traveler found a office near the old counter. | [Work] The office was recorded carefully in the report. | [Everyday] I put the office on the counter before dinner.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fbe61236c-c209-43bb-9f3d-ff1dea687d48.jpg?alt=media	A building or room where people work, especially in business or administration.	văn phòng	ˈɒfɪs	office	\N	
efa6819a-3158-4e1d-9539-464864424900	2025-10-10 18:49:48.244597	2025-10-17 19:01:53.615955	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffd17e01d-d2d2-4e85-a83f-ccf370360286.mp3?alt=media	A1	[School] The teacher asked us to describe a bed in two sentences. | [Everyday] I put the bed on the counter before dinner. | [Advice] Keep the bed away from sunlight to stay safe.	\N	A piece of furniture for sleeping.	giường	bed	bed	\N	
904d53ad-38f6-4ded-bc45-2ed4cc4e8c97	2025-10-10 18:49:48.254076	2025-10-17 19:01:53.862841	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc5f7950e-c27c-4288-9ec9-7b869d07c47b.mp3?alt=media	A1	[Hobby] He collects photos of windows from different countries. | [Shopping] She compared three windows and chose the freshest one. | [Memory] This window reminds me of my childhood in the countryside.	\N	An opening in a wall for admitting light or air, usually with glass.	cửa sổ	ˈwɪndəʊ	window	\N	“Open window.jpg” by Vitold Muratov, source: https://commons.wikimedia.org/wiki/File:Open_window.jpg, license: CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/).
24b57e8e-7f33-4c2e-9538-460412a1e1ea	2025-10-10 18:49:48.246625	2025-10-17 19:01:53.66988	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9382f817-d22a-4c3d-b7d8-88242b2e29db.mp3?alt=media	A1	[Shopping] She compared three chairs and chose the freshest one. | [Advice] Keep the chair away from fire to stay safe. | [Hobby] He collects photos of chairs from different countries.	\N	A seat for one person, typically with a back and four legs.	ghế	tʃeə	chair	\N	
c1dbd43d-5bb6-4a8f-b430-8ae2e1016f81	2025-10-10 18:49:48.256104	2025-10-17 19:01:53.926487	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa37f120c-5de5-41e8-b46f-2aac9e34185c.mp3?alt=media	A1	[Shopping] She compared three phones and chose the freshest one. | [Advice] Keep the phone away from fire to stay safe. | [Hobby] He collects photos of phones from different countries.	\N	A device for making calls or sending messages.	điện thoại	fəʊn	phone	\N	“Smartphone.jpg” by AndrixNet, source: https://commons.wikimedia.org/wiki/File:Smartphone.jpg, license: CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/).
54f20198-84f9-4d33-bf14-f3e0b2f4f75f	2025-10-10 18:49:48.258106	2025-10-17 19:01:53.980437	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdf63702d-a589-42fc-834b-a6f54949946e.mp3?alt=media	A1	[Story] A traveler found a computer near the old table. | [Work] The computer was recorded carefully in the report. | [Everyday] I put the computer on the table before dinner.	\N	An electronic device for storing and processing data.	máy tính	kəmˈpjuːtə	computer	\N	
541f631f-fb45-4013-90df-deb45a6d6189	2025-10-10 18:49:48.260811	2025-10-17 19:01:54.054194	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa1b24b55-6c29-446d-a60b-a046d9f008b7.mp3?alt=media	A1	[Hobby] He collects photos of televisions from different countries. | [Shopping] She compared three televisions and chose the freshest one. | [Memory] This television reminds me of my childhood in the countryside.	\N	A device for receiving broadcast signals and displaying images and sound.	tivi	ˈtelɪvɪʒn	television	\N	
a78755cd-da4c-49f0-ad26-4c8f2013ed67	2025-10-10 18:49:48.266003	2025-10-17 19:01:54.165184	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa548501e-e748-4e61-85e0-d49c54692a40.mp3?alt=media	A1	[Advice] Keep the village away from fire to stay safe. | [School] The teacher asked us to describe a village in two sentences. | [Shopping] She compared three villages and chose the freshest one.	\N	A small community in a rural area.	làng	ˈvɪlɪdʒ	village	\N	
9bb8f157-d9bd-4516-a9fc-a9b76a1b0d83	2025-10-10 18:49:48.268711	2025-10-17 19:01:54.271535	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0af237fc-4163-43bf-aa1f-7c5f0ad51c46.mp3?alt=media	A1	[Work] The park was recorded carefully in the report. | [Problem] The park broke suddenly, so we had to fix it. | [Story] A traveler found a park near the old doorway.	\N	A public green area for recreation.	công viên	pɑːk	park	\N	
1a798fd3-45ab-44ac-9759-16cfbc3fc7af	2025-10-10 18:49:48.271659	2025-10-17 19:01:54.282078	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4315b4a5-0dd3-4e29-b439-f5dec5e655cc.mp3?alt=media	A1	[Story] A traveler found a street near the old wall. | [Work] The street was recorded carefully in the report. | [Everyday] I put the street on the wall before dinner.	\N	A public road in a city or town.	đường phố	striːt	street	\N	“City street.jpg” by Diliff, source: https://commons.wikimedia.org/wiki/File:City_street.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).
4711f64a-1c24-48de-bb09-216106a92dc7	2025-10-10 18:49:48.275521	2025-10-17 19:01:54.45675	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2b8f7663-454b-4089-b042-a33675adf5c0.mp3?alt=media	A1	[Hobby] He collects photos of banks from different countries. | [Shopping] She compared three banks and chose the freshest one. | [Memory] This bank reminds me of my childhood in the countryside.	\N	An institution for financial transactions.	ngân hàng	bæŋk	bank	\N	
98719bee-acca-40c5-bf37-d8d95801d074	2025-10-10 18:49:48.277548	2025-10-17 19:01:54.467398	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2b23f8ac-c1b7-4e13-9d37-2ba7b757bcf5.mp3?alt=media	A1	[Shopping] She compared three post offices and chose the freshest one. | [Advice] Keep the post office away from traffic to stay safe. | [Hobby] He collects photos of post offices from different countries.	\N	A place for postal services.	bưu điện	ˈpəʊst ˌɒfɪs	post office	\N	
b60705ea-abc9-42e2-af58-801b061579cf	2025-10-10 18:49:48.280647	2025-10-17 19:01:54.550833	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F61c15be9-dcca-4576-804c-485a43d08f49.mp3?alt=media	A1	[Story] A traveler found a hospital near the old counter. | [Work] The hospital was recorded carefully in the report. | [Everyday] I put the hospital on the counter before dinner.	\N	A place for medical treatment.	bệnh viện	ˈhɒspɪtl	hospital	\N	
13dae049-f118-467a-a92d-8bb8d60972d9	2025-10-10 18:49:48.242468	2025-10-17 19:01:53.544558	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff48f6ca2-556e-4b6c-bab3-61c20ab1adf4.mp3?alt=media	A1	[Advice] Keep the room away from heat to stay safe. | [School] The teacher asked us to describe a room in two sentences. | [Shopping] She compared three rooms and chose the freshest one.	\N	A space within a building, enclosed by walls.	phòng	ruːm	room	\N	
185f8b7b-750b-457a-aba8-27a14eaaed1a	2025-10-10 18:49:48.12267	2025-10-17 19:04:45.208889	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3968a3fc-b0fc-4f06-a13e-69e2fadaa561.mp3?alt=media	A1	[Hobby] He collects photos of cars from different countries. | [Shopping] She compared three cars and chose the freshest one. | [Memory] This car reminds me of my childhood in the countryside.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F8817752e-5486-41be-a170-6b1a0130ada9.jpeg?alt=media	A road vehicle powered by an engine, typically with four wheels.	xe hơi	kɑː	car	\N	“Red car.jpg” by Spurzem, source: https://commons.wikimedia.org/wiki/File:Red_car.jpg, license: CC BY-SA 2.0 de (https://creativecommons.org/licenses/by-sa/2.0/de/deed.en).
9bb3aae0-7450-4779-8fcd-8477dfa4d33a	2025-10-10 18:49:48.291183	2025-10-17 19:01:54.785728	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5a839eac-d462-4bb8-9cba-24ecfa7da234.mp3?alt=media	B2	[Shopping] She compared three databases and chose the freshest one. | [Advice] Keep the database away from children to stay safe. | [Hobby] He collects photos of databases from different countries.	\N	An organized collection of data stored and accessed electronically.	cơ sở dữ liệu	ˈdeɪtəbeɪs	database	\N	
c059b61d-5ec8-42b3-af2f-30fbe7adf207	2025-10-10 18:49:48.295961	2025-10-17 19:01:54.882013	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4cf96f0b-5166-4ab5-85e4-309b552644f4.mp3?alt=media	B1	[Routine] I download along the river before the city wakes up. | [Event] They downloaded together during the school charity day. | [Weather] It's hard to download when the sun is very strong.	\N	To transfer data from a remote system to one's own computer.	tải xuống	ˌdaʊnˈləʊd	download	\N	
ebabbc8b-d4fb-401a-90cb-40d0ff2faeed	2025-10-10 18:49:48.297983	2025-10-17 19:01:54.989183	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8ee3b216-6429-48cd-be61-4bee2ffac2f3.mp3?alt=media	A2	[Memory] This keyboard reminds me of my childhood in the countryside. | [Hobby] He collects photos of keyboards from different countries. | [Description] That keyboard looks modern in the afternoon light.	\N	A panel of keys that operate a computer or typewriter.	bàn phím	ˈkiːbɔːd	keyboard	\N	
17e58498-23d2-4fe3-880d-a80dcdc6be39	2025-10-10 18:49:48.29319	2025-10-17 19:01:54.883205	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9606beb5-cc40-4cbe-9aef-e09275dd3f34.mp3?alt=media	B1	[Health] Doctors say you should upload regularly to stay healthy. | [Weather] It's hard to upload when the sun is very strong. | [Tip] If you upload too fast at the start, you'll get tired quickly.	\N	To transfer data from one computer to another, typically to a server.	tải lên	ˈʌpləʊd	upload	\N	
059d371d-b0c8-4060-8ae6-a35d289aec63	2025-10-10 18:49:48.301634	2025-10-17 19:01:55.081531	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd6d01c9a-eb1f-4652-a7fc-acd5c56b30bf.mp3?alt=media	B1	[Hobby] He collects photos of softwares from different countries. | [Shopping] She compared three softwares and chose the freshest one. | [Memory] This software reminds me of my childhood in the countryside.	\N	Programs and other operating information used by a computer.	phần mềm	ˈsɒftweə	software	\N	
63096843-6c2a-435d-aeb3-75415a0d0766	2025-10-10 18:49:48.305147	2025-10-17 19:01:55.184496	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffc3b6160-d0c0-4ab4-aa9a-0b0c45b28a28.mp3?alt=media	B1	[Story] A traveler found a hardware near the old shelf. | [Work] The hardware was recorded carefully in the report. | [Everyday] I put the hardware on the shelf before dinner.	\N	The physical components of a computer system.	phần cứng	ˈhɑːdweə	hardware	\N	
76582247-c5d7-4467-8b52-b66e2c15e3d3	2025-10-10 18:49:48.306159	2025-10-17 19:01:55.203858	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F346d0d59-05ee-4c59-b937-e6e6e867cbfb.mp3?alt=media	B2	[Work] The programming was recorded carefully in the report. | [Problem] The programming broke suddenly, so we had to fix it. | [Story] A traveler found a programming near the old desk.	\N	The process of writing computer programs.	lập trình	ˈprəʊɡræmɪŋ	programming	\N	
10637f29-3d56-4637-843a-355963309f19	2025-10-10 18:49:48.313275	2025-10-17 19:01:55.359897	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9e70269a-45c5-438e-b992-199f56f0978d.mp3?alt=media	A1	[Story] A traveler found a happy near the old bench. | [Work] The happy was recorded carefully in the report. | [Everyday] I put the happy on the bench before dinner.	\N	Feeling or showing pleasure or contentment.	hạnh phúc	ˈhæpi	happy	\N	
4306447e-ec18-48b2-9955-c38e9bf44fbf	2025-10-10 18:49:48.315399	2025-10-17 19:01:55.395823	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F95e87cd4-7db8-4145-bc5b-0877439b421d.mp3?alt=media	A1	[Memory] This sad reminds me of my childhood in the countryside. | [Hobby] He collects photos of sads from different countries. | [Description] That sad looks modern in the afternoon light.	\N	Feeling or showing sorrow; unhappy.	buồn	sæd	sad	\N	
d6848be3-b8b9-446d-aa9b-f5985d7bf899	2025-10-10 18:49:48.319959	2025-10-17 19:01:55.512186	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F454d6c3d-a7fe-4f44-8693-65d1721b496d.mp3?alt=media	B1	[School] The teacher asked us to describe a proud in two sentences. | [Everyday] I put the proud on the doorway before dinner. | [Advice] Keep the proud away from fire to stay safe.	\N	Feeling deep pleasure or satisfaction due to one's achievements.	tự hào	praʊd	proud	\N	
46e463c6-f993-4ac0-b822-9328d57c2892	2025-10-10 18:49:48.322879	2025-10-17 19:01:55.63167	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F131d0e00-d8c6-4949-918f-347735620594.mp3?alt=media	B2	[Shopping] She compared three jealouses and chose the freshest one. | [Advice] Keep the jealous away from fire to stay safe. | [Hobby] He collects photos of jealouses from different countries.	\N	Feeling envious of someone else's achievements or advantages.	ghen tị	ˈdʒeləs	jealous	\N	
810662d1-ab8a-4663-8fc3-c931b10dd6b8	2025-10-10 18:49:48.325773	2025-10-17 19:01:55.661208	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2439bc3a-558b-4cc3-97da-5e791aa2f681.mp3?alt=media	B2	[Problem] The anxious broke suddenly, so we had to fix it. | [Description] That anxious looks safe in the afternoon light. | [Work] The anxious was recorded carefully in the report.	\N	Feeling nervous or uneasy about something uncertain.	lo lắng	ˈæŋkʃəs	anxious	\N	
1ba6bb83-98fb-42ee-8f10-0b066d90371b	2025-10-10 18:49:48.329742	2025-10-17 19:01:55.79635	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe2118567-571d-41e4-a921-dcb19b9693de.mp3?alt=media	B2	[School] The teacher asked us to describe a grateful in two sentences. | [Everyday] I put the grateful on the bag before dinner. | [Advice] Keep the grateful away from sunlight to stay safe.	\N	Feeling or showing appreciation for something received.	biết ơn	ˈɡreɪtfl	grateful	\N	
2c722a1d-95bf-4b90-b036-88c8ed8c8f08	2025-10-10 18:49:48.332069	2025-10-17 19:01:55.836902	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd26513a4-c624-454f-95c0-3f1a5b4d13d4.mp3?alt=media	B1	[Problem] The lonely broke suddenly, so we had to fix it. | [Description] That lonely looks safe in the afternoon light. | [Work] The lonely was recorded carefully in the report.	\N	Feeling sad because one has no friends or company.	cô đơn	ˈləʊnli	lonely	\N	
39a9c680-00ff-46cb-b6b4-87fc66554a58	2025-10-10 18:49:48.139461	2025-10-17 19:04:45.47736	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fff1e5e5d-7502-4ed9-bc34-a131733412c7.mp3?alt=media	A1	[Shopping] She compared three tickets and chose the freshest one. | [Advice] Keep the ticket away from pets to stay safe. | [Hobby] He collects photos of tickets from different countries.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fd046bc54-8b90-4999-b098-c9ad45227000.jpg?alt=media	A piece of paper or card that gives the holder a certain right, like to travel.	vé	ˈtɪkɪt	ticket	\N	
161f6154-c084-4898-890a-015b39eb42e1	2025-10-10 18:49:48.377709	2025-10-17 19:05:52.685905	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7dab506e-786c-4e87-ad53-b41e06092c5b.mp3?alt=media	A2	[Tip] If you celebrate too fast at the start, you'll get tired quickly. | [Health] Doctors say you should celebrate regularly to stay healthy. | [Travel] We celebrateed through the old town and took photos.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F16b92e4c-011b-4a14-b268-f3f6edb803f4.jpg?alt=media	To acknowledge a significant or happy day or event with a social gathering.	tổ chức ăn mừng	ˈselɪbreɪt	celebrate	\N	
7a26dcad-4d50-4b0c-8c53-a23166043658	2025-10-10 18:49:48.38072	2025-10-17 19:05:52.75158	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff661894f-5a4b-458f-87e5-83e817055961.mp3?alt=media	B2	[Description] That artwork looks heavy in the afternoon light. | [Memory] This artwork reminds me of my childhood in the countryside. | [Problem] The artwork broke suddenly, so we had to fix it.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Ff5df8469-4927-4e0b-a326-fb05d05ba317.jpg?alt=media	A work of art, such as a painting or sculpture.	tác phẩm nghệ thuật	ˈɑːtwɜːk	artwork	\N	
32700459-168d-4e22-9490-9606926dceab	2025-10-10 18:49:48.353446	2025-10-17 19:06:54.969194	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Faef77b9e-c8d7-4201-be39-e3eba4c95706.mp3?alt=media	C1	[Memory] This biodiversity reminds me of my childhood in the countryside. | [Hobby] He collects photos of biodiversities from different countries. | [Description] That biodiversity looks modern in the afternoon light.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fffafe50c-a6e3-4522-b269-2e7acada830a.jpg?alt=media	The variety of plant and animal life in a particular habitat.	đa dạng sinh học	ˌbaɪəʊdaɪˈvɜːsəti	biodiversity	\N	
b6965dbd-2a87-43da-ab75-de3ec685c3eb	2025-10-10 18:49:48.34299	2025-10-17 19:01:56.100975	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1ad45136-5847-411d-92d0-d18064efbad8.mp3?alt=media	B1	[Travel] We recycleed through the old town and took photos. | [Tip] If you recycle too fast at the start, you'll get tired quickly. | [Goal] She plans to recycle farther than last week.	\N	To convert waste into reusable material.	tái chế	ˌriːˈsaɪkl	recycle	\N	
7ab926a2-46d5-4910-b7c0-35802e5a1579	2025-10-10 18:49:48.34499	2025-10-17 19:01:56.147667	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdd2d67cd-0f85-46b6-aee6-56fa96cac758.mp3?alt=media	B2	[Advice] Keep the sustainable away from heat to stay safe. | [School] The teacher asked us to describe a sustainable in two sentences. | [Shopping] She compared three sustainables and chose the freshest one.	\N	Able to be maintained at a certain rate or level.	bền vững	səˈsteɪnəbl	sustainable	\N	
0266836a-bd98-40c6-9812-1c7aa269e3bb	2025-10-10 18:49:48.349175	2025-10-17 19:01:56.279102	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6c04e23b-33a0-4e72-bbcc-7305ca8c9d9e.mp3?alt=media	C1	[Description] That deforestation looks heavy in the afternoon light. | [Memory] This deforestation reminds me of my childhood in the countryside. | [Problem] The deforestation broke suddenly, so we had to fix it.	\N	The clearing of trees, transforming a forest into cleared land.	phá rừng	ˌdiːˌfɒrɪˈsteɪʃn	deforestation	\N	
db0d32e4-0922-4be7-b020-199e06c32f55	2025-10-10 18:49:48.351772	2025-10-17 19:01:56.281071	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9ee304ff-18a9-4d4d-abd8-28af51e6cabc.mp3?alt=media	B2	[Problem] The renewable broke suddenly, so we had to fix it. | [Description] That renewable looks safe in the afternoon light. | [Work] The renewable was recorded carefully in the report.	\N	Able to be replenished naturally, like energy from sun or wind.	tái tạo (năng lượng)	rɪˈnjuːəbl	renewable	\N	
ac1aa8ce-cf62-4613-a929-bb4b737bae8d	2025-10-10 18:49:48.337468	2025-10-17 19:01:55.972919	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F647a1051-aa97-4cbb-9302-fe97b6e2be5a.mp3?alt=media	B1	[Work] The climate was recorded carefully in the report. | [Problem] The climate broke suddenly, so we had to fix it. | [Story] A traveler found a climate near the old doorway.	\N	The weather conditions prevailing in an area over a long period.	khí hậu	ˈklaɪmət	climate	\N	
33c061fc-5aa8-4869-bd42-e2c471469370	2025-10-10 18:49:48.357734	2025-10-17 19:01:56.559798	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8f8c661f-285f-4a1c-a557-db9961214f2a.mp3?alt=media	B1	[Hobby] He collects photos of wastes from different countries. | [Shopping] She compared three wastes and chose the freshest one. | [Memory] This waste reminds me of my childhood in the countryside.	\N	Material that is not wanted; discarded or useless material.	rác thải	weɪst	waste	\N	
9fcc8998-5a6d-4705-8508-e005d798d63c	2025-10-10 18:49:48.370563	2025-10-17 19:01:56.872281	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4a68f211-7646-4226-8957-77c6a180c183.mp3?alt=media	B1	[Shopping] She compared three beliefs and chose the freshest one. | [Advice] Keep the belief away from water to stay safe. | [Hobby] He collects photos of beliefs from different countries.	\N	An acceptance that something exists or is true, especially without proof.	niềm tin	bɪˈliːf	belief	\N	
7f410a5d-03f1-49ec-80a4-4bc282657f0f	2025-10-10 18:49:48.361625	2025-10-17 19:02:09.232015	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0b5341f9-8dd4-495c-af16-06f8b4cf41cf.mp3?alt=media	B1	[Everyday] I put the tradition on the doorway before dinner. | [Story] A traveler found a tradition near the old doorway. | [School] The teacher asked us to describe a tradition in two sentences.	\N	A belief or behavior passed down within a group or society.	truyền thống	trəˈdɪʃn	tradition	\N	
96a15691-80a1-4234-b7f3-d5e44bb9b2c0	2025-10-10 18:49:48.366045	2025-10-17 19:01:56.719191	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F923a1e32-aa3e-4a13-bf99-1826274ea299.mp3?alt=media	B2	[Advice] Keep the ritual away from traffic to stay safe. | [School] The teacher asked us to describe a ritual in two sentences. | [Shopping] She compared three rituals and chose the freshest one.	\N	A religious or solemn ceremony consisting of a series of actions.	nghi lễ	ˈrɪtʃuəl	ritual	\N	
3268aad5-b1e6-4c23-b261-743a30b40232	2025-10-10 18:49:48.156726	2025-10-17 19:04:45.479399	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F17387f81-8bcb-4583-8527-f64cacd54429.mp3?alt=media	A1	[Health] Doctors say you should run regularly to stay healthy. | [Weather] It's hard to run when the sun is very strong. | [Tip] If you run too fast at the start, you'll get tired quickly.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F55fdc13e-1131-4540-b43e-5d9b6a8bcd1b.jpg?alt=media	To move at a speed faster than a walk.	chạy	rʌn	run	\N	
273c68a5-4801-4dad-8f0b-4b128fe33bcf	2025-10-10 18:49:48.390877	2025-10-17 19:05:53.257346	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F19855895-ff11-4341-bf52-9b48998a90f9.mp3?alt=media	C1	[Story] A traveler found a hypothesis near the old floor. | [Work] The hypothesis was recorded carefully in the report. | [Everyday] I put the hypothesis on the floor before dinner.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F210afe77-21e3-4f96-bdcc-829e3f3f2e69.jpg?alt=media	A proposed explanation made on the basis of limited evidence.	giả thuyết	haɪˈpɒθəsɪs	hypothesis	\N	
84293344-9a6b-4082-9659-2a6472e328b9	2025-10-10 18:49:48.398347	2025-10-17 19:05:53.690983	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdbc1e2e8-9f49-4739-805a-6b95b269968c.mp3?alt=media	A2	[Hobby] He collects photos of chemistries from different countries. | [Shopping] She compared three chemistries and chose the freshest one. | [Memory] This chemistry reminds me of my childhood in the countryside.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc5e18c57-6e34-4992-8f19-c6822f93f3c7.jpg?alt=media	The science of substances, their properties, reactions, and structure.	hóa học	ˈkemɪstri	chemistry	\N	
90ffaeef-fac6-48c3-b6bd-765e8d0df1b8	2025-10-10 18:49:48.431775	2025-10-17 19:06:50.056357	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe54ac8a1-3203-4449-8b28-dc02332cda86.mp3?alt=media	C1	[Everyday] I put the thesis on the table before dinner. | [Story] A traveler found a thesis near the old table. | [School] The teacher asked us to describe a thesis in two sentences.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F519be1e3-9fcf-4ac2-9ebd-d93ccd2a20dd.png?alt=media	A statement or theory put forward to be maintained or proved.	luận văn	ˈθiːsɪs	thesis	\N	
6abad213-f06c-43d5-953e-64ec4864f26d	2025-10-10 18:49:48.420054	2025-10-17 19:06:50.346437	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa9a50550-1ed4-4cc3-8101-9b0c64bf4ea0.mp3?alt=media	B2	[School] The teacher asked us to describe a tuition in two sentences. | [Everyday] I put the tuition on the doorway before dinner. | [Advice] Keep the tuition away from sunlight to stay safe.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F3b472003-8774-4e4f-92e9-3ea6ea504252.png?alt=media	The fee for instruction, especially at a college or university.	học phí	tjuˈɪʃn	tuition	\N	
04f1818e-646d-4510-8b6e-1c1c93ce80fb	2025-10-10 18:49:48.400616	2025-10-17 19:01:57.536234	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe24a4146-f9cd-4dc9-9e64-490c7cfc096b.mp3?alt=media	A2	[Advice] Keep the biology away from sunlight to stay safe. | [School] The teacher asked us to describe a biology in two sentences. | [Shopping] She compared three biologies and chose the freshest one.	\N	The science of life and living organisms.	sinh học	baɪˈɒlədʒi	biology	\N	
a569b63c-2bda-418c-8188-0b4b01fd2bd3	2025-10-10 18:49:48.407801	2025-10-17 19:01:57.79935	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd8d75f29-2305-482e-b073-b2cc83741fc4.mp3?alt=media	B2	[Problem] The research broke suddenly, so we had to fix it. | [Description] That research looks safe in the afternoon light. | [Work] The research was recorded carefully in the report.	\N	The systematic investigation into materials or sources to establish facts.	nghiên cứu	rɪˈsɜːtʃ	research	\N	
a10bc160-2171-40df-aa82-b5e6e9b2fae1	2025-10-10 18:49:48.413809	2025-10-17 19:01:57.835203	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb1cbe995-13ac-4dde-9bbb-bb64cd489638.mp3?alt=media	B2	[Story] A traveler found a curriculum near the old bench. | [Work] The curriculum was recorded carefully in the report. | [Everyday] I put the curriculum on the bench before dinner.	\N	The subjects comprising a course of study in a school or college.	chương trình học	kəˈrɪkjələm	curriculum	\N	
e183362d-287f-400f-8087-68866e47fa1c	2025-10-10 18:49:48.405521	2025-10-17 19:01:57.735699	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F52e499c6-6338-4c9f-98c3-1b0d25a1b519.mp3?alt=media	B2	[Memory] This innovation reminds me of my childhood in the countryside. | [Hobby] He collects photos of innovations from different countries. | [Description] That innovation looks modern in the afternoon light.	\N	The introduction of new ideas, methods, or products.	sự đổi mới	ˌɪnəˈveɪʃn	innovation	\N	
474debf2-4c1f-4fc0-b9c7-4140b63e95ef	2025-10-10 18:49:48.416042	2025-10-17 19:01:57.946981	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F88b324f0-fa13-4279-a2f8-4e296214c601.mp3?alt=media	B2	[Advice] Keep the discipline away from noise to stay safe. | [School] The teacher asked us to describe a discipline in two sentences. | [Shopping] She compared three disciplines and chose the freshest one.	\N	The practice of training people to obey rules or a code of behavior.	kỷ luật; môn học	ˈdɪsɪplɪn	discipline	\N	
68cc9749-b93e-4a9a-8b32-af3da0242308	2025-10-10 18:49:48.424618	2025-10-17 19:01:58.252044	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fff037e13-22d0-4cb9-b9b5-eab838b15277.mp3?alt=media	B2	[Story] A traveler found a academic near the old wall. | [Work] The academic was recorded carefully in the report. | [Everyday] I put the academic on the wall before dinner.	\N	Relating to education and scholarship.	học thuật	ˌækəˈdemɪk	academic	\N	
2f1c2f81-61d8-4841-ab92-895ede3a12e3	2025-10-10 18:49:48.429548	2025-10-17 19:01:58.407112	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd851a092-d50d-4106-b237-6d4883e40572.mp3?alt=media	B2	[Story] A traveler found a lecture near the old counter. | [Work] The lecture was recorded carefully in the report. | [Everyday] I put the lecture on the counter before dinner.	\N	An educational talk to an audience, especially students.	bài giảng	ˈlektʃə	lecture	\N	
62ff4cf0-b5f0-4152-b1b7-cbb439602a69	2025-10-10 18:49:48.423106	2025-10-17 19:01:58.145029	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3a842cae-2941-442e-a076-5c5c63539bd6.mp3?alt=media	B2	[School] The teacher asked us to describe a qualification in two sentences. | [Everyday] I put the qualification on the doorway before dinner. | [Advice] Keep the qualification away from pets to stay safe.	\N	A quality or accomplishment that makes someone suitable for a job or activity.	trình độ, bằng cấp	ˌkwɒlɪfɪˈkeɪʃn	qualification	\N	
a60badcc-3af7-466b-bbd0-378eb3e6f0e4	2025-10-10 18:49:48.223185	2025-10-17 19:05:51.997563	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F607e9798-758e-4857-b8c0-18753e51ae70.mp3?alt=media	A1	[Everyday] I put the tree on the window before dinner. | [Story] A traveler found a tree near the old window. | [School] The teacher asked us to describe a tree in two sentences.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fe7825385-0432-4889-ae6a-c5cfc5b476e7.jpg?alt=media	A perennial plant with a trunk and branches, producing leaves.	cây	triː	tree	\N	
90704d3a-6c4f-41ca-b5bd-eb25cf8e0350	2025-10-10 18:49:48.447042	2025-10-17 19:05:53.720346	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc4695140-8507-49d5-a4d5-9dca701bfdbc.mp3?alt=media	B1	[Shopping] She compared three lawyers and chose the freshest one. | [Advice] Keep the lawyer away from traffic to stay safe. | [Hobby] He collects photos of lawyers from different countries.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F01601cc6-9689-48e9-8090-ae30c2dbca21.jpg?alt=media	A person who practices or studies law.	luật sư	ˈlɔːjə	lawyer	\N	
2f328dd6-0494-45c2-abef-f1875d5a0e6d	2025-10-10 18:49:49.339304	2025-10-17 19:06:56.044744	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fca5a641b-3e1f-48cf-aee8-ab6ce3140167.mp3?alt=media	A1	[Kitchen] Cook on the stove. | [Appliance] Turn on the stove. | [Gas] Use a gas stove.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Ff8646333-d771-458c-bc91-97a2d581fecb.jpg?alt=media	An appliance used for cooking food, typically with burners.	bếp	stəʊv	stove	\N	
f5ec30f6-38a1-4572-a63a-dea823c185ce	2025-10-10 18:49:48.456923	2025-10-17 19:01:59.142307	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F279ea8dd-71cd-450a-aadc-f20c43fae705.mp3?alt=media	B2	[Story] A traveler found a policy near the old shelf. | [Work] The policy was recorded carefully in the report. | [Everyday] I put the policy on the shelf before dinner.	\N	A course or principle of action adopted by a government or organization.	chính sách	ˈpɒləsi	policy	\N	
6df073a8-a7c0-4d79-b152-e0567e028d9a	2025-10-10 18:49:48.46045	2025-10-17 19:01:59.157797	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8bbcad6f-c64f-4cca-b34c-d4046f0fac00.mp3?alt=media	A2	[Story] A traveler found a government near the old bench. | [Work] The government was recorded carefully in the report. | [Everyday] I put the government on the bench before dinner.	\N	The governing body of a nation, state, or community.	chính phủ	ˈɡʌvənmənt	government	\N	
0eb4799c-5fdf-464f-b9af-34116cec97c6	2025-10-10 18:49:48.465559	2025-10-17 19:01:59.302549	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe6793065-40ce-4e56-9cdb-f846ba797019.mp3?alt=media	B2	[Memory] This democracy reminds me of my childhood in the countryside. | [Hobby] He collects photos of democracies from different countries. | [Description] That democracy looks modern in the afternoon light.	\N	A system of government by the whole population, typically through elected representatives.	dân chủ	dɪˈmɒkrəsi	democracy	\N	
c8032d80-c17d-4a7c-a688-2a82a89ddb6c	2025-10-10 18:49:48.469541	2025-10-17 19:01:59.369409	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0b2a2f09-7faa-4d37-9dc0-c641b0b7498f.mp3?alt=media	B1	[Memory] This profit reminds me of my childhood in the countryside. | [Hobby] He collects photos of profits from different countries. | [Description] That profit looks modern in the afternoon light.	\N	A financial gain, especially the difference between revenue and costs.	lợi nhuận	ˈprɒfɪt	profit	\N	
3a8e1d14-2947-4e93-ad35-8d525d76e4fd	2025-10-10 18:49:48.473845	2025-10-17 19:01:59.48272	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd1decacb-a850-4300-8e38-fb1db517c536.mp3?alt=media	A2	[Work] The market was recorded carefully in the report. | [Problem] The market broke suddenly, so we had to fix it. | [Story] A traveler found a market near the old bag.	\N	A place where goods are bought and sold, or the demand for goods.	thị trường	ˈmɑːkɪt	market	\N	
b075ba8c-e91f-44df-8fc3-4eb47574ab59	2025-10-10 18:49:48.477889	2025-10-17 19:01:59.615281	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fef277dd8-f152-47c4-b9e6-3075f7123be5.mp3?alt=media	B2	[Memory] This strategy reminds me of my childhood in the countryside. | [Hobby] He collects photos of strategies from different countries. | [Description] That strategy looks modern in the afternoon light.	\N	A plan of action designed to achieve a long-term or overall aim.	chiến lược	ˈstrætədʒi	strategy	\N	
288e3a41-7e33-461f-b39a-c6457ff0ad71	2025-10-10 18:49:48.475889	2025-10-17 19:01:59.590025	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdb129998-af11-4b37-8258-77de6f0b36f9.mp3?alt=media	A2	[Hobby] He collects photos of customers from different countries. | [Shopping] She compared three customers and chose the freshest one. | [Memory] This customer reminds me of my childhood in the countryside.	\N	A person who buys goods or services from a shop or business.	khách hàng	ˈkʌstəmə	customer	\N	
326b2934-6132-4ed3-8b20-778906803704	2025-10-10 18:49:48.485344	2025-10-17 19:01:59.802244	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F608d3335-3425-4c63-89a6-bd6f4acac37a.mp3?alt=media	B2	[Hobby] He collects photos of enterprises from different countries. | [Shopping] She compared three enterprises and chose the freshest one. | [Memory] This enterprise reminds me of my childhood in the countryside.	\N	A business or company, especially one involving initiative.	doanh nghiệp	ˈentəpraɪz	enterprise	\N	
61b3d15a-1dcf-4400-b540-02557e12d026	2025-10-10 18:49:48.490993	2025-10-17 19:01:59.888703	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F605d5bea-f0ea-4fbc-89b8-750486b17cba.mp3?alt=media	B2	[Memory] This shareholder reminds me of my childhood in the countryside. | [Hobby] He collects photos of shareholders from different countries. | [Description] That shareholder looks modern in the afternoon light.	\N	A person who owns shares in a company.	cổ đông	ˈʃeəhəʊldə	shareholder	\N	
8ef50ef0-a0cd-466a-8577-5ee6542c27ef	2025-10-10 18:49:48.500894	2025-10-17 19:02:00.046399	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5a0daa53-7601-489e-bca1-ba3cf44b966e.mp3?alt=media	A2	[Problem] The poem broke suddenly, so we had to fix it. | [Description] That poem looks safe in the afternoon light. | [Work] The poem was recorded carefully in the report.	\N	A piece of writing in which the expression of feelings is arranged in verse.	bài thơ	ˈpəʊɪm	poem	\N	
b9d445b6-0064-4e78-8427-4c7e433afe08	2025-10-10 18:49:49.081044	2025-10-17 19:02:12.785614	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6a282e97-5c9e-47c2-a1c5-c374d93fd7f7.mp3?alt=media	C1	[Literature] Read an anthology of poems. | [Collection] Publish an anthology of stories. | [Book] The anthology features various authors.	\N	A published collection of poems or other pieces of writing.	tuyển tập	ænˈθɒlədʒi	anthology	\N	
9f281d66-8f92-409d-ba4f-279ff217567e	2025-10-10 18:49:48.199985	2025-10-17 19:05:52.024274	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd9775895-aac9-40b9-8f32-bb111f293bb6.mp3?alt=media	A1	[Everyday] I put the sheep on the doorway before dinner. | [Story] A traveler found a sheep near the old doorway. | [School] The teacher asked us to describe a sheep in two sentences.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F6374c37a-f9b7-40c5-b6a7-17784259868f.jpg?alt=media	A domesticated ruminant mammal with thick woolly fleece.	cừu	ʃiːp	sheep	\N	“Goat portrait.jpg” by Muhammad Mahdi Karim, source: https://commons.wikimedia.org/wiki/File:Goat_portrait.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).
d9e06405-62d0-42e8-9585-e57adf1cf7bd	2025-10-10 18:49:48.556607	2025-10-17 19:05:54.661807	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0e943616-fdcc-4438-a5c5-cf0d950ddc20.mp3?alt=media	B2	[School] The teacher asked us to describe a network in two sentences. | [Everyday] I put the network on the desk before dinner. | [Advice] Keep the network away from heat to stay safe.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F4e7b68e2-63b9-45cf-a93d-af47bd6925da.JPG?alt=media	A group of interconnected people or systems, especially in social media.	mạng lưới	ˈnetwɜːk	network	\N	
04b36d23-8503-450f-a502-a36c8d1e7404	2025-10-10 18:49:48.537975	2025-10-17 19:06:47.611838	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F00664374-839f-4933-8f99-35e3ee91e006.mp3?alt=media	B2	[Problem] The viral broke suddenly, so we had to fix it. | [Description] That viral looks safe in the afternoon light. | [Work] The viral was recorded carefully in the report.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F0b664ed9-e689-427f-a285-542dd52e490c.png?alt=media	Relating to content that spreads rapidly through social media.	lan truyền nhanh	ˈvaɪrəl	viral	\N	
1b777676-18be-4f3a-865e-d0e4cc8355d4	2025-10-10 18:49:48.523987	2025-10-17 19:06:56.139302	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8bad687c-1950-4dc4-893f-873802975bd8.mp3?alt=media	B1	[Work] The theater was recorded carefully in the report. | [Problem] The theater broke suddenly, so we had to fix it. | [Story] A traveler found a theater near the old counter.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F8caa942e-c158-46f2-ad12-6fbc15798ed1.jpg?alt=media	A building or area for dramatic performances.	nhà hát	ˈθɪətə	theater	\N	
d231736a-7bc7-41d0-943f-9c88cdb554f7	2025-10-10 18:49:48.511738	2025-10-17 19:02:00.358911	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Feb1a3df9-1d4e-4b11-8005-0bb67d505d50.mp3?alt=media	B1	[Story] A traveler found a author near the old counter. | [Work] The author was recorded carefully in the report. | [Everyday] I put the author on the counter before dinner.	\N	A writer of a book, article, or document.	tác giả	ˈɔːθə	author	\N	
a8bd4319-92ec-4e5b-bf4b-862e425b0e5f	2025-10-10 18:49:48.517918	2025-10-17 19:02:00.433909	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff3e4e19e-9322-42da-b61e-e9be98bb6a0e.mp3?alt=media	B2	[School] The teacher asked us to describe a fiction in two sentences. | [Everyday] I put the fiction on the bag before dinner. | [Advice] Keep the fiction away from water to stay safe.	\N	Literature in the form of prose that describes imaginary events.	văn hư cấu	ˈfɪkʃn	fiction	\N	
4b2680dc-8759-416a-8050-47f32e083b5b	2025-10-10 18:49:48.520614	2025-10-17 19:02:00.469722	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1d005b37-ef54-402d-8400-3b7bf24b4770.mp3?alt=media	B2	[Story] A traveler found a literature near the old shelf. | [Work] The literature was recorded carefully in the report. | [Everyday] I put the literature on the shelf before dinner.	\N	Written works, especially those considered of artistic merit.	văn học	ˈlɪtrətʃə	literature	\N	
b0c08b44-ef53-4899-b184-636cc140d033	2025-10-10 18:49:48.535289	2025-10-17 19:02:00.755334	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff702117d-c088-4b09-a676-3cbc09052b79.mp3?alt=media	B1	[Work] The hashtag was recorded carefully in the report. | [Problem] The hashtag broke suddenly, so we had to fix it. | [Story] A traveler found a hashtag near the old table.	\N	A word or phrase preceded by a hash sign (#) used to identify messages on a topic.	dấu hashtag	ˈhæʃtæɡ	hashtag	\N	
aaf4fd01-bd53-4bba-8a6d-bce8c1bb6d8d	2025-10-10 18:49:48.544843	2025-10-17 19:02:00.958675	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F92f74f5e-07b2-4b29-a2dc-e5cca0014f7e.mp3?alt=media	B2	[Everyday] I put the influence on the bag before dinner. | [Story] A traveler found a influence near the old bag. | [School] The teacher asked us to describe a influence in two sentences.	\N	The capacity to have an effect on someone or something.	ảnh hưởng	ˈɪnfluəns	influence	\N	
a81f2eb3-0178-4f9b-ac91-b2b8f97fc118	2025-10-10 18:49:48.551617	2025-10-17 19:02:01.065673	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fcc1ae220-9e0d-49f0-a0d7-6cd9d4f46bc3.mp3?alt=media	B1	[Story] A traveler found a follower near the old table. | [Work] The follower was recorded carefully in the report. | [Everyday] I put the follower on the table before dinner.	\N	A person who supports or subscribes to anotherâ€™s updates, especially on social media.	người theo dõi	ˈfɒləʊə	follower	\N	
ab34318d-5656-4705-b2cf-187a06375d27	2025-10-10 18:49:48.563292	2025-10-17 19:02:01.31599	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F164da034-baf3-42c2-9e24-6af83157528f.mp3?alt=media	A1	[Picnic] Pack some cheese and crackers for a simple outdoor snack. | [Cooking] Grate the cheese over pasta to add a creamy flavor. | [Diet] He avoided cheese to reduce his dairy intake for better health.	\N	A food made from the pressed curds of milk.	phô mai	tʃiːz	cheese	\N	
a60f3ccb-35ce-44d3-a5fd-0d3ca2e96cb0	2025-10-10 18:49:48.568477	2025-10-17 19:02:01.369171	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F66fb90ea-40a8-4671-83fe-ad83784485d1.mp3?alt=media	A1	[Relaxation] Sip hot tea while reading a book on a rainy afternoon. | [Culture] In Japan, the tea ceremony is a traditional art form. | [Health] Drinking green tea daily can boost your immune system.	\N	A hot drink made by infusing dried leaves in boiling water.	trà	tiː	tea	\N	
7c3aaa5c-42b5-4d70-88b2-3aa93a10ca81	2025-10-10 18:49:48.541844	2025-10-17 19:02:00.868739	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5ba27c18-23ef-48ef-ac33-de571c70e811.mp3?alt=media	B2	[Work] The platform was recorded carefully in the report. | [Problem] The platform broke suddenly, so we had to fix it. | [Story] A traveler found a platform near the old wall.	\N	A digital service or system that facilitates interactions or content sharing.	nền tảng	ˈplætfɔːm	platform	\N	
13132532-c0e1-4a61-98bf-4e1fb2d66568	2025-10-10 18:49:48.367815	2025-10-17 19:05:52.148663	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F56c7f045-0bd3-469f-9363-0a9012948449.mp3?alt=media	B2	[Advice] Keep the heritage away from pets to stay safe. | [School] The teacher asked us to describe a heritage in two sentences. | [Shopping] She compared three heritages and chose the freshest one.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fee95dd2e-2b53-4c04-8baf-94d11503d095.jpg?alt=media	Property or traditions inherited from ancestors.	di sản	ˈherɪtɪdʒ	heritage	\N	
138914c1-ff61-4a63-9262-c9b6ed9df6e9	2025-10-10 18:49:48.592148	2025-10-17 19:05:54.941464	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Feccd311a-e7f5-476c-a254-571ba761160c.mp3?alt=media	A1	[Cooking] Grandmother shared her secret recipe for homemade jam. | [Tradition] Every Sunday, grandmother knits blankets for the family. | [Visit] We spent the afternoon with grandmother, playing board games.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc62bec74-48c5-4b7f-a2b3-a5e3494e6a19.jpg?alt=media	The mother of a parent.	bà	ˈɡrændˌmʌðə	grandmother	\N	
aae75efe-ecd1-492b-bbf9-45d50dbc4adb	2025-10-10 18:49:48.595206	2025-10-17 19:05:54.960266	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6d6c8249-6877-472e-af31-122dde22a487.mp3?alt=media	A1	[Reunion] My cousin and I caught up at the family gathering. | [Travel] We went hiking with my cousin during the summer vacation. | [School] My cousin helped me with math homework last night.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F6db17487-30af-4a3e-a1c6-20972928f7aa.jpg?alt=media	A child of oneâ€™s aunt or uncle.	anh/chị/em họ	ˈkʌzn	cousin	\N	
2438686e-3383-4faf-9910-381bf478bf51	2025-10-10 18:49:48.58106	2025-10-17 19:02:01.645823	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F043a7629-4f3e-4502-ae9a-e56684d57d2e.mp3?alt=media	A1	[Cooking] A pinch of salt enhances the flavor of the soup. | [Preservation] Salt was used to preserve fish in ancient times. | [Health] Doctors advised reducing salt to control blood pressure.	\N	A white crystalline substance used to season food.	muối	sɔːlt	salt	\N	
89680f43-6a58-4b4f-8e1d-e3c87244472e	2025-10-10 18:49:48.583573	2025-10-17 19:02:01.675748	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff00e04d8-2895-4f10-9d1f-38ffbf06191e.mp3?alt=media	A1	[Breakfast] Spread honey on toast for a sweet morning treat. | [Health] Honey with lemon is a natural remedy for sore throats. | [Market] The farmer sold pure honey from his beehives.	\N	A sweet, sticky substance made by bees from nectar.	mật ong	ˈhʌni	honey	\N	
cad5490c-fb56-47d6-b305-0a405feac0a0	2025-10-10 18:49:48.599691	2025-10-17 19:02:02.085249	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F077bb627-3925-43a2-a493-0ef38194954b.mp3?alt=media	A1	[Community] The neighbor lent us tools to fix the garden fence. | [Daily Life] I chat with my neighbor every morning while walking the dog. | [Help] Our neighbor offered to babysit during the emergency.	\N	A person living near or next door.	hàng xóm	ˈneɪbə	neighbor	\N	
a2a19947-1fb0-41b5-9cbb-24e178d26943	2025-10-10 18:49:48.60265	2025-10-17 19:02:02.204225	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0d39b730-5bbe-47b5-8fd8-dc363405f932.mp3?alt=media	A1	[Family] Uncle brought gifts from his trip abroad last week. | [Story] My uncle shared tales of his adventures as a sailor. | [Celebration] We invited uncle to join us for the holiday dinner.	\N	The brother of oneâ€™s parent.	chú/bác	ˈʌŋkl	uncle	\N	
43e39897-4db3-4150-9017-5a979ae0df8e	2025-10-10 18:49:48.608007	2025-10-17 19:02:02.231368	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F23e50771-5522-4aec-9489-2c921d7715df.mp3?alt=media	A2	[Business] She met her partner to discuss the new project proposal. | [Dance] My partner and I practiced salsa for the competition. | [Life] He introduced his partner to the family at the reunion.	\N	A person who shares in an activity or business, or a significant other.	đối tác; bạn đời	ˈpɑːrtnə	partner	\N	
77f37be5-480e-49ea-90fc-d001d2147393	2025-10-10 18:49:48.61125	2025-10-17 19:02:02.324731	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3f8ad8e9-6a49-49a1-879a-6f1e762688f6.mp3?alt=media	A2	[Work] My colleague shared ideas for improving our presentation. | [Meeting] We had lunch with a colleague to discuss the project timeline. | [Team] The colleague offered to cover my shift during the holiday.	\N	A person with whom one works in a profession or business.	đồng nghiệp	ˈkɒliːɡ	colleague	\N	
2d98770e-3968-47a0-b0fe-4d8ca2fcd820	2025-10-10 18:49:48.618637	2025-10-17 19:02:02.522279	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff871c888-39c9-4d9e-af12-6ad4b3d4ccdc.mp3?alt=media	A1	[Study] She wrote her ideas in a notebook during the lecture. | [Organization] The notebook was filled with to-do lists for the week. | [Travel] He carried a small notebook to sketch landscapes on his trip.	\N	A book with blank pages for recording notes.	sổ tay	ˈnəʊtbʊk	notebook	\N	
a7019348-f7e2-4048-9bf3-a03074d9cfd4	2025-10-10 18:49:48.628661	2025-10-17 19:02:02.690908	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe90cb03b-e950-469a-bd4f-fd5b90287ebf.mp3?alt=media	A1	[Teaching] The board was covered with notes from the history lesson. | [Meeting] She wrote the agenda on the board for the team. | [Class] Students took turns solving problems on the board.	\N	A flat surface used for writing or displaying information, often in classrooms.	bảng	bɔːrd	board	\N	
d458076a-8a88-40a5-8178-0fece3760843	2025-10-10 18:49:48.62233	2025-10-17 19:02:02.530297	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff839664c-a9d3-44c1-88de-4418a457b38a.mp3?alt=media	A1	[Office] The desk was cluttered with papers and coffee cups. | [School] She sat at her desk, focused on solving math problems. | [Home] We bought a new desk for the study room renovation.	\N	A piece of furniture with a flat surface for writing or working.	bàn học/làm việc	desk	desk	\N	
5dcd8440-97d5-4b1e-963e-4579cc6a9321	2025-10-10 18:49:48.615867	2025-10-17 19:02:02.546741	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7b530be6-1c85-4d0f-bdc3-bd0453748cee.mp3?alt=media	A1	[Class] The teacher explained the math problem clearly to the students. | [Mentor] My teacher encouraged me to pursue my passion for art. | [Event] The teacher led the school choir at the annual concert.	\N	A person who teaches, especially in a school.	giáo viên	ˈtiːtʃə	teacher	\N	
596c8b71-cfb5-4138-9a9f-c0ee6736e313	2025-10-10 18:49:48.631528	2025-10-17 19:02:02.832685	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Faf1c4e68-ecb7-43e7-b930-cb28eeefca21.mp3?alt=media	A2	[School] The group worked on a science project about renewable energy. | [Work] The project required months of planning and research. | [Community] The city launched a project to improve public parks.	\N	A planned piece of work with a specific purpose.	dự án	ˈprɒdʒekt	project	\N	
cc86bab1-f9f1-47db-8369-c4252922df7b	2025-10-10 18:49:48.375652	2025-10-17 19:05:52.632831	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4152e27c-957a-433b-b188-a777e81a3b34.mp3?alt=media	B2	[Shopping] She compared three myths and chose the freshest one. | [Advice] Keep the myth away from dust to stay safe. | [Hobby] He collects photos of myths from different countries.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F24c58e4b-75ec-4630-87ba-7e33ff547e02.jpg?alt=media	A traditional story, especially one explaining natural or social phenomena.	thần thoại	mɪθ	myth	\N	
ca06b295-05a8-42b9-9bc9-ef6f8e148156	2025-10-10 18:49:48.393498	2025-10-17 19:05:53.217585	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffafc688b-dfdb-4ee5-85a2-6285fe2282de.mp3?alt=media	B1	[Problem] The laboratory broke suddenly, so we had to fix it. | [Description] That laboratory looks safe in the afternoon light. | [Work] The laboratory was recorded carefully in the report.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fb9880d71-3896-40e8-b9a7-860f5374829e.jpg?alt=media	A room or building equipped for scientific experiments or research.	phòng thí nghiệm	ləˈbɒrətri	laboratory	\N	
679609ac-0041-4c59-a34d-89272baf43f4	2025-10-10 18:49:48.643541	2025-10-17 19:02:03.010555	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F85da4fda-3a61-441c-bd16-7ad02e85bc4b.mp3?alt=media	A2	[Work] The employee received a promotion after years of hard work. | [Team] She collaborated with employees from different departments. | [Training] The new employee attended a workshop to learn company policies.	\N	A person employed for wages or salary.	nhân viên	ɪmˈplɔɪi	employee	\N	
549b62b0-9c23-47f1-8187-ac64854ed3a2	2025-10-10 18:49:48.653079	2025-10-17 19:02:03.149342	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fcfc53758-b164-4527-8673-a49ab0485ff9.mp3?alt=media	A2	[Finance] His salary increased after the company’s successful year. | [Negotiation] She discussed her salary expectations during the interview. | [Budget] Most of his salary goes toward rent and bills.	\N	A fixed regular payment for work, typically paid monthly.	lương	ˈsæləri	salary	\N	
2d53adf8-5c8d-405f-bc04-ac98f774de6a	2025-10-10 18:49:48.655085	2025-10-17 19:02:03.26842	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F321dad38-246b-4473-af32-8a64eb273771.mp3?alt=media	A2	[Goal] She planned her career to become a software engineer. | [Advice] He sought a mentor to guide his career choices. | [Change] After years in sales, she switched to a teaching career.	\N	An occupation undertaken for a significant period of a personâ€™s life.	sự nghiệp	kəˈrɪə	career	\N	
90b4aafd-5b1e-46be-92cd-75637aa0cb88	2025-10-10 18:49:48.646567	2025-10-17 19:02:03.152993	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5468dd0f-e671-4dd5-8360-46fac77de467.mp3?alt=media	A2	[Work] The meeting was scheduled to discuss the annual budget. | [Virtual] We joined the meeting via video call from home. | [Planning] She prepared slides for the team meeting tomorrow.	\N	A gathering of people for discussion or decision-making.	cuộc họp	ˈmiːtɪŋ	meeting	\N	
58ea3eb3-47fb-4e94-86a1-5dd1eca3a71b	2025-10-10 18:49:48.657085	2025-10-17 19:02:03.308979	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F12103528-04e6-4be6-9e5c-c0301c0e8d57.mp3?alt=media	A2	[Work] He worked the night shift at the hospital last week. | [Schedule] The manager changed the shift times for better efficiency. | [Balance] She preferred the morning shift to have evenings free.	\N	A period of time worked by a group of workers.	ca làm việc	ʃɪft	shift	\N	
c31f10a1-91ce-49f8-bd19-a4f64d244465	2025-10-10 18:49:48.662961	2025-10-17 19:02:03.431588	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8f5fa639-5d21-4d9e-ba6d-9b7b24b3ed5f.mp3?alt=media	B1	[Career] Teaching is a rewarding profession for those who love learning. | [Choice] He chose a profession in architecture after university. | [Respect] Her profession as a doctor earned her great admiration.	\N	A paid occupation, especially one requiring advanced education.	nghề nghiệp	prəˈfeʃn	profession	\N	
6518db6d-b5c5-44ee-9364-49d202b9106f	2025-10-10 18:49:48.665844	2025-10-17 19:02:03.469572	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3542eaf0-8772-4c13-aa74-7169fb38c4e8.mp3?alt=media	B1	[Environment] The workplace was designed to encourage creativity. | [Safety] New rules were introduced to keep the workplace safe. | [Team] She enjoyed the friendly atmosphere at her workplace.	\N	The place where people work, such as an office or factory.	nơi làm việc	ˈwɜːkpleɪs	workplace	\N	
e7511db6-6161-44f1-884d-b9eee2401726	2025-10-10 18:49:48.671989	2025-10-17 19:02:03.63415	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb307fcc5-503c-4e34-ba81-354962394290.mp3?alt=media	A1	[Exercise] Riding a bicycle to work keeps her fit and healthy. | [Travel] We explored the city on bicycles during the weekend. | [Environment] Using a bicycle reduces your carbon footprint.	\N	A vehicle with two wheels powered by pedals.	xe đạp	ˈbaɪsɪkl	bicycle	\N	
67fd00f3-6393-41e4-87ff-1cfb55ae1ad7	2025-10-10 18:49:48.675117	2025-10-17 19:02:03.727514	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9bd12c24-4fbf-4d6c-8128-1b752305d9a8.mp3?alt=media	A1	[Adventure] They sailed a boat across the lake on a sunny day. | [Fishing] The fisherman used a small boat for his daily catch. | [Vacation] Renting a boat was the highlight of our coastal trip.	\N	A small vessel for traveling over water.	thuyền	bəʊt	boat	\N	
ded24a41-25fa-4a77-853e-0ad89a541afd	2025-10-10 18:49:48.677037	2025-10-17 19:02:03.751243	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffce32346-29ae-41b4-8982-55dd205e55ed.mp3?alt=media	A2	[Commute] She takes the subway to work to avoid traffic. | [City] The subway system in Tokyo is incredibly efficient. | [Travel] We used the subway to visit famous landmarks in the city.	\N	An underground railway system in a city.	tàu điện ngầm	ˈsʌbweɪ	subway	\N	
27ea2502-0665-4013-9239-146eb6222757	2025-10-10 18:49:48.682995	2025-10-17 19:02:03.885204	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F88f226e4-cb86-4fa7-b8e3-eb1527b432bc.mp3?alt=media	A2	[City] Heavy traffic delayed our trip to the museum. | [Safety] Always check traffic before crossing the street. | [Morning] She left early to avoid rush-hour traffic.	\N	Vehicles moving on a road or public highway.	giao thông	ˈtræfɪk	traffic	\N	
ee7cb0a6-2f47-4f1d-bfdb-f3571739cb31	2025-10-10 18:49:48.686458	2025-10-17 19:02:03.943894	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F73e70866-ae2e-464c-a387-2479c61a4921.mp3?alt=media	A1	[Travel] The road to the village was lined with tall trees. | [Construction] Workers repaired the road after the heavy rain. | [Adventure] We took a scenic road trip through the mountains.	\N	A wide way leading from one place to another, especially for vehicles.	đường	rəʊd	road	\N	
efee7125-5017-4626-81c8-ae53ce375fbe	2025-10-10 18:49:48.694984	2025-10-17 19:02:04.051536	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6bd12eae-a6ef-4399-8b38-e686c3d5b468.mp3?alt=media	A2	[Airport] He lost his luggage during the connecting flight. | [Packing] She packed light luggage for the weekend getaway. | [Travel] The hotel staff helped carry our luggage to the room.	\N	Bags and suitcases a person carries when traveling.	hành lý	ˈlʌɡɪdʒ	luggage	\N	
a5502a23-407e-45e9-9488-719cda6d3b1f	2025-10-10 18:49:48.396336	2025-10-17 19:05:53.287428	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd9b5c9ab-8749-4954-ae3c-1695fbd16033.mp3?alt=media	A2	[Problem] The physics broke suddenly, so we had to fix it. | [Description] That physics looks safe in the afternoon light. | [Work] The physics was recorded carefully in the report.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F2702800c-842a-4454-b17c-a133457005f8.jpg?alt=media	The science of matter, energy, and their interactions.	vật lý	ˈfɪzɪks	physics	\N	
eaa0cb57-a623-4a1c-955d-81a9ffa7be03	2025-10-10 18:49:48.750627	2025-10-10 18:49:48.750627	null	A1	[Family] The zoo was a fun outing for kids and parents alike. | [Education] The zoo offers programs to teach about animal conservation. | [Visit] We saw rare animals during our trip to the zoo.	\N	A place where animals are kept for public viewing and study.	sở thú	zuː	zoo	\N	
3a96ac6b-dcd1-4a7b-b5f8-2d958d5539a3	2025-10-10 18:49:48.745146	2025-10-17 19:01:58.83588	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F31b6d7da-4d59-4d7e-923f-be2779f425cd.mp3?alt=media	A1	[Wildlife] The bear was fishing for salmon in the river. | [Story] The children’s book featured a friendly bear as the hero. | [Camping] We stored food securely to avoid attracting bears.	\N	A large, heavy mammal with thick fur, often found in forests.	gấu	beə	bear	\N	
1fe7d6fd-6f7e-49cc-bae1-6e4a2e20de14	2025-10-10 18:49:48.697863	2025-10-17 19:02:04.200617	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6bc31be6-78fe-49be-ad5f-2123ec4ad320.mp3?alt=media	A2	[Adventure] The journey through the desert was unforgettable. | [Life] Her journey to becoming a doctor was full of challenges. | [Travel] We planned a long journey across Europe by train.	\N	The act of traveling from one place to another.	hành trình	ˈdʒɜːni	journey	\N	
bbd04f28-8621-4bc2-9a4c-db7250d24323	2025-10-10 18:49:48.700803	2025-10-17 19:02:04.249906	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F959de72b-4b53-47ba-b5e2-94ef691c2d55.mp3?alt=media	A1	[Health] Doctors recommend a daily walk to stay active. | [City] We took a walk through the park to enjoy the flowers. | [Relaxation] A morning walk by the beach is so refreshing.	\N	To move at a regular pace by lifting and setting down each foot in turn.	đi bộ	wɔːk	walk	\N	
7c47c8b6-bb6c-41fb-b1a9-cfc5476ccf99	2025-10-10 18:49:48.742167	2025-10-17 19:01:58.804679	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff600e7e3-a07d-4f84-a6cf-87b6b988a2e6.mp3?alt=media	A1	[Zoo] The monkey swung from branch to branch playfully. | [Nature] Monkeys are known for their intelligence and social behavior. | [Travel] We spotted monkeys while hiking in the forest.	\N	A small to medium-sized primate that typically lives in trees.	con khỉ	ˈmʌŋki	monkey	\N	
76c82257-9299-4830-99ad-03131a692695	2025-10-10 18:49:48.714159	2025-10-17 19:02:04.550397	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff1f6642a-f887-4f3b-842c-b4f9f674553f.mp3?alt=media	A2	[Goal] She worked on her fitness to prepare for the hike. | [Gym] The fitness center offered new classes for all levels. | [Lifestyle] Fitness is important for a balanced and healthy life.	\N	The condition of being physically fit and healthy.	sức khỏe; thể dục	ˈfɪtnəs	fitness	\N	
45bb9ead-c0ae-4291-8efd-7dc5275f0ef5	2025-10-10 18:49:48.722824	2025-10-17 19:02:04.657904	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fabd8d205-2a59-43cd-b6aa-362568d9c2a9.mp3?alt=media	A2	[Competition] The athlete won a gold medal in the marathon. | [Training] She trained as an athlete for years to compete professionally. | [Inspiration] Young athletes admire her dedication and skill.	\N	A person who is proficient in sports and other forms of physical exercise.	vận động viên	ˈæθliːt	athlete	\N	
521c44c1-5d36-400f-9c5e-a23439050a90	2025-10-10 18:49:48.726267	2025-10-17 19:02:04.865804	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd28c0b75-ba51-4ddb-a6b3-3f2c5989b139.mp3?alt=media	A2	[Event] The stadium was packed for the championship game. | [Tour] We visited the famous stadium during our city trip. | [Construction] The new stadium will host international matches.	\N	A large structure for sports and entertainment events.	sân vận động	ˈsteɪdiəm	stadium	\N	
e6d116d8-17b8-4c87-b92f-6954e807eee0	2025-10-10 18:49:48.72867	2025-10-17 19:02:04.868759	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F480130a7-f6f6-4aad-84aa-62b4d180f247.mp3?alt=media	A2	[Gym] The trainer designed a workout plan for beginners. | [Sport] The football trainer motivated the team before the match. | [Support] She hired a personal trainer to improve her fitness.	\N	A person who trains people or animals.	huấn luyện viên	ˈtreɪnə	trainer	\N	
7afeac1c-2f17-4f41-a90e-6bb7be3d36ba	2025-10-10 18:49:48.736629	2025-10-17 19:02:04.965959	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F438653f6-d34a-45f2-9d07-0c1831d79e6a.mp3?alt=media	A1	[Safari] We saw an elephant herd during our trip to Africa. | [Culture] In some countries, elephants are symbols of wisdom. | [Conservation] Efforts to save elephants focus on stopping poaching.	\N	A large herbivorous mammal with a trunk and tusks.	con voi	ˈelɪfənt	elephant	\N	
11e6e1bc-d34d-4d5c-9466-3116eaf0ed3b	2025-10-10 18:49:48.754787	2025-10-17 19:02:05.191671	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbd5b11c6-7629-4dc4-a438-3b475d951763.mp3?alt=media	A1	[Forest] A deer grazed peacefully in the meadow at sunrise. | [Hunting] Hunters are regulated to protect the deer population. | [Symbol] The deer is often seen as a symbol of grace and gentleness.	\N	A hoofed mammal with antlers (in males), found in forests.	nai	dɪə	deer	\N	
5be08d51-c68c-4b3f-b3c2-61fcf5cb43ff	2025-10-10 18:49:48.752633	2025-10-17 19:02:05.195685	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbb5c3e67-754b-4ce7-bbea-33dfe0f214af.mp3?alt=media	A1	[Wildlife] The fox darted across the field at dawn. | [Story] The clever fox outsmarted the hunter in the tale. | [Nature] Foxes are known for their adaptability in urban areas.	\N	A small to medium-sized carnivorous mammal with a bushy tail.	cáo	fɒks	fox	\N	
cf83d964-cb5c-4bee-a213-3b2f83ed453c	2025-10-10 18:49:48.708873	2025-10-17 19:02:04.36865	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5f718ab6-95b9-476d-8b42-9ddb39d2bbf6.mp3?alt=media	A1	[Exercise] Running in the park is part of her daily routine. | [Competition] He trained for months for the running race. | [Health] Running improves heart health and builds stamina.	\N	The action of moving rapidly on foot as a sport or exercise.	chạy bộ	ˈrʌnɪŋ	running	\N	
8321ffad-fe48-4827-a523-c3989dd0675a	2025-10-10 18:49:48.757023	2025-10-17 19:02:07.195098	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F56c244cf-d60d-4965-966b-a967db60fb4a.mp3?alt=media	A1	[Weather] Dark clouds gathered before the storm began. | [Photography] The sunset behind the clouds created a stunning view. | [Science] We studied how clouds form in our geography class.	\N	A visible mass of condensed water vapor in the atmosphere.	mây	klaʊd	cloud	\N	
949612a0-8be8-44e1-9d7a-332cecae5d9b	2025-10-10 18:49:49.314853	2025-10-17 19:06:56.063302	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F87ac3081-7038-4528-9baf-f2fbf21d4a59.mp3?alt=media	C1	[Geology] Tectonic plates move. | [Earth] Tectonic activity causes earthquakes. | [Theory] Study tectonic theory.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F066cac25-a131-4e6f-9bfd-c5fc2f363ccd.jpg?alt=media	Relating to the structure and movement of the Earthâ€™s crust.	kiến tạo	tekˈtɒnɪk	tectonic	\N	
f60b50e1-ab40-4fa2-b4b0-015adfa3f792	2025-10-10 18:49:48.768591	2025-10-17 19:02:05.564077	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdf8bc058-e1c0-4351-b978-dfa7406598c4.mp3?alt=media	A1	[Hiking] Climbing the hill offered a stunning view of the valley. | [Exercise] She jogged up the hill to improve her stamina. | [History] The ancient fort was built on top of a hill.	\N	A naturally raised area of land, not as high as a mountain.	đồi	hɪl	hill	\N	
c06ba2f7-8fbe-4309-b0f6-07707ed5000d	2025-10-10 18:49:48.771293	2025-10-17 19:02:05.569333	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F420d3615-8b8b-4247-a982-a53fef904953.mp3?alt=media	A1	[Vacation] We built sandcastles on the beach during the holiday. | [Relaxation] The sound of waves on the beach was so calming. | [Activity] They played volleyball on the beach in the evening.	\N	A sandy or pebbly shore by a body of water.	bãi biển	biːtʃ	beach	\N	
d81f6146-8d68-46f5-98f8-4ff4baa78290	2025-10-10 18:49:48.77579	2025-10-17 19:02:05.813045	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F15f8fa5b-dac1-4c01-b525-5a0892ead71f.mp3?alt=media	A1	[Agriculture] The field was full of ripe wheat ready for harvest. | [Sport] The kids played soccer in the field near the school. | [Nature] Wildflowers covered the field in vibrant colors.	\N	An open area of land, especially used for farming or sports.	đồng ruộng	fiːld	field	\N	
69137dbd-5ef0-48bc-a37c-6cbcf5d84e90	2025-10-10 18:49:48.778186	2025-10-17 19:02:05.836184	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F80527677-130a-4d67-b839-8f9c9d312ce7.mp3?alt=media	A2	[Gardening] Rich soil is essential for growing healthy plants. | [Science] The soil sample was tested for nutrient content. | [Agriculture] Farmers rotate crops to keep the soil fertile.	\N	The upper layer of earth in which plants grow.	đất	sɔɪl	soil	\N	
32ed7fa5-a6f1-4c43-b8c9-b9bf09a96428	2025-10-10 18:49:48.78211	2025-10-17 19:02:05.871609	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4aa25b80-68b4-4e33-a485-f28076360964.mp3?alt=media	A1	[Home] The bathroom was remodeled with modern tiles. | [Routine] He takes a quick shower in the bathroom every morning. | [Cleaning] She scrubbed the bathroom to keep it spotless.	\N	A room containing a toilet and sink, often a bathtub or shower.	phòng tắm	ˈbɑːθruːm	bathroom	\N	
a832de10-033d-4e22-b602-a57f9710b473	2025-10-10 18:49:48.784611	2025-10-17 19:02:05.940997	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa800451d-b074-4503-8341-ead6aed04d09.mp3?alt=media	A1	[Living Room] The sofa was the perfect spot for family movie nights. | [Furniture] They bought a new sofa for the cozy apartment. | [Relaxation] She napped on the sofa after a long day.	\N	A long, upholstered seat with a back and arms for multiple people.	ghế sofa	ˈsəʊfə	sofa	\N	
864b2621-cba0-4a18-bc39-f973b5dd5c41	2025-10-10 18:49:48.788814	2025-10-17 19:02:06.137837	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3c263b65-ae01-4f65-8174-9c4e55e36ca0.mp3?alt=media	A1	[Bathroom] She checked her outfit in the mirror before leaving. | [Decor] A large mirror made the small room feel bigger. | [Daily Life] The mirror in the hallway was a gift from her aunt.	\N	A reflective surface, typically glass, for viewing oneself.	gương	ˈmɪrə	mirror	\N	
88aa9c3c-c3c4-42db-97b6-f1358cac803e	2025-10-10 18:49:48.791421	2025-10-17 19:02:06.147729	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F71622461-93e2-4d0a-8e70-c5720c5fe7cc.mp3?alt=media	A1	[Time] The clock on the wall ticked loudly in the quiet room. | [Decor] They hung a vintage clock in the dining area. | [Routine] He checked the clock to make sure he wasn’t late.	\N	A device for measuring and showing time.	đồng hồ	klɒk	clock	\N	
7660ae0e-2fff-43bc-bfd9-038645f48bf8	2025-10-10 18:49:48.793855	2025-10-17 19:02:06.182309	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa388cf86-b59c-4321-a518-dd64965ccdf4.mp3?alt=media	A1	[Home] The soft carpet felt warm under her feet in winter. | [Decor] They chose a blue carpet to match the room’s theme. | [Cleaning] Vacuuming the carpet regularly keeps it dust-free.	\N	A floor covering made of thick woven fabric.	thảm	ˈkɑːrpɪt	carpet	\N	
1239a73e-f141-40a0-8ac5-a6dbd8908045	2025-10-10 18:49:48.798893	2025-10-17 19:02:06.415497	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F111fb558-4ac3-4fe2-a1a3-07ec3700ff39.mp3?alt=media	A1	[Kitchen] The cupboard was stocked with canned goods and spices. | [Storage] She hid gifts in the cupboard before the party. | [Home] They painted the cupboard to match the new decor.	\N	A cabinet or closet for storing items, especially in a kitchen.	tủ đựng đồ	ˈkʌbərd	cupboard	\N	
b5d6adfb-303b-4325-9a17-a9d895a7f053	2025-10-10 18:49:48.801132	2025-10-17 19:02:06.435779	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F80a64436-d9df-4f9c-8e77-5457f18b26ce.mp3?alt=media	A1	[Winter] She wrapped herself in a warm blanket by the fire. | [Travel] He packed a blanket for the picnic in the park. | [Comfort] The soft blanket was a gift from her grandmother.	\N	A large piece of fabric used for warmth, typically on a bed.	chăn	ˈblæŋkɪt	blanket	\N	
fc12e2dc-912f-47ec-9a50-7cccced58cc7	2025-10-10 18:49:48.807631	2025-10-17 19:02:06.571638	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe46f1323-8c46-4cfe-b689-4a0f9b286457.mp3?alt=media	A2	[Culture] The temple was a peaceful place for meditation. | [Travel] We visited an ancient temple during our trip to Asia. | [History] The temple’s architecture reflected centuries-old traditions.	\N	A building devoted to the worship of a god or gods.	đền; chùa	ˈtempl	temple	\N	
efaa5ce0-8ad2-416e-8b49-a7ba7e67f208	2025-10-10 18:49:48.812883	2025-10-17 19:02:06.760959	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F67fe973d-e1ae-40d2-b091-f7458e05e210.mp3?alt=media	A2	[Culture] The mosque’s minaret towered over the city skyline. | [Travel] We admired the intricate designs inside the mosque. | [Community] The mosque welcomed everyone for the festival prayer.	\N	A Muslim place of worship.	nhà thờ Hồi giáo	mɒsk	mosque	\N	
a9d78901-672d-43da-b728-978e84567cfa	2025-10-10 18:49:48.766342	2025-10-17 19:02:05.513146	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa09a5c88-93f3-43fd-afd2-554dfe67e0fd.mp3?alt=media	A1	[Vacation] The lake was perfect for swimming and kayaking. | [Nature] Fish thrive in the clear waters of the mountain lake. | [Photography] The lake reflected the stars beautifully at night.	\N	A large body of water surrounded by land.	hồ	leɪk	lake	\N	
f58dc7ab-3f9e-4ffc-a470-ebf4b60a5ff6	2025-10-10 18:49:48.451563	2025-10-17 19:05:53.83266	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffb567621-5b7f-4bad-9a46-0c95127a149c.mp3?alt=media	B2	[Everyday] I put the election on the window before dinner. | [Story] A traveler found a election near the old window. | [School] The teacher asked us to describe a election in two sentences.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F874f757a-8bbf-440d-a3a3-f7bf7facf08f.jpg?alt=media	A formal process of choosing a person for public office.	cuộc bầu cử	ɪˈlekʃn	election	\N	
c8eca88f-9ba5-4f94-ac82-3883105102cf	2025-10-10 18:49:48.842394	2025-10-17 19:06:21.177433	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F20a81bcd-9666-4bcd-b0df-9106be87c2c7.mp3?alt=media	B1	[Technology] The phone received a software update last night. | [Work] She updated the team on the project’s progress. | [Security] Regular updates keep the system safe from threats.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F55444a5e-bd9a-43a4-8ccb-3272f05bcbd6.jpg?alt=media	To make something more modern or current.	cập nhật	ˈʌpdeɪt	update	\N	
64758780-d379-4991-8aa1-006bb062174d	2025-10-10 18:49:48.85233	2025-10-17 19:06:21.610366	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbd950dc0-c8f9-44dc-9348-4de4a293724d.mp3?alt=media	A1	[Work] He was tired after working a double shift. | [Travel] The long hike left her tired but satisfied. | [Daily Life] She felt tired and went to bed early tonight.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fa79f3221-0c8b-4ad4-be91-3933c49166b7.jpg?alt=media	In need of rest or sleep.	mệt mỏi	ˈtaɪərd	tired	\N	
fa51392c-9410-405d-abfb-f599c693ea4a	2025-10-10 18:49:48.858771	2025-10-17 19:06:21.816621	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7870a20c-c96f-4a64-b823-69102df6d872.mp3?alt=media	A2	[Vacation] She felt relaxed sitting by the pool with a book. | [Evening] A warm bath made him relaxed after a long day. | [Activity] The yoga class left everyone relaxed and refreshed.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F32a49708-9ac7-4f79-abe7-c4933e0a6925.jpg?alt=media	Free from tension and anxiety.	thư giãn	rɪˈlækst	relaxed	\N	
b357fa38-d1a4-4613-947f-7be8675bb591	2025-10-10 18:49:48.827285	2025-10-10 18:49:48.827285	null	A2	[Business] The company launched a new website to attract customers. | [Learning] She found a website with free language lessons. | [Design] Creating a website requires both coding and creativity.	\N	A set of related web pages located under a single domain.	trang web	ˈwebsaɪt	website	\N	
ee582b94-430d-417a-88c5-35f0de227e58	2025-10-10 18:49:48.830203	2025-10-10 18:49:48.830203	null	B1	[Technology] The new application helps track daily expenses. | [Phone] He downloaded a fitness application to monitor his workouts. | [Development] The team worked hard to update the application.	\N	A program or piece of software designed for a specific purpose.	ứng dụng	ˌæplɪˈkeɪʃn	application	\N	
26193f2b-c221-41a6-b94b-74b3106c0fcc	2025-10-10 18:49:48.861665	2025-10-17 19:06:21.888961	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F18cd6798-2aaa-4f96-8a0d-ef5f12037df3.mp3?alt=media	B1	[Technology] He was frustrated when the computer crashed again. | [Task] She felt frustrated trying to solve the difficult puzzle. | [Work] The delayed project left the team frustrated.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F3f864fed-490f-413c-a866-89892a8311a3.jpg?alt=media	Feeling annoyed or upset due to inability to achieve something.	bực bội	frʌˈstreɪtɪd	frustrated	\N	
4940bc8c-1d3b-4a10-bd75-41047fd455e7	2025-10-10 18:49:48.837116	2025-10-17 19:06:47.379772	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2a6a8bc0-f1f5-49b1-b45a-6dcfca4dbed6.mp3?alt=media	B1	[Programming] She wrote code to create a simple game. | [Security] The code was needed to access the secure system. | [Learning] He studied how to code in Python during the summer.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F9222f72d-ee0e-4471-b851-09cd3e578582.jpg?alt=media	A system of words, letters, or symbols used in programming.	mã code	kəʊd	code	\N	
d2fc65c0-52d8-4a3b-8dbf-341c034bd590	2025-10-10 18:49:48.821878	2025-10-17 19:02:07.044367	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd39061fd-45b8-4d9d-a28a-3d4a96c02d37.mp3?alt=media	A2	[History] The monument honors soldiers who fought in the war. | [Tourism] Visitors took photos in front of the famous monument. | [City] The monument stands tall in the center of the park.	\N	A structure built to commemorate a person or event.	đài tưởng niệm	ˈmɒnjumənt	monument	\N	
3654ddcf-0c85-4761-8a9b-1265ee1b2bde	2025-10-10 18:49:48.834795	2025-10-17 19:02:07.115677	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7728fb9e-21e8-43af-86d9-27a28aa9487d.mp3?alt=media	B2	[Technology] The server crashed, causing a website outage. | [Business] They upgraded the server to handle more traffic. | [IT] He works as a server administrator for a tech company.	\N	A computer that provides data to other computers.	máy chủ	ˈsɜːrvə	server	\N	
1396744e-d891-401f-b5dd-3d052b8f6f96	2025-10-10 18:49:48.844692	2025-10-17 19:02:07.411081	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff06f895b-68d1-4c03-aed0-c1c3fc2ddcda.mp3?alt=media	B1	[Data] Always create a backup of important files. | [Technology] The system crashed, but the backup saved the data. | [Routine] He backs up his computer every week to avoid data loss.	\N	A copy of data saved to prevent loss.	sao lưu	ˈbækʌp	backup	\N	
51dc45ef-a0aa-4ac5-a6e4-b8a119602f78	2025-10-10 18:49:48.84887	2025-10-17 19:02:07.683213	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe54f7b36-f305-4949-bdeb-45c35933412d.mp3?alt=media	A2	[Relaxation] The calm atmosphere of the lake was soothing. | [Reaction] She stayed calm during the stressful meeting. | [Advice] Take deep breaths to remain calm in tough situations.	\N	Peaceful and free from agitation or excitement.	bình tĩnh	kɑːm	calm	\N	
9372cf72-5cc2-4625-8146-264a328406a8	2025-10-10 18:49:48.865815	2025-10-17 19:02:08.035594	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3429face-53c0-4f84-bf94-2b8c7244b0dc.mp3?alt=media	B1	[Event] She was disappointed when the concert was canceled. | [Result] He felt disappointed with his low test score. | [Expectation] The meal was disappointing compared to the reviews.	\N	Feeling sad or dissatisfied because something was not as expected.	thất vọng	ˌdɪsəˈpɔɪntɪd	disappointed	\N	
5f237721-d474-496a-aaef-af413c73ab94	2025-10-10 18:49:48.454019	2025-10-17 19:05:54.196478	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7bf245c4-22ff-4365-a47e-df6bcd813928.mp3?alt=media	B1	[Goal] She plans to vote farther than last week. | [Travel] We voteed through the old town and took photos. | [Event] They voteed together during the school charity day.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fb8b5f383-5072-4004-84f6-713650602cce.jpg?alt=media	A formal indication of a choice between candidates or proposals.	bầu cử; lá phiếu	vəʊt	vote	\N	
85dd49fd-5be8-48c1-a1e8-b8c39c57084b	2025-10-10 18:49:48.887493	2025-10-17 19:06:22.907175	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F62560404-09f3-452b-85af-c933022a793b.mp3?alt=media	B2	[Agriculture] The greenhouse allows plants to grow year-round. | [Science] Greenhouse gases contribute to global warming. | [Gardening] She built a small greenhouse in her backyard.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F5ed4f8ad-6940-4df5-966b-3620382a2246.jpg?alt=media	A structure where plants are grown in a controlled environment.	nhà kính	ˈɡriːnhaʊs	greenhouse	\N	
d586c332-67a3-4adc-934b-72dc74decff1	2025-10-10 18:49:48.893165	2025-10-17 19:06:23.010387	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F39563b40-8abb-4e89-9781-07d0c04d00c0.mp3?alt=media	A2	[Performance] The dance at the festival was vibrant and colorful. | [Class] She joined a dance class to learn salsa. | [Culture] Traditional dances tell stories of the community’s history.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F7634b2d1-b004-4937-a6d0-3f003fefbf45.jpg?alt=media	A series of movements to music, often for performance.	điệu nhảy	dæns	dance	\N	
b635d05f-ad6f-4f3b-9d02-52364677205d	2025-10-10 18:49:48.9046	2025-10-17 19:06:23.53925	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2910b704-1a02-4013-90c8-82ae7d82188b.mp3?alt=media	A2	[Celebration] The parade featured colorful floats and music. | [Community] The town organizes a parade every summer. | [Culture] The parade showcased traditional costumes and dances.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F2590e784-702d-4dfe-9584-11361e7ddddf.jpeg?alt=media	A public procession, especially one celebrating a special day.	cuộc diễu hành	pəˈreɪd	parade	\N	
b9cc41e6-a4f3-4f01-bf1a-fa79b648322a	2025-10-10 18:49:48.908858	2025-10-17 19:06:46.922681	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F85b4b29b-4c57-4012-8243-ffdd3c2da160.mp3?alt=media	A2	[Education] Science classes teach students about the natural world. | [Research] The science of genetics has advanced rapidly. | [Interest] She loves science and wants to become a biologist.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F6edf4280-0ad1-4db3-9fd7-a60c76dabe1f.jpg?alt=media	The systematic study of the structure and behavior of the physical world.	khoa học	ˈsaɪəns	science	\N	
9653310a-5c16-461d-a2dc-492a24677edd	2025-10-10 18:49:48.907123	2025-10-17 19:06:46.959803	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fcf46e48f-f2cc-4e7a-ae76-dce0137128f6.mp3?alt=media	B1	[Story] The legend of the dragon fascinated the children. | [History] The city is famous for its ancient legends. | [Culture] She read a book about local legends and myths.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F23ddb2b6-1cd0-454b-8831-ee239565a29a.jpg?alt=media	A traditional story regarded as historical but unauthenticated.	truyền thuyết	ˈledʒənd	legend	\N	
50673261-9279-4b72-a146-0c31fe5300b6	2025-10-10 18:49:48.876037	2025-10-17 19:02:08.333522	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F632d41a1-4feb-4991-9044-fe437e3da4b2.mp3?alt=media	B1	[Environment] Recycling plastic reduces waste in landfills. | [School] The recycling program encouraged students to sort trash. | [Community] The town built a new recycling center for residents.	\N	The process of converting waste into reusable material.	tái chế	riːˈsaɪklɪŋ	recycling	\N	
3c716cec-8f3f-4543-9173-8b3ea1ba82df	2025-10-10 18:49:48.888825	2025-10-17 19:02:08.773277	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5dd86a79-619e-4d2d-99b1-84b9f3a7c2a5.mp3?alt=media	B1	[Culture] The custom of giving gifts is common during festivals. | [Travel] We learned about local customs during our trip. | [Tradition] The wedding followed ancient family customs.	\N	A traditional or widely accepted way of behaving.	phong tục	ˈkʌstəm	custom	\N	
8e7c4101-4ecc-43b2-91cd-5f0692c3409d	2025-10-10 18:49:48.918797	2025-10-17 19:02:09.626845	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4f17d29a-c748-4b26-b483-7751e584bdd0.mp3?alt=media	B2	[Science] The researcher published a paper on marine biology. | [Team] She worked as a researcher on a climate project. | [Career] Becoming a researcher requires years of study.	\N	A person who conducts research, especially in science or academia.	nhà nghiên cứu	rɪˈsɜːrtʃə	researcher	\N	
548f2700-27d5-49e2-9e0a-7e50d34c18f0	2025-10-10 18:49:48.916008	2025-10-17 19:02:09.526912	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd9927ddf-60ca-45fe-8741-b0dabcbe825b.mp3?alt=media	B2	[Research] The data showed a clear trend in temperature rise. | [Technology] She analyzed data to improve the app’s performance. | [Business] Accurate data is key to making informed decisions.	\N	Facts and statistics collected for analysis.	dữ liệu	ˈdeɪtə	data	\N	
46e999ce-c312-4ae5-ad2f-6d74b122f54c	2025-10-10 18:49:49.078245	2025-10-17 19:02:12.60087	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F205d2514-875d-454a-9991-00de93b77af8.mp3?alt=media	B2	[Literature] Submit the manuscript to publishers. | [History] Discover an ancient manuscript. | [Writing] Edit the manuscript carefully.	\N	A handwritten or typed document, especially an authorâ€™s original text.	bản thảo	ˈmænjəskrɪpt	manuscript	\N	
bcdf2be9-16bb-43b7-857e-37e6d928e28a	2025-10-10 18:49:48.874517	2025-10-17 19:02:08.326093	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F49671f0a-f06b-45a7-bed7-ab63643ea824.mp3?alt=media	B2	[Science] Climate change affects weather patterns worldwide. | [Policy] Governments are working to combat climate change with new laws. | [Awareness] The documentary raised awareness about climate change.	\N	A long-term change in weather patterns, often due to human activity.	biến đổi khí hậu	ˈklaɪmət tʃeɪndʒ	climate change	\N	
31b5c2db-7017-4c1c-b314-6af119da397f	2025-10-10 18:49:49.205594	2025-10-17 19:06:50.85344	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdba1498a-448c-46f7-9007-525d12526ac5.mp3?alt=media	B2	[Business] Hire a contractor for the project. | [Work] Work as an independent contractor. | [Agreement] Sign with the contractor.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F84490e45-5286-4799-8698-03b4a1b1fe8e.jpg?alt=media	A person or company hired to perform specific tasks.	nhà thầu	kənˈtræktə	contractor	\N	
5e189710-8a5e-4a07-8cda-05086ae5157f	2025-10-10 18:49:48.509609	2025-10-17 19:05:54.306683	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2eadfd5c-ef2f-4904-8394-39696e5b376b.mp3?alt=media	B2	[Work] The sculpture was recorded carefully in the report. | [Problem] The sculpture broke suddenly, so we had to fix it. | [Story] A traveler found a sculpture near the old bench.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F388a2d12-0028-47dd-be22-d77324893ddc.jpg?alt=media	The art of making two- or three-dimensional representative or abstract forms.	điêu khắc	ˈskʌlptʃə	sculpture	\N	
8b91ab1f-312a-4dac-9929-6667fc418a0f	2025-10-10 18:49:48.931272	2025-10-17 19:02:09.951372	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F77b4d800-6549-427f-ab69-2d0c00a624c1.mp3?alt=media	B1	[System] Education is essential for personal development. | [School] She pursued higher education to become a lawyer. | [Community] Free education programs help underserved children.	\N	The process of receiving or giving systematic instruction.	giáo dục	ˌedʒuˈkeɪʃn	education	\N	
63382b7c-03cc-40cd-9133-9152b2c3346a	2025-10-10 18:49:48.933282	2025-10-17 19:02:10.035481	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F21fbde1f-3b51-42bc-acf2-052faff32e11.mp3?alt=media	B1	[University] She earned a degree in computer science. | [Achievement] His degree opened doors to new career opportunities. | [Study] Getting a degree requires years of hard work.	\N	An academic qualification awarded by a college or university.	bằng cấp	dɪˈɡriː	degree	\N	
f9860988-56b5-4f41-90db-ca52b721c304	2025-10-10 18:49:48.935818	2025-10-17 19:02:10.079477	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F80f22f6d-ca8b-4073-bffa-6c14edb86f61.mp3?alt=media	B1	[Education] The online course taught coding for beginners. | [University] She enrolled in a course on environmental science. | [Learning] The course included weekly quizzes and projects.	\N	A series of lessons or lectures on a particular subject.	khóa học	kɔːrs	course	\N	
df8806e4-e4a5-4aca-a100-94b0320c50ca	2025-10-10 18:49:48.943281	2025-10-17 19:02:10.121618	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1b6bf749-b458-4ab4-a032-924dcd55c170.mp3?alt=media	B2	[Education] The syllabus outlined the topics for the semester. | [Planning] She reviewed the syllabus to prepare for the course. | [School] The teacher handed out the syllabus on the first day.	\N	An outline of the subjects in a course of study.	đề cương môn học	ˈsɪləbəs	syllabus	\N	
75df9462-3698-4f0f-8df3-4c7f07776958	2025-10-10 18:49:48.945616	2025-10-17 19:02:10.271656	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffe781c6c-fa0f-47b1-9819-b72a69060d11.mp3?alt=media	B2	[Education] The assessment included both a test and an essay. | [Work] The manager conducted an assessment of the team’s performance. | [School] Her assessment showed she excelled in math.	\N	The evaluation or estimation of the nature or quality of something.	đánh giá	əˈsesmənt	assessment	\N	
62c3bcd6-606d-4458-b37a-f582609fdeb3	2025-10-10 18:49:48.941474	2025-10-17 19:02:10.098942	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8d92184a-ce64-4b5a-8db1-b67211591828.mp3?alt=media	B1	[University] The professor explained complex theories clearly. | [Research] She worked with a professor on a biology project. | [Lecture] The professor’s talk on history was fascinating.	\N	A senior academic teacher at a university.	giáo sư	prəˈfesə	professor	\N	
f75cd964-753f-4a5c-9d20-a096e09d6893	2025-10-10 18:49:48.952934	2025-10-17 19:02:10.379337	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc6dea09e-cfb0-4c5c-8457-8342eaafd31f.mp3?alt=media	B1	[Education] Lifelong learning keeps the mind sharp. | [Class] The new method improved students’ learning experience. | [Technology] Online learning platforms are growing in popularity.	\N	The acquisition of knowledge or skills through study or experience.	học tập	ˈlɜːrnɪŋ	learning	\N	
86605566-91b4-4bdc-99c1-0ea26ea26933	2025-10-10 18:49:48.94763	2025-10-17 19:02:10.340451	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe58defd9-98e2-48f1-817a-a34a3d738012.mp3?alt=media	B2	[Research] The scholar published a book on ancient history. | [Education] She was recognized as a scholar for her academic work. | [History] Scholars debated the meaning of the ancient texts.	\N	A person who has detailed knowledge in a particular field.	học giả	ˈskɒlə	scholar	\N	
4f0cd45e-dae5-4f37-a3b3-87685c307783	2025-10-10 18:49:48.958379	2025-10-17 19:02:10.433944	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe748fc9a-6ee6-4cfd-889c-f313ded72fab.mp3?alt=media	B2	[Business] The regulation ensures fair trade practices. | [Safety] New regulations were introduced to protect workers. | [Government] The regulation limits pollution from factories.	\N	A rule or directive made and maintained by an authority.	quy định	ˌreɡjəˈleɪʃn	regulation	\N	
4bec0ceb-af9b-4fd6-ab28-35477e65ac21	2025-10-10 18:49:48.971441	2025-10-17 19:02:10.680542	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Feb06c091-c847-433b-bdf9-b68dc73a32f6.mp3?alt=media	B2	[Government] The legislation was passed to reduce emissions. | [Study] She researched legislation on renewable energy. | [Politics] New legislation aims to improve public healthcare.	\N	Laws collectively, or the process of making laws.	luật pháp	ˌledʒɪsˈleɪʃn	legislation	\N	
7850bc93-7891-4814-8917-57af1f272e90	2025-10-10 18:49:48.976192	2025-10-17 19:02:10.895297	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F78c40845-f04a-40c4-a7be-07727d3d4ed9.mp3?alt=media	B1	[Politics] The campaign focused on improving education. | [Marketing] The advertising campaign boosted product sales. | [Community] They launched a campaign to clean the river.	\N	An organized effort to achieve a political or social goal.	chiến dịch	kæmˈpeɪn	campaign	\N	
6c33d855-a64a-4585-bf42-be988826d0b1	2025-10-10 18:49:48.967026	2025-10-17 19:02:10.692362	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F89796e55-604f-4b4f-88fe-3b2b3911f445.mp3?alt=media	B1	[Law] Human rights are protected by international agreements. | [Protest] They marched to demand equal rights for all. | [Education] She studied the rights of workers in her course.	\N	Legal, social, or ethical principles of entitlement.	quyền	raɪts	rights	\N	
b528b374-eb09-4336-b06e-5ea9271fd390	2025-10-10 18:49:48.98388	2025-10-17 19:02:10.945109	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7d391932-ce04-4a49-a938-1c962596d613.mp3?alt=media	B2	[Politics] Diplomacy helped resolve the international dispute peacefully. | [Career] She pursued a career in diplomacy after studying international relations. | [History] Effective diplomacy prevented a major war in the region.	\N	The profession or activity of managing international relations.	ngoại giao	dɪˈpləʊməsi	diplomacy	\N	
f177ca54-42da-46a8-967d-dded3256f62b	2025-10-10 18:49:48.948983	2025-10-17 19:02:15.627649	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F488ded64-53cc-4a46-b9ce-fe598d0cf7eb.mp3?alt=media	B2	[Career] Her mentor guided her through the job application process. | [Education] The mentor helped students with their research projects. | [Support] He acted as a mentor to young entrepreneurs.	\N	An experienced person who advises and guides a less experienced person.	cố vấn	ˈmentɔːr	mentor	\N	
b1a974e2-9a37-40b3-b1db-7dec651fa698	2025-10-10 18:49:48.554596	2025-10-17 19:05:54.338873	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F18a5a921-495a-45fd-b9e7-4a3e2168c455.mp3?alt=media	B1	[Everyday] I put the content on the doorway before dinner. | [Story] A traveler found a content near the old doorway. | [School] The teacher asked us to describe a content in two sentences.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F432a1fdf-f1a9-4674-b1da-78f369503c55.jpg?alt=media	Information made available by a website or other electronic medium.	nội dung	ˈkɒntent	content	\N	
a65685bd-5de1-41a1-9eb1-ec758057d9b1	2025-10-10 18:49:49.000566	2025-10-17 19:02:11.201209	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fee8d1d75-3faa-4f01-8f2a-d4b6cc20af5a.mp3?alt=media	B2	[Politics] Leaders met at the summit to discuss trade. | [Event] The annual summit focused on climate issues. | [Diplomacy] The summit resulted in new agreements.	\N	A meeting of heads of state or government.	hội nghị thượng đỉnh	ˈsʌmɪt	summit	\N	
74c9f5c8-7126-484d-9e29-1e0883e26d80	2025-10-10 18:49:49.009053	2025-10-17 19:02:11.307836	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbe1e2740-fdb0-49b5-9d26-7fdac4afa3ee.mp3?alt=media	B1	[Politics] Citizens organized a protest against the policy. | [Rights] The protest drew thousands of participants. | [Event] Police monitored the peaceful protest.	\N	A public expression of objection or disapproval.	biểu tình	ˈprəʊtest	protest	\N	
830c9ca7-c911-406a-aac6-caf4630d12cb	2025-10-10 18:49:49.014369	2025-10-17 19:02:11.368348	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F73a1c5a5-715a-40fe-9dbf-dde664c6edb3.mp3?alt=media	C1	[Law] The amendment protected freedom of speech. | [Constitution] Propose an amendment to the bill. | [Politics] The amendment passed with majority support.	\N	A change or addition to a legal document or law.	sửa đổi (luật)	əˈmendmənt	amendment	\N	
a6d284ed-0dcc-4437-aade-1cfca79591fb	2025-10-10 18:49:49.024868	2025-10-17 19:02:11.583612	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc9af866f-1d64-4f48-b07a-ad30b48adb31.mp3?alt=media	B2	[Finance] The company's assets include property and equipment. | [Investment] Diversify your assets for better returns. | [Business] Sell assets to raise capital.	\N	A useful or valuable thing or person.	tài sản	ˈæset	asset	\N	
b2ff7598-8c0e-4508-8410-cb75ff0de59b	2025-10-10 18:49:49.028519	2025-10-17 19:02:11.606316	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F893ea453-f14b-455b-bd96-38651e4c1825.mp3?alt=media	C1	[Law] Limit liability with insurance. | [Business] Assess the company's liabilities. | [Finance] Liabilities exceed assets in bankruptcy.	\N	The state of being responsible for something, especially by law.	trách nhiệm pháp lý	ˌlaɪəˈbɪləti	liability	\N	
1f2112c3-6d51-4c0e-884c-188d785f4409	2025-10-10 18:49:49.022868	2025-10-17 19:02:11.592365	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F46d04abb-d883-4658-b6fd-aae42655a494.mp3?alt=media	B2	[Law] The judge announced the verdict. | [Trial] Await the jury's verdict. | [Case] The verdict surprised everyone.	\N	A decision on an issue of fact in a court case.	phán quyết	ˈvɜːdɪkt	verdict	\N	
8419243e-9fed-4440-94d2-5a1eff090cce	2025-10-10 18:49:49.033777	2025-10-17 19:02:11.830687	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff19c9222-4020-4632-adc5-f5063381dc7f.mp3?alt=media	B2	[Business] The acquisition expanded the product line. | [Strategy] Plan a strategic acquisition. | [Finance] Fund the acquisition with loans.	\N	The purchase or takeover of one company by another.	mua lại	ˌækwɪˈzɪʃn	acquisition	\N	
6399d03b-291b-4f5e-87cd-8d47ac1b6a36	2025-10-10 18:49:49.039336	2025-10-17 19:02:11.902337	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F61e9bc93-c0cc-4937-b971-384071b584a5.mp3?alt=media	B2	[Business] Engage stakeholders in decisions. | [Project] Identify key stakeholders. | [Management] Communicate with stakeholders regularly.	\N	A person with an interest or concern in a business or project.	người liên quan	ˈsteɪkhəʊldə	stakeholder	\N	
daeac45d-a40d-410b-9d47-e91cad9db759	2025-10-10 18:49:49.047507	2025-10-17 19:02:11.979936	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd6ae84e5-01e6-4e33-b4e6-80ab82d02af3.mp3?alt=media	B2	[Finance] Pay dividends to shareholders. | [Investment] Receive annual dividends. | [Profit] Dividends reflect company profits.	\N	A sum of money paid to shareholders from profits.	cổ tức	ˈdɪvɪdend	dividend	\N	
ec8243e7-c96a-4b22-90e5-ec9271414e57	2025-10-10 18:49:49.051006	2025-10-17 19:02:12.149622	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb2f1968c-42f7-48df-83cd-09d4bf87433f.mp3?alt=media	B2	[Finance] File for bankruptcy protection. | [Business] Avoid bankruptcy with restructuring. | [Law] Bankruptcy affects credit ratings.	\N	The state of being unable to pay debts, leading to legal insolvency.	phá sản	ˈbæŋkrʌptsi	bankruptcy	\N	
99342083-9250-4be9-82a6-1131c091ce18	2025-10-10 18:49:49.057086	2025-10-17 19:02:12.191465	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe66f8704-b42e-4098-84b2-0d98f7d63808.mp3?alt=media	B1	[Art] Paint on a stretched canvas. | [Material] Buy canvas for the project. | [Exhibit] Display the canvas artwork.	\N	A strong, coarse fabric used for painting or sails.	vải tranh	ˈkænvəs	canvas	\N	
6be67608-8412-4e97-b87c-ffef811b600d	2025-10-10 18:49:49.060564	2025-10-17 19:02:12.229753	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F51a0601a-aa63-4d56-b783-96243d1d6a6a.mp3?alt=media	A2	[Art] Draw a quick sketch. | [Design] Sketch ideas on paper. | [Artist] View the artist's sketches.	\N	A rough or unfinished drawing or outline.	phác thảo	sketʃ	sketch	\N	
aa4d011f-19fa-4617-bc60-ec598ed6ddb8	2025-10-10 18:49:49.069161	2025-10-17 19:02:12.495333	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F95aa3ea5-7aaa-423c-ad50-8aac3e90c37c.mp3?alt=media	B2	[Music] Listen to the symphony orchestra. | [Composition] Compose a new symphony. | [Performance] Attend the symphony concert.	\N	An elaborate musical composition for a full orchestra.	giao hưởng	ˈsɪmfəni	symphony	\N	
d721da1e-9419-4508-8a97-6ca6333bd379	2025-10-10 18:49:49.075225	2025-10-17 19:02:12.538092	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb2b1c805-892e-466f-99fd-e314494fa6a0.mp3?alt=media	B1	[Theater] Enjoy an opera show. | [Music] Sing in the opera. | [Culture] Opera combines music and drama.	\N	A dramatic work combining music, singing, and often dance.	nhạc kịch	ˈɒpərə	opera	\N	
40f072b9-6bda-45fc-9a89-e748d8c0f428	2025-10-10 18:49:49.072695	2025-10-17 19:02:12.538092	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F27f52d04-55f7-4fa1-b40d-59bb5ec61b9a.mp3?alt=media	B1	[Dance] Watch a ballet performance. | [Art] Study ballet dancing. | [Theater] The ballet tells a story.	\N	An artistic dance form performed to music, using precise movements.	vũ ba lê	ˈbæleɪ	ballet	\N	
45ea8c80-2e55-4c0c-a429-1d96576fcadf	2025-10-10 18:49:49.092901	2025-10-17 19:06:47.068332	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F318bef18-5ca9-4f30-bf5b-d4a58ad88a17.mp3?alt=media	A1	[Online] Join the group chat. | [Communication] Chat with friends daily. | [App] Use the chat feature.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F66feda3f-c83f-4f09-955a-000ecfbea45d.jpg?alt=media	Informal conversation, often online.	cuộc trò chuyện	tʃæt	chat	\N	
88d2fae9-669e-4a72-9cb4-4d312e8da912	2025-10-10 18:49:49.114324	2025-10-17 19:06:48.034479	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3f8c21bb-3da2-4f47-9b56-dc341e44c21b.mp3?alt=media	A1	[Snack] Have yogurt for dessert. | [Health] Yogurt aids digestion. | [Flavor] Add fruit to yogurt.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fcd433852-a739-4351-8128-6d86dc5308d0.jpg?alt=media	A food produced by bacterial fermentation of milk.	sữa chua	ˈjɒɡət	yogurt	\N	
be3517e2-04f4-47b9-a3f4-97747694d2e5	2025-10-10 18:49:49.117353	2025-10-17 19:06:48.110427	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3c5c0c9e-3d4b-471c-9040-6ca106efd9ed.mp3?alt=media	A2	[Meal] Grill a juicy steak. | [Restaurant] Order medium rare steak. | [Protein] Steak provides protein.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fdbd508bb-047e-4823-a749-52f29a9b0d72.jpg?alt=media	A slice of meat, typically beef, cooked by grilling or frying.	bò bít tết	steɪk	steak	\N	
67cec151-d0c1-443d-99fe-7f2b726f01b7	2025-10-10 18:49:49.119156	2025-10-17 19:06:48.245781	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F53f239e7-5c73-40f3-952a-d29d4fe789ab.mp3?alt=media	A2	[Drink] Blend a fruit smoothie. | [Health] Drink smoothie for breakfast. | [Recipe] Add spinach to smoothie.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fb1eec683-c019-414d-8727-a6d19aab3446.JPG?alt=media	A thick beverage made from blended fruits, vegetables, or yogurt.	sinh tố	ˈsmuːði	smoothie	\N	
21c90780-f66e-46c9-ae20-b841304a64cf	2025-10-10 18:49:49.128167	2025-10-17 19:06:48.592799	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F13573e6f-992e-478d-b496-ec3653e81e03.mp3?alt=media	A2	[Cooking] Chop fresh herbs. | [Garden] Grow herbs at home. | [Flavor] Herbs add aroma.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fba233c06-1789-40f9-9211-e3349e3bbe7c.jpg?alt=media	A plant used for flavoring food or medicine.	thảo mộc	hɜːb	herb	\N	
e877cf96-c733-4b5f-8114-130198437563	2025-10-10 18:49:49.135541	2025-10-17 19:06:48.807848	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5a217b0d-8cb8-484f-aefa-d8309de27754.mp3?alt=media	A2	[Meal] Save room for dessert. | [Sweet] Order chocolate dessert. | [Variety] Try fruit dessert.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F7e6d3a8e-70bf-4c67-b5c0-874165683d9b.jpg?alt=media	A sweet course eaten at the end of a meal.	món tráng miệng	dɪˈzɜːt	dessert	\N	
aca76173-8925-46ac-b543-866b771b130f	2025-10-10 18:49:49.142206	2025-10-17 19:06:49.158596	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdcf6e0e0-4e54-4c9f-85eb-54a9df2dc68e.mp3?alt=media	A2	[Family] Visit your siblings. | [Relationship] Share with siblings. | [Bond] Strengthen sibling bonds.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F60c1b479-f0ee-47fe-b446-2bcfd9882c12.jpg?alt=media	A brother or sister.	anh chị em	ˈsɪblɪŋ	sibling	\N	
4b986ae8-c4b1-48a3-a668-a54307d2e482	2025-10-10 18:49:49.150665	2025-10-17 19:06:49.189382	null	B1	[Relationship] Meet the fiancée. | [Planning] Discuss with fiancée. | [Future] Build life with fiancée.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F87257d25-b9ae-4b7a-ac95-07acce83eb6e.jpg?alt=media	A woman engaged to be married.	vị hôn thê	fiˈɒnseɪ	fiancée	\N	
6f9afab8-b43b-49b0-bf36-f995c1057349	2025-10-10 18:49:49.146886	2025-10-10 18:49:49.146886	null	B1	[Relationship] Introduce your fiancé. | [Engagement] Plan with your fiancé. | [Wedding] Marry your fiancé.	\N	A man engaged to be married.	vị hôn phu	fiˈɒnseɪ	fiancé	\N	
841da8ef-9320-4f20-ac66-a7743299ae03	2025-10-10 18:49:49.161061	2025-10-17 19:06:49.661625	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd58b6fef-a4e3-4087-91a8-eb565364eba4.mp3?alt=media	B2	[Family] Comfort the widower. | [Grief] The widower mourned. | [Support] Assist widowers.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F26c23a96-8ad7-48fb-866c-07d4c67a3324.jpg?alt=media	A man whose spouse has died and who has not remarried.	goá chồng	ˈwɪdəʊə	widower	\N	
27b2c02b-656a-4bd8-bf7e-623448e2af6b	2025-10-10 18:49:49.167836	2025-10-10 18:49:49.168838	null	A2	[Classroom] Write on the whiteboard. | [Meeting] Use whiteboard for ideas. | [Tool] Erase the whiteboard.	\N	A glossy surface for writing with non-permanent markers.	bảng trắng	ˈwaɪtbɔːd	whiteboard	\N	
803c2b1e-5272-4011-8102-5d6d115ef135	2025-10-10 18:49:49.098572	2025-10-17 19:02:13.100087	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0b83b6cd-e8e3-454b-8cf0-f7baf34deb02.mp3?alt=media	B1	[Media] Listen to a podcast episode. | [Series] Subscribe to the podcast. | [Content] Create your own podcast.	\N	A digital audio file available for downloading, often part of a series.	podcast	ˈpɒdkɑːst	podcast	\N	
ec2b718b-a2dd-449e-83d3-868875ad579d	2025-10-10 18:49:49.105029	2025-10-17 19:02:13.145456	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbe6ad878-5fce-40de-8457-bb668e85b9cf.mp3?alt=media	B1	[Online] Post on the discussion forum. | [Community] Join the forum community. | [Question] Ask questions in the forum.	\N	A place, especially online, for public discussion.	diễn đàn	ˈfɔːrəm	forum	\N	
04e0f2e8-3206-468b-b31d-d8bb1f9ccc7e	2025-10-10 18:49:49.144217	2025-10-17 19:02:14.098591	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F157986c2-b55d-4031-af6b-e934d1cac349.mp3?alt=media	B1	[Family] Meet the in-laws. | [Relationship] Get along with in-laws. | [Holiday] Celebrate with in-laws.	\N	A relative by marriage, such as a mother-in-law.	nhà thông gia	ˈɪn lɔː	in-law	\N	
4a6e301c-fe33-4c67-a718-148ef4d5b2d6	2025-10-10 18:49:49.089015	2025-10-17 19:02:12.844935	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2ed8966a-9cc4-455b-b09e-4f8856ac34a1.mp3?alt=media	A2	[Communication] Use emoji in messages. | [Expression] Add emoji to express emotions. | [Text] The message included heart emoji.	\N	A small digital image used to express an idea or emotion.	biểu tượng cảm xúc	ɪˈməʊdʒi	emoji	\N	
c2fb73eb-bd37-46ce-aacb-061882fa4013	2025-10-10 18:49:48.589374	2025-10-17 19:05:54.854681	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc356bea9-77d2-4231-b753-617c06e11d51.mp3?alt=media	A1	[Memory] My grandfather told stories of his childhood every evening. | [Family] The grandfather taught his grandson how to fish by the lake. | [Celebration] We visited grandfather to celebrate his 80th birthday.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F905aa952-6f53-4285-8b87-47c2dcec9c74.jpg?alt=media	The father of a parent.	ông	ˈɡrændˌfɑːðə	grandfather	\N	
72a0ffd4-cd07-41bb-9bcb-bda6491d5846	2025-10-10 18:49:49.195932	2025-10-17 19:06:50.608574	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F934f1ff6-d30d-4bf8-a941-618d8b72d38e.mp3?alt=media	B2	[Business] Face company layoffs. | [Economy] Avoid mass layoffs. | [Support] Provide aid after layoffs.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F518d1585-aea8-4d2b-930f-fcfe80a1cc44.jpg?alt=media	The termination of employees due to lack of work or funds.	sa thải	ˈleɪɒf	layoff	\N	
3725020a-e0d8-47f8-a822-a5ceb9570747	2025-10-10 18:49:49.2076	2025-10-17 19:06:50.897535	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd8b1a743-2097-4a62-96ee-1bfc505da34e.mp3?alt=media	B1	[Career] Become a freelancer writer. | [Work] Freelancers set their schedules. | [Platform] Find jobs as freelancer.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fb52f92ee-6253-4dc8-ad9e-8cbc19baa55b.jpg?alt=media	A self-employed person offering services to multiple clients.	người làm tự do	ˈfriːlɑːnsə	freelancer	\N	
9597a1fa-bf39-4e97-abff-1e24ac0c0496	2025-10-10 18:49:49.212971	2025-10-17 19:06:51.035744	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa5f789c7-4851-4ea9-aef6-4bb76e3ed934.mp3?alt=media	B2	[Career] Attend networking events. | [Connections] Expand professional networking. | [Benefit] Networking leads to opportunities.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fb518f6b0-af83-490e-9405-95f6cb75c1a5.jpg?alt=media	The act of building professional or social relationships.	xây dựng mạng lưới	ˈnetwɜːkɪŋ	networking	\N	
75d00137-9049-4c63-afcc-8030a53d4dda	2025-10-10 18:49:49.217326	2025-10-17 19:06:51.331907	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdd144f91-1d9d-4c04-a304-47ad3342442a.mp3?alt=media	A2	[Transport] Drive through the tunnel. | [Construction] Build a long tunnel. | [Light] See light at tunnel end.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F2dd8986f-f562-40ca-9979-f37e75b78d7a.jpg?alt=media	An underground passage, often for vehicles or trains.	đường hầm	ˈtʌnl	tunnel	\N	
2e1c3430-c811-484d-856a-415f860ff281	2025-10-10 18:49:49.219307	2025-10-17 19:06:51.366161	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb8f84da7-9295-4fcd-8bf3-4c7228f49d87.mp3?alt=media	A2	[Safety] Use the crosswalk to cross. | [City] Wait at the crosswalk. | [Sign] Follow crosswalk signals.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc2e25ee6-6f83-4cee-912b-38ad05a2eb53.jpg?alt=media	A marked part of a road where pedestrians can cross.	lối đi bộ	ˈkrɒswɔːk	crosswalk	\N	
a8fd5c97-43aa-433b-9b88-39cbae469032	2025-10-10 18:49:49.226599	2025-10-17 19:06:51.598934	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd3d0d0c2-50a0-4f3d-bb00-da46988b99db.mp3?alt=media	B1	[Road] Pay the toll at the booth. | [Highway] Collect toll for maintenance. | [Pass] Use electronic toll pass.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F55b90b66-ca22-464a-b9cb-4ca55166888f.jpg?alt=media	A fee charged for using a road, bridge, or tunnel.	phí cầu đường	təʊl	toll	\N	
6df72cca-a3dc-4cf1-bf1e-02a7e51d306c	2025-10-10 18:49:49.245511	2025-10-17 19:06:51.901536	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3dabc0f3-5f25-437c-b2e1-92618c8c44d7.mp3?alt=media	A2	[Travel] Go sightseeing in the city. | [Tour] Join a sightseeing bus. | [Activity] Enjoy sightseeing spots.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F7e765003-4cb8-4a5d-af1b-7f7830fa0155.jpg?alt=media	The activity of visiting places of interest as a tourist.	tham quan	ˈsaɪtsiːɪŋ	sightseeing	\N	
8822fdd1-24bf-491a-8de3-6b5fc21dc074	2025-10-10 18:49:49.255377	2025-10-17 19:06:52.405872	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fce10c77b-a4be-4596-bbdc-04043d3471ea.mp3?alt=media	B1	[Fitness] Join aerobics classes. | [Workout] Do aerobics for cardio. | [Music] Aerobics with upbeat music.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F4cffca39-a071-4b21-84d6-623381560e8f.jpg?alt=media	A form of exercise involving rhythmic movements to improve fitness.	thể dục nhịp điệu	eəˈrəʊbɪks	aerobics	\N	
850223a1-7b7e-434c-810d-f2c64feca497	2025-10-10 18:49:49.186374	2025-10-17 19:02:14.995872	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7cb34874-301e-4923-b19e-c5e64ac43650.mp3?alt=media	B1	[Education] Start the new semester. | [Schedule] Plan courses for the semester. | [Break] Enjoy semester holidays.	\N	An academic term, typically lasting several months.	học kỳ	sɪˈmestə	semester	\N	
685dc8b9-b03a-44ae-8b6c-5ee6ba56ee21	2025-10-10 18:49:49.202709	2025-10-17 19:02:15.457117	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1a6465fe-0e3c-497d-8383-94adfaebbf88.mp3?alt=media	B2	[Job] Enjoy company perks. | [Benefit] Health insurance is a perk. | [Attraction] Perks attract employees.	\N	A benefit given to employees in addition to salary.	phúc lợi	pɜːk	perk	\N	
87883ed9-e12c-49cb-81d8-cf4315e9349b	2025-10-10 18:49:49.232915	2025-10-17 19:02:16.204797	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb5c53503-09b5-4bf6-b7c4-b94678a28f74.mp3?alt=media	B2	[Travel] Plan your trip itinerary. | [Schedule] Follow the itinerary. | [Details] Include flights in itinerary.	\N	A planned route or journey.	lịch trình	aɪˈtɪnərəri	itinerary	\N	
befcbc13-db42-49a5-b394-6560b60e51fd	2025-10-10 18:49:48.831739	2025-10-17 19:06:20.533354	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2fc933c9-e5b4-4bc2-8732-6e101db988e7.mp3?alt=media	A2	[Technology] The new device can charge without any wires. | [Home] She controls the lights with a smart home device. | [Work] Employees were trained to use the new office device.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fb6163e63-c2ab-4f94-8e9f-2d2f6ad92e84.jpg?alt=media	A piece of equipment designed for a particular purpose.	thiết bị	dɪˈvaɪs	device	\N	
f667a905-4e7a-493b-969c-e7e92efc0cdd	2025-10-10 18:49:49.274048	2025-10-17 19:06:52.918455	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F69f9f090-b4bb-4c73-9edf-73dbd152e076.mp3?alt=media	A1	[Animal] See kangaroos in Australia. | [Jump] Kangaroos hop quickly. | [Pouch] Kangaroos carry joeys in pouches.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Ff3d2faee-d44e-4d9c-a8f0-6fc761c75b66.jpg?alt=media	A large marsupial native to Australia with strong hind legs for jumping.	chuột túi	ˌkæŋɡəˈruː	kangaroo	\N	
509caa1d-9a7b-47bd-848a-6c76d58dde04	2025-10-10 18:49:49.281982	2025-10-17 19:06:53.06972	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F94cecfcd-e290-4547-b98a-46edf53a3c1e.mp3?alt=media	A1	[Ocean] Watch whales migrate. | [Size] Whales are huge mammals. | [Song] Hear whale songs underwater.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F33e568b0-8e87-43c3-8f54-d636dd412db0.jpg?alt=media	A large marine mammal that breathes air through a blowhole.	cá voi	weɪl	whale	\N	
1b2fad33-8744-4877-9d1f-54e8d48ca38a	2025-10-10 18:49:49.284741	2025-10-17 19:06:53.3577	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F53e1b7b1-404d-47d7-860c-fea6997aeba9.mp3?alt=media	A1	[Ocean] Dolphins are intelligent. | [Play] Dolphins jump in waves. | [Show] See dolphin performances.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Ff7d06a45-e724-4dec-bd8d-65c077588bba.jpg?alt=media	A small, social marine mammal known for its intelligence.	cá heo	ˈdɒlfɪn	dolphin	\N	
5e6b19af-da93-48a5-8b5c-83e8e22350e4	2025-10-10 18:49:49.292008	2025-10-17 19:06:53.419787	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F84f66a0b-7522-4680-9032-91054b486f90.mp3?alt=media	A2	[Ocean] Jellyfish sting can hurt. | [Glow] Some jellyfish glow. | [Beach] Avoid jellyfish in water.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F18d5fc8e-3856-48bc-b385-06d6103dc774.jpg?alt=media	A marine animal with a gelatinous body and stinging tentacles.	sứa	ˈdʒelifiʃ	jellyfish	\N	
84b23dcf-efb6-4b54-a9d8-28e3bf3fe5c8	2025-10-10 18:49:49.300706	2025-10-17 19:06:54.015337	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F60a06810-3428-4756-90a6-27ccfca7eb1d.mp3?alt=media	B1	[Space] Milky Way is our galaxy. | [Stars] Galaxies contain billions of stars. | [Universe] Explore distant galaxies.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc36e6568-3627-41a1-9adb-9515b38142b3.jpg?alt=media	A system of stars, gas, and dust bound by gravity.	thiên hà	ˈɡæləksi	galaxy	\N	
c83226b6-1928-4f13-a2be-09275ec25a9f	2025-10-10 18:49:49.297044	2025-10-17 19:06:54.01735	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fce7fee4b-cb1e-4c1a-a70f-2eabd2dc9460.mp3?alt=media	A1	[Space] Earth is a planet. | [Solar] Study solar planets. | [Explore] Discover new planets.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F1728795d-a328-4172-b4d1-b23158cf72dd.jpg?alt=media	A celestial body orbiting a star, like Earth or Mars.	hành tinh	ˈplænɪt	planet	\N	
fdc7e851-3115-438a-8b55-0a770c1b830e	2025-10-10 18:49:49.310774	2025-10-17 19:06:54.663327	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbe95976c-8aac-45e4-9b85-6cdfe6a8908c.mp3?alt=media	B1	[Animal] Preserve wildlife habitats. | [Nature] Habitats support biodiversity. | [Change] Climate affects habitats.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F8ed7dd11-2ad1-4fdb-82ca-4af57de97442.jpg?alt=media	The natural home or environment of an animal or plant.	môi trường sống	ˈhæbɪtæt	habitat	\N	
3d9d1167-6077-4e36-add8-e27273938068	2025-10-10 18:49:49.317849	2025-10-17 19:06:55.01622	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Feb3a4de1-6259-4dc8-827f-d983021fc2ef.mp3?alt=media	A1	[Kitchen] Store food in refrigerator. | [Appliance] Buy a new refrigerator. | [Cool] Keep drinks cold in refrigerator.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F0b82b060-a2ab-4758-82a1-0083dfa5feb9.jpg?alt=media	An appliance for keeping food and drinks cold.	tủ lạnh	rɪˈfrɪdʒəreɪtə	refrigerator	\N	
2294e059-a5db-4c62-8c9b-7aa5b64421e6	2025-10-10 18:49:49.320825	2025-10-17 19:06:55.17661	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff68b3a1e-b040-4a89-8e0d-7570f64c4f67.mp3?alt=media	A1	[Kitchen] Heat food in microwave. | [Appliance] Use the microwave oven. | [Quick] Microwave meals are convenient.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F434d6671-5829-4ddc-8945-153f64065491.jpg?alt=media	An appliance that cooks or heats food using electromagnetic waves.	lò vi sóng	ˈmaɪkrəʊweɪv	microwave	\N	
0d2c7c71-e6ec-4576-b344-b6e85f1df693	2025-10-10 18:49:49.323835	2025-10-17 19:06:55.181192	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F853f6af4-e820-4abe-861c-7b8312e7da03.mp3?alt=media	A2	[Home] Clean with vacuum cleaner. | [Tool] Buy a cordless vacuum. | [Chore] Vacuum the carpets weekly.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fa03d02f1-a62e-4334-80b0-09bcc541ebd8.jpg?alt=media	A device that cleans floors by sucking up dirt.	máy hút bụi	ˈvækjuːm ˈkliːnə	vacuum cleaner	\N	
d06d4c80-8a57-493b-9b6f-e20ee3938482	2025-10-10 18:49:49.32548	2025-10-17 19:06:55.521917	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6da5fa7b-983d-43c4-9bab-10c6ec7e62dc.mp3?alt=media	A2	[Kitchen] Load the dishwasher. | [Appliance] Run the dishwasher cycle. | [Convenience] Use dishwasher for cleaning.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc291252c-60d1-4594-aa29-8cef1e3754b3.jpg?alt=media	A machine for washing dishes automatically.	máy rửa chén	ˈdɪʃwɒʃə	dishwasher	\N	
60223308-3723-4dc7-9569-4b7b744ab2ac	2025-10-10 18:49:49.272219	2025-10-17 19:02:16.976073	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3d91db33-baae-475e-95ce-f4b6b2c69431.mp3?alt=media	B2	[Sport] Build endurance with training. | [Test] Endurance is key in marathons. | [Improvement] Increase endurance gradually.	\N	The ability to sustain prolonged physical or mental effort.	sức chịu đựng	ɪnˈdjʊərəns	endurance	\N	
010f277b-490d-4e11-9b6e-600b6a00a66f	2025-10-10 18:49:48.805619	2025-10-17 19:06:21.004575	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6f8ffc55-702a-40cb-8a45-b527571d1a75.mp3?alt=media	A2	[Shopping] The marketplace was bustling with vendors selling fresh produce. | [Culture] Visiting the local marketplace is a cultural experience. | [Food] She bought spices and fruits at the marketplace.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fa3c2db00-a1ab-4c4e-92a7-f76ce357333a.jpg?alt=media	A place where goods are bought and sold, often outdoors.	chợ	ˈmɑːrkɪtpleɪs	marketplace	\N	
30794320-b4bb-4324-8daf-9bcd05a56427	2025-10-10 18:49:49.347209	2025-10-10 18:49:49.347209	null	A2	[Shopping] Shop at the mall on weekends. | [Food] Eat at the mall's food court. | [Entertainment] Watch movies at the mall.	\N	A large indoor shopping center.	trung tâm thương mại	mɔːl	mall	\N	
3e7b9a5f-58a7-4900-bce5-76c815e6eee0	2025-10-10 18:49:49.349272	2025-10-10 18:49:49.349272	null	B1	[History] Tour the cathedral's architecture. | [Religion] Attend mass at the cathedral. | [Landmark] The cathedral is a city icon.	\N	A large and important Christian church.	nhà thờ lớn	kəˈθiːdrəl	cathedral	\N	
db751582-55be-423c-8906-77d362f9a2cc	2025-10-10 18:49:49.354171	2025-10-10 18:49:49.354171	null	B1	[Technology] The invention changed lives. | [History] The wheel was a great invention. | [Science] Patent the new invention.	\N	A new device, method, or process created through study and experimentation.	sáng chế	ɪnˈvenʃn	invention	\N	
8f275fa0-f699-437a-a627-aa85778c15ff	2025-10-10 18:49:49.356714	2025-10-10 18:49:49.356714	null	B2	[Electronics] Design a circuit board. | [Technology] Test the circuit's performance. | [Repair] Fix the broken circuit.	\N	A closed path through which an electric current flows.	mạch điện	ˈsɜːkɪt	circuit	\N	
1481203f-4e3a-45bd-b05d-b83e22600efe	2025-10-10 18:49:49.361592	2025-10-10 18:49:49.361592	null	A1	[Technology] Replace the battery. | [Power] Charge the battery fully. | [Device] The battery lasts long.	\N	A device that stores and provides electrical energy.	pin	ˈbætəri	battery	\N	
626ce20a-f028-41d1-8d6a-3d6415404b65	2025-10-10 18:49:49.364109	2025-10-10 18:49:49.364109	null	A2	[Technology] Program a robot for tasks. | [Industry] Robots automate production. | [Future] Robots assist in daily life.	\N	A programmable machine capable of performing tasks automatically.	robot	ˈrəʊbɒt	robot	\N	
9605b764-b0c9-4209-951b-545f44695166	2025-10-10 18:49:49.367114	2025-10-10 18:49:49.367114	null	B2	[Technology] Study artificial intelligence applications. | [Innovation] Artificial intelligence powers chatbots. | [Future] Artificial intelligence transforms industries.	\N	The development of computer systems that perform tasks requiring human intelligence.	trí tuệ nhân tạo	ˌɑːtɪˈfɪʃl ɪnˈtelɪdʒəns	artificial intelligence	\N	
1f938ce9-0381-4685-b154-39a9b86f8500	2025-10-10 18:49:49.369323	2025-10-10 18:49:49.369323	null	C1	[Security] Use encryption for privacy. | [Technology] Encryption protects data. | [System] Apply encryption to messages.	\N	The process of converting data into a code to prevent unauthorized access.	mã hóa	ɪnˈkrɪpʃn	encryption	\N	
97dccdaa-0f5d-4b2a-afd9-ee886e7bee33	2025-10-10 18:49:49.374682	2025-10-10 18:49:49.374682	null	A2	[Event] Plan a beautiful wedding. | [Celebration] Attend a friend's wedding. | [Dress] Wear a white wedding gown.	\N	A ceremony where two people are married.	đám cưới	ˈwedɪŋ	wedding	\N	
72754622-4da6-439e-9094-afd84c9147ae	2025-10-10 18:49:49.377262	2025-10-10 18:49:49.377262	null	A1	[Celebration] Celebrate your birthday. | [Party] Host a birthday party. | [Gift] Give a birthday present.	\N	The anniversary of the day a person was born.	sinh nhật	ˈbɜːθdeɪ	birthday	\N	
90ceb93e-2885-4594-b7fb-8826cbd6aed6	2025-10-10 18:49:49.379316	2025-10-10 18:49:49.379316	null	B1	[Celebration] Mark a wedding anniversary. | [Event] Plan an anniversary dinner. | [Memory] Celebrate a special anniversary.	\N	The yearly recurrence of a notable event, like a wedding.	kỷ niệm	ˌænɪˈvɜːsəri	anniversary	\N	
a0137d63-afcb-4b28-a482-8d9ea8a30598	2025-10-10 18:49:49.384819	2025-10-10 18:49:49.384819	null	A2	[Celebration] Watch fireworks at night. | [Event] Fireworks lit up the sky. | [Festival] Enjoy fireworks displays.	\N	Explosive devices used for entertainment, producing light and sound.	pháo hoa	ˈfaɪəwɜːks	fireworks	\N	
382c5d89-d8bb-4d6d-a404-0e567efae4a3	2025-10-10 18:49:49.38582	2025-10-10 18:49:49.38582	null	B1	[Event] Attend a funeral service. | [Respect] Pay respects at the funeral. | [Tradition] Follow funeral customs.	\N	A ceremony for a person who has died.	đám tang	ˈfjuːnərəl	funeral	\N	
4baaf54b-e985-44ab-a6fd-dd86a13ff00e	2025-10-10 18:49:49.389284	2025-10-10 18:49:49.389284	null	B1	[Education] Celebrate graduation day. | [Event] Wear a cap at graduation. | [Achievement] Graduation marks success.	\N	A ceremony marking the completion of a course of study.	lễ tốt nghiệp	ˌɡrædʒuˈeɪʃn	graduation	\N	
405b165f-7bed-45bd-8a35-83f53abe01ef	2025-10-10 18:49:49.392814	2025-10-10 18:49:49.392814	null	B1	[Family] Attend a family reunion. | [School] Join the class reunion. | [Event] Plan a high school reunion.	\N	A gathering of people who have been apart, like family or classmates.	cuộc hội ngộ	riːˈjuːnjən	reunion	\N	
514637a2-36f3-427a-bae6-48b401c7dadf	2025-10-10 18:49:49.39619	2025-10-10 18:49:49.39619	null	A2	[Health] Take medicine for headache. | [Stress] Stress causes headaches. | [Relief] Rest to cure headache.	\N	A pain in the head.	đau đầu	ˈhedeɪk	headache	\N	
1e9f47da-1276-4f64-87f5-af4bb2de30b2	2025-10-10 18:49:49.398368	2025-10-10 18:49:49.398368	null	A2	[Health] Check for a fever. | [Symptom] Fever indicates illness. | [Treatment] Reduce fever with medicine.	\N	An increase in body temperature above normal.	sốt	ˈfiːvə	fever	\N	
feb22a4f-8ca3-47be-9f77-73633e8cac87	2025-10-10 18:49:49.402132	2025-10-10 18:49:49.402132	null	A1	[Health] Treat a persistent cough. | [Symptom] Cough during a cold. | [Medicine] Use cough syrup.	\N	A sudden expulsion of air from the lungs, often due to illness.	ho	kɒf	cough	\N	
fea0d429-99a2-4c19-9637-07bf182b7983	2025-10-10 18:49:49.406087	2025-10-10 18:49:49.406087	null	A2	[Health] Sneeze into a tissue. | [Allergy] Pollen causes sneezing. | [Symptom] Sneezing spreads germs.	\N	A sudden, involuntary expulsion of air through the nose and mouth.	hắt hơi	sniːz	sneeze	\N	
0a2e8432-7519-451e-bdf2-73582f37b73e	2025-10-10 18:49:49.408086	2025-10-10 18:49:49.408086	null	B1	[Health] Avoid allergy triggers. | [Symptom] Allergies cause itching. | [Medicine] Take allergy medication.	\N	A condition where the body reacts to a substance, like pollen.	dị ứng	ˈælərdʒi	allergy	\N	
ea8a749f-cb4f-4416-97d9-983ff8976f1a	2025-10-10 18:49:49.409874	2025-10-10 18:49:49.409874	null	B1	[Health] Get a flu vaccine. | [Prevention] Vaccines protect against diseases. | [Campaign] Promote vaccine awareness.	\N	A substance used to stimulate immunity to a disease.	vắc-xin	ˈvæksiːn	vaccine	\N	
9d967a61-5752-4f31-9ae1-f75afd17434e	2025-10-10 18:49:49.413754	2025-10-10 18:49:49.413754	null	B1	[Health] Recover after surgery. | [Procedure] Schedule heart surgery. | [Hospital] Perform surgery safely.	\N	A medical procedure involving an incision to treat a condition.	phẫu thuật	ˈsɜːrdʒəri	surgery	\N	
c36131f1-1b10-45ee-bb94-e134d3f58f08	2025-10-10 18:49:49.418902	2025-10-10 18:49:49.418902	null	A2	[Health] Buy medicine at the pharmacy. | [Prescription] Fill prescription at pharmacy. | [Service] Consult the pharmacy staff.	\N	A store where medicines are dispensed and sold.	nhà thuốc	ˈfɑːməsi	pharmacy	\N	
e4dcc1e7-b923-4562-839f-d534597b8e54	2025-10-10 18:49:49.341988	2025-10-17 19:02:18.757551	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9d26d270-c19c-48a3-9130-54718e2e64b1.mp3?alt=media	A1	[Entertainment] Go to the cinema. | [Movie] Watch films at cinema. | [Date] Enjoy cinema outings.	\N	A place where films are shown to the public.	rạp chiếu phim	ˈsɪnəmə	cinema	\N	
a0a4b2a1-cd99-4cd3-a45b-b805b284ac73	2025-10-10 18:49:49.422016	2025-10-10 18:49:49.422016	null	B1	[Health] Follow the prescription instructions. | [Doctor] Get a prescription for medicine. | [Pharmacy] Refill the prescription.	\N	A written order for medicine from a doctor.	đơn thuốc	prɪˈskrɪpʃn	prescription	\N	
1eb5e75f-3e77-4149-9b56-e9ba539e4c03	2025-10-10 18:49:49.425095	2025-10-10 18:49:49.425095	null	A2	[Health] Apply a bandage to the wound. | [Injury] Change the bandage daily. | [First Aid] Use bandages for cuts.	\N	A strip of material used to cover and protect a wound.	băng gạc	ˈbændɪdʒ	bandage	\N	
1c7c759c-ec31-480b-a2e9-d5a6240e2645	2025-10-10 18:49:49.431466	2025-10-10 18:49:49.431466	null	B1	[Fashion] Follow the latest trends. | [Social Media] The trend went viral. | [Market] Analyze market trends.	\N	A general direction in which something is developing or changing.	xu hướng	trend	trend	\N	
5d7fc569-c59e-4f74-a380-3f3a10e2811f	2025-10-10 18:49:49.434202	2025-10-10 18:49:49.434202	null	A2	[Style] Follow fashion trends. | [Design] Study fashion design. | [Show] Attend a fashion show.	\N	A popular style or practice, especially in clothing.	thời trang	ˈfæʃn	fashion	\N	
76708d13-3556-461a-b254-386e469e69d9	2025-10-10 18:49:49.436691	2025-10-10 18:49:49.436691	null	B1	[Fashion] Wear stylish accessories. | [Outfit] Choose accessories for the dress. | [Jewelry] Buy new accessories.	\N	An item that complements or enhances clothing.	phụ kiện	əkˈsesəri	accessory	\N	
ab54442b-fd73-4767-99e5-398dd4b19707	2025-10-10 18:49:49.43934	2025-10-10 18:49:49.43934	null	A2	[Fashion] Pick a casual outfit. | [Event] Wear a formal outfit. | [Style] Match the outfit with shoes.	\N	A set of clothes worn together.	trang phục	ˈaʊtfɪt	outfit	\N	
6ba28a5a-471e-4083-b91d-11b8d48461c9	2025-10-10 18:49:49.443747	2025-10-10 18:49:49.443747	null	B1	[Fashion] Follow famous designers. | [Brand] Buy designer clothes. | [Career] Become a fashion designer.	\N	A person who plans the look or workings of something, like clothes.	nhà thiết kế	dɪˈzaɪnə	designer	\N	
509c1bd0-a388-422a-8769-4afbc0efa7be	2025-10-10 18:49:49.470943	2025-10-10 18:49:49.470943	null	A2	[Material] Choose soft fabric. | [Sewing] Buy cotton fabric. | [Design] Use fabric for dresses.	\N	Material made by weaving or knitting fibers.	vải	ˈfæbrɪk	fabric	\N	
d9580e28-c329-4afe-83c0-83c2ede40cc9	2025-10-10 18:49:49.477827	2025-10-10 18:49:49.477827	null	B2	[Fashion] Models walk the runway. | [Show] Watch the runway event. | [Design] Present designs on runway.	\N	A platform where fashion models display clothes.	đường băng (thời trang)	ˈrʌnweɪ	runway	\N	
e93073dd-5fbc-4e07-9c6e-3603b0b82421	2025-10-10 18:49:49.479732	2025-10-10 18:49:49.479732	null	A2	[Fashion] Try a new hairstyle. | [Salon] Choose a trendy hairstyle. | [Style] Maintain your hairstyle.	\N	A particular way in which hair is styled or arranged.	kiểu tóc	ˈheəstaɪl	hairstyle	\N	
4b965609-7921-47fd-af6b-9ecfd6199289	2025-10-10 18:49:49.484827	2025-10-10 18:49:49.484827	null	A2	[Beauty] Apply makeup for the event. | [Style] Use natural makeup. | [Product] Buy quality makeup.	\N	Cosmetics used to enhance or alter appearance.	trang điểm	ˈmeɪkʌp	makeup	\N	
4e94a729-ca31-4f9a-81a4-20d43b23553e	2025-10-10 18:49:49.488279	2025-10-10 18:49:49.488279	null	A2	[Geography] Africa is a continent. | [Travel] Explore different continents. | [Map] Study continents in geography.	\N	One of the seven large landmasses on Earth.	lục địa	ˈkɒntɪnənt	continent	\N	
4611b319-7124-46ad-b837-1cacb0b3a740	2025-10-10 18:49:49.491696	2025-10-10 18:49:49.491696	null	A2	[Nature] Explore the jungle wildlife. | [Adventure] Trek through the jungle. | [Ecosystem] Jungles are biodiverse.	\N	A dense, tropical forest with thick vegetation.	rừng rậm	ˈdʒʌŋɡl	jungle	\N	
1fb3a057-b4be-493e-8b5b-5497633557fc	2025-10-10 18:49:49.494098	2025-10-10 18:49:49.494098	null	B1	[Nature] Glaciers are melting fast. | [Geography] Study glaciers in Antarctica. | [Hiking] Hike near a glacier.	\N	A large, slow-moving mass of ice.	sông băng	ˈɡlæsiə	glacier	\N	
8c732e30-7933-4e36-8249-6275c3990ada	2025-10-10 18:49:49.496138	2025-10-10 18:49:49.496138	null	B2	[Geography] Italy is a peninsula. | [Map] Locate the peninsula on the map. | [Travel] Visit the peninsula's coast.	\N	A piece of land almost surrounded by water.	bán đảo	pəˈnɪnsjələ	peninsula	\N	
01c605cb-7f85-4f78-83a4-b3b92359414b	2025-10-10 18:49:49.498138	2025-10-10 18:49:49.498138	null	A1	[Geography] Live on a tropical island. | [Travel] Vacation on an island. | [Nature] Islands have unique wildlife.	\N	A piece of land surrounded by water.	đảo	ˈaɪlənd	island	\N	
9a631f0a-6c67-4df0-bf72-1f3b18f17990	2025-10-10 18:49:49.499385	2025-10-10 18:49:49.499385	null	B1	[Ocean] Dive near the coral reef. | [Nature] Protect the reef ecosystem. | [Beauty] Reefs are colorful underwater.	\N	A ridge of rock, coral, or sand near the waterâ€™s surface.	rạn san hô	riːf	reef	\N	
ddb3565e-3b5e-4106-a53e-5109f4f69b34	2025-10-10 18:49:49.503526	2025-10-10 18:49:49.503526	null	B2	[Geography] Hike on the plateau. | [Landscape] The plateau offers great views. | [Geology] Study plateau formation.	\N	A flat, elevated area of land.	cao nguyên	ˈplætəʊ	plateau	\N	
e05bdc20-f4af-439d-b7a4-90c51869550d	2025-10-10 18:49:49.50555	2025-10-10 18:49:49.50555	null	B1	[Geography] Explore the Grand Canyon. | [Nature] Hike through the canyon. | [Beauty] The canyon has stunning views.	\N	A deep valley with steep sides, often carved by a river.	hẻm núi	ˈkænjən	canyon	\N	
2c563240-772f-4d1a-b2fa-c21faf4d76f3	2025-10-10 18:49:49.507812	2025-10-10 18:49:49.507812	null	A2	[Nature] Visit a majestic waterfall. | [Tourism] Photograph the waterfall. | [Hiking] Trek to the waterfall.	\N	A cascade of water falling from a height.	thác nước	ˈwɔːtəfɔːl	waterfall	\N	
1c67dcf5-26b7-46de-9cd6-02006602da91	2025-10-10 18:49:49.512712	2025-10-10 18:49:49.512712	null	B1	[Astronomy] Observe stars with a telescope. | [Science] Buy a powerful telescope. | [Night] Use the telescope at night.	\N	An instrument for observing distant objects, like stars.	kính thiên văn	ˈtelɪskəʊp	telescope	\N	
7cadac02-c2db-45f4-b686-0a8226ede13e	2025-10-10 18:49:49.515771	2025-10-10 18:49:49.515771	null	B1	[Science] Examine cells with a microscope. | [Lab] Use a microscope in biology. | [Research] Buy a digital microscope.	\N	An instrument for viewing tiny objects magnified.	kính hiển vi	ˈmaɪkrəskəʊp	microscope	\N	
b13526b9-7385-4d75-8194-15fc9501a72b	2025-10-10 18:49:49.521588	2025-10-10 18:49:49.521588	null	B2	[Science] Atoms form molecules. | [Chemistry] Study atom structure. | [Physics] Research atom behavior.	\N	The smallest unit of a chemical element.	nguyên tử	ˈætəm	atom	\N	
e1dda565-6e15-4183-a684-129c52bb1a73	2025-10-10 18:49:49.526858	2025-10-10 18:49:49.526858	null	A2	[Leisure] Photography is her hobby. | [Activity] Find a new hobby. | [Fun] Share your hobby with friends.	\N	An activity done regularly in oneâ€™s leisure time for pleasure.	sở thích	ˈhɒbi	hobby	\N	
70a1cd58-5008-446a-b303-d2e2d61e8dfc	2025-10-10 18:49:49.529529	2025-10-10 18:49:49.529529	null	B1	[Hobby] Learn photography techniques. | [Art] Display photography in galleries. | [Equipment] Buy a camera for photography.	\N	The art or practice of taking and processing photographs.	nhiếp ảnh	fəˈtɒɡrəfi	photography	\N	
f097a098-dd7e-449f-9521-1dcaeba20ec5	2025-10-10 18:49:49.533942	2025-10-10 18:49:49.533942	null	A2	[Hobby] Enjoy gardening on weekends. | [Plants] Gardening grows flowers. | [Relaxation] Gardening reduces stress.	\N	The activity of growing and tending plants.	làm vườn	ˈɡɑːdnɪŋ	gardening	\N	
677bb0f5-f574-4c9a-9535-137618ae50f9	2025-10-10 18:49:49.537241	2025-10-10 18:49:49.537241	null	A1	[Hobby] Practice cooking new recipes. | [Skill] Improve your cooking. | [Fun] Cooking brings family together.	\N	The practice or skill of preparing food.	nấu ăn	ˈkʊkɪŋ	cooking	\N	
45b62747-23bc-4928-af2d-e8a40505fc0e	2025-10-10 18:49:49.541126	2025-10-10 18:49:49.541126	null	B1	[Hobby] Knitting scarves is relaxing. | [Craft] Learn knitting patterns. | [Gift] Knit a sweater for winter.	\N	The craft of creating fabric by interlocking yarn loops.	đan len	ˈnɪtɪŋ	knitting	\N	
e2f92315-82fd-4764-a8ea-7256633802b9	2025-10-10 18:49:49.544666	2025-10-10 18:49:49.544666	null	A2	[Hobby] Play chess with friends. | [Strategy] Learn chess moves. | [Competition] Join a chess club.	\N	A board game of strategy for two players.	cờ vua	tʃes	chess	\N	
cb479c78-c152-4db6-b62a-3daa3dc7de6c	2025-10-10 18:49:49.547695	2025-10-10 18:49:49.547695	null	A2	[Hobby] Solve a jigsaw puzzle. | [Game] Try crossword puzzles. | [Fun] Puzzles challenge the mind.	\N	A game or problem designed to test ingenuity or knowledge.	câu đố	ˈpʌzl	puzzle	\N	
ad92b3ca-2370-4aec-892a-3148259919b9	2025-10-10 18:49:49.549796	2025-10-10 18:49:49.549796	null	B2	[Hobby] Practice calligraphy art. | [Writing] Use pens for calligraphy. | [Design] Create calligraphy cards.	\N	The art of beautiful handwriting.	thư pháp	kəˈlɪɡrəfi	calligraphy	\N	
5c7f0254-ab95-4f62-a71f-3e3e0f63d8de	2025-10-10 18:49:49.554028	2025-10-10 18:49:49.554028	null	B1	[Hobby] Fold origami cranes. | [Craft] Learn origami techniques. | [Art] Display origami creations.	\N	The Japanese art of paper folding to create shapes.	gấp giấy	ˌɒrɪˈɡɑːmi	origami	\N	
18ebe3fb-e67f-4c97-aa19-de9b3157c429	2025-10-10 18:49:49.559776	2025-10-10 18:49:49.559776	null	C1	[Environment] Promote sustainability in farming. | [Goal] Achieve sustainability goals. | [Future] Sustainability ensures resources.	\N	The ability to maintain or preserve something, especially the environment.	bền vững	səˌsteɪnəˈbɪləti	sustainability	\N	
9a77ffd9-cb63-4cec-b955-644b2f967a63	2025-10-10 18:49:49.562404	2025-10-10 18:49:49.562404	null	B2	[Environment] Reduce carbon emissions. | [Science] Carbon forms compounds. | [Climate] Measure carbon footprint.	\N	A chemical element, often linked to emissions in the environment.	cacbon	ˈkɑːbən	carbon	\N	
b71d1650-de86-4d85-b96c-7ae3b292fae0	2025-10-10 18:49:49.568074	2025-10-10 18:49:49.568074	null	A2	[Cooking] Follow the recipe steps. | [Food] Share a family recipe. | [Kitchen] Try a new recipe.	\N	A set of instructions for preparing a dish.	công thức nấu ăn	ˈresɪpi	recipe	\N	
cdc8fb15-da7d-4399-91e8-f1198a3ddc23	2025-10-10 18:49:49.572625	2025-10-10 18:49:49.572625	null	A2	[Cooking] Gather all ingredients. | [Recipe] Check ingredient list. | [Food] Use fresh ingredients.	\N	A component used in preparing a dish.	nguyên liệu	ɪnˈɡriːdiənt	ingredient	\N	
b69223b4-d9de-4d97-964f-19e48b6288f6	2025-10-10 18:49:49.575352	2025-10-10 18:49:49.575352	null	B1	[Kitchen] Use cooking utensils. | [Tool] Clean the utensils. | [Set] Buy a utensil set.	\N	A tool or implement used in cooking or eating.	dụng cụ bếp	juːˈtensl	utensil	\N	
d9264521-5a7b-42b8-a15f-1de7899e0109	2025-10-10 18:49:49.579036	2025-10-10 18:49:49.579036	null	A2	[Kitchen] Wear an apron while cooking. | [Protection] The apron prevents stains. | [Style] Choose a colorful apron.	\N	A garment worn over clothes to protect them while cooking.	tạp dề	ˈeɪprən	apron	\N	
cdd1ef0c-1f23-405a-848f-95e7ff299d6e	2025-10-10 18:49:49.5812	2025-10-10 18:49:49.5812	null	A2	[Kitchen] The chef prepares gourmet meals. | [Career] Train to be a chef. | [Restaurant] Meet the head chef.	\N	A professional cook, typically in charge of a kitchen.	đầu bếp	ʃef	chef	\N	
d4bc5119-f4b5-4d5f-b679-82d4d9fec828	2025-10-10 18:49:49.585362	2025-10-10 18:49:49.585362	null	A2	[Cooking] Bake a cake for dessert. | [Kitchen] Learn to bake bread. | [Oven] Bake at high temperature.	\N	To cook food in an oven using dry heat.	nướng	beɪk	bake	\N	
e6a3ddf7-5f14-4187-a1f0-d4de0065c0f5	2025-10-10 18:49:49.589647	2025-10-10 18:49:49.589647	null	A2	[Cooking] Grill steaks outdoors. | [Tool] Use a barbecue grill. | [Food] Enjoy grilled vegetables.	\N	To cook food on a metal grate over an open flame.	nướng (thịt)	ɡrɪl	grill	\N	
95dcc931-02f8-4d30-9de6-81d897c27f2b	2025-10-10 18:49:49.592888	2025-10-10 18:49:49.592888	null	A1	[Cooking] Boil water for pasta. | [Kitchen] Boil eggs for breakfast. | [Method] Boil soup gently.	\N	To heat a liquid until it reaches its boiling point.	luộc	bɔɪl	boil	\N	
c3d41e13-d185-40d8-83e8-9322dde44e2e	2025-10-10 18:49:49.59595	2025-10-10 18:49:49.59595	null	A1	[Cooking] Fry chicken in oil. | [Kitchen] Fry potatoes for chips. | [Method] Fry food carefully.	\N	To cook food in hot oil or fat.	chiên	fraɪ	fry	\N	
cb5fd2e7-54e6-4d7c-a631-950e69626271	2025-10-10 18:49:49.59898	2025-10-10 18:49:49.59898	null	A2	[Cooking] Stir the soup slowly. | [Recipe] Stir ingredients together. | [Kitchen] Stir with a spoon.	\N	To mix ingredients with a spoon or utensil.	khuấy	stɜː	stir	\N	
e3996ff9-748c-4045-82da-54c8f23676fb	2025-10-10 18:49:49.604046	2025-10-10 18:49:49.604046	null	B2	[Job] Interview the job applicant. | [Process] Review applicant resumes. | [Selection] Choose the best applicant.	\N	A person who applies for a job or position.	người nộp đơn	ˈæplɪkənt	applicant	\N	
c756854c-164d-4e4b-af55-5733ada6ad25	2025-10-10 18:49:49.606674	2025-10-10 18:49:49.606674	null	B2	[HR] Manage the recruitment process. | [Company] Recruitment attracts talent. | [Job] Apply during recruitment.	\N	The process of finding and hiring new employees.	tuyển dụng	rɪˈkruːtmənt	recruitment	\N	
d99daa4d-e8f0-451c-b346-054d478cc369	2025-10-10 18:49:49.609688	2025-10-10 18:49:49.609688	null	B1	[Job] Select the best candidate. | [Election] Vote for the candidate. | [Interview] Meet the job candidate.	\N	A person applying for a job or running for a position.	ứng viên	ˈkændɪdeɪt	candidate	\N	
a6e52495-3418-4bf8-8c53-b095eac5223f	2025-10-10 18:49:49.614039	2025-10-10 18:49:49.614039	null	B2	[Job] Provide a job reference. | [Document] Check candidate references. | [Support] Ask for a reference.	\N	A letter or statement supporting someoneâ€™s abilities or character.	thư giới thiệu	ˈrefərəns	reference	\N	
de8ffe11-5db4-40f8-bfe5-f94292fab106	2025-10-10 18:49:49.617039	2025-10-10 18:49:49.617039	null	B2	[Work] Complete the probation period. | [Job] Pass probation successfully. | [Policy] Review probation terms.	\N	A trial period to assess an employeeâ€™s performance.	thời gian thử việc	prəˈbeɪʃn	probation	\N	
d4f8e3c3-6014-4a7a-8f89-a1a465092a60	2025-10-10 18:49:49.620076	2025-10-10 18:49:49.620076	null	B2	[Retirement] Receive a monthly pension. | [Finance] Plan for pension savings. | [Benefit] Pension supports retirees.	\N	A regular payment made to a retired person.	lương hưu	ˈpenʃn	pension	\N	
5f13718b-403a-47eb-ba7d-5d962cfb3bf8	2025-10-10 18:49:49.624293	2025-10-10 18:49:49.624293	null	B2	[Company] Train the workforce. | [Economy] Expand the workforce. | [Management] Support workforce needs.	\N	The group of people employed by a company or organization.	lực lượng lao động	ˈwɜːkfɔːs	workforce	\N	
aac06803-eba6-468e-bb10-07c7004a144d	2025-10-10 18:49:49.626894	2025-10-10 18:49:49.626894	null	B2	[Business] Increase company turnover. | [HR] Reduce employee turnover. | [Finance] Analyze turnover rates.	\N	The rate at which employees leave or the amount of business revenue.	doanh thu / tỷ lệ nghỉ việc	ˈtɜːnəʊvə	turnover	\N	
2305bd17-e2d8-48b4-9cb6-129142f9df37	2025-10-10 18:49:49.633845	2025-10-10 18:49:49.633845	null	B1	[Business] Set clear objectives. | [Project] Meet project objectives. | [Plan] Align with team objectives.	\N	A specific goal or aim to be achieved.	mục tiêu	əbˈdʒektɪv	objective	\N	
90452f4e-b01c-4497-bcf4-040afb5cbd2c	2025-10-10 18:49:49.636974	2025-10-10 18:49:49.636974	null	B1	[Task] Focus on top priorities. | [Plan] Set project priorities. | [Time] Manage priorities effectively.	\N	Something given or deserving precedence over others.	ưu tiên	praɪˈɒrəti	priority	\N	
cbbf1d07-ef68-4472-a181-9861bd98a346	2025-10-10 18:49:49.640587	2025-10-10 18:49:49.640587	null	B2	[Team] Encourage team collaboration. | [Project] Collaboration improves results. | [Business] Foster global collaboration.	\N	Working together to achieve a common goal.	sự hợp tác	kəˌlæbəˈreɪʃn	collaboration	\N	
54b6cf22-8049-454e-97d6-2aecc4b81646	2025-10-10 18:49:49.644781	2025-10-10 18:49:49.644781	null	B2	[Work] Boost workplace productivity. | [Efficiency] Measure team productivity. | [Goal] Improve daily productivity.	\N	The efficiency of producing goods or completing tasks.	năng suất	ˌprɒdʌkˈtɪvəti	productivity	\N	
91d0fdb4-146d-431b-9984-cbe81f6de1fc	2025-10-10 18:49:49.64729	2025-10-10 18:49:49.64729	null	B1	[Business] Develop leadership skills. | [Team] Show strong leadership. | [Role] Take on leadership duties.	\N	The ability to guide or direct a group.	lãnh đạo	ˈliːdəʃɪp	leadership	\N	
7a09f2ea-1ff8-4b01-912f-38824ad34d1e	2025-10-10 18:49:49.65029	2025-10-10 18:49:49.65029	null	C1	[Business] Follow business ethics. | [Philosophy] Study ethics in school. | [Decision] Make ethical choices.	\N	Moral principles governing behavior or activities.	đạo đức	ˈeθɪks	ethics	\N	
db35d19c-891a-450d-96f3-60c04061b58f	2025-10-10 18:49:49.65454	2025-10-10 18:49:49.65454	null	B2	[Business] Manage supply chain logistics. | [Transport] Improve logistics efficiency. | [Planning] Coordinate logistics for events.	\N	The planning and management of the flow of goods or resources.	hậu cần	ləˈdʒɪstɪks	logistics	\N	
6b65a2e6-9286-4933-b544-a6e6220353c9	2025-10-10 18:49:49.657957	2025-10-10 18:49:49.657957	null	B1	[Business] Create a sales forecast. | [Weather] Check the weather forecast. | [Planning] Forecast future trends.	\N	A prediction of future events, often weather or business trends.	dự báo	ˈfɔːkɑːst	forecast	\N	
5e5063ff-4619-4f49-a463-36d8882d5868	2025-10-10 18:49:49.662494	2025-10-10 18:49:49.662494	null	B2	[Culture] Sing the national anthem. | [Event] Play the anthem at ceremonies. | [Pride] The anthem inspires unity.	\N	A song officially adopted by a country or organization.	quốc ca	ˈænθəm	anthem	\N	
b0e95b64-d0f8-45ac-bfb5-0644144cdaa8	2025-10-10 18:49:49.666493	2025-10-10 18:49:49.666493	null	B2	[Culture] Embrace your cultural identity. | [Personal] Identity shapes behavior. | [Document] Verify your identity.	\N	The characteristics or qualities that define a person or group.	danh tính	aɪˈdentəti	identity	\N	
5e466f08-c63a-40a2-9a85-bd76189adb4b	2025-10-10 18:49:49.6695	2025-10-10 18:49:49.6695	null	B2	[Society] Celebrate cultural diversity. | [Work] Promote diversity in teams. | [Community] Diversity enriches society.	\N	The inclusion of different types of people or cultures.	đa dạng	daɪˈvɜːsəti	diversity	\N	
6c86b220-d897-4970-b95b-f14a59e45086	2025-10-10 18:49:49.672922	2025-10-10 18:49:49.672922	null	A2	[Society] Join the local community. | [Support] Build a strong community. | [Event] Community hosts festivals.	\N	A group of people living or working together.	cộng đồng	kəˈmjuːnəti	community	\N	
9fd6af8a-eed5-4212-b8c3-96b6667cd482	2025-10-10 18:49:49.680435	2025-10-10 18:49:49.680435	null	B1	[Marketing] Create an advertisement. | [Media] See a TV advertisement. | [Campaign] Launch a new advertisement.	\N	A public notice or announcement promoting a product or service.	quảng cáo	ədˈvɜːtɪsmənt	advertisement	\N	
69a77995-4a29-475a-a7c6-7b7091105a09	2025-10-10 18:49:49.683558	2025-10-10 18:49:49.684569	null	B1	[Marketing] Create a catchy slogan. | [Brand] The slogan promotes the product. | [Campaign] Use a slogan for advertising.	\N	A short, memorable phrase used in advertising.	khẩu hiệu	ˈsləʊɡən	slogan	\N	
a2517c65-d423-46bd-ac3f-abb1be982e31	2025-10-10 18:49:49.68724	2025-10-10 18:49:49.68724	null	B1	[Advertising] Display ads on billboards. | [Road] See a billboard on the highway. | [Marketing] Design a billboard ad.	\N	A large outdoor board for displaying advertisements.	biển quảng cáo	ˈbɪlbɔːd	billboard	\N	
234cf56d-e721-4816-b07d-a789b33e36b7	2025-10-10 18:49:49.690774	2025-10-10 18:49:49.690774	null	B1	[Media] Watch a TV commercial. | [Advertising] Create a commercial video. | [Business] Commercial ads boost sales.	\N	An advertisement broadcast on television or radio.	quảng cáo thương mại	kəˈmɜːʃl	commercial	\N	
1ea28ae0-55b5-4fa4-9549-e929888f71ce	2025-10-10 18:49:49.694754	2025-10-10 18:49:49.694754	null	B2	[Advertising] Write a catchy jingle. | [Media] Hear a jingle on radio. | [Brand] The jingle promotes the product.	\N	A short song or tune used in advertising.	đoạn nhạc quảng cáo	ˈdʒɪŋɡl	jingle	\N	
55599a9d-fc78-4a74-bb58-d310be81402e	2025-10-10 18:49:49.697943	2025-10-10 18:49:49.697943	null	A2	[Media] Engage the audience. | [Event] Perform for a large audience. | [Show] The audience clapped loudly.	\N	A group of people who watch or listen to a performance or media.	khán giả	ˈɔːdiəns	audience	\N	
bc6544bd-01f8-4ddd-86ae-e8869d0a141b	2025-10-10 18:49:49.702264	2025-10-10 18:49:49.702264	null	B1	[Media] Check TV show ratings. | [Performance] Improve movie ratings. | [Popularity] High ratings attract viewers.	\N	A measure of a programâ€™s popularity or quality.	xếp hạng	ˈreɪtɪŋz	ratings	\N	
4b581df1-8c71-4a6d-8fbe-1600ef59acd9	2025-10-10 18:49:49.705515	2025-10-10 18:49:49.705515	null	B1	[Media] Stream movies online. | [Technology] Use a streaming service. | [Live] Stream a live event.	\N	To transmit or receive data, especially video, over the internet.	luồng (truyền dữ liệu)	striːm	stream	\N	
5ba8947b-125b-4e51-89e5-72b8de894dc6	2025-10-10 18:49:49.708918	2025-10-10 18:49:49.708918	null	B1	[Media] Pay for a streaming subscription. | [Service] Cancel the subscription. | [Access] Get a monthly subscription.	\N	An agreement to receive a service or product regularly for a fee.	đăng ký (dịch vụ)	səbˈskrɪpʃn	subscription	\N	
6b3d66f1-95d4-4c80-89ab-c8626b42343c	2025-10-10 18:49:49.714634	2025-10-10 18:49:49.714634	null	B1	[Community] Volunteer at the shelter. | [Event] Volunteer for the festival. | [Help] Volunteer to help the needy.	\N	A person who freely offers to do something without payment.	tình nguyện viên	ˌvɒlənˈtɪə	volunteer	\N	
693fe39d-8914-4805-86eb-cca7a657f311	2025-10-10 18:49:49.717436	2025-10-10 18:49:49.717436	null	B1	[Community] Donate to charity. | [Organization] Support a local charity. | [Event] Attend a charity fundraiser.	\N	An organization or act of giving to help those in need.	từ thiện	ˈtʃærəti	charity	\N	
f39be50c-2d84-4dda-8def-3cfbeca4942d	2025-10-10 18:49:49.721134	2025-10-10 18:49:49.721134	null	B1	[Charity] Make a donation online. | [Support] Give a donation to schools. | [Cause] Donations help the poor.	\N	Money or goods given to help a cause or person.	quyên góp	dəʊˈneɪʃn	donation	\N	
ac093c3a-9c80-44b3-b08f-45df2da3562d	2025-10-10 18:49:49.72514	2025-10-10 18:49:49.72514	null	B2	[Event] Organize a fundraiser event. | [Charity] Attend a fundraiser dinner. | [Cause] Fundraisers support projects.	\N	An event or campaign to raise money for a cause.	gây quỹ	ˈfʌndreɪzə	fundraiser	\N	
688672df-4526-440f-af3d-adf4ca533df3	2025-10-10 18:49:49.72814	2025-10-10 18:49:49.72814	null	B2	[Organization] Work for a nonprofit. | [Charity] Support nonprofit causes. | [Mission] Nonprofits help communities.	\N	An organization that uses its surplus to achieve its goals, not for profit.	phi lợi nhuận	ˌnɒnˈprɒfɪt	nonprofit	\N	
5db16109-fc90-4747-a5c4-5ed1becb49fc	2025-10-10 18:49:49.732144	2025-10-10 18:49:49.732144	null	B2	[Society] The activist fights for rights. | [Cause] Join activists for change. | [Protest] Activists demand justice.	\N	A person who campaigns for social or political change.	nhà hoạt động	ˈæktɪvɪst	activist	\N	
d06ed3e7-914c-463a-909f-de1dc4489962	2025-10-10 18:49:49.735141	2025-10-10 18:49:49.735141	null	C1	[Society] Advocacy promotes equality. | [Cause] Support environmental advocacy. | [Policy] Advocacy influences laws.	\N	Public support for a cause or policy.	vận động chính sách	ˈædvəkəsi	advocacy	\N	
7b2e802c-3bc1-4748-a10e-e99db52bf561	2025-10-10 18:49:49.738143	2025-10-10 18:49:49.738143	null	B2	[Community] Organize outreach programs. | [Support] Outreach helps the homeless. | [Effort] Expand outreach efforts.	\N	The act of reaching out to provide services or support.	tiếp cận cộng đồng	ˈaʊtriːtʃ	outreach	\N	
36c3ec36-9233-4799-864f-43b92e8d4017	2025-10-10 18:49:49.742408	2025-10-10 18:49:49.742408	null	B2	[Community] Launch a community initiative. | [Project] Support green initiatives. | [Leadership] Take initiative at work.	\N	A new plan or action to achieve a goal.	sáng kiến	ɪˈnɪʃətɪv	initiative	\N	
a08d0770-c967-47df-bd9c-9213893196dd	2025-10-10 18:49:49.745417	2025-10-10 18:49:49.745417	null	A2	[Road] Stop at the intersection. | [Traffic] Cross the intersection safely. | [City] Install lights at intersections.	\N	A place where two or more roads cross.	ngã tư	ˌɪntəˈsekʃn	intersection	\N	
8c0ae6cd-4456-48ef-871d-413984717c04	2025-10-10 18:49:49.749419	2025-10-10 18:49:49.749419	null	A2	[Transport] Take the tram downtown. | [City] Trams are eco-friendly. | [Route] Follow the tram schedule.	\N	A vehicle running on rails, typically in cities.	xe điện	træm	tram	\N	
8a9f224b-bddb-4168-a5b4-67f4265813cc	2025-10-10 18:49:49.754595	2025-10-10 18:49:49.754595	null	A2	[Transport] Ride a scooter in the city. | [Fun] Rent an electric scooter. | [Mobility] Scooters are convenient.	\N	A two-wheeled vehicle, often motorized, for personal transport.	xe tay ga	ˈskuːtə	scooter	\N	
b52e56ed-029e-445c-8e92-d2b80f3398ba	2025-10-10 18:49:49.756962	2025-10-10 18:49:49.756962	null	B1	[Travel] Wait at the boarding gate. | [Airport] Complete boarding procedures. | [Flight] Boarding starts soon.	\N	The act of getting on a plane, train, or ship.	lên máy bay	ˈbɔːdɪŋ	boarding	\N	
08cbab15-b6e4-4964-9ec3-57498b16fc91	2025-10-10 18:49:49.760431	2025-10-10 18:49:49.760431	null	A2	[Travel] Carry a backpack for hiking. | [School] Use a backpack for books. | [Trip] Pack essentials in the backpack.	\N	A bag carried on the back, often for travel or hiking.	ba lô	ˈbækpæk	backpack	\N	
b623b4af-4323-49ca-bd12-6e7006c0a204	2025-10-10 18:49:49.766265	2025-10-10 18:49:49.766265	null	A2	[Fitness] Complete a daily workout. | [Exercise] Try a new workout routine. | [Health] Workout improves strength.	\N	A session of physical exercise or training.	buổi tập luyện	ˈwɜːkaʊt	workout	\N	
a7ea18ed-5809-4a6d-a54d-8fd9b1f6e1bd	2025-10-10 18:49:49.769351	2025-10-10 18:49:49.769351	null	B1	[Sports] The referee controls the game. | [Match] Listen to the referee. | [Fairness] Referees ensure fair play.	\N	An official who enforces rules in a sport or game.	trọng tài	ˌrefəˈriː	referee	\N	
dd7fb716-191b-4033-b3e6-ababe25780f1	2025-10-10 18:49:49.773751	2025-10-10 18:49:49.773751	null	A2	[Sports] Check the game score. | [Match] Score a goal in soccer. | [Record] Keep track of scores.	\N	The number of points earned in a game or competition.	điểm số	skɔː	score	\N	
b306027d-c1dd-40e2-add0-cbfe1c56f371	2025-10-10 18:49:49.776747	2025-10-10 18:49:49.776747	null	A2	[Sports] Cheer for the champion. | [Competition] Become a chess champion. | [Victory] The champion won gold.	\N	A person or team that wins a competition.	nhà vô địch	ˈtʃæmpiən	champion	\N	
4306fb3b-f572-4498-9434-b89bb9741340	2025-10-10 18:49:49.780904	2025-10-10 18:49:49.780904	null	B1	[Sports] Compete in a tennis tournament. | [Event] Watch the tournament finals. | [Organize] Plan a local tournament.	\N	A competition involving multiple participants or teams.	giải đấu	ˈtʊənəmənt	tournament	\N	
08141e11-5ed8-485d-9ace-6149f87a3744	2025-10-10 18:49:49.784142	2025-10-10 18:49:49.784142	null	B2	[Fitness] Build stamina with running. | [Sports] Stamina helps in marathons. | [Health] Improve your stamina.	\N	The ability to sustain prolonged physical or mental effort.	sức bền	ˈstæmɪnə	stamina	\N	
1e0bec3a-108d-4b84-8806-35e65b2f7ca4	2025-10-10 18:49:49.788173	2025-10-10 18:49:49.788173	null	B1	[Art] Paint a family portrait. | [Photography] Take a portrait photo. | [Gallery] Display royal portraits.	\N	A painting or photograph of a personâ€™s face.	chân dung	ˈpɔːtrət	portrait	\N	
f6ce6220-67c3-4199-9501-9ea2c593c6e5	2025-10-10 18:49:49.792214	2025-10-10 18:49:49.792214	null	B1	[Art] Paint a beautiful landscape. | [Nature] Capture landscape photos. | [View] Enjoy the mountain landscape.	\N	A painting or view of natural scenery, like mountains or forests.	phong cảnh	ˈlændskeɪp	landscape	\N	
d8be77c1-096c-4e4b-a786-73307726ab19	2025-10-10 18:49:49.795152	2025-10-10 18:49:49.795152	null	B2	[Art] Create an abstract painting. | [Style] Abstract art is unique. | [Exhibit] Show abstract works.	\N	Art or ideas that do not represent reality directly.	trừu tượng	ˈæbstrækt	abstract	\N	
a73b7584-85ad-4310-b68e-5d6d0237da39	2025-10-10 18:49:49.798151	2025-10-10 18:49:49.798151	null	B2	[Art] The painting is a masterpiece. | [Museum] View the artist's masterpiece. | [Creation] Produce a literary masterpiece.	\N	A work of outstanding artistry, skill, or workmanship.	tác phẩm xuất sắc	ˈmɑːstəpiːs	masterpiece	\N	
782dbdac-7ba7-4d07-856f-555bfad005bb	2025-10-10 18:49:49.803294	2025-10-10 18:49:49.803294	null	A2	[Art] Use a fine brush. | [Painting] Clean the paint brush. | [Tool] Buy new brushes for art.	\N	A tool with bristles used for painting or cleaning.	bút vẽ	brʌʃ	brush	\N	
b3364089-a364-4a7e-bfa9-e0b9b93d797e	2025-10-10 18:49:49.806808	2025-10-10 18:49:49.806808	null	B1	[Art] Mix colors on the palette. | [Painting] Choose a bright palette. | [Tool] Use a wooden palette.	\N	A board for mixing colors or a range of colors.	bảng màu	ˈpælət	palette	\N	
160c94bd-8139-4f2c-96d3-18ee0c6ca7d8	2025-10-10 18:49:49.811556	2025-10-10 18:49:49.811556	null	B2	[Literature] Write a compelling narrative. | [Film] The movie has a strong narrative. | [Story] Share a personal narrative.	\N	A spoken or written account of connected events; a story.	câu chuyện	ˈnærətɪv	narrative	\N	
35518f0b-e443-4980-945a-1f715f080265	2025-10-10 18:49:49.815016	2025-10-10 18:49:49.815016	null	B2	[Literature] The protagonist faces challenges. | [Story] Follow the protagonist's journey. | [Film] The protagonist saves the day.	\N	The main character in a story or drama.	nhân vật chính	prəˈtæɡənɪst	protagonist	\N	
21099f91-65a4-4250-ba23-85d92553c5ba	2025-10-10 18:49:49.817042	2025-10-10 18:49:49.817042	null	B2	[Literature] The antagonist creates conflict. | [Story] Defeat the antagonist. | [Film] The antagonist opposes the hero.	\N	A character who opposes the protagonist in a story.	nhân vật phản diện	ænˈtæɡənɪst	antagonist	\N	
f772a646-5588-4060-978c-14bf3104870d	2025-10-10 18:49:49.821246	2025-10-10 18:49:49.821246	null	B2	[Literature] The story reaches its climax. | [Film] The climax surprises viewers. | [Plot] Build tension to the climax.	\N	The most intense or exciting point in a story.	đỉnh điểm	ˈklaɪmæks	climax	\N	
0f9b1333-caf2-47e2-9f5f-e10c0d19252e	2025-10-10 18:49:49.8244	2025-10-10 18:49:49.8244	null	B1	[Literature] Explore the story's theme. | [Book] The theme is love. | [Film] The theme shapes the narrative.	\N	The central idea or message in a work of art or literature.	chủ đề	θiːm	theme	\N	
9071d528-f356-413b-b6b3-a3b8a168f872	2025-10-10 18:49:49.8274	2025-10-10 18:49:49.8274	null	B1	[Literature] The dove is a symbol of peace. | [Art] Use symbols in writing. | [Culture] Symbols carry meaning.	\N	An object or image representing something else.	biểu tượng	ˈsɪmbl	symbol	\N	
c66d603b-0764-4f24-a8e7-e47ff0cff1c3	2025-10-10 18:49:49.830403	2025-10-10 18:49:49.830403	null	B2	[Literature] Use a metaphor in poetry. | [Writing] The metaphor enhances meaning. | [Speech] Explain with a metaphor.	\N	A figure of speech comparing two unlike things without using 'like' or 'as'.	ẩn dụ	ˈmetəfə	metaphor	\N	
9ac9684f-1f2d-40a0-a4b6-d9ecf9a344d7	2025-10-10 18:49:49.833411	2025-10-10 18:49:49.833411	null	C1	[Literature] Irony adds depth to stories. | [Situation] The irony was unexpected. | [Humor] Use irony in writing.	\N	A situation or expression where the outcome or meaning is opposite to what is expected.	sự mỉa mai	ˈaɪrəni	irony	\N	
f2d3c699-fab2-4275-a0df-e27ff89151f1	2025-10-10 18:49:49.836639	2025-10-10 18:49:49.836639	null	B2	[Literature] Share a folktale with kids. | [Culture] Folktales teach morals. | [Story] Retell ancient folktales.	\N	A traditional story passed down orally within a culture.	truyện dân gian	ˈfəʊkteɪl	folktale	\N	
acaa7eb1-e1fe-4fea-a595-e21e85491a2e	2025-10-10 18:49:49.839648	2025-10-10 18:49:49.839648	null	B2	[Literature] Read a fable to children. | [Story] Fables teach lessons. | [Moral] The fable has a moral.	\N	A short story with animals as characters, teaching a moral.	ngụ ngôn	ˈfeɪbl	fable	\N	
5a677e39-ca9b-48e2-87af-8d4bd4de1e95	2025-10-10 18:49:49.844295	2025-10-10 18:49:49.844295	null	B1	[Publishing] The editor reviews manuscripts. | [Media] Work as a news editor. | [Writing] Consult the editor for feedback.	\N	A person who prepares content for publication.	biên tập viên	ˈedɪtə	editor	\N	
9fcf4011-2901-4f3a-8ce8-24fc4448b6ba	2025-10-10 18:49:49.847823	2025-10-10 18:49:49.847823	null	B2	[Book] Submit to a publisher. | [Industry] Work for a publisher. | [Process] The publisher prints books.	\N	A company or person that prepares and issues books or other materials.	nhà xuất bản	ˈpʌblɪʃə	publisher	\N	
b5d2633d-cef9-44de-b067-a2887371feeb	2025-10-10 18:49:49.85173	2025-10-10 18:49:49.85173	null	B1	[Work] Meet the project deadline. | [Publishing] Submit before the deadline. | [Stress] Work under deadline pressure.	\N	The time by which something must be completed.	hạn chót	ˈdedlaɪn	deadline	\N	
8aae4914-2af6-45e8-9a15-1dfc0af43d9c	2025-10-10 18:49:49.855192	2025-10-10 18:49:49.855192	null	B2	[Writing] Proofread the document carefully. | [Publishing] Hire someone to proofread. | [Editing] Proofread for errors.	\N	To read and correct errors in a text.	hiệu đính	ˈpruːfriːd	proofread	\N	
dee0ba45-aa47-4963-bad1-c9535fa3f0bb	2025-10-10 18:49:49.8582	2025-10-10 18:49:49.8582	null	B2	[Publishing] Protect work with copyright. | [Law] Respect copyright rules. | [Media] Check copyright status.	\N	The legal right to control the use of a creative work.	bản quyền	ˈkɒpiraɪt	copyright	\N	
ad8d4724-f1e0-4e94-9717-f80a418c607d	2025-10-10 18:49:49.862224	2025-10-10 18:49:49.862224	null	B2	[Publishing] Earn royalties from books. | [Author] Receive royalty payments. | [Contract] Negotiate royalty rates.	\N	A payment made to an author or creator for their work.	tiền bản quyền	ˈrɔɪəlti	royalty	\N	
1d07efd9-c210-44e7-9bb5-90b61d02d923	2025-10-10 18:49:49.864886	2025-10-10 18:49:49.864886	null	B2	[Media] The newspaper has a wide circulation. | [Health] Good circulation improves health. | [Economy] Money circulation boosts trade.	\N	The distribution or number of copies of a publication sold.	lưu hành (báo chí)/tuần hoàn	ˌsɜːkjəˈleɪʃn	circulation	\N	
0ae6f709-7a8c-4ab9-a170-9780a3ab2790	2025-10-10 18:49:49.868589	2025-10-10 18:49:49.868589	null	B1	[News] The headline grabbed attention. | [Article] Write a catchy headline. | [Media] Read the latest headlines.	\N	The title of a news article or story.	tiêu đề	ˈhedlaɪn	headline	\N	
00cee702-8be3-4a95-a97a-af6936a05873	2025-10-10 18:49:49.872605	2025-10-10 18:49:49.872605	null	B2	[Journalism] The article includes a byline. | [Writer] Earn a byline for your work. | [News] Check the byline for the author.	\N	The line in a newspaper or article giving the authorâ€™s name.	tên tác giả (bài báo)	ˈbaɪlaɪn	byline	\N	
147ec701-da5a-4ad5-9828-608382af5b84	2025-10-10 18:49:49.875617	2025-10-10 18:49:49.875617	null	B2	[News] Read the editorial in the paper. | [Opinion] Write an editorial on politics. | [Media] The editorial sparked debate.	\N	An article expressing the opinion of the editor or publication.	bài xã luận	ˌedɪˈtɔːriəl	editorial	\N	
721f3e98-7a9a-415a-a2f3-dc9d38f5f414	2025-10-10 18:49:49.878908	2025-10-10 18:49:49.878908	null	B2	[Career] Study journalism at university. | [Media] Journalism informs the public. | [Ethics] Practice ethical journalism.	\N	The profession of writing or reporting news for media.	báo chí	ˈdʒɜːnəlɪzəm	journalism	\N	
f2fb5530-e5c8-48bc-8f8c-7fc1006850f7	2025-10-10 18:49:49.882923	2025-10-10 18:49:49.882923	null	B1	[News] Write a weekly column. | [Journalism] Read the opinion column. | [Media] The column covers local events.	\N	A regular article or feature in a newspaper or magazine.	cột báo	ˈkɒləm	column	\N	
ed4a3f21-01b4-42fe-beea-be5d80b7167f	2025-10-10 18:49:49.885923	2025-10-10 18:49:49.885923	null	B2	[Journalism] Publish a feature story. | [Magazine] Read the feature article. | [News] The feature highlights culture.	\N	A special or prominent article in a publication.	bài đặc biệt	ˈfiːtʃə	feature	\N	
fccd63b7-af2a-47f1-afd4-2510e78a0fc6	2025-10-10 18:49:49.887923	2025-10-10 18:49:49.887923	null	B1	[Media] The press covered the event. | [News] Speak to the press. | [Journalism] Freedom of the press is vital.	\N	Newspapers or journalists collectively.	báo chí	pres	press	\N	
2ae2e4d4-607f-4c81-9e4a-b158f394859e	2025-10-10 18:49:49.893812	2025-10-10 18:49:49.893812	null	B2	[Media] Access the news archive. | [History] Archive old documents. | [Digital] Store files in the archive.	\N	A collection of historical documents or records.	lưu trữ	ˈɑːkaɪv	archive	\N	
14fe6c8a-eac5-46c4-b1d5-62817daf1e78	2025-10-10 18:49:49.899191	2025-10-10 18:49:49.899191	null	B1	[Media] Watch a live broadcast. | [TV] Broadcast the sports event. | [News] The broadcast reached millions.	\N	To transmit a program or information via radio or television.	phát sóng	ˈbrɔːdkɑːst	broadcast	\N	
8dda7592-45b7-4d36-aa90-d77899eb6a20	2025-10-10 18:49:49.903475	2025-10-10 18:49:49.903475	null	B2	[TV] The anchor reported the news. | [Broadcast] Trust the news anchor. | [Media] The anchor hosts the show.	\N	A person who presents news or programs on television or radio.	người dẫn chương trình	ˈæŋkə	anchor	\N	
ea7a9840-e31c-449c-a87e-6ec03e65aa8f	2025-10-10 18:49:49.905984	2025-10-10 18:49:49.905984	null	B2	[TV] Watch a news segment. | [Broadcast] Air a short segment. | [Show] The segment covers health tips.	\N	A part of a program or broadcast.	phân đoạn (chương trình)	ˈseɡmənt	segment	\N	
4843714b-fcf2-4889-80b7-337fc38f60bd	2025-10-10 18:49:49.909489	2025-10-10 18:49:49.909489	null	B1	[Media] Record in a TV studio. | [Music] Work in a recording studio. | [Broadcast] Visit the news studio.	\N	A room where broadcasts or recordings are made.	phòng thu	ˈstjuːdiəu	studio	\N	
3bbb2b8b-41c3-4b06-8512-64ec84e4e402	2025-10-10 18:49:49.91351	2025-10-10 18:49:49.91351	null	B2	[Media] Review the video footage. | [News] Share exclusive footage. | [Film] Capture live event footage.	\N	Raw video material used in broadcasting or filmmaking.	đoạn phim	ˈfʊtɪdʒ	footage	\N	
032187df-beb1-4707-9947-7f8ee61259ee	2025-10-10 18:49:49.91651	2025-10-10 18:49:49.91651	null	B1	[Media] Watch streaming movies. | [Technology] Use a streaming platform. | [Live] Streaming concerts is popular.	\N	The continuous transmission of audio or video over the internet.	phát trực tuyến	ˈstriːmɪŋ	streaming	\N	
92b8e6f0-804d-45b5-8cef-2bd874e157af	2025-10-10 18:49:49.919512	2025-10-10 18:49:49.919512	null	B2	[News] The correspondent reported live. | [Media] Follow the foreign correspondent. | [Journalism] Hire a war correspondent.	\N	A journalist reporting news from a particular location.	phóng viên	ˌkɒrəˈspɒndənt	correspondent	\N	
66ed1f11-e7f1-4362-ac73-93012a85fbbc	2025-10-10 18:49:49.923571	2025-10-10 18:49:49.923571	null	A2	[Media] Conduct an interview with a celebrity. | [Job] Prepare for a job interview. | [News] Watch the live interview.	\N	A conversation where questions are asked to gather information.	phỏng vấn	ˈɪntəvjuː	interview	\N	
2c3c0ee4-0a72-4ea1-9187-9474845a644f	2025-10-10 18:49:49.927245	2025-10-10 18:49:49.927245	null	B2	[Media] Watch the telecast tonight. | [Broadcast] Telecast the football match. | [Event] The telecast reached millions.	\N	A television broadcast.	phát sóng truyền hình	ˈtelɪkɑːst	telecast	\N	
4a91ad24-9c24-4b0a-885e-4a3926890b41	2025-10-10 18:49:49.93087	2025-10-10 18:49:49.93087	null	B1	[Broadcast] Improve the TV signal. | [Technology] Check the signal strength. | [Communication] Send a clear signal.	\N	An electronic or visual indication used for communication.	tín hiệu	ˈsɪɡnəl	signal	\N	
8be66ca4-38da-43f3-b78d-415f3428674d	2025-10-10 18:49:49.934851	2025-10-10 18:49:49.934851	null	B2	[News] Report a political scandal. | [Media] The scandal shocked the public. | [Celebrity] Avoid a media scandal.	\N	An event causing public outrage or disapproval.	vụ bê bối	ˈskændl	scandal	\N	
61efb3b4-24ad-4244-92b2-f0c2feb5c648	2025-10-10 18:49:49.937851	2025-10-10 18:49:49.937851	null	B1	[Media] Spread celebrity gossip. | [Talk] Avoid gossip at work. | [News] Gossip columns attract readers.	\N	Casual or sensational talk about peopleâ€™s personal lives.	tin đồn	ˈɡɒsɪp	gossip	\N	
1e0d7b91-0196-437c-b0dc-8e020bb035ac	2025-10-10 18:49:49.940151	2025-10-10 18:49:49.940151	null	B1	[Society] Ignore the false rumor. | [Media] Rumors spread quickly online. | [News] Confirm or deny the rumor.	\N	An unverified story or piece of information circulating among people.	tin đồn	ˈruːmə	rumor	\N	
b92d9a3b-8221-465d-a51f-8e595eb13001	2025-10-10 18:49:49.943901	2025-10-10 18:49:49.943901	null	B2	[Media] Read a tabloid magazine. | [News] Tabloids focus on gossip. | [Journalism] Avoid tabloid-style reporting.	\N	A newspaper focusing on sensational or celebrity news.	báo lá cải	ˈtæblɔɪd	tabloid	\N	
3ab5a4de-5c62-4336-916c-76218f356382	2025-10-10 18:49:49.946901	2025-10-10 18:49:49.946901	null	B2	[Media] Write a sensational headline. | [News] The story was sensational. | [Report] Avoid sensational reporting.	\N	Causing intense interest, excitement, or shock.	gây sốc	senˈseɪʃənl	sensational	\N	
e4c934ab-afac-473c-a668-3f9153095f1e	2025-10-10 18:49:49.949905	2025-10-10 18:49:49.949905	null	C1	[Media] Recognize propaganda in news. | [Politics] Propaganda influences opinions. | [History] Study wartime propaganda.	\N	Information, often biased, used to promote a political cause.	tuyên truyền	ˌprɒpəˈɡændə	propaganda	\N	
4b211b45-b61b-4656-ad5d-ce4dd19e56bc	2025-10-10 18:49:49.953801	2025-10-10 18:49:49.953801	null	C1	[Media] Oppose media censorship. | [Government] Censorship limits free speech. | [News] Censorship affects reporting.	\N	The suppression or control of information in media.	kiểm duyệt	ˈsensəʃɪp	censorship	\N	
9c0b5906-f6d9-44ca-95bb-1b88eebe227f	2025-10-10 18:49:49.957504	2025-10-10 18:49:49.957504	null	B2	[Media] Avoid bias in reporting. | [Opinion] Recognize personal bias. | [News] Bias affects news credibility.	\N	A tendency to favor one perspective over others.	thiên vị	ˈbaɪəs	bias	\N	
6ee4cab8-d247-4681-a9a4-64a3eec28263	2025-10-10 18:49:49.960764	2025-10-10 18:49:49.960764	null	C1	[Media] Build credibility in journalism. | [Source] Check the source's credibility. | [Trust] Credibility ensures trust.	\N	The quality of being trusted or believed in.	độ tin cậy	ˌkredəˈbɪləti	credibility	\N	
3831aca6-deb7-4737-9d1f-3f763e76d53b	2025-10-10 18:49:49.964283	2025-10-10 18:49:49.964283	null	C1	[Journalism] Maintain objectivity in reporting. | [News] Objectivity builds trust. | [Media] Strive for objectivity.	\N	The quality of being impartial and free from bias.	tính khách quan	ˌɒbdʒekˈtɪvəti	objectivity	\N	
71ccdbff-cdb8-420e-9dd4-b969dd027798	2025-10-10 18:49:49.967283	2025-10-10 18:49:49.967283	null	C1	[Journalism] Publish an exposé on corruption. | [Media] The exposé shocked readers. | [News] Write an investigative exposé.	\N	A report revealing hidden or scandalous information.	bài vạch trần	ˌekspəʊˈzeɪ	exposé	\N	
fedc4968-5036-4f07-b5c1-02da0c7e0f89	2025-10-10 18:49:49.970297	2025-10-10 18:49:49.970297	null	A2	[Society] Embrace local culture. | [Travel] Experience a new culture. | [Diversity] Culture shapes identity.	\N	The beliefs, customs, and arts of a particular society.	văn hóa	ˈkʌltʃə	culture	\N	
c5242118-e645-4997-94da-c258df490a2e	2025-10-10 18:49:49.975089	2025-10-10 18:49:49.975089	null	B2	[Society] Follow dining etiquette. | [Culture] Learn business etiquette. | [Behavior] Etiquette shows respect.	\N	The rules of polite behavior in a society.	phép lịch sự	ˈetɪket	etiquette	\N	
7b9949e1-3263-4ef0-9797-f2a01a682411	2025-10-10 18:49:49.977089	2025-10-10 18:49:49.977089	null	B2	[Society] Follow social norms. | [Behavior] Norms guide interactions. | [Culture] Norms differ by country.	\N	A standard or expected pattern of behavior.	chuẩn mực	nɔːm	norm	\N	
74e1f67d-8872-4a40-852a-b460e3d7aa86	2025-10-10 18:49:49.981098	2025-10-10 18:49:49.981098	null	B2	[Culture] Avoid common superstitions. | [Belief] Superstitions influence behavior. | [Tradition] Learn about local superstitions.	\N	A belief in something not based on reason or science.	mê tín	ˌsuːpəˈstɪʃn	superstition	\N	
5436c34e-4288-4164-a9f7-c60a15bddbd9	2025-10-10 18:49:49.985333	2025-10-10 18:49:49.985333	null	B2	[History] Discover ancient artifacts. | [Museum] Display cultural artifacts. | [Archaeology] Study the artifact's origin.	\N	An object made by humans, often of historical value.	di vật	ˈɑːtɪfækt	artifact	\N	
9b87a142-1cac-451c-8ef0-4bb4f34d5e48	2025-10-10 18:49:49.989485	2025-10-10 18:49:49.989485	null	B1	[Food] Enjoy Italian cuisine. | [Culture] Explore Asian cuisine. | [Restaurant] Try local cuisine.	\N	A style of cooking characteristic of a region or culture.	phong cách ẩm thực	kwɪˈziːn	cuisine	\N	
d134cb8c-4e65-4b8a-9805-3baecd222021	2025-10-10 18:49:49.993521	2025-10-10 18:49:49.993521	null	B1	[Cooking] Add seasoning to the dish. | [Flavor] Use natural seasonings. | [Kitchen] Buy new seasonings.	\N	Ingredients used to enhance the flavor of food.	gia vị	ˈsiːzənɪŋ	seasoning	\N	
aacc96ba-8409-4130-8d1b-006405af356a	2025-10-10 18:49:49.996029	2025-10-10 18:49:49.996029	null	B1	[Food] Serve appetizers at the party. | [Restaurant] Order a light appetizer. | [Menu] Choose a tasty appetizer.	\N	A small dish served before a meal to stimulate appetite.	món khai vị	ˈæpɪtaɪzə	appetizer	\N	
d27b18e4-0688-48c6-bb49-2412319272cc	2025-10-10 18:49:49.999029	2025-10-10 18:49:49.999029	null	B2	[Food] The entree was delicious. | [Restaurant] Choose a seafood entree. | [Menu] The entree comes with sides.	\N	The main course of a meal.	món chính	ˈɒntreɪ	entree	\N	
0a49e6eb-40d1-473c-8e7a-589389e03233	2025-10-10 18:49:50.005039	2025-10-10 18:49:50.005039	null	B2	[Food] Try gourmet dishes. | [Restaurant] Visit a gourmet restaurant. | [Cooking] Learn gourmet recipes.	\N	High-quality food or sophisticated cooking.	ẩm thực cao cấp	ˈɡɔːmeɪ	gourmet	\N	
e4d1bb28-bcc8-4561-8899-f31551eeaa25	2025-10-10 18:49:50.008548	2025-10-10 18:49:50.008548	null	B1	[Food] Choose a vegetarian meal. | [Diet] Become a vegetarian. | [Menu] Offer vegetarian options.	\N	A person who does not eat meat, or food excluding meat.	ăn chay	ˌvedʒəˈteəriən	vegetarian	\N	
c83e1718-4557-4dbe-8f6c-adc237f9245c	2025-10-10 18:49:50.012552	2025-10-10 18:49:50.012552	null	B2	[Food] Cook a vegan dish. | [Diet] Follow a vegan lifestyle. | [Menu] Include vegan recipes.	\N	A person who avoids all animal products, or food without them.	thuần chay	ˈviːɡən	vegan	\N	
08cfc2ef-009e-4d28-8b70-72cb21ff0b8e	2025-10-10 18:49:50.016548	2025-10-10 18:49:50.016548	null	B1	[Art] Study modern architecture. | [Building] Admire ancient architecture. | [Design] Architecture shapes cities.	\N	The art or practice of designing buildings.	kiến trúc	ˈɑːkɪtektʃə	architecture	\N	
a7c3202b-8ef0-4697-b719-cb5cbd4c478c	2025-10-10 18:49:50.019551	2025-10-10 18:49:50.019551	null	B2	[Architecture] Review the building blueprint. | [Plan] Create a project blueprint. | [Design] Follow the blueprint.	\N	A detailed plan or design, often for a building.	bản thiết kế	ˈbluːprɪnt	blueprint	\N	
abada2ba-197c-46fa-9d20-34d9844aed2b	2025-10-10 18:49:50.024038	2025-10-10 18:49:50.024038	null	B1	[Architecture] Design a strong structure. | [Building] Inspect the structure's safety. | [Engineering] Study building structures.	\N	Something built, like a building or framework.	cấu trúc	ˈstrʌktʃə	structure	\N	
73a4caf7-5f43-444a-86e2-c962a1b6468d	2025-10-10 18:49:50.026039	2025-10-10 18:49:50.026039	null	B2	[Architecture] The facade looks modern. | [Building] Design a unique facade. | [Aesthetics] The facade enhances beauty.	\N	The front of a building or a superficial appearance.	mặt tiền	fəˈsɑːd	facade	\N	
8ba50fc1-df40-40c6-bf44-e183208c021b	2025-10-10 18:49:50.029048	2025-10-10 18:49:50.029048	null	B1	[Architecture] Lay a strong foundation. | [Building] Check the foundation's stability. | [Metaphor] Build a solid foundation.	\N	The base on which a building or structure rests.	nền móng	faʊnˈdeɪʃn	foundation	\N	
8e3e95df-79c2-4630-8a4a-5282ad1cca3c	2025-10-10 18:49:50.033391	2025-10-10 18:49:50.033391	null	B2	[Architecture] Install steel beams. | [Building] Beams support the structure. | [Construction] Check the beam's strength.	\N	A horizontal piece of wood or metal supporting a structure.	dầm	biːm	beam	\N	
3262ab29-8fb4-4cf6-88f7-b5c5f6a8b21f	2025-10-10 18:49:50.037024	2025-10-10 18:49:50.037024	null	B1	[Architecture] Visit a tall skyscraper. | [City] Skyscrapers define the skyline. | [Design] Build a modern skyscraper.	\N	A very tall building with many stories.	tòa nhà chọc trời	ˈskaɪskreɪpə	skyscraper	\N	
f908de00-2030-43fb-94c0-171b5c4c718b	2025-10-10 18:49:50.040026	2025-10-10 18:49:50.040026	null	B2	[Architecture] Plan a home renovation. | [Building] Renovation improves value. | [Project] Fund the renovation.	\N	The act of improving or updating a building.	sự cải tạo	ˌrenəˈveɪʃn	renovation	\N	
38fad0f0-dc36-42e0-89f8-5feeab404413	2025-10-10 18:49:50.043806	2025-10-10 18:49:50.043806	null	B2	[Architecture] Add ornaments to the building. | [Design] Use decorative ornaments. | [Art] Ornaments enhance aesthetics.	\N	A decorative object or detail added to a structure.	đồ trang trí	ˈɔːnəmənt	ornament	\N	
1d999b41-1ea1-4fba-9012-1f5d7a170753	2025-10-10 18:49:50.046811	2025-10-10 18:49:50.046811	null	B1	[Space] Astronauts explore space. | [Career] Train to be an astronaut. | [Mission] Astronauts landed on the moon.	\N	A person trained to travel or work in space.	phi hành gia	ˈæstrənɔːt	astronaut	\N	
2d3d4fc8-26ca-49c5-97f6-d10220a402bf	2025-10-10 18:49:50.050978	2025-10-10 18:49:50.050978	null	B2	[Space] The satellite is in orbit. | [Astronomy] Planets orbit the sun. | [Mission] Launch into low orbit.	\N	The path of a celestial body around another.	quỹ đạo	ˈɔːbɪt	orbit	\N	
e0b4806f-c318-4e7c-b459-4db8b3d544be	2025-10-10 18:49:50.055217	2025-10-10 18:49:50.055217	null	B2	[Space] Design a new spacecraft. | [Mission] The spacecraft reached Mars. | [Technology] Build advanced spacecraft.	\N	A vehicle designed for travel in outer space.	tàu vũ trụ	ˈspeɪskrɑːft	spacecraft	\N	
b9ee40fc-cda1-4574-8945-2f9fd0fa897b	2025-10-10 18:49:50.058216	2025-10-10 18:49:50.058216	null	B1	[Space] Complete a space mission. | [Goal] The mission explored Jupiter. | [Project] Fund a new mission.	\N	A specific task or journey, often in space or for a purpose.	sứ mệnh	ˈmɪʃn	mission	\N	
10a7c159-43c8-41eb-947f-544f5eac1ecb	2025-10-10 18:49:50.061846	2025-10-10 18:49:50.061846	null	A2	[Space] Launch a rocket to space. | [Technology] Build a powerful rocket. | [Mission] The rocket carried satellites.	\N	A vehicle propelled by engines, often for space travel.	tên lửa	ˈrɒkɪt	rocket	\N	
c9fc9529-0694-4985-adbf-a69dde03ed21	2025-10-10 18:49:50.06514	2025-10-10 18:49:50.06514	null	B1	[Space] Track the satellite's orbit. | [Technology] Satellites improve communication. | [Weather] Satellites monitor storms.	\N	An object launched to orbit Earth for communication or observation.	vệ tinh	ˈsætəlaɪt	satellite	\N	
e5772443-ce05-481a-91cb-ec9a0b709215	2025-10-10 18:49:50.06874	2025-10-10 18:49:50.06874	null	B2	[Space] Explore the vast cosmos. | [Astronomy] Study the cosmos in class. | [Universe] The cosmos is infinite.	\N	The universe considered as a whole.	vũ trụ	ˈkɒzmɒs	cosmos	\N	
f51fcc18-fbc8-4e22-84fc-8c20bfaef8b9	2025-10-10 18:49:50.072617	2025-10-10 18:49:50.072617	null	B2	[Astronomy] Visit the local observatory. | [Science] Observatories track stars. | [Research] Work at an observatory.	\N	A building equipped for observing astronomical events.	đài thiên văn	əbˈzɜːvətəri	observatory	\N	
c6183c1e-59d0-4f46-831a-43f2a7124b08	2025-10-10 18:49:50.076624	2025-10-10 18:49:50.076624	null	B2	[Science] Research forest ecology. | [Environment] Ecology studies ecosystems. | [Nature] Protect ecology balance.	\N	The study of relationships between organisms and their environment.	sinh thái học	iˈkɒlədʒi	ecology	\N	
ee826772-c967-4fa2-87be-8ea0134700c5	2025-10-10 18:49:50.079628	2025-10-10 18:49:50.079628	null	B2	[Biology] Study living organisms. | [Science] Organisms adapt to environments. | [Nature] Microorganisms are tiny.	\N	A living thing, such as a plant, animal, or microbe.	sinh vật	ˈɔːɡənɪzəm	organism	\N	
895ebdd8-5189-437d-a5cc-66398173ae64	2025-10-10 18:49:50.083651	2025-10-10 18:49:50.083651	null	B1	[Biology] Examine cells under a microscope. | [Science] Cells form tissues. | [Research] Study cell division.	\N	The basic unit of life in living organisms.	tế bào	sel	cell	\N	
d05318e9-4674-4643-a927-a9cccd82b5f3	2025-10-10 18:49:50.086616	2025-10-10 18:49:50.086616	null	B2	[Biology] DNA carries genetic information. | [Science] Study DNA in genetics. | [Research] Analyze DNA samples.	\N	The molecule carrying genetic information in living organisms.	DNA	ˌdiː en ˈeɪ	dna	\N	
0e275ff6-28a7-4111-b085-7b57e5811d56	2025-10-10 18:49:50.089345	2025-10-10 18:49:50.089345	null	C1	[Biology] Map the human genome. | [Science] Genomes store genetic data. | [Research] Study genome sequencing.	\N	The complete set of genes in an organism.	bộ gen	ˈdʒiːnəʊm	genome	\N	
6cae8abe-fb2b-4f35-8a53-7f47ffddbfa9	2025-10-10 18:49:50.094178	2025-10-10 18:49:50.094178	null	B2	[Biology] Study the theory of evolution. | [Science] Evolution shapes species. | [Nature] Evolution takes millions of years.	\N	The process by which species change over time.	tiến hóa	ˌiːvəˈluːʃn	evolution	\N	
1d360df8-d1b7-4bac-8877-8f8cf8f1c1ad	2025-10-10 18:49:50.096178	2025-10-10 18:49:50.096178	null	B1	[Biology] Protect endangered species. | [Science] Study different species. | [Nature] New species are discovered.	\N	A group of organisms capable of interbreeding.	loài	ˈspiːʃiːz	species	\N	
c5fe5ad2-4cb4-43a1-b749-eb09b64a6c37	2025-10-10 18:49:50.101101	2025-10-10 18:49:50.101101	null	B2	[Biology] Animals show adaptation to climates. | [Science] Study adaptation in species. | [Nature] Adaptation ensures survival.	\N	A trait or change helping an organism survive in its environment.	sự thích nghi	ˌædæpˈteɪʃn	adaptation	\N	
353856f1-c5f3-4cba-a895-5ee5c5876fe0	2025-10-10 18:49:50.10522	2025-10-10 18:49:50.10522	null	B1	[Physics] Study laws of motion. | [Science] Motion affects speed. | [Experiment] Observe objects in motion.	\N	The act or process of moving or changing position.	chuyển động	ˈməʊʃn	motion	\N	
1860d6b7-4484-460b-af88-333b43880c06	2025-10-10 18:49:50.108863	2025-10-10 18:49:50.108863	null	B1	[Physics] Measure the force applied. | [Science] Force causes movement. | [Experiment] Test force in experiments.	\N	A push or pull that causes motion or change.	lực	fɔːs	force	\N	
c4ec5912-259e-47e8-bf65-aec7177f8ca3	2025-10-10 18:49:50.11238	2025-10-10 18:49:50.11238	null	B2	[Physics] Friction slows movement. | [Science] Study friction in physics. | [Experiment] Test friction on surfaces.	\N	The force resisting motion between two surfaces.	ma sát	ˈfrɪkʃn	friction	\N	
a6ac2b2d-a26f-4398-b36b-70bdcd3cf3b7	2025-10-10 18:49:50.115524	2025-10-10 18:49:50.115524	null	B2	[Physics] Calculate the object's velocity. | [Science] Velocity measures speed. | [Motion] Velocity affects distance.	\N	The speed of an object in a particular direction.	vận tốc	vəˈlɒsəti	velocity	\N	
f2b01b3e-593f-4f4e-82f3-de574676e79d	2025-10-10 18:49:50.119069	2025-10-10 18:49:50.119069	null	B2	[Physics] Measure the car's acceleration. | [Science] Acceleration changes speed. | [Experiment] Study acceleration in motion.	\N	The rate of change of velocity over time.	gia tốc	əkˌseləˈreɪʃn	acceleration	\N	
a6ba2a2c-cfd2-4df7-90aa-66e0b0895c6b	2025-10-10 18:49:50.123555	2025-10-10 18:49:50.123555	null	B2	[Physics] Study magnetism in class. | [Science] Magnetism attracts metals. | [Experiment] Test magnetism with magnets.	\N	The force exerted by magnets, attracting or repelling objects.	từ tính	ˈmæɡnətɪzəm	magnetism	\N	
34535e43-7658-4967-b4cf-a2097aaa2d20	2025-10-10 18:49:50.12791	2025-10-10 18:49:50.12791	null	A2	[Physics] Generate electricity from wind. | [Science] Electricity powers homes. | [Experiment] Study electricity flow.	\N	A form of energy from charged particles.	điện	ɪˌlekˈtrɪsəti	electricity	\N	
b8d945fb-c29c-4733-89ee-06b5d3d2c407	2025-10-10 18:49:50.134205	2025-10-10 18:49:50.134205	null	B1	[Chemistry] Observe a chemical reaction. | [Science] Study reaction rates. | [Experiment] Cause a reaction in lab.	\N	A process where substances change or interact.	phản ứng	riˈækʃn	reaction	\N	
19ad1db6-0008-4922-834b-fc4a4dab829d	2025-10-10 18:49:50.137208	2025-10-10 18:49:50.137208	null	B2	[Chemistry] Form a new compound. | [Science] Study chemical compounds. | [Lab] Analyze the compound's properties.	\N	A substance formed by chemically combining elements.	hợp chất	ˈkɒmpaʊnd	compound	\N	
e331e4cf-28ef-4cbe-9a4a-1e0899aa29a0	2025-10-10 18:49:50.142205	2025-10-10 18:49:50.142205	null	B1	[Chemistry] Learn the periodic elements. | [Science] Elements form compounds. | [Lab] Study the element carbon.	\N	A pure substance that cannot be broken down chemically.	nguyên tố	ˈelɪmənt	element	\N	
f38de71c-917a-478f-a37d-331a777fbb35	2025-10-10 18:49:50.145926	2025-10-10 18:49:50.145926	null	B1	[Chemistry] Create a chemical mixture. | [Science] Study mixture properties. | [Lab] Separate the mixture.	\N	A combination of substances not chemically bonded.	hỗn hợp	ˈmɪkstʃə	mixture	\N	
c1cea1da-ae4e-4ea7-8c43-b02dcefbed4a	2025-10-10 18:49:50.148926	2025-10-10 18:49:50.148926	null	B1	[Chemistry] Prepare a chemical solution. | [Science] Test the solution's pH. | [Lab] Mix a saline solution.	\N	A homogeneous mixture of a solute dissolved in a solvent.	dung dịch	səˈluːʃn	solution	\N	
d87723b6-239a-4f63-ba07-b0788ba2ddf8	2025-10-10 18:49:50.15393	2025-10-10 18:49:50.15393	null	C1	[Chemistry] Use a catalyst in reactions. | [Science] Catalysts speed up processes. | [Lab] Study catalyst effects.	\N	A substance that speeds up a chemical reaction without being consumed.	chất xúc tác	ˈkætəlɪst	catalyst	\N	
62847eca-5dc3-44a7-b323-8abca1f30553	2025-10-10 18:49:50.156927	2025-10-10 18:49:50.156927	null	B1	[Chemistry] Handle acid with care. | [Science] Test the acid's pH. | [Lab] Mix acid in a solution.	\N	A substance with a pH less than 7, often corrosive.	axit	ˈæsɪd	acid	\N	
5b13ecf7-9a49-4989-9578-0287fbcc3a2f	2025-10-10 18:49:50.161216	2025-10-10 18:49:50.161216	null	B2	[Chemistry] Bases neutralize acids. | [Science] Study base properties. | [Lab] Use a base in experiments.	\N	A substance with a pH greater than 7, often neutralizing acids.	kiềm	beɪs	base	\N	
d5309492-806a-467e-af76-94b02ecbda44	2025-10-10 18:49:50.165097	2025-10-10 18:49:50.165097	null	C1	[Chemistry] Polymers form plastics. | [Science] Study polymer structures. | [Industry] Use polymers in manufacturing.	\N	A large molecule made of repeating subunits.	polyme	ˈpɒlɪmə	polymer	\N	
20fa3db0-2bb1-4893-9417-634ce70bc0d6	2025-10-10 18:49:50.168093	2025-10-10 18:49:50.168093	null	B2	[Chemistry] Ions carry electric charge. | [Science] Study ion behavior. | [Lab] Analyze ion reactions.	\N	An atom or molecule with an electric charge.	ion	ˈaɪən	ion	\N	
8c6a80a1-f18e-40b4-bd09-271f71535dcf	2025-10-10 18:49:50.171099	2025-10-10 18:49:50.171099	null	B2	[Chemistry] Form a chemical bond. | [Science] Study covalent bonds. | [Lab] Analyze bond strength.	\N	A chemical connection between atoms in a molecule.	liên kết (hóa học)	bɒnd	bond	\N	
50cfea3a-7c16-4787-8566-628892ed550d	2025-10-10 18:49:50.176238	2025-10-10 18:49:50.176238	null	C1	[Chemistry] Form a precipitate in solution. | [Science] Study precipitate formation. | [Lab] Precipitate separates in water.	\N	A solid formed from a chemical reaction in a liquid.	kết tủa	prɪˈsɪpɪteɪt	precipitate	\N	
47cec108-f0f3-410c-ad50-c8a95ddde5c4	2025-10-10 18:49:50.178737	2025-10-10 18:49:50.178737	null	C1	[Chemistry] Use a solvent to dissolve. | [Science] Solvents clean surfaces. | [Lab] Choose the right solvent.	\N	A substance that dissolves another to form a solution.	dung môi	ˈsɒlvənt	solvent	\N	
77cd027d-e01c-491a-b8d5-78346f4ff542	2025-10-10 18:49:50.182828	2025-10-10 18:49:50.182828	null	C1	[Chemistry] Perform distillation in lab. | [Science] Distillation purifies liquids. | [Process] Study distillation techniques.	\N	The process of purifying a liquid by heating and cooling.	chưng cất	ˌdɪstɪˈleɪʃn	distillation	\N	
5c4659b7-af82-4eb1-8a40-deb1686fa27e	2025-10-10 18:49:50.186211	2025-10-10 18:49:50.186211	null	C1	[Chemistry] Neutralization balances acids and bases. | [Science] Study neutralization reactions. | [Lab] Perform a neutralization experiment.	\N	A reaction between an acid and base to form water and salt.	sự trung hòa	njuːtrəlaɪˈzeɪʃn	neutralization	\N	
a87ba1b3-4bb9-492e-bd8c-f1026a4d1c57	2025-10-10 18:49:50.189259	2025-10-10 18:49:50.189259	null	B2	[Science] Study geology in university. | [Research] Geology explores Earth's structure. | [Career] Work as a geologist.	\N	The study of Earthâ€™s structure, materials, and processes.	địa chất học	dʒiˈɒlədʒi	geology	\N	
f0c223a8-7cc8-40a5-8697-5b6afeec7de6	2025-10-10 18:49:50.193716	2025-10-10 18:49:50.193716	null	B1	[Geology] Identify minerals in rocks. | [Science] Minerals form crystals. | [Nature] Study mineral properties.	\N	A naturally occurring inorganic substance with a specific composition.	khoáng vật	ˈmɪnərəl	mineral	\N	
5564e0a5-0ec8-4669-8e69-c26b66670cd7	2025-10-10 18:49:50.197332	2025-10-10 18:49:50.197332	null	B1	[Geology] Discover dinosaur fossils. | [Science] Fossils reveal ancient life. | [Museum] Display fossil collections.	\N	The preserved remains of ancient organisms.	hóa thạch	ˈfɒsl	fossil	\N	
76c8ff48-e28d-4e79-a06a-79b922460a21	2025-10-10 18:49:50.201841	2025-10-10 18:49:50.201841	null	A2	[Geology] Visit an active volcano. | [Science] Study volcano eruptions. | [Nature] Volcanoes shape Earth's crust.	\N	A mountain that erupts molten rock, ash, and gases.	núi lửa	vɒlˈkeɪnəu	volcano	\N	
3e75dd6a-74ad-4f0c-befa-c4cd00da8491	2025-10-10 18:49:50.204684	2025-10-10 18:49:50.204684	null	A2	[Geology] Prepare for an earthquake. | [Science] Study earthquake causes. | [Safety] Earthquake drills save lives.	\N	A sudden shaking of the Earthâ€™s surface caused by tectonic movement.	động đất	ˈɜːθkweɪk	earthquake	\N	
e4d7947e-52a7-4a9d-8ef1-8fb6771ce30a	2025-10-10 18:49:50.208712	2025-10-10 18:49:50.208712	null	C1	[Geology] Analyze river sediment. | [Science] Sediments form rock layers. | [Nature] Study sediment deposition.	\N	Material deposited by water, wind, or ice.	trầm tích	ˈsedɪmənt	sediment	\N	
0e96a1ac-ae6d-414b-b362-69131aab1b4c	2025-10-10 18:49:50.211485	2025-10-10 18:49:50.211485	null	C1	[Geology] Magma fuels volcanoes. | [Science] Study magma composition. | [Earth] Magma forms igneous rocks.	\N	Molten rock beneath the Earthâ€™s surface.	dung nham (dưới lòng đất)	ˈmæɡmə	magma	\N	
b775e25c-12b4-4518-bf50-fa834650c4ce	2025-10-10 18:49:50.215001	2025-10-10 18:49:50.215001	null	B1	[Geology] Lava flows from volcanoes. | [Science] Study cooled lava rocks. | [Nature] Lava creates new land.	\N	Molten rock that flows from a volcano.	dung nham	ˈlɑːvə	lava	\N	
75d72a27-a432-4690-936e-1d8970435cf7	2025-10-10 18:49:50.22001	2025-10-10 18:49:50.22001	null	C1	[Astronomy] Observe a nebula through a telescope. | [Science] Nebulas form stars. | [Space] Nebulas are cosmic clouds.	\N	A cloud of gas and dust in space, often where stars form.	tinh vân	ˈnebjlə	nebula	\N	
99d1272c-3794-44ef-8b5a-cbc35a5ca3ed	2025-10-10 18:49:50.228497	2025-10-10 18:49:50.228497	null	B1	[Science] Study engineering at college. | [Career] Work in civil engineering. | [Technology] Engineering solves problems.	\N	The application of science to design machines or structures.	kỹ thuật	ˌendʒɪˈnɪərɪŋ	engineering	\N	
a9d0b29f-cb30-489a-b736-b5eff81ef6b2	2025-10-10 18:49:50.232633	2025-10-10 18:49:50.232633	null	B2	[Engineering] Build a product prototype. | [Design] Test the prototype's function. | [Innovation] Develop a new prototype.	\N	An early model of a product for testing.	nguyên mẫu	ˈprəʊtətaɪp	prototype	\N	
de43def9-5b4d-41de-b1be-d6579daa2b8c	2025-10-10 18:49:50.236625	2025-10-10 18:49:50.236625	null	B2	[Engineering] Study mechanics in physics. | [Science] Mechanics explains motion. | [Career] Work in auto mechanics.	\N	The branch of physics dealing with motion and forces.	cơ học	mɪˈkænɪks	mechanics	\N	
f0b3075d-476c-48ee-a3a0-e60619ce8f4e	2025-10-10 18:49:50.239626	2025-10-10 18:49:50.239626	null	C1	[Engineering] Automation improves efficiency. | [Technology] Use automation in factories. | [Science] Study automation systems.	\N	The use of machines to perform tasks automatically.	tự động hóa	ˌɔːtəˈmeɪʃn	automation	\N	
1385ef47-7644-463a-a535-770542e5122c	2025-10-10 18:49:50.243927	2025-10-10 18:49:50.243927	null	B2	[Engineering] Robotics advances technology. | [Science] Study robotics in college. | [Innovation] Robotics transforms industries.	\N	The branch of engineering dealing with robots.	ngành robot	rəʊˈbɒtɪks	robotics	\N	
37092294-0ce3-4c96-9820-67b64fadbb73	2025-10-10 18:49:50.247475	2025-10-10 18:49:50.247475	null	B2	[Engineering] Install a motion sensor. | [Technology] Sensors detect changes. | [Science] Study sensor applications.	\N	A device detecting changes in the environment.	cảm biến	ˈsensə	sensor	\N	
ab8c30b6-4ab2-4851-9a1d-a0334ba7206e	2025-10-10 18:49:50.25771	2025-10-10 18:49:50.25771	null	B1	[Environment] Agriculture feeds the world. | [Science] Study sustainable agriculture. | [Economy] Agriculture supports jobs.	\N	The science or practice of farming.	nông nghiệp	ˈæɡrɪkʌltʃə	agriculture	\N	
e13c5ae7-5524-4e08-af5a-598c843f6fc8	2025-10-10 18:49:50.259717	2025-10-10 18:49:50.259717	null	A2	[Agriculture] Harvest crops in autumn. | [Farming] Plant seasonal crops. | [Economy] Crops boost trade.	\N	Plants grown for food or other uses.	cây trồng	krɒp	crop	\N	
983428bc-0d18-4ef9-a6a7-e157faa8f627	2025-10-10 18:49:50.26395	2025-10-10 18:49:50.26395	null	B2	[Agriculture] Use irrigation for crops. | [Farming] Improve irrigation systems. | [Science] Study irrigation efficiency.	\N	The artificial supply of water to crops.	tưới tiêu	ˌɪrɪˈɡeɪʃn	irrigation	\N	
c3396dde-e9c2-4ad0-97aa-526c87a0fe98	2025-10-10 18:49:50.266952	2025-10-10 18:49:50.266952	null	B2	[Agriculture] Apply fertilizer to fields. | [Farming] Use organic fertilizer. | [Science] Study fertilizer impact.	\N	A substance added to soil to enhance plant growth.	phân bón	ˈfɜːtɪlaɪzə	fertilizer	\N	
6c9226f8-26e5-4dde-8786-c555d9c962a8	2025-10-10 18:49:50.270467	2025-10-10 18:49:50.270467	null	B2	[Agriculture] Use pesticides carefully. | [Farming] Pesticides protect crops. | [Science] Study pesticide effects.	\N	A chemical used to kill pests that harm crops.	thuốc trừ sâu	ˈpestɪsaɪd	pesticide	\N	
5eed014e-ae0d-4580-bd61-11a7a67a3bb1	2025-10-10 18:49:50.274435	2025-10-10 18:49:50.274435	null	A2	[Agriculture] Prepare for the harvest. | [Farming] Harvest crops in autumn. | [Season] The harvest was successful.	\N	The process of gathering mature crops.	vụ mùa/thu hoạch	ˈhɑːvɪst	harvest	\N	
b211d13f-ba1c-455c-af5a-85581f6c7e88	2025-10-10 18:49:50.27866	2025-10-10 18:49:50.27866	null	A1	[Agriculture] Work on a family farm. | [Farming] Farm organic vegetables. | [Nature] Visit a local farm.	\N	Land used for growing crops or raising animals.	nông trại	fɑːm	farm	\N	
2c1bb589-6eae-4a61-9670-8a75041af02d	2025-10-10 18:49:50.282656	2025-10-10 18:49:50.282656	null	B2	[Agriculture] Raise livestock for food. | [Farming] Feed the livestock daily. | [Economy] Livestock supports farmers.	\N	Animals raised for food or other products.	gia súc	ˈlaɪvstɒk	livestock	\N	
1874d770-c999-4f37-980b-ab9a499a68d5	2025-10-10 18:49:50.286184	2025-10-10 18:49:50.286184	null	B1	[Agriculture] Buy organic vegetables. | [Farming] Use organic methods. | [Food] Organic products are healthier.	\N	Food or farming without synthetic chemicals.	hữu cơ	ɔːˈɡænɪk	organic	\N	
6c7427bb-c202-4fc8-9db3-df0e066c7d61	2025-10-10 18:49:50.289185	2025-10-10 18:49:50.289185	null	A2	[Health] Study medicine at university. | [Science] Take medicine for colds. | [Career] Work in modern medicine.	\N	The science or practice of diagnosing and treating diseases.	y học/thuốc	ˈmedɪsn	medicine	\N	
d1dc14f9-4f6c-492b-abd2-28ac48260a3a	2025-10-10 18:49:50.292941	2025-10-10 18:49:50.292941	null	B2	[Health] Get a medical diagnosis. | [Medicine] The diagnosis was accurate. | [Doctor] Discuss the diagnosis.	\N	The identification of a disease or condition.	chẩn đoán	ˌdaɪəɡˈnəʊsɪs	diagnosis	\N	
2edcb120-b531-448e-bb0d-879c198f6c36	2025-10-10 18:49:50.295946	2025-10-10 18:49:50.295946	null	B1	[Health] Start treatment for illness. | [Medicine] Follow the treatment plan. | [Doctor] Discuss treatment options.	\N	Medical care given to a patient for an illness.	điều trị	ˈtriːtmənt	treatment	\N	
74e8a803-1361-4b5a-ad72-272206aa48ef	2025-10-10 18:49:50.299915	2025-10-10 18:49:50.299915	null	B1	[Health] Try physical therapy. | [Medicine] Attend therapy sessions. | [Treatment] Therapy helps recovery.	\N	Treatment to relieve or heal a condition.	liệu pháp	ˈθerəpi	therapy	\N	
2fb52aca-f436-449f-b7d7-de3e61ca5d07	2025-10-10 18:49:50.302909	2025-10-10 18:49:50.302909	null	A2	[Health] Report symptoms to the doctor. | [Medicine] Symptoms indicate illness. | [Diagnosis] Monitor fever symptoms.	\N	A sign or indication of a disease or condition.	triệu chứng	ˈsɪmptəm	symptom	\N	
b60373d5-ffa9-4629-8975-51073b205ffd	2025-10-10 18:49:50.307913	2025-10-10 18:49:50.307913	null	C1	[Health] Control the epidemic spread. | [Medicine] Study epidemic patterns. | [History] Epidemics affect populations.	\N	A widespread outbreak of a disease.	dịch bệnh	ˌepɪˈdemɪk	epidemic	\N	
fdd3d6d7-c4d5-4218-a5ab-38b2e404331f	2025-10-10 18:49:50.312648	2025-10-10 18:49:50.312648	null	B2	[Science] Study psychology at university. | [Health] Psychology explores behavior. | [Career] Work in clinical psychology.	\N	The study of the mind and behavior.	tâm lý học	saɪˈkɒlədʒi	psychology	\N	
dd3acc71-d3c9-4fb4-bdf3-a320acc2f070	2025-10-10 18:49:50.315656	2025-10-10 18:49:50.315656	null	B1	[Psychology] Study human behavior. | [Science] Behavior reflects emotions. | [Observation] Analyze animal behavior.	\N	The way a person or animal acts.	hành vi	bɪˈheɪvjə	behavior	\N	
c0af76d8-1522-4e6f-b0a0-84f0a9e39537	2025-10-10 18:49:50.319808	2025-10-10 18:49:50.319808	null	A2	[Psychology] Express your emotions. | [Health] Emotions affect decisions. | [Science] Study emotional responses.	\N	A strong feeling, such as happiness or anger.	cảm xúc	ɪˈməʊʃn	emotion	\N	
f9eeb2d3-9d6f-4470-9e0d-aee44a3367f8	2025-10-10 18:49:50.323814	2025-10-10 18:49:50.323814	null	A2	[Psychology] Manage stress daily. | [Health] Stress affects sleep. | [Science] Study stress causes.	\N	Mental or emotional strain or pressure.	căng thẳng	stres	stress	\N	
72ae0734-3280-4e96-bbc6-c1ad004e4c70	2025-10-10 18:49:50.326814	2025-10-10 18:49:50.326814	null	B2	[Psychology] Reduce anxiety with therapy. | [Health] Anxiety affects focus. | [Science] Study anxiety disorders.	\N	A feeling of worry or nervousness.	lo âu	æŋˈzaɪəti	anxiety	\N	
eb45eeee-a334-464a-a4d1-388ed2d26276	2025-10-10 18:49:50.330835	2025-10-10 18:49:50.330835	null	B2	[Psychology] Seek counseling for stress. | [Health] Counseling helps mental health. | [Service] Offer family counseling.	\N	Professional guidance to address personal or mental issues.	tư vấn	ˈkaʊnsəlɪŋ	counseling	\N	
4e0b4507-322b-426f-a7df-c3b5083743d4	2025-10-10 18:49:50.33595	2025-10-10 18:49:50.33595	null	B1	[Psychology] Find motivation to study. | [Health] Motivation drives success. | [Science] Study motivation theories.	\N	The reason or drive to act or achieve a goal.	động lực	ˌməʊtɪˈveɪʃn	motivation	\N	
547c893d-f4ac-4cfd-852d-141fd74bf0c0	2025-10-10 18:49:50.338746	2025-10-10 18:49:50.338746	null	C1	[Psychology] Study cognition in class. | [Science] Cognition affects learning. | [Health] Improve cognitive skills.	\N	The mental process of acquiring knowledge and understanding.	nhận thức	kɒɡˈnɪʃn	cognition	\N	
9a0140bd-ca21-452e-996a-5379eb4270fb	2025-10-10 18:49:50.343055	2025-10-10 18:49:50.343055	null	B2	[Psychology] Perception shapes reality. | [Science] Study visual perception. | [Health] Perception influences decisions.	\N	The way one interprets or understands something.	nhận thức (giác quan)	pəˈsepʃn	perception	\N	
499ef0e5-5d1d-4aa3-837b-9ecb4c3a7522	2025-10-10 18:49:50.350063	2025-10-10 18:49:50.350063	null	B1	[Education] Watch a tutorial video. | [Learning] Follow the math tutorial. | [School] Attend a coding tutorial.	\N	A lesson or guide to teach a specific skill.	bài hướng dẫn	tjuːˈtɔːriəl	tutorial	\N	
5aeb91e4-1f31-47e9-b4b0-aa5419ce0985	2025-10-10 18:49:50.356817	2025-10-10 18:49:50.356817	null	B1	[Literature] Write poetry for fun. | [Art] Study classic poetry. | [Culture] Poetry expresses emotions.	\N	Literary work expressing feelings in verse.	thơ ca	ˈpəʊɪtri	poetry	\N	
f5f61923-6e83-4d31-86de-a46d81d9636b	2025-10-10 18:49:50.362133	2025-10-10 18:49:50.362133	null	B2	[Literature] Enjoy the fantasy genre. | [Book] Explore different genres. | [Culture] Genres shape storytelling.	\N	A category of literature or art, like mystery or sci-fi.	thể loại	ˈʒɒnrə	genre	\N	
fd272683-c1d1-420f-951d-92889bae4093	2025-10-10 18:49:50.365645	2025-10-10 18:49:50.365645	null	B1	[Literature] The plot was exciting. | [Book] Develop a strong plot. | [Story] Follow the plot twists.	\N	The sequence of events in a story.	cốt truyện	plɒt	plot	\N	
d121cbe4-037e-44a8-b642-8e9c5e15f457	2025-10-10 18:49:50.368645	2025-10-10 18:49:50.368645	null	A2	[Literature] Create a memorable character. | [Story] The character faced challenges. | [Book] Analyze the main character.	\N	A person or figure in a story or play.	nhân vật	ˈkærəktə	character	\N	
a910802a-353f-4fbb-9bb6-927a44b458c7	2025-10-10 18:49:50.37336	2025-10-10 18:49:50.37336	null	B2	[Literature] Symbolism enhances stories. | [Book] Analyze symbolism in poetry. | [Art] The dove represents symbolism of peace.	\N	The use of symbols to represent ideas or qualities.	biểu tượng	ˈsɪmbəlɪzəm	symbolism	\N	
97e538b5-f545-4fbd-b8ca-e02e3cd83bbd	2025-10-10 18:49:50.377368	2025-10-10 18:49:50.377368	null	C1	[Literature] The story is an allegory. | [Book] Study allegories in class. | [Art] Allegories teach moral lessons.	\N	A story with a hidden moral or symbolic meaning.	ngụ ngôn	ˈæləɡəri	allegory	\N	
3af9a6b0-68f8-405f-9e72-d889665a1571	2025-10-10 18:49:50.380815	2025-10-10 18:49:50.380815	null	B2	[Literature] Imagery creates vivid scenes. | [Poetry] The imagery was striking. | [Writing] Use imagery to engage readers.	\N	Vivid descriptive language that appeals to the senses.	hình ảnh (văn học)	ˈɪmɪdʒəri	imagery	\N	
bda25f3d-1ffe-4d72-93e2-1e1f4cda9748	2025-10-10 18:49:50.384839	2025-10-10 18:49:50.384839	null	B2	[Literature] Write prose for the novel. | [Book] Prose differs from poetry. | [Writing] Her prose is beautiful.	\N	Written or spoken language in its ordinary form, without verse.	văn xuôi	prəʊz	prose	\N	
c79a63fb-aaa0-4365-9c0e-a7a1486164fa	2025-10-10 18:49:50.387845	2025-10-10 18:49:50.387845	null	B2	[Literature] Memorize a verse of poetry. | [Poetry] Write a verse for class. | [Art] The verse was lyrical.	\N	Writing arranged with a metrical rhythm, typically in poetry.	thơ (đoạn)	vɜːs	verse	\N	
97a2a6b9-3894-452b-b4c0-3a6b290eec8e	2025-10-10 18:49:50.392929	2025-10-10 18:49:50.392929	null	B1	[Poetry] The poem has a rhyme. | [Writing] Rhyme words in the stanza. | [Literature] Study rhyme schemes.	\N	Words with similar ending sounds, often used in poetry.	vần	raɪm	rhyme	\N	
cb8e81a5-1e00-4ae4-b156-4acf9ea43d7b	2025-10-10 18:49:50.396613	2025-10-10 18:49:50.396613	null	B2	[Poetry] Each stanza has four lines. | [Literature] Analyze the stanza’s meaning. | [Writing] Write a new stanza.	\N	A grouped set of lines in a poem.	đoạn thơ	ˈstænzə	stanza	\N	
2a8ae232-2102-4907-bb10-d27273ec04b8	2025-10-10 18:49:50.40031	2025-10-10 18:49:50.40031	null	B2	[Literature] Shakespeare was a playwright. | [Theater] Meet the famous playwright. | [Art] Playwrights create stories.	\N	A person who writes plays.	nhà viết kịch	ˈpleɪraɪt	playwright	\N	
bc517ac5-c869-4598-a3e5-644523a9b914	2025-10-10 18:49:50.405482	2025-10-10 18:49:50.405482	null	A1	[Culture] Visit an art gallery. | [Creativity] Create art with paint. | [School] Study art history.	\N	The expression of creativity through painting, music, or other forms.	nghệ thuật	ɑːt	art	\N	
2a339934-72ce-4a8c-8596-906c91eb436d	2025-10-10 18:49:50.413197	2025-10-10 18:49:50.413197	null	B1	[Art] Explore a local gallery. | [Culture] Galleries display paintings. | [Exhibition] Visit an art gallery.	\N	A place where art is displayed or sold.	phòng trưng bày	ˈɡæləri	gallery	\N	
96cb5435-02fb-45e5-a375-cfa7ea2ebb3e	2025-10-10 18:49:50.420895	2025-10-10 18:49:50.420895	null	A2	[Music] Play a musical instrument. | [School] Learn the guitar instrument. | [Performance] Tune your instrument.	\N	A tool or device used to play music.	nhạc cụ	ˈɪnstrəmənt	instrument	\N	
86e837b2-6e09-4193-b335-72ce3cd7a6ac	2025-10-10 18:49:50.424303	2025-10-10 18:49:50.424303	null	B1	[Music] Hum a catchy melody. | [Song] The melody was beautiful. | [Performance] Compose a new melody.	\N	A sequence of musical notes that are pleasing.	giai điệu	ˈmelədi	melody	\N	
6615aacb-5119-49ee-b3f8-5698329c3bf1	2025-10-10 18:49:50.427307	2025-10-10 18:49:50.427307	null	B1	[Music] Follow the song’s rhythm. | [Performance] Dance to the rhythm. | [Art] Rhythm enhances music.	\N	The pattern of beats or stresses in music.	nhịp điệu	ˈrɪðəm	rhythm	\N	
bead87ce-2b39-421b-ab0f-59f0f3a38d44	2025-10-10 18:49:50.432263	2025-10-10 18:49:50.432263	null	B2	[Music] Create harmony in songs. | [Performance] Sing in perfect harmony. | [Art] Harmony balances melodies.	\N	The combination of musical notes played together.	hòa âm	ˈhɑːməni	harmony	\N	
8003d046-de6a-4ef7-a9be-cc1bc2a82e0c	2025-10-10 18:49:50.435602	2025-10-10 18:49:50.435602	null	A2	[Music] Attend a live concert. | [Performance] Perform at a concert. | [Culture] Concerts attract crowds.	\N	A live performance of music.	buổi hòa nhạc	ˈkɒnsət	concert	\N	
8f8db73b-d658-4d0a-b837-7394628a9ad0	2025-10-10 18:49:50.440414	2025-10-10 18:49:50.440414	null	B2	[Music] Beethoven was a composer. | [Art] Meet the famous composer. | [Performance] Composers create music.	\N	A person who writes music.	nhà soạn nhạc	kəmˈpəʊzə	composer	\N	
0385d096-707d-4755-9d71-9a2b6015dcf1	2025-10-10 18:49:50.444719	2025-10-10 18:49:50.444719	null	B1	[Music] Watch an orchestra perform. | [Performance] Join the school orchestra. | [Art] Orchestras play symphonies.	\N	A large group of musicians playing together.	dàn nhạc giao hưởng	ˈɔːkɪstrə	orchestra	\N	
60f58b5a-ab66-49ee-be75-1b47f29e2871	2025-10-10 18:49:50.447728	2025-10-10 18:49:50.447728	null	B2	[Music] The conductor leads the orchestra. | [Performance] Follow the conductor’s cues. | [Art] Conductors inspire musicians.	\N	A person who directs an orchestra or choir.	người chỉ huy dàn nhạc	kənˈdʌktə	conductor	\N	
4fc37296-db7e-4032-9c84-6b585fc611b6	2025-10-10 18:49:50.45478	2025-10-10 18:49:50.45478	null	B2	[Dance] Create new choreography. | [Performance] Practice the choreography. | [Art] Choreography enhances shows.	\N	The art of designing dance sequences.	biên đạo múa	ˌkɒriˈɒɡrəfi	choreography	\N	
40618d78-8d5f-479f-96f7-e1dfd020be80	2025-10-10 18:49:50.459536	2025-10-10 18:49:50.459536	null	B1	[Dance] Practice the dance routine. | [Performance] Perform a new routine. | [Art] Create a routine for the show.	\N	A sequence of dance or performance steps.	điệu múa (bài tập)	ruːˈtiːn	routine	\N	
8d0887c1-306b-4aed-b738-7b68f4153e85	2025-10-10 18:49:50.463576	2025-10-10 18:49:50.463576	null	A2	[Performance] Perform on a stage. | [Theater] Decorate the stage. | [Art] The stage was lit brightly.	\N	A platform where performances take place.	sân khấu	steɪdʒ	stage	\N	
fa38c299-624b-4dd6-88b8-23f2f4a4008e	2025-10-10 18:49:50.46777	2025-10-10 18:49:50.46777	null	B1	[Performance] Attend a dance rehearsal. | [Theater] Schedule a rehearsal. | [Art] Rehearsals improve skills.	\N	A practice session for a performance.	bài tập dượt	rɪˈhɜːsl	rehearsal	\N	
0b57217d-48a2-43d0-9ad5-8ef9321dffc5	2025-10-10 18:49:50.472686	2025-10-10 18:49:50.472686	null	B1	[Performance] Receive loud applause. | [Theater] Applause followed the show. | [Art] Applause rewards performers.	\N	Clapping to show appreciation for a performance.	sự vỗ tay	əˈplɔːz	applause	\N	
db409508-f49b-424c-a0ec-0d2048dd929a	2025-10-10 18:49:50.479059	2025-10-10 18:49:50.479059	null	A1	[Cinema] Watch a new film. | [Art] Create a short film. | [Entertainment] Films inspire audiences.	\N	A motion picture or movie.	phim	fɪlm	film	\N	
25a91133-69e8-4aee-ac14-d554a35add59	2025-10-10 18:49:50.483031	2025-10-10 18:49:50.483031	null	B1	[Cinema] The director filmed the movie. | [Art] Meet a famous director. | [Film] Directors lead productions.	\N	People who guide the making of a film or play.	đạo diễn	dɪˈrektə	director	\N	
98ae76c4-ceda-4285-978b-17455b34924d	2025-10-10 18:49:50.486905	2025-10-10 18:49:50.486905	null	B1	[Cinema] Write a movie script. | [Film] Read the script carefully. | [Art] Scripts guide actors.	\N	The written text of a film, play, or broadcast.	kịch bản	skrɪpt	script	\N	
ac192161-54ea-428d-b117-be7a02e2562f	2025-10-10 18:49:50.489912	2025-10-10 18:49:50.489912	null	A2	[Cinema] The actor played the lead. | [Film] Hire a talented actor. | [Art] Actors perform on stage.	\N	A man who performs in films, plays, or shows.	diễn viên (nam)	ˈæktə	actor	\N	
cf0b9614-845c-4250-932c-7561eabc6d6f	2025-10-10 18:49:50.495021	2025-10-10 18:49:50.495021	null	A2	[Cinema] The actress won an award. | [Film] Meet a famous actress. | [Art] Actresses shine in roles.	\N	A woman who performs in films, plays, or shows.	diễn viên (nữ)	ˈæktrəs	actress	\N	
82056b35-4192-474c-9f21-ac79b9f295b7	2025-10-10 18:49:50.498021	2025-10-10 18:49:50.498021	null	A2	[Cinema] Film a dramatic scene. | [Film] The scene was emotional. | [Art] Direct the next scene.	\N	A part of a film or play showing a single event.	cảnh (phim)	siːn	scene	\N	
02f42ee2-ed6d-47bf-ae9f-44a28b0c5b16	2025-10-10 18:49:50.501508	2025-10-10 18:49:50.501508	null	C1	[Cinema] Study cinematography in school. | [Film] Cinematography enhances visuals. | [Art] Great cinematography wins awards.	\N	The art of capturing visuals for films.	nghệ thuật quay phim	ˌsɪnəməˈtɒɡrəfi	cinematography	\N	
22e80f9a-0b56-489c-abaa-703bc6a43102	2025-10-10 18:49:50.505287	2025-10-10 18:49:50.505287	null	B2	[Cinema] Editing improves the film. | [Film] Learn video editing skills. | [Art] Editing shapes the story.	\N	The process of selecting and arranging film or text.	biên tập (phim)	ˈedɪtɪŋ	editing	\N	
91485041-fabb-4152-8a10-1d9683589f9d	2025-10-10 18:49:50.509772	2025-10-10 18:49:50.509772	null	B1	[Cinema] The soundtrack was memorable. | [Film] Choose a movie soundtrack. | [Art] Soundtracks set the mood.	\N	Music accompanying a film or show.	nhạc nền (phim)	ˈsaʊndtræk	soundtrack	\N	
644080d7-d49c-407e-9a81-79a5993f7fac	2025-10-10 18:49:50.516368	2025-10-10 18:49:50.516368	null	A1	[Photography] Use a professional camera. | [Art] Buy a new camera. | [Hobby] Cameras capture memories.	\N	A device used to take photographs or videos.	máy ảnh	ˈkæmərə	camera	\N	
ebc9c64c-fc50-401b-b70d-bee85001d9ad	2025-10-10 18:49:50.521511	2025-10-10 18:49:50.521511	null	B1	[Photography] Choose a zoom lens. | [Camera] Clean the camera lens. | [Art] Lenses affect photo quality.	\N	A piece of glass in a camera that focuses light.	ống kính	lenz	lens	\N	
a424bf4e-85fa-45c5-ae76-31307ead1d5d	2025-10-10 18:49:50.524525	2025-10-10 18:49:50.524525	null	B2	[Photography] Adjust the shutter speed. | [Camera] The shutter controls light. | [Art] Shutter settings impact photos.	\N	A camera part controlling light exposure.	màn trập	ˈʃʌtə	shutter	\N	
ddc2999d-9a3b-40de-a2f4-c58b8c9423f9	2025-10-10 18:49:50.528519	2025-10-10 18:49:50.528519	null	B2	[Photography] Control the exposure settings. | [Art] Exposure affects brightness. | [Camera] Learn about exposure.	\N	The amount of light allowed in a photograph.	phơi sáng	ɪkˈspəʊʒə	exposure	\N	
3be8d56f-c941-466e-87f9-382822a4229d	2025-10-10 18:49:50.535306	2025-10-10 18:49:50.535306	null	A2	[Photography] Adjust the camera focus. | [Art] Focus on the subject. | [Camera] Sharp focus improves photos.	\N	The clarity or sharpness of an image.	tiêu điểm	ˈfəʊkəs	focus	\N	
9095fef0-de6f-40a2-8d1a-0260657123ca	2025-10-10 18:49:50.539304	2025-10-10 18:49:50.539304	null	B2	[Photography] Study photo composition. | [Art] Composition creates balance. | [Camera] Improve your composition skills.	\N	The arrangement of elements in a photograph or artwork.	sự sắp xếp (ảnh)	ˌkɒmpəˈzɪʃn	composition	\N	
3b47177f-62d7-494a-9f1b-955ab28bea24	2025-10-10 18:49:50.544195	2025-10-10 18:49:50.544195	null	B1	[Photography] Use soft lighting. | [Art] Lighting sets the mood. | [Film] Adjust lighting for the scene.	\N	The use of light in photography or performance.	ánh sáng	ˈlaɪtɪŋ	lighting	\N	
5b61c522-3c53-446c-b666-592d550c1e30	2025-10-10 18:49:50.546707	2025-10-10 18:49:50.546707	null	C1	[Photography] Practice portraiture in studios. | [Art] Portraiture captures emotions. | [Hobby] Learn portraiture techniques.	\N	The art of creating portraits through photography or painting.	nghệ thuật chụp chân dung	ˈpɔːtrətʃə	portraiture	\N	
02c6e47c-29a6-4cb5-b087-954ef5afa36b	2025-10-10 18:49:50.549686	2025-10-10 18:49:50.549686	null	B2	[Photography] Apply a photo filter. | [Camera] Use a UV filter. | [Art] Filters enhance colors.	\N	A device or effect altering a photoâ€™s appearance.	bộ lọc (ảnh)	ˈfɪltə	filter	\N	
7594a4e9-b6ac-4844-96f3-21fc8990bdb2	2025-10-10 18:49:50.558643	2025-10-10 18:49:50.558643	null	B1	[Fashion] Design a floral pattern. | [Art] Use bold patterns. | [Industry] Patterns attract buyers.	\N	A design or template used in sewing or decoration.	mẫu (vải)	ˈpætən	pattern	\N	
42dd35bd-dde0-4321-b337-a8f1eab0da87	2025-10-10 18:49:50.564075	2025-10-10 18:49:50.564075	null	A2	[Fashion] Develop your own style. | [Culture] Her style is unique. | [Design] Style defines trends.	\N	A distinctive manner of dressing or design.	phong cách	staɪl	style	\N	
2bf28a75-2000-4e2c-ad62-09cdc4b3f58b	2025-10-10 18:49:50.567869	2025-10-10 18:49:50.567869	null	B1	[Fashion] Launch a new collection. | [Design] Display the collection. | [Industry] Collections set trends.	\N	A group of fashion items designed together.	bộ sưu tập	kəˈlekʃn	collection	\N	
ad278642-432b-4373-b6c4-0edcca891e5e	2025-10-10 18:49:50.570875	2025-10-10 18:49:50.570875	null	B2	[Fashion] Models walk the catwalk. | [Show] Watch a catwalk show. | [Industry] Catwalks showcase designs.	\N	A runway where models display fashion.	sàn diễn thời trang	ˈkætwɔːk	catwalk	\N	
92e16207-f569-4b2b-931b-155bb1967da4	2025-10-10 18:49:50.57559	2025-10-10 18:49:50.57559	null	A2	[Science] Study modern technology. | [Industry] Technology improves lives. | [Innovation] Develop new technology.	\N	The application of scientific knowledge for practical purposes.	công nghệ	tekˈnɒlədʒi	technology	\N	
51a1715d-4ee9-4ce3-8c75-f52d1e2c63fa	2025-10-10 18:49:50.586731	2025-10-10 18:49:50.586731	null	B2	[Technology] Design a user interface. | [Software] Improve the interface. | [Innovation] Interfaces enhance usability.	\N	A point where users interact with a computer or device.	giao diện	ˈɪntəfeɪs	interface	\N	
82802ef2-70cb-490c-9dc4-d72ce2634874	2025-10-10 18:49:50.590462	2025-10-10 18:49:50.590462	null	B2	[Technology] Explore virtual reality. | [Innovation] Use virtual meetings. | [Gaming] Virtual worlds are immersive.	\N	Simulated or existing online, not physically.	ảo	ˈvɜːtʃuəl	virtual	\N	
bf0de82e-eb20-4cbf-8a65-205d571242d0	2025-10-10 18:49:50.594437	2025-10-10 18:49:50.594437	null	C1	[Technology] Improve internet connectivity. | [Industry] Connectivity boosts communication. | [Innovation] Connectivity drives progress.	\N	The ability to connect to networks or devices.	kết nối	kəˌnekˈtɪvəti	connectivity	\N	
2608c991-3e84-4636-a240-efd690b0b8fc	2025-10-10 18:49:50.59959	2025-10-10 18:49:50.59959	null	B2	[Technology] Launch a tech startup. | [Business] Invest in a startup. | [Innovation] Startups drive change.	\N	A new company, often focused on innovation.	công ty khởi nghiệp	ˈstɑːtʌp	startup	\N	
34b92a9e-a787-40f1-84d0-c95b7bf337c5	2025-10-10 18:49:50.605113	2025-10-10 18:49:50.605113	null	B1	[Business] Study the global economy. | [Society] The economy affects jobs. | [Finance] A strong economy grows.	\N	The system of production, distribution, and consumption.	kinh tế	ɪˈkɒnəmi	economy	\N	
74e380fd-279c-405c-a75b-9b8d71b82a2f	2025-10-10 18:49:50.611116	2025-10-10 18:49:50.611116	null	A2	[Business] Plan a monthly budget. | [Finance] Stick to the budget. | [Economy] Budget for new projects.	\N	A plan for managing income and expenses.	ngân sách	ˈbʌdʒɪt	budget	\N	
d1b21d54-03dc-4c44-8d24-d0ec3331d9c8	2025-10-10 18:49:50.615204	2025-10-10 18:49:50.615204	null	B2	[Business] Study finance in college. | [Economy] Finance drives growth. | [Career] Work in corporate finance.	\N	The management of money and investments.	tài chính	fɪˈnæns	finance	\N	
e14d3c92-3c1c-4210-baab-2bc8ec1adca1	2025-10-10 18:49:50.6182	2025-10-10 18:49:50.6182	null	B1	[Business] International trade boosts economies. | [Economy] Trade goods globally. | [Commerce] Learn about trade policies.	\N	The buying and selling of goods or services.	thương mại	treɪd	trade	\N	
f3283039-1654-42a4-87da-2c60a74d7046	2025-10-10 18:49:50.622739	2025-10-10 18:49:50.622739	null	B2	[Business] Work for a corporation. | [Economy] Corporations drive markets. | [Industry] Start a new corporation.	\N	A large company or group acting as a single entity.	tập đoàn	ˌkɔːpəˈreɪʃn	corporation	\N	
58b7563c-e5d6-4247-b3e7-af5b988f0fe1	2025-10-10 18:49:47.960025	2025-10-17 18:12:24.115149	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F60290668-034a-46ab-80b7-365eb961af8a.mp3?alt=media	A1	[Story] A traveler found a bread near the old bench. | [Work] The bread was recorded carefully in the report. | [Everyday] I put the bread on the bench before dinner.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F928c3111-e4b0-4f90-be86-0bdcde894193.jpeg?alt=media&token=7541f2a7-b9d7-4d33-a958-faf9afc8360d	A staple food made from flour and water, baked into various forms like loaves or rolls.	bánh mì	bred	bread	\N	
5f686bca-6f57-4565-b363-ff65dfda2c20	2025-10-10 18:49:47.978744	2025-10-17 18:18:06.577524	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F68523d83-1011-4498-93c3-ad86306f0bb1.mp3?alt=media	A1	[Everyday] I put the milk on the table before dinner. | [Story] A traveler found a milk near the old table. | [School] The teacher asked us to describe a milk in two sentences.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F6e343263-f8ad-42ca-97d2-720ff871e711.jpeg?alt=media	A white liquid produced by mammals, commonly used as a drink or in cooking.	sữa	mɪlk	milk	\N	
c97b145b-085f-4f27-a01a-b0601bcd2e2c	2025-10-10 18:49:47.987451	2025-10-17 18:23:37.229404	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F93a5a571-4c23-426d-a956-5e71f4e204e6.mp3?alt=media	A1	[Description] That rice looks heavy in the afternoon light. | [Memory] This rice reminds me of my childhood in the countryside. | [Problem] The rice broke suddenly, so we had to fix it.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Ff96a1a8b-5f95-499a-9890-1b6bee481ffb.jpeg?alt=media	A grain that serves as a staple food in many cultures, often boiled or steamed.	gạo; cơm	raɪs	rice	\N	
e206b6cc-471c-4a64-a87c-df46ea12e232	2025-10-10 18:49:48.003655	2025-10-17 18:37:26.034676	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3389c71b-9568-4418-894d-ef175a1acc97.mp3?alt=media	A1	[Hobby] He collects photos of soups from different countries. | [Shopping] She compared three soups and chose the freshest one. | [Memory] This soup reminds me of my childhood in the countryside.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fe4f4b040-844a-4e61-af2a-0b5aac7361cd.jpeg?alt=media	A liquid dish made by boiling ingredients like vegetables or meat in water or broth.	súp	suːp	soup	\N	“Bowl of chicken soup.jpg” by RWS, source: https://commons.wikimedia.org/wiki/File:Bowl_of_chicken_soup.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).
037af387-d58d-4ebd-8a60-6c503ac5aedf	2025-10-10 18:49:48.050443	2025-10-17 19:04:43.369027	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1b4ccd5d-921a-48db-afb9-33a2716beae4.mp3?alt=media	A1	[Advice] Keep the book away from sunlight to stay safe. | [School] The teacher asked us to describe a book in two sentences. | [Shopping] She compared three books and chose the freshest one.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F0645df59-423b-4bdd-98f7-3820501e46b9.jpg?alt=media	A collection of pages with text or images, used for reading or study.	cuốn sách	bʊk	book	\N	
cc06f961-f972-48ff-9821-cf763ff6dd6f	2025-10-10 18:49:48.101187	2025-10-17 19:04:44.767853	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd5126f55-42b5-4012-a75e-cdad89fc722a.mp3?alt=media	A2	[Problem] The engineer broke suddenly, so we had to fix it. | [Description] That engineer looks safe in the afternoon light. | [Work] The engineer was recorded carefully in the report.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fccd03f10-f871-4acd-8f2a-db1e166d005e.jpg?alt=media	A person who designs and builds machines, structures, or systems.	kỹ sư	ˌendʒɪˈnɪə	engineer	\N	
af1fa1c5-5267-4719-b4fa-408685ad52a9	2025-10-10 18:49:48.016319	2025-10-17 19:01:49.562535	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdaf4e3c2-eaf4-4de3-a7f0-2f31de01d6a8.mp3?alt=media	A1	[Story] A traveler found a mother near the old counter. | [Work] The mother was recorded carefully in the report. | [Everyday] I put the mother on the counter before dinner.	\N	A female parent who nurtures and supports her children.	mẹ	ˈmʌðə	mother	\N	
f76e999a-d0df-41fd-937f-a358d6270c6f	2025-10-10 18:49:48.505808	2025-10-17 19:05:54.331215	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9932138e-1b10-4871-b857-2e5d9c89c776.mp3?alt=media	A2	[Work] The painting was recorded carefully in the report. | [Problem] The painting broke suddenly, so we had to fix it. | [Story] A traveler found a painting near the old bench.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fe74fe7ec-d764-4291-ad9c-de949a1b9854.jpg?alt=media	The practice of applying paint to a surface.	bức tranh	ˈpeɪntɪŋ	painting	\N	
47c4f2d3-2a46-4f95-b994-8764c92410fa	2025-10-10 18:49:48.195005	2025-10-17 19:01:52.066378	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F221657fb-be83-4c18-9882-027986ec2ea0.mp3?alt=media	A1	[Everyday] I put the cow on the table before dinner. | [Story] A traveler found a cow near the old table. | [School] The teacher asked us to describe a cow in two sentences.	\N	A large domesticated mammal kept for milk or meat.	bò	kaʊ	cow	\N	
63ff7a9b-0fc5-4843-a9e2-a91d008352ad	2025-10-10 18:49:48.178707	2025-10-17 19:01:52.336697	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0dba90f0-e659-404b-8d4c-aa7e45478438.mp3?alt=media	A1	[Shopping] She compared three teams and chose the freshest one. | [Advice] Keep the team away from sunlight to stay safe. | [Hobby] He collects photos of teams from different countries.	\N	A group of players forming one side in a competitive game or sport.	đội	tiːm	team	\N	
60828f58-fa9f-4dd6-876f-0dad07f38002	2025-10-10 18:49:48.317718	2025-10-17 19:01:55.495231	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F32be19f7-86c7-4283-be34-585288c9fc27.mp3?alt=media	A1	[Story] A traveler found a angry near the old bench. | [Work] The angry was recorded carefully in the report. | [Everyday] I put the angry on the bench before dinner.	\N	Feeling or showing strong annoyance or displeasure.	tức giận	ˈæŋɡri	angry	\N	
0de79a43-2db1-4f7b-ae50-bd3a445fa872	2025-10-10 18:49:48.355859	2025-10-17 19:01:56.474078	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb69ca5e6-4a8b-434f-84bb-d4cfe7432a89.mp3?alt=media	B2	[Story] A traveler found a conservation near the old counter. | [Work] The conservation was recorded carefully in the report. | [Everyday] I put the conservation on the counter before dinner.	\N	The protection of plants, animals, and natural resources.	bảo tồn	ˌkɒnsəˈveɪʃn	conservation	\N	
e924ee87-6cc9-4f94-af4a-98bf9a3da519	2025-10-10 18:49:48.576487	2025-10-17 19:02:01.624584	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa357880f-af6b-4d4a-96b4-564508ef38a1.mp3?alt=media	A1	[Baking] Add two spoons of sugar to the cake batter for sweetness. | [Health] Too much sugar can lead to health problems like diabetes. | [Culture] In some countries, sugar cubes are served with coffee.	\N	A sweet crystalline substance used in food and drink.	đường	ˈʃʊɡə	sugar	\N	
6f7fec37-6d4a-41b0-9daf-c238b27d90db	2025-10-10 18:49:48.605755	2025-10-17 19:02:02.230367	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1656f10a-eb7d-44cf-bfad-cecf0cd114b2.mp3?alt=media	A1	[Visit] Aunt baked cookies for us when we came to her house. | [Tradition] My aunt teaches me traditional songs every summer. | [Support] Aunt helped organize the charity event in our town.	\N	The sister of oneâ€™s parent.	cô/dì	ɑːnt	aunt	\N	
3b2ec59a-d3bf-450f-90f9-45729add3d26	2025-10-10 18:49:48.634192	2025-10-17 19:02:02.825992	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fcbf9fc2c-c131-4886-a2a1-e35853f1173e.mp3?alt=media	A2	[School] The assignment on literature was due by next Monday. | [Work] He completed the assignment before the team meeting. | [Study] She organized her notes to tackle the tough assignment.	\N	A task or piece of work allocated to someone as part of a job or study.	bài tập	əˈsaɪnmənt	assignment	\N	
5683217c-29d0-436a-bdb4-de2f8f19a598	2025-10-10 18:49:48.64869	2025-10-17 19:02:03.1441	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F83567f4c-c4f2-4804-981a-8a2bd72f1a64.mp3?alt=media	B1	[Business] They signed a contract to start the new partnership. | [Work] The contract outlined the job responsibilities clearly. | [Legal] She reviewed the contract with a lawyer before agreeing.	\N	A written or spoken agreement enforceable by law.	hợp đồng	ˈkɒntrækt	contract	\N	
375c06f1-20f6-4585-b7a5-dae14cd23213	2025-10-10 18:49:48.758691	2025-10-17 19:02:05.27435	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1c7d937f-cb65-4e0c-a1ef-196ffa5b5741.mp3?alt=media	A1	[Weather] The rain forced us to cancel the outdoor picnic. | [Agriculture] Farmers welcomed the rain after a long drought. | [Mood] She loved the sound of rain tapping on the window.	\N	Water falling in drops from the atmosphere.	mưa	reɪn	rain	\N	
b1b74240-e55e-4ca1-a0e2-29067fb389bd	2025-10-10 18:49:48.81692	2025-10-17 19:02:06.820607	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F34fd020f-eb4a-4963-84cd-5512c8748f4b.mp3?alt=media	A2	[City] The town square was decorated for the holiday festival. | [Protest] People gathered in the square to demand change. | [Tourism] The square was filled with street performers and tourists.	\N	An open public space in a city, often square-shaped.	quảng trường	skweə	square	\N	
0e2ef3c3-c24d-411b-b1f6-50ce0a0b0b93	2025-10-10 18:49:48.043548	2025-10-17 19:04:43.408613	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd068c92b-d430-492d-9415-f44b5ae7ab0e.mp3?alt=media	A1	[School] The teacher asked us to describe a child in two sentences. | [Everyday] I put the child on the wall before dinner. | [Advice] Keep the child away from fire to stay safe.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fccfdd73c-ecf6-472c-ba3b-29afead767d8.jpg?alt=media	A young human, typically under the age of puberty.	trẻ em	tʃaɪld	child	\N	
8658c8fa-0c19-420e-8b9f-8a70c1c09db0	2025-10-10 18:49:48.07359	2025-10-17 19:04:44.217622	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F74c0cd3c-d82b-4ca8-806f-61d1c7a94d4f.mp3?alt=media	A2	[Work] The exam was recorded carefully in the report. | [Problem] The exam broke suddenly, so we had to fix it. | [Story] A traveler found a exam near the old doorway.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F36a6445a-91bc-4e2a-b486-651b082f5428.jpg?alt=media	A test to assess knowledge or skills.	kỳ thi	ɪɡˈzæm	exam	\N	
8b86e29d-2e02-4d4c-8c9a-b89a73f15b64	2025-10-10 18:49:48.389377	2025-10-17 19:05:53.178551	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F208c4b0a-5176-41dc-b2c0-7f6c1a3181cb.mp3?alt=media	B2	[Advice] Keep the theory away from children to stay safe. | [School] The teacher asked us to describe a theory in two sentences. | [Shopping] She compared three theories and chose the freshest one.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fa6142baa-a832-413d-8f4c-e66d77d276f6.jpg?alt=media	A system of ideas to explain something, based on general principles.	lý thuyết	ˈθɪəri	theory	\N	
4d25d71c-b640-47f3-bd18-79d18f647af4	2025-10-10 18:49:48.165995	2025-10-17 19:01:52.022879	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fec95e267-4561-41ee-9274-7ad95b80afce.mp3?alt=media	A1	[Problem] The basketball broke suddenly, so we had to fix it. | [Description] That basketball looks safe in the afternoon light. | [Work] The basketball was recorded carefully in the report.	\N	A game played by two teams of five players with a ball thrown into a basket.	bóng rổ	ˈbɑːskɪtbɔːl	basketball	\N	“Basketball game.jpg” by Kelly Bailey, source: https://commons.wikimedia.org/wiki/File:Basketball_game.jpg, license: CC BY 2.0 (https://creativecommons.org/licenses/by/2.0/).
01254977-2ebe-4447-8492-4573a307005e	2025-10-10 18:49:48.854991	2025-10-17 19:06:21.550531	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F628ed695-d299-4d89-bd13-bd87f1114a30.mp3?alt=media	A2	[Class] He was bored during the long lecture on history. | [Home] She felt bored and decided to watch a movie. | [Activity] Playing the same game made the kids bored quickly.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Ff8325c27-7574-477f-9ab6-a00fdfa0c182.jpg?alt=media	Feeling uninterested or lacking engagement.	nhàm chán	bɔːrd	bored	\N	
0c5b29fe-04ce-417d-9c4e-1419b948bcda	2025-10-10 18:49:48.213582	2025-10-17 19:01:52.93803	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F77a6ab69-0201-4056-ab0a-07e88ab43021.mp3?alt=media	A1	[Description] That sun looks heavy in the afternoon light. | [Memory] This sun reminds me of my childhood in the countryside. | [Problem] The sun broke suddenly, so we had to fix it.	\N	The star at the center of our solar system, providing light and heat.	mặt trời	sʌn	sun	\N	“Sun in the sky.jpg” by NASA, source: https://commons.wikimedia.org/wiki/File:Sun_in_the_sky.jpg, license: Public Domain (https://creativecommons.org/publicdomain/mark/1.0/).
c64e91ed-a4de-40f0-ae4d-4dba3a15eab3	2025-10-10 18:49:48.327782	2025-10-17 19:01:55.691003	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4adca986-fdb3-4bd8-94b3-7cf7912a5eaa.mp3?alt=media	B1	[Everyday] I put the confident on the floor before dinner. | [Story] A traveler found a confident near the old floor. | [School] The teacher asked us to describe a confident in two sentences.	\N	Feeling certain about one's abilities or qualities.	tự tin	ˈkɒnfɪdənt	confident	\N	
af0916df-4290-42a5-a159-9daba0868084	2025-10-10 18:49:48.339988	2025-10-17 19:01:55.982505	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffb9259aa-40af-4338-ba43-ad2e650d6c96.mp3?alt=media	B1	[Work] The pollution was recorded carefully in the report. | [Problem] The pollution broke suddenly, so we had to fix it. | [Story] A traveler found a pollution near the old doorway.	\N	The presence of harmful substances in the environment.	ô nhiễm	pəˈluːʃn	pollution	\N	
bdc7adbb-b50a-4359-9892-fa9a136391fc	2025-10-10 18:49:48.403075	2025-10-17 19:01:57.637409	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F25fbc027-6516-4e3b-b349-4eaeaffa7bbe.mp3?alt=media	B2	[Description] That genetics looks heavy in the afternoon light. | [Memory] This genetics reminds me of my childhood in the countryside. | [Problem] The genetics broke suddenly, so we had to fix it.	\N	The study of heredity and the variation of inherited characteristics.	di truyền học	dʒəˈnetɪks	genetics	\N	
c5b8311e-6bdc-4f94-a159-367aae082058	2025-10-10 18:49:48.718827	2025-10-17 19:01:58.146467	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa966d5f9-b876-4faf-8ba9-14550f170422.mp3?alt=media	A1	[School] The sport event included soccer and volleyball matches. | [Hobby] Playing a sport like tennis is a fun way to stay active. | [Community] The town built a new sport complex for residents.	\N	An activity involving physical exertion and skill.	thể thao	spɔːrt	sport	\N	
79c2cefe-1534-4d67-b950-2ab12955d037	2025-10-10 18:49:48.471811	2025-10-17 19:01:59.439077	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4d71dad9-03cd-49a8-aa34-1a4f6df937d8.mp3?alt=media	B1	[Hobby] He collects photos of losses from different countries. | [Shopping] She compared three losses and chose the freshest one. | [Memory] This loss reminds me of my childhood in the countryside.	\N	The fact or process of losing something, especially money.	thua lỗ	lɒs	loss	\N	
6f5f1fd3-7541-4562-97ea-a0f0b8c1aff8	2025-10-10 18:49:48.502924	2025-10-17 19:02:00.127397	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa94c998b-72a5-4bd1-8975-2e010a258c75.mp3?alt=media	B2	[Advice] Keep the drama away from rain to stay safe. | [School] The teacher asked us to describe a drama in two sentences. | [Shopping] She compared three dramas and chose the freshest one.	\N	A play for theater, radio, or television.	kịch	ˈdrɑːmə	drama	\N	
e0b2d1f6-d455-4a8d-a281-e8a96f1a0e7a	2025-10-10 18:49:48.548242	2025-10-17 19:02:00.995008	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb05682b9-9c34-45b2-83a9-e88127ff9fd5.mp3?alt=media	B1	[Travel] We subscribeed through the old town and took photos. | [Tip] If you subscribe too fast at the start, you'll get tired quickly. | [Goal] She plans to subscribe farther than last week.	\N	To arrange to receive something regularly, typically a publication or service.	đăng ký (kênh)	səbˈskraɪb	subscribe	\N	
af19b21f-2ba9-4f1a-b46f-4ed316273510	2025-10-10 18:49:48.106364	2025-10-17 19:04:44.915888	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7c48d93c-8e8e-4725-bcb6-000673663082.mp3?alt=media	A1	[Story] A traveler found a nurse near the old wall. | [Work] The nurse was recorded carefully in the report. | [Everyday] I put the nurse on the wall before dinner.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fb1a1b2c5-0714-4a75-8942-3f93fb334d4f.jpg?alt=media	A person trained to care for the sick or infirm.	y tá; điều dưỡng	nɜːs	nurse	\N	
b910d755-212e-433e-8f32-8902f9af58e2	2025-10-10 18:49:48.143478	2025-10-17 19:04:45.43028	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F58b55f23-0c84-4538-bcfe-011f06f48ba8.mp3?alt=media	A1	[Advice] Keep the hotel away from pets to stay safe. | [School] The teacher asked us to describe a hotel in two sentences. | [Shopping] She compared three hotels and chose the freshest one.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Faaa7b296-e49a-439e-ab7f-57bc0eaf5ef2.jpg?alt=media	A building providing lodging and usually meals for the public.	khách sạn	həʊˈtel	hotel	\N	
45caabd5-5ec7-4b41-b3cc-d43bc4047d8b	2025-10-10 18:49:48.081431	2025-10-17 19:01:50.514121	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6a2f3d0d-e371-4b16-8c25-ac9b23ed1691.mp3?alt=media	A1	[Everyday] I put the subject on the bag before dinner. | [Story] A traveler found a subject near the old bag. | [School] The teacher asked us to describe a subject in two sentences.	\N	A specific area of study, like math or history.	môn học	ˈsʌbdʒɪkt	subject	\N	
cf3ebbbd-6a07-4e8d-bf54-9cfaad027461	2025-10-10 18:49:48.22832	2025-10-17 19:05:52.136757	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F529b560c-4b7d-46ab-95f6-39b1b0e6b7cd.mp3?alt=media	A1	[Hobby] He collects photos of grasses from different countries. | [Shopping] She compared three grasses and chose the freshest one. | [Memory] This grass reminds me of my childhood in the countryside.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fe09ba29e-ece3-4b4e-8299-882c10b6285c.jpg?alt=media	A low green plant that covers the ground in lawns or fields.	cỏ	ɡrɑːs	grass	\N	
47c922c7-2b04-4aa4-93f3-c18f6eea74d5	2025-10-10 18:49:48.126427	2025-10-17 19:01:51.167964	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe3f0f4cd-023d-4e84-81ec-538c1fcccbe7.mp3?alt=media	A1	[Work] The bus was recorded carefully in the report. | [Problem] The bus broke suddenly, so we had to fix it. | [Story] A traveler found a bus near the old counter.	\N	A large vehicle carrying many passengers, used for public transport.	xe buýt	bʌs	bus	\N	
590302b0-026c-421a-9d7f-0428ccf29f73	2025-10-10 18:49:48.183953	2025-10-17 19:01:51.783052	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5e359eb2-5d5e-45e6-88aa-472a8ab3ab6b.mp3?alt=media	A2	[Problem] The coach broke suddenly, so we had to fix it. | [Description] That coach looks safe in the afternoon light. | [Work] The coach was recorded carefully in the report.	\N	A person who trains and directs athletes or teams.	huấn luyện viên	kəʊtʃ	coach	\N	
4bfc41a7-c669-4147-932d-da637599141c	2025-10-10 18:49:48.192112	2025-10-17 19:01:52.413593	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa5bd357a-c874-4080-be86-afcd36867d35.mp3?alt=media	A1	[School] The teacher asked us to describe a bird in two sentences. | [Everyday] I put the bird on the wall before dinner. | [Advice] Keep the bird away from noise to stay safe.	\N	A warm-blooded egg-laying vertebrate with feathers and wings.	chim	bɜːd	bird	\N	
227cf445-3087-4c52-adc9-c62c007738bb	2025-10-10 18:49:48.236148	2025-10-17 19:01:53.471584	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc59146c2-97b5-4fc4-aa99-b9ac9fb5b01d.mp3?alt=media	A1	[School] The teacher asked us to describe a sea in two sentences. | [Everyday] I put the sea on the bench before dinner. | [Advice] Keep the sea away from heat to stay safe.	\N	A large body of salt water covering much of the earth's surface.	biển	siː	sea	\N	“Calm sea.jpg” by Jorge Morales Piderit, source: https://commons.wikimedia.org/wiki/File:Calm_sea.jpg, license: CC BY 2.0 (https://creativecommons.org/licenses/by/2.0/).
dad42817-a33a-414c-8aaa-1d5279a12b10	2025-10-10 18:49:48.239587	2025-10-17 19:01:53.565364	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F44853642-1f5b-4ebd-b02b-47f62852584c.mp3?alt=media	A1	[Hobby] He collects photos of houses from different countries. | [Shopping] She compared three houses and chose the freshest one. | [Memory] This house reminds me of my childhood in the countryside.	\N	A building for human habitation.	ngôi nhà	haʊs	house	\N	“House in countryside.jpg” by Rufus46, source: https://commons.wikimedia.org/wiki/File:House_in_countryside.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).
62ed2bc7-e0cd-43c1-8431-7edf99a7c9d0	2025-10-10 18:49:48.249221	2025-10-17 19:01:53.760747	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fab9e57c8-742a-4f24-9daf-a2642f368066.mp3?alt=media	A1	[Work] The table was recorded carefully in the report. | [Problem] The table broke suddenly, so we had to fix it. | [Story] A traveler found a table near the old counter.	\N	A piece of furniture with a flat top and legs, used for eating or working.	bàn	ˈteɪbl	table	\N	“Wooden table.jpg” by Evan-Amos, source: https://commons.wikimedia.org/wiki/File:Wooden_table.jpg\n, license: CC0 1.0 (https://creativecommons.org/publicdomain/zero/1.0/\n).
62295023-3013-4628-aeb9-53af85fd8102	2025-10-10 18:49:48.263998	2025-10-17 19:01:54.165184	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Faf0dcaa4-1d43-41a4-9d8c-17d7eb8e1f26.mp3?alt=media	A1	[Story] A traveler found a city near the old floor. | [Work] The city was recorded carefully in the report. | [Everyday] I put the city on the floor before dinner.	\N	A large town with many inhabitants.	thành phố	ˈsɪti	city	\N	“New York City skyline.jpg” by King of Hearts, source: https://commons.wikimedia.org/wiki/File:New_York_City_skyline.jpg, license: CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/).
bc103d34-24b7-4106-9cc3-c4e1bd851a4f	2025-10-10 18:49:48.273656	2025-10-17 19:01:54.366069	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd9cd11ba-93ea-4d5a-bd6e-7968251955c5.mp3?alt=media	A1	[Memory] This shop reminds me of my childhood in the countryside. | [Hobby] He collects photos of shops from different countries. | [Description] That shop looks modern in the afternoon light.	\N	A place where goods are sold.	cửa hàng	ʃɒp	shop	\N	“Shop interior.jpg” by MOs810, source: https://commons.wikimedia.org/wiki/File:Shop_interior.jpg, license: CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/).
a10ca209-b213-4931-9db3-39353bf1fc67	2025-10-10 18:49:48.445037	2025-10-17 19:05:53.818634	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffdf35a69-28ff-4e82-8b73-afed7f75eb68.mp3?alt=media	B1	[Memory] This judge reminds me of my childhood in the countryside. | [Hobby] He collects photos of judges from different countries. | [Description] That judge looks modern in the afternoon light.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F91fe70e2-5a2e-4ad5-bff1-38b83ef5bea6.jpg?alt=media	A public official appointed to decide cases in a court of law.	thẩm phán	dʒʌdʒ	judge	\N	
e056c667-b697-467a-863f-51d6670df651	2025-10-10 18:49:48.282662	2025-10-17 19:01:54.57714	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fddf967c0-3b0b-407f-a31d-958d4fe46b74.mp3?alt=media	A2	[Advice] Keep the restaurant away from water to stay safe. | [School] The teacher asked us to describe a restaurant in two sentences. | [Shopping] She compared three restaurants and chose the freshest one.	\N	A place where meals are served to customers.	nhà hàng	ˈrest(ə)rɒnt	restaurant	\N	“Restaurant interior.jpg” by Jorge Royan, source: https://commons.wikimedia.org/wiki/File:Restaurant_interior.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).
584b2697-a8eb-4de3-b3e6-1ade63945494	2025-10-10 18:49:48.363954	2025-10-17 19:01:56.595523	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa35a141f-3823-4bd3-bc4d-422ccdf5401c.mp3?alt=media	A2	[Memory] This festival reminds me of my childhood in the countryside. | [Hobby] He collects photos of festivals from different countries. | [Description] That festival looks modern in the afternoon light.	\N	A day or period of celebration, typically for religious or cultural reasons.	lễ hội	ˈfestɪvl	festival	\N	
49d132ec-1046-4178-9ab3-7501fc7c0944	2025-10-10 18:49:48.863675	2025-10-17 19:06:22.106761	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F56f451d3-55c8-4026-97d3-fdd1b72c7ff1.mp3?alt=media	B1	[Future] She was hopeful about her chances of getting the job. | [Event] The team felt hopeful after a strong practice session. | [Dream] He remained hopeful that his goals would come true.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F329690f2-a353-4b0c-a216-88fd746fb6a3.jpg?alt=media	Feeling optimistic about a future outcome.	lạc quan	ˈhəʊpfl	hopeful	\N	
af76284a-289f-49f3-a760-be152bed0502	2025-10-10 18:49:48.885494	2025-10-17 19:06:22.646975	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F21f3dce9-67c8-4d2c-9ec5-c2777d31d5fb.mp3?alt=media	B1	[Conservation] Wildlife sanctuaries protect endangered species. | [Travel] We saw incredible wildlife on the safari tour. | [Education] The book teaches kids about wildlife in different regions.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fd53bbcf5-786d-4872-ad0c-047153f6684b.jpg?alt=media	Animals living in their natural environment.	động vật hoang dã	ˈwaɪldlaɪf	wildlife	\N	
901ba8aa-4629-45ed-87d3-73d57e83aa47	2025-10-10 18:49:48.493248	2025-10-17 19:01:59.918954	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F312ec424-85e5-444b-abe8-aeb2b8f6b856.mp3?alt=media	C1	[Description] That entrepreneur looks heavy in the afternoon light. | [Memory] This entrepreneur reminds me of my childhood in the countryside. | [Problem] The entrepreneur broke suddenly, so we had to fix it.	\N	A person who sets up a business, taking on financial risks.	doanh nhân khởi nghiệp	ˌɒntrəprəˈnɜː	entrepreneur	\N	
fa7e5492-bc6c-409a-b01c-ba70f265dfc9	2025-10-10 18:49:48.572207	2025-10-17 19:02:01.481005	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F322e281c-20cf-48e3-b408-d0f249e9cab8.mp3?alt=media	A1	[Cooking] Chop the vegetables finely for a colorful stir-fry dish. | [Shopping] She bought fresh vegetables from the local farmer’s market. | [Health] Eating a variety of vegetables improves your overall nutrition.	\N	A plant or part of a plant used as food.	rau củ	ˈvedʒtəbl	vegetable	\N	
0d9ac936-4341-4d40-ac94-6230317134bf	2025-10-10 18:49:48.61386	2025-10-17 19:02:02.377981	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F89202332-6ac2-4f5d-8956-ab598200786b.mp3?alt=media	A1	[Class] The student raised her hand to answer the teacher’s question. | [Study] He stayed late in the library as a student preparing for exams. | [Event] The student organized a science fair for the school.	\N	A person who is studying at a school or college.	học sinh; sinh viên	ˈstuːdnt	student	\N	
ebc3298b-25d3-4f4c-ae2a-338ae140bda3	2025-10-10 18:49:48.780086	2025-10-17 19:02:05.859574	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F81710e44-5e35-4446-98f5-fbde9b1da7af.mp3?alt=media	A1	[Home] The kitchen smelled amazing with freshly baked bread. | [Renovation] They installed new cabinets in the kitchen last month. | [Cooking] She spent hours in the kitchen preparing a feast.	\N	A room or area where food is prepared and cooked.	nhà bếp	ˈkɪtʃɪn	kitchen	\N	
7ed4a483-9581-44ad-bd90-a7d2caf72b91	2025-10-10 18:49:48.801132	2025-10-17 19:02:06.450487	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F736bcca5-ec22-44b2-aed5-f5bd6d72f9e3.mp3?alt=media	A1	[City] The bridge lit up beautifully at night with colorful lights. | [Travel] We crossed the old stone bridge to reach the village. | [Engineering] The bridge was designed to withstand earthquakes.	\N	A structure carrying a road or path across a river or other obstacle.	cầu	brɪdʒ	bridge	\N	
320c8f1f-aaf1-442d-831e-5dc89a5aa054	2025-10-10 18:49:48.81492	2025-10-17 19:02:06.755942	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F53a7d20d-d16b-45b2-99b7-c3e071e72b65.mp3?alt=media	A1	[Home] She planted roses and tulips in her garden. | [Relaxation] The garden was a quiet place to read and relax. | [Community] The city garden hosts summer concerts for residents.	\N	A piece of land used for growing flowers, vegetables, or plants.	vườn	ˈɡɑːrdn	garden	\N	
f3156f0a-6d2b-4a22-92a3-c866a8dcf605	2025-10-10 18:49:48.897082	2025-10-17 19:06:23.110918	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F01ddf95f-1f85-4340-82c9-638993859c51.mp3?alt=media	B1	[Theater] The performance of the play received a standing ovation. | [Music] Her piano performance was flawless and moving. | [Event] The street performance attracted a large crowd.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc4ac1a01-5e4c-48cd-9144-cf7028e3c452.jpg?alt=media	An act of presenting a play, concert, or other form of entertainment.	biểu diễn	pəˈfɔːrməns	performance	\N	
56b81922-f7e4-42cb-9b0a-89dfc0c3183f	2025-10-10 18:49:48.374131	2025-10-17 19:05:52.591775	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Faff0958d-4df8-4986-9fe5-3471c93f2d89.mp3?alt=media	B1	[School] The teacher asked us to describe a costume in two sentences. | [Everyday] I put the costume on the doorway before dinner. | [Advice] Keep the costume away from dust to stay safe.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc43cddac-0489-4992-8443-214879d8270a.jpg?alt=media	A set of clothes worn for a particular occasion or performance.	trang phục	ˈkɒstjuːm	costume	\N	
2aa891f9-8a1e-4135-8d0f-16134dcc1c87	2025-10-10 18:49:48.38632	2025-10-17 19:05:53.106908	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9bd08cfc-f2fb-4352-ba56-2078339f236d.mp3?alt=media	B1	[Advice] Keep the experiment away from water to stay safe. | [School] The teacher asked us to describe a experiment in two sentences. | [Shopping] She compared three experiments and chose the freshest one.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F3b8c3731-6376-49d6-8c93-34d433090efb.jpg?alt=media	A scientific procedure to test a hypothesis or demonstrate a fact.	thí nghiệm	ɪkˈsperɪmənt	experiment	\N	
61d8a4ff-e4a7-42af-8d1d-d902b4884d4a	2025-10-10 18:49:48.411373	2025-10-17 19:01:57.829204	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F18436401-fcdc-4c0c-8ee4-9627705ea83d.mp3?alt=media	B2	[Everyday] I put the scholarship on the window before dinner. | [Story] A traveler found a scholarship near the old window. | [School] The teacher asked us to describe a scholarship in two sentences.	\N	A grant or payment made to support a student's education.	học bổng	ˈskɒləʃɪp	scholarship	\N	
90c6eae9-2edc-4d7a-a04b-2d84343fafc5	2025-10-10 18:49:48.300628	2025-10-17 19:01:55.06972	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F581723ed-55d2-411f-8002-dd7f7d20fe19.mp3?alt=media	A2	[Shopping] She compared three screens and chose the freshest one. | [Advice] Keep the screen away from dust to stay safe. | [Hobby] He collects photos of screens from different countries.	\N	The flat surface of a device where images and data are displayed.	màn hình	skriːn	screen	\N	
273db95f-caaa-484b-9271-7ccf824c2e0a	2025-10-10 18:49:48.309637	2025-10-17 19:01:55.306088	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffb65f8e1-7505-4f14-b25a-af2ed214abf0.mp3?alt=media	C1	[Hobby] He collects photos of cybersecurities from different countries. | [Shopping] She compared three cybersecurities and chose the freshest one. | [Memory] This cybersecurity reminds me of my childhood in the countryside.	\N	The practice of protecting systems, networks, and programs from digital attacks.	an ninh mạng	ˌsaɪbəsɪˈkjʊərəti	cybersecurity	\N	
34ab08ee-acec-4875-b03d-d769da7491e9	2025-10-10 18:49:48.347002	2025-10-17 19:01:56.244521	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fea7f9e4f-f113-40a1-9c56-c4c05e7e1723.mp3?alt=media	B2	[Problem] The global warming broke suddenly, so we had to fix it. | [Description] That global warming looks safe in the afternoon light. | [Work] The global warming was recorded carefully in the report.	\N	The increase in the earth's average temperature due to greenhouse gases.	nóng lên toàn cầu	ˌɡləʊbl ˈwɔːmɪŋ	global warming	\N	
b8adc413-e1ea-4cbc-bf3a-de5e54422c68	2025-10-10 18:49:48.441284	2025-10-17 19:05:53.739134	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff481c4be-67fc-4215-9660-d2402ae7a8a5.mp3?alt=media	B1	[Description] That court looks heavy in the afternoon light. | [Memory] This court reminds me of my childhood in the countryside. | [Problem] The court broke suddenly, so we had to fix it.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fb088aa11-9417-4724-aa8e-6f06b934e227.jpg?alt=media	A place where legal cases are heard.	tòa án	kɔːt	court	\N	
462d68a3-1e44-4b18-a7ae-d4b119c745dd	2025-10-10 18:49:48.383337	2025-10-17 19:06:47.202341	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F264311d2-20df-4cf9-920c-028213f546c8.mp3?alt=media	B2	[Story] A traveler found a ceremony near the old bench. | [Work] The ceremony was recorded carefully in the report. | [Everyday] I put the ceremony on the bench before dinner.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc757bfe8-495d-4a61-baa6-8a34eaaabf1f.jpg?alt=media	A formal act or series of acts performed according to custom or tradition.	nghi thức	ˈserəməni	ceremony	\N	
3125e20a-d165-4aff-9d55-b02ceaf9bd91	2025-10-10 18:49:48.41805	2025-10-17 19:01:58.043945	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd35e73b6-726c-4df0-95c3-2b1edf660aed.mp3?alt=media	B2	[Description] That literacy looks heavy in the afternoon light. | [Memory] This literacy reminds me of my childhood in the countryside. | [Problem] The literacy broke suddenly, so we had to fix it.	\N	The ability to read and write.	khả năng đọc viết	ˈlɪtərəsi	literacy	\N	
2c7ce3cd-a77f-4ea1-a778-9a0019a63f8d	2025-10-10 18:49:48.427362	2025-10-17 19:01:58.350684	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbbdae01d-07e9-4309-ba00-5e854134eacb.mp3?alt=media	B2	[School] The teacher asked us to describe a graduate in two sentences. | [Everyday] I put the graduate on the bench before dinner. | [Advice] Keep the graduate away from dust to stay safe.	\N	A person who has successfully completed a course of study.	tốt nghiệp; cử nhân	ˈɡrædʒuət	graduate	\N	
46d0d450-8fec-40f9-b771-f98ac72cb218	2025-10-10 18:49:48.731608	2025-10-17 19:01:58.464149	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4099c386-fe01-4751-ad61-33fd22adebbb.mp3?alt=media	A1	[Home] The pet dog greeted us happily at the door. | [Care] She spends time every day feeding and walking her pet. | [Adoption] They decided to adopt a pet from the local shelter.	\N	A domesticated animal kept for companionship.	thú cưng	pet	pet	\N	
4df08286-0192-4aeb-9c5b-b4f4461d8fce	2025-10-10 18:49:48.747418	2025-10-17 19:01:59.06982	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6ff4f320-a1d7-4c70-924c-6b17e4ce104a.mp3?alt=media	A1	[Nature] The wolf howled under the full moon in the forest. | [Myth] Wolves are often portrayed as mysterious in folklore. | [Conservation] Efforts are underway to protect wolves in the region.	\N	A wild carnivorous mammal, often living in packs.	sói	wʊlf	wolf	\N	
6382cd6d-4be7-4ac6-9140-6f46e5405e5d	2025-10-10 18:49:48.463849	2025-10-17 19:01:59.28933	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd9120463-c911-40d1-b54d-0cae029000c4.mp3?alt=media	C1	[Advice] Keep the constitution away from traffic to stay safe. | [School] The teacher asked us to describe a constitution in two sentences. | [Shopping] She compared three constitutions and chose the freshest one.	\N	A body of fundamental principles by which a nation is governed.	hiến pháp	ˌkɒnstɪˈtjuːʃn	constitution	\N	
08984518-6f1e-46ca-b124-7f49fdc31320	2025-10-10 18:49:48.532977	2025-10-17 19:05:54.38676	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe55e6218-2fbc-407e-be78-f424b9ddaa45.mp3?alt=media	B1	[School] The teacher asked us to describe a comment in two sentences. | [Everyday] I put the comment on the wall before dinner. | [Advice] Keep the comment away from dust to stay safe.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F660b638d-d34d-490c-a57d-4ea622ca24c3.png?alt=media	A verbal or written remark expressing an opinion or reaction.	bình luận	ˈkɒment	comment	\N	
0a667169-c8a6-4cbb-9ffa-49679555a257	2025-10-10 18:49:48.596715	2025-10-17 19:06:20.758431	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa88c17fd-df6f-462a-9a6c-5c5600d3a3a8.mp3?alt=media	A1	[Party] I invited my friend to the birthday celebration at home. | [Support] My friend helped me move furniture into my new apartment. | [School] We worked together with my friend on a group project.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F779f92b8-3547-4bc6-b98e-7a52314c7795.jpg?alt=media	A person with whom one has a bond of mutual affection.	bạn bè	frend	friend	\N	
2fb0f237-15ad-4c43-8ade-b1128757f072	2025-10-10 18:49:48.514864	2025-10-17 19:02:00.358911	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa2667c0a-c86a-42a9-ae04-97e9207ad5ec.mp3?alt=media	B2	[Problem] The critic broke suddenly, so we had to fix it. | [Description] That critic looks safe in the afternoon light. | [Work] The critic was recorded carefully in the report.	\N	A person who expresses an unfavorable opinion of something or reviews art.	nhà phê bình	ˈkrɪtɪk	critic	\N	
70be0f81-0376-4d3f-9015-ab7b33ea0f87	2025-10-10 18:49:48.528469	2025-10-17 19:02:00.658098	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Faba2a0f5-6a81-4c91-843f-fd98d7adfd33.mp3?alt=media	A2	[Description] That message looks heavy in the afternoon light. | [Memory] This message reminds me of my childhood in the countryside. | [Problem] The message broke suddenly, so we had to fix it.	\N	A verbal, written, or recorded communication sent to a person or group.	tin nhắn	ˈmesɪdʒ	message	\N	
669dedfa-3e08-42a1-bc09-291438e654b9	2025-10-10 18:49:49.243101	2025-10-17 19:06:51.919105	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb1f16e50-5a91-41cc-83c1-aad20d5e9cd0.mp3?alt=media	B1	[Travel] Apply for a tourist visa. | [Document] Check visa requirements. | [Entry] Get visa on arrival.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F0136b2b1-8be4-45a9-9836-ef812e253669.jpg?alt=media	An official document allowing entry to a country.	thị thực	ˈviːzə	visa	\N	
2db7a213-5b39-480e-bff3-a73026219d51	2025-10-10 18:49:48.565299	2025-10-17 19:02:01.348767	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5422391f-505e-4c40-81ca-811be217699b.mp3?alt=media	A1	[Breakfast] Pour orange juice into glasses for a refreshing start to the day. | [Fitness] After workout, she drank vegetable juice to replenish nutrients. | [Market] The vendor squeezed fresh juice from fruits right in front of customers.	\N	A drink made from the extraction of liquid from fruits or vegetables.	nước ép	dʒuːs	juice	\N	
a9abecfe-4806-4102-bc45-0ef517592ace	2025-10-10 18:49:48.623858	2025-10-17 19:02:02.638654	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa1f48639-88a3-4207-b119-3ce178bbe461.mp3?alt=media	A1	[Classroom] The teacher used chalk to draw a diagram on the blackboard. | [Art] Kids drew hopscotch on the pavement with colorful chalk. | [Memory] The smell of chalk reminded her of her old school days.	\N	A soft white limestone used for writing on blackboards.	phấn viết bảng	tʃɔːk	chalk	\N	
aa4e84d7-1079-435d-a496-9a698793cbcd	2025-10-10 18:49:48.638599	2025-10-17 19:02:02.948875	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbb870426-e30c-490d-bc6f-23faff958b35.mp3?alt=media	A1	[Routine] She studies for two hours every evening to prepare for exams. | [Research] The study on climate change was published last week. | [Library] He found a quiet corner to study in peace.	\N	The act of learning or revising academic subjects.	học tập	ˈstʌdi	study	\N	
4b14fc39-8e56-4aed-b694-8b5fb3d31ada	2025-10-10 18:49:48.660951	2025-10-17 19:02:03.451826	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdeb7de9e-b913-4a74-ac82-2dc264422ee4.mp3?alt=media	B1	[Business] The client was impressed with the new marketing plan. | [Meeting] She prepared a report for the client’s visit tomorrow. | [Service] We aim to satisfy every client with excellent support.	\N	A person or organization using the services of a professional.	khách hàng \n	klaɪənt	client	\N	
c65b6c05-39d5-4115-b135-ed4cd4799c31	2025-10-10 18:49:48.668555	2025-10-17 19:02:03.582862	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F323c06f4-9d22-4b37-8ef2-b2e6ea407939.mp3?alt=media	B1	[Experience] The intern gained valuable skills during the summer program. | [Work] She worked as an intern at a tech startup last year. | [Opportunity] The intern impressed the team with her dedication.	\N	A student or trainee who works to gain experience.	thực tập sinh	ˈɪntɜːrn	intern	\N	
ee6e9102-f858-4984-9a4d-f5da69aecc1f	2025-10-10 18:49:48.688623	2025-10-17 19:02:04.040813	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F17491db6-54ad-46f4-8351-b970fca917f5.mp3?alt=media	A1	[Travel] The train station was crowded with morning commuters. | [Waiting] We met at the station before heading to the festival. | [City] The bus station is just a short walk from the hotel.	\N	A place where trains or buses regularly stop.	ga; trạm	ˈsteɪʃn	station	\N	
a0056831-6ce7-4cbe-9842-538510e22800	2025-10-10 18:49:48.704682	2025-10-17 19:02:04.348096	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb998c294-0d3b-4c99-9026-e6f1c86d984e.mp3?alt=media	A2	[Exercise] She practices yoga every morning to reduce stress. | [Class] The yoga session at the gym was open to beginners. | [Health] Yoga improves flexibility and mental focus over time.	\N	A Hindu spiritual and physical discipline involving breath control and meditation.	yoga	ˈjəʊɡə	yoga	\N	
6d67c37d-d0eb-44cc-8bd3-5d3583c45928	2025-10-10 18:49:48.937829	2025-10-17 19:02:04.546147	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F63f79691-1ea5-42c0-9441-68c6145ff28b.mp3?alt=media	B2	[Education] The seminar on leadership was very inspiring. | [Work] She attended a seminar to learn about new technologies. | [Event] The university hosted a seminar on global health.	\N	A meeting for discussion or training on a specific topic.	hội thảo	ˈsemɪnɑːr	seminar	\N	
453d983a-41e1-4534-9d22-bec95353736f	2025-10-10 18:49:48.716482	2025-10-17 19:02:04.644775	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb02c472b-fe61-41c3-b5b5-fd1d474854e6.mp3?alt=media	A1	[Advice] Good health requires a balanced diet and exercise. | [Checkup] She visited the doctor for a health assessment. | [Community] The campaign promoted mental health awareness.	\N	The state of being free from illness or injury.	sức khỏe	helθ	health	\N	
381f11dc-9efe-47cd-8117-6cb02b725f23	2025-10-10 18:49:48.680831	2025-10-17 19:02:03.767821	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc8ffa0eb-1d8f-46e2-ad9d-e26bd18fe8f9.mp3?alt=media	A1	[Travel] We took a taxi to the airport to catch our flight. | [Convenience] She called a taxi after a late-night event. | [City] Taxis are a popular way to get around in busy cities.	\N	A car licensed to transport passengers in return for payment.	taxi	ˈtæksi	taxi	\N	
9d16b245-249d-4709-ad6c-e283bf2be619	2025-10-10 18:49:48.764326	2025-10-17 19:02:05.507017	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffc3ee64a-19ea-4038-8d18-a75fa1c05c50.mp3?alt=media	A1	[Hiking] We explored the forest and found a hidden waterfall. | [Conservation] Protecting forests helps maintain biodiversity. | [Story] The forest was the setting for a magical adventure.	\N	A large area covered with trees and undergrowth.	rừng	ˈfɒrɪst	forest	\N	
4df4ab6e-6bf8-4f15-8ed2-923986f015a9	2025-10-10 18:49:48.786179	2025-10-17 19:02:06.105254	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F004dd9a7-bd6b-44d9-b339-204684856a4c.mp3?alt=media	A1	[Decor] The lamp added a warm glow to the living room. | [Study] She turned on the desk lamp to read late at night. | [Shopping] They found a vintage lamp at the flea market.	\N	A device for giving light, typically portable.	đèn	læmp	lamp	\N	
629ec111-04a6-4f04-8f25-8c0d658e96af	2025-10-10 18:49:48.81067	2025-10-17 19:02:06.721086	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fffe49184-3323-4979-a931-4b213112e9a6.mp3?alt=media	A1	[Community] The church hosted a charity event for the homeless. | [History] The old church was a landmark in the small town. | [Celebration] They got married in a beautiful church ceremony.	\N	A building used for Christian worship.	nhà thờ	tʃɜːrtʃ	church	\N	
42cc50bf-4d06-4e8f-93ad-a61d4da50614	2025-10-10 18:49:48.872404	2025-10-17 19:06:54.498173	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F75ae7968-f628-4d07-97a8-e400a87837ca.mp3?alt=media	B2	[Biology] The coral reef is a fragile ecosystem needing protection. | [Study] We learned about forest ecosystems in science class. | [Conservation] Restoring the ecosystem helps endangered species.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fb962dc8c-0af5-4b42-b5b1-c98f3156af27.jpg?alt=media	A biological community of interacting organisms and their environment.	hệ sinh thái	ˈiːkəʊsɪstəm	ecosystem	\N	
de7126d7-9d89-4284-b656-7f6002208558	2025-10-10 18:49:48.847218	2025-10-17 19:06:21.325092	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Faf0e26dd-d10a-4f42-9e05-a2a8b1a3c1f0.mp3?alt=media	A2	[Performance] She felt nervous before her piano recital. | [Interview] He was nervous but prepared for the job interview. | [Situation] The loud noise made the dog nervous and jumpy.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Ff347bb8f-e538-44a2-88f3-122d24c41395.jpg?alt=media	Feeling uneasy or apprehensive about something.	lo lắng	ˈnɜːrvəs	nervous	\N	
1fb1fabe-3e03-4228-8aec-442da4065036	2025-10-10 18:49:48.867338	2025-10-17 19:06:22.116652	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdfd4718a-6446-433a-ae89-1720c26b1b1a.mp3?alt=media	B1	[Science] Protecting the environment is crucial for future generations. | [Work] The office environment was friendly and supportive. | [Nature] The clean environment attracted many tourists to the park.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F280d5db1-cd41-4fac-b791-91b95bb8ba89.jpg?alt=media	The surroundings or conditions in which a person, animal, or plant lives.	môi trường	ɪnˈvaɪrənmənt	environment	\N	
7f57664a-79ef-4a88-8a99-31810d16ef69	2025-10-10 18:49:48.883085	2025-10-17 19:06:22.55675	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F322c6d54-7596-46b1-8d63-308864c971b0.mp3?alt=media	B2	[Technology] Wind and solar are forms of renewable energy. | [Environment] Investing in renewable energy reduces fossil fuel use. | [Future] Renewable energy is key to a sustainable planet.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F468674f2-24c9-4e81-884b-8a6058df682a.jpg?alt=media	Energy from sources that are naturally replenishing, like solar or wind.	năng lượng tái tạo	rɪˈnjuːəbl ˈenərdʒi	renewable energy	\N	
bc376700-8217-4a83-814d-0efdce5baa76	2025-10-10 18:49:48.895164	2025-10-17 19:06:23.127849	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7bd9e98e-0327-4a05-9742-7ba13cc3cc16.mp3?alt=media	A1	[Event] Live music filled the air at the outdoor concert. | [Hobby] He plays music on his guitar every evening. | [Culture] Folk music reflects the traditions of the region.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F427fb2d4-ddbc-4159-b318-4c97d0f9073d.jpg?alt=media	Vocal or instrumental sounds combined to produce harmony.	âm nhạc	ˈmjuːzɪk	music	\N	
a8aeb122-ebbd-4727-b626-50e834153873	2025-10-10 18:49:48.899679	2025-10-17 19:06:23.176501	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F347fb6ac-11c4-401e-84b0-7afc4db212bd.mp3?alt=media	B2	[Story] Folklore tales were passed down through generations. | [Culture] The festival celebrated the region’s rich folklore. | [Study] She researched folklore for her history project.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F68557919-a118-4360-9981-04edd285bd77.jpg?alt=media	Traditional beliefs, customs, and stories of a community.	văn hóa dân gian	ˈfəʊklɔːr	folklore	\N	
3d376050-92e3-47a2-a71a-cc6e7e2a9a13	2025-10-10 18:49:48.901797	2025-10-17 19:06:23.529659	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5e16b398-7228-4529-8d4d-e64659e5b1b2.mp3?alt=media	B1	[Hobby] She sells handmade crafts at the local market. | [Art] The craft of pottery requires patience and skill. | [Tradition] The village is known for its traditional crafts.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fd217941f-22b3-4907-b4aa-46b153f51ea6.jpg?alt=media	An activity involving skill in making things by hand.	thủ công	kræft	craft	\N	
ac8861be-cc76-4bc2-bfdf-7c93caebe90e	2025-10-10 18:49:48.824517	2025-10-17 19:06:20.712187	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F92f10e80-289f-4489-90ae-d0b0da6bedac.mp3?alt=media	A2	[Technology] The internet connects people across the globe instantly. | [Work] She relies on the internet for remote meetings and research. | [Daily Life] Without the internet, checking news would be much harder.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F97298cb7-49f5-4335-a0ce-6420aa1855cd.jpg?alt=media	A global computer network providing information and communication.	mạng internet	ˈɪntərnet	internet	\N	
5cef2d1c-b47b-4fdb-ac52-b372971e5ef5	2025-10-10 18:49:48.734133	2025-10-17 19:02:04.953079	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3bef6363-4f60-46b6-a22d-6063e0cf9d53.mp3?alt=media	A1	[Zoo] The tiger paced gracefully in its enclosure at the zoo. | [Wildlife] Conservationists work to protect tigers from extinction. | [Story] The book described a tiger roaming the jungle at night.	\N	A large wild cat with a striped coat, native to Asia.	con hổ	ˈtaɪɡə	tiger	\N	
4d4d6cbc-62ad-4708-b42b-30f05720f05f	2025-10-10 18:49:48.73873	2025-10-17 19:02:05.004421	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0c3d6dd5-ca39-4218-8d8f-6572b201ba07.mp3?alt=media	A1	[Wildlife] The lion roared loudly in the savanna at dusk. | [Documentary] We watched a film about a lion pride’s survival. | [Symbol] The lion is often used as a symbol of courage.	\N	A large wild cat, known as the king of the jungle.	sư tử	ˈlaɪən	lion	\N	
3df97d03-9562-4ebf-93de-720e5b3338ab	2025-10-10 18:49:48.762014	2025-10-17 19:02:05.314708	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F09e845b6-38fb-4ae5-9244-0c40a3202cc7.mp3?alt=media	A1	[Weather] The strong wind blew the leaves across the yard. | [Energy] Wind turbines generate clean energy for the town. | [Sailing] Sailors adjusted the sails to catch the wind.	\N	The natural movement of air, especially in the form of a current.	gió	wɪnd	wind	\N	
d5ce75e4-585e-498a-8107-7e4e82d9bafa	2025-10-10 18:49:48.77355	2025-10-17 19:02:05.629561	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F61f31417-752d-447f-88be-a8805d340568.mp3?alt=media	A2	[Adventure] Crossing the desert required careful planning and supplies. | [Nature] The desert blooms with flowers after rare rainfall. | [Photography] The desert sunset created a dramatic landscape.	\N	A dry, barren area of land with little vegetation.	sa mạc	ˈdezərt	desert	\N	
02b950ae-fee7-4c39-81b7-93f9336dca9b	2025-10-10 18:49:48.796151	2025-10-17 19:02:06.265599	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F545b22ea-cb3f-4e68-bc17-f0fadd2a8999.mp3?alt=media	A1	[Storage] She organized her books neatly on the shelf. | [Decor] The shelf displayed family photos and small plants. | [Shop] He built a wooden shelf for his workshop tools.	\N	A flat surface fixed to a wall or frame for storage.	kệ	ʃelf	shelf	\N	
e0ef842f-849d-440f-a4a3-080227c89e93	2025-10-10 18:49:48.857001	2025-10-17 19:06:21.624557	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd1200e10-4920-423f-9fc6-5a48e923ce41.mp3?alt=media	A1	[Movie] The horror movie left her scared for hours. | [Experience] He was scared when he got lost in the forest. | [Reaction] The loud thunder made the child scared and clingy.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F140e4395-d1b3-4f4d-9101-eb3c16558a43.jpeg?alt=media	Feeling afraid or frightened.	sợ hãi	skeərd	scared	\N	
6d4e0c8b-22b1-4078-bfbb-c42a47bdb1c2	2025-10-10 18:49:48.869732	2025-10-17 19:06:22.090511	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd31f3f95-69d3-4db1-916b-c9ef1b50bc09.mp3?alt=media	B1	[Science] Solar energy is a renewable source of power. | [Daily Life] She lacked energy after staying up late to study. | [Technology] The device saves energy with its efficient design.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F4e4eee5f-e0e1-461b-baf2-b73669589697.jpg?alt=media	The strength and vitality required for sustained activity.	năng lượng	ˈenərdʒi	energy	\N	
e5ccf03c-5424-49a0-b6ec-54554ba1d4f9	2025-10-10 18:49:48.878868	2025-10-17 19:06:22.587707	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fde52b254-cf3c-4b97-bfe3-86fc7cec54d2.mp3?alt=media	B2	[Environment] Reducing emissions helps fight air pollution. | [Industry] Factories must monitor their carbon emissions carefully. | [Policy] New laws aim to lower vehicle emissions in cities.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fbabcb030-bca2-4e9b-afaf-1ed4181053df.jpg?alt=media	The production and discharge of something, especially gas or radiation.	khí thải	ɪˈmɪʃn	emission	\N	
94f51b7d-163c-44c0-889c-0240e935c91a	2025-10-10 18:49:48.839716	2025-10-17 19:06:21.086452	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd7543043-cfb1-48b2-b37e-f97b296e985c.mp3?alt=media	B2	[Programming] The developer fixed a bug in the application. | [Testing] They found a bug during the software testing phase. | [Frustration] The bug caused the program to crash unexpectedly.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F63dd0fb4-3cbd-457c-b61e-0cc65f1dba87.jpg?alt=media	An error or flaw in a computer program.	lỗi phần mềm	bʌɡ	bug	\N	
c3c35ad5-d432-4a36-8c20-62a9a77a859a	2025-10-10 18:49:48.334671	2025-10-17 19:06:21.235889	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fecaa161b-a39c-4971-8ad4-f7efda3074e1.mp3?alt=media	A2	[Hobby] He collects photos of exciteds from different countries. | [Shopping] She compared three exciteds and chose the freshest one. | [Memory] This excited reminds me of my childhood in the countryside.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F4edc35f5-99ba-4ddf-a351-8093e8c912f5.jpg?alt=media	Feeling very enthusiastic and eager.	hào hứng	ɪkˈsaɪtɪd	excited	\N	
f022eed0-6488-4618-95db-c50d6a8bb51b	2025-10-10 18:49:48.878043	2025-10-17 19:06:22.448263	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa7f91e95-d855-4fe0-8fca-7ea9fae56069.mp3?alt=media	B2	[Nature] Preservation of forests ensures wildlife habitats remain. | [History] The museum focuses on the preservation of ancient artifacts. | [Food] Preservation techniques like canning extend shelf life.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc4ea3f64-993a-492b-91f4-8185a6b80b2c.jpg?alt=media	The act of maintaining something in its original state.	bảo tồn	ˌprezəˈveɪʃn	preservation	\N	
a793ad5b-d0fd-4ad1-ba29-10deb496e84e	2025-10-10 18:49:49.286936	2025-10-17 19:06:53.520194	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F180c0db3-267c-401a-8d4f-2af6c242c2f4.mp3?alt=media	A2	[Ocean] Octopuses have eight arms. | [Intelligence] Octopuses solve puzzles. | [Camouflage] Octopuses change colors.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc6813116-92bc-456d-93f6-80f9f47002d3.jpg?alt=media	A marine animal with eight arms and a soft body.	bạch tuộc	ˈɒktəpəs	octopus	\N	
ed78c44e-d82b-4398-b96d-106cdc54eb3d	2025-10-10 18:49:48.921021	2025-10-17 19:02:09.710593	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9c75d729-8695-4f39-ab7e-c1c4c9121cf2.mp3?alt=media	B2	[Study] The analysis of the data revealed surprising results. | [Business] Market analysis helped the company plan its strategy. | [Science] Her analysis of the experiment was very thorough.	\N	Detailed examination of the elements or structure of something.	phân tích	əˈnæləsɪs	analysis	\N	
10109c3c-1c8b-436d-8ea5-d81adc6e3cb8	2025-10-10 18:49:48.924568	2025-10-17 19:02:09.785084	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9a3bc48f-7157-4ead-abd2-d5bd2ebd8e3f.mp3?alt=media	B1	[Math] The formula helped solve the complex equation. | [Science] Chemists use a formula to predict reactions. | [Cooking] The recipe’s formula included precise measurements.	\N	A mathematical or scientific expression or rule.	công thức	ˈfɔːrmjələ	formula	\N	
6dccae02-79fb-4b5c-8bab-8582455b9ece	2025-10-10 18:49:48.928821	2025-10-17 19:02:09.818689	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F740bb5d8-343a-4411-993b-69d42797a025.mp3?alt=media	B1	[Science] Gravity keeps the planets orbiting the sun. | [Physics] The experiment tested the effects of gravity on objects. | [Education] He explained gravity using a falling apple as an example.	\N	The force that attracts objects towards the center of the Earth.	lực hấp dẫn	ˈɡrævɪti	gravity	\N	
daa5c1a0-0ea7-4bec-8cf8-9bb8408aa3aa	2025-10-10 18:49:48.956065	2025-10-17 19:02:10.380548	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fcde9581a-5f67-4266-af3c-a5555454cf47.mp3?alt=media	B1	[Society] The new law promotes equal rights for everyone. | [Study] He studied law to become a human rights lawyer. | [Enforcement] Breaking the law can lead to serious consequences.	\N	A system of rules enforced by a government or institution.	luật pháp	lɔː	law	\N	
c2791686-8b0a-47c8-a65a-533b68d15222	2025-10-10 18:49:48.961643	2025-10-17 19:02:10.585008	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F001eb593-0bab-4b95-aa4b-0295d593dd16.mp3?alt=media	B2	[Politics] The parliament voted on the new education bill. | [History] The parliament building is a historic landmark. | [Government] She was elected to serve in the parliament.	\N	The supreme legislative body in a country.	quốc hội	ˈpɑːrləmənt	parliament	\N	
119d919a-dd6c-4eec-a0b0-c7280e98a639	2025-10-10 18:49:48.964742	2025-10-17 19:02:10.63223	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9eed5ecf-e9d7-42e4-bc9d-2647f4bc49f4.mp3?alt=media	B1	[Society] Every citizen has the right to vote in elections. | [Community] Citizens gathered to discuss local issues. | [Law] The law protects the rights of all citizens.	\N	A legally recognized member of a state or nation.	công dân	ˈsɪtɪzn	citizen	\N	
b010b77b-a49e-4fb3-862f-c15588e849ff	2025-10-10 18:49:48.986369	2025-10-17 19:02:10.979492	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9e7639ec-6ff5-45c0-9db9-7eb122f42f29.mp3?alt=media	C1	[Politics] The government imposed sanctions on the rogue nation. | [Economy] Sanctions affected trade between the two countries. | [International] Lifting sanctions improved diplomatic relations.	\N	A penalty or measure to enforce compliance with law or policy.	trừng phạt	ˈsæŋkʃn	sanction	\N	
6d54d5dd-ba47-450b-80e0-6f4e3d068b89	2025-10-10 18:49:48.990821	2025-10-17 19:02:11.002493	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F683b3867-1372-4f08-83cc-ca01a4f7e41c.mp3?alt=media	B2	[History] The treaty ended the long-standing conflict. | [Politics] Nations signed a treaty on environmental protection. | [Law] The treaty outlined terms for mutual cooperation.	\N	A formally concluded agreement between countries.	hiệp ước	ˈtriːti	treaty	\N	
12b60a14-b5d7-45fa-922a-1c1b77c8cc3b	2025-10-10 18:49:49.00477	2025-10-17 19:02:11.270478	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F185fa5f2-a8e7-49dd-8b61-ca28ab84a1c3.mp3?alt=media	B1	[Diplomacy] The embassy hosted a cultural exchange event. | [Travel] Contact the embassy for visa information. | [Politics] The embassy represents the country's interests abroad.	\N	The official residence or office of an ambassador.	đại sứ quán	ˈembəsi	embassy	\N	
53abf7cb-6bfb-42f3-b3a1-882d335c36a1	2025-10-10 18:49:49.018744	2025-10-17 19:02:11.516524	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffd8eafa6-863a-4e26-93cf-6ffc12fb1b94.mp3?alt=media	B2	[Law] The jury deliberated for hours. | [Trial] Serve on a jury for the case. | [Verdict] The jury reached a unanimous decision.	\N	A group of people sworn to give a verdict in a legal case.	bồi thẩm đoàn	ˈdʒʊəri	jury	\N	
1e6d9955-9fd2-450b-9fa3-02dadcec9b3c	2025-10-10 18:49:49.031779	2025-10-17 19:02:11.682693	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F53a67abe-250a-48b3-bf2b-5c4e3001a379.mp3?alt=media	B2	[Business] The merger created a larger corporation. | [Economy] Approve the merger after review. | [Strategy] The merger enhanced market share.	\N	The combining of two or more companies into one.	sáp nhập	ˈmɜːdʒə	merger	\N	
0f72e2f8-d3ab-4e25-917a-ec6d7441abc3	2025-10-10 18:49:49.035284	2025-10-17 19:02:11.900366	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F14271f8b-a2ce-45e0-a282-1b9477ddeabb.mp3?alt=media	B2	[Business] Open a franchise of the restaurant. | [Model] The franchise model is profitable. | [Expansion] Buy a franchise opportunity.	\N	A license to operate a business under a brandâ€™s name.	nhượng quyền	ˈfræntʃaɪz	franchise	\N	
d4ea243e-e8c2-45d8-ae3a-294fc7a248ab	2025-10-10 18:49:49.163624	2025-10-17 19:06:20.805408	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa5c2db33-3fcb-4434-ab94-dce6a052f764.mp3?alt=media	B1	[Child] Help the orphan. | [Home] Adopt an orphan. | [Support] Care for orphans.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F81070a52-e38d-4daa-a917-98e76c7b77ab.jpg?alt=media	A child whose parents are dead.	mồ côi	ˈɔːfn	orphan	\N	
fa6ed463-3bfd-406c-ae34-672f36090354	2025-10-10 18:49:49.065818	2025-10-17 19:02:12.468977	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd7dab4c7-c21c-42f0-9cf6-5405ba371d0d.mp3?alt=media	B1	[Art] Visit the art exhibition. | [Event] Host an exhibition of photographs. | [Museum] The exhibition attracts visitors.	\N	A public display of works of art or items of interest.	triển lãm	ˌeksɪˈbɪʃn	exhibition	\N	
3cd1685f-8082-4a41-80fa-b07cae255376	2025-10-10 18:49:49.083729	2025-10-17 19:02:12.780314	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F830daed4-7af8-486c-b432-288cd92394db.mp3?alt=media	B2	[Literature] Write a personal memoir. | [Book] Read the celebrity's memoir. | [Story] The memoir recounts life experiences.	\N	A written account of oneâ€™s personal life and experiences.	hồi ký	ˈmemwɑː	memoir	\N	
53fc66fd-f80f-483c-a412-d7b0ba325a55	2025-10-10 18:49:49.095899	2025-10-17 19:02:13.09399	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7e4f025c-8314-4ff4-8930-fa327a18b279.mp3?alt=media	A2	[Writing] Start a personal blog. | [Content] Update the blog weekly. | [Read] Follow interesting blogs.	\N	A regularly updated website or web page, typically run by an individual.	blog	blɒɡ	blog	\N	
a93aab17-7596-4722-b221-802b2913a656	2025-10-10 18:49:49.132257	2025-10-17 19:06:48.694319	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe1f891bc-7bc1-4ad4-abc8-177f7d0fda5f.mp3?alt=media	B1	[Menu] Choose a beverage. | [Variety] Offer hot beverages. | [Refresh] Enjoy a cold beverage.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Ffb92067c-54de-49c9-86fa-0bc38fbf0c0b.jpg?alt=media	A drink, such as water, juice, or soda.	đồ uống	ˈbevərɪdʒ	beverage	\N	
ff282b9b-35b9-4c4c-9e3a-99f8a7192bca	2025-10-10 18:49:49.222072	2025-10-17 19:06:51.449857	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe0b794b3-a7d8-4227-8d5f-41c86a8abd7a.mp3?alt=media	B1	[Traffic] Navigate the roundabout carefully. | [Road] Enter the roundabout. | [Flow] Roundabout improves traffic flow.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fa390f9b2-2adf-48dc-800c-ceff472fa770.jpg?alt=media	A circular intersection where traffic flows around a central island.	vòng xuyến	ˈraʊndəbaʊt	roundabout	\N	
ce1af51a-e499-49df-b414-eb5421a92103	2025-10-10 18:49:49.296044	2025-10-17 19:06:53.908248	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa33d6448-3776-4a8d-ad11-703970d42a5a.mp3?alt=media	A2	[Ocean] Starfish regenerate arms. | [Beach] Find starfish on shore. | [Color] Starfish are colorful.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F149c4c88-cf85-4134-a841-f2800b06f162.jpg?alt=media	A marine animal with a star-shaped body and five arms.	sao biển	ˈstɑːfɪʃ	starfish	\N	
2e6fd08a-7133-4292-b30b-a1f6f65822e5	2025-10-10 18:49:49.106922	2025-10-17 19:06:47.556245	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2eef16aa-2421-4393-b7c9-cf4943db494a.mp3?alt=media	B1	[Internet] Share a funny meme. | [Culture] The meme went viral. | [Humor] Create original memes.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fbb000d64-6c0c-4629-986c-906cbf7b6686.png?alt=media	A humorous image, video, or text copied and spread online.	meme	miːm	meme	\N	
a932b9d4-688b-4109-8d88-43fb61e78137	2025-10-10 18:49:49.199293	2025-10-17 19:02:15.316222	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F89d7e4b5-057f-4ca1-9e40-6d133c77f047.mp3?alt=media	B1	[Work] Receive a performance bonus. | [Incentive] Offer year-end bonus. | [Motivation] Earn extra bonus.	\N	An extra payment given for good performance.	tiền thưởng	ˈbəʊnəs	bonus	\N	
b7ca1f07-abc9-4941-992a-069e313bf3a2	2025-10-10 18:49:49.306926	2025-10-17 19:06:54.37188	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Feb40b2ef-a7e7-40c2-9ba4-7083c121aa9b.mp3?alt=media	B1	[Planet] Earth's atmosphere protects life. | [Weather] Atmosphere causes weather changes. | [Space] Study Mars' atmosphere.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F397241c9-f465-439e-95b4-afad4f5bf7f1.jpg?alt=media	The layer of gases surrounding a planet.	khí quyển	ˈætməsfɪə	atmosphere	\N	
3e5ab82c-f469-4efd-8e40-7f9af702cd4b	2025-10-10 18:49:49.238651	2025-10-17 19:02:16.232091	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fba61fcb8-f315-4f13-80ff-50ef4eb8f596.mp3?alt=media	B2	[Travel] Recover from jet lag. | [Symptom] Feel tired due to jet lag. | [Tip] Adjust to jet lag quickly.	\N	Fatigue caused by traveling across time zones.	mệt mỏi do lệch múi giờ	dʒet læɡ	jet lag	\N	
e4b4b6e5-427f-4e81-a92a-9416eb484a23	2025-10-10 18:49:49.329268	2025-10-17 19:06:55.57161	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd6fea967-d290-4c80-a654-76e0433f0a56.mp3?alt=media	A1	[Clothes] Iron the shirt. | [Tool] Use a steam iron. | [Chore] Iron wrinkled clothes.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F2d302481-87a1-4436-9276-7dae9f869007.jpg?alt=media	A device used to press clothes to remove wrinkles.	bàn ủi	ˈaɪən	iron	\N	
9a771b4e-4b54-42db-85f7-0262ef349e46	2025-10-10 18:49:49.269266	2025-10-17 19:02:16.862351	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F11222aa5-5e51-459c-88c6-b664c9233857.mp3?alt=media	B2	[Lifestyle] Promote overall wellness. | [Program] Participate in wellness activities. | [Balance] Achieve mental and physical wellness.	\N	The state of being in good health, especially as an active goal.	sức khỏe tổng thể	ˈwelnəs	wellness	\N	
5de0140d-eb1d-47eb-9a38-c682b7b7e418	2025-10-10 18:49:49.336787	2025-10-17 19:06:55.719867	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fff68f319-2db6-4d4b-9c02-2f34a204fb10.mp3?alt=media	A1	[Kitchen] Bake in the oven. | [Cooking] Preheat the oven. | [Appliance] Clean the oven.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F0cb50ce2-acdf-4426-be6e-9d7184fc338e.jpg?alt=media	An appliance for baking or roasting food.	lò nướng	ˈʌvn	oven	\N	
be2348e6-27d5-4e93-9550-0bb136793d02	2025-10-10 18:49:48.912735	2025-10-17 19:06:46.997274	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7401d6a6-4026-4911-b7e4-b5d55c600be0.mp3?alt=media	B2	[Study] Astronomy involves observing stars and planets. | [Hobby] He bought a telescope to pursue his interest in astronomy. | [Science] Astronomy discoveries change our view of the universe.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F45e1b6f7-7e66-477a-9b67-4b495b035a03.jpg?alt=media	The scientific study of celestial objects and phenomena.	thiên văn học	əˈstrɒnəmi	astronomy	\N	
4316bf87-bd18-41f3-a620-9d8c441e27d8	2025-10-10 18:49:48.026745	2025-10-17 19:04:42.848833	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F525eb789-fc64-49aa-a48f-07ce0122ef94.mp3?alt=media	A1	[Story] A traveler found a son near the old shelf. | [Work] The son was recorded carefully in the report. | [Everyday] I put the son on the shelf before dinner.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fe3807f41-610e-4c31-ba92-b5c38b3a13df.jpg?alt=media	A male child in a family.	con trai	sʌn	son	\N	
38fc3d91-6588-4459-9b7d-94f4788282c2	2025-10-10 18:49:48.231377	2025-10-17 19:01:53.300267	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fab8f8a48-59aa-441a-99a7-d149452afa94.mp3?alt=media	A1	[Hobby] He collects photos of rivers from different countries. | [Shopping] She compared three rivers and chose the freshest one. | [Memory] This river reminds me of my childhood in the countryside.	\N	A large natural stream of water flowing to the sea or a lake.	sông	ˈrɪvə	river	\N	“Amazon River.jpg” by Neil Palmer, source: https://commons.wikimedia.org/wiki/File:Amazon_River.jpg, license: CC BY-SA 2.0 (https://creativecommons.org/licenses/by-sa/2.0/).
1e4e851f-baff-4b7e-8cf6-2c8044b471dd	2025-10-10 18:49:48.285129	2025-10-17 19:01:54.686896	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8e8bc0bd-5269-41fe-af2f-2d8458739fe2.mp3?alt=media	A2	[Shopping] She compared three museums and chose the freshest one. | [Advice] Keep the museum away from dust to stay safe. | [Hobby] He collects photos of museums from different countries.	\N	A building displaying objects of cultural or historical interest.	bảo tàng	mjuˈziːəm	museum	\N	“British Museum Great Court.jpg” by Diliff, source: https://commons.wikimedia.org/wiki/File:British_Museum_Great_Court.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).
17ebbd48-d223-4e40-a8ff-3b30bb4d0eb6	2025-10-10 18:49:48.094061	2025-10-17 19:04:44.447758	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6e23242f-5c89-4dc5-ab98-e2b607bf9814.mp3?alt=media	A2	[Description] That boss looks heavy in the afternoon light. | [Memory] This boss reminds me of my childhood in the countryside. | [Problem] The boss broke suddenly, so we had to fix it.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fd2887b0f-c070-43a7-8018-b5d80e44079e.jpg?alt=media	A person in charge of a worker or organization.	sếp	bɒs	boss	\N	
3994ab27-f60a-40dc-863b-d343e2a436e4	2025-10-10 18:49:48.92608	2025-10-17 19:02:09.792896	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F404b3d9f-3948-46ab-8d1c-a7b4854b3092.mp3?alt=media	B2	[Chemistry] The molecule’s structure was studied in the lab. | [Science] Water is made up of two hydrogen molecules and one oxygen. | [Education] She drew the molecule on the board for the class.	\N	A group of atoms bonded together, the smallest unit of a chemical compound.	phân tử	ˈmɒlɪkjuːl	molecule	\N	
4e21806d-bae8-4993-9690-9c9456510ddb	2025-10-10 18:49:48.996569	2025-10-17 19:02:11.061034	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdef79367-0750-4a4c-aaf4-a179b12027a8.mp3?alt=media	B2	[Politics] The alliance strengthened defense capabilities. | [Business] Companies formed an alliance to share resources. | [History] The alliance shifted the balance of power.	\N	A union or association formed for mutual benefit.	liên minh	əˈlaɪəns	alliance	\N	
3a93c64c-ba3b-43ba-b420-3465647d3abf	2025-10-10 18:49:49.053928	2025-10-17 19:02:12.237136	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd4c5c664-9cf7-4973-9b67-e6721c1e1311.mp3?alt=media	B2	[Finance] Diversify your investment portfolio. | [Art] Showcase your portfolio online. | [Career] Build a professional portfolio.	\N	A collection of investments or works.	danh mục đầu tư	pɔːtˈfəʊliəʊ	portfolio	\N	
4b28459c-8236-49ad-b72f-ef345f67cd55	2025-10-10 18:49:49.063256	2025-10-17 19:02:12.28853	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F940ddd0a-7975-4867-afba-3d903eb31cb1.mp3?alt=media	B2	[Art] Paint a mural on the wall. | [Community] The mural depicts local history. | [Decoration] Admire the colorful mural.	\N	A large painting or artwork applied directly to a wall.	tranh tường	ˈmjʊərəl	mural	\N	
a814171c-b882-4541-8828-faa19e232b88	2025-10-10 18:49:49.174465	2025-10-17 19:06:49.803045	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F614a0147-4028-4869-9e20-890ea0e93317.mp3?alt=media	B1	[Education] Receive your diploma. | [Achievement] Frame the diploma. | [Qualification] Earn a diploma.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fbe6d06b4-f4cb-459f-b741-3c505e3d03ee.jpg?alt=media	A certificate awarded for completing a course of study.	bằng cấp	dɪˈpləʊmə	diploma	\N	
212124d0-0491-4206-be63-75754545e091	2025-10-10 18:49:48.482817	2025-10-17 19:06:50.803918	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9add9bf9-4742-4867-a63d-aba9dc0bc6d5.mp3?alt=media	B2	[Work] The negotiation was recorded carefully in the report. | [Problem] The negotiation broke suddenly, so we had to fix it. | [Story] A traveler found a negotiation near the old desk.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fcba3a942-0fc0-4a58-9c49-25c9353da239.jpg?alt=media	Discussion aimed at reaching an agreement.	đàm phán	nɪˌɡəʊʃiˈeɪʃn	negotiation	\N	
18b0f067-a10a-4c66-9d27-f3b062721c23	2025-10-10 18:49:49.235303	2025-10-17 19:06:51.811155	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F67402df6-cb06-4f45-8e11-dd20e39c5906.mp3?alt=media	B2	[Flight] Have a short layover. | [Airport] Shop during layover. | [Travel] Avoid long layovers.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F27d9719a-99de-4d50-aca7-bbb945b77ad2.jpg?alt=media	A stop between flights during a journey.	dừng chân	ˈleɪəʊvə	layover	\N	
b02725a9-c914-4ed8-8701-326c375071fa	2025-10-10 18:49:49.279367	2025-10-17 19:06:52.955939	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F130a16c7-c41e-47f7-8b80-12cbcc3f072c.mp3?alt=media	A1	[Ocean] Sharks swim in deep waters. | [Fear] Avoid shark attacks. | [Species] Study great white sharks.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F4aef8f35-56ad-4a1c-9808-24d90b85c10d.jpg?alt=media	A large marine fish with sharp teeth, often predatory.	cá mập	ʃɑːk	shark	\N	
0c08794c-62d4-474b-99d9-deeda83be44c	2025-10-10 18:49:48.586046	2025-10-17 19:06:47.909482	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F47c5a01e-3ae5-4f2c-bb8a-e70980caf446.mp3?alt=media	A1	[Dinner] She cooked pasta with a rich tomato sauce for the family. | [Restaurant] The menu offered a variety of pasta dishes with seafood. | [Travel] In Italy, we learned to make fresh pasta from scratch.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fa57d5a8b-1433-47d6-a27c-4254521d7830.jpg?alt=media	A food made from flour and water, shaped into various forms.	mì Ý	ˈpæstə	pasta	\N	
f1d68be1-44ce-4f0e-bffc-fa6f28b669b4	2025-10-10 18:49:49.101998	2025-10-17 19:06:47.573722	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6671482e-6cde-45a3-a59a-c89ea85345cd.mp3?alt=media	B2	[Education] Attend a webinar on marketing. | [Event] Host a free webinar. | [Learning] Register for the webinar.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fcfc320b5-6fa0-4428-bab5-d25d0c22df44.png?alt=media	An online seminar conducted over the internet.	hội thảo trực tuyến	ˈwebɪnɑː	webinar	\N	
35e482f6-8fdf-4107-be24-7a13fc9ab4ea	2025-10-10 18:49:48.020058	2025-10-17 19:01:49.566153	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5c603b35-9c44-4c4d-96a3-d1aaed0b9ec0.mp3?alt=media	A1	[Advice] Keep the brother away from heat to stay safe. | [School] The teacher asked us to describe a brother in two sentences. | [Shopping] She compared three brothers and chose the freshest one.	\N	A male sibling who shares family bonds.	anh/em trai	ˈbrʌðə	brother	\N	“Brothers.jpg” by Alex, source: https://commons.wikimedia.org/wiki/File:Brothers.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).
be5b2186-183b-49c2-8cea-faa78967c64d	2025-10-10 18:49:48.251106	2025-10-17 19:01:53.858671	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F32e80a2f-801f-4909-93f6-991a78ac6a93.mp3?alt=media	A1	[Work] The door was recorded carefully in the report. | [Problem] The door broke suddenly, so we had to fix it. | [Story] A traveler found a door near the old bag.	\N	A hinged or sliding barrier for closing an entrance.	cửa	dɔː	door	\N	“Wooden door.jpg” by Maderibeyza, source: https://commons.wikimedia.org/wiki/File:Wooden_door.jpg, license: CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/).
f780f3e1-e7a3-4c96-b73d-91eab2aecbf1	2025-10-10 18:49:48.478395	2025-10-17 19:01:59.707025	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F38982cbd-a2c5-40b3-9f82-cdc91254021f.mp3?alt=media	B2	[Advice] Keep the investment away from noise to stay safe. | [School] The teacher asked us to describe a investment in two sentences. | [Shopping] She compared three investments and chose the freshest one.	\N	The action or process of investing money for profit.	đầu tư	ɪnˈvestmənt	investment	\N	
9ad54faf-3409-4d21-9d52-50851425e208	2025-10-10 18:49:48.497684	2025-10-17 19:02:00.046399	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8ea71e21-d06b-4234-b4da-044b7c14aa69.mp3?alt=media	B1	[Hobby] He collects photos of novels from different countries. | [Shopping] She compared three novels and chose the freshest one. | [Memory] This novel reminds me of my childhood in the countryside.	\N	A fictitious prose narrative of book length.	tiểu thuyết	ˈnɒvl	novel	\N	
257176ac-4845-42e5-a0e5-a6c0c3255b33	2025-10-10 18:49:49.086754	2025-10-17 19:02:12.844935	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbf87d3b8-02a9-4a92-9f55-a5fdd173ee16.mp3?alt=media	B1	[Social Media] The topic is trending worldwide. | [News] Check trending hashtags. | [Popularity] The video is trending on the platform.	\N	Currently popular or widely discussed, especially on social media.	đang thịnh hành	ˈtrendɪŋ	trending	\N	
c7fdfd6a-eff1-41ff-a6ba-7226844f0218	2025-10-10 18:49:49.138548	2025-10-17 19:06:48.940842	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F026d931d-614c-4b64-8b16-4569494b5e2a.mp3?alt=media	B1	[Family] Introduce your spouse. | [Marriage] Support your spouse. | [Relationship] Travel with your spouse.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F912c2ee6-a1dc-4efa-9a6a-4ad012ba20e9.jpg?alt=media	A husband or wife, considered in relation to their partner.	vợ/chồng	spaʊz	spouse	\N	
d3106bfa-da5b-47ce-b12c-9040baa3a0ff	2025-10-10 18:49:49.154117	2025-10-17 19:06:49.252266	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb3326043-bc14-4b63-8051-d0ff260a153e.mp3?alt=media	B1	[Marriage] File for divorce. | [Process] Go through divorce. | [Law] Settle divorce terms.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F70cd3c36-1bf1-4585-8faf-d62b9f40894f.jpg?alt=media	The legal dissolution of a marriage.	ly hôn	dɪˈvɔːs	divorce	\N	
e85e6fc0-e162-4ed7-92b5-206060044294	2025-10-10 18:49:49.214719	2025-10-17 19:06:51.066774	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb816acff-17d7-4ab0-b7dc-de34f51dfd79.mp3?alt=media	B2	[Work] Receive annual appraisal. | [Feedback] Use appraisal for improvement. | [Process] Conduct fair appraisals.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Ff20106a0-691e-4120-9d1a-58add35a0386.png?alt=media	An assessment of someoneâ€™s performance or the value of something.	đánh giá hiệu suất	əˈpreɪzl	appraisal	\N	
7fea3d8b-90ee-4f7d-a28f-571e7eedbf95	2025-10-10 18:49:49.26424	2025-10-17 19:06:52.604263	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5385d181-477e-42be-b39d-929bc1365f15.mp3?alt=media	B2	[Health] Maintain proper hydration. | [Exercise] Drink water for hydration. | [Importance] Hydration prevents fatigue.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Ff0989e02-04ed-4de0-8953-122b15ee82e1.jpg?alt=media	The process of keeping the body supplied with water.	sự hydrat hóa	haɪˈdreɪʃn	hydration	\N	
105b4aad-e4b4-41cb-8f17-11501595a42c	2025-10-10 18:49:49.303116	2025-10-17 19:06:53.985072	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F42c7470c-1153-4a96-bf69-880298d4bd53.mp3?alt=media	B1	[Space] Observe a comet tail. | [Orbit] Comets orbit the sun. | [Event] See the comet pass.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc10bbc3f-aa04-409b-89c8-f008d485e841.jpg?alt=media	A celestial body with a bright head and a long tail, orbiting the sun.	sao chổi	ˈkɒmɪt	comet	\N	
f6624c5c-23d8-4914-9bdc-9e24438accb4	2025-10-10 18:49:49.32548	2025-10-17 19:06:55.27089	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F06e0c24f-9a17-4d4c-b880-47a6755b663e.mp3?alt=media	A1	[Home] Load the washing machine. | [Appliance] Repair the washing machine. | [Laundry] Wash clothes in machine.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F4767d5d0-274c-449b-872b-46013669973d.jpg?alt=media	A machine for washing clothes.	máy giặt	ˈwɒʃɪŋ məˈʃiːn	washing machine	\N	
1095ba50-88c2-49c5-92f0-76064b90e0ca	2025-10-10 18:49:49.123548	2025-10-17 19:06:48.372189	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fae049aaa-720f-4d0e-9094-a8fe04539070.mp3?alt=media	A1	[Snack] Make popcorn for movies. | [Cinema] Buy popcorn at the theater. | [Flavor] Season popcorn with butter.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F0af8a05c-c664-4aa3-8bf4-e81d61e1ee5d.jpg?alt=media	Corn kernels that expand and puff up when heated.	bắp rang	ˈpɒpkɔːn	popcorn	\N	
180edcd4-46ac-4d9d-a395-cc82d8b847c4	2025-10-10 18:49:48.288137	2025-10-17 19:06:47.654822	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F65a3955f-00c7-410d-aa13-2e2a2e3ca3f4.mp3?alt=media	B2	[Story] A traveler found a algorithm near the old shelf. | [Work] The algorithm was recorded carefully in the report. | [Everyday] I put the algorithm on the shelf before dinner.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F754809fb-47d0-42eb-82f1-c020f29909b1.jpg?alt=media	A step-by-step procedure for solving a problem or performing a computation.	thuật toán	ˈælɡərɪðəm	algorithm	\N	
cf83d4b4-ca5c-46d5-b577-8d8775d4f59c	2025-10-10 18:49:48.438319	2025-10-17 19:02:10.746571	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F318e12ba-914a-4438-bf6a-819bd2dc4a91.mp3?alt=media	B2	[Shopping] She compared three justices and chose the freshest one. | [Advice] Keep the justice away from sunlight to stay safe. | [Hobby] He collects photos of justices from different countries.	\N	The quality of being fair and reasonable.	công lý	ˈdʒʌstɪs	justice	\N	
4367d0a5-f9b1-4c92-b58d-c6735c7df2d5	2025-10-10 18:49:49.248346	2025-10-17 19:06:52.009281	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd7427f6d-b682-48ff-a490-5a4a2063c52b.mp3?alt=media	B1	[Sport] Train for a marathon. | [Event] Run in the city marathon. | [Endurance] Finish the marathon race.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F24bad548-b808-47c3-bd67-d468e424b207.jpg?alt=media	A long-distance running race, typically 42.195 kilometers.	cuộc chạy maratông	ˈmærəθən	marathon	\N	
48178cb1-c1e4-472a-900d-4bf164a752a5	2025-10-10 18:49:49.261578	2025-10-17 19:06:52.470486	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc8f8fca0-bb02-4ed0-9185-bd693c8015bf.mp3?alt=media	B1	[Health] Focus on balanced nutrition. | [Diet] Study sports nutrition. | [Advice] Get nutrition tips from experts.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F36019470-18fc-4ba2-a42f-39ec1ffb7e8c.png?alt=media	The process of obtaining or providing food for health and growth.	dinh dưỡng	njuːˈtrɪʃn	nutrition	\N	
7645e3f2-d33d-42c7-88b0-c90faf1f839d	2025-10-10 18:49:49.183349	2025-10-17 19:02:14.981682	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F36edaac5-4bcd-4c2b-91d1-a31f27291b9e.mp3?alt=media	B2	[School] Complete enrollment process. | [University] Increase enrollment numbers. | [Course] Check enrollment status.	\N	The act of registering or enrolling in a course or institution.	đăng ký học	ɪnˈrəʊlmənt	enrollment	\N	
6f4797ea-dbc9-49ad-a33c-94b5e7e76954	2025-10-10 18:49:49.28929	2025-10-17 19:06:53.463172	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7f7c5698-e898-4eef-9a19-9ab73febebe0.mp3?alt=media	A2	[Ocean] Squids squirt ink. | [Food] Eat fried squid. | [Size] Giant squids are mysterious.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fbf868e39-83b6-4353-8ec7-bf89377f4cb2.jpg?alt=media	A marine animal with a long body and ten arms, related to octopuses.	mực ống	skwɪd	squid	\N	
28bc7a62-9c62-4bc2-ab9d-772356929321	2025-10-10 18:49:49.333259	2025-10-17 19:06:55.623548	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa3d2f6fd-076b-4f14-877b-89778f11a243.mp3?alt=media	A1	[Kitchen] Toast bread in toaster. | [Breakfast] Use the toaster daily. | [Appliance] Buy a new toaster.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fab038b6b-1cd7-4bdc-a8fb-8fb3cd822a33.jpg?alt=media	An appliance for toasting bread.	máy nướng bánh mì	ˈtəʊstə	toaster	\N	
b62ca336-49fa-48c0-8f7f-a0edf3d8a5c9	2025-10-10 18:49:49.335787	2025-10-17 19:06:55.676955	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5562fe69-c6ac-4c99-afad-7d1d87a1b161.mp3?alt=media	A2	[Kitchen] Blend fruits in blender. | [Appliance] Clean the blender. | [Recipe] Use blender for smoothies.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc748720b-b982-43a5-ab76-3f973c28e372.jpg?alt=media	An appliance for blending or pureeing food.	máy xay	ˈblendə	blender	\N	
72b8c5e2-6168-4927-b758-9c46cbb1a602	2025-10-10 18:49:49.11158	2025-10-17 19:06:48.013839	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc0e4052d-71f9-4cbb-96b4-5072215bf877.mp3?alt=media	A1	[Breakfast] Eat cereal with milk. | [Healthy] Choose whole grain cereal. | [Variety] Try different cereal flavors.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc852bb4c-678c-4ffc-8e9f-ec300b1f51aa.jpg?alt=media	A grain-based food, often eaten for breakfast.	ngũ cốc	ˈsɪəriəl	cereal	\N	
554381b5-fa4d-4688-8921-a03960c03bd2	2025-10-10 18:49:49.126161	2025-10-17 19:06:48.589903	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fee24e03a-4491-4a58-800a-a6e9549ee608.mp3?alt=media	A2	[Cooking] Add spice to the dish. | [Variety] Use different spices. | [Flavor] Spice enhances taste.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F54b6bc03-529d-4b6a-b419-a38f14f23d13.jpg?alt=media	A substance used to flavor food, often dried seeds or bark.	gia vị	spaɪs	spice	\N	
de7bf23f-0c55-4f21-a2f4-7f754d753bf5	2025-10-10 18:49:49.157209	2025-10-17 19:06:49.469667	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4dd07636-1a83-4fba-bc8b-f6892c95ef44.mp3?alt=media	B2	[Family] Support the widow. | [Loss] Become a widow. | [Community] Help widows in need.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F0139c0e8-abc3-48a9-a7f7-d59f9d579bbf.jpg?alt=media	A woman whose spouse has died and who has not remarried.	goá phụ	ˈwɪdəʊ	widow	\N	
f6449c21-0a8c-4d42-8040-096b46de4bb2	2025-10-10 18:49:49.172395	2025-10-17 19:06:49.691527	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6a62b06f-58af-4cc2-a904-33e4f10b79dd.mp3?alt=media	A2	[Presentation] Connect the projector. | [Class] Use projector for slides. | [Meeting] Set up the projector.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc13bd101-3c35-4ae4-9f0c-b7daf72505b4.jpg?alt=media	A device that projects images by shining light through a small transparent image.	máy chiếu	prəˈdʒektə	projector	\N	
0ad8c7fe-c5e8-4c19-a0fc-78cba7f52f4b	2025-10-10 18:49:49.165808	2025-10-17 19:06:49.708423	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff9747075-7ca8-4c03-87be-3e1426176f27.mp3?alt=media	B2	[Family] Consider adoption options. | [Process] Complete the adoption. | [Child] Find home through adoption.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fd6ec7573-ec65-422e-8ed3-f4d58660112d.jpg?alt=media	The act of legally taking anotherâ€™s child as oneâ€™s own.	nhận con nuôi	əˈdɒpʃn	adoption	\N	
1a51ba3c-0209-4bc0-a5bb-d3ca4524cf12	2025-10-10 18:49:48.574974	2025-10-17 19:02:01.56906	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0a0e5a42-7b3b-4d0c-b60b-1da23f9022eb.mp3?alt=media	A1	[Snack] He grabbed a piece of fruit from the bowl for a quick bite. | [Dessert] The fruit salad was a refreshing end to the meal. | [Travel] Tropical fruits like mangoes were abundant in the island market.	\N	The sweet, edible part of a plant, typically containing seeds.	trái cây	fruːt	fruit	\N	
754ee5d5-00ef-4687-946b-7663e0fd8892	2025-10-10 18:49:48.637233	2025-10-17 19:02:02.832685	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff112a993-7ce1-4350-8fe1-40d4690cb231.mp3?alt=media	A1	[School] She was thrilled to receive a high grade on her essay. | [Feedback] The teacher wrote comments next to the grade on the test. | [Goal] He studied hard to improve his math grade.	\N	A mark indicating the quality of a studentâ€™s work.	điểm số	ɡreɪd	grade	\N	
e59b1c30-7f29-4932-8d6a-06925d737687	2025-10-10 18:49:48.559948	2025-10-17 19:05:54.952286	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb2e83ac2-ed76-4356-9216-f651ac4c16c1.mp3?alt=media	A1	[Recipe] Mix banana with yogurt for a healthy smoothie in the morning. | [Travel] During the tropical trip, we picked fresh bananas from the trees. | [Party] She decorated the table with banana leaves for an exotic theme.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fb8a57913-8abb-4677-bb1a-30aeef91f457.jpg?alt=media	A long, curved fruit with a soft sweet flesh inside a thick skin.	quả chuối	bəˈnɑːnə	banana	\N	
c8a28113-178c-4685-b390-b43aa361d9b1	2025-10-10 18:49:49.177508	2025-10-17 19:06:50.085581	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd114e3f8-a944-4b23-9ed4-c98121bb5ef6.mp3?alt=media	B2	[Education] Avoid plagiarism in essays. | [Ethics] Check for plagiarism. | [Consequence] Punish plagiarism.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F2a52b0d6-037d-4e17-8781-bd824207ee1b.png?alt=media	The act of using someone elseâ€™s work or ideas without credit.	đạo văn	ˈpleɪdʒərɪzəm	plagiarism	\N	
572f5961-3b53-4595-8844-2fe7113f8a36	2025-10-10 18:49:49.17924	2025-10-17 19:06:50.299682	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1f366cfd-b68a-4498-982a-135e0156ef3b.mp3?alt=media	B1	[School] Record student attendance. | [Event] High attendance at the lecture. | [Policy] Require regular attendance.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F1f6ebe05-9969-4f6d-9206-d085df8cd847.jpg?alt=media	The act of being present at an event or place.	sự tham dự	əˈtendəns	attendance	\N	
1c671f9b-b271-4f02-8880-c9454060646a	2025-10-10 18:49:49.193314	2025-10-17 19:06:50.598615	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb77d05b7-9f4d-4346-a8f9-5fc591cd9fbc.mp3?alt=media	B2	[Career] Submit a resignation letter. | [Decision] Announce the resignation. | [Process] Handle resignation professionally.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F78a60d99-ff98-4590-b04b-9e2c25b18cea.jpg?alt=media	The act of voluntarily leaving a job or position.	từ chức	ˌrezɪɡˈneɪʃn	resignation	\N	
ce01825f-4a63-4b92-9ae5-875bff0c837d	2025-10-10 18:49:48.707436	2025-10-17 19:06:52.171346	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F68f66796-37ac-468d-b5bc-5318f86ec69e.mp3?alt=media	A2	[Sport] Cycling is a great way to explore the countryside. | [Fitness] He joined a cycling group to train for a marathon. | [Environment] Cycling to work helps reduce air pollution.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F180df758-fbb6-4b68-bd3f-52d89c8d2df6.jpg?alt=media	The activity of riding a bicycle for sport or exercise.	đạp xe	ˈsaɪklɪŋ	cycling	\N	
86d447fe-c5f1-4133-a60d-0256e9541b5f	2025-10-10 18:49:49.253355	2025-10-17 19:06:52.294917	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc50baa03-d359-499d-ab89-84e27566eed9.mp3?alt=media	B1	[Gym] Practice weightlifting routines. | [Strength] Build muscle with weightlifting. | [Competition] Enter weightlifting contests.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F421b2110-3955-4a52-b210-e036954832a8.jpg?alt=media	The sport of lifting heavy weights for exercise or competition.	nâng tạ	ˈweɪtlɪftɪŋ	weightlifting	\N	
cdeb3bc1-8258-45c9-ad8f-85dd7feb3a9f	2025-10-10 18:49:49.266272	2025-10-17 19:06:52.808649	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F742a8849-7d5c-488b-aefd-2b9a60599ff5.mp3?alt=media	C1	[Health] Undergo rehabilitation after injury. | [Program] Join a rehabilitation center. | [Process] Rehabilitation takes time.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F048e11b4-be3b-4efc-9763-13605d86bccb.jpg?alt=media	The process of restoring someone to health or normal life.	phục hồi chức năng	ˌriːhəˌbɪlɪˈteɪʃn	rehabilitation	\N	
5d5ca654-556c-4ae2-af29-f1c3af3314a1	2025-10-10 18:49:49.294036	2025-10-17 19:06:53.58184	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F695677bb-a4ff-48bc-b699-e041e37d10cd.mp3?alt=media	A1	[Beach] Catch crabs in rocks. | [Food] Eat crab meat. | [Walk] Crabs walk sideways.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fffc7161c-d9a4-40e4-8bfd-a97a64d89439.jpg?alt=media	A marine or terrestrial crustacean with a hard shell and pincers.	cua	kræb	crab	\N	
f95fa30c-31d8-45bf-ad42-d506cc4d55e1	2025-10-10 18:49:49.305677	2025-10-17 19:06:54.075688	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2551f034-7a7b-48f5-aaa2-542c380da77e.mp3?alt=media	B2	[Space] Asteroids are rocky bodies. | [Belt] Asteroid belt between planets. | [Impact] Asteroids hit Earth rarely.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Faa4a5435-897f-46f8-bfa4-6873ffea1f5b.jpg?alt=media	A small rocky body orbiting the sun, smaller than a planet.	tiểu hành tinh	ˈæstərɔɪd	asteroid	\N	
8a623eb6-5c61-43a5-8b89-a019a1beee6b	2025-10-10 18:49:49.312784	2025-10-17 19:06:54.663327	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F37776cab-6726-4c18-85fd-8b52dc25e59d.mp3?alt=media	B2	[Nature] Prevent soil erosion. | [Coast] Erosion shapes coastlines. | [Wind] Wind causes erosion.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fef064b1a-572f-4389-b3fe-c5f008b05a7f.jpg?alt=media	The process of wearing away land by wind, water, or ice.	xói mòn	ɪˈrəʊʒn	erosion	\N	
3868e67d-696e-4ab0-9280-063e05780ea9	2025-10-10 18:49:48.691868	2025-10-17 19:02:04.051536	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5424b38d-d0d0-4cdf-883b-f1aa963b8944.mp3?alt=media	A2	[Travel] She checked her passport before boarding the international flight. | [Security] The officer stamped the passport at the border. | [Preparation] Always keep your passport safe when traveling abroad.	\N	An official document for international travel.	hộ chiếu	ˈpæspɔːrt	passport	\N	
1ed89d76-8fca-4ebd-98a0-cfffedd9be11	2025-10-10 18:49:48.818843	2025-10-17 19:02:06.885928	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F96ec8a03-e74d-417c-a504-594f62773af6.mp3?alt=media	A1	[History] The castle was built in the 12th century by a king. | [Tourism] We explored the castle’s towers and dungeons on the tour. | [Story] The fairy tale was set in a magical castle.	\N	A large fortified building or group of buildings.	lâu đài	ˈkæsl	castle	\N	
6853f4b1-7c31-4774-8a09-5fc06de1a227	2025-10-10 18:49:49.038558	2025-10-17 19:02:11.902337	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd4ef1252-0e62-4c0e-a76b-f905dd5d1e31.mp3?alt=media	B2	[Finance] Conduct an annual audit. | [Business] Prepare for the external audit. | [Compliance] The audit revealed discrepancies.	\N	An official inspection of an organizationâ€™s accounts.	kiểm toán	ˈɔːdɪt	audit	\N	
32d891c0-f376-4c10-8f00-dd034b053b73	2025-10-10 18:49:49.191339	2025-10-17 19:06:50.308635	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4f8c4aa5-8a83-4abc-82ba-a96d9962a08d.mp3?alt=media	B1	[University] Live in the dormitory. | [Room] Share a dormitory room. | [Life] Experience dormitory life.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc429f502-efd4-4ca7-8e64-05e84220e96d.jpg?alt=media	A building where students live, typically at a school or university.	ký túc xá	dɔːˈmɪtəri	dormitory	\N	
5adcfd89-1152-4748-b626-90cab5b913b7	2025-10-10 18:49:49.229399	2025-10-17 19:06:51.493048	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd0224321-2950-40e9-94c6-8a585ce67500.mp3?alt=media	B2	[Road] Take a detour due to construction. | [Route] Follow the detour signs. | [Travel] The detour added time.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F5b957d18-fd63-4a4e-a16a-828b1ae749ca.jpg?alt=media	A route taken to avoid an obstacle or delay.	lối vòng	ˈdiːtʊə	detour	\N	
3b2d0654-1dbf-486c-b8fc-d9c2c5944b35	2025-10-10 18:49:49.258402	2025-10-17 19:06:52.406881	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F00e36470-2653-4c52-b403-2ac355f03429.mp3?alt=media	B2	[Exercise] Practice pilates for core strength. | [Class] Attend pilates sessions. | [Benefit] Pilates improves posture.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Ff51a6bec-944f-459c-8552-d5f480e17818.jpg?alt=media	A system of exercises to improve flexibility and core strength.	pilates	pɪˈlɑːtiːz	pilates	\N	
bd7e4d67-9971-4e60-9e18-a275b9ccd639	2025-10-10 18:49:49.276557	2025-10-17 19:06:52.971458	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F50597e79-19f8-4a15-94e5-2f3c1295cd99.mp3?alt=media	A1	[Animal] Koalas sleep in trees. | [Australia] Koalas eat eucalyptus leaves. | [Cute] Koalas look cuddly.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F22edd9ba-612c-402f-9866-07946620aa61.jpg?alt=media	A marsupial native to Australia that lives in eucalyptus trees.	gấu koala	kəʊˈɑːlə	koala	\N	
\.


--
-- Data for Name: vocab_packages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vocab_packages (package_id, vocab_id) FROM stdin;
\.


--
-- Data for Name: vocab_topics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vocab_topics (vocab_id, topic_id) FROM stdin;
58b7563c-e5d6-4247-b3e7-af5b988f0fe1	1
58b7563c-e5d6-4247-b3e7-af5b988f0fe1	2
5f686bca-6f57-4565-b363-ff65dfda2c20	1
5f686bca-6f57-4565-b363-ff65dfda2c20	2
bf58df5a-d024-4b7a-b4e4-0b6e07c5692c	1
bf58df5a-d024-4b7a-b4e4-0b6e07c5692c	2
c97b145b-085f-4f27-a01a-b0601bcd2e2c	1
c97b145b-085f-4f27-a01a-b0601bcd2e2c	2
87d4927c-4a8f-48d9-93e3-71e8a35e0770	1
87d4927c-4a8f-48d9-93e3-71e8a35e0770	2
5e53247f-dc44-425e-b70b-fce4cf245048	1
5e53247f-dc44-425e-b70b-fce4cf245048	2
34c7d346-eac6-43ef-9b8d-847b8066fe56	1
34c7d346-eac6-43ef-9b8d-847b8066fe56	2
1f4716d3-0144-486c-82aa-6495c04a6799	1
1f4716d3-0144-486c-82aa-6495c04a6799	2
e206b6cc-471c-4a64-a87c-df46ea12e232	1
e206b6cc-471c-4a64-a87c-df46ea12e232	2
64edc678-01c8-4291-9fd0-efd330d6dead	2
64edc678-01c8-4291-9fd0-efd330d6dead	1
e2510cb1-8178-42de-904b-5e2cdc3680b5	44
e2510cb1-8178-42de-904b-5e2cdc3680b5	45
af1fa1c5-5267-4719-b4fa-408685ad52a9	44
af1fa1c5-5267-4719-b4fa-408685ad52a9	45
35e482f6-8fdf-4107-be24-7a13fc9ab4ea	45
35e482f6-8fdf-4107-be24-7a13fc9ab4ea	44
fb618efb-dd79-4c8a-a01d-704ea630b694	44
fb618efb-dd79-4c8a-a01d-704ea630b694	45
4316bf87-bd18-41f3-a620-9d8c441e27d8	45
4316bf87-bd18-41f3-a620-9d8c441e27d8	44
24339e86-67f9-408e-b3a3-166c182d6518	44
24339e86-67f9-408e-b3a3-166c182d6518	45
ad763e27-5b69-4861-96a5-a42a9dbce021	45
ad763e27-5b69-4861-96a5-a42a9dbce021	44
08e548ce-597a-4436-9dd4-a57170647d66	44
08e548ce-597a-4436-9dd4-a57170647d66	45
28b70b3d-16a6-497f-8498-216a7d343bd9	44
28b70b3d-16a6-497f-8498-216a7d343bd9	45
0e2ef3c3-c24d-411b-b1f6-50ce0a0b0b93	44
0e2ef3c3-c24d-411b-b1f6-50ce0a0b0b93	45
037af387-d58d-4ebd-8a60-6c503ac5aedf	47
037af387-d58d-4ebd-8a60-6c503ac5aedf	46
86b7b2f4-5b79-4989-b5a8-4aa896601498	46
86b7b2f4-5b79-4989-b5a8-4aa896601498	47
0059b1b9-2bf4-4db9-8872-cdba778a7c4a	47
0059b1b9-2bf4-4db9-8872-cdba778a7c4a	46
e45bd462-9ee0-40a0-9f6a-41f174e03d81	46
e45bd462-9ee0-40a0-9f6a-41f174e03d81	47
41bcd0ee-915b-46d3-90e9-c1285d1bceee	46
41bcd0ee-915b-46d3-90e9-c1285d1bceee	47
6a11f8f5-fe19-4755-a962-bb5a0c345945	47
6a11f8f5-fe19-4755-a962-bb5a0c345945	46
1fe3a9a6-f87e-432a-8d18-461941881e3e	47
1fe3a9a6-f87e-432a-8d18-461941881e3e	46
8658c8fa-0c19-420e-8b9f-8a70c1c09db0	46
8658c8fa-0c19-420e-8b9f-8a70c1c09db0	47
aee63a03-282c-4783-9659-7c4e58729e08	47
aee63a03-282c-4783-9659-7c4e58729e08	46
45caabd5-5ec7-4b41-b3cc-d43bc4047d8b	47
45caabd5-5ec7-4b41-b3cc-d43bc4047d8b	46
f1900639-c9bb-47a9-a4df-8997fea9ae8a	49
f1900639-c9bb-47a9-a4df-8997fea9ae8a	48
21a1882b-4e95-4e7f-8ec6-df31df1b25d4	48
21a1882b-4e95-4e7f-8ec6-df31df1b25d4	49
17ebbd48-d223-4e40-a8ff-3b30bb4d0eb6	48
17ebbd48-d223-4e40-a8ff-3b30bb4d0eb6	49
7938c7b3-6a81-4fcd-844d-ede72c3e5182	49
7938c7b3-6a81-4fcd-844d-ede72c3e5182	48
cc06f961-f972-48ff-9821-cf763ff6dd6f	48
cc06f961-f972-48ff-9821-cf763ff6dd6f	49
d9d403ee-cf64-424c-8e60-a14567b6c266	48
d9d403ee-cf64-424c-8e60-a14567b6c266	49
af19b21f-2ba9-4f1a-b46f-4ed316273510	49
af19b21f-2ba9-4f1a-b46f-4ed316273510	48
97fa16a3-6483-4a5f-99f1-2c0fdc612769	49
97fa16a3-6483-4a5f-99f1-2c0fdc612769	48
5cc1da45-ca89-4c72-90d5-60c30b2cfaef	49
5cc1da45-ca89-4c72-90d5-60c30b2cfaef	48
e38ad6ce-f5dd-47a6-be59-913ece323015	48
e38ad6ce-f5dd-47a6-be59-913ece323015	49
185f8b7b-750b-457a-aba8-27a14eaaed1a	51
185f8b7b-750b-457a-aba8-27a14eaaed1a	50
47c922c7-2b04-4aa4-93f3-c18f6eea74d5	50
47c922c7-2b04-4aa4-93f3-c18f6eea74d5	51
e829d14c-9a3b-4c71-9e6d-3c52df6e291b	51
e829d14c-9a3b-4c71-9e6d-3c52df6e291b	50
f33f8d0d-d2be-4096-ac65-dc876229a7d4	51
f33f8d0d-d2be-4096-ac65-dc876229a7d4	50
088b3bc1-3254-4f71-a22f-fdec555a2f68	50
088b3bc1-3254-4f71-a22f-fdec555a2f68	51
39a9c680-00ff-46cb-b6b4-87fc66554a58	50
39a9c680-00ff-46cb-b6b4-87fc66554a58	51
b910d755-212e-433e-8f32-8902f9af58e2	50
b910d755-212e-433e-8f32-8902f9af58e2	51
5f6d0f07-e66d-443d-80d4-a3a4125970ee	51
5f6d0f07-e66d-443d-80d4-a3a4125970ee	50
b2bd866b-a85a-4222-8646-6284d014b3e5	50
b2bd866b-a85a-4222-8646-6284d014b3e5	51
31713db1-5f9e-4172-bfe9-30e0f1f44f54	51
31713db1-5f9e-4172-bfe9-30e0f1f44f54	50
3268aad5-b1e6-4c23-b261-743a30b40232	52
3268aad5-b1e6-4c23-b261-743a30b40232	53
1e8ae068-1f58-455c-ac7a-c697a8188e43	52
1e8ae068-1f58-455c-ac7a-c697a8188e43	53
d0b068e5-3c67-427d-b572-b50190b87f3a	52
d0b068e5-3c67-427d-b572-b50190b87f3a	53
4d25d71c-b640-47f3-bd18-79d18f647af4	52
4d25d71c-b640-47f3-bd18-79d18f647af4	53
543e1a08-a254-4834-a3da-53209b0ac86f	52
543e1a08-a254-4834-a3da-53209b0ac86f	53
5d7bb7be-a862-4ee1-9206-ba4ab7383d4e	53
5d7bb7be-a862-4ee1-9206-ba4ab7383d4e	52
0e199588-ffb8-459e-a9ba-e925afde0484	52
0e199588-ffb8-459e-a9ba-e925afde0484	53
63ff7a9b-0fc5-4843-a9e2-a91d008352ad	52
63ff7a9b-0fc5-4843-a9e2-a91d008352ad	53
cc7a67ed-c412-463b-b1ae-ec999ebfd541	52
cc7a67ed-c412-463b-b1ae-ec999ebfd541	53
590302b0-026c-421a-9d7f-0428ccf29f73	53
590302b0-026c-421a-9d7f-0428ccf29f73	52
ab7b7066-6c3b-40ff-8231-1274cd87b060	54
e0e43a0e-4abf-4437-986d-368d8e6d24b9	54
4bfc41a7-c669-4147-932d-da637599141c	54
47c4f2d3-2a46-4f95-b994-8764c92410fa	54
64cb0d69-d84e-43a4-87d1-6e3b9c888c24	54
9f281d66-8f92-409d-ba4f-279ff217567e	54
2c8db310-fe7d-4a62-9ff8-6140759f109f	54
d539284f-c0ba-4a2b-997c-b292b9d86827	54
3a93694e-ce24-4f35-95b3-37dd5fde7689	54
fdc1979e-e28d-4904-9ebc-6e22ba6e4f1e	54
0c5b29fe-04ce-417d-9c4e-1419b948bcda	55
68706170-5a79-49be-9371-f0650fd14601	55
63fd5fd0-dd1c-4bcc-83e0-200ea0337a2d	55
4c5c09be-4268-450d-87f8-af21a4dec46f	55
a60badcc-3af7-466b-bbd0-378eb3e6f0e4	55
7a1f7fc7-6ec6-4d21-b2d6-49e160d4b0f2	55
cf3ebbbd-6a07-4e8d-bf54-9cfaad027461	55
38fc3d91-6588-4459-9b7d-94f4788282c2	55
6d247664-56b0-4e34-b36f-e8086e06ce4a	55
227cf445-3087-4c52-adc9-c62c007738bb	55
dad42817-a33a-414c-8aaa-1d5279a12b10	56
13dae049-f118-467a-a92d-8bb8d60972d9	56
efa6819a-3158-4e1d-9539-464864424900	56
24b57e8e-7f33-4c2e-9538-460412a1e1ea	56
62ed2bc7-e0cd-43c1-8431-7edf99a7c9d0	56
be5b2186-183b-49c2-8cea-faa78967c64d	56
904d53ad-38f6-4ded-bc45-2ed4cc4e8c97	56
c1dbd43d-5bb6-4a8f-b430-8ae2e1016f81	56
54f20198-84f9-4d33-bf14-f3e0b2f4f75f	56
541f631f-fb45-4013-90df-deb45a6d6189	56
62295023-3013-4628-aeb9-53af85fd8102	57
a78755cd-da4c-49f0-ad26-4c8f2013ed67	57
9bb8f157-d9bd-4516-a9fc-a9b76a1b0d83	57
1a798fd3-45ab-44ac-9759-16cfbc3fc7af	57
bc103d34-24b7-4106-9cc3-c4e1bd851a4f	57
4711f64a-1c24-48de-bb09-216106a92dc7	57
98719bee-acca-40c5-bf37-d8d95801d074	57
b60705ea-abc9-42e2-af58-801b061579cf	57
e056c667-b697-467a-863f-51d6670df651	57
1e4e851f-baff-4b7e-8cf6-2c8044b471dd	57
180edcd4-46ac-4d9d-a395-cc82d8b847c4	58
9bb3aae0-7450-4779-8fcd-8477dfa4d33a	58
17e58498-23d2-4fe3-880d-a80dcdc6be39	58
c059b61d-5ec8-42b3-af2f-30fbe7adf207	58
ebabbc8b-d4fb-401a-90cb-40d0ff2faeed	58
90c6eae9-2edc-4d7a-a04b-2d84343fafc5	58
059d371d-b0c8-4060-8ae6-a35d289aec63	58
63096843-6c2a-435d-aeb3-75415a0d0766	58
76582247-c5d7-4467-8b52-b66e2c15e3d3	58
273db95f-caaa-484b-9271-7ccf824c2e0a	58
10637f29-3d56-4637-843a-355963309f19	59
4306447e-ec18-48b2-9955-c38e9bf44fbf	59
60828f58-fa9f-4dd6-876f-0dad07f38002	59
d6848be3-b8b9-446d-aa9b-f5985d7bf899	59
46e463c6-f993-4ac0-b822-9328d57c2892	59
810662d1-ab8a-4663-8fc3-c931b10dd6b8	59
c64e91ed-a4de-40f0-ae4d-4dba3a15eab3	59
1ba6bb83-98fb-42ee-8f10-0b066d90371b	59
2c722a1d-95bf-4b90-b036-88c8ed8c8f08	59
c3c35ad5-d432-4a36-8c20-62a9a77a859a	59
ac1aa8ce-cf62-4613-a929-bb4b737bae8d	60
af0916df-4290-42a5-a159-9daba0868084	60
b6965dbd-2a87-43da-ab75-de3ec685c3eb	60
7ab926a2-46d5-4910-b7c0-35802e5a1579	60
34ab08ee-acec-4875-b03d-d769da7491e9	60
0266836a-bd98-40c6-9812-1c7aa269e3bb	60
db0d32e4-0922-4be7-b020-199e06c32f55	60
32700459-168d-4e22-9490-9606926dceab	60
0de79a43-2db1-4f7b-ae50-bd3a445fa872	60
33c061fc-5aa8-4869-bd42-e2c471469370	60
7f410a5d-03f1-49ec-80a4-4bc282657f0f	61
584b2697-a8eb-4de3-b3e6-1ade63945494	61
96a15691-80a1-4234-b7f3-d5e44bb9b2c0	61
13132532-c0e1-4a61-98bf-4e1fb2d66568	61
9fcc8998-5a6d-4705-8508-e005d798d63c	61
56b81922-f7e4-42cb-9b0a-89dfc0c3183f	61
cc86bab1-f9f1-47db-8369-c4252922df7b	61
161f6154-c084-4898-890a-015b39eb42e1	61
7a26dcad-4d50-4b0c-8c53-a23166043658	61
462d68a3-1e44-4b18-a7ae-d4b119c745dd	61
2aa891f9-8a1e-4135-8d0f-16134dcc1c87	62
8b86e29d-2e02-4d4c-8c9a-b89a73f15b64	62
273c68a5-4801-4dad-8f0b-4b128fe33bcf	62
ca06b295-05a8-42b9-9bc9-ef6f8e148156	62
a5502a23-407e-45e9-9488-719cda6d3b1f	62
84293344-9a6b-4082-9659-2a6472e328b9	62
04f1818e-646d-4510-8b6e-1c1c93ce80fb	62
bdc7adbb-b50a-4359-9892-fa9a136391fc	62
e183362d-287f-400f-8087-68866e47fa1c	62
a569b63c-2bda-418c-8188-0b4b01fd2bd3	62
61d8a4ff-e4a7-42af-8d1d-d902b4884d4a	63
a10bc160-2171-40df-aa82-b5e6e9b2fae1	63
474debf2-4c1f-4fc0-b9c7-4140b63e95ef	63
3125e20a-d165-4aff-9d55-b02ceaf9bd91	63
6abad213-f06c-43d5-953e-64ec4864f26d	63
62ff4cf0-b5f0-4152-b1b7-cbb439602a69	63
68cc9749-b93e-4a9a-8b32-af3da0242308	63
2c7ce3cd-a77f-4ea1-a778-9a0019a63f8d	63
2f1c2f81-61d8-4841-ab92-895ede3a12e3	63
90ffaeef-fac6-48c3-b6bd-765e8d0df1b8	63
cf83d4b4-ca5c-46d5-b577-8d8775d4f59c	65
cf83d4b4-ca5c-46d5-b577-8d8775d4f59c	64
b8adc413-e1ea-4cbc-bf3a-de5e54422c68	65
b8adc413-e1ea-4cbc-bf3a-de5e54422c68	64
a10ca209-b213-4931-9db3-39353bf1fc67	65
a10ca209-b213-4931-9db3-39353bf1fc67	64
90704d3a-6c4f-41ca-b5bd-eb25cf8e0350	65
90704d3a-6c4f-41ca-b5bd-eb25cf8e0350	64
f58dc7ab-3f9e-4ffc-a470-ebf4b60a5ff6	65
f58dc7ab-3f9e-4ffc-a470-ebf4b60a5ff6	64
5f237721-d474-496a-aaef-af413c73ab94	64
5f237721-d474-496a-aaef-af413c73ab94	65
f5ec30f6-38a1-4572-a63a-dea823c185ce	64
f5ec30f6-38a1-4572-a63a-dea823c185ce	65
6df073a8-a7c0-4d79-b152-e0567e028d9a	65
6df073a8-a7c0-4d79-b152-e0567e028d9a	64
6382cd6d-4be7-4ac6-9140-6f46e5405e5d	64
6382cd6d-4be7-4ac6-9140-6f46e5405e5d	65
0eb4799c-5fdf-464f-b9af-34116cec97c6	65
0eb4799c-5fdf-464f-b9af-34116cec97c6	64
c8032d80-c17d-4a7c-a688-2a82a89ddb6c	66
79c2cefe-1534-4d67-b950-2ab12955d037	66
3a8e1d14-2947-4e93-ad35-8d525d76e4fd	66
288e3a41-7e33-461f-b39a-c6457ff0ad71	66
b075ba8c-e91f-44df-8fc3-4eb47574ab59	66
f780f3e1-e7a3-4c96-b73d-91eab2aecbf1	66
212124d0-0491-4206-be63-75754545e091	66
326b2934-6132-4ed3-8b20-778906803704	66
61b3d15a-1dcf-4400-b540-02557e12d026	66
901ba8aa-4629-45ed-87d3-73d57e83aa47	66
9ad54faf-3409-4d21-9d52-50851425e208	68
9ad54faf-3409-4d21-9d52-50851425e208	67
8ef50ef0-a0cd-466a-8577-5ee6542c27ef	67
8ef50ef0-a0cd-466a-8577-5ee6542c27ef	68
6f5f1fd3-7541-4562-97ea-a0f0b8c1aff8	68
6f5f1fd3-7541-4562-97ea-a0f0b8c1aff8	67
f76e999a-d0df-41fd-937f-a358d6270c6f	68
f76e999a-d0df-41fd-937f-a358d6270c6f	67
5e189710-8a5e-4a07-8cda-05086ae5157f	68
5e189710-8a5e-4a07-8cda-05086ae5157f	67
d231736a-7bc7-41d0-943f-9c88cdb554f7	67
d231736a-7bc7-41d0-943f-9c88cdb554f7	68
2fb0f237-15ad-4c43-8ade-b1128757f072	67
2fb0f237-15ad-4c43-8ade-b1128757f072	68
a8bd4319-92ec-4e5b-bf4b-862e425b0e5f	68
a8bd4319-92ec-4e5b-bf4b-862e425b0e5f	67
4b2680dc-8759-416a-8050-47f32e083b5b	67
4b2680dc-8759-416a-8050-47f32e083b5b	68
1b777676-18be-4f3a-865e-d0e4cc8355d4	68
1b777676-18be-4f3a-865e-d0e4cc8355d4	67
70be0f81-0376-4d3f-9015-ab7b33ea0f87	69
70be0f81-0376-4d3f-9015-ab7b33ea0f87	70
08984518-6f1e-46ca-b124-7f49fdc31320	70
08984518-6f1e-46ca-b124-7f49fdc31320	69
b0c08b44-ef53-4899-b184-636cc140d033	69
b0c08b44-ef53-4899-b184-636cc140d033	70
04b36d23-8503-450f-a502-a36c8d1e7404	70
04b36d23-8503-450f-a502-a36c8d1e7404	69
7c3aaa5c-42b5-4d70-88b2-3aa93a10ca81	69
7c3aaa5c-42b5-4d70-88b2-3aa93a10ca81	70
aaf4fd01-bd53-4bba-8a6d-bce8c1bb6d8d	70
aaf4fd01-bd53-4bba-8a6d-bce8c1bb6d8d	69
e0b2d1f6-d455-4a8d-a281-e8a96f1a0e7a	70
e0b2d1f6-d455-4a8d-a281-e8a96f1a0e7a	69
a81f2eb3-0178-4f9b-ac91-b2b8f97fc118	69
a81f2eb3-0178-4f9b-ac91-b2b8f97fc118	70
b1a974e2-9a37-40b3-b1db-7dec651fa698	69
b1a974e2-9a37-40b3-b1db-7dec651fa698	70
d9e06405-62d0-42e8-9585-e57adf1cf7bd	70
d9e06405-62d0-42e8-9585-e57adf1cf7bd	69
e59b1c30-7f29-4932-8d6a-06925d737687	2
e59b1c30-7f29-4932-8d6a-06925d737687	1
ab34318d-5656-4705-b2cf-187a06375d27	2
ab34318d-5656-4705-b2cf-187a06375d27	1
2db7a213-5b39-480e-bff3-a73026219d51	1
2db7a213-5b39-480e-bff3-a73026219d51	2
a60f3ccb-35ce-44d3-a5fd-0d3ca2e96cb0	2
a60f3ccb-35ce-44d3-a5fd-0d3ca2e96cb0	1
fa7e5492-bc6c-409a-b01c-ba70f265dfc9	1
fa7e5492-bc6c-409a-b01c-ba70f265dfc9	2
1a51ba3c-0209-4bc0-a5bb-d3ca4524cf12	1
1a51ba3c-0209-4bc0-a5bb-d3ca4524cf12	2
e924ee87-6cc9-4f94-af4a-98bf9a3da519	2
e924ee87-6cc9-4f94-af4a-98bf9a3da519	1
2438686e-3383-4faf-9910-381bf478bf51	2
2438686e-3383-4faf-9910-381bf478bf51	1
89680f43-6a58-4b4f-8e1d-e3c87244472e	1
89680f43-6a58-4b4f-8e1d-e3c87244472e	2
0c08794c-62d4-474b-99d9-deeda83be44c	2
0c08794c-62d4-474b-99d9-deeda83be44c	1
c2fb73eb-bd37-46ce-aacb-061882fa4013	44
c2fb73eb-bd37-46ce-aacb-061882fa4013	45
138914c1-ff61-4a63-9262-c9b6ed9df6e9	45
138914c1-ff61-4a63-9262-c9b6ed9df6e9	44
aae75efe-ecd1-492b-bbf9-45d50dbc4adb	45
aae75efe-ecd1-492b-bbf9-45d50dbc4adb	44
0a667169-c8a6-4cbb-9ffa-49679555a257	45
0a667169-c8a6-4cbb-9ffa-49679555a257	44
cad5490c-fb56-47d6-b305-0a405feac0a0	44
cad5490c-fb56-47d6-b305-0a405feac0a0	45
a2a19947-1fb0-41b5-9cbb-24e178d26943	45
a2a19947-1fb0-41b5-9cbb-24e178d26943	44
6f7fec37-6d4a-41b0-9daf-c238b27d90db	44
6f7fec37-6d4a-41b0-9daf-c238b27d90db	45
43e39897-4db3-4150-9017-5a979ae0df8e	45
43e39897-4db3-4150-9017-5a979ae0df8e	44
77f37be5-480e-49ea-90fc-d001d2147393	44
77f37be5-480e-49ea-90fc-d001d2147393	45
0d9ac936-4341-4d40-ac94-6230317134bf	46
0d9ac936-4341-4d40-ac94-6230317134bf	47
5dcd8440-97d5-4b1e-963e-4579cc6a9321	47
5dcd8440-97d5-4b1e-963e-4579cc6a9321	46
2d98770e-3968-47a0-b0fe-4d8ca2fcd820	46
2d98770e-3968-47a0-b0fe-4d8ca2fcd820	47
d458076a-8a88-40a5-8178-0fece3760843	47
d458076a-8a88-40a5-8178-0fece3760843	46
a9abecfe-4806-4102-bc45-0ef517592ace	47
a9abecfe-4806-4102-bc45-0ef517592ace	46
a7019348-f7e2-4048-9bf3-a03074d9cfd4	47
a7019348-f7e2-4048-9bf3-a03074d9cfd4	46
596c8b71-cfb5-4138-9a9f-c0ee6736e313	46
596c8b71-cfb5-4138-9a9f-c0ee6736e313	47
3b2ec59a-d3bf-450f-90f9-45729add3d26	46
3b2ec59a-d3bf-450f-90f9-45729add3d26	47
754ee5d5-00ef-4687-946b-7663e0fd8892	46
754ee5d5-00ef-4687-946b-7663e0fd8892	47
aa4e84d7-1079-435d-a496-9a698793cbcd	46
aa4e84d7-1079-435d-a496-9a698793cbcd	47
679609ac-0041-4c59-a34d-89272baf43f4	48
679609ac-0041-4c59-a34d-89272baf43f4	49
90b4aafd-5b1e-46be-92cd-75637aa0cb88	48
90b4aafd-5b1e-46be-92cd-75637aa0cb88	49
5683217c-29d0-436a-bdb4-de2f8f19a598	48
5683217c-29d0-436a-bdb4-de2f8f19a598	49
549b62b0-9c23-47f1-8187-ac64854ed3a2	48
549b62b0-9c23-47f1-8187-ac64854ed3a2	49
2d53adf8-5c8d-405f-bc04-ac98f774de6a	48
2d53adf8-5c8d-405f-bc04-ac98f774de6a	49
58ea3eb3-47fb-4e94-86a1-5dd1eca3a71b	48
58ea3eb3-47fb-4e94-86a1-5dd1eca3a71b	49
4b14fc39-8e56-4aed-b694-8b5fb3d31ada	48
4b14fc39-8e56-4aed-b694-8b5fb3d31ada	49
c31f10a1-91ce-49f8-bd19-a4f64d244465	49
c31f10a1-91ce-49f8-bd19-a4f64d244465	48
6518db6d-b5c5-44ee-9364-49d202b9106f	49
6518db6d-b5c5-44ee-9364-49d202b9106f	48
c65b6c05-39d5-4115-b135-ed4cd4799c31	48
c65b6c05-39d5-4115-b135-ed4cd4799c31	49
e7511db6-6161-44f1-884d-b9eee2401726	51
e7511db6-6161-44f1-884d-b9eee2401726	50
67fd00f3-6393-41e4-87ff-1cfb55ae1ad7	50
67fd00f3-6393-41e4-87ff-1cfb55ae1ad7	51
ded24a41-25fa-4a77-853e-0ad89a541afd	51
ded24a41-25fa-4a77-853e-0ad89a541afd	50
381f11dc-9efe-47cd-8117-6cb02b725f23	51
381f11dc-9efe-47cd-8117-6cb02b725f23	50
27ea2502-0665-4013-9239-146eb6222757	51
27ea2502-0665-4013-9239-146eb6222757	50
ee7cb0a6-2f47-4f1d-bfdb-f3571739cb31	50
ee7cb0a6-2f47-4f1d-bfdb-f3571739cb31	51
ee6e9102-f858-4984-9a4d-f5da69aecc1f	51
ee6e9102-f858-4984-9a4d-f5da69aecc1f	50
3868e67d-696e-4ab0-9280-063e05780ea9	50
3868e67d-696e-4ab0-9280-063e05780ea9	51
efee7125-5017-4626-81c8-ae53ce375fbe	50
efee7125-5017-4626-81c8-ae53ce375fbe	51
1fe7d6fd-6f7e-49cc-bae1-6e4a2e20de14	50
1fe7d6fd-6f7e-49cc-bae1-6e4a2e20de14	51
bbd04f28-8621-4bc2-9a4c-db7250d24323	52
bbd04f28-8621-4bc2-9a4c-db7250d24323	53
a0056831-6ce7-4cbe-9842-538510e22800	53
a0056831-6ce7-4cbe-9842-538510e22800	52
ce01825f-4a63-4b92-9ae5-875bff0c837d	53
ce01825f-4a63-4b92-9ae5-875bff0c837d	52
cf83d964-cb5c-4bee-a213-3b2f83ed453c	53
cf83d964-cb5c-4bee-a213-3b2f83ed453c	52
76c82257-9299-4830-99ad-03131a692695	53
76c82257-9299-4830-99ad-03131a692695	52
453d983a-41e1-4534-9d22-bec95353736f	53
453d983a-41e1-4534-9d22-bec95353736f	52
c5b8311e-6bdc-4f94-a159-367aae082058	52
c5b8311e-6bdc-4f94-a159-367aae082058	53
45bb9ead-c0ae-4291-8efd-7dc5275f0ef5	53
45bb9ead-c0ae-4291-8efd-7dc5275f0ef5	52
521c44c1-5d36-400f-9c5e-a23439050a90	52
521c44c1-5d36-400f-9c5e-a23439050a90	53
e6d116d8-17b8-4c87-b92f-6954e807eee0	53
e6d116d8-17b8-4c87-b92f-6954e807eee0	52
46d0d450-8fec-40f9-b771-f98ac72cb218	54
5cef2d1c-b47b-4fdb-ac52-b372971e5ef5	54
7afeac1c-2f17-4f41-a90e-6bb7be3d36ba	54
4d4d6cbc-62ad-4708-b42b-30f05720f05f	54
7c47c8b6-bb6c-41fb-b1a9-cfc5476ccf99	54
3a96ac6b-dcd1-4a7b-b5f8-2d958d5539a3	54
4df08286-0192-4aeb-9c5b-b4f4461d8fce	54
eaa0cb57-a623-4a1c-955d-81a9ffa7be03	54
5be08d51-c68c-4b3f-b3c2-61fcf5cb43ff	54
11e6e1bc-d34d-4d5c-9466-3116eaf0ed3b	54
8321ffad-fe48-4827-a523-c3989dd0675a	55
375c06f1-20f6-4585-b7a5-dae14cd23213	55
3df97d03-9562-4ebf-93de-720e5b3338ab	55
9d16b245-249d-4709-ad6c-e283bf2be619	55
a9d78901-672d-43da-b728-978e84567cfa	55
f60b50e1-ab40-4fa2-b4b0-015adfa3f792	55
c06ba2f7-8fbe-4309-b0f6-07707ed5000d	55
d5ce75e4-585e-498a-8107-7e4e82d9bafa	55
d81f6146-8d68-46f5-98f8-4ff4baa78290	55
69137dbd-5ef0-48bc-a37c-6cbcf5d84e90	55
ebc3298b-25d3-4f4c-ae2a-338ae140bda3	56
32ed7fa5-a6f1-4c43-b8c9-b9bf09a96428	56
a832de10-033d-4e22-b602-a57f9710b473	56
4df4ab6e-6bf8-4f15-8ed2-923986f015a9	56
864b2621-cba0-4a18-bc39-f973b5dd5c41	56
88aa9c3c-c3c4-42db-97b6-f1358cac803e	56
7660ae0e-2fff-43bc-bfd9-038645f48bf8	56
02b950ae-fee7-4c39-81b7-93f9336dca9b	56
1239a73e-f141-40a0-8ac5-a6dbd8908045	56
b5d6adfb-303b-4325-9a17-a9d895a7f053	56
7ed4a483-9581-44ad-bd90-a7d2caf72b91	57
010f277b-490d-4e11-9b6e-600b6a00a66f	57
fc12e2dc-912f-47ec-9a50-7cccced58cc7	57
629ec111-04a6-4f04-8f25-8c0d658e96af	57
efaa5ce0-8ad2-416e-8b49-a7ba7e67f208	57
320c8f1f-aaf1-442d-831e-5dc89a5aa054	57
b1b74240-e55e-4ca1-a0e2-29067fb389bd	57
1ed89d76-8fca-4ebd-98a0-cfffedd9be11	57
d2fc65c0-52d8-4a3b-8dbf-341c034bd590	57
ac8861be-cc76-4bc2-bfdf-7c93caebe90e	58
b357fa38-d1a4-4613-947f-7be8675bb591	58
ee582b94-430d-417a-88c5-35f0de227e58	58
befcbc13-db42-49a5-b394-6560b60e51fd	58
3654ddcf-0c85-4761-8a9b-1265ee1b2bde	58
4940bc8c-1d3b-4a10-bd75-41047fd455e7	58
94f51b7d-163c-44c0-889c-0240e935c91a	58
c8eca88f-9ba5-4f94-ac82-3883105102cf	58
1396744e-d891-401f-b5dd-3d052b8f6f96	58
de7126d7-9d89-4284-b656-7f6002208558	59
51dc45ef-a0aa-4ac5-a6e4-b8a119602f78	59
64758780-d379-4991-8aa1-006bb062174d	59
01254977-2ebe-4447-8492-4573a307005e	59
e0ef842f-849d-440f-a4a3-080227c89e93	59
fa51392c-9410-405d-abfb-f599c693ea4a	59
26193f2b-c221-41a6-b94b-74b3106c0fcc	59
49d132ec-1046-4178-9ab3-7501fc7c0944	59
9372cf72-5cc2-4625-8146-264a328406a8	59
1fb1fabe-3e03-4228-8aec-442da4065036	60
6d4e0c8b-22b1-4078-bfbb-c42a47bdb1c2	60
42cc50bf-4d06-4e8f-93ad-a61d4da50614	60
bcdf2be9-16bb-43b7-857e-37e6d928e28a	60
50673261-9279-4b72-a146-0c31fe5300b6	60
f022eed0-6488-4618-95db-c50d6a8bb51b	60
e5ccf03c-5424-49a0-b6ec-54554ba1d4f9	60
7f57664a-79ef-4a88-8a99-31810d16ef69	60
af76284a-289f-49f3-a760-be152bed0502	60
85dd49fd-5be8-48c1-a1e8-b8c39c57084b	60
3c716cec-8f3f-4543-9173-8b3ea1ba82df	61
d586c332-67a3-4adc-934b-72dc74decff1	61
bc376700-8217-4a83-814d-0efdce5baa76	61
f3156f0a-6d2b-4a22-92a3-c866a8dcf605	61
a8aeb122-ebbd-4727-b626-50e834153873	61
3d376050-92e3-47a2-a71a-cc6e7e2a9a13	61
b635d05f-ad6f-4f3b-9d02-52364677205d	61
9653310a-5c16-461d-a2dc-492a24677edd	61
b9cc41e6-a4f3-4f01-bf1a-fa79b648322a	62
be2348e6-27d5-4e93-9550-0bb136793d02	62
548f2700-27d5-49e2-9e0a-7e50d34c18f0	62
8e7c4101-4ecc-43b2-91cd-5f0692c3409d	62
ed78c44e-d82b-4398-b96d-106cdc54eb3d	62
10109c3c-1c8b-436d-8ea5-d81adc6e3cb8	62
3994ab27-f60a-40dc-863b-d343e2a436e4	62
6dccae02-79fb-4b5c-8bab-8582455b9ece	62
8b91ab1f-312a-4dac-9929-6667fc418a0f	63
63382b7c-03cc-40cd-9133-9152b2c3346a	63
f9860988-56b5-4f41-90db-ca52b721c304	63
6d67c37d-d0eb-44cc-8bd3-5d3583c45928	63
62c3bcd6-606d-4458-b37a-f582609fdeb3	63
df8806e4-e4a5-4aca-a100-94b0320c50ca	63
75df9462-3698-4f0f-8df3-4c7f07776958	63
86605566-91b4-4bdc-99c1-0ea26ea26933	63
f177ca54-42da-46a8-967d-dded3256f62b	63
f75cd964-753f-4a5c-9d20-a096e09d6893	63
daa5c1a0-0ea7-4bec-8cf8-9bb8408aa3aa	65
daa5c1a0-0ea7-4bec-8cf8-9bb8408aa3aa	64
4f0cd45e-dae5-4f37-a3b3-87685c307783	65
4f0cd45e-dae5-4f37-a3b3-87685c307783	64
c2791686-8b0a-47c8-a65a-533b68d15222	64
c2791686-8b0a-47c8-a65a-533b68d15222	65
119d919a-dd6c-4eec-a0b0-c7280e98a639	65
119d919a-dd6c-4eec-a0b0-c7280e98a639	64
6c33d855-a64a-4585-bf42-be988826d0b1	64
6c33d855-a64a-4585-bf42-be988826d0b1	65
4bec0ceb-af9b-4fd6-ab28-35477e65ac21	65
4bec0ceb-af9b-4fd6-ab28-35477e65ac21	64
7850bc93-7891-4814-8917-57af1f272e90	64
7850bc93-7891-4814-8917-57af1f272e90	65
b528b374-eb09-4336-b06e-5ea9271fd390	65
b528b374-eb09-4336-b06e-5ea9271fd390	64
b010b77b-a49e-4fb3-862f-c15588e849ff	64
b010b77b-a49e-4fb3-862f-c15588e849ff	65
6d54d5dd-ba47-450b-80e0-6f4e3d068b89	64
6d54d5dd-ba47-450b-80e0-6f4e3d068b89	65
4e21806d-bae8-4993-9690-9c9456510ddb	64
4e21806d-bae8-4993-9690-9c9456510ddb	65
a65685bd-5de1-41a1-9eb1-ec758057d9b1	65
a65685bd-5de1-41a1-9eb1-ec758057d9b1	64
12b60a14-b5d7-45fa-922a-1c1b77c8cc3b	64
12b60a14-b5d7-45fa-922a-1c1b77c8cc3b	65
74c9f5c8-7126-484d-9e29-1e0883e26d80	65
74c9f5c8-7126-484d-9e29-1e0883e26d80	64
830c9ca7-c911-406a-aac6-caf4630d12cb	64
830c9ca7-c911-406a-aac6-caf4630d12cb	65
53abf7cb-6bfb-42f3-b3a1-882d335c36a1	64
53abf7cb-6bfb-42f3-b3a1-882d335c36a1	65
1f2112c3-6d51-4c0e-884c-188d785f4409	65
1f2112c3-6d51-4c0e-884c-188d785f4409	64
a6d284ed-0dcc-4437-aade-1cfca79591fb	66
b2ff7598-8c0e-4508-8410-cb75ff0de59b	66
1e6d9955-9fd2-450b-9fa3-02dadcec9b3c	66
8419243e-9fed-4440-94d2-5a1eff090cce	66
0f72e2f8-d3ab-4e25-917a-ec6d7441abc3	66
6853f4b1-7c31-4774-8a09-5fc06de1a227	66
6399d03b-291b-4f5e-87cd-8d47ac1b6a36	66
daeac45d-a40d-410b-9d47-e91cad9db759	66
ec8243e7-c96a-4b22-90e5-ec9271414e57	66
3a93c64c-ba3b-43ba-b420-3465647d3abf	66
99342083-9250-4be9-82a6-1131c091ce18	68
99342083-9250-4be9-82a6-1131c091ce18	67
6be67608-8412-4e97-b87c-ffef811b600d	67
6be67608-8412-4e97-b87c-ffef811b600d	68
4b28459c-8236-49ad-b72f-ef345f67cd55	67
4b28459c-8236-49ad-b72f-ef345f67cd55	68
fa6ed463-3bfd-406c-ae34-672f36090354	67
fa6ed463-3bfd-406c-ae34-672f36090354	68
aa4d011f-19fa-4617-bc60-ec598ed6ddb8	67
aa4d011f-19fa-4617-bc60-ec598ed6ddb8	68
40f072b9-6bda-45fc-9a89-e748d8c0f428	68
40f072b9-6bda-45fc-9a89-e748d8c0f428	67
d721da1e-9419-4508-8a97-6ca6333bd379	67
d721da1e-9419-4508-8a97-6ca6333bd379	68
46e999ce-c312-4ae5-ad2f-6d74b122f54c	68
46e999ce-c312-4ae5-ad2f-6d74b122f54c	67
b9d445b6-0064-4e78-8427-4c7e433afe08	67
b9d445b6-0064-4e78-8427-4c7e433afe08	68
3cd1685f-8082-4a41-80fa-b07cae255376	68
3cd1685f-8082-4a41-80fa-b07cae255376	67
257176ac-4845-42e5-a0e5-a6c0c3255b33	69
257176ac-4845-42e5-a0e5-a6c0c3255b33	70
4a6e301c-fe33-4c67-a718-148ef4d5b2d6	70
4a6e301c-fe33-4c67-a718-148ef4d5b2d6	69
45ea8c80-2e55-4c0c-a429-1d96576fcadf	69
45ea8c80-2e55-4c0c-a429-1d96576fcadf	70
53fc66fd-f80f-483c-a412-d7b0ba325a55	70
53fc66fd-f80f-483c-a412-d7b0ba325a55	69
803c2b1e-5272-4011-8102-5d6d115ef135	69
803c2b1e-5272-4011-8102-5d6d115ef135	70
f1d68be1-44ce-4f0e-bffc-fa6f28b669b4	69
f1d68be1-44ce-4f0e-bffc-fa6f28b669b4	70
ec2b718b-a2dd-449e-83d3-868875ad579d	70
ec2b718b-a2dd-449e-83d3-868875ad579d	69
2e6fd08a-7133-4292-b30b-a1f6f65822e5	69
2e6fd08a-7133-4292-b30b-a1f6f65822e5	70
72b8c5e2-6168-4927-b758-9c46cbb1a602	1
72b8c5e2-6168-4927-b758-9c46cbb1a602	2
88d2fae9-669e-4a72-9cb4-4d312e8da912	2
88d2fae9-669e-4a72-9cb4-4d312e8da912	1
be3517e2-04f4-47b9-a3f4-97747694d2e5	1
be3517e2-04f4-47b9-a3f4-97747694d2e5	2
67cec151-d0c1-443d-99fe-7f2b726f01b7	1
67cec151-d0c1-443d-99fe-7f2b726f01b7	2
1095ba50-88c2-49c5-92f0-76064b90e0ca	1
1095ba50-88c2-49c5-92f0-76064b90e0ca	2
554381b5-fa4d-4688-8921-a03960c03bd2	2
554381b5-fa4d-4688-8921-a03960c03bd2	1
21c90780-f66e-46c9-ae20-b841304a64cf	1
21c90780-f66e-46c9-ae20-b841304a64cf	2
a93aab17-7596-4722-b221-802b2913a656	2
a93aab17-7596-4722-b221-802b2913a656	1
e877cf96-c733-4b5f-8114-130198437563	2
e877cf96-c733-4b5f-8114-130198437563	1
c7fdfd6a-eff1-41ff-a6ba-7226844f0218	45
c7fdfd6a-eff1-41ff-a6ba-7226844f0218	44
aca76173-8925-46ac-b543-866b771b130f	45
aca76173-8925-46ac-b543-866b771b130f	44
04e0f2e8-3206-468b-b31d-d8bb1f9ccc7e	45
04e0f2e8-3206-468b-b31d-d8bb1f9ccc7e	44
6f9afab8-b43b-49b0-bf36-f995c1057349	45
6f9afab8-b43b-49b0-bf36-f995c1057349	44
4b986ae8-c4b1-48a3-a668-a54307d2e482	45
4b986ae8-c4b1-48a3-a668-a54307d2e482	44
d3106bfa-da5b-47ce-b12c-9040baa3a0ff	45
d3106bfa-da5b-47ce-b12c-9040baa3a0ff	44
de7bf23f-0c55-4f21-a2f4-7f754d753bf5	44
de7bf23f-0c55-4f21-a2f4-7f754d753bf5	45
841da8ef-9320-4f20-ac66-a7743299ae03	45
841da8ef-9320-4f20-ac66-a7743299ae03	44
d4ea243e-e8c2-45d8-ae3a-294fc7a248ab	44
d4ea243e-e8c2-45d8-ae3a-294fc7a248ab	45
0ad8c7fe-c5e8-4c19-a0fc-78cba7f52f4b	45
0ad8c7fe-c5e8-4c19-a0fc-78cba7f52f4b	44
27b2c02b-656a-4bd8-bf7e-623448e2af6b	47
27b2c02b-656a-4bd8-bf7e-623448e2af6b	46
f6449c21-0a8c-4d42-8040-096b46de4bb2	46
f6449c21-0a8c-4d42-8040-096b46de4bb2	47
a814171c-b882-4541-8828-faa19e232b88	46
a814171c-b882-4541-8828-faa19e232b88	47
c8a28113-178c-4685-b390-b43aa361d9b1	47
c8a28113-178c-4685-b390-b43aa361d9b1	46
572f5961-3b53-4595-8844-2fe7113f8a36	47
572f5961-3b53-4595-8844-2fe7113f8a36	46
7645e3f2-d33d-42c7-88b0-c90faf1f839d	46
7645e3f2-d33d-42c7-88b0-c90faf1f839d	47
850223a1-7b7e-434c-810d-f2c64feca497	46
850223a1-7b7e-434c-810d-f2c64feca497	47
32d891c0-f376-4c10-8f00-dd034b053b73	47
32d891c0-f376-4c10-8f00-dd034b053b73	46
1c671f9b-b271-4f02-8880-c9454060646a	48
1c671f9b-b271-4f02-8880-c9454060646a	49
72a0ffd4-cd07-41bb-9bcb-bda6491d5846	49
72a0ffd4-cd07-41bb-9bcb-bda6491d5846	48
a932b9d4-688b-4109-8d88-43fb61e78137	48
a932b9d4-688b-4109-8d88-43fb61e78137	49
685dc8b9-b03a-44ae-8b6c-5ee6ba56ee21	48
685dc8b9-b03a-44ae-8b6c-5ee6ba56ee21	49
31b5c2db-7017-4c1c-b314-6af119da397f	49
31b5c2db-7017-4c1c-b314-6af119da397f	48
3725020a-e0d8-47f8-a822-a5ceb9570747	48
3725020a-e0d8-47f8-a822-a5ceb9570747	49
9597a1fa-bf39-4e97-abff-1e24ac0c0496	49
9597a1fa-bf39-4e97-abff-1e24ac0c0496	48
e85e6fc0-e162-4ed7-92b5-206060044294	48
e85e6fc0-e162-4ed7-92b5-206060044294	49
75d00137-9049-4c63-afcc-8030a53d4dda	51
75d00137-9049-4c63-afcc-8030a53d4dda	50
2e1c3430-c811-484d-856a-415f860ff281	51
2e1c3430-c811-484d-856a-415f860ff281	50
ff282b9b-35b9-4c4c-9e3a-99f8a7192bca	51
ff282b9b-35b9-4c4c-9e3a-99f8a7192bca	50
a8fd5c97-43aa-433b-9b88-39cbae469032	51
a8fd5c97-43aa-433b-9b88-39cbae469032	50
5adcfd89-1152-4748-b626-90cab5b913b7	51
5adcfd89-1152-4748-b626-90cab5b913b7	50
87883ed9-e12c-49cb-81d8-cf4315e9349b	51
87883ed9-e12c-49cb-81d8-cf4315e9349b	50
18b0f067-a10a-4c66-9d27-f3b062721c23	50
18b0f067-a10a-4c66-9d27-f3b062721c23	51
3e5ab82c-f469-4efd-8e40-7f9af702cd4b	50
3e5ab82c-f469-4efd-8e40-7f9af702cd4b	51
669dedfa-3e08-42a1-bc09-291438e654b9	51
669dedfa-3e08-42a1-bc09-291438e654b9	50
6df72cca-a3dc-4cf1-bf1e-02a7e51d306c	51
6df72cca-a3dc-4cf1-bf1e-02a7e51d306c	50
4367d0a5-f9b1-4c92-b58d-c6735c7df2d5	53
4367d0a5-f9b1-4c92-b58d-c6735c7df2d5	52
86d447fe-c5f1-4133-a60d-0256e9541b5f	52
86d447fe-c5f1-4133-a60d-0256e9541b5f	53
8822fdd1-24bf-491a-8de3-6b5fc21dc074	53
8822fdd1-24bf-491a-8de3-6b5fc21dc074	52
3b2d0654-1dbf-486c-b8fc-d9c2c5944b35	53
3b2d0654-1dbf-486c-b8fc-d9c2c5944b35	52
48178cb1-c1e4-472a-900d-4bf164a752a5	52
48178cb1-c1e4-472a-900d-4bf164a752a5	53
7fea3d8b-90ee-4f7d-a28f-571e7eedbf95	53
7fea3d8b-90ee-4f7d-a28f-571e7eedbf95	52
cdeb3bc1-8258-45c9-ad8f-85dd7feb3a9f	53
cdeb3bc1-8258-45c9-ad8f-85dd7feb3a9f	52
9a771b4e-4b54-42db-85f7-0262ef349e46	53
9a771b4e-4b54-42db-85f7-0262ef349e46	52
60223308-3723-4dc7-9569-4b7b744ab2ac	52
60223308-3723-4dc7-9569-4b7b744ab2ac	53
f667a905-4e7a-493b-969c-e7e92efc0cdd	54
bd7e4d67-9971-4e60-9e18-a275b9ccd639	54
b02725a9-c914-4ed8-8701-326c375071fa	54
509caa1d-9a7b-47bd-848a-6c76d58dde04	54
1b2fad33-8744-4877-9d1f-54e8d48ca38a	54
a793ad5b-d0fd-4ad1-ba29-10deb496e84e	54
6f4797ea-dbc9-49ad-a33c-94b5e7e76954	54
5e6b19af-da93-48a5-8b5c-83e8e22350e4	54
5d5ca654-556c-4ae2-af29-f1c3af3314a1	54
ce1af51a-e499-49df-b414-eb5421a92103	54
c83226b6-1928-4f13-a2be-09275ec25a9f	55
84b23dcf-efb6-4b54-a9d8-28e3bf3fe5c8	55
105b4aad-e4b4-41cb-8f17-11501595a42c	55
f95fa30c-31d8-45bf-ad42-d506cc4d55e1	55
b7ca1f07-abc9-4941-992a-069e313bf3a2	55
fdc7e851-3115-438a-8b55-0a770c1b830e	55
8a623eb6-5c61-43a5-8b89-a019a1beee6b	55
949612a0-8be8-44e1-9d7a-332cecae5d9b	55
3d9d1167-6077-4e36-add8-e27273938068	56
2294e059-a5db-4c62-8c9b-7aa5b64421e6	56
0d2c7c71-e6ec-4576-b344-b6e85f1df693	56
f6624c5c-23d8-4914-9bdc-9e24438accb4	56
d06d4c80-8a57-493b-9b6f-e20ee3938482	56
e4b4b6e5-427f-4e81-a92a-9416eb484a23	56
28bc7a62-9c62-4bc2-ab9d-772356929321	56
b62ca336-49fa-48c0-8f7f-a0edf3d8a5c9	56
5de0140d-eb1d-47eb-9a38-c682b7b7e418	56
2f328dd6-0494-45c2-abef-f1875d5a0e6d	56
e4dcc1e7-b923-4562-839f-d534597b8e54	57
30794320-b4bb-4324-8daf-9bcd05a56427	57
3e7b9a5f-58a7-4900-bce5-76c815e6eee0	57
db751582-55be-423c-8906-77d362f9a2cc	58
db751582-55be-423c-8906-77d362f9a2cc	62
8f275fa0-f699-437a-a627-aa85778c15ff	58
8f275fa0-f699-437a-a627-aa85778c15ff	62
1481203f-4e3a-45bd-b05d-b83e22600efe	62
1481203f-4e3a-45bd-b05d-b83e22600efe	58
626ce20a-f028-41d1-8d6a-3d6415404b65	62
626ce20a-f028-41d1-8d6a-3d6415404b65	58
9605b764-b0c9-4209-951b-545f44695166	62
9605b764-b0c9-4209-951b-545f44695166	58
1f938ce9-0381-4685-b154-39a9b86f8500	62
1f938ce9-0381-4685-b154-39a9b86f8500	58
97dccdaa-0f5d-4b2a-afd9-ee886e7bee33	71
97dccdaa-0f5d-4b2a-afd9-ee886e7bee33	72
72754622-4da6-439e-9094-afd84c9147ae	72
72754622-4da6-439e-9094-afd84c9147ae	71
90ceb93e-2885-4594-b7fb-8826cbd6aed6	72
90ceb93e-2885-4594-b7fb-8826cbd6aed6	71
a0137d63-afcb-4b28-a482-8d9ea8a30598	72
a0137d63-afcb-4b28-a482-8d9ea8a30598	71
382c5d89-d8bb-4d6d-a404-0e567efae4a3	71
382c5d89-d8bb-4d6d-a404-0e567efae4a3	72
4baaf54b-e985-44ab-a6fd-dd86a13ff00e	71
4baaf54b-e985-44ab-a6fd-dd86a13ff00e	72
405b165f-7bed-45bd-8a35-83f53abe01ef	72
405b165f-7bed-45bd-8a35-83f53abe01ef	71
514637a2-36f3-427a-bae6-48b401c7dadf	73
514637a2-36f3-427a-bae6-48b401c7dadf	53
1e9f47da-1276-4f64-87f5-af4bb2de30b2	53
1e9f47da-1276-4f64-87f5-af4bb2de30b2	73
feb22a4f-8ca3-47be-9f77-73633e8cac87	53
feb22a4f-8ca3-47be-9f77-73633e8cac87	73
fea0d429-99a2-4c19-9637-07bf182b7983	73
fea0d429-99a2-4c19-9637-07bf182b7983	53
0a2e8432-7519-451e-bdf2-73582f37b73e	53
0a2e8432-7519-451e-bdf2-73582f37b73e	73
ea8a749f-cb4f-4416-97d9-983ff8976f1a	53
ea8a749f-cb4f-4416-97d9-983ff8976f1a	73
9d967a61-5752-4f31-9ae1-f75afd17434e	73
9d967a61-5752-4f31-9ae1-f75afd17434e	53
c36131f1-1b10-45ee-bb94-e134d3f58f08	73
c36131f1-1b10-45ee-bb94-e134d3f58f08	53
a0a4b2a1-cd99-4cd3-a45b-b805b284ac73	53
a0a4b2a1-cd99-4cd3-a45b-b805b284ac73	73
1eb5e75f-3e77-4149-9b56-e9ba539e4c03	73
1eb5e75f-3e77-4149-9b56-e9ba539e4c03	53
1c7c759c-ec31-480b-a2e9-d5a6240e2645	74
1c7c759c-ec31-480b-a2e9-d5a6240e2645	75
5d7fc569-c59e-4f74-a380-3f3a10e2811f	75
5d7fc569-c59e-4f74-a380-3f3a10e2811f	74
76708d13-3556-461a-b254-386e469e69d9	74
76708d13-3556-461a-b254-386e469e69d9	75
ab54442b-fd73-4767-99e5-398dd4b19707	74
ab54442b-fd73-4767-99e5-398dd4b19707	75
6ba28a5a-471e-4083-b91d-11b8d48461c9	74
6ba28a5a-471e-4083-b91d-11b8d48461c9	75
509c1bd0-a388-422a-8769-4afbc0efa7be	74
509c1bd0-a388-422a-8769-4afbc0efa7be	75
d9580e28-c329-4afe-83c0-83c2ede40cc9	74
d9580e28-c329-4afe-83c0-83c2ede40cc9	75
e93073dd-5fbc-4e07-9c6e-3603b0b82421	74
e93073dd-5fbc-4e07-9c6e-3603b0b82421	75
4b965609-7921-47fd-af6b-9ecfd6199289	75
4b965609-7921-47fd-af6b-9ecfd6199289	74
4e94a729-ca31-4f9a-81a4-20d43b23553e	83
4611b319-7124-46ad-b837-1cacb0b3a740	83
1fb3a057-b4be-493e-8b5b-5497633557fc	83
8c732e30-7933-4e36-8249-6275c3990ada	83
01c605cb-7f85-4f78-83a4-b3b92359414b	83
9a631f0a-6c67-4df0-bf72-1f3b18f17990	83
ddb3565e-3b5e-4106-a53e-5109f4f69b34	83
e05bdc20-f4af-439d-b7a4-90c51869550d	83
2c563240-772f-4d1a-b2fa-c21faf4d76f3	83
1c67dcf5-26b7-46de-9cd6-02006602da91	62
1c67dcf5-26b7-46de-9cd6-02006602da91	58
7cadac02-c2db-45f4-b686-0a8226ede13e	62
7cadac02-c2db-45f4-b686-0a8226ede13e	58
b13526b9-7385-4d75-8194-15fc9501a72b	62
b13526b9-7385-4d75-8194-15fc9501a72b	58
e1dda565-6e15-4183-a684-129c52bb1a73	85
e1dda565-6e15-4183-a684-129c52bb1a73	84
70a1cd58-5008-446a-b303-d2e2d61e8dfc	85
70a1cd58-5008-446a-b303-d2e2d61e8dfc	84
f097a098-dd7e-449f-9521-1dcaeba20ec5	85
f097a098-dd7e-449f-9521-1dcaeba20ec5	84
677bb0f5-f574-4c9a-9535-137618ae50f9	85
677bb0f5-f574-4c9a-9535-137618ae50f9	84
45b62747-23bc-4928-af2d-e8a40505fc0e	85
45b62747-23bc-4928-af2d-e8a40505fc0e	84
e2f92315-82fd-4764-a8ea-7256633802b9	84
e2f92315-82fd-4764-a8ea-7256633802b9	85
cb479c78-c152-4db6-b62a-3daa3dc7de6c	85
cb479c78-c152-4db6-b62a-3daa3dc7de6c	84
ad92b3ca-2370-4aec-892a-3148259919b9	85
ad92b3ca-2370-4aec-892a-3148259919b9	84
5c7f0254-ab95-4f62-a71f-3e3e0f63d8de	84
5c7f0254-ab95-4f62-a71f-3e3e0f63d8de	85
18ebe3fb-e67f-4c97-aa19-de9b3157c429	60
9a77ffd9-cb63-4cec-b955-644b2f967a63	60
b71d1650-de86-4d85-b96c-7ae3b292fae0	1
b71d1650-de86-4d85-b96c-7ae3b292fae0	86
cdc8fb15-da7d-4399-91e8-f1198a3ddc23	86
cdc8fb15-da7d-4399-91e8-f1198a3ddc23	1
b69223b4-d9de-4d97-964f-19e48b6288f6	86
b69223b4-d9de-4d97-964f-19e48b6288f6	1
d9264521-5a7b-42b8-a15f-1de7899e0109	1
d9264521-5a7b-42b8-a15f-1de7899e0109	86
cdd1ef0c-1f23-405a-848f-95e7ff299d6e	1
cdd1ef0c-1f23-405a-848f-95e7ff299d6e	86
d4bc5119-f4b5-4d5f-b679-82d4d9fec828	86
d4bc5119-f4b5-4d5f-b679-82d4d9fec828	1
e6a3ddf7-5f14-4187-a1f0-d4de0065c0f5	86
e6a3ddf7-5f14-4187-a1f0-d4de0065c0f5	1
95dcc931-02f8-4d30-9de6-81d897c27f2b	1
95dcc931-02f8-4d30-9de6-81d897c27f2b	86
c3d41e13-d185-40d8-83e8-9322dde44e2e	86
c3d41e13-d185-40d8-83e8-9322dde44e2e	1
cb5fd2e7-54e6-4d7c-a631-950e69626271	1
cb5fd2e7-54e6-4d7c-a631-950e69626271	86
e3996ff9-748c-4045-82da-54c8f23676fb	48
e3996ff9-748c-4045-82da-54c8f23676fb	87
c756854c-164d-4e4b-af55-5733ada6ad25	48
c756854c-164d-4e4b-af55-5733ada6ad25	87
d99daa4d-e8f0-451c-b346-054d478cc369	48
d99daa4d-e8f0-451c-b346-054d478cc369	87
a6e52495-3418-4bf8-8c53-b095eac5223f	87
a6e52495-3418-4bf8-8c53-b095eac5223f	48
de8ffe11-5db4-40f8-bfe5-f94292fab106	48
de8ffe11-5db4-40f8-bfe5-f94292fab106	87
d4f8e3c3-6014-4a7a-8f89-a1a465092a60	48
d4f8e3c3-6014-4a7a-8f89-a1a465092a60	87
5f13718b-403a-47eb-ba7d-5d962cfb3bf8	87
5f13718b-403a-47eb-ba7d-5d962cfb3bf8	48
aac06803-eba6-468e-bb10-07c7004a144d	87
aac06803-eba6-468e-bb10-07c7004a144d	48
2305bd17-e2d8-48b4-9cb6-129142f9df37	88
2305bd17-e2d8-48b4-9cb6-129142f9df37	66
90452f4e-b01c-4497-bcf4-040afb5cbd2c	66
90452f4e-b01c-4497-bcf4-040afb5cbd2c	88
cbbf1d07-ef68-4472-a181-9861bd98a346	88
cbbf1d07-ef68-4472-a181-9861bd98a346	66
54b6cf22-8049-454e-97d6-2aecc4b81646	88
54b6cf22-8049-454e-97d6-2aecc4b81646	66
91d0fdb4-146d-431b-9984-cbe81f6de1fc	66
91d0fdb4-146d-431b-9984-cbe81f6de1fc	88
7a09f2ea-1ff8-4b01-912f-38824ad34d1e	88
7a09f2ea-1ff8-4b01-912f-38824ad34d1e	66
db35d19c-891a-450d-96f3-60c04061b58f	66
db35d19c-891a-450d-96f3-60c04061b58f	88
6b65a2e6-9286-4933-b544-a6e6220353c9	88
6b65a2e6-9286-4933-b544-a6e6220353c9	66
5e5063ff-4619-4f49-a463-36d8882d5868	61
5e5063ff-4619-4f49-a463-36d8882d5868	89
b0e95b64-d0f8-45ac-bfb5-0644144cdaa8	61
b0e95b64-d0f8-45ac-bfb5-0644144cdaa8	89
5e466f08-c63a-40a2-9a85-bd76189adb4b	89
5e466f08-c63a-40a2-9a85-bd76189adb4b	61
6c86b220-d897-4970-b95b-f14a59e45086	89
6c86b220-d897-4970-b95b-f14a59e45086	61
9fd6af8a-eed5-4212-b8c3-96b6667cd482	90
9fd6af8a-eed5-4212-b8c3-96b6667cd482	91
69a77995-4a29-475a-a7c6-7b7091105a09	91
69a77995-4a29-475a-a7c6-7b7091105a09	90
a2517c65-d423-46bd-ac3f-abb1be982e31	91
a2517c65-d423-46bd-ac3f-abb1be982e31	90
234cf56d-e721-4816-b07d-a789b33e36b7	90
234cf56d-e721-4816-b07d-a789b33e36b7	91
1ea28ae0-55b5-4fa4-9549-e929888f71ce	91
1ea28ae0-55b5-4fa4-9549-e929888f71ce	90
55599a9d-fc78-4a74-bb58-d310be81402e	90
55599a9d-fc78-4a74-bb58-d310be81402e	91
bc6544bd-01f8-4ddd-86ae-e8869d0a141b	91
bc6544bd-01f8-4ddd-86ae-e8869d0a141b	90
4b581df1-8c71-4a6d-8fbe-1600ef59acd9	90
4b581df1-8c71-4a6d-8fbe-1600ef59acd9	91
5ba8947b-125b-4e51-89e5-72b8de894dc6	91
5ba8947b-125b-4e51-89e5-72b8de894dc6	90
6b3d66f1-95d4-4c80-89ab-c8626b42343c	92
6b3d66f1-95d4-4c80-89ab-c8626b42343c	93
693fe39d-8914-4805-86eb-cca7a657f311	93
693fe39d-8914-4805-86eb-cca7a657f311	92
f39be50c-2d84-4dda-8def-3cfbeca4942d	93
f39be50c-2d84-4dda-8def-3cfbeca4942d	92
ac093c3a-9c80-44b3-b08f-45df2da3562d	92
ac093c3a-9c80-44b3-b08f-45df2da3562d	93
688672df-4526-440f-af3d-adf4ca533df3	93
688672df-4526-440f-af3d-adf4ca533df3	92
5db16109-fc90-4747-a5c4-5ed1becb49fc	93
5db16109-fc90-4747-a5c4-5ed1becb49fc	92
d06ed3e7-914c-463a-909f-de1dc4489962	92
d06ed3e7-914c-463a-909f-de1dc4489962	93
7b2e802c-3bc1-4748-a10e-e99db52bf561	92
7b2e802c-3bc1-4748-a10e-e99db52bf561	93
36c3ec36-9233-4799-864f-43b92e8d4017	93
36c3ec36-9233-4799-864f-43b92e8d4017	92
a08d0770-c967-47df-bd9c-9213893196dd	51
a08d0770-c967-47df-bd9c-9213893196dd	50
8c0ae6cd-4456-48ef-871d-413984717c04	50
8c0ae6cd-4456-48ef-871d-413984717c04	51
8a9f224b-bddb-4168-a5b4-67f4265813cc	50
8a9f224b-bddb-4168-a5b4-67f4265813cc	51
b52e56ed-029e-445c-8e92-d2b80f3398ba	50
b52e56ed-029e-445c-8e92-d2b80f3398ba	51
08cbab15-b6e4-4964-9ec3-57498b16fc91	50
08cbab15-b6e4-4964-9ec3-57498b16fc91	51
b623b4af-4323-49ca-bd12-6e7006c0a204	52
b623b4af-4323-49ca-bd12-6e7006c0a204	94
a7ea18ed-5809-4a6d-a54d-8fd9b1f6e1bd	52
a7ea18ed-5809-4a6d-a54d-8fd9b1f6e1bd	94
dd7fb716-191b-4033-b3e6-ababe25780f1	52
dd7fb716-191b-4033-b3e6-ababe25780f1	94
b306027d-c1dd-40e2-add0-cbfe1c56f371	52
b306027d-c1dd-40e2-add0-cbfe1c56f371	94
4306fb3b-f572-4498-9434-b89bb9741340	52
4306fb3b-f572-4498-9434-b89bb9741340	94
08141e11-5ed8-485d-9ace-6149f87a3744	94
08141e11-5ed8-485d-9ace-6149f87a3744	52
1e0bec3a-108d-4b84-8806-35e65b2f7ca4	61
1e0bec3a-108d-4b84-8806-35e65b2f7ca4	67
f6ce6220-67c3-4199-9501-9ea2c593c6e5	67
f6ce6220-67c3-4199-9501-9ea2c593c6e5	61
d8be77c1-096c-4e4b-a786-73307726ab19	67
d8be77c1-096c-4e4b-a786-73307726ab19	61
a73b7584-85ad-4310-b68e-5d6d0237da39	61
a73b7584-85ad-4310-b68e-5d6d0237da39	67
782dbdac-7ba7-4d07-856f-555bfad005bb	61
782dbdac-7ba7-4d07-856f-555bfad005bb	67
b3364089-a364-4a7e-bfa9-e0b9b93d797e	67
b3364089-a364-4a7e-bfa9-e0b9b93d797e	61
160c94bd-8139-4f2c-96d3-18ee0c6ca7d8	68
160c94bd-8139-4f2c-96d3-18ee0c6ca7d8	95
35518f0b-e443-4980-945a-1f715f080265	68
35518f0b-e443-4980-945a-1f715f080265	95
21099f91-65a4-4250-ba23-85d92553c5ba	68
21099f91-65a4-4250-ba23-85d92553c5ba	95
f772a646-5588-4060-978c-14bf3104870d	95
f772a646-5588-4060-978c-14bf3104870d	68
0f9b1333-caf2-47e2-9f5f-e10c0d19252e	68
0f9b1333-caf2-47e2-9f5f-e10c0d19252e	95
9071d528-f356-413b-b6b3-a3b8a168f872	95
9071d528-f356-413b-b6b3-a3b8a168f872	68
c66d603b-0764-4f24-a8e7-e47ff0cff1c3	68
c66d603b-0764-4f24-a8e7-e47ff0cff1c3	95
9ac9684f-1f2d-40a0-a4b6-d9ecf9a344d7	68
9ac9684f-1f2d-40a0-a4b6-d9ecf9a344d7	95
f2d3c699-fab2-4275-a0df-e27ff89151f1	95
f2d3c699-fab2-4275-a0df-e27ff89151f1	68
acaa7eb1-e1fe-4fea-a595-e21e85491a2e	68
acaa7eb1-e1fe-4fea-a595-e21e85491a2e	95
5a677e39-ca9b-48e2-87af-8d4bd4de1e95	96
5a677e39-ca9b-48e2-87af-8d4bd4de1e95	90
9fcf4011-2901-4f3a-8ce8-24fc4448b6ba	90
9fcf4011-2901-4f3a-8ce8-24fc4448b6ba	96
b5d2633d-cef9-44de-b067-a2887371feeb	96
b5d2633d-cef9-44de-b067-a2887371feeb	90
8aae4914-2af6-45e8-9a15-1dfc0af43d9c	96
8aae4914-2af6-45e8-9a15-1dfc0af43d9c	90
dee0ba45-aa47-4963-bad1-c9535fa3f0bb	96
dee0ba45-aa47-4963-bad1-c9535fa3f0bb	90
ad8d4724-f1e0-4e94-9717-f80a418c607d	90
ad8d4724-f1e0-4e94-9717-f80a418c607d	96
1d07efd9-c210-44e7-9bb5-90b61d02d923	96
1d07efd9-c210-44e7-9bb5-90b61d02d923	90
0ae6f709-7a8c-4ab9-a170-9780a3ab2790	96
0ae6f709-7a8c-4ab9-a170-9780a3ab2790	90
00cee702-8be3-4a95-a97a-af6936a05873	96
00cee702-8be3-4a95-a97a-af6936a05873	90
147ec701-da5a-4ad5-9828-608382af5b84	90
147ec701-da5a-4ad5-9828-608382af5b84	96
721f3e98-7a9a-415a-a2f3-dc9d38f5f414	90
721f3e98-7a9a-415a-a2f3-dc9d38f5f414	96
f2fb5530-e5c8-48bc-8f8c-7fc1006850f7	90
f2fb5530-e5c8-48bc-8f8c-7fc1006850f7	96
ed4a3f21-01b4-42fe-beea-be5d80b7167f	96
ed4a3f21-01b4-42fe-beea-be5d80b7167f	90
fccd63b7-af2a-47f1-afd4-2510e78a0fc6	96
fccd63b7-af2a-47f1-afd4-2510e78a0fc6	90
2ae2e4d4-607f-4c81-9e4a-b158f394859e	90
2ae2e4d4-607f-4c81-9e4a-b158f394859e	96
14fe6c8a-eac5-46c4-b1d5-62817daf1e78	97
14fe6c8a-eac5-46c4-b1d5-62817daf1e78	90
8dda7592-45b7-4d36-aa90-d77899eb6a20	97
8dda7592-45b7-4d36-aa90-d77899eb6a20	90
ea7a9840-e31c-449c-a87e-6ec03e65aa8f	97
ea7a9840-e31c-449c-a87e-6ec03e65aa8f	90
4843714b-fcf2-4889-80b7-337fc38f60bd	90
4843714b-fcf2-4889-80b7-337fc38f60bd	97
3bbb2b8b-41c3-4b06-8512-64ec84e4e402	97
3bbb2b8b-41c3-4b06-8512-64ec84e4e402	90
032187df-beb1-4707-9947-7f8ee61259ee	90
032187df-beb1-4707-9947-7f8ee61259ee	97
92b8e6f0-804d-45b5-8cef-2bd874e157af	97
92b8e6f0-804d-45b5-8cef-2bd874e157af	90
66ed1f11-e7f1-4362-ac73-93012a85fbbc	97
66ed1f11-e7f1-4362-ac73-93012a85fbbc	90
2c3c0ee4-0a72-4ea1-9187-9474845a644f	90
2c3c0ee4-0a72-4ea1-9187-9474845a644f	97
4a91ad24-9c24-4b0a-885e-4a3926890b41	90
4a91ad24-9c24-4b0a-885e-4a3926890b41	97
8be66ca4-38da-43f3-b78d-415f3428674d	90
8be66ca4-38da-43f3-b78d-415f3428674d	89
61efb3b4-24ad-4244-92b2-f0c2feb5c648	90
61efb3b4-24ad-4244-92b2-f0c2feb5c648	89
1e0d7b91-0196-437c-b0dc-8e020bb035ac	89
1e0d7b91-0196-437c-b0dc-8e020bb035ac	90
b92d9a3b-8221-465d-a51f-8e595eb13001	90
b92d9a3b-8221-465d-a51f-8e595eb13001	89
3ab5a4de-5c62-4336-916c-76218f356382	89
3ab5a4de-5c62-4336-916c-76218f356382	90
e4c934ab-afac-473c-a668-3f9153095f1e	90
e4c934ab-afac-473c-a668-3f9153095f1e	89
4b211b45-b61b-4656-ad5d-ce4dd19e56bc	89
4b211b45-b61b-4656-ad5d-ce4dd19e56bc	90
9c0b5906-f6d9-44ca-95bb-1b88eebe227f	89
9c0b5906-f6d9-44ca-95bb-1b88eebe227f	90
6ee4cab8-d247-4681-a9a4-64a3eec28263	89
6ee4cab8-d247-4681-a9a4-64a3eec28263	90
3831aca6-deb7-4737-9d1f-3f763e76d53b	90
3831aca6-deb7-4737-9d1f-3f763e76d53b	89
71ccdbff-cdb8-420e-9dd4-b969dd027798	90
71ccdbff-cdb8-420e-9dd4-b969dd027798	89
fedc4968-5036-4f07-b5c1-02da0c7e0f89	61
fedc4968-5036-4f07-b5c1-02da0c7e0f89	89
c5242118-e645-4997-94da-c258df490a2e	61
c5242118-e645-4997-94da-c258df490a2e	89
7b9949e1-3263-4ef0-9797-f2a01a682411	89
7b9949e1-3263-4ef0-9797-f2a01a682411	61
74e1f67d-8872-4a40-852a-b460e3d7aa86	61
74e1f67d-8872-4a40-852a-b460e3d7aa86	89
5436c34e-4288-4164-a9f7-c60a15bddbd9	89
5436c34e-4288-4164-a9f7-c60a15bddbd9	61
9b87a142-1cac-451c-8ef0-4bb4f34d5e48	86
9b87a142-1cac-451c-8ef0-4bb4f34d5e48	1
d134cb8c-4e65-4b8a-9805-3baecd222021	86
d134cb8c-4e65-4b8a-9805-3baecd222021	1
aacc96ba-8409-4130-8d1b-006405af356a	86
aacc96ba-8409-4130-8d1b-006405af356a	1
d27b18e4-0688-48c6-bb49-2412319272cc	1
d27b18e4-0688-48c6-bb49-2412319272cc	86
0a49e6eb-40d1-473c-8e7a-589389e03233	86
0a49e6eb-40d1-473c-8e7a-589389e03233	1
e4d1bb28-bcc8-4561-8899-f31551eeaa25	1
e4d1bb28-bcc8-4561-8899-f31551eeaa25	86
c83e1718-4557-4dbe-8f6c-adc237f9245c	1
c83e1718-4557-4dbe-8f6c-adc237f9245c	86
08cfc2ef-009e-4d28-8b70-72cb21ff0b8e	67
08cfc2ef-009e-4d28-8b70-72cb21ff0b8e	98
a7c3202b-8ef0-4697-b719-cb5cbd4c478c	67
a7c3202b-8ef0-4697-b719-cb5cbd4c478c	98
abada2ba-197c-46fa-9d20-34d9844aed2b	98
abada2ba-197c-46fa-9d20-34d9844aed2b	67
73a4caf7-5f43-444a-86e2-c962a1b6468d	67
73a4caf7-5f43-444a-86e2-c962a1b6468d	98
8ba50fc1-df40-40c6-bf44-e183208c021b	67
8ba50fc1-df40-40c6-bf44-e183208c021b	98
8e3e95df-79c2-4630-8a4a-5282ad1cca3c	67
8e3e95df-79c2-4630-8a4a-5282ad1cca3c	98
3262ab29-8fb4-4cf6-88f7-b5c5f6a8b21f	98
3262ab29-8fb4-4cf6-88f7-b5c5f6a8b21f	67
f908de00-2030-43fb-94c0-171b5c4c718b	98
f908de00-2030-43fb-94c0-171b5c4c718b	67
38fad0f0-dc36-42e0-89f8-5feeab404413	67
38fad0f0-dc36-42e0-89f8-5feeab404413	98
1d999b41-1ea1-4fba-9012-1f5d7a170753	99
1d999b41-1ea1-4fba-9012-1f5d7a170753	62
2d3d4fc8-26ca-49c5-97f6-d10220a402bf	62
2d3d4fc8-26ca-49c5-97f6-d10220a402bf	99
e0b4806f-c318-4e7c-b459-4db8b3d544be	99
e0b4806f-c318-4e7c-b459-4db8b3d544be	62
b9ee40fc-cda1-4574-8945-2f9fd0fa897b	99
b9ee40fc-cda1-4574-8945-2f9fd0fa897b	62
10a7c159-43c8-41eb-947f-544f5eac1ecb	99
10a7c159-43c8-41eb-947f-544f5eac1ecb	62
c9fc9529-0694-4985-adbf-a69dde03ed21	99
c9fc9529-0694-4985-adbf-a69dde03ed21	62
e5772443-ce05-481a-91cb-ec9a0b709215	62
e5772443-ce05-481a-91cb-ec9a0b709215	99
f51fcc18-fbc8-4e22-84fc-8c20bfaef8b9	62
f51fcc18-fbc8-4e22-84fc-8c20bfaef8b9	99
c6183c1e-59d0-4f46-831a-43f2a7124b08	100
c6183c1e-59d0-4f46-831a-43f2a7124b08	62
ee826772-c967-4fa2-87be-8ea0134700c5	62
ee826772-c967-4fa2-87be-8ea0134700c5	100
895ebdd8-5189-437d-a5cc-66398173ae64	100
895ebdd8-5189-437d-a5cc-66398173ae64	62
d05318e9-4674-4643-a927-a9cccd82b5f3	62
d05318e9-4674-4643-a927-a9cccd82b5f3	100
0e275ff6-28a7-4111-b085-7b57e5811d56	100
0e275ff6-28a7-4111-b085-7b57e5811d56	62
6cae8abe-fb2b-4f35-8a53-7f47ffddbfa9	62
6cae8abe-fb2b-4f35-8a53-7f47ffddbfa9	100
1d360df8-d1b7-4bac-8877-8f8cf8f1c1ad	62
1d360df8-d1b7-4bac-8877-8f8cf8f1c1ad	100
c5fe5ad2-4cb4-43a1-b749-eb09b64a6c37	62
c5fe5ad2-4cb4-43a1-b749-eb09b64a6c37	100
353856f1-c5f3-4cba-a895-5ee5c5876fe0	101
353856f1-c5f3-4cba-a895-5ee5c5876fe0	62
1860d6b7-4484-460b-af88-333b43880c06	62
1860d6b7-4484-460b-af88-333b43880c06	101
c4ec5912-259e-47e8-bf65-aec7177f8ca3	101
c4ec5912-259e-47e8-bf65-aec7177f8ca3	62
a6ac2b2d-a26f-4398-b36b-70bdcd3cf3b7	101
a6ac2b2d-a26f-4398-b36b-70bdcd3cf3b7	62
f2b01b3e-593f-4f4e-82f3-de574676e79d	101
f2b01b3e-593f-4f4e-82f3-de574676e79d	62
a6ba2a2c-cfd2-4df7-90aa-66e0b0895c6b	101
a6ba2a2c-cfd2-4df7-90aa-66e0b0895c6b	62
34535e43-7658-4967-b4cf-a2097aaa2d20	62
34535e43-7658-4967-b4cf-a2097aaa2d20	101
b8d945fb-c29c-4733-89ee-06b5d3d2c407	102
b8d945fb-c29c-4733-89ee-06b5d3d2c407	62
19ad1db6-0008-4922-834b-fc4a4dab829d	62
19ad1db6-0008-4922-834b-fc4a4dab829d	102
e331e4cf-28ef-4cbe-9a4a-1e0899aa29a0	102
e331e4cf-28ef-4cbe-9a4a-1e0899aa29a0	62
f38de71c-917a-478f-a37d-331a777fbb35	62
f38de71c-917a-478f-a37d-331a777fbb35	102
c1cea1da-ae4e-4ea7-8c43-b02dcefbed4a	62
c1cea1da-ae4e-4ea7-8c43-b02dcefbed4a	102
d87723b6-239a-4f63-ba07-b0788ba2ddf8	102
d87723b6-239a-4f63-ba07-b0788ba2ddf8	62
62847eca-5dc3-44a7-b323-8abca1f30553	62
62847eca-5dc3-44a7-b323-8abca1f30553	102
5b13ecf7-9a49-4989-9578-0287fbcc3a2f	102
5b13ecf7-9a49-4989-9578-0287fbcc3a2f	62
d5309492-806a-467e-af76-94b02ecbda44	102
d5309492-806a-467e-af76-94b02ecbda44	62
20fa3db0-2bb1-4893-9417-634ce70bc0d6	102
20fa3db0-2bb1-4893-9417-634ce70bc0d6	62
8c6a80a1-f18e-40b4-bd09-271f71535dcf	102
8c6a80a1-f18e-40b4-bd09-271f71535dcf	62
50cfea3a-7c16-4787-8566-628892ed550d	62
50cfea3a-7c16-4787-8566-628892ed550d	102
47cec108-f0f3-410c-ad50-c8a95ddde5c4	62
47cec108-f0f3-410c-ad50-c8a95ddde5c4	102
77cd027d-e01c-491a-b8d5-78346f4ff542	102
77cd027d-e01c-491a-b8d5-78346f4ff542	62
5c4659b7-af82-4eb1-8a40-deb1686fa27e	62
5c4659b7-af82-4eb1-8a40-deb1686fa27e	102
a87ba1b3-4bb9-492e-bd8c-f1026a4d1c57	62
a87ba1b3-4bb9-492e-bd8c-f1026a4d1c57	103
f0c223a8-7cc8-40a5-8697-5b6afeec7de6	62
f0c223a8-7cc8-40a5-8697-5b6afeec7de6	103
5564e0a5-0ec8-4669-8e69-c26b66670cd7	103
5564e0a5-0ec8-4669-8e69-c26b66670cd7	62
76c8ff48-e28d-4e79-a06a-79b922460a21	62
76c8ff48-e28d-4e79-a06a-79b922460a21	103
3e75dd6a-74ad-4f0c-befa-c4cd00da8491	103
3e75dd6a-74ad-4f0c-befa-c4cd00da8491	62
e4d7947e-52a7-4a9d-8ef1-8fb6771ce30a	103
e4d7947e-52a7-4a9d-8ef1-8fb6771ce30a	62
0e96a1ac-ae6d-414b-b362-69131aab1b4c	103
0e96a1ac-ae6d-414b-b362-69131aab1b4c	62
b775e25c-12b4-4518-bf50-fa834650c4ce	62
b775e25c-12b4-4518-bf50-fa834650c4ce	103
75d72a27-a432-4690-936e-1d8970435cf7	104
75d72a27-a432-4690-936e-1d8970435cf7	62
99d1272c-3794-44ef-8b5a-cbc35a5ca3ed	62
99d1272c-3794-44ef-8b5a-cbc35a5ca3ed	105
a9d0b29f-cb30-489a-b736-b5eff81ef6b2	62
a9d0b29f-cb30-489a-b736-b5eff81ef6b2	105
de43def9-5b4d-41de-b1be-d6579daa2b8c	105
de43def9-5b4d-41de-b1be-d6579daa2b8c	62
f0b3075d-476c-48ee-a3a0-e60619ce8f4e	105
f0b3075d-476c-48ee-a3a0-e60619ce8f4e	62
1385ef47-7644-463a-a535-770542e5122c	105
1385ef47-7644-463a-a535-770542e5122c	62
37092294-0ce3-4c96-9820-67b64fadbb73	105
37092294-0ce3-4c96-9820-67b64fadbb73	62
ab8c30b6-4ab2-4851-9a1d-a0334ba7206e	106
ab8c30b6-4ab2-4851-9a1d-a0334ba7206e	60
e13c5ae7-5524-4e08-af5a-598c843f6fc8	106
e13c5ae7-5524-4e08-af5a-598c843f6fc8	60
983428bc-0d18-4ef9-a6a7-e157faa8f627	60
983428bc-0d18-4ef9-a6a7-e157faa8f627	106
c3396dde-e9c2-4ad0-97aa-526c87a0fe98	106
c3396dde-e9c2-4ad0-97aa-526c87a0fe98	60
6c9226f8-26e5-4dde-8786-c555d9c962a8	60
6c9226f8-26e5-4dde-8786-c555d9c962a8	106
5eed014e-ae0d-4580-bd61-11a7a67a3bb1	60
5eed014e-ae0d-4580-bd61-11a7a67a3bb1	106
b211d13f-ba1c-455c-af5a-85581f6c7e88	106
b211d13f-ba1c-455c-af5a-85581f6c7e88	60
2c1bb589-6eae-4a61-9670-8a75041af02d	60
2c1bb589-6eae-4a61-9670-8a75041af02d	106
1874d770-c999-4f37-980b-ab9a499a68d5	60
1874d770-c999-4f37-980b-ab9a499a68d5	106
6c7427bb-c202-4fc8-9db3-df0e066c7d61	73
6c7427bb-c202-4fc8-9db3-df0e066c7d61	53
d1dc14f9-4f6c-492b-abd2-28ac48260a3a	53
d1dc14f9-4f6c-492b-abd2-28ac48260a3a	73
2edcb120-b531-448e-bb0d-879c198f6c36	53
2edcb120-b531-448e-bb0d-879c198f6c36	73
74e8a803-1361-4b5a-ad72-272206aa48ef	53
74e8a803-1361-4b5a-ad72-272206aa48ef	73
2fb52aca-f436-449f-b7d7-de3e61ca5d07	73
2fb52aca-f436-449f-b7d7-de3e61ca5d07	53
b60373d5-ffa9-4629-8975-51073b205ffd	73
b60373d5-ffa9-4629-8975-51073b205ffd	53
fdd3d6d7-c4d5-4218-a5ab-38b2e404331f	53
fdd3d6d7-c4d5-4218-a5ab-38b2e404331f	107
dd3acc71-d3c9-4fb4-bdf3-a320acc2f070	53
dd3acc71-d3c9-4fb4-bdf3-a320acc2f070	107
c0af76d8-1522-4e6f-b0a0-84f0a9e39537	107
c0af76d8-1522-4e6f-b0a0-84f0a9e39537	53
f9eeb2d3-9d6f-4470-9e0d-aee44a3367f8	107
f9eeb2d3-9d6f-4470-9e0d-aee44a3367f8	53
72ae0734-3280-4e96-bbc6-c1ad004e4c70	107
72ae0734-3280-4e96-bbc6-c1ad004e4c70	53
eb45eeee-a334-464a-a4d1-388ed2d26276	107
eb45eeee-a334-464a-a4d1-388ed2d26276	53
4e0b4507-322b-426f-a7df-c3b5083743d4	53
4e0b4507-322b-426f-a7df-c3b5083743d4	107
547c893d-f4ac-4cfd-852d-141fd74bf0c0	53
547c893d-f4ac-4cfd-852d-141fd74bf0c0	107
9a0140bd-ca21-452e-996a-5379eb4270fb	53
9a0140bd-ca21-452e-996a-5379eb4270fb	107
499ef0e5-5d1d-4aa3-837b-9ecb4c3a7522	108
499ef0e5-5d1d-4aa3-837b-9ecb4c3a7522	109
5aeb91e4-1f31-47e9-b4b0-aa5419ce0985	110
5aeb91e4-1f31-47e9-b4b0-aa5419ce0985	68
f5f61923-6e83-4d31-86de-a46d81d9636b	68
f5f61923-6e83-4d31-86de-a46d81d9636b	110
fd272683-c1d1-420f-951d-92889bae4093	110
fd272683-c1d1-420f-951d-92889bae4093	68
d121cbe4-037e-44a8-b642-8e9c5e15f457	68
d121cbe4-037e-44a8-b642-8e9c5e15f457	110
a910802a-353f-4fbb-9bb6-927a44b458c7	68
a910802a-353f-4fbb-9bb6-927a44b458c7	110
97e538b5-f545-4fbd-b8ca-e02e3cd83bbd	68
97e538b5-f545-4fbd-b8ca-e02e3cd83bbd	110
3af9a6b0-68f8-405f-9e72-d889665a1571	110
3af9a6b0-68f8-405f-9e72-d889665a1571	68
bda25f3d-1ffe-4d72-93e2-1e1f4cda9748	110
bda25f3d-1ffe-4d72-93e2-1e1f4cda9748	68
c79a63fb-aaa0-4365-9c0e-a7a1486164fa	68
c79a63fb-aaa0-4365-9c0e-a7a1486164fa	110
97a2a6b9-3894-452b-b4c0-3a6b290eec8e	68
97a2a6b9-3894-452b-b4c0-3a6b290eec8e	110
cb8e81a5-1e00-4ae4-b156-4acf9ea43d7b	110
cb8e81a5-1e00-4ae4-b156-4acf9ea43d7b	68
2a8ae232-2102-4907-bb10-d27273ec04b8	68
2a8ae232-2102-4907-bb10-d27273ec04b8	110
bc517ac5-c869-4598-a3e5-644523a9b914	111
bc517ac5-c869-4598-a3e5-644523a9b914	67
2a339934-72ce-4a8c-8596-906c91eb436d	67
2a339934-72ce-4a8c-8596-906c91eb436d	111
96cb5435-02fb-45e5-a375-cfa7ea2ebb3e	112
96cb5435-02fb-45e5-a375-cfa7ea2ebb3e	113
86e837b2-6e09-4193-b335-72ce3cd7a6ac	113
86e837b2-6e09-4193-b335-72ce3cd7a6ac	112
6615aacb-5119-49ee-b3f8-5698329c3bf1	112
6615aacb-5119-49ee-b3f8-5698329c3bf1	113
bead87ce-2b39-421b-ab0f-59f0f3a38d44	113
bead87ce-2b39-421b-ab0f-59f0f3a38d44	112
8003d046-de6a-4ef7-a9be-cc1bc2a82e0c	112
8003d046-de6a-4ef7-a9be-cc1bc2a82e0c	113
8f8db73b-d658-4d0a-b837-7394628a9ad0	112
8f8db73b-d658-4d0a-b837-7394628a9ad0	113
0385d096-707d-4755-9d71-9a2b6015dcf1	113
0385d096-707d-4755-9d71-9a2b6015dcf1	112
60f58b5a-ab66-49ee-be75-1b47f29e2871	112
60f58b5a-ab66-49ee-be75-1b47f29e2871	113
4fc37296-db7e-4032-9c84-6b585fc611b6	114
4fc37296-db7e-4032-9c84-6b585fc611b6	113
40618d78-8d5f-479f-96f7-e1dfd020be80	113
40618d78-8d5f-479f-96f7-e1dfd020be80	114
8d0887c1-306b-4aed-b738-7b68f4153e85	114
8d0887c1-306b-4aed-b738-7b68f4153e85	113
fa38c299-624b-4dd6-88b8-23f2f4a4008e	114
fa38c299-624b-4dd6-88b8-23f2f4a4008e	113
0b57217d-48a2-43d0-9ad5-8ef9321dffc5	114
0b57217d-48a2-43d0-9ad5-8ef9321dffc5	113
db409508-f49b-424c-a0ec-0d2048dd929a	115
db409508-f49b-424c-a0ec-0d2048dd929a	90
25a91133-69e8-4aee-ac14-d554a35add59	115
25a91133-69e8-4aee-ac14-d554a35add59	90
98ae76c4-ceda-4285-978b-17455b34924d	90
98ae76c4-ceda-4285-978b-17455b34924d	115
ac192161-54ea-428d-b117-be7a02e2562f	90
ac192161-54ea-428d-b117-be7a02e2562f	115
cf0b9614-845c-4250-932c-7561eabc6d6f	90
cf0b9614-845c-4250-932c-7561eabc6d6f	115
82056b35-4192-474c-9f21-ac79b9f295b7	115
82056b35-4192-474c-9f21-ac79b9f295b7	90
02f42ee2-ed6d-47bf-ae9f-44a28b0c5b16	115
02f42ee2-ed6d-47bf-ae9f-44a28b0c5b16	90
22e80f9a-0b56-489c-abaa-703bc6a43102	90
22e80f9a-0b56-489c-abaa-703bc6a43102	115
91485041-fabb-4152-8a10-1d9683589f9d	115
91485041-fabb-4152-8a10-1d9683589f9d	90
644080d7-d49c-407e-9a81-79a5993f7fac	116
644080d7-d49c-407e-9a81-79a5993f7fac	90
ebc9c64c-fc50-401b-b70d-bee85001d9ad	90
ebc9c64c-fc50-401b-b70d-bee85001d9ad	116
a424bf4e-85fa-45c5-ae76-31307ead1d5d	116
a424bf4e-85fa-45c5-ae76-31307ead1d5d	90
ddc2999d-9a3b-40de-a2f4-c58b8c9423f9	116
ddc2999d-9a3b-40de-a2f4-c58b8c9423f9	90
3be8d56f-c941-466e-87f9-382822a4229d	116
3be8d56f-c941-466e-87f9-382822a4229d	90
9095fef0-de6f-40a2-8d1a-0260657123ca	116
9095fef0-de6f-40a2-8d1a-0260657123ca	90
3b47177f-62d7-494a-9f1b-955ab28bea24	116
3b47177f-62d7-494a-9f1b-955ab28bea24	90
5b61c522-3c53-446c-b666-592d550c1e30	116
5b61c522-3c53-446c-b666-592d550c1e30	90
02c6e47c-29a6-4cb5-b087-954ef5afa36b	90
02c6e47c-29a6-4cb5-b087-954ef5afa36b	116
7594a4e9-b6ac-4844-96f3-21fc8990bdb2	117
7594a4e9-b6ac-4844-96f3-21fc8990bdb2	74
42dd35bd-dde0-4321-b337-a8f1eab0da87	117
42dd35bd-dde0-4321-b337-a8f1eab0da87	74
2bf28a75-2000-4e2c-ad62-09cdc4b3f58b	74
2bf28a75-2000-4e2c-ad62-09cdc4b3f58b	117
ad278642-432b-4373-b6c4-0edcca891e5e	74
ad278642-432b-4373-b6c4-0edcca891e5e	117
92e16207-f569-4b2b-931b-155bb1967da4	118
92e16207-f569-4b2b-931b-155bb1967da4	58
51a1715d-4ee9-4ce3-8c75-f52d1e2c63fa	118
51a1715d-4ee9-4ce3-8c75-f52d1e2c63fa	58
82802ef2-70cb-490c-9dc4-d72ce2634874	118
82802ef2-70cb-490c-9dc4-d72ce2634874	58
bf0de82e-eb20-4cbf-8a65-205d571242d0	118
bf0de82e-eb20-4cbf-8a65-205d571242d0	58
2608c991-3e84-4636-a240-efd690b0b8fc	58
2608c991-3e84-4636-a240-efd690b0b8fc	118
34b92a9e-a787-40f1-84d0-c95b7bf337c5	119
34b92a9e-a787-40f1-84d0-c95b7bf337c5	66
74e380fd-279c-405c-a75b-9b8d71b82a2f	66
74e380fd-279c-405c-a75b-9b8d71b82a2f	119
d1b21d54-03dc-4c44-8d24-d0ec3331d9c8	119
d1b21d54-03dc-4c44-8d24-d0ec3331d9c8	66
e14d3c92-3c1c-4210-baab-2bc8ec1adca1	119
e14d3c92-3c1c-4210-baab-2bc8ec1adca1	66
f3283039-1654-42a4-87da-2c60a74d7046	66
f3283039-1654-42a4-87da-2c60a74d7046	119
\.


--
-- Data for Name: vocab_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vocab_types (vocab_id, type_id) FROM stdin;
58b7563c-e5d6-4247-b3e7-af5b988f0fe1	1
5f686bca-6f57-4565-b363-ff65dfda2c20	1
bf58df5a-d024-4b7a-b4e4-0b6e07c5692c	1
c97b145b-085f-4f27-a01a-b0601bcd2e2c	1
87d4927c-4a8f-48d9-93e3-71e8a35e0770	1
5e53247f-dc44-425e-b70b-fce4cf245048	1
34c7d346-eac6-43ef-9b8d-847b8066fe56	1
1f4716d3-0144-486c-82aa-6495c04a6799	1
e206b6cc-471c-4a64-a87c-df46ea12e232	1
64edc678-01c8-4291-9fd0-efd330d6dead	1
e2510cb1-8178-42de-904b-5e2cdc3680b5	1
af1fa1c5-5267-4719-b4fa-408685ad52a9	1
35e482f6-8fdf-4107-be24-7a13fc9ab4ea	1
fb618efb-dd79-4c8a-a01d-704ea630b694	1
4316bf87-bd18-41f3-a620-9d8c441e27d8	1
24339e86-67f9-408e-b3a3-166c182d6518	1
ad763e27-5b69-4861-96a5-a42a9dbce021	1
08e548ce-597a-4436-9dd4-a57170647d66	1
28b70b3d-16a6-497f-8498-216a7d343bd9	1
0e2ef3c3-c24d-411b-b1f6-50ce0a0b0b93	1
037af387-d58d-4ebd-8a60-6c503ac5aedf	1
86b7b2f4-5b79-4989-b5a8-4aa896601498	1
0059b1b9-2bf4-4db9-8872-cdba778a7c4a	1
e45bd462-9ee0-40a0-9f6a-41f174e03d81	1
41bcd0ee-915b-46d3-90e9-c1285d1bceee	1
6a11f8f5-fe19-4755-a962-bb5a0c345945	1
1fe3a9a6-f87e-432a-8d18-461941881e3e	1
8658c8fa-0c19-420e-8b9f-8a70c1c09db0	1
aee63a03-282c-4783-9659-7c4e58729e08	1
45caabd5-5ec7-4b41-b3cc-d43bc4047d8b	1
f1900639-c9bb-47a9-a4df-8997fea9ae8a	1
21a1882b-4e95-4e7f-8ec6-df31df1b25d4	1
17ebbd48-d223-4e40-a8ff-3b30bb4d0eb6	1
7938c7b3-6a81-4fcd-844d-ede72c3e5182	1
cc06f961-f972-48ff-9821-cf763ff6dd6f	1
d9d403ee-cf64-424c-8e60-a14567b6c266	1
af19b21f-2ba9-4f1a-b46f-4ed316273510	1
97fa16a3-6483-4a5f-99f1-2c0fdc612769	1
5cc1da45-ca89-4c72-90d5-60c30b2cfaef	1
e38ad6ce-f5dd-47a6-be59-913ece323015	1
185f8b7b-750b-457a-aba8-27a14eaaed1a	1
47c922c7-2b04-4aa4-93f3-c18f6eea74d5	1
e829d14c-9a3b-4c71-9e6d-3c52df6e291b	1
f33f8d0d-d2be-4096-ac65-dc876229a7d4	1
088b3bc1-3254-4f71-a22f-fdec555a2f68	1
39a9c680-00ff-46cb-b6b4-87fc66554a58	1
b910d755-212e-433e-8f32-8902f9af58e2	1
5f6d0f07-e66d-443d-80d4-a3a4125970ee	1
b2bd866b-a85a-4222-8646-6284d014b3e5	1
31713db1-5f9e-4172-bfe9-30e0f1f44f54	1
3268aad5-b1e6-4c23-b261-743a30b40232	3
1e8ae068-1f58-455c-ac7a-c697a8188e43	3
d0b068e5-3c67-427d-b572-b50190b87f3a	1
4d25d71c-b640-47f3-bd18-79d18f647af4	1
543e1a08-a254-4834-a3da-53209b0ac86f	1
5d7bb7be-a862-4ee1-9206-ba4ab7383d4e	1
0e199588-ffb8-459e-a9ba-e925afde0484	3
0e199588-ffb8-459e-a9ba-e925afde0484	1
63ff7a9b-0fc5-4843-a9e2-a91d008352ad	1
cc7a67ed-c412-463b-b1ae-ec999ebfd541	1
590302b0-026c-421a-9d7f-0428ccf29f73	1
ab7b7066-6c3b-40ff-8231-1274cd87b060	1
e0e43a0e-4abf-4437-986d-368d8e6d24b9	1
4bfc41a7-c669-4147-932d-da637599141c	1
47c4f2d3-2a46-4f95-b994-8764c92410fa	1
64cb0d69-d84e-43a4-87d1-6e3b9c888c24	1
9f281d66-8f92-409d-ba4f-279ff217567e	1
2c8db310-fe7d-4a62-9ff8-6140759f109f	1
d539284f-c0ba-4a2b-997c-b292b9d86827	1
3a93694e-ce24-4f35-95b3-37dd5fde7689	1
fdc1979e-e28d-4904-9ebc-6e22ba6e4f1e	1
0c5b29fe-04ce-417d-9c4e-1419b948bcda	1
68706170-5a79-49be-9371-f0650fd14601	1
63fd5fd0-dd1c-4bcc-83e0-200ea0337a2d	1
4c5c09be-4268-450d-87f8-af21a4dec46f	1
a60badcc-3af7-466b-bbd0-378eb3e6f0e4	1
7a1f7fc7-6ec6-4d21-b2d6-49e160d4b0f2	1
cf3ebbbd-6a07-4e8d-bf54-9cfaad027461	1
38fc3d91-6588-4459-9b7d-94f4788282c2	1
6d247664-56b0-4e34-b36f-e8086e06ce4a	1
227cf445-3087-4c52-adc9-c62c007738bb	1
dad42817-a33a-414c-8aaa-1d5279a12b10	1
13dae049-f118-467a-a92d-8bb8d60972d9	1
efa6819a-3158-4e1d-9539-464864424900	1
24b57e8e-7f33-4c2e-9538-460412a1e1ea	1
62ed2bc7-e0cd-43c1-8431-7edf99a7c9d0	1
be5b2186-183b-49c2-8cea-faa78967c64d	1
904d53ad-38f6-4ded-bc45-2ed4cc4e8c97	1
c1dbd43d-5bb6-4a8f-b430-8ae2e1016f81	1
54f20198-84f9-4d33-bf14-f3e0b2f4f75f	1
541f631f-fb45-4013-90df-deb45a6d6189	1
62295023-3013-4628-aeb9-53af85fd8102	1
a78755cd-da4c-49f0-ad26-4c8f2013ed67	1
9bb8f157-d9bd-4516-a9fc-a9b76a1b0d83	1
1a798fd3-45ab-44ac-9759-16cfbc3fc7af	1
bc103d34-24b7-4106-9cc3-c4e1bd851a4f	1
4711f64a-1c24-48de-bb09-216106a92dc7	1
98719bee-acca-40c5-bf37-d8d95801d074	1
b60705ea-abc9-42e2-af58-801b061579cf	1
e056c667-b697-467a-863f-51d6670df651	1
1e4e851f-baff-4b7e-8cf6-2c8044b471dd	1
180edcd4-46ac-4d9d-a395-cc82d8b847c4	1
9bb3aae0-7450-4779-8fcd-8477dfa4d33a	1
17e58498-23d2-4fe3-880d-a80dcdc6be39	3
c059b61d-5ec8-42b3-af2f-30fbe7adf207	3
ebabbc8b-d4fb-401a-90cb-40d0ff2faeed	1
90c6eae9-2edc-4d7a-a04b-2d84343fafc5	1
059d371d-b0c8-4060-8ae6-a35d289aec63	1
63096843-6c2a-435d-aeb3-75415a0d0766	1
76582247-c5d7-4467-8b52-b66e2c15e3d3	1
273db95f-caaa-484b-9271-7ccf824c2e0a	1
10637f29-3d56-4637-843a-355963309f19	4
4306447e-ec18-48b2-9955-c38e9bf44fbf	4
60828f58-fa9f-4dd6-876f-0dad07f38002	4
d6848be3-b8b9-446d-aa9b-f5985d7bf899	4
46e463c6-f993-4ac0-b822-9328d57c2892	4
810662d1-ab8a-4663-8fc3-c931b10dd6b8	4
c64e91ed-a4de-40f0-ae4d-4dba3a15eab3	4
1ba6bb83-98fb-42ee-8f10-0b066d90371b	4
2c722a1d-95bf-4b90-b036-88c8ed8c8f08	4
c3c35ad5-d432-4a36-8c20-62a9a77a859a	4
ac1aa8ce-cf62-4613-a929-bb4b737bae8d	1
af0916df-4290-42a5-a159-9daba0868084	1
b6965dbd-2a87-43da-ab75-de3ec685c3eb	3
7ab926a2-46d5-4910-b7c0-35802e5a1579	4
34ab08ee-acec-4875-b03d-d769da7491e9	1
0266836a-bd98-40c6-9812-1c7aa269e3bb	1
db0d32e4-0922-4be7-b020-199e06c32f55	4
32700459-168d-4e22-9490-9606926dceab	1
0de79a43-2db1-4f7b-ae50-bd3a445fa872	1
33c061fc-5aa8-4869-bd42-e2c471469370	1
7f410a5d-03f1-49ec-80a4-4bc282657f0f	1
584b2697-a8eb-4de3-b3e6-1ade63945494	1
96a15691-80a1-4234-b7f3-d5e44bb9b2c0	1
13132532-c0e1-4a61-98bf-4e1fb2d66568	1
9fcc8998-5a6d-4705-8508-e005d798d63c	1
56b81922-f7e4-42cb-9b0a-89dfc0c3183f	1
cc86bab1-f9f1-47db-8369-c4252922df7b	1
161f6154-c084-4898-890a-015b39eb42e1	3
7a26dcad-4d50-4b0c-8c53-a23166043658	1
462d68a3-1e44-4b18-a7ae-d4b119c745dd	1
2aa891f9-8a1e-4135-8d0f-16134dcc1c87	1
8b86e29d-2e02-4d4c-8c9a-b89a73f15b64	1
273c68a5-4801-4dad-8f0b-4b128fe33bcf	1
ca06b295-05a8-42b9-9bc9-ef6f8e148156	1
a5502a23-407e-45e9-9488-719cda6d3b1f	1
84293344-9a6b-4082-9659-2a6472e328b9	1
04f1818e-646d-4510-8b6e-1c1c93ce80fb	1
bdc7adbb-b50a-4359-9892-fa9a136391fc	1
e183362d-287f-400f-8087-68866e47fa1c	1
a569b63c-2bda-418c-8188-0b4b01fd2bd3	3
a569b63c-2bda-418c-8188-0b4b01fd2bd3	1
61d8a4ff-e4a7-42af-8d1d-d902b4884d4a	1
a10bc160-2171-40df-aa82-b5e6e9b2fae1	1
474debf2-4c1f-4fc0-b9c7-4140b63e95ef	1
3125e20a-d165-4aff-9d55-b02ceaf9bd91	1
6abad213-f06c-43d5-953e-64ec4864f26d	1
62ff4cf0-b5f0-4152-b1b7-cbb439602a69	1
68cc9749-b93e-4a9a-8b32-af3da0242308	4
2c7ce3cd-a77f-4ea1-a778-9a0019a63f8d	1
2c7ce3cd-a77f-4ea1-a778-9a0019a63f8d	3
2f1c2f81-61d8-4841-ab92-895ede3a12e3	1
90ffaeef-fac6-48c3-b6bd-765e8d0df1b8	1
cf83d4b4-ca5c-46d5-b577-8d8775d4f59c	1
b8adc413-e1ea-4cbc-bf3a-de5e54422c68	1
a10ca209-b213-4931-9db3-39353bf1fc67	1
90704d3a-6c4f-41ca-b5bd-eb25cf8e0350	1
f58dc7ab-3f9e-4ffc-a470-ebf4b60a5ff6	1
5f237721-d474-496a-aaef-af413c73ab94	3
5f237721-d474-496a-aaef-af413c73ab94	1
f5ec30f6-38a1-4572-a63a-dea823c185ce	1
6df073a8-a7c0-4d79-b152-e0567e028d9a	1
6382cd6d-4be7-4ac6-9140-6f46e5405e5d	1
0eb4799c-5fdf-464f-b9af-34116cec97c6	1
c8032d80-c17d-4a7c-a688-2a82a89ddb6c	1
79c2cefe-1534-4d67-b950-2ab12955d037	1
3a8e1d14-2947-4e93-ad35-8d525d76e4fd	1
288e3a41-7e33-461f-b39a-c6457ff0ad71	1
b075ba8c-e91f-44df-8fc3-4eb47574ab59	1
f780f3e1-e7a3-4c96-b73d-91eab2aecbf1	1
212124d0-0491-4206-be63-75754545e091	1
326b2934-6132-4ed3-8b20-778906803704	1
61b3d15a-1dcf-4400-b540-02557e12d026	1
901ba8aa-4629-45ed-87d3-73d57e83aa47	1
9ad54faf-3409-4d21-9d52-50851425e208	1
8ef50ef0-a0cd-466a-8577-5ee6542c27ef	1
6f5f1fd3-7541-4562-97ea-a0f0b8c1aff8	1
f76e999a-d0df-41fd-937f-a358d6270c6f	1
5e189710-8a5e-4a07-8cda-05086ae5157f	1
d231736a-7bc7-41d0-943f-9c88cdb554f7	1
2fb0f237-15ad-4c43-8ade-b1128757f072	1
a8bd4319-92ec-4e5b-bf4b-862e425b0e5f	1
4b2680dc-8759-416a-8050-47f32e083b5b	1
1b777676-18be-4f3a-865e-d0e4cc8355d4	1
70be0f81-0376-4d3f-9015-ab7b33ea0f87	1
08984518-6f1e-46ca-b124-7f49fdc31320	3
08984518-6f1e-46ca-b124-7f49fdc31320	1
b0c08b44-ef53-4899-b184-636cc140d033	1
04b36d23-8503-450f-a502-a36c8d1e7404	4
7c3aaa5c-42b5-4d70-88b2-3aa93a10ca81	1
aaf4fd01-bd53-4bba-8a6d-bce8c1bb6d8d	1
aaf4fd01-bd53-4bba-8a6d-bce8c1bb6d8d	3
e0b2d1f6-d455-4a8d-a281-e8a96f1a0e7a	3
a81f2eb3-0178-4f9b-ac91-b2b8f97fc118	1
b1a974e2-9a37-40b3-b1db-7dec651fa698	1
d9e06405-62d0-42e8-9585-e57adf1cf7bd	1
e59b1c30-7f29-4932-8d6a-06925d737687	1
ab34318d-5656-4705-b2cf-187a06375d27	1
2db7a213-5b39-480e-bff3-a73026219d51	1
a60f3ccb-35ce-44d3-a5fd-0d3ca2e96cb0	1
fa7e5492-bc6c-409a-b01c-ba70f265dfc9	1
1a51ba3c-0209-4bc0-a5bb-d3ca4524cf12	1
e924ee87-6cc9-4f94-af4a-98bf9a3da519	1
2438686e-3383-4faf-9910-381bf478bf51	1
89680f43-6a58-4b4f-8e1d-e3c87244472e	1
0c08794c-62d4-474b-99d9-deeda83be44c	1
c2fb73eb-bd37-46ce-aacb-061882fa4013	1
138914c1-ff61-4a63-9262-c9b6ed9df6e9	1
aae75efe-ecd1-492b-bbf9-45d50dbc4adb	1
0a667169-c8a6-4cbb-9ffa-49679555a257	1
cad5490c-fb56-47d6-b305-0a405feac0a0	1
a2a19947-1fb0-41b5-9cbb-24e178d26943	1
6f7fec37-6d4a-41b0-9daf-c238b27d90db	1
43e39897-4db3-4150-9017-5a979ae0df8e	1
77f37be5-480e-49ea-90fc-d001d2147393	1
0d9ac936-4341-4d40-ac94-6230317134bf	1
5dcd8440-97d5-4b1e-963e-4579cc6a9321	1
2d98770e-3968-47a0-b0fe-4d8ca2fcd820	1
d458076a-8a88-40a5-8178-0fece3760843	1
a9abecfe-4806-4102-bc45-0ef517592ace	1
a7019348-f7e2-4048-9bf3-a03074d9cfd4	1
596c8b71-cfb5-4138-9a9f-c0ee6736e313	1
3b2ec59a-d3bf-450f-90f9-45729add3d26	1
754ee5d5-00ef-4687-946b-7663e0fd8892	1
aa4e84d7-1079-435d-a496-9a698793cbcd	3
aa4e84d7-1079-435d-a496-9a698793cbcd	1
679609ac-0041-4c59-a34d-89272baf43f4	1
90b4aafd-5b1e-46be-92cd-75637aa0cb88	1
5683217c-29d0-436a-bdb4-de2f8f19a598	1
549b62b0-9c23-47f1-8187-ac64854ed3a2	1
2d53adf8-5c8d-405f-bc04-ac98f774de6a	1
58ea3eb3-47fb-4e94-86a1-5dd1eca3a71b	1
4b14fc39-8e56-4aed-b694-8b5fb3d31ada	1
c31f10a1-91ce-49f8-bd19-a4f64d244465	1
6518db6d-b5c5-44ee-9364-49d202b9106f	1
c65b6c05-39d5-4115-b135-ed4cd4799c31	1
e7511db6-6161-44f1-884d-b9eee2401726	1
67fd00f3-6393-41e4-87ff-1cfb55ae1ad7	1
ded24a41-25fa-4a77-853e-0ad89a541afd	1
381f11dc-9efe-47cd-8117-6cb02b725f23	1
27ea2502-0665-4013-9239-146eb6222757	1
ee7cb0a6-2f47-4f1d-bfdb-f3571739cb31	1
ee6e9102-f858-4984-9a4d-f5da69aecc1f	1
3868e67d-696e-4ab0-9280-063e05780ea9	1
efee7125-5017-4626-81c8-ae53ce375fbe	1
1fe7d6fd-6f7e-49cc-bae1-6e4a2e20de14	1
bbd04f28-8621-4bc2-9a4c-db7250d24323	1
bbd04f28-8621-4bc2-9a4c-db7250d24323	3
a0056831-6ce7-4cbe-9842-538510e22800	1
ce01825f-4a63-4b92-9ae5-875bff0c837d	1
cf83d964-cb5c-4bee-a213-3b2f83ed453c	1
76c82257-9299-4830-99ad-03131a692695	1
453d983a-41e1-4534-9d22-bec95353736f	1
c5b8311e-6bdc-4f94-a159-367aae082058	1
45bb9ead-c0ae-4291-8efd-7dc5275f0ef5	1
521c44c1-5d36-400f-9c5e-a23439050a90	1
e6d116d8-17b8-4c87-b92f-6954e807eee0	1
46d0d450-8fec-40f9-b771-f98ac72cb218	1
5cef2d1c-b47b-4fdb-ac52-b372971e5ef5	1
7afeac1c-2f17-4f41-a90e-6bb7be3d36ba	1
4d4d6cbc-62ad-4708-b42b-30f05720f05f	1
7c47c8b6-bb6c-41fb-b1a9-cfc5476ccf99	1
3a96ac6b-dcd1-4a7b-b5f8-2d958d5539a3	1
4df08286-0192-4aeb-9c5b-b4f4461d8fce	1
eaa0cb57-a623-4a1c-955d-81a9ffa7be03	1
5be08d51-c68c-4b3f-b3c2-61fcf5cb43ff	1
11e6e1bc-d34d-4d5c-9466-3116eaf0ed3b	1
8321ffad-fe48-4827-a523-c3989dd0675a	1
375c06f1-20f6-4585-b7a5-dae14cd23213	1
3df97d03-9562-4ebf-93de-720e5b3338ab	1
9d16b245-249d-4709-ad6c-e283bf2be619	1
a9d78901-672d-43da-b728-978e84567cfa	1
f60b50e1-ab40-4fa2-b4b0-015adfa3f792	1
c06ba2f7-8fbe-4309-b0f6-07707ed5000d	1
d5ce75e4-585e-498a-8107-7e4e82d9bafa	1
d81f6146-8d68-46f5-98f8-4ff4baa78290	1
69137dbd-5ef0-48bc-a37c-6cbcf5d84e90	1
ebc3298b-25d3-4f4c-ae2a-338ae140bda3	1
32ed7fa5-a6f1-4c43-b8c9-b9bf09a96428	1
a832de10-033d-4e22-b602-a57f9710b473	1
4df4ab6e-6bf8-4f15-8ed2-923986f015a9	1
864b2621-cba0-4a18-bc39-f973b5dd5c41	1
88aa9c3c-c3c4-42db-97b6-f1358cac803e	1
7660ae0e-2fff-43bc-bfd9-038645f48bf8	1
02b950ae-fee7-4c39-81b7-93f9336dca9b	1
1239a73e-f141-40a0-8ac5-a6dbd8908045	1
b5d6adfb-303b-4325-9a17-a9d895a7f053	1
7ed4a483-9581-44ad-bd90-a7d2caf72b91	1
010f277b-490d-4e11-9b6e-600b6a00a66f	1
fc12e2dc-912f-47ec-9a50-7cccced58cc7	1
629ec111-04a6-4f04-8f25-8c0d658e96af	1
efaa5ce0-8ad2-416e-8b49-a7ba7e67f208	1
320c8f1f-aaf1-442d-831e-5dc89a5aa054	1
b1b74240-e55e-4ca1-a0e2-29067fb389bd	1
1ed89d76-8fca-4ebd-98a0-cfffedd9be11	1
d2fc65c0-52d8-4a3b-8dbf-341c034bd590	1
ac8861be-cc76-4bc2-bfdf-7c93caebe90e	1
b357fa38-d1a4-4613-947f-7be8675bb591	1
ee582b94-430d-417a-88c5-35f0de227e58	1
befcbc13-db42-49a5-b394-6560b60e51fd	1
3654ddcf-0c85-4761-8a9b-1265ee1b2bde	1
4940bc8c-1d3b-4a10-bd75-41047fd455e7	1
4940bc8c-1d3b-4a10-bd75-41047fd455e7	3
94f51b7d-163c-44c0-889c-0240e935c91a	1
c8eca88f-9ba5-4f94-ac82-3883105102cf	1
c8eca88f-9ba5-4f94-ac82-3883105102cf	3
1396744e-d891-401f-b5dd-3d052b8f6f96	3
1396744e-d891-401f-b5dd-3d052b8f6f96	1
de7126d7-9d89-4284-b656-7f6002208558	4
51dc45ef-a0aa-4ac5-a6e4-b8a119602f78	4
64758780-d379-4991-8aa1-006bb062174d	4
01254977-2ebe-4447-8492-4573a307005e	4
e0ef842f-849d-440f-a4a3-080227c89e93	4
fa51392c-9410-405d-abfb-f599c693ea4a	4
26193f2b-c221-41a6-b94b-74b3106c0fcc	4
49d132ec-1046-4178-9ab3-7501fc7c0944	4
9372cf72-5cc2-4625-8146-264a328406a8	4
1fb1fabe-3e03-4228-8aec-442da4065036	1
6d4e0c8b-22b1-4078-bfbb-c42a47bdb1c2	1
42cc50bf-4d06-4e8f-93ad-a61d4da50614	1
bcdf2be9-16bb-43b7-857e-37e6d928e28a	1
50673261-9279-4b72-a146-0c31fe5300b6	1
f022eed0-6488-4618-95db-c50d6a8bb51b	1
e5ccf03c-5424-49a0-b6ec-54554ba1d4f9	1
7f57664a-79ef-4a88-8a99-31810d16ef69	1
af76284a-289f-49f3-a760-be152bed0502	1
85dd49fd-5be8-48c1-a1e8-b8c39c57084b	1
3c716cec-8f3f-4543-9173-8b3ea1ba82df	1
d586c332-67a3-4adc-934b-72dc74decff1	1
d586c332-67a3-4adc-934b-72dc74decff1	3
bc376700-8217-4a83-814d-0efdce5baa76	1
f3156f0a-6d2b-4a22-92a3-c866a8dcf605	1
a8aeb122-ebbd-4727-b626-50e834153873	1
3d376050-92e3-47a2-a71a-cc6e7e2a9a13	1
b635d05f-ad6f-4f3b-9d02-52364677205d	1
9653310a-5c16-461d-a2dc-492a24677edd	1
b9cc41e6-a4f3-4f01-bf1a-fa79b648322a	1
be2348e6-27d5-4e93-9550-0bb136793d02	1
548f2700-27d5-49e2-9e0a-7e50d34c18f0	1
8e7c4101-4ecc-43b2-91cd-5f0692c3409d	1
ed78c44e-d82b-4398-b96d-106cdc54eb3d	1
10109c3c-1c8b-436d-8ea5-d81adc6e3cb8	1
3994ab27-f60a-40dc-863b-d343e2a436e4	1
6dccae02-79fb-4b5c-8bab-8582455b9ece	1
8b91ab1f-312a-4dac-9929-6667fc418a0f	1
63382b7c-03cc-40cd-9133-9152b2c3346a	1
f9860988-56b5-4f41-90db-ca52b721c304	1
6d67c37d-d0eb-44cc-8bd3-5d3583c45928	1
62c3bcd6-606d-4458-b37a-f582609fdeb3	1
df8806e4-e4a5-4aca-a100-94b0320c50ca	1
75df9462-3698-4f0f-8df3-4c7f07776958	1
86605566-91b4-4bdc-99c1-0ea26ea26933	1
f177ca54-42da-46a8-967d-dded3256f62b	1
f75cd964-753f-4a5c-9d20-a096e09d6893	1
daa5c1a0-0ea7-4bec-8cf8-9bb8408aa3aa	1
4f0cd45e-dae5-4f37-a3b3-87685c307783	1
c2791686-8b0a-47c8-a65a-533b68d15222	1
119d919a-dd6c-4eec-a0b0-c7280e98a639	1
6c33d855-a64a-4585-bf42-be988826d0b1	1
4bec0ceb-af9b-4fd6-ab28-35477e65ac21	1
7850bc93-7891-4814-8917-57af1f272e90	1
b528b374-eb09-4336-b06e-5ea9271fd390	1
b010b77b-a49e-4fb3-862f-c15588e849ff	1
6d54d5dd-ba47-450b-80e0-6f4e3d068b89	1
4e21806d-bae8-4993-9690-9c9456510ddb	1
a65685bd-5de1-41a1-9eb1-ec758057d9b1	1
12b60a14-b5d7-45fa-922a-1c1b77c8cc3b	1
74c9f5c8-7126-484d-9e29-1e0883e26d80	1
74c9f5c8-7126-484d-9e29-1e0883e26d80	3
830c9ca7-c911-406a-aac6-caf4630d12cb	1
53abf7cb-6bfb-42f3-b3a1-882d335c36a1	1
1f2112c3-6d51-4c0e-884c-188d785f4409	1
a6d284ed-0dcc-4437-aade-1cfca79591fb	1
b2ff7598-8c0e-4508-8410-cb75ff0de59b	1
1e6d9955-9fd2-450b-9fa3-02dadcec9b3c	1
8419243e-9fed-4440-94d2-5a1eff090cce	1
0f72e2f8-d3ab-4e25-917a-ec6d7441abc3	1
6853f4b1-7c31-4774-8a09-5fc06de1a227	1
6853f4b1-7c31-4774-8a09-5fc06de1a227	3
6399d03b-291b-4f5e-87cd-8d47ac1b6a36	1
daeac45d-a40d-410b-9d47-e91cad9db759	1
ec8243e7-c96a-4b22-90e5-ec9271414e57	1
3a93c64c-ba3b-43ba-b420-3465647d3abf	1
99342083-9250-4be9-82a6-1131c091ce18	1
6be67608-8412-4e97-b87c-ffef811b600d	3
6be67608-8412-4e97-b87c-ffef811b600d	1
4b28459c-8236-49ad-b72f-ef345f67cd55	1
fa6ed463-3bfd-406c-ae34-672f36090354	1
aa4d011f-19fa-4617-bc60-ec598ed6ddb8	1
40f072b9-6bda-45fc-9a89-e748d8c0f428	1
d721da1e-9419-4508-8a97-6ca6333bd379	1
46e999ce-c312-4ae5-ad2f-6d74b122f54c	1
b9d445b6-0064-4e78-8427-4c7e433afe08	1
3cd1685f-8082-4a41-80fa-b07cae255376	1
257176ac-4845-42e5-a0e5-a6c0c3255b33	4
4a6e301c-fe33-4c67-a718-148ef4d5b2d6	1
45ea8c80-2e55-4c0c-a429-1d96576fcadf	1
45ea8c80-2e55-4c0c-a429-1d96576fcadf	3
53fc66fd-f80f-483c-a412-d7b0ba325a55	1
53fc66fd-f80f-483c-a412-d7b0ba325a55	3
803c2b1e-5272-4011-8102-5d6d115ef135	1
f1d68be1-44ce-4f0e-bffc-fa6f28b669b4	1
ec2b718b-a2dd-449e-83d3-868875ad579d	1
2e6fd08a-7133-4292-b30b-a1f6f65822e5	1
72b8c5e2-6168-4927-b758-9c46cbb1a602	1
88d2fae9-669e-4a72-9cb4-4d312e8da912	1
be3517e2-04f4-47b9-a3f4-97747694d2e5	1
67cec151-d0c1-443d-99fe-7f2b726f01b7	1
1095ba50-88c2-49c5-92f0-76064b90e0ca	1
554381b5-fa4d-4688-8921-a03960c03bd2	1
21c90780-f66e-46c9-ae20-b841304a64cf	1
a93aab17-7596-4722-b221-802b2913a656	1
e877cf96-c733-4b5f-8114-130198437563	1
c7fdfd6a-eff1-41ff-a6ba-7226844f0218	1
aca76173-8925-46ac-b543-866b771b130f	1
04e0f2e8-3206-468b-b31d-d8bb1f9ccc7e	1
6f9afab8-b43b-49b0-bf36-f995c1057349	1
4b986ae8-c4b1-48a3-a668-a54307d2e482	1
d3106bfa-da5b-47ce-b12c-9040baa3a0ff	1
d3106bfa-da5b-47ce-b12c-9040baa3a0ff	3
de7bf23f-0c55-4f21-a2f4-7f754d753bf5	1
841da8ef-9320-4f20-ac66-a7743299ae03	1
d4ea243e-e8c2-45d8-ae3a-294fc7a248ab	1
0ad8c7fe-c5e8-4c19-a0fc-78cba7f52f4b	1
27b2c02b-656a-4bd8-bf7e-623448e2af6b	1
f6449c21-0a8c-4d42-8040-096b46de4bb2	1
a814171c-b882-4541-8828-faa19e232b88	1
c8a28113-178c-4685-b390-b43aa361d9b1	1
572f5961-3b53-4595-8844-2fe7113f8a36	1
7645e3f2-d33d-42c7-88b0-c90faf1f839d	1
850223a1-7b7e-434c-810d-f2c64feca497	1
32d891c0-f376-4c10-8f00-dd034b053b73	1
1c671f9b-b271-4f02-8880-c9454060646a	1
72a0ffd4-cd07-41bb-9bcb-bda6491d5846	1
a932b9d4-688b-4109-8d88-43fb61e78137	1
685dc8b9-b03a-44ae-8b6c-5ee6ba56ee21	1
31b5c2db-7017-4c1c-b314-6af119da397f	1
3725020a-e0d8-47f8-a822-a5ceb9570747	1
9597a1fa-bf39-4e97-abff-1e24ac0c0496	1
e85e6fc0-e162-4ed7-92b5-206060044294	1
75d00137-9049-4c63-afcc-8030a53d4dda	1
2e1c3430-c811-484d-856a-415f860ff281	1
ff282b9b-35b9-4c4c-9e3a-99f8a7192bca	1
a8fd5c97-43aa-433b-9b88-39cbae469032	1
5adcfd89-1152-4748-b626-90cab5b913b7	1
87883ed9-e12c-49cb-81d8-cf4315e9349b	1
18b0f067-a10a-4c66-9d27-f3b062721c23	1
3e5ab82c-f469-4efd-8e40-7f9af702cd4b	1
669dedfa-3e08-42a1-bc09-291438e654b9	1
6df72cca-a3dc-4cf1-bf1e-02a7e51d306c	1
4367d0a5-f9b1-4c92-b58d-c6735c7df2d5	1
86d447fe-c5f1-4133-a60d-0256e9541b5f	1
8822fdd1-24bf-491a-8de3-6b5fc21dc074	1
3b2d0654-1dbf-486c-b8fc-d9c2c5944b35	1
48178cb1-c1e4-472a-900d-4bf164a752a5	1
7fea3d8b-90ee-4f7d-a28f-571e7eedbf95	1
cdeb3bc1-8258-45c9-ad8f-85dd7feb3a9f	1
9a771b4e-4b54-42db-85f7-0262ef349e46	1
60223308-3723-4dc7-9569-4b7b744ab2ac	1
f667a905-4e7a-493b-969c-e7e92efc0cdd	1
bd7e4d67-9971-4e60-9e18-a275b9ccd639	1
b02725a9-c914-4ed8-8701-326c375071fa	1
509caa1d-9a7b-47bd-848a-6c76d58dde04	1
1b2fad33-8744-4877-9d1f-54e8d48ca38a	1
a793ad5b-d0fd-4ad1-ba29-10deb496e84e	1
6f4797ea-dbc9-49ad-a33c-94b5e7e76954	1
5e6b19af-da93-48a5-8b5c-83e8e22350e4	1
5d5ca654-556c-4ae2-af29-f1c3af3314a1	1
ce1af51a-e499-49df-b414-eb5421a92103	1
c83226b6-1928-4f13-a2be-09275ec25a9f	1
84b23dcf-efb6-4b54-a9d8-28e3bf3fe5c8	1
105b4aad-e4b4-41cb-8f17-11501595a42c	1
f95fa30c-31d8-45bf-ad42-d506cc4d55e1	1
b7ca1f07-abc9-4941-992a-069e313bf3a2	1
fdc7e851-3115-438a-8b55-0a770c1b830e	1
8a623eb6-5c61-43a5-8b89-a019a1beee6b	1
949612a0-8be8-44e1-9d7a-332cecae5d9b	1
3d9d1167-6077-4e36-add8-e27273938068	1
2294e059-a5db-4c62-8c9b-7aa5b64421e6	3
2294e059-a5db-4c62-8c9b-7aa5b64421e6	1
0d2c7c71-e6ec-4576-b344-b6e85f1df693	1
f6624c5c-23d8-4914-9bdc-9e24438accb4	1
d06d4c80-8a57-493b-9b6f-e20ee3938482	1
e4b4b6e5-427f-4e81-a92a-9416eb484a23	3
e4b4b6e5-427f-4e81-a92a-9416eb484a23	1
28bc7a62-9c62-4bc2-ab9d-772356929321	1
b62ca336-49fa-48c0-8f7f-a0edf3d8a5c9	1
5de0140d-eb1d-47eb-9a38-c682b7b7e418	1
2f328dd6-0494-45c2-abef-f1875d5a0e6d	1
e4dcc1e7-b923-4562-839f-d534597b8e54	1
30794320-b4bb-4324-8daf-9bcd05a56427	1
3e7b9a5f-58a7-4900-bce5-76c815e6eee0	1
db751582-55be-423c-8906-77d362f9a2cc	1
8f275fa0-f699-437a-a627-aa85778c15ff	1
1481203f-4e3a-45bd-b05d-b83e22600efe	1
626ce20a-f028-41d1-8d6a-3d6415404b65	1
9605b764-b0c9-4209-951b-545f44695166	1
1f938ce9-0381-4685-b154-39a9b86f8500	1
97dccdaa-0f5d-4b2a-afd9-ee886e7bee33	1
72754622-4da6-439e-9094-afd84c9147ae	1
90ceb93e-2885-4594-b7fb-8826cbd6aed6	1
a0137d63-afcb-4b28-a482-8d9ea8a30598	1
382c5d89-d8bb-4d6d-a404-0e567efae4a3	1
4baaf54b-e985-44ab-a6fd-dd86a13ff00e	1
405b165f-7bed-45bd-8a35-83f53abe01ef	1
514637a2-36f3-427a-bae6-48b401c7dadf	1
1e9f47da-1276-4f64-87f5-af4bb2de30b2	1
feb22a4f-8ca3-47be-9f77-73633e8cac87	1
feb22a4f-8ca3-47be-9f77-73633e8cac87	3
fea0d429-99a2-4c19-9637-07bf182b7983	1
fea0d429-99a2-4c19-9637-07bf182b7983	3
0a2e8432-7519-451e-bdf2-73582f37b73e	1
ea8a749f-cb4f-4416-97d9-983ff8976f1a	1
9d967a61-5752-4f31-9ae1-f75afd17434e	1
c36131f1-1b10-45ee-bb94-e134d3f58f08	1
a0a4b2a1-cd99-4cd3-a45b-b805b284ac73	1
1eb5e75f-3e77-4149-9b56-e9ba539e4c03	1
1eb5e75f-3e77-4149-9b56-e9ba539e4c03	3
1c7c759c-ec31-480b-a2e9-d5a6240e2645	1
5d7fc569-c59e-4f74-a380-3f3a10e2811f	1
76708d13-3556-461a-b254-386e469e69d9	1
ab54442b-fd73-4767-99e5-398dd4b19707	1
6ba28a5a-471e-4083-b91d-11b8d48461c9	1
509c1bd0-a388-422a-8769-4afbc0efa7be	1
d9580e28-c329-4afe-83c0-83c2ede40cc9	1
e93073dd-5fbc-4e07-9c6e-3603b0b82421	1
4b965609-7921-47fd-af6b-9ecfd6199289	1
4e94a729-ca31-4f9a-81a4-20d43b23553e	1
4611b319-7124-46ad-b837-1cacb0b3a740	1
1fb3a057-b4be-493e-8b5b-5497633557fc	1
8c732e30-7933-4e36-8249-6275c3990ada	1
01c605cb-7f85-4f78-83a4-b3b92359414b	1
9a631f0a-6c67-4df0-bf72-1f3b18f17990	1
ddb3565e-3b5e-4106-a53e-5109f4f69b34	1
e05bdc20-f4af-439d-b7a4-90c51869550d	1
2c563240-772f-4d1a-b2fa-c21faf4d76f3	1
1c67dcf5-26b7-46de-9cd6-02006602da91	1
7cadac02-c2db-45f4-b686-0a8226ede13e	1
b13526b9-7385-4d75-8194-15fc9501a72b	1
e1dda565-6e15-4183-a684-129c52bb1a73	1
70a1cd58-5008-446a-b303-d2e2d61e8dfc	1
f097a098-dd7e-449f-9521-1dcaeba20ec5	1
677bb0f5-f574-4c9a-9535-137618ae50f9	1
45b62747-23bc-4928-af2d-e8a40505fc0e	1
e2f92315-82fd-4764-a8ea-7256633802b9	1
cb479c78-c152-4db6-b62a-3daa3dc7de6c	1
ad92b3ca-2370-4aec-892a-3148259919b9	1
5c7f0254-ab95-4f62-a71f-3e3e0f63d8de	1
18ebe3fb-e67f-4c97-aa19-de9b3157c429	1
9a77ffd9-cb63-4cec-b955-644b2f967a63	1
b71d1650-de86-4d85-b96c-7ae3b292fae0	1
cdc8fb15-da7d-4399-91e8-f1198a3ddc23	1
b69223b4-d9de-4d97-964f-19e48b6288f6	1
d9264521-5a7b-42b8-a15f-1de7899e0109	1
cdd1ef0c-1f23-405a-848f-95e7ff299d6e	1
d4bc5119-f4b5-4d5f-b679-82d4d9fec828	3
e6a3ddf7-5f14-4187-a1f0-d4de0065c0f5	1
e6a3ddf7-5f14-4187-a1f0-d4de0065c0f5	3
95dcc931-02f8-4d30-9de6-81d897c27f2b	3
c3d41e13-d185-40d8-83e8-9322dde44e2e	3
cb5fd2e7-54e6-4d7c-a631-950e69626271	3
e3996ff9-748c-4045-82da-54c8f23676fb	1
c756854c-164d-4e4b-af55-5733ada6ad25	1
d99daa4d-e8f0-451c-b346-054d478cc369	1
a6e52495-3418-4bf8-8c53-b095eac5223f	1
de8ffe11-5db4-40f8-bfe5-f94292fab106	1
d4f8e3c3-6014-4a7a-8f89-a1a465092a60	1
5f13718b-403a-47eb-ba7d-5d962cfb3bf8	1
aac06803-eba6-468e-bb10-07c7004a144d	1
2305bd17-e2d8-48b4-9cb6-129142f9df37	1
90452f4e-b01c-4497-bcf4-040afb5cbd2c	1
cbbf1d07-ef68-4472-a181-9861bd98a346	1
54b6cf22-8049-454e-97d6-2aecc4b81646	1
91d0fdb4-146d-431b-9984-cbe81f6de1fc	1
7a09f2ea-1ff8-4b01-912f-38824ad34d1e	1
db35d19c-891a-450d-96f3-60c04061b58f	1
6b65a2e6-9286-4933-b544-a6e6220353c9	1
6b65a2e6-9286-4933-b544-a6e6220353c9	3
5e5063ff-4619-4f49-a463-36d8882d5868	1
b0e95b64-d0f8-45ac-bfb5-0644144cdaa8	1
5e466f08-c63a-40a2-9a85-bd76189adb4b	1
6c86b220-d897-4970-b95b-f14a59e45086	1
9fd6af8a-eed5-4212-b8c3-96b6667cd482	1
69a77995-4a29-475a-a7c6-7b7091105a09	1
a2517c65-d423-46bd-ac3f-abb1be982e31	1
234cf56d-e721-4816-b07d-a789b33e36b7	1
234cf56d-e721-4816-b07d-a789b33e36b7	4
1ea28ae0-55b5-4fa4-9549-e929888f71ce	1
55599a9d-fc78-4a74-bb58-d310be81402e	1
bc6544bd-01f8-4ddd-86ae-e8869d0a141b	1
4b581df1-8c71-4a6d-8fbe-1600ef59acd9	1
4b581df1-8c71-4a6d-8fbe-1600ef59acd9	3
5ba8947b-125b-4e51-89e5-72b8de894dc6	1
6b3d66f1-95d4-4c80-89ab-c8626b42343c	3
6b3d66f1-95d4-4c80-89ab-c8626b42343c	1
693fe39d-8914-4805-86eb-cca7a657f311	1
f39be50c-2d84-4dda-8def-3cfbeca4942d	1
ac093c3a-9c80-44b3-b08f-45df2da3562d	1
688672df-4526-440f-af3d-adf4ca533df3	4
688672df-4526-440f-af3d-adf4ca533df3	1
5db16109-fc90-4747-a5c4-5ed1becb49fc	1
d06ed3e7-914c-463a-909f-de1dc4489962	1
7b2e802c-3bc1-4748-a10e-e99db52bf561	1
36c3ec36-9233-4799-864f-43b92e8d4017	1
a08d0770-c967-47df-bd9c-9213893196dd	1
8c0ae6cd-4456-48ef-871d-413984717c04	1
8a9f224b-bddb-4168-a5b4-67f4265813cc	1
b52e56ed-029e-445c-8e92-d2b80f3398ba	1
08cbab15-b6e4-4964-9ec3-57498b16fc91	1
b623b4af-4323-49ca-bd12-6e7006c0a204	1
a7ea18ed-5809-4a6d-a54d-8fd9b1f6e1bd	1
dd7fb716-191b-4033-b3e6-ababe25780f1	1
dd7fb716-191b-4033-b3e6-ababe25780f1	3
b306027d-c1dd-40e2-add0-cbfe1c56f371	1
4306fb3b-f572-4498-9434-b89bb9741340	1
08141e11-5ed8-485d-9ace-6149f87a3744	1
1e0bec3a-108d-4b84-8806-35e65b2f7ca4	1
f6ce6220-67c3-4199-9501-9ea2c593c6e5	1
d8be77c1-096c-4e4b-a786-73307726ab19	1
d8be77c1-096c-4e4b-a786-73307726ab19	4
a73b7584-85ad-4310-b68e-5d6d0237da39	1
782dbdac-7ba7-4d07-856f-555bfad005bb	1
b3364089-a364-4a7e-bfa9-e0b9b93d797e	1
160c94bd-8139-4f2c-96d3-18ee0c6ca7d8	1
35518f0b-e443-4980-945a-1f715f080265	1
21099f91-65a4-4250-ba23-85d92553c5ba	1
f772a646-5588-4060-978c-14bf3104870d	1
0f9b1333-caf2-47e2-9f5f-e10c0d19252e	1
9071d528-f356-413b-b6b3-a3b8a168f872	1
c66d603b-0764-4f24-a8e7-e47ff0cff1c3	1
9ac9684f-1f2d-40a0-a4b6-d9ecf9a344d7	1
f2d3c699-fab2-4275-a0df-e27ff89151f1	1
acaa7eb1-e1fe-4fea-a595-e21e85491a2e	1
5a677e39-ca9b-48e2-87af-8d4bd4de1e95	1
9fcf4011-2901-4f3a-8ce8-24fc4448b6ba	1
b5d2633d-cef9-44de-b067-a2887371feeb	1
8aae4914-2af6-45e8-9a15-1dfc0af43d9c	3
dee0ba45-aa47-4963-bad1-c9535fa3f0bb	1
ad8d4724-f1e0-4e94-9717-f80a418c607d	1
1d07efd9-c210-44e7-9bb5-90b61d02d923	1
0ae6f709-7a8c-4ab9-a170-9780a3ab2790	1
00cee702-8be3-4a95-a97a-af6936a05873	1
147ec701-da5a-4ad5-9828-608382af5b84	1
721f3e98-7a9a-415a-a2f3-dc9d38f5f414	1
f2fb5530-e5c8-48bc-8f8c-7fc1006850f7	1
ed4a3f21-01b4-42fe-beea-be5d80b7167f	1
fccd63b7-af2a-47f1-afd4-2510e78a0fc6	1
2ae2e4d4-607f-4c81-9e4a-b158f394859e	3
2ae2e4d4-607f-4c81-9e4a-b158f394859e	1
14fe6c8a-eac5-46c4-b1d5-62817daf1e78	1
14fe6c8a-eac5-46c4-b1d5-62817daf1e78	3
8dda7592-45b7-4d36-aa90-d77899eb6a20	1
ea7a9840-e31c-449c-a87e-6ec03e65aa8f	1
4843714b-fcf2-4889-80b7-337fc38f60bd	1
3bbb2b8b-41c3-4b06-8512-64ec84e4e402	1
032187df-beb1-4707-9947-7f8ee61259ee	1
92b8e6f0-804d-45b5-8cef-2bd874e157af	1
66ed1f11-e7f1-4362-ac73-93012a85fbbc	3
66ed1f11-e7f1-4362-ac73-93012a85fbbc	1
2c3c0ee4-0a72-4ea1-9187-9474845a644f	1
2c3c0ee4-0a72-4ea1-9187-9474845a644f	3
4a91ad24-9c24-4b0a-885e-4a3926890b41	1
8be66ca4-38da-43f3-b78d-415f3428674d	1
61efb3b4-24ad-4244-92b2-f0c2feb5c648	1
61efb3b4-24ad-4244-92b2-f0c2feb5c648	3
1e0d7b91-0196-437c-b0dc-8e020bb035ac	1
b92d9a3b-8221-465d-a51f-8e595eb13001	1
3ab5a4de-5c62-4336-916c-76218f356382	4
e4c934ab-afac-473c-a668-3f9153095f1e	1
4b211b45-b61b-4656-ad5d-ce4dd19e56bc	1
9c0b5906-f6d9-44ca-95bb-1b88eebe227f	1
6ee4cab8-d247-4681-a9a4-64a3eec28263	1
3831aca6-deb7-4737-9d1f-3f763e76d53b	1
71ccdbff-cdb8-420e-9dd4-b969dd027798	1
fedc4968-5036-4f07-b5c1-02da0c7e0f89	1
c5242118-e645-4997-94da-c258df490a2e	1
7b9949e1-3263-4ef0-9797-f2a01a682411	1
74e1f67d-8872-4a40-852a-b460e3d7aa86	1
5436c34e-4288-4164-a9f7-c60a15bddbd9	1
9b87a142-1cac-451c-8ef0-4bb4f34d5e48	1
d134cb8c-4e65-4b8a-9805-3baecd222021	1
aacc96ba-8409-4130-8d1b-006405af356a	1
d27b18e4-0688-48c6-bb49-2412319272cc	1
0a49e6eb-40d1-473c-8e7a-589389e03233	4
0a49e6eb-40d1-473c-8e7a-589389e03233	1
e4d1bb28-bcc8-4561-8899-f31551eeaa25	4
e4d1bb28-bcc8-4561-8899-f31551eeaa25	1
c83e1718-4557-4dbe-8f6c-adc237f9245c	1
c83e1718-4557-4dbe-8f6c-adc237f9245c	4
08cfc2ef-009e-4d28-8b70-72cb21ff0b8e	1
a7c3202b-8ef0-4697-b719-cb5cbd4c478c	1
abada2ba-197c-46fa-9d20-34d9844aed2b	1
73a4caf7-5f43-444a-86e2-c962a1b6468d	1
8ba50fc1-df40-40c6-bf44-e183208c021b	1
8e3e95df-79c2-4630-8a4a-5282ad1cca3c	1
3262ab29-8fb4-4cf6-88f7-b5c5f6a8b21f	1
f908de00-2030-43fb-94c0-171b5c4c718b	1
38fad0f0-dc36-42e0-89f8-5feeab404413	1
1d999b41-1ea1-4fba-9012-1f5d7a170753	1
2d3d4fc8-26ca-49c5-97f6-d10220a402bf	3
2d3d4fc8-26ca-49c5-97f6-d10220a402bf	1
e0b4806f-c318-4e7c-b459-4db8b3d544be	1
b9ee40fc-cda1-4574-8945-2f9fd0fa897b	1
10a7c159-43c8-41eb-947f-544f5eac1ecb	1
c9fc9529-0694-4985-adbf-a69dde03ed21	1
e5772443-ce05-481a-91cb-ec9a0b709215	1
f51fcc18-fbc8-4e22-84fc-8c20bfaef8b9	1
c6183c1e-59d0-4f46-831a-43f2a7124b08	1
ee826772-c967-4fa2-87be-8ea0134700c5	1
895ebdd8-5189-437d-a5cc-66398173ae64	1
d05318e9-4674-4643-a927-a9cccd82b5f3	1
0e275ff6-28a7-4111-b085-7b57e5811d56	1
6cae8abe-fb2b-4f35-8a53-7f47ffddbfa9	1
1d360df8-d1b7-4bac-8877-8f8cf8f1c1ad	1
c5fe5ad2-4cb4-43a1-b749-eb09b64a6c37	1
353856f1-c5f3-4cba-a895-5ee5c5876fe0	1
1860d6b7-4484-460b-af88-333b43880c06	1
c4ec5912-259e-47e8-bf65-aec7177f8ca3	1
a6ac2b2d-a26f-4398-b36b-70bdcd3cf3b7	1
f2b01b3e-593f-4f4e-82f3-de574676e79d	1
a6ba2a2c-cfd2-4df7-90aa-66e0b0895c6b	1
34535e43-7658-4967-b4cf-a2097aaa2d20	1
b8d945fb-c29c-4733-89ee-06b5d3d2c407	1
19ad1db6-0008-4922-834b-fc4a4dab829d	1
e331e4cf-28ef-4cbe-9a4a-1e0899aa29a0	1
f38de71c-917a-478f-a37d-331a777fbb35	1
c1cea1da-ae4e-4ea7-8c43-b02dcefbed4a	1
d87723b6-239a-4f63-ba07-b0788ba2ddf8	1
62847eca-5dc3-44a7-b323-8abca1f30553	1
5b13ecf7-9a49-4989-9578-0287fbcc3a2f	1
d5309492-806a-467e-af76-94b02ecbda44	1
20fa3db0-2bb1-4893-9417-634ce70bc0d6	1
8c6a80a1-f18e-40b4-bd09-271f71535dcf	1
50cfea3a-7c16-4787-8566-628892ed550d	3
50cfea3a-7c16-4787-8566-628892ed550d	1
47cec108-f0f3-410c-ad50-c8a95ddde5c4	1
77cd027d-e01c-491a-b8d5-78346f4ff542	1
5c4659b7-af82-4eb1-8a40-deb1686fa27e	1
a87ba1b3-4bb9-492e-bd8c-f1026a4d1c57	1
f0c223a8-7cc8-40a5-8697-5b6afeec7de6	1
5564e0a5-0ec8-4669-8e69-c26b66670cd7	1
76c8ff48-e28d-4e79-a06a-79b922460a21	1
3e75dd6a-74ad-4f0c-befa-c4cd00da8491	1
e4d7947e-52a7-4a9d-8ef1-8fb6771ce30a	1
0e96a1ac-ae6d-414b-b362-69131aab1b4c	1
b775e25c-12b4-4518-bf50-fa834650c4ce	1
75d72a27-a432-4690-936e-1d8970435cf7	1
99d1272c-3794-44ef-8b5a-cbc35a5ca3ed	1
a9d0b29f-cb30-489a-b736-b5eff81ef6b2	1
de43def9-5b4d-41de-b1be-d6579daa2b8c	1
f0b3075d-476c-48ee-a3a0-e60619ce8f4e	1
1385ef47-7644-463a-a535-770542e5122c	1
37092294-0ce3-4c96-9820-67b64fadbb73	1
ab8c30b6-4ab2-4851-9a1d-a0334ba7206e	1
e13c5ae7-5524-4e08-af5a-598c843f6fc8	1
983428bc-0d18-4ef9-a6a7-e157faa8f627	1
c3396dde-e9c2-4ad0-97aa-526c87a0fe98	1
6c9226f8-26e5-4dde-8786-c555d9c962a8	1
5eed014e-ae0d-4580-bd61-11a7a67a3bb1	1
5eed014e-ae0d-4580-bd61-11a7a67a3bb1	3
b211d13f-ba1c-455c-af5a-85581f6c7e88	3
b211d13f-ba1c-455c-af5a-85581f6c7e88	1
2c1bb589-6eae-4a61-9670-8a75041af02d	1
1874d770-c999-4f37-980b-ab9a499a68d5	4
6c7427bb-c202-4fc8-9db3-df0e066c7d61	1
d1dc14f9-4f6c-492b-abd2-28ac48260a3a	1
2edcb120-b531-448e-bb0d-879c198f6c36	1
74e8a803-1361-4b5a-ad72-272206aa48ef	1
2fb52aca-f436-449f-b7d7-de3e61ca5d07	1
b60373d5-ffa9-4629-8975-51073b205ffd	1
fdd3d6d7-c4d5-4218-a5ab-38b2e404331f	1
dd3acc71-d3c9-4fb4-bdf3-a320acc2f070	1
c0af76d8-1522-4e6f-b0a0-84f0a9e39537	1
f9eeb2d3-9d6f-4470-9e0d-aee44a3367f8	1
72ae0734-3280-4e96-bbc6-c1ad004e4c70	1
eb45eeee-a334-464a-a4d1-388ed2d26276	1
4e0b4507-322b-426f-a7df-c3b5083743d4	1
547c893d-f4ac-4cfd-852d-141fd74bf0c0	1
9a0140bd-ca21-452e-996a-5379eb4270fb	1
499ef0e5-5d1d-4aa3-837b-9ecb4c3a7522	1
5aeb91e4-1f31-47e9-b4b0-aa5419ce0985	1
f5f61923-6e83-4d31-86de-a46d81d9636b	1
fd272683-c1d1-420f-951d-92889bae4093	1
d121cbe4-037e-44a8-b642-8e9c5e15f457	1
a910802a-353f-4fbb-9bb6-927a44b458c7	1
97e538b5-f545-4fbd-b8ca-e02e3cd83bbd	1
3af9a6b0-68f8-405f-9e72-d889665a1571	1
bda25f3d-1ffe-4d72-93e2-1e1f4cda9748	1
c79a63fb-aaa0-4365-9c0e-a7a1486164fa	1
97a2a6b9-3894-452b-b4c0-3a6b290eec8e	3
97a2a6b9-3894-452b-b4c0-3a6b290eec8e	1
cb8e81a5-1e00-4ae4-b156-4acf9ea43d7b	1
2a8ae232-2102-4907-bb10-d27273ec04b8	1
bc517ac5-c869-4598-a3e5-644523a9b914	1
2a339934-72ce-4a8c-8596-906c91eb436d	1
96cb5435-02fb-45e5-a375-cfa7ea2ebb3e	1
86e837b2-6e09-4193-b335-72ce3cd7a6ac	1
6615aacb-5119-49ee-b3f8-5698329c3bf1	1
bead87ce-2b39-421b-ab0f-59f0f3a38d44	1
8003d046-de6a-4ef7-a9be-cc1bc2a82e0c	1
8f8db73b-d658-4d0a-b837-7394628a9ad0	1
0385d096-707d-4755-9d71-9a2b6015dcf1	1
60f58b5a-ab66-49ee-be75-1b47f29e2871	1
4fc37296-db7e-4032-9c84-6b585fc611b6	1
40618d78-8d5f-479f-96f7-e1dfd020be80	1
8d0887c1-306b-4aed-b738-7b68f4153e85	1
fa38c299-624b-4dd6-88b8-23f2f4a4008e	1
0b57217d-48a2-43d0-9ad5-8ef9321dffc5	1
db409508-f49b-424c-a0ec-0d2048dd929a	1
25a91133-69e8-4aee-ac14-d554a35add59	1
98ae76c4-ceda-4285-978b-17455b34924d	1
ac192161-54ea-428d-b117-be7a02e2562f	1
cf0b9614-845c-4250-932c-7561eabc6d6f	1
82056b35-4192-474c-9f21-ac79b9f295b7	1
02f42ee2-ed6d-47bf-ae9f-44a28b0c5b16	1
22e80f9a-0b56-489c-abaa-703bc6a43102	1
91485041-fabb-4152-8a10-1d9683589f9d	1
644080d7-d49c-407e-9a81-79a5993f7fac	1
ebc9c64c-fc50-401b-b70d-bee85001d9ad	1
a424bf4e-85fa-45c5-ae76-31307ead1d5d	1
ddc2999d-9a3b-40de-a2f4-c58b8c9423f9	1
3be8d56f-c941-466e-87f9-382822a4229d	1
3be8d56f-c941-466e-87f9-382822a4229d	3
9095fef0-de6f-40a2-8d1a-0260657123ca	1
3b47177f-62d7-494a-9f1b-955ab28bea24	1
5b61c522-3c53-446c-b666-592d550c1e30	1
02c6e47c-29a6-4cb5-b087-954ef5afa36b	1
7594a4e9-b6ac-4844-96f3-21fc8990bdb2	1
42dd35bd-dde0-4321-b337-a8f1eab0da87	1
2bf28a75-2000-4e2c-ad62-09cdc4b3f58b	1
ad278642-432b-4373-b6c4-0edcca891e5e	1
92e16207-f569-4b2b-931b-155bb1967da4	1
51a1715d-4ee9-4ce3-8c75-f52d1e2c63fa	1
82802ef2-70cb-490c-9dc4-d72ce2634874	4
bf0de82e-eb20-4cbf-8a65-205d571242d0	1
2608c991-3e84-4636-a240-efd690b0b8fc	1
34b92a9e-a787-40f1-84d0-c95b7bf337c5	1
74e380fd-279c-405c-a75b-9b8d71b82a2f	1
d1b21d54-03dc-4c44-8d24-d0ec3331d9c8	1
e14d3c92-3c1c-4210-baab-2bc8ec1adca1	1
e14d3c92-3c1c-4210-baab-2bc8ec1adca1	3
f3283039-1654-42a4-87da-2c60a74d7046	1
\.


--
-- Name: game_session_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.game_session_details_id_seq', 111, true);


--
-- Name: game_sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.game_sessions_id_seq', 47, true);


--
-- Name: games_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.games_id_seq', 3, true);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_id_seq', 1, false);


--
-- Name: packages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.packages_id_seq', 1, false);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 2, true);


--
-- Name: topics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.topics_id_seq', 119, true);


--
-- Name: types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.types_id_seq', 12, true);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: game_session_details game_session_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_session_details
    ADD CONSTRAINT game_session_details_pkey PRIMARY KEY (id);


--
-- Name: game_sessions game_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_sessions
    ADD CONSTRAINT game_sessions_pkey PRIMARY KEY (id);


--
-- Name: games games_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: roles idx_role_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT idx_role_name UNIQUE (name);


--
-- Name: user_vocab_progress idx_uvp_user_vocab; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_vocab_progress
    ADD CONSTRAINT idx_uvp_user_vocab UNIQUE (user_id, vocab_id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: packages packages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.packages
    ADD CONSTRAINT packages_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (id);


--
-- Name: topics topics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- Name: types types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types
    ADD CONSTRAINT types_pkey PRIMARY KEY (id);


--
-- Name: types uk_17go525ou3scbmd4pcftq130f; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types
    ADD CONSTRAINT uk_17go525ou3scbmd4pcftq130f UNIQUE (name);


--
-- Name: users uk_6dotkott2kjsp8vw4d0m25fb7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uk_6dotkott2kjsp8vw4d0m25fb7 UNIQUE (email);


--
-- Name: topics uk_7tuhnscjpohbffmp7btit1uff; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT uk_7tuhnscjpohbffmp7btit1uff UNIQUE (name);


--
-- Name: tokens uk_868xfj44b89t1voh058wevbqg; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT uk_868xfj44b89t1voh058wevbqg UNIQUE (refresh_token);


--
-- Name: games uk_dp39yy9j9cn10v9vhyr2j1uaa; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.games
    ADD CONSTRAINT uk_dp39yy9j9cn10v9vhyr2j1uaa UNIQUE (name);


--
-- Name: vocab uk_km7blpn65sakml18nhnnhvxfc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vocab
    ADD CONSTRAINT uk_km7blpn65sakml18nhnnhvxfc UNIQUE (word);


--
-- Name: tokens uk_na3v9f8s7ucnj16tylrs822qj; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT uk_na3v9f8s7ucnj16tylrs822qj UNIQUE (token);


--
-- Name: user_game_settings uq_user_game; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_game_settings
    ADD CONSTRAINT uq_user_game UNIQUE (user_id, game_name);


--
-- Name: user_game_settings user_game_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_game_settings
    ADD CONSTRAINT user_game_settings_pkey PRIMARY KEY (id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role_id);


--
-- Name: user_vocab_progress user_vocab_progress_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_vocab_progress
    ADD CONSTRAINT user_vocab_progress_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vocab_packages vocab_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vocab_packages
    ADD CONSTRAINT vocab_packages_pkey PRIMARY KEY (package_id, vocab_id);


--
-- Name: vocab vocab_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vocab
    ADD CONSTRAINT vocab_pkey PRIMARY KEY (id);


--
-- Name: vocab_topics vocab_topics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vocab_topics
    ADD CONSTRAINT vocab_topics_pkey PRIMARY KEY (vocab_id, topic_id);


--
-- Name: vocab_types vocab_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vocab_types
    ADD CONSTRAINT vocab_types_pkey PRIMARY KEY (vocab_id, type_id);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: idx_game_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_game_name ON public.games USING btree (name);


--
-- Name: idx_gs_game_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_gs_game_id ON public.game_sessions USING btree (game_id);


--
-- Name: idx_gs_score; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_gs_score ON public.game_sessions USING btree (score);


--
-- Name: idx_gs_started_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_gs_started_at ON public.game_sessions USING btree (started_at);


--
-- Name: idx_gs_topic_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_gs_topic_id ON public.game_sessions USING btree (topic_id);


--
-- Name: idx_gs_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_gs_user_id ON public.game_sessions USING btree (user_id);


--
-- Name: idx_gsd_is_correct; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_gsd_is_correct ON public.game_session_details USING btree (is_correct);


--
-- Name: idx_gsd_session_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_gsd_session_id ON public.game_session_details USING btree (session_id);


--
-- Name: idx_gsd_vocab_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_gsd_vocab_id ON public.game_session_details USING btree (vocab_id);


--
-- Name: idx_notif_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notif_created_at ON public.notifications USING btree (created_at);


--
-- Name: idx_notif_is_read; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notif_is_read ON public.notifications USING btree (is_read);


--
-- Name: idx_notif_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notif_type ON public.notifications USING btree (type);


--
-- Name: idx_notif_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notif_user_id ON public.notifications USING btree (user_id);


--
-- Name: idx_package_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_package_name ON public.packages USING btree (name);


--
-- Name: idx_package_topic_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_package_topic_id ON public.packages USING btree (topic_id);


--
-- Name: idx_package_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_package_version ON public.packages USING btree (version);


--
-- Name: idx_token_refresh_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_token_refresh_token ON public.tokens USING btree (refresh_token);


--
-- Name: idx_token_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_token_token ON public.tokens USING btree (token);


--
-- Name: idx_token_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_token_user_id ON public.tokens USING btree (user_id);


--
-- Name: idx_topic_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_topic_name ON public.topics USING btree (name);


--
-- Name: idx_type_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_type_name ON public.types USING btree (name);


--
-- Name: idx_ugs_game_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ugs_game_name ON public.user_game_settings USING btree (game_name);


--
-- Name: idx_ugs_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ugs_user_id ON public.user_game_settings USING btree (user_id);


--
-- Name: idx_user_activated; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_activated ON public.users USING btree (activated);


--
-- Name: idx_user_activation_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_activation_key ON public.users USING btree (activation_key);


--
-- Name: idx_user_current_streak; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_current_streak ON public.users USING btree (current_streak);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_email ON public.users USING btree (email);


--
-- Name: idx_user_last_activity; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_last_activity ON public.users USING btree (last_activity_date);


--
-- Name: idx_user_roles_role_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_roles_role_id ON public.user_roles USING btree (role_id);


--
-- Name: idx_user_roles_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_roles_user_id ON public.user_roles USING btree (user_id);


--
-- Name: idx_user_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_status ON public.users USING btree (status);


--
-- Name: idx_uvp_next_review_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_uvp_next_review_date ON public.user_vocab_progress USING btree (next_review_date);


--
-- Name: idx_uvp_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_uvp_status ON public.user_vocab_progress USING btree (status);


--
-- Name: idx_uvp_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_uvp_user_id ON public.user_vocab_progress USING btree (user_id);


--
-- Name: idx_uvp_vocab_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_uvp_vocab_id ON public.user_vocab_progress USING btree (vocab_id);


--
-- Name: idx_vocab_cefr; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vocab_cefr ON public.vocab USING btree (cefr);


--
-- Name: idx_vocab_packages_package_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vocab_packages_package_id ON public.vocab_packages USING btree (package_id);


--
-- Name: idx_vocab_packages_vocab_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vocab_packages_vocab_id ON public.vocab_packages USING btree (vocab_id);


--
-- Name: idx_vocab_topics_topic_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vocab_topics_topic_id ON public.vocab_topics USING btree (topic_id);


--
-- Name: idx_vocab_topics_vocab_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vocab_topics_vocab_id ON public.vocab_topics USING btree (vocab_id);


--
-- Name: idx_vocab_types_type_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vocab_types_type_id ON public.vocab_types USING btree (type_id);


--
-- Name: idx_vocab_types_vocab_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vocab_types_vocab_id ON public.vocab_types USING btree (vocab_id);


--
-- Name: idx_vocab_word; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vocab_word ON public.vocab USING btree (word);


--
-- Name: idx_vocab_word_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vocab_word_type ON public.vocab USING btree (word_type);


--
-- Name: tokens fk2dylsfo39lgjyqml2tbe0b0ss; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT fk2dylsfo39lgjyqml2tbe0b0ss FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_vocab_progress fk33pgqxu66c8cqcxntofkb4y2s; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_vocab_progress
    ADD CONSTRAINT fk33pgqxu66c8cqcxntofkb4y2s FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: vocab_packages fk3sqns36r7ayiuuveolphgoid6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vocab_packages
    ADD CONSTRAINT fk3sqns36r7ayiuuveolphgoid6 FOREIGN KEY (vocab_id) REFERENCES public.vocab(id);


--
-- Name: vocab_packages fk68qcf97frw1gb3ira0swjrvs2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vocab_packages
    ADD CONSTRAINT fk68qcf97frw1gb3ira0swjrvs2 FOREIGN KEY (package_id) REFERENCES public.packages(id);


--
-- Name: packages fk6au9rillwif46gs2ns21omn3j; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.packages
    ADD CONSTRAINT fk6au9rillwif46gs2ns21omn3j FOREIGN KEY (topic_id) REFERENCES public.topics(id);


--
-- Name: notifications fk9y21adhxn0ayjhfocscqox7bh; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk9y21adhxn0ayjhfocscqox7bh FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: game_sessions fkb1wbt36yrcq4dbrjgneswj7q6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_sessions
    ADD CONSTRAINT fkb1wbt36yrcq4dbrjgneswj7q6 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: vocab_topics fkbprb148uajmbg8iyldutvvtgb; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vocab_topics
    ADD CONSTRAINT fkbprb148uajmbg8iyldutvvtgb FOREIGN KEY (vocab_id) REFERENCES public.vocab(id);


--
-- Name: game_session_details fkc5ypsx4atnxtbp3nwmn65aa68; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_session_details
    ADD CONSTRAINT fkc5ypsx4atnxtbp3nwmn65aa68 FOREIGN KEY (vocab_id) REFERENCES public.vocab(id);


--
-- Name: game_session_details fkcgnhrkxuaeiamytg1gtscunu9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_session_details
    ADD CONSTRAINT fkcgnhrkxuaeiamytg1gtscunu9 FOREIGN KEY (session_id) REFERENCES public.game_sessions(id);


--
-- Name: vocab_types fkfabr2gt9t8gq2o5sbvlqeni04; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vocab_types
    ADD CONSTRAINT fkfabr2gt9t8gq2o5sbvlqeni04 FOREIGN KEY (type_id) REFERENCES public.types(id);


--
-- Name: user_vocab_progress fkfiilqe47oy4tqrnhjut9k795m; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_vocab_progress
    ADD CONSTRAINT fkfiilqe47oy4tqrnhjut9k795m FOREIGN KEY (vocab_id) REFERENCES public.vocab(id);


--
-- Name: game_sessions fkgpy7f1n4exl7o8hvngciklah3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_sessions
    ADD CONSTRAINT fkgpy7f1n4exl7o8hvngciklah3 FOREIGN KEY (topic_id) REFERENCES public.topics(id);


--
-- Name: user_roles fkh8ciramu9cc9q3qcqiv4ue8a6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT fkh8ciramu9cc9q3qcqiv4ue8a6 FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: user_roles fkhfh9dx7w3ubf1co1vdev94g3f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT fkhfh9dx7w3ubf1co1vdev94g3f FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_game_settings fkid0uayock06pjyd23fj5doibb; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_game_settings
    ADD CONSTRAINT fkid0uayock06pjyd23fj5doibb FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: vocab_topics fkk443gx9afaho5in6vykrxcy9t; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vocab_topics
    ADD CONSTRAINT fkk443gx9afaho5in6vykrxcy9t FOREIGN KEY (topic_id) REFERENCES public.topics(id);


--
-- Name: game_sessions fklg198vj4h7ejkp6n710neylxx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_sessions
    ADD CONSTRAINT fklg198vj4h7ejkp6n710neylxx FOREIGN KEY (game_id) REFERENCES public.games(id);


--
-- Name: vocab_types fkm941banl9315i644h1l8htolv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vocab_types
    ADD CONSTRAINT fkm941banl9315i644h1l8htolv FOREIGN KEY (vocab_id) REFERENCES public.vocab(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict XArqdT7gogVufntiBNj2pBvD3BnxIoeguSnapdGXiJrWY92g9vKWEC8aBWdXdur

