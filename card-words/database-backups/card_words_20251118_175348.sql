--
-- PostgreSQL database dump
--

\restrict Cc6JvX4wpIduzDNUrtzPXO07PNrzkGe9X1C7ctTaC0ejt8gyJdABSNDuIapcgTS

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

ALTER TABLE IF EXISTS ONLY public.vocab_types DROP CONSTRAINT IF EXISTS fkm941banl9315i644h1l8htolv;
ALTER TABLE IF EXISTS ONLY public.game_sessions DROP CONSTRAINT IF EXISTS fklg198vj4h7ejkp6n710neylxx;
ALTER TABLE IF EXISTS ONLY public.user_game_settings DROP CONSTRAINT IF EXISTS fkid0uayock06pjyd23fj5doibb;
ALTER TABLE IF EXISTS ONLY public.user_roles DROP CONSTRAINT IF EXISTS fkhfh9dx7w3ubf1co1vdev94g3f;
ALTER TABLE IF EXISTS ONLY public.user_roles DROP CONSTRAINT IF EXISTS fkh8ciramu9cc9q3qcqiv4ue8a6;
ALTER TABLE IF EXISTS ONLY public.game_sessions DROP CONSTRAINT IF EXISTS fkgpy7f1n4exl7o8hvngciklah3;
ALTER TABLE IF EXISTS ONLY public.user_vocab_progress DROP CONSTRAINT IF EXISTS fkfiilqe47oy4tqrnhjut9k795m;
ALTER TABLE IF EXISTS ONLY public.vocab_types DROP CONSTRAINT IF EXISTS fkfabr2gt9t8gq2o5sbvlqeni04;
ALTER TABLE IF EXISTS ONLY public.game_session_details DROP CONSTRAINT IF EXISTS fkcgnhrkxuaeiamytg1gtscunu9;
ALTER TABLE IF EXISTS ONLY public.game_session_details DROP CONSTRAINT IF EXISTS fkc5ypsx4atnxtbp3nwmn65aa68;
ALTER TABLE IF EXISTS ONLY public.game_sessions DROP CONSTRAINT IF EXISTS fkb1wbt36yrcq4dbrjgneswj7q6;
ALTER TABLE IF EXISTS ONLY public.action_logs DROP CONSTRAINT IF EXISTS fk_action_log_user;
ALTER TABLE IF EXISTS ONLY public.notifications DROP CONSTRAINT IF EXISTS fk9y21adhxn0ayjhfocscqox7bh;
ALTER TABLE IF EXISTS ONLY public.vocab DROP CONSTRAINT IF EXISTS fk7qogloulpjcrjq1hyby2jf9f5;
ALTER TABLE IF EXISTS ONLY public.user_vocab_progress DROP CONSTRAINT IF EXISTS fk33pgqxu66c8cqcxntofkb4y2s;
ALTER TABLE IF EXISTS ONLY public.tokens DROP CONSTRAINT IF EXISTS fk2dylsfo39lgjyqml2tbe0b0ss;
DROP INDEX IF EXISTS public.idx_vocab_word;
DROP INDEX IF EXISTS public.idx_vocab_types_vocab_id;
DROP INDEX IF EXISTS public.idx_vocab_types_type_id;
DROP INDEX IF EXISTS public.idx_vocab_topic_id;
DROP INDEX IF EXISTS public.idx_vocab_cefr;
DROP INDEX IF EXISTS public.idx_uvp_vocab_id;
DROP INDEX IF EXISTS public.idx_uvp_user_id;
DROP INDEX IF EXISTS public.idx_uvp_status;
DROP INDEX IF EXISTS public.idx_uvp_next_review_date;
DROP INDEX IF EXISTS public.idx_user_status;
DROP INDEX IF EXISTS public.idx_user_roles_user_id;
DROP INDEX IF EXISTS public.idx_user_roles_role_id;
DROP INDEX IF EXISTS public.idx_user_last_activity;
DROP INDEX IF EXISTS public.idx_user_email;
DROP INDEX IF EXISTS public.idx_user_current_streak;
DROP INDEX IF EXISTS public.idx_user_activation_key;
DROP INDEX IF EXISTS public.idx_user_activated;
DROP INDEX IF EXISTS public.idx_ugs_user_id;
DROP INDEX IF EXISTS public.idx_type_name;
DROP INDEX IF EXISTS public.idx_topic_name;
DROP INDEX IF EXISTS public.idx_token_user_id;
DROP INDEX IF EXISTS public.idx_token_token;
DROP INDEX IF EXISTS public.idx_token_refresh_token;
DROP INDEX IF EXISTS public.idx_notif_user_id;
DROP INDEX IF EXISTS public.idx_notif_type;
DROP INDEX IF EXISTS public.idx_notif_is_read;
DROP INDEX IF EXISTS public.idx_notif_created_at;
DROP INDEX IF EXISTS public.idx_gsd_vocab_id;
DROP INDEX IF EXISTS public.idx_gsd_session_id;
DROP INDEX IF EXISTS public.idx_gsd_is_correct;
DROP INDEX IF EXISTS public.idx_gs_user_id;
DROP INDEX IF EXISTS public.idx_gs_topic_id;
DROP INDEX IF EXISTS public.idx_gs_started_at;
DROP INDEX IF EXISTS public.idx_gs_score;
DROP INDEX IF EXISTS public.idx_gs_game_id;
DROP INDEX IF EXISTS public.idx_game_name;
DROP INDEX IF EXISTS public.idx_action_log_user_id;
DROP INDEX IF EXISTS public.idx_action_log_status;
DROP INDEX IF EXISTS public.idx_action_log_resource_type;
DROP INDEX IF EXISTS public.idx_action_log_created_at;
DROP INDEX IF EXISTS public.idx_action_log_action_type;
DROP INDEX IF EXISTS public.flyway_schema_history_s_idx;
ALTER TABLE IF EXISTS ONLY public.vocab_types DROP CONSTRAINT IF EXISTS vocab_types_pkey;
ALTER TABLE IF EXISTS ONLY public.vocab DROP CONSTRAINT IF EXISTS vocab_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.user_vocab_progress DROP CONSTRAINT IF EXISTS user_vocab_progress_pkey;
ALTER TABLE IF EXISTS ONLY public.user_roles DROP CONSTRAINT IF EXISTS user_roles_pkey;
ALTER TABLE IF EXISTS ONLY public.user_game_settings DROP CONSTRAINT IF EXISTS user_game_settings_pkey;
ALTER TABLE IF EXISTS ONLY public.user_game_settings DROP CONSTRAINT IF EXISTS uq_user_game_settings_user_id;
ALTER TABLE IF EXISTS ONLY public.tokens DROP CONSTRAINT IF EXISTS uk_na3v9f8s7ucnj16tylrs822qj;
ALTER TABLE IF EXISTS ONLY public.vocab DROP CONSTRAINT IF EXISTS uk_km7blpn65sakml18nhnnhvxfc;
ALTER TABLE IF EXISTS ONLY public.games DROP CONSTRAINT IF EXISTS uk_dp39yy9j9cn10v9vhyr2j1uaa;
ALTER TABLE IF EXISTS ONLY public.tokens DROP CONSTRAINT IF EXISTS uk_868xfj44b89t1voh058wevbqg;
ALTER TABLE IF EXISTS ONLY public.topics DROP CONSTRAINT IF EXISTS uk_7tuhnscjpohbffmp7btit1uff;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS uk_6dotkott2kjsp8vw4d0m25fb7;
ALTER TABLE IF EXISTS ONLY public.types DROP CONSTRAINT IF EXISTS uk_17go525ou3scbmd4pcftq130f;
ALTER TABLE IF EXISTS ONLY public.types DROP CONSTRAINT IF EXISTS types_pkey;
ALTER TABLE IF EXISTS ONLY public.topics DROP CONSTRAINT IF EXISTS topics_pkey;
ALTER TABLE IF EXISTS ONLY public.tokens DROP CONSTRAINT IF EXISTS tokens_pkey;
ALTER TABLE IF EXISTS ONLY public.roles DROP CONSTRAINT IF EXISTS roles_pkey;
ALTER TABLE IF EXISTS ONLY public.notifications DROP CONSTRAINT IF EXISTS notifications_pkey;
ALTER TABLE IF EXISTS ONLY public.user_vocab_progress DROP CONSTRAINT IF EXISTS idx_uvp_user_vocab;
ALTER TABLE IF EXISTS ONLY public.roles DROP CONSTRAINT IF EXISTS idx_role_name;
ALTER TABLE IF EXISTS ONLY public.games DROP CONSTRAINT IF EXISTS games_pkey;
ALTER TABLE IF EXISTS ONLY public.game_sessions DROP CONSTRAINT IF EXISTS game_sessions_pkey;
ALTER TABLE IF EXISTS ONLY public.game_session_details DROP CONSTRAINT IF EXISTS game_session_details_pkey;
ALTER TABLE IF EXISTS ONLY public.flyway_schema_history DROP CONSTRAINT IF EXISTS flyway_schema_history_pk;
ALTER TABLE IF EXISTS ONLY public.action_logs DROP CONSTRAINT IF EXISTS action_logs_pkey;
ALTER TABLE IF EXISTS public.types ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.topics ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.roles ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.notifications ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.games ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.game_sessions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.game_session_details ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.action_logs ALTER COLUMN id DROP DEFAULT;
DROP TABLE IF EXISTS public.vocab_types;
DROP TABLE IF EXISTS public.vocab;
DROP TABLE IF EXISTS public.users;
DROP TABLE IF EXISTS public.user_vocab_progress;
DROP TABLE IF EXISTS public.user_roles;
DROP TABLE IF EXISTS public.user_game_settings;
DROP SEQUENCE IF EXISTS public.types_id_seq;
DROP TABLE IF EXISTS public.types;
DROP SEQUENCE IF EXISTS public.topics_id_seq;
DROP TABLE IF EXISTS public.topics;
DROP TABLE IF EXISTS public.tokens;
DROP SEQUENCE IF EXISTS public.roles_id_seq;
DROP TABLE IF EXISTS public.roles;
DROP SEQUENCE IF EXISTS public.notifications_id_seq;
DROP TABLE IF EXISTS public.notifications;
DROP SEQUENCE IF EXISTS public.games_id_seq;
DROP TABLE IF EXISTS public.games;
DROP SEQUENCE IF EXISTS public.game_sessions_id_seq;
DROP TABLE IF EXISTS public.game_sessions;
DROP SEQUENCE IF EXISTS public.game_session_details_id_seq;
DROP TABLE IF EXISTS public.game_session_details;
DROP TABLE IF EXISTS public.flyway_schema_history;
DROP SEQUENCE IF EXISTS public.action_logs_id_seq;
DROP TABLE IF EXISTS public.action_logs;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: action_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.action_logs (
    id bigint NOT NULL,
    user_id uuid,
    action_type character varying(100) NOT NULL,
    resource_type character varying(100),
    resource_id character varying(255),
    description text,
    status character varying(50),
    ip_address character varying(50),
    user_agent character varying(500),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.action_logs OWNER TO postgres;

--
-- Name: action_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.action_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.action_logs_id_seq OWNER TO postgres;

--
-- Name: action_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.action_logs_id_seq OWNED BY public.action_logs.id;


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
    name character varying(100) NOT NULL,
    img character varying(500)
);


ALTER TABLE public.topics OWNER TO postgres;

--
-- Name: COLUMN topics.img; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.topics.img IS 'Firebase Storage URL for topic image';


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
    image_word_total_pairs integer,
    quick_quiz_time_per_question integer,
    quick_quiz_total_questions integer,
    word_definition_total_pairs integer,
    user_id uuid NOT NULL
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
    vocab_id uuid NOT NULL,
    CONSTRAINT user_vocab_progress_status_check CHECK (((status)::text = ANY (ARRAY[('NEW'::character varying)::text, ('KNOWN'::character varying)::text, ('UNKNOWN'::character varying)::text, ('MASTERED'::character varying)::text])))
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
    current_streak integer,
    date_of_birth date,
    email character varying(100) NOT NULL,
    gender character varying(10),
    last_activity_date date,
    level_test_completed boolean NOT NULL,
    longest_streak integer,
    name character varying(100) NOT NULL,
    next_activation_time timestamp(6) without time zone,
    password character varying(255) NOT NULL,
    status character varying(50),
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
    credit character varying(255),
    example_sentence character varying(1000),
    img character varying(500),
    interpret character varying(1000),
    meaning_vi character varying(500),
    transcription character varying(100),
    word character varying(100) NOT NULL,
    topic_id bigint
);


ALTER TABLE public.vocab OWNER TO postgres;

--
-- Name: vocab_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vocab_types (
    vocab_id uuid NOT NULL,
    type_id bigint NOT NULL
);


ALTER TABLE public.vocab_types OWNER TO postgres;

--
-- Name: action_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action_logs ALTER COLUMN id SET DEFAULT nextval('public.action_logs_id_seq'::regclass);


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
-- Data for Name: action_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.action_logs (id, user_id, action_type, resource_type, resource_id, description, status, ip_address, user_agent, created_at, updated_at) FROM stdin;
1	a67776ee-d02c-4d9a-8b40-548a1017f284	USER_LOGIN	SYSTEM	system	User logged in successfully	SUCCESS	127.0.0.1	\N	2025-11-17 09:52:53.034511	2025-11-17 09:52:53.034511
2	80e0aba9-a8f6-4bd0-b844-2db35c45b4e9	USER_LOGIN	SYSTEM	system	User logged in successfully	SUCCESS	127.0.0.1	\N	2025-11-17 09:52:53.034511	2025-11-17 09:52:53.034511
3	0231fef6-69e6-4ada-998c-e665499890fd	USER_LOGIN	SYSTEM	system	User logged in successfully	SUCCESS	127.0.0.1	\N	2025-11-17 09:52:53.034511	2025-11-17 09:52:53.034511
4	68d0e081-c30d-4013-aaad-71f66e345a39	USER_LOGIN	SYSTEM	system	User logged in successfully	SUCCESS	127.0.0.1	\N	2025-11-17 09:52:53.034511	2025-11-17 09:52:53.034511
\.


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	initial schema	SQL	V1__initial_schema.sql	-720968403	postgres	2025-11-12 12:09:01.808621	15	t
2	2	remove unique constraint topic id	SQL	V2__remove_unique_constraint_topic_id.sql	1271158155	postgres	2025-11-12 12:45:07.817635	56	t
3	3	force remove all topic unique constraints	SQL	V3__force_remove_all_topic_unique_constraints.sql	891480958	postgres	2025-11-12 12:58:06.106488	44	t
4	4	add img column to topics	SQL	V4__add_img_column_to_topics.sql	-1258855077	postgres	2025-11-13 10:35:35.671748	34	t
5	5	remove game name from user game settings	SQL	V5__remove_game_name_from_user_game_settings.sql	-1557624129	postgres	2025-11-14 12:06:12.584634	45	t
6	6	insert initial games data	SQL	V6__insert_initial_games_data.sql	896262779	postgres	2025-11-14 12:40:57.706538	15	t
7	7	create action logs table	SQL	V7__create_action_logs_table.sql	997376750	postgres	2025-11-17 09:52:53.014027	73	t
\.


--
-- Data for Name: game_session_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.game_session_details (id, created_at, updated_at, is_correct, time_taken, session_id, vocab_id) FROM stdin;
1	2025-11-14 12:32:11.313497	2025-11-14 12:32:11.31355	t	\N	1	859a67dd-5dd0-4193-9d04-87fc41a03c59
2	2025-11-14 12:32:11.326299	2025-11-14 12:32:11.326336	t	\N	1	2f6a493d-722f-46cc-8c97-56622c5818e1
3	2025-11-14 12:32:11.335969	2025-11-14 12:32:11.335995	t	\N	1	8e1da24a-731c-46ad-89c2-014d0b0abbab
4	2025-11-14 12:32:11.344631	2025-11-14 12:32:11.344667	t	\N	1	3a0df300-b644-43b2-8ff2-baf58db0a9f5
5	2025-11-14 12:32:11.354913	2025-11-14 12:32:11.354944	t	\N	1	c315d0f6-f15c-4fc0-87dd-430ed1f47672
6	2025-11-14 12:35:00.911501	2025-11-14 12:35:00.911527	t	\N	2	0841a70f-c509-47f2-92e4-236a48797f80
7	2025-11-14 12:35:00.921164	2025-11-14 12:35:00.921199	t	\N	2	ca4db7c3-0f35-48dc-b95e-706dd677502e
8	2025-11-14 12:35:00.928469	2025-11-14 12:35:00.928488	t	\N	2	eb523b41-fb1b-48d9-9aed-05dfc7760bc1
9	2025-11-14 12:35:00.936401	2025-11-14 12:35:00.936423	t	\N	2	7df11371-9269-472a-a403-5032e60a6823
10	2025-11-14 12:35:00.943659	2025-11-14 12:35:00.94368	t	\N	2	22124e5f-d914-45a9-9bd3-311453433cf8
11	2025-11-14 12:41:44.551221	2025-11-14 12:41:44.551267	f	10000	3	15c41d03-b901-49e4-9b19-43befd322627
12	2025-11-14 12:41:50.135156	2025-11-14 12:41:50.135196	f	10000	3	e28ea120-607e-4bf4-b437-8009011bc135
13	2025-11-14 12:41:54.542293	2025-11-14 12:41:54.542343	f	10000	3	830dde69-2c19-429a-bf42-9c0b7bf7a022
14	2025-11-14 12:41:59.987377	2025-11-14 12:41:59.987408	t	10000	3	02524785-3026-48f4-b538-9f32298d5736
15	2025-11-14 12:42:06.248055	2025-11-14 12:42:06.248103	f	10000	3	b64837cb-2e32-4646-b070-dfdc013ca3fa
16	2025-11-17 11:30:54.713011	2025-11-17 11:30:54.713038	f	1000	4	78042145-2403-4c7d-adae-554f08965db0
17	2025-11-17 11:30:58.383187	2025-11-17 11:30:58.383206	f	1000	4	830dde69-2c19-429a-bf42-9c0b7bf7a022
18	2025-11-17 11:31:01.582795	2025-11-17 11:31:01.582828	t	1000	4	8f6cd00b-6784-4e6e-88dd-76984709d7dd
19	2025-11-17 11:31:05.178292	2025-11-17 11:31:05.178311	t	1000	4	6e48003f-c4c4-4e6c-9ded-b954bc7a66eb
20	2025-11-17 11:31:08.129586	2025-11-17 11:31:08.129603	f	1000	4	a42fb061-d0a3-4fa9-a51b-1eade4ca02b9
21	2025-11-17 18:53:29.836145	2025-11-17 18:53:29.836189	f	1000	5	d3d30637-4e02-4b5b-aa05-5bea49dba687
22	2025-11-17 18:54:11.54778	2025-11-17 18:54:11.547799	f	1000	5	154fb5c1-e8cf-4333-93d3-0fdc0d25c280
23	2025-11-17 18:54:18.75401	2025-11-17 18:54:18.754037	f	1000	5	9ff88cd7-7d55-4d8f-8bdb-780035bd1858
24	2025-11-17 18:54:24.307379	2025-11-17 18:54:24.307403	f	1000	5	67855177-90ed-4f1a-b473-d4e0e5e14204
25	2025-11-17 18:54:27.92647	2025-11-17 18:54:27.926496	f	1000	5	f0086b87-8b1b-4cbf-897d-30dfdf1c8bde
26	2025-11-17 18:54:44.15637	2025-11-17 18:54:44.15642	t	1000	5	3e902e56-5be7-44f3-b720-78453268523b
27	2025-11-17 18:54:56.649177	2025-11-17 18:54:56.6492	f	1000	5	64caeaed-1a63-4b5a-87e4-8305762822f7
28	2025-11-17 18:55:03.546495	2025-11-17 18:55:03.546545	f	1000	5	b82c614e-0457-4514-8c86-1003eab624b9
29	2025-11-17 18:55:12.238908	2025-11-17 18:55:12.238954	f	1000	5	5fee7ae3-46ec-4bd9-ab6c-cbdd35d13b83
30	2025-11-17 18:55:16.223311	2025-11-17 18:55:16.223327	t	1000	5	ad50fa9d-3d44-416b-b8db-115e4748a685
\.


--
-- Data for Name: game_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.game_sessions (id, created_at, updated_at, accuracy, correct_count, duration, finished_at, score, started_at, total_questions, game_id, topic_id, user_id) FROM stdin;
1	2025-11-14 12:29:39.110815	2025-11-14 12:32:11.430307	100	5	152	2025-11-14 12:32:11.356576	7	2025-11-14 12:29:39.109127	5	1	\N	68d0e081-c30d-4013-aaad-71f66e345a39
2	2025-11-14 12:33:15.135367	2025-11-14 12:35:00.973773	100	5	\N	2025-11-14 12:35:00.949345	7	2025-11-14 12:33:15.134967	5	2	\N	68d0e081-c30d-4013-aaad-71f66e345a39
3	2025-11-14 12:41:23.173946	2025-11-14 12:42:06.323663	20	1	43	2025-11-14 12:42:06.256428	10	2025-11-14 12:41:23.15426	5	3	\N	68d0e081-c30d-4013-aaad-71f66e345a39
4	2025-11-17 11:30:15.703853	2025-11-17 11:31:05.189617	\N	2	\N	\N	30	2025-11-17 11:30:15.69192	10	3	\N	80e0aba9-a8f6-4bd0-b844-2db35c45b4e9
5	2025-11-17 18:52:47.496949	2025-11-17 18:55:16.298746	20	2	148	2025-11-17 18:55:16.231157	30	2025-11-17 18:52:47.483407	10	3	\N	80e0aba9-a8f6-4bd0-b844-2db35c45b4e9
\.


--
-- Data for Name: games; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.games (id, created_at, updated_at, description, name, rules_json) FROM stdin;
1	2025-11-14 12:29:39.039687	2025-11-14 12:29:39.039756	Ghép thẻ hình ảnh với từ vựng	Image-Word Matching	\N
2	2025-11-14 12:33:15.110805	2025-11-14 12:33:15.110871	Ghép thẻ từ vựng với nghĩa	Word-Definition Matching	\N
3	2025-11-14 12:40:57.729342	2025-11-14 12:40:57.729342	Trắc nghiệm phản xạ nhanh với câu hỏi Multiple Choice	Quick Reflex Quiz	\N
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, created_at, updated_at, content, is_read, title, type, user_id) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, created_at, updated_at, description, name) FROM stdin;
1	2025-11-12 12:09:09.447012	2025-11-12 12:09:09.447144	Quản trị hệ thống	ROLE_ADMIN
2	2025-11-12 12:09:09.509388	2025-11-12 12:09:09.509489	Người dùng	ROLE_USER
\.


--
-- Data for Name: tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tokens (id, created_at, updated_at, expired, refresh_token, revoked, token, user_id) FROM stdin;
e6ceda34-5e91-43ac-beb6-2d6c188e1c7b	2025-11-12 12:09:20.020484	2025-11-13 08:55:30.830847	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImFkbWluMUBjYXJkd29yZHMuY29tIiwiaWF0IjoxNzYyOTQ5MzU5LCJleHAiOjE3NjM1NTQxNTl9.OAHEE90ohuWEntI32UFbw4Wd1Z1NdYYP13WVp7JyP6U	t	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX0FETUlOIiwiUk9MRV9VU0VSIl0sInVzZXJJZCI6ImE2Nzc3NmVlLWQwMmMtNGQ5YS04YjQwLTU0OGExMDE3ZjI4NCIsIm5hbWUiOiJRdeG6o24gdHLhu4sgdmnDqm4gMSIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiYWRtaW4xQGNhcmR3b3Jkcy5jb20iLCJpYXQiOjE3NjI5NDkzNTksImV4cCI6MTc2MzAzNTc1OX0.0b9s8AZhCq8BRiRe-lH4tBTjZi8oT3MKYheqixJjsjo	a67776ee-d02c-4d9a-8b40-548a1017f284
f8510a8c-9e50-43de-b00a-20a8d63644a9	2025-11-13 08:55:30.816654	2025-11-13 08:55:57.847694	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImFkbWluMUBjYXJkd29yZHMuY29tIiwiaWF0IjoxNzYzMDI0MTMwLCJleHAiOjE3NjM2Mjg5MzB9.4wsJEpXzs6c6p0HACOULVwjK6kSXUxT0UdBv9PQYfVE	t	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiLCJST0xFX0FETUlOIl0sIm5hbWUiOiJRdeG6o24gdHLhu4sgdmnDqm4gMSIsInVzZXJJZCI6ImE2Nzc3NmVlLWQwMmMtNGQ5YS04YjQwLTU0OGExMDE3ZjI4NCIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiYWRtaW4xQGNhcmR3b3Jkcy5jb20iLCJpYXQiOjE3NjMwMjQxMzAsImV4cCI6MTc2MzExMDUzMH0.14aZCLoAP_r21zP5CYdg1yYoCP51itN4nCJnaHkViEg	a67776ee-d02c-4d9a-8b40-548a1017f284
6cc66659-4a22-4fef-b3f5-da2b57add8a2	2025-11-13 08:55:57.845955	2025-11-13 09:09:14.763252	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImFkbWluMUBjYXJkd29yZHMuY29tIiwiaWF0IjoxNzYzMDI0MTU3LCJleHAiOjE3NjM2Mjg5NTd9.-B5PZeFWDo7jvF1BFfgS6ppHrNCXIa20Gx_xjnMMZhY	t	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiLCJST0xFX0FETUlOIl0sIm5hbWUiOiJRdeG6o24gdHLhu4sgdmnDqm4gMSIsInVzZXJJZCI6ImE2Nzc3NmVlLWQwMmMtNGQ5YS04YjQwLTU0OGExMDE3ZjI4NCIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiYWRtaW4xQGNhcmR3b3Jkcy5jb20iLCJpYXQiOjE3NjMwMjQxNTcsImV4cCI6MTc2MzExMDU1N30.F80lTie3olla5xb9y_1CJdBfmItizHqm0zIZgliwZdQ	a67776ee-d02c-4d9a-8b40-548a1017f284
c0d1e36f-9fa7-4a11-a778-f8113e52047a	2025-11-13 09:09:14.748172	2025-11-13 10:52:47.259919	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImFkbWluMUBjYXJkd29yZHMuY29tIiwiaWF0IjoxNzYzMDI0OTU0LCJleHAiOjE3NjM2Mjk3NTR9.RMtOUhOuWrCdccJN4MYcQg7nusy7GKXHSqPhcNIH4XE	t	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJhNjc3NzZlZS1kMDJjLTRkOWEtOGI0MC01NDhhMTAxN2YyODQiLCJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIDEiLCJhdXRob3JpdGllcyI6WyJST0xFX0FETUlOIiwiUk9MRV9VU0VSIl0sImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiYWRtaW4xQGNhcmR3b3Jkcy5jb20iLCJpYXQiOjE3NjMwMjQ5NTQsImV4cCI6MTc2MzExMTM1NH0.X4-GJabPczptTwhePUq_-f5HTE1NrjdXW5fTBxWmJF4	a67776ee-d02c-4d9a-8b40-548a1017f284
759c8b67-3d95-4bc4-93a5-38f068d89381	2025-11-13 12:20:42.460073	2025-11-14 11:29:50.221444	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYzMDM2NDQyLCJleHAiOjE3NjM2NDEyNDJ9.uQAYvzGgLqXZZE0Z_95stn6nhK0tGOLiG7fmaoWNwoI	t	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiTmd1eeG7hW4gVsSDbiBDIiwidXNlcklkIjoiNjhkMGUwODEtYzMwZC00MDEzLWFhYWQtNzFmNjZlMzQ1YTM5IiwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0VSIl0sImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiY2FyZHdvcmRzZ2FtZUBnbWFpbC5jb20iLCJpYXQiOjE3NjMwMzY0NDIsImV4cCI6MTc2MzEyMjg0Mn0.1P5O2etHElCz-woFeZ2ESX1cV1hde3iK0K1j0OnQCyg	68d0e081-c30d-4013-aaad-71f66e345a39
d73bf29c-4183-4b53-aef6-b70886fb70b5	2025-11-14 11:29:50.209986	2025-11-14 11:30:50.549666	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYzMTE5NzkwLCJleHAiOjE3NjM3MjQ1OTB9.UrlKEha_hUqT2V3wooMgw5wv8ZK-6tiQIYohRyYEKog	t	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiTmd1eeG7hW4gVsSDbiBDIiwidXNlcklkIjoiNjhkMGUwODEtYzMwZC00MDEzLWFhYWQtNzFmNjZlMzQ1YTM5IiwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0VSIl0sImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiY2FyZHdvcmRzZ2FtZUBnbWFpbC5jb20iLCJpYXQiOjE3NjMxMTk3OTAsImV4cCI6MTc2MzIwNjE5MH0.Go367y_3KGnYrRD9GacMtZ9li6S3Rc97veDkSdJ_qX0	68d0e081-c30d-4013-aaad-71f66e345a39
dd1ddb75-8898-4dff-a6b0-f3472b48a17b	2025-11-14 11:30:50.548375	2025-11-14 12:11:49.486767	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYzMTE5ODUwLCJleHAiOjE3NjM3MjQ2NTB9.azQoSOoYNFdIdCAOHcdAWUVLqJYT-FtxftsQj-TAofM	t	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiTmd1eeG7hW4gVsSDbiBDIiwidXNlcklkIjoiNjhkMGUwODEtYzMwZC00MDEzLWFhYWQtNzFmNjZlMzQ1YTM5IiwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0VSIl0sImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiY2FyZHdvcmRzZ2FtZUBnbWFpbC5jb20iLCJpYXQiOjE3NjMxMTk4NTAsImV4cCI6MTc2MzIwNjI1MH0.yvD3IyDFlNIUZpEas7ElNIVliRGlnKnmbTVfHMWDnkQ	68d0e081-c30d-4013-aaad-71f66e345a39
629b8c00-da51-4997-817a-d9eaa8b05251	2025-11-14 12:11:49.475063	2025-11-14 12:54:40.650723	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYzMTIyMzA5LCJleHAiOjE3NjM3MjcxMDl9.Eboj6mseOQK5-VykqNLRjQK6n30ztQVk2sP3X17Bzf4	t	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiTmd1eeG7hW4gVsSDbiBDIiwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0VSIl0sInVzZXJJZCI6IjY4ZDBlMDgxLWMzMGQtNDAxMy1hYWFkLTcxZjY2ZTM0NWEzOSIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiY2FyZHdvcmRzZ2FtZUBnbWFpbC5jb20iLCJpYXQiOjE3NjMxMjIzMDksImV4cCI6MTc2MzIwODcwOX0.a5wL2LADxGMYRmUdB3JsXIkKoXcjJSeaObdpx8_yeeg	68d0e081-c30d-4013-aaad-71f66e345a39
3ee48165-8fdd-44ac-9056-0956c5fb0956	2025-11-14 12:54:40.644038	2025-11-14 16:53:44.123574	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYzMTI0ODgwLCJleHAiOjE3NjM3Mjk2ODB9.KRRpwCg7isUsiHpxUb0LSWnaZ6FE0f7DxBLV7XxtJGo	t	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiTmd1eeG7hW4gVsSDbiBDIiwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0VSIl0sInVzZXJJZCI6IjY4ZDBlMDgxLWMzMGQtNDAxMy1hYWFkLTcxZjY2ZTM0NWEzOSIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiY2FyZHdvcmRzZ2FtZUBnbWFpbC5jb20iLCJpYXQiOjE3NjMxMjQ4ODAsImV4cCI6MTc2MzIxMTI4MH0.NErvsaLbsG9pHojHeNS2i4FmexE3OcIaSkvFQJu4qpQ	68d0e081-c30d-4013-aaad-71f66e345a39
44a78835-429a-47ba-b182-61c0d0cb3363	2025-11-14 16:53:44.109332	2025-11-16 15:44:03.410768	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYzMTM5MjI0LCJleHAiOjE3NjM3NDQwMjR9.EDAIbEBBjwJj3Yprc2evfZBFrqGMBaiqAvNFxfHiIag	t	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwidXNlcklkIjoiNjhkMGUwODEtYzMwZC00MDEzLWFhYWQtNzFmNjZlMzQ1YTM5IiwibmFtZSI6Ik5ndXnhu4VuIFbEg24gQyIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiY2FyZHdvcmRzZ2FtZUBnbWFpbC5jb20iLCJpYXQiOjE3NjMxMzkyMjQsImV4cCI6MTc2MzIyNTYyNH0.E3GQJz4wbDTprlRfFRi_lltFn0dSLxmOy9MamnsZUK4	68d0e081-c30d-4013-aaad-71f66e345a39
deab23f3-b708-448c-ada7-750f5f262bb0	2025-11-13 10:52:47.239816	2025-11-16 16:43:10.089416	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImFkbWluMUBjYXJkd29yZHMuY29tIiwiaWF0IjoxNzYzMDMxMTY3LCJleHAiOjE3NjM2MzU5Njd9.mph0hJSzLBvJuOpjW0_RdNEq0BoE2B-5sVBD6ex8ihU	t	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIDEiLCJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiLCJST0xFX0FETUlOIl0sInVzZXJJZCI6ImE2Nzc3NmVlLWQwMmMtNGQ5YS04YjQwLTU0OGExMDE3ZjI4NCIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiYWRtaW4xQGNhcmR3b3Jkcy5jb20iLCJpYXQiOjE3NjMwMzExNjcsImV4cCI6MTc2MzExNzU2N30.y3lKKzD1zXWYGUMD_POrnukLaQhNFo2Pe25GSsxLzgw	a67776ee-d02c-4d9a-8b40-548a1017f284
d2112180-2152-4cb1-a259-f779da5015f6	2025-11-16 16:42:58.8594	2025-11-16 17:56:32.344344	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYzMzExMzc4LCJleHAiOjE3NjM5MTYxNzh9.YchFVEEQuc2grQYePr_iacsuPjVPmJitTEvM7DF6AxY	t	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiTmd1eeG7hW4gVsSDbiBDIiwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0VSIl0sInVzZXJJZCI6IjY4ZDBlMDgxLWMzMGQtNDAxMy1hYWFkLTcxZjY2ZTM0NWEzOSIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiY2FyZHdvcmRzZ2FtZUBnbWFpbC5jb20iLCJpYXQiOjE3NjMzMTEzNzgsImV4cCI6MTc2MzM5Nzc3OH0.a9KpDsQFIMASYcu_QBaZj4g5Pgot8pm8MRTmWiooJq4	68d0e081-c30d-4013-aaad-71f66e345a39
06e4b083-fe78-4d74-b1ee-4e50eab674ae	2025-11-16 15:44:03.395239	2025-11-16 16:42:58.873422	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYzMzA3ODQzLCJleHAiOjE3NjM5MTI2NDN9.0_BYuY1Afpc_R9jXF-8s1z_Hh7hi0NbeWWvdsu8Lwhk	t	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwidXNlcklkIjoiNjhkMGUwODEtYzMwZC00MDEzLWFhYWQtNzFmNjZlMzQ1YTM5IiwibmFtZSI6Ik5ndXnhu4VuIFbEg24gQyIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiY2FyZHdvcmRzZ2FtZUBnbWFpbC5jb20iLCJpYXQiOjE3NjMzMDc4NDMsImV4cCI6MTc2MzM5NDI0M30.hZ50DdkRMBqtKqwOqe7ubnPmmlkCjeKTjOhSnstdvYI	68d0e081-c30d-4013-aaad-71f66e345a39
1d4d2301-78c5-4402-8797-8e6ffbe10eff	2025-11-16 16:46:46.868384	2025-11-16 16:46:46.868454	f	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImFkbWluMUBjYXJkd29yZHMuY29tIiwiaWF0IjoxNzYzMzExNjA2LCJleHAiOjE3NjM5MTY0MDZ9.SQ_J2ht0JzAKiGrHJKrmgg9Z2k1jow-YeJU2WH5jFSw	f	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIDEiLCJhdXRob3JpdGllcyI6WyJST0xFX0FETUlOIiwiUk9MRV9VU0VSIl0sInVzZXJJZCI6ImE2Nzc3NmVlLWQwMmMtNGQ5YS04YjQwLTU0OGExMDE3ZjI4NCIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiYWRtaW4xQGNhcmR3b3Jkcy5jb20iLCJpYXQiOjE3NjMzMTE2MDYsImV4cCI6MTc2MzM5ODAwNn0.63sZa9BLQcXqp4yKME8bG8aqxG1GXBxUOa8HhUTXfXQ	a67776ee-d02c-4d9a-8b40-548a1017f284
40b94491-d94e-4087-9b36-f6ab3f12204f	2025-11-16 16:43:10.0881	2025-11-16 16:46:46.882173	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImFkbWluMUBjYXJkd29yZHMuY29tIiwiaWF0IjoxNzYzMzExMzkwLCJleHAiOjE3NjM5MTYxOTB9.Lr22hVpkx5i31qW4rzCRkATtJ1iKePJrXK3MP6mcL4c	t	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIDEiLCJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiLCJST0xFX0FETUlOIl0sInVzZXJJZCI6ImE2Nzc3NmVlLWQwMmMtNGQ5YS04YjQwLTU0OGExMDE3ZjI4NCIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiYWRtaW4xQGNhcmR3b3Jkcy5jb20iLCJpYXQiOjE3NjMzMTEzOTAsImV4cCI6MTc2MzM5Nzc5MH0.AQvSIShkoOUSuxoF-5E4RAeIkw8WOtPsGQq4iaWnfVY	a67776ee-d02c-4d9a-8b40-548a1017f284
8af2342a-94e6-4a4c-8191-37636e943eac	2025-11-16 17:57:46.638571	2025-11-16 17:57:46.638609	f	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImNhcmR3b3Jkc2dhbWVAZ21haWwuY29tIiwiaWF0IjoxNzYzMzE1ODY2LCJleHAiOjE3NjM5MjA2NjZ9.UUNzVmG1riNT4qu_NFlaaX__-moUdU_NfvlqVbZ7wr0	f	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiI2OGQwZTA4MS1jMzBkLTQwMTMtYWFhZC03MWY2NmUzNDVhMzkiLCJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwibmFtZSI6Ik5ndXnhu4VuIFbEg24gQyIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiY2FyZHdvcmRzZ2FtZUBnbWFpbC5jb20iLCJpYXQiOjE3NjMzMTU4NjYsImV4cCI6MTc2MzQwMjI2Nn0.dMLrkUxcUZLtTHdaZPquN7TEM5y2MuVIqQDMNGY9NEM	68d0e081-c30d-4013-aaad-71f66e345a39
ad977e9d-2131-4650-8b24-690574701166	2025-11-16 16:46:59.126898	2025-11-17 08:42:28.338103	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImFkbWluMkBjYXJkd29yZHMuY29tIiwiaWF0IjoxNzYzMzExNjE5LCJleHAiOjE3NjM5MTY0MTl9.JZ7Rx75cY8pUx50-j_Gx4QBJh_M7aQUYQVI0T8oDSg4	t	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIDIiLCJhdXRob3JpdGllcyI6WyJST0xFX0FETUlOIiwiUk9MRV9VU0VSIl0sInVzZXJJZCI6IjgwZTBhYmE5LWE4ZjYtNGJkMC1iODQ0LTJkYjM1YzQ1YjRlOSIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiYWRtaW4yQGNhcmR3b3Jkcy5jb20iLCJpYXQiOjE3NjMzMTE2MTksImV4cCI6MTc2MzM5ODAxOX0._lbkr-hidxKZPnH59EHuTwgHWQL4tfuj6oRRRcDTV7Q	80e0aba9-a8f6-4bd0-b844-2db35c45b4e9
503f2fe8-7ffa-4e9b-b652-736ef1146c61	2025-11-17 08:42:28.321306	2025-11-17 09:53:08.301207	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImFkbWluMkBjYXJkd29yZHMuY29tIiwiaWF0IjoxNzYzMzY4OTQ4LCJleHAiOjE3NjM5NzM3NDh9.KO2ZwJ_UrZXq8BcRbWVf5mG1Ixb_RNfRgob1b_CzDHs	t	eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIDIiLCJ1c2VySWQiOiI4MGUwYWJhOS1hOGY2LTRiZDAtYjg0NC0yZGIzNWM0NWI0ZTkiLCJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiLCJST0xFX0FETUlOIl0sImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiYWRtaW4yQGNhcmR3b3Jkcy5jb20iLCJpYXQiOjE3NjMzNjg5NDgsImV4cCI6MTc2MzQ1NTM0OH0.-tqvlmUQw2ri1vuUAmrR56W_K-soxbHKOnvgVGCP4ko	80e0aba9-a8f6-4bd0-b844-2db35c45b4e9
9a1e09ba-9253-45a1-9322-ad8dd8308bfc	2025-11-17 09:53:08.288701	2025-11-18 08:42:17.139522	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImFkbWluMkBjYXJkd29yZHMuY29tIiwiaWF0IjoxNzYzMzczMTg4LCJleHAiOjE3NjM5Nzc5ODh9.XCllEg4QzuwWGrluWmiBIZ-QmXqfxKrWQRSGTfdAsbQ	t	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiLCJST0xFX0FETUlOIl0sInVzZXJJZCI6IjgwZTBhYmE5LWE4ZjYtNGJkMC1iODQ0LTJkYjM1YzQ1YjRlOSIsIm5hbWUiOiJRdeG6o24gdHLhu4sgdmnDqm4gMiIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiYWRtaW4yQGNhcmR3b3Jkcy5jb20iLCJpYXQiOjE3NjMzNzMxODgsImV4cCI6MTc2MzQ1OTU4OH0.4jO4LRsuWowGtsN-tF1mUbE7xqzVwhKa1n6PLcvc6rs	80e0aba9-a8f6-4bd0-b844-2db35c45b4e9
80ea1d57-af51-4729-a727-4326c431c645	2025-11-18 08:42:40.176068	2025-11-18 08:42:40.176134	f	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImFkbWluMkBjYXJkd29yZHMuY29tIiwiaWF0IjoxNzYzNDU1MzYwLCJleHAiOjE3NjQwNjAxNjB9.x0IigAdqWX_nvmoE7jjp9TVbtsR1-M5INKGaq3INSvo	f	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX0FETUlOIiwiUk9MRV9VU0VSIl0sIm5hbWUiOiJRdeG6o24gdHLhu4sgdmnDqm4gMiIsInVzZXJJZCI6IjgwZTBhYmE5LWE4ZjYtNGJkMC1iODQ0LTJkYjM1YzQ1YjRlOSIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiYWRtaW4yQGNhcmR3b3Jkcy5jb20iLCJpYXQiOjE3NjM0NTUzNjAsImV4cCI6MTc2MzU0MTc2MH0.GJL1Z9zrOoQw7jdRZM9zWqrJ32Z_xQOhkETWplZrnzA	80e0aba9-a8f6-4bd0-b844-2db35c45b4e9
ebe95b35-e9c5-4121-a962-70b197e2a241	2025-11-18 08:42:17.126186	2025-11-18 08:42:40.177805	t	eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJjYXJkLXdvcmRzLmNvbSIsInN1YiI6ImFkbWluMkBjYXJkd29yZHMuY29tIiwiaWF0IjoxNzYzNDU1MzM3LCJleHAiOjE3NjQwNjAxMzd9.TAjcQpvz-WtWZNkrlB9xRWpIuvP30svE4bUJhS_CVpc	t	eyJhbGciOiJIUzI1NiJ9.eyJhdXRob3JpdGllcyI6WyJST0xFX0FETUlOIiwiUk9MRV9VU0VSIl0sIm5hbWUiOiJRdeG6o24gdHLhu4sgdmnDqm4gMiIsInVzZXJJZCI6IjgwZTBhYmE5LWE4ZjYtNGJkMC1iODQ0LTJkYjM1YzQ1YjRlOSIsImlzcyI6ImNhcmQtd29yZHMuY29tIiwic3ViIjoiYWRtaW4yQGNhcmR3b3Jkcy5jb20iLCJpYXQiOjE3NjM0NTUzMzcsImV4cCI6MTc2MzU0MTczN30.tv0VthzZZ7R7F5GnufHn8QMStbHdmoqbYqkCJEPLci4	80e0aba9-a8f6-4bd0-b844-2db35c45b4e9
\.


--
-- Data for Name: topics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.topics (id, created_at, updated_at, description, name, img) FROM stdin;
19	2025-11-12 12:10:13.912085	2025-11-12 12:10:13.912107	Auto-generated from vocab creation	art & literature	\N
20	2025-11-12 12:10:14.070404	2025-11-12 12:10:14.070428	Auto-generated from vocab creation	social media & communication	\N
21	2025-11-12 12:10:18.173188	2025-11-12 12:10:18.1732	Auto-generated from vocab creation	science & technology	\N
22	2025-11-12 12:10:18.336423	2025-11-12 12:10:18.336432	Auto-generated from vocab creation	events & celebrations	\N
23	2025-11-12 12:10:18.447367	2025-11-12 12:10:18.447382	Auto-generated from vocab creation	health & medicine	\N
24	2025-11-12 12:10:18.584077	2025-11-12 12:10:18.584081	Auto-generated from vocab creation	fashion & trends	\N
25	2025-11-12 12:10:18.711488	2025-11-12 12:10:18.711493	Auto-generated from vocab creation	geography	\N
26	2025-11-12 12:10:18.935916	2025-11-12 12:10:18.935925	Auto-generated from vocab creation	hobbies & leisure	\N
27	2025-11-12 12:10:19.18657	2025-11-12 12:10:19.186581	Auto-generated from vocab creation	food & cooking	\N
28	2025-11-12 12:10:19.339071	2025-11-12 12:10:19.339081	Auto-generated from vocab creation	work & employment	\N
29	2025-11-12 12:10:19.464835	2025-11-12 12:10:19.464843	Auto-generated from vocab creation	business & management	\N
30	2025-11-12 12:10:19.601875	2025-11-12 12:10:19.601887	Auto-generated from vocab creation	culture & society	\N
31	2025-11-12 12:10:19.700833	2025-11-12 12:10:19.700846	Auto-generated from vocab creation	media & advertising	\N
32	2025-11-12 12:10:19.805843	2025-11-12 12:10:19.805854	Auto-generated from vocab creation	community & volunteering	\N
33	2025-11-12 12:10:20.022682	2025-11-12 12:10:20.022689	Auto-generated from vocab creation	sports & fitness	\N
34	2025-11-12 12:10:20.124787	2025-11-12 12:10:20.124793	Auto-generated from vocab creation	art & culture	\N
35	2025-11-12 12:10:20.234147	2025-11-12 12:10:20.234153	Auto-generated from vocab creation	literature & storytelling	\N
36	2025-11-12 12:10:20.359833	2025-11-12 12:10:20.359843	Auto-generated from vocab creation	publishing & media	\N
37	2025-11-12 12:10:20.553715	2025-11-12 12:10:20.553721	Auto-generated from vocab creation	media & broadcasting	\N
38	2025-11-12 12:10:20.654133	2025-11-12 12:10:20.654137	Auto-generated from vocab creation	media & society	\N
39	2025-11-12 12:10:20.940436	2025-11-12 12:10:20.940447	Auto-generated from vocab creation	art & architecture	\N
40	2025-11-12 12:10:21.065828	2025-11-12 12:10:21.065838	Auto-generated from vocab creation	science & space	\N
41	2025-11-12 12:10:21.214286	2025-11-12 12:10:21.214295	Auto-generated from vocab creation	science & biology	\N
42	2025-11-12 12:10:21.349494	2025-11-12 12:10:21.349504	Auto-generated from vocab creation	science & physics	\N
43	2025-11-12 12:10:21.446646	2025-11-12 12:10:21.446651	Auto-generated from vocab creation	science & chemistry	\N
44	2025-11-12 12:10:21.655756	2025-11-12 12:10:21.655768	Auto-generated from vocab creation	science & geology	\N
45	2025-11-12 12:10:21.757542	2025-11-12 12:10:21.757547	Auto-generated from vocab creation	science & astronomy	\N
46	2025-11-12 12:10:21.885388	2025-11-12 12:10:21.885415	Auto-generated from vocab creation	science & engineering	\N
47	2025-11-12 12:10:21.984126	2025-11-12 12:10:21.984136	Auto-generated from vocab creation	environment & ecology	\N
48	2025-11-12 12:10:22.08884	2025-11-12 12:10:22.088851	Auto-generated from vocab creation	environment & agriculture	\N
49	2025-11-12 12:10:22.338644	2025-11-12 12:10:22.338652	Auto-generated from vocab creation	health & psychology	\N
50	2025-11-12 12:10:22.486049	2025-11-12 12:10:22.486062	Auto-generated from vocab creation	education & learning	\N
51	2025-11-12 12:10:22.605674	2025-11-12 12:10:22.605683	Auto-generated from vocab creation	literature & arts	\N
52	2025-11-12 12:10:22.817338	2025-11-12 12:10:22.817344	Auto-generated from vocab creation	art & creativity	\N
53	2025-11-12 12:10:22.928353	2025-11-12 12:10:22.928361	Auto-generated from vocab creation	music & performance	\N
54	2025-11-12 12:10:23.035004	2025-11-12 12:10:23.035024	Auto-generated from vocab creation	dance & performance	\N
55	2025-11-12 12:10:23.122308	2025-11-12 12:10:23.122317	Auto-generated from vocab creation	film & media	\N
56	2025-11-12 12:10:23.194449	2025-11-12 12:10:23.194455	Auto-generated from vocab creation	photography & media	\N
57	2025-11-12 12:10:23.275115	2025-11-12 12:10:23.275122	Auto-generated from vocab creation	fashion & design	\N
58	2025-11-12 12:10:23.333135	2025-11-12 12:10:23.333141	Auto-generated from vocab creation	technology & innovation	\N
59	2025-11-12 12:10:23.467373	2025-11-12 12:10:23.467378	Auto-generated from vocab creation	business & economy	\N
1	2025-11-12 12:10:05.210741	2025-11-13 10:53:08.697213	Auto-generated from vocab creation	food & drink	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/topics%2Fimages%2Fcf91ecfe-e28a-4313-8964-b9fd1e59fbb4.png?alt=media
2	2025-11-12 12:10:11.033548	2025-11-13 10:53:50.539416	Auto-generated from vocab creation	family & people	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/topics%2Fimages%2Fee260fdf-3f17-44c7-821c-f368e3ca7600.png?alt=media
3	2025-11-12 12:10:11.319949	2025-11-13 11:09:58.540489	Auto-generated from vocab creation	school & study	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/topics%2Fimages%2Fcb221fa4-7c8a-44a7-bccf-0000937609c8.png?alt=media
4	2025-11-12 12:10:11.552407	2025-11-13 11:10:58.000525	Auto-generated from vocab creation	work & jobs	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/topics%2Fimages%2F43f8a6f7-2ce4-42d8-8796-03a3c344ebd8.png?alt=media
5	2025-11-12 12:10:11.843912	2025-11-13 11:11:14.586159	Auto-generated from vocab creation	travel & transport	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/topics%2Fimages%2F7a2558ec-ef9b-4d9a-88a8-0cd16a167161.png?alt=media
6	2025-11-12 12:10:12.06728	2025-11-13 11:11:33.715505	Auto-generated from vocab creation	sports & health	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/topics%2Fimages%2Fc8993cc8-8542-4fd9-8fdb-6bf6c068699a.png?alt=media
7	2025-11-12 12:10:12.282637	2025-11-13 11:15:21.579475	Auto-generated from vocab creation	animals	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/topics%2Fimages%2F5d9309dc-eeab-4cb4-b4db-27e6aa6615e9.png?alt=media
8	2025-11-12 12:10:12.437829	2025-11-13 11:15:35.28849	Auto-generated from vocab creation	nature	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/topics%2Fimages%2F6e4c9c80-e229-4b01-aa39-b5d3176b82d4.png?alt=media
9	2025-11-12 12:10:12.576737	2025-11-13 11:15:53.18495	Auto-generated from vocab creation	daily life	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/topics%2Fimages%2Fc87eb570-bbf8-489a-b3f9-72f8e4047cbb.png?alt=media
10	2025-11-12 12:10:12.715598	2025-11-13 11:16:13.515527	Auto-generated from vocab creation	places	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/topics%2Fimages%2F4e8f267e-9130-47ff-a75d-c714fb57eee0.png?alt=media
11	2025-11-12 12:10:12.859948	2025-11-13 11:17:14.793239	Auto-generated from vocab creation	technology	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/topics%2Fimages%2F74fdddb8-debb-4ab4-8924-fd4e297ae1fe.png?alt=media
14	2025-11-12 12:10:13.304898	2025-11-13 11:18:10.593275	Auto-generated from vocab creation	culture	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/topics%2Fimages%2F512a6343-198b-412c-9035-5bce86ac57aa.png?alt=media
17	2025-11-12 12:10:13.672126	2025-11-13 11:20:49.732932	Auto-generated from vocab creation	law & politics	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/topics%2Fimages%2F00efe11e-4c24-4fd6-bdc4-d6265a740581.png?alt=media
12	2025-11-12 12:10:13.007772	2025-11-13 11:17:30.290748	Auto-generated from vocab creation	emotions	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/topics%2Fimages%2F1f7f1644-302e-4cfd-8de4-2624e6632b1c.png?alt=media
13	2025-11-12 12:10:13.142931	2025-11-13 11:17:43.497609	Auto-generated from vocab creation	environment	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/topics%2Fimages%2Fdfa16151-071a-4952-8110-0d77314891a2.png?alt=media
15	2025-11-12 12:10:13.430087	2025-11-13 11:18:27.962882	Auto-generated from vocab creation	science	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/topics%2Fimages%2F54f881a7-fc4f-4296-a906-a226b524acfc.png?alt=media
16	2025-11-12 12:10:13.547571	2025-11-13 11:18:45.664454	Auto-generated from vocab creation	education advanced	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/topics%2Fimages%2Fd576d7e2-4d49-4989-bbf9-838ec8244dfc.png?alt=media
18	2025-11-12 12:10:13.791085	2025-11-13 11:21:21.657639	Auto-generated from vocab creation	business	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/topics%2Fimages%2Ffef3c346-4849-4f0f-9166-8dc39e22deb2.png?alt=media
\.


--
-- Data for Name: types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.types (id, created_at, updated_at, name) FROM stdin;
1	2025-11-12 12:10:05.195351	2025-11-12 12:10:05.195418	noun
2	2025-11-12 12:10:12.05656	2025-11-12 12:10:12.056577	verb
3	2025-11-12 12:10:12.99983	2025-11-12 12:10:12.999856	adjective
4	2025-11-12 12:10:18.644474	2025-11-12 12:10:18.644483	mẫu hoa văn
\.


--
-- Data for Name: user_game_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_game_settings (id, created_at, updated_at, image_word_total_pairs, quick_quiz_time_per_question, quick_quiz_total_questions, word_definition_total_pairs, user_id) FROM stdin;
16050c86-e2eb-4a5f-b64c-dfca9fcaf36b	2025-11-14 12:20:08.528022	2025-11-14 12:20:08.528305	5	10	5	5	68d0e081-c30d-4013-aaad-71f66e345a39
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_roles (user_id, role_id) FROM stdin;
a67776ee-d02c-4d9a-8b40-548a1017f284	2
a67776ee-d02c-4d9a-8b40-548a1017f284	1
80e0aba9-a8f6-4bd0-b844-2db35c45b4e9	1
80e0aba9-a8f6-4bd0-b844-2db35c45b4e9	2
0231fef6-69e6-4ada-998c-e665499890fd	2
68d0e081-c30d-4013-aaad-71f66e345a39	2
\.


--
-- Data for Name: user_vocab_progress; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_vocab_progress (id, created_at, updated_at, ef_factor, interval_days, last_reviewed, next_review_date, repetition, status, times_correct, times_wrong, user_id, vocab_id) FROM stdin;
93040267-0986-4490-9600-5b0ef873469e	2025-11-14 12:32:11.30499	2025-11-14 12:32:11.305045	2.5	1	2025-11-14	2025-11-15	0	NEW	1	0	68d0e081-c30d-4013-aaad-71f66e345a39	859a67dd-5dd0-4193-9d04-87fc41a03c59
0f450403-d880-4403-a8d6-79cd2368b5f1	2025-11-14 12:32:11.323631	2025-11-14 12:32:11.32366	2.5	1	2025-11-14	2025-11-15	0	NEW	1	0	68d0e081-c30d-4013-aaad-71f66e345a39	2f6a493d-722f-46cc-8c97-56622c5818e1
ce49b039-a3ab-4043-975e-ff03b5a87e80	2025-11-14 12:32:11.334085	2025-11-14 12:32:11.334138	2.5	1	2025-11-14	2025-11-15	0	NEW	1	0	68d0e081-c30d-4013-aaad-71f66e345a39	8e1da24a-731c-46ad-89c2-014d0b0abbab
3e6a0056-51ac-404e-b808-fb025368bddb	2025-11-14 12:32:11.342879	2025-11-14 12:32:11.342914	2.5	1	2025-11-14	2025-11-15	0	NEW	1	0	68d0e081-c30d-4013-aaad-71f66e345a39	3a0df300-b644-43b2-8ff2-baf58db0a9f5
05cd7357-d3fc-4ed6-8d26-d04f135b75a1	2025-11-14 12:32:11.35192	2025-11-14 12:32:11.351962	2.5	1	2025-11-14	2025-11-15	0	NEW	1	0	68d0e081-c30d-4013-aaad-71f66e345a39	c315d0f6-f15c-4fc0-87dd-430ed1f47672
17aeacae-bf70-4ada-896e-70ed52930c23	2025-11-14 12:35:00.919399	2025-11-14 12:35:00.919425	2.5	1	2025-11-14	2025-11-15	0	NEW	1	0	68d0e081-c30d-4013-aaad-71f66e345a39	0841a70f-c509-47f2-92e4-236a48797f80
b952cbdb-ebac-4f4a-9185-df93ac5ef1a8	2025-11-14 12:35:00.927089	2025-11-14 12:35:00.927124	2.5	1	2025-11-14	2025-11-15	0	NEW	1	0	68d0e081-c30d-4013-aaad-71f66e345a39	ca4db7c3-0f35-48dc-b95e-706dd677502e
651e7e5b-1e11-44a1-8171-42c868b5f05f	2025-11-14 12:35:00.93489	2025-11-14 12:35:00.934919	2.5	1	2025-11-14	2025-11-15	0	NEW	1	0	68d0e081-c30d-4013-aaad-71f66e345a39	eb523b41-fb1b-48d9-9aed-05dfc7760bc1
f3edee94-91fc-4019-adb2-718c58b04f19	2025-11-14 12:35:00.94206	2025-11-14 12:35:00.94209	2.5	1	2025-11-14	2025-11-15	0	NEW	1	0	68d0e081-c30d-4013-aaad-71f66e345a39	7df11371-9269-472a-a403-5032e60a6823
e79aa4b9-a9a5-4492-8378-06fca9c1079e	2025-11-14 12:35:00.972078	2025-11-14 12:35:00.972114	2.5	1	2025-11-14	2025-11-15	0	NEW	1	0	68d0e081-c30d-4013-aaad-71f66e345a39	22124e5f-d914-45a9-9bd3-311453433cf8
8184074b-5525-4c65-85a4-21a068e5cb41	2025-11-14 12:41:44.576898	2025-11-14 12:41:44.576943	2.5	1	2025-11-14	2025-11-15	0	NEW	0	1	68d0e081-c30d-4013-aaad-71f66e345a39	15c41d03-b901-49e4-9b19-43befd322627
437f22fe-7926-4ede-b16f-5174a845212f	2025-11-14 12:41:54.558048	2025-11-14 12:41:54.558084	2.5	1	2025-11-14	2025-11-15	0	NEW	0	1	68d0e081-c30d-4013-aaad-71f66e345a39	830dde69-2c19-429a-bf42-9c0b7bf7a022
6f359f9c-9259-4f51-a6e3-7c9a03d0c392	2025-11-14 12:42:00.001189	2025-11-14 12:42:00.001215	2.5	1	2025-11-14	2025-11-15	1	NEW	1	0	68d0e081-c30d-4013-aaad-71f66e345a39	02524785-3026-48f4-b538-9f32298d5736
63c78edf-218e-4361-88ac-215de9588d38	2025-11-14 12:42:06.321964	2025-11-14 12:42:06.321994	2.5	1	2025-11-14	2025-11-15	0	NEW	0	1	68d0e081-c30d-4013-aaad-71f66e345a39	b64837cb-2e32-4646-b070-dfdc013ca3fa
1ccdbdd9-24f6-4d89-bc51-33798e581481	2025-11-14 12:41:50.14969	2025-11-16 15:45:52.998516	2.1799999999999997	1	2025-11-16	2025-11-17	0	KNOWN	1	1	68d0e081-c30d-4013-aaad-71f66e345a39	e28ea120-607e-4bf4-b437-8009011bc135
ad4d25b6-2084-457e-8f25-33e41552a5b4	2025-11-17 11:30:54.740556	2025-11-17 11:30:54.740593	2.5	1	2025-11-17	2025-11-18	0	NEW	0	1	80e0aba9-a8f6-4bd0-b844-2db35c45b4e9	78042145-2403-4c7d-adae-554f08965db0
83fec7be-072c-4280-bb6c-abda15a45614	2025-11-17 11:30:58.394531	2025-11-17 11:30:58.394621	2.5	1	2025-11-17	2025-11-18	0	NEW	0	1	80e0aba9-a8f6-4bd0-b844-2db35c45b4e9	830dde69-2c19-429a-bf42-9c0b7bf7a022
ab5ab030-2411-4f61-9a06-3cedcadab867	2025-11-17 11:31:01.596943	2025-11-17 11:31:01.59698	2.5	1	2025-11-17	2025-11-18	1	NEW	1	0	80e0aba9-a8f6-4bd0-b844-2db35c45b4e9	8f6cd00b-6784-4e6e-88dd-76984709d7dd
61604f4d-055c-4c66-9363-7c7eb5a9647d	2025-11-17 11:31:05.188335	2025-11-17 11:31:05.188353	2.5	1	2025-11-17	2025-11-18	1	NEW	1	0	80e0aba9-a8f6-4bd0-b844-2db35c45b4e9	6e48003f-c4c4-4e6c-9ded-b954bc7a66eb
92a0860e-860f-4d1a-9ba4-634aef8405f3	2025-11-17 11:31:08.149712	2025-11-17 11:31:08.149733	2.5	1	2025-11-17	2025-11-18	0	NEW	0	1	80e0aba9-a8f6-4bd0-b844-2db35c45b4e9	a42fb061-d0a3-4fa9-a51b-1eade4ca02b9
46ca5707-b236-4246-8bfe-f91a8b5b4e71	2025-11-17 18:53:29.864065	2025-11-17 18:53:29.864096	2.5	1	2025-11-17	2025-11-18	0	NEW	0	1	80e0aba9-a8f6-4bd0-b844-2db35c45b4e9	d3d30637-4e02-4b5b-aa05-5bea49dba687
36b578c0-ed5d-44a2-b16a-1c7c8f059f2d	2025-11-17 18:54:11.56522	2025-11-17 18:54:11.56525	2.5	1	2025-11-17	2025-11-18	0	NEW	0	1	80e0aba9-a8f6-4bd0-b844-2db35c45b4e9	154fb5c1-e8cf-4333-93d3-0fdc0d25c280
7ac7c2d7-854b-4baa-b4e2-ed20db2160ec	2025-11-17 18:54:18.767432	2025-11-17 18:54:18.767501	2.5	1	2025-11-17	2025-11-18	0	NEW	0	1	80e0aba9-a8f6-4bd0-b844-2db35c45b4e9	9ff88cd7-7d55-4d8f-8bdb-780035bd1858
c7d3087a-7b83-4038-8a28-93c5a140d67b	2025-11-17 18:54:24.324085	2025-11-17 18:54:24.32412	2.5	1	2025-11-17	2025-11-18	0	NEW	0	1	80e0aba9-a8f6-4bd0-b844-2db35c45b4e9	67855177-90ed-4f1a-b473-d4e0e5e14204
e8d9fbed-f9fd-4036-bff2-048e33cc3428	2025-11-17 18:54:27.947825	2025-11-17 18:54:27.947852	2.5	1	2025-11-17	2025-11-18	0	NEW	0	1	80e0aba9-a8f6-4bd0-b844-2db35c45b4e9	f0086b87-8b1b-4cbf-897d-30dfdf1c8bde
922baf11-642f-49cc-80d2-a5ce5df2860b	2025-11-17 18:54:44.170639	2025-11-17 18:54:44.170684	2.5	1	2025-11-17	2025-11-18	1	NEW	1	0	80e0aba9-a8f6-4bd0-b844-2db35c45b4e9	3e902e56-5be7-44f3-b720-78453268523b
5a8aa535-26c4-4cd2-a238-32cfa33edf90	2025-11-17 18:54:56.669193	2025-11-17 18:54:56.669223	2.5	1	2025-11-17	2025-11-18	0	NEW	0	1	80e0aba9-a8f6-4bd0-b844-2db35c45b4e9	64caeaed-1a63-4b5a-87e4-8305762822f7
e4cb7b4c-e1d7-455e-b77d-5664b977e504	2025-11-17 18:55:03.568339	2025-11-17 18:55:03.568362	2.5	1	2025-11-17	2025-11-18	0	NEW	0	1	80e0aba9-a8f6-4bd0-b844-2db35c45b4e9	b82c614e-0457-4514-8c86-1003eab624b9
87072f21-ab10-4c7a-87d2-a6f584207fb9	2025-11-17 18:55:12.252165	2025-11-17 18:55:12.252201	2.5	1	2025-11-17	2025-11-18	0	NEW	0	1	80e0aba9-a8f6-4bd0-b844-2db35c45b4e9	5fee7ae3-46ec-4bd9-ab6c-cbdd35d13b83
cac82989-14e2-458d-b61e-c811214edf23	2025-11-17 18:55:16.29733	2025-11-17 18:55:16.297359	2.5	1	2025-11-17	2025-11-18	1	NEW	1	0	80e0aba9-a8f6-4bd0-b844-2db35c45b4e9	ad50fa9d-3d44-416b-b8db-115e4748a685
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, created_at, updated_at, activated, activation_expired_date, activation_key, avatar, banned, current_level, current_streak, date_of_birth, email, gender, last_activity_date, level_test_completed, longest_streak, name, next_activation_time, password, status, total_study_days) FROM stdin;
a67776ee-d02c-4d9a-8b40-548a1017f284	2025-11-12 12:09:09.720466	2025-11-12 12:09:09.720562	t	\N	\N	\N	f	A1	0	1990-01-01	admin1@cardwords.com	Nam	\N	f	0	Quản trị viên 1	\N	$2a$10$BAO5l7YcGlktRJR6/r.wc.mUFvveSJ5vbPnffDuLd9IzfSjA3mJ6e	ACTIVE	0
0231fef6-69e6-4ada-998c-e665499890fd	2025-11-12 18:37:04.053672	2025-11-12 18:37:04.053765	t	\N	\N	https://lh3.googleusercontent.com/a/ACg8ocIW78u-wYJP0fc8bYK_2mIplyShXnEb0D3tj6lPVbv_Tsu8mW7f=s96-c	f	A1	0	\N	thuanxinhtrai63@gmail.com	\N	\N	f	0	Ngô Minh Thuận	\N	$2a$10$zglidI1VK/taTMEK8Y1rUeHQj92V8nB4dlg8h5cn.7PCiLcEACKKm	\N	0
68d0e081-c30d-4013-aaad-71f66e345a39	2025-11-13 12:18:43.600402	2025-11-16 17:56:28.23224	t	\N	\N	\N	f	A1	1	1990-01-01	cardwordsgame@gmail.com	Nam	2025-11-16	f	1	Nguyễn Văn C	\N	$2a$10$x8bP24u1HgA2Q.e57G3MLexgW51IBmn9KYt2gngD//edrzi6x0gvq	ACTIVE	2
80e0aba9-a8f6-4bd0-b844-2db35c45b4e9	2025-11-12 12:09:09.913444	2025-11-17 11:36:17.220084	t	\N	\N	\N	f	A1	1	1992-02-02	admin2@cardwords.com	Nam	2025-11-17	f	1	Quản trị viên 2	\N	$2a$10$x/Q/4naZVlyNqBZJH8Ixu.BJgZ8ZmyYJfKgjeFfEBROKVingUixsW	ACTIVE	1
\.


--
-- Data for Name: vocab; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vocab (id, created_at, updated_at, audio, cefr, credit, example_sentence, img, interpret, meaning_vi, transcription, word, topic_id) FROM stdin;
2c152098-7f90-4a19-b5bb-1f94f689bcbf	2025-11-12 13:02:10.335227	2025-11-12 16:23:31.830762	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fcfddb066-c5a1-4d27-95e0-8fdfb86797fc.mp3?alt=media	A1		[Work] The park was recorded carefully in the report. | [Problem] The park broke suddenly, so we had to fix it. | [Story] A traveler found a park near the old doorway.	\N	A public green area for recreation.	công viên	pɑːk	park	10
dd378064-30a3-4209-b3e4-1a73918cdc3c	2025-11-12 13:02:10.436522	2025-11-12 16:23:31.927502	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc7bdfc4c-3f20-463f-85fb-435d3b757873.mp3?alt=media	A2	“British Museum Great Court.jpg” by Diliff, source: https://commons.wikimedia.org/wiki/File:British_Museum_Great_Court.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).	[Shopping] She compared three museums and chose the freshest one. | [Advice] Keep the museum away from dust to stay safe. | [Hobby] He collects photos of museums from different countries.	\N	A building displaying objects of cultural or historical interest.	bảo tàng	mjuˈziːəm	museum	10
cc63ef3a-7344-4dd0-aa70-bcdc257eed34	2025-11-12 13:02:14.491849	2025-11-12 16:23:42.9629	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4ae44571-25ff-4cf3-9ccb-362a975dd694.mp3?alt=media	B1		[Community] Donate to charity. | [Organization] Support a local charity. | [Event] Attend a charity fundraiser.	\N	An organization or act of giving to help those in need.	từ thiện	ˈtʃærəti	charity	32
2dd4d526-5575-45e5-9285-cf69dee83912	2025-11-12 13:02:14.505941	2025-11-12 16:23:42.991264	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5a8b9837-0218-4476-b6cd-f1cf8a8864cf.mp3?alt=media	B2		[Event] Organize a fundraiser event. | [Charity] Attend a fundraiser dinner. | [Cause] Fundraisers support projects.	\N	An event or campaign to raise money for a cause.	gây quỹ	ˈfʌndreɪzə	fundraiser	32
ae8c73c5-e8c3-4a08-9a26-910b36a293da	2025-11-12 12:10:14.074591	2025-11-12 12:10:14.074619	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Faba2a0f5-6a81-4c91-843f-fd98d7adfd33.mp3?alt=media	A2		[Description] That message looks heavy in the afternoon light. | [Memory] This message reminds me of my childhood in the countryside. | [Problem] The message broke suddenly, so we had to fix it.	\N	A verbal, written, or recorded communication sent to a person or group.	tin nhắn	ˈmesɪdʒ	message	20
e8a0f006-0830-4356-b9fb-f8f95165aff8	2025-11-12 13:02:14.513026	2025-11-12 16:23:43.089317	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F98f7a326-c67e-45fd-bd62-866ad68cfe99.mp3?alt=media	B2		[Organization] Work for a nonprofit. | [Charity] Support nonprofit causes. | [Mission] Nonprofits help communities.	\N	An organization that uses its surplus to achieve its goals, not for profit.	phi lợi nhuận	ˌnɒnˈprɒfɪt	nonprofit	32
4f700034-7bc7-4773-860e-9d579188b099	2025-11-12 13:02:14.519976	2025-11-12 16:23:43.221755	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd025a804-cdb6-40c3-aeaf-efc81d569694.mp3?alt=media	B2		[Society] The activist fights for rights. | [Cause] Join activists for change. | [Protest] Activists demand justice.	\N	A person who campaigns for social or political change.	nhà hoạt động	ˈæktɪvɪst	activist	32
1118f1c5-35d3-4a49-be56-a93869ab8387	2025-11-12 13:02:14.534647	2025-11-12 16:23:43.302856	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F50a6e1e7-9c14-434f-9d28-3a2a68686733.mp3?alt=media	B2		[Community] Organize outreach programs. | [Support] Outreach helps the homeless. | [Effort] Expand outreach efforts.	\N	The act of reaching out to provide services or support.	tiếp cận cộng đồng	ˈaʊtriːtʃ	outreach	32
074c4480-4ef1-4daf-a02a-aac169bab7ee	2025-11-12 13:02:14.541302	2025-11-12 16:23:43.397417	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdb8de5c7-4167-4771-9876-5ed91e0ea002.mp3?alt=media	B2		[Community] Launch a community initiative. | [Project] Support green initiatives. | [Leadership] Take initiative at work.	\N	A new plan or action to achieve a goal.	sáng kiến	ɪˈnɪʃətɪv	initiative	32
00050568-175b-4ac2-96de-b92c451691f8	2025-11-12 13:02:14.55641	2025-11-12 16:23:43.640504	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff1167983-2a57-4696-bc23-35b307c7bcc2.mp3?alt=media	A2		[Transport] Take the tram downtown. | [City] Trams are eco-friendly. | [Route] Follow the tram schedule.	\N	A vehicle running on rails, typically in cities.	xe điện	træm	tram	5
d386d78d-d6b3-46d1-9b82-ca95d1864774	2025-11-12 13:02:14.563547	2025-11-12 16:23:43.835244	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F473fa7c0-92a6-408d-9040-f140f4d8edcb.mp3?alt=media	A2		[Transport] Ride a scooter in the city. | [Fun] Rent an electric scooter. | [Mobility] Scooters are convenient.	\N	A two-wheeled vehicle, often motorized, for personal transport.	xe tay ga	ˈskuːtə	scooter	5
8c1446bd-0a4e-40cd-a26a-0f097b1c1b9e	2025-11-12 13:02:14.577817	2025-11-12 16:23:43.949827	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5b7c0b00-fd50-47cb-9d42-62fc58867c11.mp3?alt=media	A2		[Travel] Carry a backpack for hiking. | [School] Use a backpack for books. | [Trip] Pack essentials in the backpack.	\N	A bag carried on the back, often for travel or hiking.	ba lô	ˈbækpæk	backpack	5
dd70a898-48e5-4a83-833c-d57da8e1c5fb	2025-11-12 13:02:14.586063	2025-11-12 16:23:44.220601	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbc3c95cb-5d34-4284-bd78-968b59e158aa.mp3?alt=media	A2		[Fitness] Complete a daily workout. | [Exercise] Try a new workout routine. | [Health] Workout improves strength.	\N	A session of physical exercise or training.	buổi tập luyện	ˈwɜːkaʊt	workout	33
53f5ec1a-e275-4e85-a8c0-532fef9b57bc	2025-11-12 13:02:14.600853	2025-11-12 16:23:44.455307	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F40faa0f3-36dc-4281-9722-62058cc74b80.mp3?alt=media	A2		[Sports] Check the game score. | [Match] Score a goal in soccer. | [Record] Keep track of scores.	\N	The number of points earned in a game or competition.	điểm số	skɔː	score	33
ae4ddfbb-3d13-403c-b59b-0f92cc3e0627	2025-11-12 13:02:14.607898	2025-11-12 16:23:44.523185	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd05aa819-5941-43a8-853b-c1ea5520600f.mp3?alt=media	A2		[Sports] Cheer for the champion. | [Competition] Become a chess champion. | [Victory] The champion won gold.	\N	A person or team that wins a competition.	nhà vô địch	ˈtʃæmpiən	champion	33
cb5d9aec-39e4-4423-82a9-644d3861ad9e	2025-11-12 13:02:14.621875	2025-11-12 16:23:44.574815	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1ed68ec3-9db0-41e6-9da5-c64933b6bf54.mp3?alt=media	B2		[Fitness] Build stamina with running. | [Sports] Stamina helps in marathons. | [Health] Improve your stamina.	\N	The ability to sustain prolonged physical or mental effort.	sức bền	ˈstæmɪnə	stamina	33
321ad9bb-7d33-4dce-93aa-fddd264d3443	2025-11-12 13:02:14.645588	2025-11-12 16:23:44.959638	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F350043b9-1e98-4b02-a0b4-aedb879cba11.mp3?alt=media	B2		[Art] Create an abstract painting. | [Style] Abstract art is unique. | [Exhibit] Show abstract works.	\N	Art or ideas that do not represent reality directly.	trừu tượng	ˈæbstrækt	abstract	34
827d3f45-f8ec-4139-9ae2-565f33776469	2025-11-12 13:02:14.652706	2025-11-12 16:23:45.064226	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fad0af7b2-11ab-4ac2-b366-38c8b9dbaf4b.mp3?alt=media	B2		[Art] The painting is a masterpiece. | [Museum] View the artist's masterpiece. | [Creation] Produce a literary masterpiece.	\N	A work of outstanding artistry, skill, or workmanship.	tác phẩm xuất sắc	ˈmɑːstəpiːs	masterpiece	34
2e3693ec-e8dc-4cdc-94f2-7251a1d95b91	2025-11-12 13:02:14.680614	2025-11-12 16:23:45.463273	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fcfe4ab3b-5386-461b-862f-e90bf457bbd8.mp3?alt=media	B2		[Literature] The antagonist creates conflict. | [Story] Defeat the antagonist. | [Film] The antagonist opposes the hero.	\N	A character who opposes the protagonist in a story.	nhân vật phản diện	ænˈtæɡənɪst	antagonist	35
5da17287-9084-407c-bc4a-86a09fe7d5f3	2025-11-12 12:10:11.559259	2025-11-12 12:10:11.55931	null	A1	“Job fair.jpg” by US Department of Labor, source: https://commons.wikimedia.org/wiki/File:Job_fair.jpg, license: Public Domain (https://creativecommons.org/publicdomain/mark/1.0/).	[Shopping] She compared three jobs and chose the freshest one. | [Advice] Keep the job away from fire to stay safe. | [Hobby] He collects photos of jobs from different countries.	\N	A paid position of regular employment.	công việc	dʒɒb	job	4
ca3b8e66-f7f2-42a9-ab95-2cb46a1cd619	2025-11-12 13:02:14.688392	2025-11-12 16:23:45.518112	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F02d32a7b-6078-4f57-a837-b15082f9fce6.mp3?alt=media	B2		[Literature] The story reaches its climax. | [Film] The climax surprises viewers. | [Plot] Build tension to the climax.	\N	The most intense or exciting point in a story.	đỉnh điểm	ˈklaɪmæks	climax	35
811a1a75-5725-4df2-96e6-9e7e6bcd9a98	2025-11-12 13:02:14.660578	2025-11-12 16:24:02.381509	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa9bebfdc-de9d-4b49-9257-534c69ca9555.mp3?alt=media	A2		[Art] Use a fine brush. | [Painting] Clean the paint brush. | [Tool] Buy new brushes for art.	\N	A tool with bristles used for painting or cleaning.	bút vẽ	brʌʃ	brush	34
53c50a4f-cae0-4912-95ce-d64693c554d8	2025-11-12 13:02:14.702662	2025-11-12 16:23:45.786724	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa9849f49-1fe1-4ba4-9e0a-23bbbe53ce4e.mp3?alt=media	B1		[Literature] The dove is a symbol of peace. | [Art] Use symbols in writing. | [Culture] Symbols carry meaning.	\N	An object or image representing something else.	biểu tượng	ˈsɪmbl	symbol	35
f90f4069-0b58-4cd5-b037-a0d23b59a823	2025-11-12 13:02:14.722193	2025-11-12 16:23:45.826383	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F81e7d875-ca4a-445a-9a73-a574faa49db8.mp3?alt=media	B2		[Literature] Share a folktale with kids. | [Culture] Folktales teach morals. | [Story] Retell ancient folktales.	\N	A traditional story passed down orally within a culture.	truyện dân gian	ˈfəʊkteɪl	folktale	35
d2bbacc0-e9ea-4763-b945-753361a51ecc	2025-11-12 13:02:14.728989	2025-11-12 16:23:46.01503	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0ae74b87-8b5e-495a-8b6b-afe659583dd8.mp3?alt=media	B2		[Literature] Read a fable to children. | [Story] Fables teach lessons. | [Moral] The fable has a moral.	\N	A short story with animals as characters, teaching a moral.	ngụ ngôn	ˈfeɪbl	fable	35
0785be95-5804-42b1-916b-0be966d583e0	2025-11-12 13:02:14.742121	2025-11-12 16:23:46.143421	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4cae02d5-8bac-4d36-ba46-5963967acc65.mp3?alt=media	B1		[Work] Meet the project deadline. | [Publishing] Submit before the deadline. | [Stress] Work under deadline pressure.	\N	The time by which something must be completed.	hạn chót	ˈdedlaɪn	deadline	36
7600f77c-d799-40d2-a246-848721ed8051	2025-11-12 13:02:14.736222	2025-11-12 16:23:46.172412	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb356c789-6c19-421d-bbf2-909c6c271513.mp3?alt=media	B2		[Book] Submit to a publisher. | [Industry] Work for a publisher. | [Process] The publisher prints books.	\N	A company or person that prepares and issues books or other materials.	nhà xuất bản	ˈpʌblɪʃə	publisher	36
e086974f-5ac9-4d3f-9cf3-aa12a9db8808	2025-11-12 13:02:14.759774	2025-11-12 16:23:46.540998	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb86ddf4c-767d-467d-a9a7-7967e805e5b0.mp3?alt=media	B2		[Publishing] Earn royalties from books. | [Author] Receive royalty payments. | [Contract] Negotiate royalty rates.	\N	A payment made to an author or creator for their work.	tiền bản quyền	ˈrɔɪəlti	royalty	36
72bff958-63d1-4fe9-92cf-5485c219b8ce	2025-11-12 13:02:14.772295	2025-11-12 16:23:46.555441	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F31814f1c-418d-4013-b3d7-f823ce9ee76a.mp3?alt=media	B1		[News] The headline grabbed attention. | [Article] Write a catchy headline. | [Media] Read the latest headlines.	\N	The title of a news article or story.	tiêu đề	ˈhedlaɪn	headline	36
28c56e90-0aa4-4ccc-b1fc-2ddc6aab2bd2	2025-11-12 13:02:14.766939	2025-11-12 16:23:46.584091	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F877d6ed7-e56c-4b8c-b770-7ae873242830.mp3?alt=media	B2		[Media] The newspaper has a wide circulation. | [Health] Good circulation improves health. | [Economy] Money circulation boosts trade.	\N	The distribution or number of copies of a publication sold.	lưu hành (báo chí)/tuần hoàn	ˌsɜːkjəˈleɪʃn	circulation	36
5005a23b-67b5-4292-aa4d-c0d8f2dea29a	2025-11-12 13:02:14.785772	2025-11-12 16:23:46.805077	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F95dd0c94-e2cf-477e-96a2-374e12633ab4.mp3?alt=media	B2		[News] Read the editorial in the paper. | [Opinion] Write an editorial on politics. | [Media] The editorial sparked debate.	\N	An article expressing the opinion of the editor or publication.	bài xã luận	ˌedɪˈtɔːriəl	editorial	36
26dba188-bbf8-4be3-b984-9fd1b1195c5a	2025-11-12 13:02:14.790864	2025-11-12 16:23:46.936773	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbc16a0e8-6051-46d9-9af6-78eff1d8b154.mp3?alt=media	B2		[Career] Study journalism at university. | [Media] Journalism informs the public. | [Ethics] Practice ethical journalism.	\N	The profession of writing or reporting news for media.	báo chí	ˈdʒɜːnəlɪzəm	journalism	36
85ff5ac8-7ca0-402c-8dd9-e6ca46925ea4	2025-11-12 13:02:14.696193	2025-11-12 16:24:01.264625	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8ca3e982-a450-47e9-9490-a488186e7674.mp3?alt=media	B1		[Literature] Explore the story's theme. | [Book] The theme is love. | [Film] The theme shapes the narrative.	\N	The central idea or message in a work of art or literature.	chủ đề	θiːm	theme	35
9ffb6f21-0147-4e77-92c3-9f186e196fcd	2025-11-12 12:10:05.219678	2025-11-12 17:06:45.715976	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F58a7e413-454f-4b5c-8ee4-bfd1e297d257.mp3?alt=media	A1	“Apple on desk” by Bapple4747, source: https://commons.wikimedia.org/wiki/File:Apple_on_desk.jpg,\nlicense: CC0 1.0 (https://creativecommons.org/publicdomain/zero/1.0/).	[Advice] Keep the apple away from rain to stay safe. | [School] The teacher asked us to describe a apple in two sentences. | [Shopping] She compared three apples and chose the freshest one.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F4018283a-4dbf-4396-8ed2-b3ea4f49f8c2.jpeg?alt=media	A round fruit with crisp flesh and a sweet or tart taste, often eaten raw or used in cooking.	quả táo	ˈæpl	apple	1
736466d4-0e22-4369-a036-e54f155c5398	2025-11-12 13:02:11.318467	2025-11-12 16:23:31.93976	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3f78efc3-f708-4d50-aca6-c12b9f8a807c.mp3?alt=media	B1		[Work] The theater was recorded carefully in the report. | [Problem] The theater broke suddenly, so we had to fix it. | [Story] A traveler found a theater near the old counter.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F8caa942e-c158-46f2-ad12-6fbc15798ed1.jpg?alt=media	A building or area for dramatic performances.	nhà hát	ˈθɪətə	theater	19
cd24ee8c-d708-46c2-8c45-17bc20bf367e	2025-11-12 13:02:11.956561	2025-11-12 16:23:31.957505	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8334d08d-29ac-479b-99ce-0c437dc7b55d.mp3?alt=media	A2		[Event] The stadium was packed for the championship game. | [Tour] We visited the famous stadium during our city trip. | [Construction] The new stadium will host international matches.	\N	A large structure for sports and entertainment events.	sân vận động	ˈsteɪdiəm	stadium	6
2dc8f962-0f80-4008-ab71-4e6860238332	2025-11-12 13:02:14.809933	2025-11-12 16:23:47.124592	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fca345afb-c849-4bd9-8cb2-8a46d46c3f55.mp3?alt=media	B1		[Media] The press covered the event. | [News] Speak to the press. | [Journalism] Freedom of the press is vital.	\N	Newspapers or journalists collectively.	báo chí	pres	press	36
54d73f0a-2d18-4d85-816e-c6007ae01583	2025-11-12 13:02:14.81782	2025-11-12 16:23:47.318644	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc0856d74-7c8b-4069-a374-a7ff3447a2e3.mp3?alt=media	B2		[Media] Access the news archive. | [History] Archive old documents. | [Digital] Store files in the archive.	\N	A collection of historical documents or records.	lưu trữ	ˈɑːkaɪv	archive	36
c6910f69-e6d1-4aa6-bda6-a676b7182e2f	2025-11-12 13:02:14.830874	2025-11-12 16:23:47.575222	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa1394082-78d6-45cb-8faa-59d98e0c8a2f.mp3?alt=media	B2		[TV] Watch a news segment. | [Broadcast] Air a short segment. | [Show] The segment covers health tips.	\N	A part of a program or broadcast.	phân đoạn (chương trình)	ˈseɡmənt	segment	37
4b308bce-2444-4711-9503-e17939012d4f	2025-11-12 13:02:14.837152	2025-11-12 16:23:47.715488	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fde493211-ba1c-46e4-b889-377274160eee.mp3?alt=media	B1		[Media] Record in a TV studio. | [Music] Work in a recording studio. | [Broadcast] Visit the news studio.	\N	A room where broadcasts or recordings are made.	phòng thu	ˈstjuːdiəu	studio	37
1d6cd7c7-a599-4126-8e20-aefa3af45143	2025-11-12 13:02:09.59183	2025-11-12 16:23:31.960647	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe5789eda-50a1-498f-ac54-9be2a22ddf5f.mp3?alt=media	A1		[School] The teacher asked us to describe a library in two sentences. | [Everyday] I put the library on the desk before dinner. | [Advice] Keep the library away from dust to stay safe.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fad83df41-86ca-45b7-b14d-18e4a121411b.jpg?alt=media	A place where books and resources are stored for reading or study.	thư viện	ˈlaɪbrəri	library	3
48f931f7-abf4-498e-8a7d-591b5990b899	2025-11-12 13:02:12.303132	2025-11-12 16:23:32.358884	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb08e4710-fa76-4628-92c2-18f2ff370191.mp3?alt=media	A2		[Culture] The temple was a peaceful place for meditation. | [Travel] We visited an ancient temple during our trip to Asia. | [History] The temple’s architecture reflected centuries-old traditions.	\N	A building devoted to the worship of a god or gods.	đền; chùa	ˈtempl	temple	10
6a57cde8-175e-4a43-9bf8-69a2ea0dd3e7	2025-11-12 13:01:47.842848	2025-11-12 13:01:47.842848	\N	\N	\N	Câu ví dụ số 39	\N	\N	nghĩa số 39	/test/	bulk_test_39	1
d7d68f0f-3938-4875-9bfe-ee13cc2cd99e	2025-11-12 13:02:12.143788	2025-11-12 16:23:32.358887	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F39faf8c4-877c-473f-bc0a-7ec99a1c21fb.mp3?alt=media	A1		[Vacation] We built sandcastles on the beach during the holiday. | [Relaxation] The sound of waves on the beach was so calming. | [Activity] They played volleyball on the beach in the evening.	\N	A sandy or pebbly shore by a body of water.	bãi biển	biːtʃ	beach	8
6f0c9a55-400e-48ad-8bc5-9b3324f8bddc	2025-11-12 13:02:14.849469	2025-11-12 16:23:47.774493	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffaa05b4f-05f2-4cf4-9ec1-8afc37a8714a.mp3?alt=media	B1		[Media] Watch streaming movies. | [Technology] Use a streaming platform. | [Live] Streaming concerts is popular.	\N	The continuous transmission of audio or video over the internet.	phát trực tuyến	ˈstriːmɪŋ	streaming	37
8860e79a-d38b-4265-a6a9-aa2639428f56	2025-11-12 13:02:14.856856	2025-11-12 16:23:47.897331	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd9c3c2aa-ff48-4bd5-b70e-cb89c9ca40b4.mp3?alt=media	B2		[News] The correspondent reported live. | [Media] Follow the foreign correspondent. | [Journalism] Hire a war correspondent.	\N	A journalist reporting news from a particular location.	phóng viên	ˌkɒrəˈspɒndənt	correspondent	37
bb32ba75-a22c-4507-9c92-2b952756db94	2025-11-12 13:02:14.8706	2025-11-12 16:23:48.105268	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb4cf3b7d-fe2e-44ac-a7ff-7949102efab5.mp3?alt=media	B2		[Media] Watch the telecast tonight. | [Broadcast] Telecast the football match. | [Event] The telecast reached millions.	\N	A television broadcast.	phát sóng truyền hình	ˈtelɪkɑːst	telecast	37
927074d2-ed34-4665-986a-40e26f61df6f	2025-11-12 13:02:14.877821	2025-11-12 16:23:48.111804	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F350694d8-61ad-4232-89ec-04a3d1939063.mp3?alt=media	B1		[Broadcast] Improve the TV signal. | [Technology] Check the signal strength. | [Communication] Send a clear signal.	\N	An electronic or visual indication used for communication.	tín hiệu	ˈsɪɡnəl	signal	37
57876120-02eb-44f1-bf43-3bbd82b85414	2025-11-12 13:02:14.893143	2025-11-12 16:23:48.389761	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F936ed011-7d17-4e8f-a7ae-92c97891ede8.mp3?alt=media	B1		[Society] Ignore the false rumor. | [Media] Rumors spread quickly online. | [News] Confirm or deny the rumor.	\N	An unverified story or piece of information circulating among people.	tin đồn	ˈruːmə	rumor	38
b54dc0c2-6837-4511-b086-e76695ba9bc0	2025-11-12 13:02:12.615643	2025-11-12 16:23:33.88919	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F087ed340-2f52-4b08-8468-0df13d16ef8c.mp3?alt=media	A2		[Celebration] The parade featured colorful floats and music. | [Community] The town organizes a parade every summer. | [Culture] The parade showcased traditional costumes and dances.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F2590e784-702d-4dfe-9584-11361e7ddddf.jpeg?alt=media	A public procession, especially one celebrating a special day.	cuộc diễu hành	pəˈreɪd	parade	14
80b860e3-a6b8-442e-86de-f7d4f954f47b	2025-11-12 13:02:13.953903	2025-11-12 16:23:34.719027	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Feb0c8850-d646-48e5-a26a-c50cdbeb8344.mp3?alt=media	B1		[Health] Avoid allergy triggers. | [Symptom] Allergies cause itching. | [Medicine] Take allergy medication.	\N	A condition where the body reacts to a substance, like pollen.	dị ứng	ˈælərdʒi	allergy	23
f0a321f4-eb5f-48d1-8638-dfc6757b6458	2025-11-12 13:02:09.154968	2025-11-12 13:02:09.154995	null	A1		[Problem] The fish broke suddenly, so we had to fix it. | [Description] That fish looks safe in the afternoon light. | [Work] The fish was recorded carefully in the report.	\N	An aquatic animal eaten as food, known for its nutritional value.	cá	fɪʃ	fish	1
457337e3-f5db-416f-81ce-f6e2cfbb7f58	2025-11-12 13:02:09.191268	2025-11-12 13:02:09.191301	null	A1	“Egg-3506222 1920.jpg” by congerdesign, source: https://commons.wikimedia.org/wiki/File:Egg-3506222_1920.jpg, license: CC0 1.0 (https://creativecommons.org/publicdomain/zero/1.0/).	[School] The teacher asked us to describe a egg in two sentences. | [Everyday] I put the egg on the shelf before dinner. | [Advice] Keep the egg away from sunlight to stay safe.	\N	A food item produced by birds, commonly used in cooking and baking.	trứng	eɡ	egg	1
e4c4d6ae-e4f9-442e-88ed-147c738b1032	2025-11-12 13:02:14.06097	2025-11-12 16:23:35.963353	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7c746feb-a874-485d-b899-5483d5b1a466.mp3?alt=media	A2		[Beauty] Apply makeup for the event. | [Style] Use natural makeup. | [Product] Buy quality makeup.	\N	Cosmetics used to enhance or alter appearance.	trang điểm	ˈmeɪkʌp	makeup	24
c8c738e3-b93a-4917-bd18-8ae166f66705	2025-11-12 13:02:12.153784	2025-11-12 16:23:36.019366	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F630af348-c8b0-4d49-9cfe-6d1fe915cef6.mp3?alt=media	A2		[Adventure] Crossing the desert required careful planning and supplies. | [Nature] The desert blooms with flowers after rare rainfall. | [Photography] The desert sunset created a dramatic landscape.	\N	A dry, barren area of land with little vegetation.	sa mạc	ˈdezərt	desert	8
8d3f81a4-8688-40ef-a191-f88c6a8e785a	2025-11-12 13:02:14.083237	2025-11-12 16:23:36.371927	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F425ea7a6-b839-46cd-9178-d94e6a773b86.mp3?alt=media	B2		[Geography] Italy is a peninsula. | [Map] Locate the peninsula on the map. | [Travel] Visit the peninsula's coast.	\N	A piece of land almost surrounded by water.	bán đảo	pəˈnɪnsjələ	peninsula	25
c8a8f89b-e631-4ce6-8167-a08c122f30ef	2025-11-12 13:02:10.935614	2025-11-12 16:23:37.178423	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4fabfdd5-8f3a-4d8b-9393-04a27b33688d.mp3?alt=media	C1		[Story] A traveler found a hypothesis near the old floor. | [Work] The hypothesis was recorded carefully in the report. | [Everyday] I put the hypothesis on the floor before dinner.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F210afe77-21e3-4f96-bdcc-829e3f3f2e69.jpg?alt=media	A proposed explanation made on the basis of limited evidence.	giả thuyết	haɪˈpɒθəsɪs	hypothesis	15
c959c7ca-bb2c-4b4d-b924-c85a3669dfcb	2025-11-12 13:02:09.661251	2025-11-12 16:23:37.596067	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5684d4a2-614c-48cb-adfa-74b1816353b2.mp3?alt=media	A2		[Problem] The engineer broke suddenly, so we had to fix it. | [Description] That engineer looks safe in the afternoon light. | [Work] The engineer was recorded carefully in the report.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fccd03f10-f871-4acd-8f2a-db1e166d005e.jpg?alt=media	A person who designs and builds machines, structures, or systems.	kỹ sư	ˌendʒɪˈnɪə	engineer	4
c49693d2-97fe-4ff2-870b-a5dc3229bc12	2025-11-12 12:10:23.197964	2025-11-12 16:24:05.416247	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0f8cef30-2e08-44ef-b72d-6fb828960d63.mp3?alt=media	B1		[Art] Practice photography outdoors. | [Hobby] Learn photography basics. | [Culture] Photography captures moments.	\N	The art of taking and processing photographs.	nhiếp ảnh	fəˈtɒɡrəfi	photography	56
d3079c79-096c-489b-907b-2d89b0e48216	2025-11-12 12:10:23.277472	2025-11-12 16:24:06.23307	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb1a9a95c-a4dd-4f88-a1a6-388fa0f5ed8d.mp3?alt=media	A2		[Culture] Follow the latest fashion. | [Art] Design fashion clothing. | [Industry] Fashion trends change yearly.	\N	The style or trend in clothing or accessories.	thời trang	ˈfæʃn	fashion	57
44f2140a-2a22-40d5-b89d-9f70c485098a	2025-11-12 13:02:09.340948	2025-11-12 13:02:09.341259	null	A1		[Everyday] I put the man on the bag before dinner. | [Story] A traveler found a man near the old bag. | [School] The teacher asked us to describe a man in two sentences.	\N	An adult male human, often contributing to society through various roles.	người đàn ông	mæn	man	2
b28a7d92-ceea-4af5-94d6-b248549f94db	2025-11-12 13:02:14.04028	2025-11-12 16:24:06.567295	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fcf5bba29-f4f9-46c1-b1f5-5e6fd5fec222.mp3?alt=media	A2		[Material] Choose soft fabric. | [Sewing] Buy cotton fabric. | [Design] Use fabric for dresses.	\N	Material made by weaving or knitting fibers.	vải	ˈfæbrɪk	fabric	24
a7240bcd-a764-4222-8b50-b4438a73b006	2025-11-12 13:02:12.383146	2025-11-12 16:24:07.14849	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F67cc9811-ad92-4fd6-8b66-bcd7d00d4086.mp3?alt=media	A2		[Technology] The new device can charge without any wires. | [Home] She controls the lights with a smart home device. | [Work] Employees were trained to use the new office device.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fb6163e63-c2ab-4f94-8e9f-2d2f6ad92e84.jpg?alt=media	A piece of equipment designed for a particular purpose.	thiết bị	dɪˈvaɪs	device	11
a4509e82-820f-4c6e-aae2-af656e916bf7	2025-11-12 13:02:13.897091	2025-11-12 16:23:33.583663	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1318abba-62bb-4355-a66b-d2699f4fc0c1.mp3?alt=media	B1		[Celebration] Mark a wedding anniversary. | [Event] Plan an anniversary dinner. | [Memory] Celebrate a special anniversary.	\N	The yearly recurrence of a notable event, like a wedding.	kỷ niệm	ˌænɪˈvɜːsəri	anniversary	22
5b74f86c-8faa-4b96-8881-aaff4ce207c6	2025-11-12 13:02:13.932077	2025-11-12 16:23:34.421996	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6cb3d914-b11b-44bd-b27a-d5d05905c1d8.mp3?alt=media	A2		[Health] Check for a fever. | [Symptom] Fever indicates illness. | [Treatment] Reduce fever with medicine.	\N	An increase in body temperature above normal.	sốt	ˈfiːvə	fever	23
284be977-1d57-4d2d-a2e3-543878786244	2025-11-12 13:02:14.105277	2025-11-12 16:23:36.467655	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffcbf2031-0f33-4deb-8656-411cfaba129c.mp3?alt=media	B2		[Geography] Hike on the plateau. | [Landscape] The plateau offers great views. | [Geology] Study plateau formation.	\N	A flat, elevated area of land.	cao nguyên	ˈplætəʊ	plateau	25
cf60fdaf-86fb-45bb-8ab4-7314d293f301	2025-11-12 13:02:14.176597	2025-11-12 16:23:38.068953	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc053b677-7beb-460a-9343-7aa5d0a81cb7.mp3?alt=media	A2		[Hobby] Solve a jigsaw puzzle. | [Game] Try crossword puzzles. | [Fun] Puzzles challenge the mind.	\N	A game or problem designed to test ingenuity or knowledge.	câu đố	ˈpʌzl	puzzle	26
9fd7c448-de26-4677-b72d-1d85aab16e15	2025-11-12 13:02:14.260853	2025-11-12 16:23:39.650025	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0daf04a2-f06d-470c-b9ef-b35c0c91726e.mp3?alt=media	A2		[Cooking] Grill steaks outdoors. | [Tool] Use a barbecue grill. | [Food] Enjoy grilled vegetables.	\N	To cook food on a metal grate over an open flame.	nướng (thịt)	ɡrɪl	grill	27
c1302334-fec8-48a6-bb53-5c9f4cbf4830	2025-11-12 13:02:14.294996	2025-11-12 16:23:40.045312	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fffb022a2-aa3d-448c-85f9-126926307ba4.mp3?alt=media	B2		[HR] Manage the recruitment process. | [Company] Recruitment attracts talent. | [Job] Apply during recruitment.	\N	The process of finding and hiring new employees.	tuyển dụng	rɪˈkruːtmənt	recruitment	28
89faaf63-0df4-457f-ae62-3ce091cd8910	2025-11-12 13:02:14.351424	2025-11-12 16:23:40.846572	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2304ec91-e5aa-45bc-82d4-505d77230c53.mp3?alt=media	B1		[Business] Set clear objectives. | [Project] Meet project objectives. | [Plan] Align with team objectives.	\N	A specific goal or aim to be achieved.	mục tiêu	əbˈdʒektɪv	objective	29
8f27df91-39e3-4da7-b137-762a4444844f	2025-11-12 13:02:14.419473	2025-11-12 16:23:41.78123	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F21e25506-d4fc-403a-9531-5b0fcf8a7c91.mp3?alt=media	B2		[Society] Celebrate cultural diversity. | [Work] Promote diversity in teams. | [Community] Diversity enriches society.	\N	The inclusion of different types of people or cultures.	đa dạng	daɪˈvɜːsəti	diversity	30
74aaa5d8-9f08-435a-b02e-2959c458680a	2025-11-12 13:02:14.477808	2025-11-12 16:23:42.699448	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9f8592cb-224b-45f6-897a-0c9d6410b401.mp3?alt=media	B1		[Media] Stream movies online. | [Technology] Use a streaming service. | [Live] Stream a live event.	\N	To transmit or receive data, especially video, over the internet.	luồng (truyền dữ liệu)	striːm	stream	31
5bdc135d-c505-4cee-b6ca-ce49ed3fac52	2025-11-12 13:02:14.569451	2025-11-12 16:23:43.892271	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fed11fc85-deb1-459d-a447-ff40e3e31f29.mp3?alt=media	B1		[Travel] Wait at the boarding gate. | [Airport] Complete boarding procedures. | [Flight] Boarding starts soon.	\N	The act of getting on a plane, train, or ship.	lên máy bay	ˈbɔːdɪŋ	boarding	5
078632cf-fc79-4d28-9fa3-69e4dea84ee7	2025-11-12 13:02:12.997797	2025-11-12 16:23:45.142153	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F36cea70c-e7ec-4fc7-8202-1926479773c2.mp3?alt=media	A2		[Art] Draw a quick sketch. | [Design] Sketch ideas on paper. | [Artist] View the artist's sketches.	\N	A rough or unfinished drawing or outline.	phác thảo	sketʃ	sketch	19
7f8f79bd-9d3a-4d14-90ba-22ab156b9342	2025-11-12 13:02:14.67466	2025-11-12 16:23:45.474638	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0a5e2b98-43bf-44b1-be5f-20c9f58f531f.mp3?alt=media	B2		[Literature] The protagonist faces challenges. | [Story] Follow the protagonist's journey. | [Film] The protagonist saves the day.	\N	The main character in a story or drama.	nhân vật chính	prəˈtæɡənɪst	protagonist	35
27fe1367-5d6a-446b-a6f0-e0e3e87e91de	2025-11-12 13:02:14.716187	2025-11-12 16:23:45.786713	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8edc8853-72f1-4a8e-92ff-6647df08814e.mp3?alt=media	C1		[Literature] Irony adds depth to stories. | [Situation] The irony was unexpected. | [Humor] Use irony in writing.	\N	A situation or expression where the outcome or meaning is opposite to what is expected.	sự mỉa mai	ˈaɪrəni	irony	35
e942e98e-425f-4d51-a001-9281b4b47260	2025-11-12 13:02:14.842714	2025-11-12 16:23:47.712434	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F88dbb7ea-fd8e-487c-869f-ce9f07b1b873.mp3?alt=media	B2		[Media] Review the video footage. | [News] Share exclusive footage. | [Film] Capture live event footage.	\N	Raw video material used in broadcasting or filmmaking.	đoạn phim	ˈfʊtɪdʒ	footage	37
4774147a-a2d3-4705-a0ce-3264a98575b8	2025-11-12 13:02:14.909789	2025-11-12 16:23:48.502505	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F98fc8b0f-1ac4-4300-8c99-4eaf3f7b9ac9.mp3?alt=media	B2		[Media] Read a tabloid magazine. | [News] Tabloids focus on gossip. | [Journalism] Avoid tabloid-style reporting.	\N	A newspaper focusing on sensational or celebrity news.	báo lá cải	ˈtæblɔɪd	tabloid	38
f6bef4c6-30e7-4a99-bca9-193f9cd9d3cc	2025-11-12 13:02:13.97328	2025-11-12 16:23:59.437293	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4690952e-7e5a-41be-9b1a-e1aff1d7029d.mp3?alt=media	A2		[Health] Buy medicine at the pharmacy. | [Prescription] Fill prescription at pharmacy. | [Service] Consult the pharmacy staff.	\N	A store where medicines are dispensed and sold.	nhà thuốc	ˈfɑːməsi	pharmacy	23
a0b70ac1-2369-4ab3-ac39-704c331f6bc1	2025-11-12 13:02:13.996656	2025-11-12 16:24:06.677234	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3d0e3396-fe3e-4da3-a003-a2548a7554e5.mp3?alt=media	B1		[Fashion] Wear stylish accessories. | [Outfit] Choose accessories for the dress. | [Jewelry] Buy new accessories.	\N	An item that complements or enhances clothing.	phụ kiện	əkˈsesəri	accessory	24
5d97e6d6-a97e-4083-8d90-2fcf869c5063	2025-11-12 13:02:10.825334	2025-11-12 16:23:33.638134	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F661d24d5-1869-4a64-959b-1e97aed669a5.mp3?alt=media	A2		[Memory] This festival reminds me of my childhood in the countryside. | [Hobby] He collects photos of festivals from different countries. | [Description] That festival looks modern in the afternoon light.	\N	A day or period of celebration, typically for religious or cultural reasons.	lễ hội	ˈfestɪvl	festival	14
94585577-e407-41ee-96c9-8e44e516571b	2025-11-12 13:02:10.962029	2025-11-12 16:23:37.370992	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F12f17d69-2238-4fac-a153-3d2753a38297.mp3?alt=media	B2		[Description] That genetics looks heavy in the afternoon light. | [Memory] This genetics reminds me of my childhood in the countryside. | [Problem] The genetics broke suddenly, so we had to fix it.	\N	The study of heredity and the variation of inherited characteristics.	di truyền học	dʒəˈnetɪks	genetics	15
185fe36d-1c33-48f6-ada4-5ba75f7829b5	2025-11-12 13:02:14.169428	2025-11-12 16:23:38.02287	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8993567b-0a49-4e8c-aeb5-e741724de01d.mp3?alt=media	A2		[Hobby] Play chess with friends. | [Strategy] Learn chess moves. | [Competition] Join a chess club.	\N	A board game of strategy for two players.	cờ vua	tʃes	chess	26
1180bddd-a97a-4967-9b41-8fa1a138dceb	2025-11-12 13:02:09.840435	2025-11-12 13:02:09.840456	null	A1	“World map.jpg” by CIA World Factbook, source: https://commons.wikimedia.org/wiki/File:World_map.jpg, license: Public Domain (https://creativecommons.org/publicdomain/mark/1.0/).	[School] The teacher asked us to describe a map in two sentences. | [Everyday] I put the map on the bench before dinner. | [Advice] Keep the map away from children to stay safe.	\N	A diagrammatic representation of an area of land or sea showing physical features.	bản đồ	mæp	map	5
7a9de0dd-39f5-4d84-b190-d11948eb9b68	2025-11-12 13:02:14.238907	2025-11-12 16:23:39.440412	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff5d2f3c9-caac-4af7-9e87-ee339bf98f59.mp3?alt=media	A2		[Kitchen] Wear an apron while cooking. | [Protection] The apron prevents stains. | [Style] Choose a colorful apron.	\N	A garment worn over clothes to protect them while cooking.	tạp dề	ˈeɪprən	apron	27
e8e71b42-2ced-442d-a3ec-47465ba5f622	2025-11-12 13:02:16.118882	2025-11-12 16:24:06.74781	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffe123c67-94fe-4fbe-a1c4-e538c9b7fbdb.mp3?alt=media	A2		[Fashion] Develop your own style. | [Culture] Her style is unique. | [Design] Style defines trends.	\N	A distinctive manner of dressing or design.	phong cách	staɪl	style	57
911a4eb8-e048-46f2-9a03-5cb3b5d1389f	2025-11-12 13:02:11.03563	2025-11-12 16:23:40.237841	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F48416a2d-f649-43c2-b440-48793a4e3383.mp3?alt=media	B2		[School] The teacher asked us to describe a qualification in two sentences. | [Everyday] I put the qualification on the doorway before dinner. | [Advice] Keep the qualification away from pets to stay safe.	\N	A quality or accomplishment that makes someone suitable for a job or activity.	trình độ, bằng cấp	ˌkwɒlɪfɪˈkeɪʃn	qualification	16
b34617e0-9fa1-4969-868b-4f6d0cd4e4aa	2025-11-12 13:02:14.365569	2025-11-12 16:23:41.094741	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0d9216da-8109-4b01-a88e-42f36017049a.mp3?alt=media	B2		[Team] Encourage team collaboration. | [Project] Collaboration improves results. | [Business] Foster global collaboration.	\N	Working together to achieve a common goal.	sự hợp tác	kəˌlæbəˈreɪʃn	collaboration	29
e131a1d6-ec3c-472f-bc98-b6fd221cd7fc	2025-11-12 13:02:12.818225	2025-11-12 16:23:42.548277	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fcdcd6ff3-9b87-4710-b081-13c829f3d753.mp3?alt=media	B1		[Politics] The campaign focused on improving education. | [Marketing] The advertising campaign boosted product sales. | [Community] They launched a campaign to clean the river.	\N	An organized effort to achieve a political or social goal.	chiến dịch	kæmˈpeɪn	campaign	17
3b979a22-93e5-4f44-80f0-b843cce355e2	2025-11-12 13:02:14.527422	2025-11-12 16:23:43.283734	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F74858411-fe31-4d9a-b0f7-89b77b82e38b.mp3?alt=media	C1		[Society] Advocacy promotes equality. | [Cause] Support environmental advocacy. | [Policy] Advocacy influences laws.	\N	Public support for a cause or policy.	vận động chính sách	ˈædvəkəsi	advocacy	32
8a904e36-1ff1-4d69-95ba-3eba5f33cd66	2025-11-12 13:02:14.465242	2025-11-12 16:24:04.444816	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9ba2ba70-43a8-42b7-8a4b-ea888f482d16.mp3?alt=media	A2		[Media] Engage the audience. | [Event] Perform for a large audience. | [Show] The audience clapped loudly.	\N	A group of people who watch or listen to a performance or media.	khán giả	ˈɔːdiəns	audience	31
31a3a10b-a7a7-4cd6-b29b-f4d707e5c0c2	2025-11-12 12:10:13.433897	2025-11-12 16:23:54.972278	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6c84972a-5fb9-4809-80a9-1c03a15a4012.mp3?alt=media	B1		[Advice] Keep the experiment away from water to stay safe. | [School] The teacher asked us to describe a experiment in two sentences. | [Shopping] She compared three experiments and chose the freshest one.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F3b8c3731-6376-49d6-8c93-34d433090efb.jpg?alt=media	A scientific procedure to test a hypothesis or demonstrate a fact.	thí nghiệm	ɪkˈsperɪmənt	experiment	15
4b4fe656-f8b9-4f7f-af9a-ac492d2b4dcb	2025-11-12 13:02:12.691878	2025-11-12 16:23:57.014211	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5bce70e9-d4f0-4c84-aa82-b56f6ad9a525.mp3?alt=media	B1		[Science] Gravity keeps the planets orbiting the sun. | [Physics] The experiment tested the effects of gravity on objects. | [Education] He explained gravity using a falling apple as an example.	\N	The force that attracts objects towards the center of the Earth.	lực hấp dẫn	ˈɡrævɪti	gravity	15
8f4e866e-f320-4356-b6a7-bd102fb75276	2025-11-12 13:02:16.112253	2025-11-12 16:24:06.641459	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb790d60d-debe-4b0c-ba8f-69b36dd106d9.mp3?alt=media	B1		[Fashion] Design a floral pattern. | [Art] Use bold patterns. | [Industry] Patterns attract buyers.	\N	A design or template used in sewing or decoration.	mẫu (vải)	ˈpætən	pattern	57
54e7d5af-2e0f-4c67-a3b1-54cd4218c9cd	2025-11-12 13:02:14.301348	2025-11-12 16:23:40.108231	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F83d5d7bc-7e95-423f-9c98-9331f3e5d548.mp3?alt=media	B1		[Job] Select the best candidate. | [Election] Vote for the candidate. | [Interview] Meet the job candidate.	\N	A person applying for a job or running for a position.	ứng viên	ˈkændɪdeɪt	candidate	28
dc96f71f-453f-4422-aa9f-a4a68c9569af	2025-11-12 13:02:11.732295	2025-11-12 16:23:40.397958	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F413aa855-c96f-4180-9bc8-e9279beee943.mp3?alt=media	A2		[Work] He worked the night shift at the hospital last week. | [Schedule] The manager changed the shift times for better efficiency. | [Balance] She preferred the morning shift to have evenings free.	\N	A period of time worked by a group of workers.	ca làm việc	ʃɪft	shift	4
c8decee8-6865-4f78-84b2-01144d75040d	2025-11-12 13:02:14.309191	2025-11-12 16:23:40.470054	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd99faa7b-4227-4a5e-ad53-fa85ab7139c2.mp3?alt=media	B2		[Job] Provide a job reference. | [Document] Check candidate references. | [Support] Ask for a reference.	\N	A letter or statement supporting someoneâ€™s abilities or character.	thư giới thiệu	ˈrefərəns	reference	28
f11426a2-4bf1-4aa4-8f51-028ff55be6ca	2025-11-12 13:02:14.396445	2025-11-12 16:23:41.319935	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe3c47559-94b1-49f1-85a2-132125cadeed.mp3?alt=media	B2		[Business] Manage supply chain logistics. | [Transport] Improve logistics efficiency. | [Planning] Coordinate logistics for events.	\N	The planning and management of the flow of goods or resources.	hậu cần	ləˈdʒɪstɪks	logistics	29
f40f66a3-a016-4ad0-b3ce-6231646d6a9a	2025-11-12 13:02:10.876188	2025-11-12 16:23:42.122273	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8ab7c383-02a0-4691-80ca-ac1b4e8e417d.mp3?alt=media	B2		[Shopping] She compared three myths and chose the freshest one. | [Advice] Keep the myth away from dust to stay safe. | [Hobby] He collects photos of myths from different countries.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F24c58e4b-75ec-4630-87ba-7e33ff547e02.jpg?alt=media	A traditional story, especially one explaining natural or social phenomena.	thần thoại	mɪθ	myth	14
e288ff7c-5f68-422e-80e4-04d829c3793e	2025-11-12 13:02:14.442177	2025-11-12 16:23:42.38825	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa058496d-ef7a-484a-b4f7-ead9491d8495.mp3?alt=media	B1		[Advertising] Display ads on billboards. | [Road] See a billboard on the highway. | [Marketing] Design a billboard ad.	\N	A large outdoor board for displaying advertisements.	biển quảng cáo	ˈbɪlbɔːd	billboard	31
a50e9453-3fc6-4fbd-918f-27dadae61376	2025-11-12 13:02:14.4706	2025-11-12 16:23:42.699429	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fcac5d0be-a24c-41c5-8fb8-db9129478fad.mp3?alt=media	B1		[Media] Check TV show ratings. | [Performance] Improve movie ratings. | [Popularity] High ratings attract viewers.	\N	A measure of a programâ€™s popularity or quality.	xếp hạng	ˈreɪtɪŋz	ratings	31
430f0fa6-a211-4f1c-ac2a-8a9e1fd643ba	2025-11-12 13:02:14.498859	2025-11-12 16:23:43.017344	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Feac4f04f-edd4-4d66-8724-dc040e132d0b.mp3?alt=media	B1		[Charity] Make a donation online. | [Support] Give a donation to schools. | [Cause] Donations help the poor.	\N	Money or goods given to help a cause or person.	quyên góp	dəʊˈneɪʃn	donation	32
5d1198f5-0c66-4c16-a487-67cc7e0f007f	2025-11-12 13:02:11.806594	2025-11-12 16:23:43.738232	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb8cd82b6-d409-4488-85cd-b0e2aeb91ca1.mp3?alt=media	A1		[Travel] We took a taxi to the airport to catch our flight. | [Convenience] She called a taxi after a late-night event. | [City] Taxis are a popular way to get around in busy cities.	\N	A car licensed to transport passengers in return for payment.	taxi	ˈtæksi	taxi	5
878a2529-f9b7-4a66-8e37-431db9d744d0	2025-11-12 13:02:09.791328	2025-11-12 16:23:44.034636	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffe05e1a3-8091-4e1f-bd5d-9dc8afd35b0b.mp3?alt=media	A1		[Shopping] She compared three tickets and chose the freshest one. | [Advice] Keep the ticket away from pets to stay safe. | [Hobby] He collects photos of tickets from different countries.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fd046bc54-8b90-4999-b098-c9ad45227000.jpg?alt=media	A piece of paper or card that gives the holder a certain right, like to travel.	vé	ˈtɪkɪt	ticket	5
784b56c3-d281-45b7-b11c-343938bc5b13	2025-11-12 13:02:14.594696	2025-11-12 16:23:44.333572	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F44b47c10-9f40-4ebc-ab13-2483c0cbdbeb.mp3?alt=media	B1		[Sports] The referee controls the game. | [Match] Listen to the referee. | [Fairness] Referees ensure fair play.	\N	An official who enforces rules in a sport or game.	trọng tài	ˌrefəˈriː	referee	33
9d27127c-1468-434d-b2ff-a46c8d134bba	2025-11-12 13:02:14.920865	2025-11-12 16:23:48.519159	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe24afaa0-def2-4779-8a6a-95d4e94497d1.mp3?alt=media	B2		[Media] Write a sensational headline. | [News] The story was sensational. | [Report] Avoid sensational reporting.	\N	Causing intense interest, excitement, or shock.	gây sốc	senˈseɪʃənl	sensational	38
599c7f09-7a89-4698-8397-2c9592331b89	2025-11-12 13:02:12.598451	2025-11-12 16:23:49.733633	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1d74ed1c-a2a8-4464-9e1a-55a29ce7c4c4.mp3?alt=media	B2		[Story] Folklore tales were passed down through generations. | [Culture] The festival celebrated the region’s rich folklore. | [Study] She researched folklore for her history project.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F68557919-a118-4360-9981-04edd285bd77.jpg?alt=media	Traditional beliefs, customs, and stories of a community.	văn hóa dân gian	ˈfəʊklɔːr	folklore	14
a91e03af-78cc-4991-9296-423ad62fc899	2025-11-12 13:02:14.205232	2025-11-12 16:23:58.075293	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F514723bc-97bc-4088-90f8-edf36e2e0314.mp3?alt=media	C1		[Environment] Promote sustainability in farming. | [Goal] Achieve sustainability goals. | [Future] Sustainability ensures resources.	\N	The ability to maintain or preserve something, especially the environment.	bền vững	səˌsteɪnəˈbɪləti	sustainability	13
fbbe7037-c23b-4f73-ae3f-879d40e51650	2025-11-12 13:02:14.548702	2025-11-12 16:23:43.623658	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc9710e54-086d-43c3-a7f2-be0fb1082de3.mp3?alt=media	A2		[Road] Stop at the intersection. | [Traffic] Cross the intersection safely. | [City] Install lights at intersections.	\N	A place where two or more roads cross.	ngã tư	ˌɪntəˈsekʃn	intersection	5
fbc4fbfd-ec46-49d1-bd15-13b995329ec0	2025-11-12 12:10:20.02578	2025-11-12 16:23:44.141908	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F94415f88-fee6-4945-895e-0f1d584e1838.mp3?alt=media	A2		[Fitness] Work out at the gym. | [Equipment] Use gym machines. | [Health] Join a gym membership.	\N	A place for physical exercise and workouts.	phòng tập thể dục	dʒɪm	gym	33
39782550-cf03-40d1-9ff3-8f39d5543410	2025-11-12 13:02:11.88704	2025-11-12 16:23:44.260846	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6d7c61e3-909d-4f3f-accc-3ae7e88bff4e.mp3?alt=media	A2		[Exercise] She practices yoga every morning to reduce stress. | [Class] The yoga session at the gym was open to beginners. | [Health] Yoga improves flexibility and mental focus over time.	\N	A Hindu spiritual and physical discipline involving breath control and meditation.	yoga	ˈjəʊɡə	yoga	6
f832aff1-bb3c-421d-a7d2-8ef0cb2a7941	2025-11-12 13:02:14.754575	2025-11-12 16:23:46.419395	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fcb67db9f-030e-4b74-8716-e2074bbb449a.mp3?alt=media	B2		[Publishing] Protect work with copyright. | [Law] Respect copyright rules. | [Media] Check copyright status.	\N	The legal right to control the use of a creative work.	bản quyền	ˈkɒpiraɪt	copyright	36
6adacc1d-54a5-4818-933f-2874e581560d	2025-11-12 13:02:14.804528	2025-11-12 16:23:46.979464	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7931c2fb-c04e-488c-8294-7c5a839e83b7.mp3?alt=media	B2		[Journalism] Publish a feature story. | [Magazine] Read the feature article. | [News] The feature highlights culture.	\N	A special or prominent article in a publication.	bài đặc biệt	ˈfiːtʃə	feature	36
b5c02a52-04f4-4f78-b74d-4478902dac7e	2025-11-12 13:02:14.485046	2025-11-12 16:23:47.179725	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb2bbf086-943a-4958-8188-933dd570c8e9.mp3?alt=media	B1		[Media] Pay for a streaming subscription. | [Service] Cancel the subscription. | [Access] Get a monthly subscription.	\N	An agreement to receive a service or product regularly for a fee.	đăng ký (dịch vụ)	səbˈskrɪpʃn	subscription	31
5bd62008-a487-4281-81e2-c0e2b4177091	2025-11-12 13:02:14.863814	2025-11-12 16:23:47.985353	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F66b55549-588d-4f21-91c5-ee4b297ce7a9.mp3?alt=media	A2		[Media] Conduct an interview with a celebrity. | [Job] Prepare for a job interview. | [News] Watch the live interview.	\N	A conversation where questions are asked to gather information.	phỏng vấn	ˈɪntəvjuː	interview	37
6ff8936f-db00-4c3d-a549-c90f03fc297a	2025-11-12 13:02:15.01355	2025-11-12 16:23:48.957035	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F59acc616-bd5d-417d-b1c8-892aa782ceb9.mp3?alt=media	C1		[Journalism] Maintain objectivity in reporting. | [News] Objectivity builds trust. | [Media] Strive for objectivity.	\N	The quality of being impartial and free from bias.	tính khách quan	ˌɒbdʒekˈtɪvəti	objectivity	38
ebdc2808-9f12-41e0-ac88-a8138c8b0055	2025-11-12 13:02:10.912474	2025-11-12 16:23:49.588908	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fec19dfd3-3396-426f-87af-7d736f3ba7b5.mp3?alt=media	B2		[Story] A traveler found a ceremony near the old bench. | [Work] The ceremony was recorded carefully in the report. | [Everyday] I put the ceremony on the bench before dinner.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc757bfe8-495d-4a61-baa6-8a34eaaabf1f.jpg?alt=media	A formal act or series of acts performed according to custom or tradition.	nghi thức	ˈserəməni	ceremony	14
c26e7139-9000-4d44-a12e-981d553309c1	2025-11-12 13:02:15.090657	2025-11-12 16:23:49.79413	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc46834b0-e4de-4f5c-b81b-8365ede4844c.mp3?alt=media	B2		[History] Discover ancient artifacts. | [Museum] Display cultural artifacts. | [Archaeology] Study the artifact's origin.	\N	An object made by humans, often of historical value.	di vật	ˈɑːtɪfækt	artifact	30
912e3750-258a-4422-9abf-9a40d33ff34d	2025-11-12 13:02:15.120204	2025-11-12 16:23:50.194842	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd666f960-31b5-4928-af7e-a104db121ff2.mp3?alt=media	B1		[Food] Serve appetizers at the party. | [Restaurant] Order a light appetizer. | [Menu] Choose a tasty appetizer.	\N	A small dish served before a meal to stimulate appetite.	món khai vị	ˈæpɪtaɪzə	appetizer	27
43097049-1164-47b4-9f4c-430a5df195ba	2025-11-12 13:02:13.183052	2025-11-12 16:23:50.390143	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe783842a-1beb-4f5e-b94d-44c6d1c2e6cc.mp3?alt=media	A2		[Meal] Save room for dessert. | [Sweet] Order chocolate dessert. | [Variety] Try fruit dessert.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F7e6d3a8e-70bf-4c67-b5c0-874165683d9b.jpg?alt=media	A sweet course eaten at the end of a meal.	món tráng miệng	dɪˈzɜːt	dessert	1
9167c93d-789f-4a1c-826c-f8a46b9872ef	2025-11-12 13:02:15.147979	2025-11-12 16:23:50.597907	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe6b63257-efd5-44b2-b9e8-e6bcc71bb65a.mp3?alt=media	B1		[Food] Choose a vegetarian meal. | [Diet] Become a vegetarian. | [Menu] Offer vegetarian options.	\N	A person who does not eat meat, or food excluding meat.	ăn chay	ˌvedʒəˈteəriən	vegetarian	27
7d846086-572e-43a2-9654-5edda6e4e1ed	2025-11-12 13:02:15.173802	2025-11-12 16:23:50.944122	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F963b2820-8240-4f9e-a31f-9549ad53ec71.mp3?alt=media	B1		[Architecture] Design a strong structure. | [Building] Inspect the structure's safety. | [Engineering] Study building structures.	\N	Something built, like a building or framework.	cấu trúc	ˈstrʌktʃə	structure	39
8f9941b7-5c5c-4345-94d3-32aaab6aca58	2025-11-12 13:02:14.798406	2025-11-12 16:23:51.231749	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F944603a5-51a3-4dcd-a7e4-25968abffda6.mp3?alt=media	B1		[News] Write a weekly column. | [Journalism] Read the opinion column. | [Media] The column covers local events.	\N	A regular article or feature in a newspaper or magazine.	cột báo	ˈkɒləm	column	36
e5703ffb-cc7d-4b22-a071-bd66cf487f05	2025-11-12 13:02:15.242505	2025-11-12 16:23:51.825893	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fad8adc6c-5156-460e-b760-2612c2cf7807.mp3?alt=media	B1		[Space] Complete a space mission. | [Goal] The mission explored Jupiter. | [Project] Fund a new mission.	\N	A specific task or journey, often in space or for a purpose.	sứ mệnh	ˈmɪʃn	mission	40
d6743769-601d-4806-94ef-f5ed2a6c93f8	2025-11-12 13:02:14.615897	2025-11-12 16:23:44.56721	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4eb8ab38-4f5d-473b-80af-50a1d88980e4.mp3?alt=media	B1		[Sports] Compete in a tennis tournament. | [Event] Watch the tournament finals. | [Organize] Plan a local tournament.	\N	A competition involving multiple participants or teams.	giải đấu	ˈtʊənəmənt	tournament	33
a324a408-9425-4fe2-b08f-8fe6741d96c2	2025-11-12 13:02:14.748487	2025-11-12 16:23:46.407877	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F94e87622-7312-4626-9078-a179739aa3a1.mp3?alt=media	B2		[Writing] Proofread the document carefully. | [Publishing] Hire someone to proofread. | [Editing] Proofread for errors.	\N	To read and correct errors in a text.	hiệu đính	ˈpruːfriːd	proofread	36
b1251b71-f7fe-4a0e-a865-84adec3cde90	2025-11-12 13:02:14.778844	2025-11-12 16:23:46.727119	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8693000b-f727-4212-aafb-b5e36a32c664.mp3?alt=media	B2		[Journalism] The article includes a byline. | [Writer] Earn a byline for your work. | [News] Check the byline for the author.	\N	The line in a newspaper or article giving the authorâ€™s name.	tên tác giả (bài báo)	ˈbaɪlaɪn	byline	36
528d2aa4-ea02-449b-9c0e-782e2bfec418	2025-11-12 13:02:14.826012	2025-11-12 16:23:47.508529	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6947c656-2f5e-4399-9201-ef7153b05aac.mp3?alt=media	B2		[TV] The anchor reported the news. | [Broadcast] Trust the news anchor. | [Media] The anchor hosts the show.	\N	A person who presents news or programs on television or radio.	người dẫn chương trình	ˈæŋkə	anchor	37
b8ee0544-fef3-4371-824d-1ce619a589de	2025-11-12 13:02:14.886227	2025-11-12 16:23:48.296929	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3ab6b50e-d010-4ce6-b557-ace529e1da25.mp3?alt=media	B1		[Media] Spread celebrity gossip. | [Talk] Avoid gossip at work. | [News] Gossip columns attract readers.	\N	Casual or sensational talk about peopleâ€™s personal lives.	tin đồn	ˈɡɒsɪp	gossip	38
a0d1557a-0343-4ef0-a787-0489c3fae7f5	2025-11-12 13:02:15.218283	2025-11-12 16:23:51.539794	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff5d4b823-e669-4c9a-852e-93eca2349236.mp3?alt=media	B2		[Architecture] Add ornaments to the building. | [Design] Use decorative ornaments. | [Art] Ornaments enhance aesthetics.	\N	A decorative object or detail added to a structure.	đồ trang trí	ˈɔːnəmənt	ornament	39
2b0bd6e6-b4b9-4474-92ec-782999231f90	2025-11-12 13:02:15.324208	2025-11-12 16:23:52.985262	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F011fb8fe-2674-43d6-8918-48691f0ca183.mp3?alt=media	B2		[Biology] Study the theory of evolution. | [Science] Evolution shapes species. | [Nature] Evolution takes millions of years.	\N	The process by which species change over time.	tiến hóa	ˌiːvəˈluːʃn	evolution	41
de7bec8d-89a3-454a-889c-cf4214006386	2025-11-12 13:02:15.388499	2025-11-12 16:23:53.753831	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9d852a93-dbfd-427f-9d8b-99712e4c2551.mp3?alt=media	B2		[Physics] Measure the car's acceleration. | [Science] Acceleration changes speed. | [Experiment] Study acceleration in motion.	\N	The rate of change of velocity over time.	gia tốc	əkˌseləˈreɪʃn	acceleration	42
af9327fe-313e-4ae4-bfd5-0ec0c0cb99c7	2025-11-12 13:02:12.683527	2025-11-12 16:23:54.534768	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F89fb1a11-6484-44fd-93ce-5a259ba81610.mp3?alt=media	B2		[Chemistry] The molecule’s structure was studied in the lab. | [Science] Water is made up of two hydrogen molecules and one oxygen. | [Education] She drew the molecule on the board for the class.	\N	A group of atoms bonded together, the smallest unit of a chemical compound.	phân tử	ˈmɒlɪkjuːl	molecule	15
7b1e0a29-e9e4-46a6-be85-3842fcde05d6	2025-11-12 13:02:15.540477	2025-11-12 16:23:55.797242	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5a12d5f4-4be8-4abd-a85d-aa78f1d43cc3.mp3?alt=media	C1		[Chemistry] Neutralization balances acids and bases. | [Science] Study neutralization reactions. | [Lab] Perform a neutralization experiment.	\N	A reaction between an acid and base to form water and salt.	sự trung hòa	njuːtrəlaɪˈzeɪʃn	neutralization	43
49515d26-046f-4b7c-91d1-8d56fa64a258	2025-11-12 13:02:15.567659	2025-11-12 16:23:56.196842	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb0d354fb-d700-44dd-a755-8a19c9cc399f.mp3?alt=media	A2		[Geology] Visit an active volcano. | [Science] Study volcano eruptions. | [Nature] Volcanoes shape Earth's crust.	\N	A mountain that erupts molten rock, ash, and gases.	núi lửa	vɒlˈkeɪnəu	volcano	44
06aee5e0-6f75-4dfe-8548-c3da620a0b94	2025-11-12 13:02:15.653404	2025-11-12 16:23:57.519799	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F128e8262-0554-4031-a854-00859630c1a7.mp3?alt=media	B2		[Engineering] Install a motion sensor. | [Technology] Sensors detect changes. | [Science] Study sensor applications.	\N	A device detecting changes in the environment.	cảm biến	ˈsensə	sensor	46
963dfde1-8d9e-4790-9f3d-1aa0a66ce827	2025-11-12 13:02:15.701849	2025-11-12 16:23:58.760241	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3195660e-7982-43f0-829a-c0e929d570bd.mp3?alt=media	A1		[Agriculture] Work on a family farm. | [Farming] Farm organic vegetables. | [Nature] Visit a local farm.	\N	Land used for growing crops or raising animals.	nông trại	fɑːm	farm	48
164cf5ff-ba65-4b2c-9c2d-04e569be18ee	2025-11-12 13:02:15.766785	2025-11-12 16:23:59.691056	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fcc8d712b-15f9-4d40-8530-3ece0652fc42.mp3?alt=media	A2		[Psychology] Express your emotions. | [Health] Emotions affect decisions. | [Science] Study emotional responses.	\N	A strong feeling, such as happiness or anger.	cảm xúc	ɪˈməʊʃn	emotion	49
d4be79e2-d5c5-45ac-9025-272f70eb360d	2025-11-12 13:02:14.709012	2025-11-12 16:24:01.543819	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbc1a94ca-f720-403d-970a-80002421a68f.mp3?alt=media	B2		[Literature] Use a metaphor in poetry. | [Writing] The metaphor enhances meaning. | [Speech] Explain with a metaphor.	\N	A figure of speech comparing two unlike things without using 'like' or 'as'.	ẩn dụ	ˈmetəfə	metaphor	35
dc154a91-27eb-49f1-8a3b-04ebb2faa627	2025-11-12 13:02:15.879224	2025-11-12 16:24:01.8316	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F57682ed8-254b-4cb5-8f2f-107b36779e58.mp3?alt=media	B1		[Poetry] The poem has a rhyme. | [Writing] Rhyme words in the stanza. | [Literature] Study rhyme schemes.	\N	Words with similar ending sounds, often used in poetry.	vần	raɪm	rhyme	51
2321a9e8-b01c-4dee-9bda-523834362c85	2025-11-12 13:02:14.667246	2025-11-12 16:24:02.518	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3f1507da-f45d-48f2-8b9f-b03f624aac26.mp3?alt=media	B1		[Art] Mix colors on the palette. | [Painting] Choose a bright palette. | [Tool] Use a wooden palette.	\N	A board for mixing colors or a range of colors.	bảng màu	ˈpælət	palette	34
08fcbb09-e6a1-4e13-8c1a-ccd6fb14dea0	2025-11-12 13:02:15.004656	2025-11-12 16:23:48.894816	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd0a6141d-5501-4a32-8fff-55c9b3b9ee36.mp3?alt=media	C1		[Media] Build credibility in journalism. | [Source] Check the source's credibility. | [Trust] Credibility ensures trust.	\N	The quality of being trusted or believed in.	độ tin cậy	ˌkredəˈbɪləti	credibility	38
c9eda977-381a-42d2-a620-2d5b1afbd56c	2025-11-12 13:02:15.055196	2025-11-12 16:23:49.292011	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5e510a3a-677f-4141-ae8e-48f3f795470b.mp3?alt=media	B2		[Society] Follow dining etiquette. | [Culture] Learn business etiquette. | [Behavior] Etiquette shows respect.	\N	The rules of polite behavior in a society.	phép lịch sự	ˈetɪket	etiquette	30
6a4b8007-9803-4c31-b317-940bdf7cc3c3	2025-11-12 13:02:10.846296	2025-11-12 16:23:49.702288	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fec16bb61-01eb-4031-b4f4-8f034e2a0889.mp3?alt=media	B2		[Advice] Keep the heritage away from pets to stay safe. | [School] The teacher asked us to describe a heritage in two sentences. | [Shopping] She compared three heritages and chose the freshest one.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fee95dd2e-2b53-4c04-8baf-94d11503d095.jpg?alt=media	Property or traditions inherited from ancestors.	di sản	ˈherɪtɪdʒ	heritage	14
f244a100-e7f9-4060-ac78-20223c5d104c	2025-11-12 13:02:15.196588	2025-11-12 16:23:51.314826	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F22348024-8d93-4150-a4f4-a80fe149f7b7.mp3?alt=media	B2		[Architecture] Install steel beams. | [Building] Beams support the structure. | [Construction] Check the beam's strength.	\N	A horizontal piece of wood or metal supporting a structure.	dầm	biːm	beam	39
07b1b806-652c-4a23-8c61-05612c3f1f94	2025-11-12 13:02:15.285599	2025-11-12 16:23:52.559305	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdbdc6b47-0480-42b2-958a-c7c2b6d2c29e.mp3?alt=media	B2		[Science] Research forest ecology. | [Environment] Ecology studies ecosystems. | [Nature] Protect ecology balance.	\N	The study of relationships between organisms and their environment.	sinh thái học	iˈkɒlədʒi	ecology	41
51b95a12-44ba-4fe1-9da0-4b6c25e32b1a	2025-11-12 13:02:15.51641	2025-11-12 16:23:55.492541	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe0eb8605-7b18-471d-bf23-488480abfb49.mp3?alt=media	C1		[Chemistry] Form a precipitate in solution. | [Science] Study precipitate formation. | [Lab] Precipitate separates in water.	\N	A solid formed from a chemical reaction in a liquid.	kết tủa	prɪˈsɪpɪteɪt	precipitate	43
d07640e3-e9ea-4063-8580-1936249122f5	2025-11-12 13:02:10.120852	2025-11-12 16:23:56.854775	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F00c69c2c-f9f9-4997-80f0-48fccf255623.mp3?alt=media	A1		[School] The teacher asked us to describe a star in two sentences. | [Everyday] I put the star on the shelf before dinner. | [Advice] Keep the star away from dust to stay safe.	\N	A celestial body appearing as a luminous point in the night sky.	ngôi sao	stɑː	star	8
d097a40c-7030-454b-9188-aff2770d49ca	2025-11-12 13:02:15.747034	2025-11-12 16:23:59.32128	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1ce92408-4a83-4342-b298-b178195fb115.mp3?alt=media	A2		[Health] Report symptoms to the doctor. | [Medicine] Symptoms indicate illness. | [Diagnosis] Monitor fever symptoms.	\N	A sign or indication of a disease or condition.	triệu chứng	ˈsɪmptəm	symptom	23
1573b23c-a47a-4d21-936f-92fa47f2bed7	2025-11-12 13:02:15.818471	2025-11-12 16:24:00.87006	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9450a882-9857-4336-b14f-5bdf65f5c8de.mp3?alt=media	B1		[Literature] Write poetry for fun. | [Art] Study classic poetry. | [Culture] Poetry expresses emotions.	\N	Literary work expressing feelings in verse.	thơ ca	ˈpəʊɪtri	poetry	51
93c07785-6ce1-4145-b5ad-e55845294cf7	2025-11-12 13:02:15.835273	2025-11-12 16:24:01.356581	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe6b5662e-b9c1-4832-9ce5-52b9f09a9ded.mp3?alt=media	B1		[Literature] The plot was exciting. | [Book] Develop a strong plot. | [Story] Follow the plot twists.	\N	The sequence of events in a story.	cốt truyện	plɒt	plot	51
8f2d7678-1dc3-4e9c-8176-ccf6ddb3a848	2025-11-12 13:02:15.938566	2025-11-12 16:24:03.449361	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7cb860a9-cdfc-4fd0-8215-840dba3d2247.mp3?alt=media	B2		[Music] Beethoven was a composer. | [Art] Meet the famous composer. | [Performance] Composers create music.	\N	A person who writes music.	nhà soạn nhạc	kəmˈpəʊzə	composer	53
e0077224-3faf-454f-ac45-3240b397f880	2025-11-12 13:02:15.992556	2025-11-12 16:24:04.730126	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Faf6967d1-db26-4194-9813-7d4e17ad757b.mp3?alt=media	A1		[Cinema] Watch a new film. | [Art] Create a short film. | [Entertainment] Films inspire audiences.	\N	A motion picture or movie.	phim	fɪlm	film	55
07910790-9d9e-4c84-8f23-c75bacc3f82f	2025-11-12 13:02:16.030831	2025-11-12 16:24:05.151447	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F064232ac-d774-401f-a31a-48a525dc14d1.mp3?alt=media	C1		[Cinema] Study cinematography in school. | [Film] Cinematography enhances visuals. | [Art] Great cinematography wins awards.	\N	The art of capturing visuals for films.	nghệ thuật quay phim	ˌsɪnəməˈtɒɡrəfi	cinematography	55
345304b4-a7f0-4503-b7f4-b2908691fe6a	2025-11-12 12:10:18.181146	2025-11-12 16:23:32.755324	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc68d37b0-71c1-4e11-80b6-882f23f04ff1.mp3?alt=media	B1		[Technology] The invention changed lives. | [History] The wheel was a great invention. | [Science] Patent the new invention.	\N	A new device, method, or process created through study and experimentation.	sáng chế	ɪnˈvenʃn	invention	21
b9deac75-2af0-40c3-840a-c4078ba68487	2025-11-12 13:02:15.258679	2025-11-12 16:23:52.031406	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6c16b800-6933-4ec2-bfd8-7526f4f31126.mp3?alt=media	B1		[Space] Track the satellite's orbit. | [Technology] Satellites improve communication. | [Weather] Satellites monitor storms.	\N	An object launched to orbit Earth for communication or observation.	vệ tinh	ˈsætəlaɪt	satellite	40
e842b215-6353-4695-ad46-9e44ddc5dad6	2025-11-12 13:02:14.12566	2025-11-12 16:23:52.222136	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8eb719b7-e5d7-4e55-abc2-6e9975e3577e.mp3?alt=media	B1		[Astronomy] Observe stars with a telescope. | [Science] Buy a powerful telescope. | [Night] Use the telescope at night.	\N	An instrument for observing distant objects, like stars.	kính thiên văn	ˈtelɪskəʊp	telescope	21
c582d14d-dc01-479e-96ce-a82015f7129d	2025-11-12 13:02:15.29244	2025-11-12 16:23:52.560414	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fcb8993cf-af31-46ad-a367-fb7b07d722f6.mp3?alt=media	B2		[Biology] Study living organisms. | [Science] Organisms adapt to environments. | [Nature] Microorganisms are tiny.	\N	A living thing, such as a plant, animal, or microbe.	sinh vật	ˈɔːɡənɪzəm	organism	41
98c5ac17-5b37-4c2d-b97f-eaf06972d325	2025-11-12 13:02:13.728892	2025-11-12 16:23:53.127535	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe9afd4c0-7510-44bb-a3b7-17a3a88c0f46.mp3?alt=media	B1		[Animal] Preserve wildlife habitats. | [Nature] Habitats support biodiversity. | [Change] Climate affects habitats.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F8ed7dd11-2ad1-4fdb-82ca-4af57de97442.jpg?alt=media	The natural home or environment of an animal or plant.	môi trường sống	ˈhæbɪtæt	habitat	8
0105ab68-a360-4bb8-9f7b-247f1b6bd6b2	2025-11-12 13:02:15.34012	2025-11-12 16:23:53.341249	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa32f9ac4-4250-4062-92fb-4a03659eb653.mp3?alt=media	B2		[Biology] Animals show adaptation to climates. | [Science] Study adaptation in species. | [Nature] Adaptation ensures survival.	\N	A trait or change helping an organism survive in its environment.	sự thích nghi	ˌædæpˈteɪʃn	adaptation	41
b312b774-11e3-4576-ab10-f9fc404e8e29	2025-11-12 13:02:15.406604	2025-11-12 16:23:54.008592	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffcf36a7a-392f-4849-911f-db4ce470998b.mp3?alt=media	A2		[Physics] Generate electricity from wind. | [Science] Electricity powers homes. | [Experiment] Study electricity flow.	\N	A form of energy from charged particles.	điện	ɪˌlekˈtrɪsəti	electricity	42
d9ad84f7-6b2b-44a5-b943-3a09d51257e7	2025-11-12 13:02:15.437636	2025-11-12 16:23:54.40577	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3c8dba33-78ab-4f8e-8e4c-b89adf01ed68.mp3?alt=media	B1		[Chemistry] Learn the periodic elements. | [Science] Elements form compounds. | [Lab] Study the element carbon.	\N	A pure substance that cannot be broken down chemically.	nguyên tố	ˈelɪmənt	element	43
66c17f1c-f583-4c9d-8e77-5942f3d53d95	2025-11-12 13:02:14.139207	2025-11-12 16:23:54.682081	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F28bd319a-461d-4206-b7d3-efab3524d8fb.mp3?alt=media	B2		[Science] Atoms form molecules. | [Chemistry] Study atom structure. | [Physics] Research atom behavior.	\N	The smallest unit of a chemical element.	nguyên tử	ˈætəm	atom	21
febaddd8-3b24-47c1-9863-020861993e61	2025-11-12 13:02:15.462867	2025-11-12 16:23:54.79775	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fce05a12a-4e9d-4e31-9e81-2e26b68fccf0.mp3?alt=media	C1		[Chemistry] Use a catalyst in reactions. | [Science] Catalysts speed up processes. | [Lab] Study catalyst effects.	\N	A substance that speeds up a chemical reaction without being consumed.	chất xúc tác	ˈkætəlɪst	catalyst	43
2397a98d-bb2f-44b9-9b49-2ae29ab13a24	2025-11-12 13:02:15.488883	2025-11-12 16:23:55.155421	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F047cdd35-e551-43de-9587-54fbba211771.mp3?alt=media	C1		[Chemistry] Polymers form plastics. | [Science] Study polymer structures. | [Industry] Use polymers in manufacturing.	\N	A large molecule made of repeating subunits.	polyme	ˈpɒlɪmə	polymer	43
6ae1ee95-22c0-4717-8d49-bb4402ecad47	2025-11-12 13:02:15.532991	2025-11-12 16:23:55.531298	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc9464e11-b55a-49ea-a2ff-6a339c6c863a.mp3?alt=media	C1		[Chemistry] Perform distillation in lab. | [Science] Distillation purifies liquids. | [Process] Study distillation techniques.	\N	The process of purifying a liquid by heating and cooling.	chưng cất	ˌdɪstɪˈleɪʃn	distillation	43
8f053ce5-7743-4f5e-8898-ec24f5345c6d	2025-11-12 13:02:15.599826	2025-11-12 16:23:56.443368	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8186653b-fc0a-474c-9ba3-01f0f52bbaca.mp3?alt=media	B1		[Geology] Lava flows from volcanoes. | [Science] Study cooled lava rocks. | [Nature] Lava creates new land.	\N	Molten rock that flows from a volcano.	dung nham	ˈlɑːvə	lava	44
ce0e409a-3e12-42be-89a1-dedd40896d2b	2025-11-12 13:02:13.692104	2025-11-12 16:23:56.745699	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0bcbc952-401c-42ee-ac3b-8a715c3c92f4.mp3?alt=media	B1		[Space] Observe a comet tail. | [Orbit] Comets orbit the sun. | [Event] See the comet pass.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc10bbc3f-aa04-409b-89c8-f008d485e841.jpg?alt=media	A celestial body with a bright head and a long tail, orbiting the sun.	sao chổi	ˈkɒmɪt	comet	8
9bf624a7-2907-435d-aa9c-5a85bc1c74ec	2025-11-12 13:02:15.630504	2025-11-12 16:23:57.315048	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fefa7cd25-1b8e-4998-b87c-1d90b854c8d4.mp3?alt=media	B2		[Engineering] Study mechanics in physics. | [Science] Mechanics explains motion. | [Career] Work in auto mechanics.	\N	The branch of physics dealing with motion and forces.	cơ học	mɪˈkænɪks	mechanics	46
12393c83-74b4-4263-bd47-4c2c48b2736c	2025-11-12 13:02:15.680243	2025-11-12 16:23:58.553121	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F86ace4ea-5c2d-4b67-8111-6daca595d4c9.mp3?alt=media	B2		[Agriculture] Apply fertilizer to fields. | [Farming] Use organic fertilizer. | [Science] Study fertilizer impact.	\N	A substance added to soil to enhance plant growth.	phân bón	ˈfɜːtɪlaɪzə	fertilizer	48
ed22b00e-e2d4-4302-aed5-a4489340c75d	2025-11-12 13:02:15.719332	2025-11-12 16:23:58.959338	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6bc95068-ee69-4f8b-9dcd-57f341f45743.mp3?alt=media	A2		[Health] Study medicine at university. | [Science] Take medicine for colds. | [Career] Work in modern medicine.	\N	The science or practice of diagnosing and treating diseases.	y học/thuốc	ˈmedɪsn	medicine	23
7f320c22-f58b-49c2-8b63-06f54ad72202	2025-11-12 12:10:18.341218	2025-11-12 16:23:33.599573	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff21e08cf-922f-48e1-80fa-f970334d99c9.mp3?alt=media	A2		[Event] Plan a beautiful wedding. | [Celebration] Attend a friend's wedding. | [Dress] Wear a white wedding gown.	\N	A ceremony where two people are married.	đám cưới	ˈwedɪŋ	wedding	22
a841b05e-c7bf-4b6d-a35d-2361d0ce0c91	2025-11-12 12:10:18.452212	2025-11-12 16:23:34.390899	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F95132305-a217-4ca2-a51b-b242df5c2dd0.mp3?alt=media	A2		[Health] Take medicine for headache. | [Stress] Stress causes headaches. | [Relief] Rest to cure headache.	\N	A pain in the head.	đau đầu	ˈhedeɪk	headache	23
0de4090f-efc6-4442-a646-295c53255ed8	2025-11-12 13:02:13.966985	2025-11-12 16:23:59.138512	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe3bf6dd4-227f-49ae-9ec6-19a269719207.mp3?alt=media	B1		[Health] Recover after surgery. | [Procedure] Schedule heart surgery. | [Hospital] Perform surgery safely.	\N	A medical procedure involving an incision to treat a condition.	phẫu thuật	ˈsɜːrdʒəri	surgery	23
77d6bc2c-81ef-4ae4-8c2f-30f083767f40	2025-11-12 13:02:15.777348	2025-11-12 16:23:59.842846	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb8284628-5513-458e-9e1f-f13b9222d27b.mp3?alt=media	B2		[Psychology] Reduce anxiety with therapy. | [Health] Anxiety affects focus. | [Science] Study anxiety disorders.	\N	A feeling of worry or nervousness.	lo âu	æŋˈzaɪəti	anxiety	49
7a366bde-8c6c-45e6-a965-43439cbf8ea3	2025-11-12 13:02:15.740374	2025-11-12 16:23:59.951569	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fda9235e5-f0f1-41fb-8f7d-29e09ae22641.mp3?alt=media	B1		[Health] Try physical therapy. | [Medicine] Attend therapy sessions. | [Treatment] Therapy helps recovery.	\N	Treatment to relieve or heal a condition.	liệu pháp	ˈθerəpi	therapy	23
65168a87-67b4-42e3-8085-e4f97ab99a00	2025-11-12 13:02:15.794033	2025-11-12 16:24:00.089535	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F26ab8f8f-693f-4ed7-a4bb-b6f319b62ffc.mp3?alt=media	C1		[Psychology] Study cognition in class. | [Science] Cognition affects learning. | [Health] Improve cognitive skills.	\N	The mental process of acquiring knowledge and understanding.	nhận thức	kɒɡˈnɪʃn	cognition	49
ffc17443-e2d4-4249-baf9-992dbf8d2989	2025-11-12 13:02:15.861405	2025-11-12 16:24:01.675491	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F72e1da9b-b7a8-4dc8-90b2-b736622909d5.mp3?alt=media	B2		[Literature] Imagery creates vivid scenes. | [Poetry] The imagery was striking. | [Writing] Use imagery to engage readers.	\N	Vivid descriptive language that appeals to the senses.	hình ảnh (văn học)	ˈɪmɪdʒəri	imagery	51
b967e91f-d61c-43df-b9f3-49a31c1d2db7	2025-11-12 13:02:14.63105	2025-11-12 16:24:02.772728	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa96e3d27-ee8f-422d-8e69-0656013c9989.mp3?alt=media	B1		[Art] Paint a family portrait. | [Photography] Take a portrait photo. | [Gallery] Display royal portraits.	\N	A painting or photograph of a personâ€™s face.	chân dung	ˈpɔːtrət	portrait	34
4c46173c-2e5b-40cf-80ce-0f3910db5064	2025-11-12 13:02:14.638351	2025-11-12 16:24:02.80103	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff0e74c7f-727d-480e-b91b-028074495022.mp3?alt=media	B1		[Art] Paint a beautiful landscape. | [Nature] Capture landscape photos. | [View] Enjoy the mountain landscape.	\N	A painting or view of natural scenery, like mountains or forests.	phong cảnh	ˈlændskeɪp	landscape	34
1a7ed071-0dc4-40aa-b913-0ea297ab7f1b	2025-11-12 13:02:15.91515	2025-11-12 16:24:03.150159	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe0756759-e58e-4521-9d54-529ec2b44f6d.mp3?alt=media	B1		[Music] Hum a catchy melody. | [Song] The melody was beautiful. | [Performance] Compose a new melody.	\N	A sequence of musical notes that are pleasing.	giai điệu	ˈmelədi	melody	53
a3e5cded-0d28-4615-90e3-0b36b2736aa8	2025-11-12 13:02:15.949936	2025-11-12 16:24:03.746351	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F83306158-d2c6-44d3-8c53-5e2fe3155902.mp3?alt=media	B2		[Music] The conductor leads the orchestra. | [Performance] Follow the conductor’s cues. | [Art] Conductors inspire musicians.	\N	A person who directs an orchestra or choir.	người chỉ huy dàn nhạc	kənˈdʌktə	conductor	53
641ec099-ae1a-4ac7-8ba2-c0adb85ea2ac	2025-11-12 13:02:16.011531	2025-11-12 16:24:04.954175	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F15c6de4d-9681-46bf-b2db-6e1234d204a0.mp3?alt=media	A2		[Cinema] The actor played the lead. | [Film] Hire a talented actor. | [Art] Actors perform on stage.	\N	A man who performs in films, plays, or shows.	diễn viên (nam)	ˈæktə	actor	55
f0a6ebe2-eaca-4a2e-b7b5-18668364b31e	2025-11-12 13:02:16.072745	2025-11-12 16:24:05.780748	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F05b56965-eac8-41f1-93e6-62bcf095fd3d.mp3?alt=media	B2		[Photography] Control the exposure settings. | [Art] Exposure affects brightness. | [Camera] Learn about exposure.	\N	The amount of light allowed in a photograph.	phơi sáng	ɪkˈspəʊʒə	exposure	56
44ec4b12-00d3-4828-bd2f-1c4adbba24ec	2025-11-12 12:10:18.588292	2025-11-12 16:24:06.346485	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F235d64fa-bbe0-427b-aa31-b996ce3c31bd.mp3?alt=media	B1		[Fashion] Follow the latest trends. | [Social Media] The trend went viral. | [Market] Analyze market trends.	\N	A general direction in which something is developing or changing.	xu hướng	trend	trend	24
4f27d24c-b889-4346-bc5f-51e7835e98c2	2025-11-12 13:02:16.124261	2025-11-12 16:24:06.746374	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4a916f7f-ddf7-4bfe-b8a1-aca77cd4ed0f.mp3?alt=media	B1		[Fashion] Launch a new collection. | [Design] Display the collection. | [Industry] Collections set trends.	\N	A group of fashion items designed together.	bộ sưu tập	kəˈlekʃn	collection	57
8357bb68-ae8d-49fa-bb83-10160f616c88	2025-11-12 12:10:18.713817	2025-11-12 16:23:35.977197	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc7963dde-2975-47f5-9b4a-c7c9bcc2b1a9.mp3?alt=media	A2		[Geography] Africa is a continent. | [Travel] Explore different continents. | [Map] Study continents in geography.	\N	One of the seven large landmasses on Earth.	lục địa	ˈkɒntɪnənt	continent	25
d2dcd908-6402-431e-ba00-3ec08e58fef8	2025-11-12 12:10:18.941028	2025-11-12 16:23:37.659657	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe785a27e-f2e7-4f1d-99c2-faaad170da99.mp3?alt=media	A2		[Leisure] Photography is her hobby. | [Activity] Find a new hobby. | [Fun] Share your hobby with friends.	\N	An activity done regularly in oneâ€™s leisure time for pleasure.	sở thích	ˈhɒbi	hobby	26
5492da96-5740-44f2-adcd-5c19deeedefd	2025-11-12 13:02:15.9009	2025-11-12 16:24:02.831977	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F992d68ed-1ebf-4f46-98ed-1207d770c191.mp3?alt=media	B1		[Art] Explore a local gallery. | [Culture] Galleries display paintings. | [Exhibition] Visit an art gallery.	\N	A place where art is displayed or sold.	phòng trưng bày	ˈɡæləri	gallery	52
cdb71b50-b71d-4bde-8351-41008b46c11a	2025-11-12 13:02:15.97952	2025-11-12 16:24:04.342652	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fec1ef293-4a16-4055-9451-9d9f7eb30623.mp3?alt=media	B1		[Performance] Attend a dance rehearsal. | [Theater] Schedule a rehearsal. | [Art] Rehearsals improve skills.	\N	A practice session for a performance.	bài tập dượt	rɪˈhɜːsl	rehearsal	54
55407c6b-e3ad-4451-a575-09ab869167d1	2025-11-12 13:02:16.052125	2025-11-12 16:24:05.473275	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe177157c-2b4f-4bcf-92cf-5351a7a9012d.mp3?alt=media	A1		[Photography] Use a professional camera. | [Art] Buy a new camera. | [Hobby] Cameras capture memories.	\N	A device used to take photographs or videos.	máy ảnh	ˈkæmərə	camera	56
29408e38-ef13-4421-a8f2-c2a121a7ab2a	2025-11-12 13:02:16.087232	2025-11-12 16:24:05.881283	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9619b66d-7165-4204-a842-06bf183cbecc.mp3?alt=media	B2		[Photography] Study photo composition. | [Art] Composition creates balance. | [Camera] Improve your composition skills.	\N	The arrangement of elements in a photograph or artwork.	sự sắp xếp (ảnh)	ˌkɒmpəˈzɪʃn	composition	56
552d95f5-a6de-4fe8-86c0-3af24207695d	2025-11-12 13:02:15.638861	2025-11-12 16:24:07.857499	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4f46c56d-b4da-4e7d-88fd-b628ae46b224.mp3?alt=media	C1		[Engineering] Automation improves efficiency. | [Technology] Use automation in factories. | [Science] Study automation systems.	\N	The use of machines to perform tasks automatically.	tự động hóa	ˌɔːtəˈmeɪʃn	automation	46
2c0ff467-ee3c-4460-bc3c-9e42d2f47bef	2025-11-12 13:02:16.160713	2025-11-12 16:24:08.299387	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F16207f3f-68c2-4cb0-95d2-6477c7c94e24.mp3?alt=media	B2		[Technology] Launch a tech startup. | [Business] Invest in a startup. | [Innovation] Startups drive change.	\N	A new company, often focused on innovation.	công ty khởi nghiệp	ˈstɑːtʌp	startup	58
bb7463b0-d3ae-4ca7-a2a9-8b8b7db6c1f3	2025-11-12 12:10:19.191681	2025-11-12 16:23:49.984667	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6786fcc3-6eb4-47eb-b7d2-89bad52f94e1.mp3?alt=media	A2		[Cooking] Follow the recipe steps. | [Food] Share a family recipe. | [Kitchen] Try a new recipe.	\N	A set of instructions for preparing a dish.	công thức nấu ăn	ˈresɪpi	recipe	27
a93fa8a6-d9a7-40ce-bf1b-f95b52ebf30e	2025-11-12 13:02:16.129923	2025-11-12 16:24:06.973032	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fda9fd385-591d-43ab-be50-a1f1348786c9.mp3?alt=media	B2		[Fashion] Models walk the catwalk. | [Show] Watch a catwalk show. | [Industry] Catwalks showcase designs.	\N	A runway where models display fashion.	sàn diễn thời trang	ˈkætwɔːk	catwalk	57
178a6c31-2142-417f-bc8c-9a514c91b776	2025-11-12 13:02:10.570806	2025-11-12 16:24:07.155704	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F49601df4-7f99-4d24-99d3-c8158605eb72.mp3?alt=media	B1		[Story] A traveler found a hardware near the old shelf. | [Work] The hardware was recorded carefully in the report. | [Everyday] I put the hardware on the shelf before dinner.	\N	The physical components of a computer system.	phần cứng	ˈhɑːdweə	hardware	11
f9705093-d763-4c2c-a31e-8f8a8f53be74	2025-11-12 13:02:16.189118	2025-11-12 16:24:08.897018	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffa3075e2-ccf3-42c3-ba7e-4290215df228.mp3?alt=media	B1		[Business] International trade boosts economies. | [Economy] Trade goods globally. | [Commerce] Learn about trade policies.	\N	The buying and selling of goods or services.	thương mại	treɪd	trade	59
41ab2822-0554-4986-b128-b50eb7f2d94b	2025-11-12 12:10:19.342555	2025-11-12 16:23:40.045085	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F54e60c77-39d3-46e8-ace8-71cc1517eeb2.mp3?alt=media	B2		[Job] Interview the job applicant. | [Process] Review applicant resumes. | [Selection] Choose the best applicant.	\N	A person who applies for a job or position.	người nộp đơn	ˈæplɪkənt	applicant	28
97c9e3d4-c481-4633-acda-957d1a8a3400	2025-11-12 12:10:19.605349	2025-11-12 16:23:41.45733	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4e162acc-121a-4588-a97f-2fcaab8c56fb.mp3?alt=media	B2		[Culture] Sing the national anthem. | [Event] Play the anthem at ceremonies. | [Pride] The anthem inspires unity.	\N	A song officially adopted by a country or organization.	quốc ca	ˈænθəm	anthem	30
6a049afa-ea90-4118-bbc2-8b5d285d6e8f	2025-11-12 13:02:14.937587	2025-11-12 16:23:48.588239	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5717b4e0-b6cc-463d-b8e3-7019f08ac5b2.mp3?alt=media	C1		[Media] Recognize propaganda in news. | [Politics] Propaganda influences opinions. | [History] Study wartime propaganda.	\N	Information, often biased, used to promote a political cause.	tuyên truyền	ˌprɒpəˈɡændə	propaganda	38
d862efeb-34b6-4289-9322-07c0d1841e4c	2025-11-12 13:02:12.047637	2025-11-12 16:23:32.267851	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4a95193b-15d9-415d-8153-c7040770bc18.mp3?alt=media	A1		[Family] The zoo was a fun outing for kids and parents alike. | [Education] The zoo offers programs to teach about animal conservation. | [Visit] We saw rare animals during our trip to the zoo.	\N	A place where animals are kept for public viewing and study.	sở thú	zuː	zoo	7
b77712c1-feda-4166-b534-c069c7d1aa3f	2025-11-12 12:10:19.704624	2025-11-12 16:23:42.325029	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd9f8c2cf-d12f-40a5-8dea-a360fdbb5d77.mp3?alt=media	B1		[Marketing] Create an advertisement. | [Media] See a TV advertisement. | [Campaign] Launch a new advertisement.	\N	A public notice or announcement promoting a product or service.	quảng cáo	ədˈvɜːtɪsmənt	advertisement	31
b917ef3b-fb1f-4a2e-ba50-5348e5faf409	2025-11-12 12:10:19.810084	2025-11-12 16:23:42.841949	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F89305ab7-d96a-4303-ad9c-dfb30f2d6e84.mp3?alt=media	B1		[Community] Volunteer at the shelter. | [Event] Volunteer for the festival. | [Help] Volunteer to help the needy.	\N	A person who freely offers to do something without payment.	tình nguyện viên	ˌvɒlənˈtɪə	volunteer	32
fe0fbc1d-8b90-45bd-8885-49dd5d216a15	2025-11-12 13:02:14.968101	2025-11-12 16:23:48.686102	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdfb85158-7111-45c2-9c4c-9eb9389f84cc.mp3?alt=media	C1		[Media] Oppose media censorship. | [Government] Censorship limits free speech. | [News] Censorship affects reporting.	\N	The suppression or control of information in media.	kiểm duyệt	ˈsensəʃɪp	censorship	38
4d9d677f-d6e3-4a2b-a8e9-923c4f06e73d	2025-11-12 12:10:20.243438	2025-11-12 16:24:01.31011	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff846792a-4461-41bd-b33b-2901aaea9aa3.mp3?alt=media	B2		[Literature] Write a compelling narrative. | [Film] The movie has a strong narrative. | [Story] Share a personal narrative.	\N	A spoken or written account of connected events; a story.	câu chuyện	ˈnærətɪv	narrative	35
8fdb76c8-6371-4703-b035-2ab30f809825	2025-11-12 12:10:20.363841	2025-11-12 16:23:46.09519	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffb74172a-ed70-49c0-81ea-806905196641.mp3?alt=media	B1		[Publishing] The editor reviews manuscripts. | [Media] Work as a news editor. | [Writing] Consult the editor for feedback.	\N	A person who prepares content for publication.	biên tập viên	ˈedɪtə	editor	36
d9dcc38c-1380-446b-ac08-2594b429f95a	2025-11-12 12:10:20.556871	2025-11-12 16:23:47.380631	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F96190cb3-47f2-4a8a-97a2-bb0d7bc80b2f.mp3?alt=media	B1		[Media] Watch a live broadcast. | [TV] Broadcast the sports event. | [News] The broadcast reached millions.	\N	To transmit a program or information via radio or television.	phát sóng	ˈbrɔːdkɑːst	broadcast	37
5edc7dea-b448-4ee1-90d1-61df8f65fca4	2025-11-12 13:02:14.988397	2025-11-12 16:23:48.780901	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F043eb21d-cc66-4fe0-9f4b-db3bfdb037fc.mp3?alt=media	B2		[Media] Avoid bias in reporting. | [Opinion] Recognize personal bias. | [News] Bias affects news credibility.	\N	A tendency to favor one perspective over others.	thiên vị	ˈbaɪəs	bias	38
28ea5086-4430-4098-9469-17b6f69625ff	2025-11-12 13:02:12.366904	2025-11-12 13:02:12.366923	null	A2		[Business] The company launched a new website to attract customers. | [Learning] She found a website with free language lessons. | [Design] Creating a website requires both coding and creativity.	\N	A set of related web pages located under a single domain.	trang web	ˈwebsaɪt	website	11
61430b2c-53f0-43f5-8cb7-bb3e16fd49a6	2025-11-12 13:02:12.375081	2025-11-12 16:24:07.366596	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdc212faa-37de-4b3b-920a-dbd779052ccc.mp3?alt=media	B1		[Technology] The new application helps track daily expenses. | [Phone] He downloaded a fitness application to monitor his workouts. | [Development] The team worked hard to update the application.	\N	A program or piece of software designed for a specific purpose.	ứng dụng	ˌæplɪˈkeɪʃn	application	11
5ce00eb5-e51a-43a8-8638-8d63eb3db87f	2025-11-12 12:10:20.656692	2025-11-12 16:23:48.182913	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fce517b9f-e29a-472a-b155-a1ed14a7301f.mp3?alt=media	B2		[News] Report a political scandal. | [Media] The scandal shocked the public. | [Celebrity] Avoid a media scandal.	\N	An event causing public outrage or disapproval.	vụ bê bối	ˈskændl	scandal	38
a1953234-29a0-4f29-80ce-31a724178199	2025-11-12 12:10:20.943924	2025-11-12 16:23:50.817305	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc4ba46dd-5a61-4532-b5b1-8603f92637be.mp3?alt=media	B1		[Art] Study modern architecture. | [Building] Admire ancient architecture. | [Design] Architecture shapes cities.	\N	The art or practice of designing buildings.	kiến trúc	ˈɑːkɪtektʃə	architecture	39
efca1680-42ec-4383-bae5-39e64d271bef	2025-11-12 12:10:21.072153	2025-11-12 16:23:51.629902	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd0ca1caf-4551-42e8-8146-a7c01772e395.mp3?alt=media	B1		[Space] Astronauts explore space. | [Career] Train to be an astronaut. | [Mission] Astronauts landed on the moon.	\N	A person trained to travel or work in space.	phi hành gia	ˈæstrənɔːt	astronaut	40
bbecdbcc-9a02-4b82-bd6f-41bb50fedb4a	2025-11-12 12:10:21.659355	2025-11-12 16:23:55.881349	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbdafdc80-2c41-4878-9b18-efebafd9e20a.mp3?alt=media	B2		[Science] Study geology in university. | [Research] Geology explores Earth's structure. | [Career] Work as a geologist.	\N	The study of Earthâ€™s structure, materials, and processes.	địa chất học	dʒiˈɒlədʒi	geology	44
4affe0c6-16e8-4a89-9467-9f98fbe5ccf7	2025-11-12 13:02:13.215628	2025-11-12 13:02:13.215641	null	B1		[Relationship] Introduce your fiancé. | [Engagement] Plan with your fiancé. | [Wedding] Marry your fiancé.	\N	A man engaged to be married.	vị hôn phu	fiˈɒnseɪ	fiancé	2
17aaea4b-bc69-4f3d-8f56-894453489bb7	2025-11-12 13:02:15.505853	2025-11-12 16:23:55.380833	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc6bdc460-3f6c-4144-ad15-b00ce816a59b.mp3?alt=media	B2		[Chemistry] Form a chemical bond. | [Science] Study covalent bonds. | [Lab] Analyze bond strength.	\N	A chemical connection between atoms in a molecule.	liên kết (hóa học)	bɒnd	bond	43
47156ec8-3a3e-4850-b7ed-2621fc459084	2025-11-12 12:10:21.887987	2025-11-12 16:23:57.165317	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F37f74df8-0ef1-42ed-ad3d-b2467e41687a.mp3?alt=media	B1		[Science] Study engineering at college. | [Career] Work in civil engineering. | [Technology] Engineering solves problems.	\N	The application of science to design machines or structures.	kỹ thuật	ˌendʒɪˈnɪərɪŋ	engineering	46
41f04f92-023a-4289-82dd-87d5b68ab9a6	2025-11-12 12:10:22.093695	2025-11-12 16:23:58.363452	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdcb26211-5134-4f2f-9d3f-d86c8041ba50.mp3?alt=media	B1		[Environment] Agriculture feeds the world. | [Science] Study sustainable agriculture. | [Economy] Agriculture supports jobs.	\N	The science or practice of farming.	nông nghiệp	ˈæɡrɪkʌltʃə	agriculture	48
789ad328-e77d-4963-9801-609420ac5ab0	2025-11-12 13:02:13.269472	2025-11-12 13:02:13.2695	null	A2		[Classroom] Write on the whiteboard. | [Meeting] Use whiteboard for ideas. | [Tool] Erase the whiteboard.	\N	A glossy surface for writing with non-permanent markers.	bảng trắng	ˈwaɪtbɔːd	whiteboard	3
c8782b72-039a-464b-acd9-fd7e81edc6fb	2025-11-12 12:10:22.342936	2025-11-12 16:23:59.571059	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Faf9e4f9c-1216-4c78-a1aa-d6f567eed188.mp3?alt=media	B2		[Science] Study psychology at university. | [Health] Psychology explores behavior. | [Career] Work in clinical psychology.	\N	The study of the mind and behavior.	tâm lý học	saɪˈkɒlədʒi	psychology	49
15fc2d88-7e0a-4882-a2bf-48a24c243db9	2025-11-12 13:02:13.837131	2025-11-12 16:23:32.368347	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdc0318ec-11a1-4244-b0f0-a50de829bc8c.mp3?alt=media	A2		[Shopping] Shop at the mall on weekends. | [Food] Eat at the mall's food court. | [Entertainment] Watch movies at the mall.	\N	A large indoor shopping center.	trung tâm thương mại	mɔːl	mall	10
dfc0b856-0015-4d56-ba9a-e59151d00dc2	2025-11-12 13:02:13.845433	2025-11-12 16:23:32.663489	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Feddd6229-039e-4fcb-816d-2f77ec4dcc5c.mp3?alt=media	B1		[History] Tour the cathedral's architecture. | [Religion] Attend mass at the cathedral. | [Landmark] The cathedral is a city icon.	\N	A large and important Christian church.	nhà thờ lớn	kəˈθiːdrəl	cathedral	10
e5082a29-995c-4960-b419-6a23258e7054	2025-11-12 13:02:13.85973	2025-11-12 16:23:33.179473	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F371aa457-379e-4a84-844f-aa80c9cf7e08.mp3?alt=media	A1		[Technology] Replace the battery. | [Power] Charge the battery fully. | [Device] The battery lasts long.	\N	A device that stores and provides electrical energy.	pin	ˈbætəri	battery	21
00658e2b-6de4-454c-a530-ed86ffebf67e	2025-11-12 13:02:13.86701	2025-11-12 16:23:33.183942	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F377aad7e-f3f0-4f60-89f9-c28419174b39.mp3?alt=media	A2		[Technology] Program a robot for tasks. | [Industry] Robots automate production. | [Future] Robots assist in daily life.	\N	A programmable machine capable of performing tasks automatically.	robot	ˈrəʊbɒt	robot	21
d3cd05be-7e6d-4902-95f5-a44bf407bacd	2025-11-12 13:02:13.852266	2025-11-12 16:23:57.376966	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa5f624fa-947f-46a1-8eb9-e31b1bccb335.mp3?alt=media	B2		[Electronics] Design a circuit board. | [Technology] Test the circuit's performance. | [Repair] Fix the broken circuit.	\N	A closed path through which an electric current flows.	mạch điện	ˈsɜːkɪt	circuit	21
64caeaed-1a63-4b5a-87e4-8305762822f7	2025-11-12 12:10:22.824519	2025-11-12 16:24:02.134949	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F05a04532-bd20-408e-afa2-0f616a9c1051.mp3?alt=media	A1		[Culture] Visit an art gallery. | [Creativity] Create art with paint. | [School] Study art history.	\N	The expression of creativity through painting, music, or other forms.	nghệ thuật	ɑːt	art	52
79280daf-9caa-4e62-904a-02b118e9f83e	2025-11-12 13:02:13.874561	2025-11-12 13:02:13.874566	null	B2		[Technology] Study artificial intelligence applications. | [Innovation] Artificial intelligence powers chatbots. | [Future] Artificial intelligence transforms industries.	\N	The development of computer systems that perform tasks requiring human intelligence.	trí tuệ nhân tạo	ˌɑːtɪˈfɪʃl ɪnˈtelɪdʒəns	artificial intelligence	21
fb6327cc-86a0-4f0d-8e94-c55c5c709bd3	2025-11-12 13:02:13.881068	2025-11-12 16:23:33.478309	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F265d5ea4-4ccb-4989-9da7-e5cbe88fd712.mp3?alt=media	C1		[Security] Use encryption for privacy. | [Technology] Encryption protects data. | [System] Apply encryption to messages.	\N	The process of converting data into a code to prevent unauthorized access.	mã hóa	ɪnˈkrɪpʃn	encryption	21
a03a8673-323c-401e-b00f-ea06b3889687	2025-11-12 13:02:13.88952	2025-11-12 16:23:33.58365	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa9cac633-e2b9-486f-9b99-d3b47f443912.mp3?alt=media	A1		[Celebration] Celebrate your birthday. | [Party] Host a birthday party. | [Gift] Give a birthday present.	\N	The anniversary of the day a person was born.	sinh nhật	ˈbɜːθdeɪ	birthday	22
b6b7c42d-f686-438d-ad53-df8744cd8a58	2025-11-12 13:02:13.906644	2025-11-12 16:23:34.002384	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8fc32509-dc27-4132-8391-f2bd51f3c7d1.mp3?alt=media	A2		[Celebration] Watch fireworks at night. | [Event] Fireworks lit up the sky. | [Festival] Enjoy fireworks displays.	\N	Explosive devices used for entertainment, producing light and sound.	pháo hoa	ˈfaɪəwɜːks	fireworks	22
0043366f-7e4b-46fd-ac9d-aee29c6dd59f	2025-11-12 13:02:13.912927	2025-11-12 16:23:34.01428	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6855a803-9668-4c6d-84b2-6a1c9edcefd4.mp3?alt=media	B1		[Event] Attend a funeral service. | [Respect] Pay respects at the funeral. | [Tradition] Follow funeral customs.	\N	A ceremony for a person who has died.	đám tang	ˈfjuːnərəl	funeral	22
16f7834d-cab3-4f22-87fa-2b1678bf6a2a	2025-11-12 13:02:14.011713	2025-11-12 16:24:06.271325	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1cf55690-d34c-4a86-9168-2a8c745a2714.mp3?alt=media	B1		[Fashion] Follow famous designers. | [Brand] Buy designer clothes. | [Career] Become a fashion designer.	\N	A person who plans the look or workings of something, like clothes.	nhà thiết kế	dɪˈzaɪnə	designer	24
6f5cdd96-95a4-42a9-a7a7-a5078910298b	2025-11-12 13:02:13.925547	2025-11-12 16:23:34.279425	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3c000d62-d3ca-420f-bc81-55572e1640f1.mp3?alt=media	B1		[Family] Attend a family reunion. | [School] Join the class reunion. | [Event] Plan a high school reunion.	\N	A gathering of people who have been apart, like family or classmates.	cuộc hội ngộ	riːˈjuːnjən	reunion	22
4575084a-33d9-4ec5-a96c-2d9ad75eb16a	2025-11-12 13:02:13.938677	2025-11-12 16:23:34.411884	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3d314dc2-9d7b-4b33-b9b4-a841c58111bf.mp3?alt=media	A1		[Health] Treat a persistent cough. | [Symptom] Cough during a cold. | [Medicine] Use cough syrup.	\N	A sudden expulsion of air from the lungs, often due to illness.	ho	kɒf	cough	23
758fec20-ce70-49cc-a596-1ec274d43e7b	2025-11-12 13:02:13.94622	2025-11-12 16:23:34.48784	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff12f140a-c523-43e6-81e2-415c4d361e22.mp3?alt=media	A2		[Health] Sneeze into a tissue. | [Allergy] Pollen causes sneezing. | [Symptom] Sneezing spreads germs.	\N	A sudden, involuntary expulsion of air through the nose and mouth.	hắt hơi	sniːz	sneeze	23
0bd35561-1d28-4791-8d44-28875ac80409	2025-11-12 13:02:13.979022	2025-11-12 16:23:59.380519	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7a459e46-8286-4b9e-b93d-f12976958ecd.mp3?alt=media	B1		[Health] Follow the prescription instructions. | [Doctor] Get a prescription for medicine. | [Pharmacy] Refill the prescription.	\N	A written order for medicine from a doctor.	đơn thuốc	prɪˈskrɪpʃn	prescription	23
023f5b27-4fbb-4831-aae4-4f493baba6cb	2025-11-12 13:02:13.95945	2025-11-12 16:23:59.246508	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F66e0a78e-adbf-403d-b5ad-7f05e41a4bdc.mp3?alt=media	B1		[Health] Get a flu vaccine. | [Prevention] Vaccines protect against diseases. | [Campaign] Promote vaccine awareness.	\N	A substance used to stimulate immunity to a disease.	vắc-xin	ˈvæksiːn	vaccine	23
e1b3304f-5bc4-4369-bd98-3c5a4fe7149b	2025-11-12 13:02:13.918729	2025-11-12 16:24:00.702211	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb38c9efd-31b5-447e-b22c-cea07f96cdf3.mp3?alt=media	B1		[Education] Celebrate graduation day. | [Event] Wear a cap at graduation. | [Achievement] Graduation marks success.	\N	A ceremony marking the completion of a course of study.	lễ tốt nghiệp	ˌɡrædʒuˈeɪʃn	graduation	22
622afca8-954a-4432-952e-b414a35015f1	2025-11-12 13:02:13.986693	2025-11-12 16:23:35.139233	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc0c5bcc2-4f8a-439c-9f21-a945c51ea1e6.mp3?alt=media	A2		[Health] Apply a bandage to the wound. | [Injury] Change the bandage daily. | [First Aid] Use bandages for cuts.	\N	A strip of material used to cover and protect a wound.	băng gạc	ˈbændɪdʒ	bandage	23
65bb454c-788a-45f5-b9be-b1fc99e11f0c	2025-11-12 13:02:14.00418	2025-11-12 16:23:35.295156	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F527a43f9-93d0-4a67-832f-8204d73c52f6.mp3?alt=media	A2		[Fashion] Pick a casual outfit. | [Event] Wear a formal outfit. | [Style] Match the outfit with shoes.	\N	A set of clothes worn together.	trang phục	ˈaʊtfɪt	outfit	24
55ea21ac-5d08-4797-8b8c-f786b5fa66a8	2025-11-12 13:02:14.047193	2025-11-12 16:24:06.348678	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffbd07dc5-9d34-4330-89f2-8a3821dd9cdc.mp3?alt=media	B2		[Fashion] Models walk the runway. | [Show] Watch the runway event. | [Design] Present designs on runway.	\N	A platform where fashion models display clothes.	đường băng (thời trang)	ˈrʌnweɪ	runway	24
a407d40a-3df6-438f-9c8e-a776b9e64620	2025-11-12 13:02:14.054571	2025-11-12 16:23:35.721927	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5951bb92-6eeb-4e0e-ae03-1d0e7a3091f6.mp3?alt=media	A2		[Fashion] Try a new hairstyle. | [Salon] Choose a trendy hairstyle. | [Style] Maintain your hairstyle.	\N	A particular way in which hair is styled or arranged.	kiểu tóc	ˈheəstaɪl	hairstyle	24
fd88c589-5031-4499-9b6b-7eb47e8e4186	2025-11-12 13:02:14.069044	2025-11-12 16:23:36.03451	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F79a09967-3c52-4d18-9db3-a60360a5c22a.mp3?alt=media	A2		[Nature] Explore the jungle wildlife. | [Adventure] Trek through the jungle. | [Ecosystem] Jungles are biodiverse.	\N	A dense, tropical forest with thick vegetation.	rừng rậm	ˈdʒʌŋɡl	jungle	25
eef9c57f-3e29-4914-802a-768c7d288084	2025-11-12 13:02:14.076273	2025-11-12 16:23:36.144881	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff0ff2d58-4517-4250-b0dc-afca37256ce2.mp3?alt=media	B1		[Nature] Glaciers are melting fast. | [Geography] Study glaciers in Antarctica. | [Hiking] Hike near a glacier.	\N	A large, slow-moving mass of ice.	sông băng	ˈɡlæsiə	glacier	25
1d0787b0-3e1a-4b0b-b515-72c4207c50ab	2025-11-12 13:02:14.089843	2025-11-12 16:23:36.374147	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F63eadfeb-348f-48b4-8879-671ff68c1768.mp3?alt=media	A1		[Geography] Live on a tropical island. | [Travel] Vacation on an island. | [Nature] Islands have unique wildlife.	\N	A piece of land surrounded by water.	đảo	ˈaɪlənd	island	25
d19e1c25-51aa-4e24-adae-8f69a7d87454	2025-11-12 13:02:14.097311	2025-11-12 16:23:36.429773	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6e233e5d-fe23-40df-bc3c-2e0c9ecf03be.mp3?alt=media	B1		[Ocean] Dive near the coral reef. | [Nature] Protect the reef ecosystem. | [Beauty] Reefs are colorful underwater.	\N	A ridge of rock, coral, or sand near the waterâ€™s surface.	rạn san hô	riːf	reef	25
c6b1a8c6-8805-4e13-8300-0610feba12d1	2025-11-12 13:02:14.111347	2025-11-12 16:23:36.54288	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F788f1853-6a1c-4fbd-b31a-6d4e594f9d10.mp3?alt=media	B1		[Geography] Explore the Grand Canyon. | [Nature] Hike through the canyon. | [Beauty] The canyon has stunning views.	\N	A deep valley with steep sides, often carved by a river.	hẻm núi	ˈkænjən	canyon	25
52d317e6-92bf-41db-86e3-d3e37d792b49	2025-11-12 13:02:14.118347	2025-11-12 16:23:36.765097	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa6721532-d3f9-4b3a-b6f9-5c9f564b22dd.mp3?alt=media	A2		[Nature] Visit a majestic waterfall. | [Tourism] Photograph the waterfall. | [Hiking] Trek to the waterfall.	\N	A cascade of water falling from a height.	thác nước	ˈwɔːtəfɔːl	waterfall	25
f59a639c-5f5f-420a-9809-1a5ea967474a	2025-11-12 13:02:14.131089	2025-11-12 16:23:36.863816	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff87d0175-3c27-423a-8134-6738a23f57d2.mp3?alt=media	B1		[Science] Examine cells with a microscope. | [Lab] Use a microscope in biology. | [Research] Buy a digital microscope.	\N	An instrument for viewing tiny objects magnified.	kính hiển vi	ˈmaɪkrəskəʊp	microscope	21
1cf494a2-216d-4568-b00d-8c5f8fe47eec	2025-11-12 13:02:14.213883	2025-11-12 16:23:58.296722	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc2e70323-fb10-427a-9e74-e1502ae47aed.mp3?alt=media	B2		[Environment] Reduce carbon emissions. | [Science] Carbon forms compounds. | [Climate] Measure carbon footprint.	\N	A chemical element, often linked to emissions in the environment.	cacbon	ˈkɑːbən	carbon	13
6a9a7aa9-274a-41d3-9d10-52d595a0477f	2025-11-12 13:02:14.148369	2025-11-12 16:23:37.670917	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F51ef1f0c-ebdd-4aa7-8ffb-28ad27014277.mp3?alt=media	A2		[Hobby] Enjoy gardening on weekends. | [Plants] Gardening grows flowers. | [Relaxation] Gardening reduces stress.	\N	The activity of growing and tending plants.	làm vườn	ˈɡɑːdnɪŋ	gardening	26
50a8c217-bb55-46b4-b3c3-8034b25d2d09	2025-11-12 13:02:14.155628	2025-11-12 16:23:37.794379	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F836544be-40a4-49e4-9490-be9c4f40a307.mp3?alt=media	A1		[Hobby] Practice cooking new recipes. | [Skill] Improve your cooking. | [Fun] Cooking brings family together.	\N	The practice or skill of preparing food.	nấu ăn	ˈkʊkɪŋ	cooking	26
09ea9ad0-8839-4879-837b-be72cfdd73f5	2025-11-12 13:02:14.163154	2025-11-12 16:23:38.068953	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F53fcb0ea-2275-4160-a9c3-11e57f1de6c4.mp3?alt=media	B1		[Hobby] Knitting scarves is relaxing. | [Craft] Learn knitting patterns. | [Gift] Knit a sweater for winter.	\N	The craft of creating fabric by interlocking yarn loops.	đan len	ˈnɪtɪŋ	knitting	26
ce67698b-d1df-487e-a1f9-966bd6739db0	2025-11-12 13:02:14.183348	2025-11-12 16:23:38.201053	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fccb10939-f55a-4a63-8260-60f656d13b74.mp3?alt=media	B2		[Hobby] Practice calligraphy art. | [Writing] Use pens for calligraphy. | [Design] Create calligraphy cards.	\N	The art of beautiful handwriting.	thư pháp	kəˈlɪɡrəfi	calligraphy	26
861d6961-4f1a-4db7-b591-2f426f56a5b2	2025-11-12 13:02:14.189252	2025-11-12 16:23:38.417702	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F13919ef6-ce3c-4453-9967-43a257ecb96b.mp3?alt=media	B1		[Hobby] Fold origami cranes. | [Craft] Learn origami techniques. | [Art] Display origami creations.	\N	The Japanese art of paper folding to create shapes.	gấp giấy	ˌɒrɪˈɡɑːmi	origami	26
3203bff7-c122-431d-8525-9784b1c80909	2025-11-12 12:10:23.335244	2025-11-12 16:24:07.040209	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F647ab7bf-122f-4b05-85ec-f8b3340c2ea0.mp3?alt=media	A2		[Science] Study modern technology. | [Industry] Technology improves lives. | [Innovation] Develop new technology.	\N	The application of scientific knowledge for practical purposes.	công nghệ	tekˈnɒlədʒi	technology	58
2b51fbe4-944d-40f0-a689-df3ca3369a43	2025-11-12 13:02:14.225045	2025-11-12 16:23:39.264509	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Faa2ee9cf-8917-4398-b28c-beb672b12328.mp3?alt=media	A2		[Cooking] Gather all ingredients. | [Recipe] Check ingredient list. | [Food] Use fresh ingredients.	\N	A component used in preparing a dish.	nguyên liệu	ɪnˈɡriːdiənt	ingredient	27
bf106a14-9012-449b-a3f2-b4e9acc560b9	2025-11-12 13:02:14.231656	2025-11-12 16:23:39.313913	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F002d0d23-fab7-497b-bb08-269946166830.mp3?alt=media	B1		[Kitchen] Use cooking utensils. | [Tool] Clean the utensils. | [Set] Buy a utensil set.	\N	A tool or implement used in cooking or eating.	dụng cụ bếp	juːˈtensl	utensil	27
66d907ea-ef65-425d-a90b-db8cae8c99e5	2025-11-12 13:02:14.246695	2025-11-12 16:23:39.639647	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8c6f5f83-742c-47e6-8249-0c380da33bd2.mp3?alt=media	A2		[Kitchen] The chef prepares gourmet meals. | [Career] Train to be a chef. | [Restaurant] Meet the head chef.	\N	A professional cook, typically in charge of a kitchen.	đầu bếp	ʃef	chef	27
48d1502f-ab7d-4a9d-9a91-6c365e028fe4	2025-11-12 13:02:14.253968	2025-11-12 16:23:39.642414	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2fb3cd9f-28ff-4e71-8b79-8c41b0b7e6d8.mp3?alt=media	A2		[Cooking] Bake a cake for dessert. | [Kitchen] Learn to bake bread. | [Oven] Bake at high temperature.	\N	To cook food in an oven using dry heat.	nướng	beɪk	bake	27
505f8dba-b465-4ae0-84b7-a241ad34e646	2025-11-12 13:02:14.268365	2025-11-12 16:23:39.693431	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F106031ce-d73f-440c-92cc-0643b2375d1b.mp3?alt=media	A1		[Cooking] Boil water for pasta. | [Kitchen] Boil eggs for breakfast. | [Method] Boil soup gently.	\N	To heat a liquid until it reaches its boiling point.	luộc	bɔɪl	boil	27
7acec91b-c7de-4c95-ae18-ed84cbdafbe3	2025-11-12 13:02:14.278429	2025-11-12 16:23:39.82931	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc9b92f94-fa89-4b58-9c6d-c35cadf6a6d6.mp3?alt=media	A1		[Cooking] Fry chicken in oil. | [Kitchen] Fry potatoes for chips. | [Method] Fry food carefully.	\N	To cook food in hot oil or fat.	chiên	fraɪ	fry	27
e2e294d8-db39-4278-ba5f-e1650c44b500	2025-11-12 13:02:14.286055	2025-11-12 16:23:40.049815	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4b361fea-6eeb-4c3f-a1a3-fe87da1c9afc.mp3?alt=media	A2		[Cooking] Stir the soup slowly. | [Recipe] Stir ingredients together. | [Kitchen] Stir with a spoon.	\N	To mix ingredients with a spoon or utensil.	khuấy	stɜː	stir	27
2278d559-9c2f-4d6a-bf2a-b2403dcd2724	2025-11-12 13:02:14.324575	2025-11-12 16:23:40.446735	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F47620736-b9e1-4ce2-a0eb-31bd0b966a71.mp3?alt=media	B2		[Retirement] Receive a monthly pension. | [Finance] Plan for pension savings. | [Benefit] Pension supports retirees.	\N	A regular payment made to a retired person.	lương hưu	ˈpenʃn	pension	28
e626e976-3dd7-44f5-8a38-19779a72fd99	2025-11-12 13:02:14.316808	2025-11-12 16:23:40.455276	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbd2ca5de-96e7-484f-95c1-59273e8051b5.mp3?alt=media	B2		[Work] Complete the probation period. | [Job] Pass probation successfully. | [Policy] Review probation terms.	\N	A trial period to assess an employeeâ€™s performance.	thời gian thử việc	prəˈbeɪʃn	probation	28
2fa6ce06-3006-486b-b35c-82d217007506	2025-11-12 13:02:14.334314	2025-11-12 16:23:40.653449	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2b910334-851c-4569-88c8-47aa4481d049.mp3?alt=media	B2		[Company] Train the workforce. | [Economy] Expand the workforce. | [Management] Support workforce needs.	\N	The group of people employed by a company or organization.	lực lượng lao động	ˈwɜːkfɔːs	workforce	28
5cfc6c97-341b-4a05-8392-432b803b1511	2025-11-12 13:02:14.342844	2025-11-12 16:23:40.71879	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fca54b429-491b-4713-a513-9bdcee9efa49.mp3?alt=media	B2		[Business] Increase company turnover. | [HR] Reduce employee turnover. | [Finance] Analyze turnover rates.	\N	The rate at which employees leave or the amount of business revenue.	doanh thu / tỷ lệ nghỉ việc	ˈtɜːnəʊvə	turnover	28
3b2b7616-27df-4656-86da-9ceac6285632	2025-11-12 13:02:14.35824	2025-11-12 16:23:40.888266	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd70e7ec7-3a87-48f3-b70e-a1f621d6a63c.mp3?alt=media	B1		[Task] Focus on top priorities. | [Plan] Set project priorities. | [Time] Manage priorities effectively.	\N	Something given or deserving precedence over others.	ưu tiên	praɪˈɒrəti	priority	29
0a8076f2-f9f5-4e4a-a04b-6ad2e93bc4b6	2025-11-12 13:02:14.372636	2025-11-12 16:23:41.027226	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F466510ea-ffb0-4642-8177-b84e0b931c7e.mp3?alt=media	B2		[Work] Boost workplace productivity. | [Efficiency] Measure team productivity. | [Goal] Improve daily productivity.	\N	The efficiency of producing goods or completing tasks.	năng suất	ˌprɒdʌkˈtɪvəti	productivity	29
389cf908-bbd2-49c3-bfff-b4996d011c66	2025-11-12 13:02:14.380254	2025-11-12 16:23:41.156402	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9cd8932f-69b0-4de0-9b0a-283fd851834f.mp3?alt=media	B1		[Business] Develop leadership skills. | [Team] Show strong leadership. | [Role] Take on leadership duties.	\N	The ability to guide or direct a group.	lãnh đạo	ˈliːdəʃɪp	leadership	29
d2f7e97a-eee3-4ebe-b8f6-0d3f92f7a130	2025-11-12 13:02:14.404159	2025-11-12 16:23:41.491619	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd283b8fd-8aba-4f40-b4e0-34e879dae0b6.mp3?alt=media	B1		[Business] Create a sales forecast. | [Weather] Check the weather forecast. | [Planning] Forecast future trends.	\N	A prediction of future events, often weather or business trends.	dự báo	ˈfɔːkɑːst	forecast	29
be31cfac-8838-4411-bd81-124b2a3a481e	2025-11-12 13:02:14.412355	2025-11-12 16:23:41.633985	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Feadd3088-43bd-4fb4-9cd2-d1ae8aa896fa.mp3?alt=media	B2		[Culture] Embrace your cultural identity. | [Personal] Identity shapes behavior. | [Document] Verify your identity.	\N	The characteristics or qualities that define a person or group.	danh tính	aɪˈdentəti	identity	30
2c23a3de-0ec7-4f6a-85d2-581b9dabe6da	2025-11-12 13:02:14.426708	2025-11-12 16:23:41.912227	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2182aee9-5720-44d8-9463-9f424db31c05.mp3?alt=media	A2		[Society] Join the local community. | [Support] Build a strong community. | [Event] Community hosts festivals.	\N	A group of people living or working together.	cộng đồng	kəˈmjuːnəti	community	30
eb41f6ca-93ca-4f02-a81b-5ea2e94c6ee6	2025-11-12 13:02:14.436421	2025-11-12 16:23:42.249368	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa5ff1dac-f51f-4e34-8c8e-febe4a1af723.mp3?alt=media	B1		[Marketing] Create a catchy slogan. | [Brand] The slogan promotes the product. | [Campaign] Use a slogan for advertising.	\N	A short, memorable phrase used in advertising.	khẩu hiệu	ˈsləʊɡən	slogan	31
e2deb4df-8f48-47c3-bb33-6fc37bd13f6a	2025-11-12 13:02:14.448971	2025-11-12 16:23:42.392925	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6a81400d-cc64-4ed7-a069-7a0678f9e744.mp3?alt=media	B1		[Media] Watch a TV commercial. | [Advertising] Create a commercial video. | [Business] Commercial ads boost sales.	\N	An advertisement broadcast on television or radio.	quảng cáo thương mại	kəˈmɜːʃl	commercial	31
3f22bfe9-2b10-47cb-8d99-41e6c54fff2c	2025-11-12 13:02:14.45739	2025-11-12 16:23:42.433141	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb9e44310-6649-4bac-80de-b1ad1ce75f62.mp3?alt=media	B2		[Advertising] Write a catchy jingle. | [Media] Hear a jingle on radio. | [Brand] The jingle promotes the product.	\N	A short song or tune used in advertising.	đoạn nhạc quảng cáo	ˈdʒɪŋɡl	jingle	31
07cb68dd-6e78-4f7f-b126-00dfba86eb44	2025-11-12 13:02:14.387912	2025-11-12 16:23:47.324307	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc43246e2-945e-4655-a9e1-608179de6092.mp3?alt=media	C1		[Business] Follow business ethics. | [Philosophy] Study ethics in school. | [Decision] Make ethical choices.	\N	Moral principles governing behavior or activities.	đạo đức	ˈeθɪks	ethics	29
981c1e0f-de6f-4f2b-a44b-df79184310af	2025-11-12 12:10:23.469697	2025-11-12 16:24:08.579087	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5474d948-1913-439f-81b4-932a4445f9aa.mp3?alt=media	B1		[Business] Study the global economy. | [Society] The economy affects jobs. | [Finance] A strong economy grows.	\N	The system of production, distribution, and consumption.	kinh tế	ɪˈkɒnəmi	economy	59
05ea1a0b-a7ab-4b32-a6fe-97aa04c3002b	2025-11-12 13:02:15.031333	2025-11-12 16:23:48.996885	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F996ca892-2a1e-4f52-8c10-f64e63fadbbf.mp3?alt=media	C1		[Journalism] Publish an exposé on corruption. | [Media] The exposé shocked readers. | [News] Write an investigative exposé.	\N	A report revealing hidden or scandalous information.	bài vạch trần	ˌekspəʊˈzeɪ	exposé	38
9aafbe96-16ac-46a2-9466-0482b300bcbd	2025-11-12 13:02:15.046149	2025-11-12 16:23:49.078083	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F10644016-e03b-4c33-88ee-0e1c3dcd2f6d.mp3?alt=media	A2		[Society] Embrace local culture. | [Travel] Experience a new culture. | [Diversity] Culture shapes identity.	\N	The beliefs, customs, and arts of a particular society.	văn hóa	ˈkʌltʃə	culture	30
a97a2646-9e7c-4a40-8e88-cae48c4200af	2025-11-12 13:02:15.063105	2025-11-12 16:23:49.349349	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F92bae69f-a7ca-4394-8e76-7251766ba324.mp3?alt=media	B2		[Society] Follow social norms. | [Behavior] Norms guide interactions. | [Culture] Norms differ by country.	\N	A standard or expected pattern of behavior.	chuẩn mực	nɔːm	norm	30
a08995e5-b8a5-4f67-8e05-77ba4a1ce710	2025-11-12 13:02:15.071055	2025-11-12 16:23:49.503134	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff0f28f4e-449e-459c-a852-5f02524a830c.mp3?alt=media	B2		[Culture] Avoid common superstitions. | [Belief] Superstitions influence behavior. | [Tradition] Learn about local superstitions.	\N	A belief in something not based on reason or science.	mê tín	ˌsuːpəˈstɪʃn	superstition	30
cf837ea1-f998-4ba0-be59-4b7ab81e3e55	2025-11-12 13:02:15.103853	2025-11-12 16:23:50.104603	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F606e6a7a-b16d-424e-97c7-0ab37031af6d.mp3?alt=media	B1		[Food] Enjoy Italian cuisine. | [Culture] Explore Asian cuisine. | [Restaurant] Try local cuisine.	\N	A style of cooking characteristic of a region or culture.	phong cách ẩm thực	kwɪˈziːn	cuisine	27
1ee604e2-db20-461c-91d5-db5f24d3596a	2025-11-12 13:02:15.112238	2025-11-12 16:23:50.158477	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa6331588-3b13-49a7-a7f4-bc15decb0f34.mp3?alt=media	B1		[Cooking] Add seasoning to the dish. | [Flavor] Use natural seasonings. | [Kitchen] Buy new seasonings.	\N	Ingredients used to enhance the flavor of food.	gia vị	ˈsiːzənɪŋ	seasoning	27
c47b44d6-fda1-45a0-8860-fc7d4a2c0755	2025-11-12 13:02:15.128195	2025-11-12 16:23:50.321774	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F24b4f0a2-1c11-4905-88a2-1977fe21b0c0.mp3?alt=media	B2		[Food] The entree was delicious. | [Restaurant] Choose a seafood entree. | [Menu] The entree comes with sides.	\N	The main course of a meal.	món chính	ˈɒntreɪ	entree	27
31c1326e-e080-4a26-ba8c-2ab4ade5b524	2025-11-12 13:02:15.138845	2025-11-12 16:23:50.548598	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff44f4862-9332-4782-841b-5ca8d56125b3.mp3?alt=media	B2		[Food] Try gourmet dishes. | [Restaurant] Visit a gourmet restaurant. | [Cooking] Learn gourmet recipes.	\N	High-quality food or sophisticated cooking.	ẩm thực cao cấp	ˈɡɔːmeɪ	gourmet	27
701bced5-9cef-47ee-8901-9230f5e763be	2025-11-12 13:02:15.15692	2025-11-12 16:23:50.72497	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F048e3592-ac92-43b0-8c70-00da1f7c7803.mp3?alt=media	B2		[Food] Cook a vegan dish. | [Diet] Follow a vegan lifestyle. | [Menu] Include vegan recipes.	\N	A person who avoids all animal products, or food without them.	thuần chay	ˈviːɡən	vegan	27
3d8f11e9-dbca-489d-a036-02e355913e20	2025-11-12 13:02:15.732816	2025-11-12 16:23:59.063839	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffa9f3e9b-46d4-4798-ab52-15142cb812df.mp3?alt=media	B1		[Health] Start treatment for illness. | [Medicine] Follow the treatment plan. | [Doctor] Discuss treatment options.	\N	Medical care given to a patient for an illness.	điều trị	ˈtriːtmənt	treatment	23
e9455682-ff87-4f1c-8816-6cd6ccd57949	2025-11-12 13:02:15.180338	2025-11-12 16:23:50.994385	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fab67c9ed-6f59-449d-8bad-717df92b1d35.mp3?alt=media	B2		[Architecture] The facade looks modern. | [Building] Design a unique facade. | [Aesthetics] The facade enhances beauty.	\N	The front of a building or a superficial appearance.	mặt tiền	fəˈsɑːd	facade	39
5f83ecc3-d4ef-41d4-8fb3-7a1a71207ae3	2025-11-12 13:02:15.188159	2025-11-12 16:23:51.150407	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6f8025e8-f72d-4ad5-85aa-b1525a06d104.mp3?alt=media	B1		[Architecture] Lay a strong foundation. | [Building] Check the foundation's stability. | [Metaphor] Build a solid foundation.	\N	The base on which a building or structure rests.	nền móng	faʊnˈdeɪʃn	foundation	39
58a6dd13-e451-4b32-8ea4-749fa2e91d3c	2025-11-12 13:02:15.203836	2025-11-12 16:23:51.355075	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd15f133d-4595-422e-8759-4ad2fdd71eba.mp3?alt=media	B1		[Architecture] Visit a tall skyscraper. | [City] Skyscrapers define the skyline. | [Design] Build a modern skyscraper.	\N	A very tall building with many stories.	tòa nhà chọc trời	ˈskaɪskreɪpə	skyscraper	39
4945f830-9930-4f41-8286-e7fd1f8b3274	2025-11-12 13:02:15.210512	2025-11-12 16:23:51.398159	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbe7aacde-e7fb-4ada-a17f-f0ff7abc21cf.mp3?alt=media	B2		[Architecture] Plan a home renovation. | [Building] Renovation improves value. | [Project] Fund the renovation.	\N	The act of improving or updating a building.	sự cải tạo	ˌrenəˈveɪʃn	renovation	39
a59dc0bc-b43c-40c6-8768-24c5bc92b47e	2025-11-12 13:02:15.166446	2025-11-12 16:23:57.223706	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F45b801be-1868-4774-b9f5-a4d4ec760cbc.mp3?alt=media	B2		[Architecture] Review the building blueprint. | [Plan] Create a project blueprint. | [Design] Follow the blueprint.	\N	A detailed plan or design, often for a building.	bản thiết kế	ˈbluːprɪnt	blueprint	39
2d4daf51-c1f9-48b8-ac76-ea25842b809f	2025-11-12 13:02:15.235532	2025-11-12 16:23:51.768479	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd3c7cb89-a8c1-4bf9-85e4-a619bd1f8405.mp3?alt=media	B2		[Space] Design a new spacecraft. | [Mission] The spacecraft reached Mars. | [Technology] Build advanced spacecraft.	\N	A vehicle designed for travel in outer space.	tàu vũ trụ	ˈspeɪskrɑːft	spacecraft	40
5abbb529-e469-46b2-91d4-0bd6249e4bb3	2025-11-12 13:02:15.250039	2025-11-12 16:23:51.961346	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fcd7ab073-2fe9-4755-921e-4dba22c44409.mp3?alt=media	A2		[Space] Launch a rocket to space. | [Technology] Build a powerful rocket. | [Mission] The rocket carried satellites.	\N	A vehicle propelled by engines, often for space travel.	tên lửa	ˈrɒkɪt	rocket	40
82422053-d7fb-490e-84c3-4f5f776c0990	2025-11-12 13:02:15.227992	2025-11-12 16:23:56.881027	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffce1f458-4546-4cab-a2f4-650be589a762.mp3?alt=media	B2		[Space] The satellite is in orbit. | [Astronomy] Planets orbit the sun. | [Mission] Launch into low orbit.	\N	The path of a celestial body around another.	quỹ đạo	ˈɔːbɪt	orbit	40
09c9b84d-80a5-4a51-90f7-28476add7b6e	2025-11-12 13:02:15.277227	2025-11-12 16:23:52.605957	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F310fe6f0-1563-47a5-8a2c-fe86c90688af.mp3?alt=media	B2		[Astronomy] Visit the local observatory. | [Science] Observatories track stars. | [Research] Work at an observatory.	\N	A building equipped for observing astronomical events.	đài thiên văn	əbˈzɜːvətəri	observatory	40
0e4c9acf-5b13-4c55-aeec-fdaf68c548b1	2025-11-12 13:02:15.300083	2025-11-12 16:23:52.618195	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9778600b-bd46-403c-8e1a-63d45f4eca78.mp3?alt=media	B1		[Biology] Examine cells under a microscope. | [Science] Cells form tissues. | [Research] Study cell division.	\N	The basic unit of life in living organisms.	tế bào	sel	cell	41
27f4dc31-3e52-4784-a4a4-e135906619cf	2025-11-12 13:02:15.316703	2025-11-12 16:23:52.936353	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3a9b69c3-f7bf-4d68-93ad-de2d5e9863bd.mp3?alt=media	C1		[Biology] Map the human genome. | [Science] Genomes store genetic data. | [Research] Study genome sequencing.	\N	The complete set of genes in an organism.	bộ gen	ˈdʒiːnəʊm	genome	41
f846407b-627f-48f3-a11c-ed922cac35bb	2025-11-12 13:02:15.30901	2025-11-12 16:23:52.96082	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9a3d5d18-abf9-4694-9fef-d0217bcc4221.mp3?alt=media	B2		[Biology] DNA carries genetic information. | [Science] Study DNA in genetics. | [Research] Analyze DNA samples.	\N	The molecule carrying genetic information in living organisms.	DNA	ˌdiː en ˈeɪ	dna	41
2fa3aec5-2c18-4c15-a544-e427fcfd04a1	2025-11-12 13:02:15.331582	2025-11-12 16:23:53.007216	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8db9e730-48bc-4b95-b762-288809c625af.mp3?alt=media	B1		[Biology] Protect endangered species. | [Science] Study different species. | [Nature] New species are discovered.	\N	A group of organisms capable of interbreeding.	loài	ˈspiːʃiːz	species	41
ffc8329c-9bac-472d-8c88-bd661ca89d76	2025-11-12 13:02:15.359938	2025-11-12 16:23:53.529382	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3d7fe7e8-4300-4aa9-953e-0a42abc12484.mp3?alt=media	B1		[Physics] Measure the force applied. | [Science] Force causes movement. | [Experiment] Test force in experiments.	\N	A push or pull that causes motion or change.	lực	fɔːs	force	42
d66abbf2-d733-4f6c-879f-c26aa73b226f	2025-11-12 13:02:15.350116	2025-11-12 16:23:53.613803	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F07184bf0-afd4-41e9-908e-41cd2a612b32.mp3?alt=media	B1		[Physics] Study laws of motion. | [Science] Motion affects speed. | [Experiment] Observe objects in motion.	\N	The act or process of moving or changing position.	chuyển động	ˈməʊʃn	motion	42
e75c8729-02f1-4dd0-9542-bb061427c8f1	2025-11-12 13:02:15.371007	2025-11-12 16:23:53.737892	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F986b8e9a-1dd7-443c-98e3-0d572d60cfb4.mp3?alt=media	B2		[Physics] Friction slows movement. | [Science] Study friction in physics. | [Experiment] Test friction on surfaces.	\N	The force resisting motion between two surfaces.	ma sát	ˈfrɪkʃn	friction	42
b47d0845-6674-41c8-82a9-99175aa634ca	2025-11-12 13:02:15.380235	2025-11-12 16:23:53.919033	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F02057e95-84f4-4874-bba9-848b3b966db9.mp3?alt=media	B2		[Physics] Calculate the object's velocity. | [Science] Velocity measures speed. | [Motion] Velocity affects distance.	\N	The speed of an object in a particular direction.	vận tốc	vəˈlɒsəti	velocity	42
3f33d494-3651-4a1d-921e-3cb9ebb2a2b1	2025-11-12 13:02:15.396544	2025-11-12 16:23:53.925753	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3b898dc6-f981-4d25-b765-41d260be39f7.mp3?alt=media	B2		[Physics] Study magnetism in class. | [Science] Magnetism attracts metals. | [Experiment] Test magnetism with magnets.	\N	The force exerted by magnets, attracting or repelling objects.	từ tính	ˈmæɡnətɪzəm	magnetism	42
bd93d05f-d6ff-44df-af8d-b181df4c9a2e	2025-11-12 13:02:15.268173	2025-11-12 16:23:57.067342	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fda8344b3-2981-42cd-8281-0b79f729da1c.mp3?alt=media	B2		[Space] Explore the vast cosmos. | [Astronomy] Study the cosmos in class. | [Universe] The cosmos is infinite.	\N	The universe considered as a whole.	vũ trụ	ˈkɒzmɒs	cosmos	40
87603370-6158-4c99-b972-0bfcb6fddb56	2025-11-12 13:02:15.428212	2025-11-12 16:23:54.330693	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe0ed453e-6765-4a13-848c-414f0e019627.mp3?alt=media	B2		[Chemistry] Form a new compound. | [Science] Study chemical compounds. | [Lab] Analyze the compound's properties.	\N	A substance formed by chemically combining elements.	hợp chất	ˈkɒmpaʊnd	compound	43
6bc7ee70-9171-44f4-8235-4abb80ce492f	2025-11-12 13:02:15.448187	2025-11-12 16:23:54.683552	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb315bd9e-c0e9-4982-97f6-c688d45ba817.mp3?alt=media	B1		[Chemistry] Create a chemical mixture. | [Science] Study mixture properties. | [Lab] Separate the mixture.	\N	A combination of substances not chemically bonded.	hỗn hợp	ˈmɪkstʃə	mixture	43
86141a37-ce63-4534-b67c-3c6ae9d99797	2025-11-12 13:02:15.456465	2025-11-12 16:23:54.741699	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fadd9fd4e-cc84-4a0a-93b0-dde5188ae6ad.mp3?alt=media	B1		[Chemistry] Prepare a chemical solution. | [Science] Test the solution's pH. | [Lab] Mix a saline solution.	\N	A homogeneous mixture of a solute dissolved in a solvent.	dung dịch	səˈluːʃn	solution	43
d8e4b01e-2524-4614-ab04-97ae90f7cef9	2025-11-12 13:02:15.47099	2025-11-12 16:23:55.081106	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fafe1f58b-1269-4434-9b0e-398eea71f10a.mp3?alt=media	B1		[Chemistry] Handle acid with care. | [Science] Test the acid's pH. | [Lab] Mix acid in a solution.	\N	A substance with a pH less than 7, often corrosive.	axit	ˈæsɪd	acid	43
ca355235-f4a9-4fcf-a03f-e428587ca061	2025-11-12 13:02:15.479403	2025-11-12 16:23:55.092081	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff1066e14-98ac-4878-a94b-af4e7d23c0b0.mp3?alt=media	B2		[Chemistry] Bases neutralize acids. | [Science] Study base properties. | [Lab] Use a base in experiments.	\N	A substance with a pH greater than 7, often neutralizing acids.	kiềm	beɪs	base	43
7e57572d-db4d-49b5-a228-f894773d1797	2025-11-12 13:02:15.497005	2025-11-12 16:23:55.18181	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F83b62d63-5427-4a94-9fb4-44a59508dd57.mp3?alt=media	B2		[Chemistry] Ions carry electric charge. | [Science] Study ion behavior. | [Lab] Analyze ion reactions.	\N	An atom or molecule with an electric charge.	ion	ˈaɪən	ion	43
14fcbee8-bf6b-428b-a3f1-325af632a365	2025-11-12 13:02:15.419054	2025-11-12 16:23:55.47316	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F63739d39-29b6-47ab-98ef-70add95645c4.mp3?alt=media	B1		[Chemistry] Observe a chemical reaction. | [Science] Study reaction rates. | [Experiment] Cause a reaction in lab.	\N	A process where substances change or interact.	phản ứng	riˈækʃn	reaction	43
b10a9d5b-c69e-4e09-a8ce-719e64a5fa36	2025-11-12 13:02:15.52508	2025-11-12 16:23:55.588091	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb4a30909-5fdd-49f3-9e7c-94ceeadcb565.mp3?alt=media	C1		[Chemistry] Use a solvent to dissolve. | [Science] Solvents clean surfaces. | [Lab] Choose the right solvent.	\N	A substance that dissolves another to form a solution.	dung môi	ˈsɒlvənt	solvent	43
ab87ffa2-3f1f-4986-a9a4-dbcdf24d7ad9	2025-11-12 13:02:15.556957	2025-11-12 16:23:55.842195	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7d8f3930-66cf-4742-a789-d890499f4833.mp3?alt=media	B1		[Geology] Discover dinosaur fossils. | [Science] Fossils reveal ancient life. | [Museum] Display fossil collections.	\N	The preserved remains of ancient organisms.	hóa thạch	ˈfɒsl	fossil	44
e59b0b6f-38d9-452f-bcba-25c54db9b156	2025-11-12 13:02:15.549418	2025-11-12 16:23:55.906459	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc439ece1-0e9c-48a4-90f3-877f6621f8e1.mp3?alt=media	B1		[Geology] Identify minerals in rocks. | [Science] Minerals form crystals. | [Nature] Study mineral properties.	\N	A naturally occurring inorganic substance with a specific composition.	khoáng vật	ˈmɪnərəl	mineral	44
6bf49713-0aa6-4180-b3de-3e003928a602	2025-11-12 13:02:15.575695	2025-11-12 16:23:56.149204	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0d6e0e36-d764-416f-9006-c55f0b458746.mp3?alt=media	A2		[Geology] Prepare for an earthquake. | [Science] Study earthquake causes. | [Safety] Earthquake drills save lives.	\N	A sudden shaking of the Earthâ€™s surface caused by tectonic movement.	động đất	ˈɜːθkweɪk	earthquake	44
8d263b76-fefd-46e2-8c88-023aa3c39df0	2025-11-12 13:02:15.584379	2025-11-12 16:23:56.216815	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb187f58d-daa3-45d2-9051-1d8cc3759f14.mp3?alt=media	C1		[Geology] Analyze river sediment. | [Science] Sediments form rock layers. | [Nature] Study sediment deposition.	\N	Material deposited by water, wind, or ice.	trầm tích	ˈsedɪmənt	sediment	44
e9f4b352-101e-4508-a599-b76411852cc5	2025-11-12 13:02:15.59201	2025-11-12 16:23:56.257213	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5c8ebb91-2bdd-4ad2-83a6-da8bc92218fb.mp3?alt=media	C1		[Geology] Magma fuels volcanoes. | [Science] Study magma composition. | [Earth] Magma forms igneous rocks.	\N	Molten rock beneath the Earthâ€™s surface.	dung nham (dưới lòng đất)	ˈmæɡmə	magma	44
38dfd2c3-ff54-420f-bd93-a323203686d8	2025-11-12 13:02:15.609082	2025-11-12 16:23:56.560085	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F38ee63d7-99b9-43fc-98df-00570c035e00.mp3?alt=media	C1		[Astronomy] Observe a nebula through a telescope. | [Science] Nebulas form stars. | [Space] Nebulas are cosmic clouds.	\N	A cloud of gas and dust in space, often where stars form.	tinh vân	ˈnebjlə	nebula	45
1b69a7bd-1ab3-461c-ad9c-5230bc348bdc	2025-11-12 13:02:15.621778	2025-11-12 16:23:57.1522	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe6e451cf-8ab1-4708-8d04-c61954bec386.mp3?alt=media	B2		[Engineering] Build a product prototype. | [Design] Test the prototype's function. | [Innovation] Develop a new prototype.	\N	An early model of a product for testing.	nguyên mẫu	ˈprəʊtətaɪp	prototype	46
663754d9-6233-4eab-8f16-c903672fd3be	2025-11-12 13:02:15.646037	2025-11-12 16:23:57.476968	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1587fe51-0a56-407c-836a-188cfc878848.mp3?alt=media	B2		[Engineering] Robotics advances technology. | [Science] Study robotics in college. | [Innovation] Robotics transforms industries.	\N	The branch of engineering dealing with robots.	ngành robot	rəʊˈbɒtɪks	robotics	46
839a436a-4016-4c71-9db3-f93a72c6bfb4	2025-11-12 13:02:15.666936	2025-11-12 16:23:58.381045	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa5b5bcc3-1770-439b-a9b3-fb1b560236d7.mp3?alt=media	A2		[Agriculture] Harvest crops in autumn. | [Farming] Plant seasonal crops. | [Economy] Crops boost trade.	\N	Plants grown for food or other uses.	cây trồng	krɒp	crop	48
7911f1b9-ac88-43e4-80ed-ed1b911e11de	2025-11-12 13:02:15.673479	2025-11-12 16:23:58.459832	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F002d2603-25ad-4730-a5db-a0e6601894f7.mp3?alt=media	B2		[Agriculture] Use irrigation for crops. | [Farming] Improve irrigation systems. | [Science] Study irrigation efficiency.	\N	The artificial supply of water to crops.	tưới tiêu	ˌɪrɪˈɡeɪʃn	irrigation	48
93a8ec5e-f297-4dff-ad50-5f5c7d8a0693	2025-11-12 13:02:15.687252	2025-11-12 16:23:58.598446	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fab8ee704-d6db-4c4b-af58-ef662924c598.mp3?alt=media	B2		[Agriculture] Use pesticides carefully. | [Farming] Pesticides protect crops. | [Science] Study pesticide effects.	\N	A chemical used to kill pests that harm crops.	thuốc trừ sâu	ˈpestɪsaɪd	pesticide	48
9020e62c-338e-4e7d-b9e0-913ffce241b9	2025-11-12 13:02:15.694295	2025-11-12 16:23:58.66793	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4abe6a6a-c9ea-40f7-917c-ff9ad89c8591.mp3?alt=media	A2		[Agriculture] Prepare for the harvest. | [Farming] Harvest crops in autumn. | [Season] The harvest was successful.	\N	The process of gathering mature crops.	vụ mùa/thu hoạch	ˈhɑːvɪst	harvest	48
cce47762-fcc9-4183-be2e-39f3e6231d37	2025-11-12 13:02:15.708028	2025-11-12 16:23:58.840417	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F995735e7-9d2a-46d9-bd63-f01918b90e3e.mp3?alt=media	B2		[Agriculture] Raise livestock for food. | [Farming] Feed the livestock daily. | [Economy] Livestock supports farmers.	\N	Animals raised for food or other products.	gia súc	ˈlaɪvstɒk	livestock	48
c96183ea-41f7-4b75-b0c0-e74067d01cbe	2025-11-12 13:02:15.713566	2025-11-12 16:23:58.895891	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1f65924b-70a3-4819-8fc1-ea13f32cf3cc.mp3?alt=media	B1		[Agriculture] Buy organic vegetables. | [Farming] Use organic methods. | [Food] Organic products are healthier.	\N	Food or farming without synthetic chemicals.	hữu cơ	ɔːˈɡænɪk	organic	48
3dddad6f-8a25-48d7-8d03-3e69cd99c6c0	2025-11-12 13:02:15.725947	2025-11-12 16:23:59.011461	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc07b6691-c7a2-48fe-a734-6dc78d40754e.mp3?alt=media	B2		[Health] Get a medical diagnosis. | [Medicine] The diagnosis was accurate. | [Doctor] Discuss the diagnosis.	\N	The identification of a disease or condition.	chẩn đoán	ˌdaɪəɡˈnəʊsɪs	diagnosis	23
6772375b-0b2d-48bd-b1eb-003c960dff42	2025-11-12 13:02:15.932754	2025-11-12 16:24:03.25163	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F914308de-fee3-492a-9e43-8d452ed28d13.mp3?alt=media	A2		[Music] Attend a live concert. | [Performance] Perform at a concert. | [Culture] Concerts attract crowds.	\N	A live performance of music.	buổi hòa nhạc	ˈkɒnsət	concert	53
0b28f7fb-77c7-4838-91dd-2ee714efc586	2025-11-12 13:02:15.754635	2025-11-12 16:23:59.542616	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F52568cfc-97aa-4f93-9351-da1df407cb12.mp3?alt=media	C1		[Health] Control the epidemic spread. | [Medicine] Study epidemic patterns. | [History] Epidemics affect populations.	\N	A widespread outbreak of a disease.	dịch bệnh	ˌepɪˈdemɪk	epidemic	23
2acbeaed-37a9-4130-8e5d-1a5b202f780b	2025-11-12 13:02:15.760844	2025-11-12 16:23:59.64953	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4b35e68f-d41a-4a1c-a8e7-baf557e77bdb.mp3?alt=media	B1		[Psychology] Study human behavior. | [Science] Behavior reflects emotions. | [Observation] Analyze animal behavior.	\N	The way a person or animal acts.	hành vi	bɪˈheɪvjə	behavior	49
564849b1-a7d6-4c3f-bff0-2bf4de1c3612	2025-11-12 13:02:15.771606	2025-11-12 16:23:59.794823	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1837960c-773c-46a0-a367-f409b5a16520.mp3?alt=media	A2		[Psychology] Manage stress daily. | [Health] Stress affects sleep. | [Science] Study stress causes.	\N	Mental or emotional strain or pressure.	căng thẳng	stres	stress	49
ee3d130e-a931-4c2b-98f0-71e72d7aa866	2025-11-12 13:02:15.782198	2025-11-12 16:23:59.861965	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1e9f8ec5-4a10-4e9b-9eeb-eac30540a09e.mp3?alt=media	B2		[Psychology] Seek counseling for stress. | [Health] Counseling helps mental health. | [Service] Offer family counseling.	\N	Professional guidance to address personal or mental issues.	tư vấn	ˈkaʊnsəlɪŋ	counseling	49
f009a599-81a0-4f83-9c78-78ba22c23fac	2025-11-12 13:02:15.788509	2025-11-12 16:23:59.993489	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F141dfd12-a6ba-4fe4-b39f-8a77d96d3170.mp3?alt=media	B1		[Psychology] Find motivation to study. | [Health] Motivation drives success. | [Science] Study motivation theories.	\N	The reason or drive to act or achieve a goal.	động lực	ˌməʊtɪˈveɪʃn	motivation	49
b3aa70db-7a07-4d54-8d24-ee32e21bb697	2025-11-12 13:02:15.799691	2025-11-12 16:24:00.127104	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb1d2ce88-cf22-479d-ad7f-eeccb03260cb.mp3?alt=media	B2		[Psychology] Perception shapes reality. | [Science] Study visual perception. | [Health] Perception influences decisions.	\N	The way one interprets or understands something.	nhận thức (giác quan)	pəˈsepʃn	perception	49
61277383-a538-46e1-b916-890a278c9081	2025-11-12 13:02:15.808403	2025-11-12 16:24:00.467742	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F85f0f836-99b3-46ea-ac85-06d6f25e74c7.mp3?alt=media	B1		[Education] Watch a tutorial video. | [Learning] Follow the math tutorial. | [School] Attend a coding tutorial.	\N	A lesson or guide to teach a specific skill.	bài hướng dẫn	tjuːˈtɔːriəl	tutorial	50
c3fd0dcf-bf20-4a0d-bec8-d383289c76ac	2025-11-12 13:02:15.828494	2025-11-12 16:24:01.066377	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa0af07aa-1ced-4d88-a369-2ef7afc70f10.mp3?alt=media	B2		[Literature] Enjoy the fantasy genre. | [Book] Explore different genres. | [Culture] Genres shape storytelling.	\N	A category of literature or art, like mystery or sci-fi.	thể loại	ˈʒɒnrə	genre	51
e16db8f7-5f1b-4207-811a-1387297c0d8b	2025-11-12 13:02:15.841564	2025-11-12 16:24:01.251324	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fedb19702-39f7-479b-98eb-7a46bccbcfd5.mp3?alt=media	A2		[Literature] Create a memorable character. | [Story] The character faced challenges. | [Book] Analyze the main character.	\N	A person or figure in a story or play.	nhân vật	ˈkærəktə	character	51
4985dfb9-385a-4240-a7c9-b480e0e35f0f	2025-11-12 13:02:15.85019	2025-11-12 16:24:01.370356	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe178a3fa-00c3-40fe-a9e8-bef27de9b31e.mp3?alt=media	B2		[Literature] Symbolism enhances stories. | [Book] Analyze symbolism in poetry. | [Art] The dove represents symbolism of peace.	\N	The use of symbols to represent ideas or qualities.	biểu tượng	ˈsɪmbəlɪzəm	symbolism	51
36ad352c-081f-405f-879f-b34198db2d31	2025-11-12 13:02:15.856724	2025-11-12 16:24:01.652034	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd95ad369-4e6e-4955-a7f4-053ab55b20f9.mp3?alt=media	C1		[Literature] The story is an allegory. | [Book] Study allegories in class. | [Art] Allegories teach moral lessons.	\N	A story with a hidden moral or symbolic meaning.	ngụ ngôn	ˈæləɡəri	allegory	51
223cef1b-8e90-44ba-9d3a-e04db886ed9a	2025-11-12 13:02:15.872434	2025-11-12 16:24:01.679862	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F50cc749b-324b-4068-b049-b79c82007d7f.mp3?alt=media	B2		[Literature] Memorize a verse of poetry. | [Poetry] Write a verse for class. | [Art] The verse was lyrical.	\N	Writing arranged with a metrical rhythm, typically in poetry.	thơ (đoạn)	vɜːs	verse	51
1e6fd319-a39b-4316-9aee-f36729520cbc	2025-11-12 13:02:15.867542	2025-11-12 16:24:01.748893	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F896a9fe8-e71b-47b6-a5c2-3a1078089d11.mp3?alt=media	B2		[Literature] Write prose for the novel. | [Book] Prose differs from poetry. | [Writing] Her prose is beautiful.	\N	Written or spoken language in its ordinary form, without verse.	văn xuôi	prəʊz	prose	51
1c2eb9ac-606a-4ad6-b86e-427ccac7cfc7	2025-11-12 13:02:15.891453	2025-11-12 16:24:01.974325	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F84a26ac0-b826-4a29-9d78-2bd7aff7fb0f.mp3?alt=media	B2		[Literature] Shakespeare was a playwright. | [Theater] Meet the famous playwright. | [Art] Playwrights create stories.	\N	A person who writes plays.	nhà viết kịch	ˈpleɪraɪt	playwright	51
1c54a0ba-896d-4ffc-af15-b268a2815230	2025-11-12 13:02:15.88586	2025-11-12 16:24:02.029633	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5252b79f-7eaa-46ab-9b4b-f0076f3beeac.mp3?alt=media	B2		[Poetry] Each stanza has four lines. | [Literature] Analyze the stanza’s meaning. | [Writing] Write a new stanza.	\N	A grouped set of lines in a poem.	đoạn thơ	ˈstænzə	stanza	51
1a408a2d-7ff3-475e-b33c-f6cce70f5813	2025-11-12 13:02:15.908767	2025-11-12 16:24:03.074268	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F80e7f186-7d6d-48fe-81c8-3ebdbf4a8bc5.mp3?alt=media	A2		[Music] Play a musical instrument. | [School] Learn the guitar instrument. | [Performance] Tune your instrument.	\N	A tool or device used to play music.	nhạc cụ	ˈɪnstrəmənt	instrument	53
b9413a6c-d5f4-4af8-b964-d6452f7ec184	2025-11-12 13:02:15.920843	2025-11-12 16:24:03.20421	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff954c4b4-770a-46b8-adc7-81fa2c66a70e.mp3?alt=media	B1		[Music] Follow the song’s rhythm. | [Performance] Dance to the rhythm. | [Art] Rhythm enhances music.	\N	The pattern of beats or stresses in music.	nhịp điệu	ˈrɪðəm	rhythm	53
d8e403e7-b424-4ea3-96e0-c119f91ef384	2025-11-12 13:02:15.927404	2025-11-12 16:24:03.217965	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fce1fa5c4-af73-45df-a309-5de465655877.mp3?alt=media	B2		[Music] Create harmony in songs. | [Performance] Sing in perfect harmony. | [Art] Harmony balances melodies.	\N	The combination of musical notes played together.	hòa âm	ˈhɑːməni	harmony	53
26048055-6a5c-400d-bac6-8aa859fc7bee	2025-11-12 13:02:15.944807	2025-11-12 16:24:03.532304	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F48f0ba26-f96e-4528-a060-82b7b2eafdb8.mp3?alt=media	B1		[Music] Watch an orchestra perform. | [Performance] Join the school orchestra. | [Art] Orchestras play symphonies.	\N	A large group of musicians playing together.	dàn nhạc giao hưởng	ˈɔːkɪstrə	orchestra	53
e334935f-3b7f-4595-ab7f-f43d201d979d	2025-11-12 13:02:15.957077	2025-11-12 16:24:03.815371	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3c005301-bb2e-4ed0-9910-547b2f45609f.mp3?alt=media	B2		[Dance] Create new choreography. | [Performance] Practice the choreography. | [Art] Choreography enhances shows.	\N	The art of designing dance sequences.	biên đạo múa	ˌkɒriˈɒɡrəfi	choreography	54
b389c041-71f0-4b12-a276-8d9818a3d134	2025-11-12 13:02:15.963505	2025-11-12 16:24:03.967207	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fcca75dcd-61b9-4e01-901c-ae2b30661a41.mp3?alt=media	B1		[Dance] Practice the dance routine. | [Performance] Perform a new routine. | [Art] Create a routine for the show.	\N	A sequence of dance or performance steps.	điệu múa (bài tập)	ruːˈtiːn	routine	54
321c6da7-6557-4ee7-8e4c-99e941ce8139	2025-11-12 13:02:15.971291	2025-11-12 16:24:04.194113	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5df32f7b-095f-487f-b3c7-740b1154e0db.mp3?alt=media	A2		[Performance] Perform on a stage. | [Theater] Decorate the stage. | [Art] The stage was lit brightly.	\N	A platform where performances take place.	sân khấu	steɪdʒ	stage	54
22d125f4-99ed-4f08-af85-32d1198e4085	2025-11-12 13:02:15.986862	2025-11-12 16:24:04.555453	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3b75c270-512f-47a1-9d58-3804fa7b5753.mp3?alt=media	B1		[Performance] Receive loud applause. | [Theater] Applause followed the show. | [Art] Applause rewards performers.	\N	Clapping to show appreciation for a performance.	sự vỗ tay	əˈplɔːz	applause	54
cf5cbcce-2c9e-4499-9544-24d97d69cd57	2025-11-12 13:02:15.998794	2025-11-12 16:24:04.715136	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1ce32b95-022c-4b69-aba6-c0d512e72612.mp3?alt=media	B1		[Cinema] The director filmed the movie. | [Art] Meet a famous director. | [Film] Directors lead productions.	\N	People who guide the making of a film or play.	đạo diễn	dɪˈrektə	director	55
5f5e90a0-805b-45b3-9747-569614688c0c	2025-11-12 13:02:16.005702	2025-11-12 16:24:04.824117	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe469c278-f553-4ea0-b6c6-4cb4141d5365.mp3?alt=media	B1		[Cinema] Write a movie script. | [Film] Read the script carefully. | [Art] Scripts guide actors.	\N	The written text of a film, play, or broadcast.	kịch bản	skrɪpt	script	55
74774577-c266-461d-b068-97e2285e0ef9	2025-11-12 13:02:16.018459	2025-11-12 16:24:05.013925	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F56871e2d-55e3-4017-a561-b74de3fcd038.mp3?alt=media	A2		[Cinema] The actress won an award. | [Film] Meet a famous actress. | [Art] Actresses shine in roles.	\N	A woman who performs in films, plays, or shows.	diễn viên (nữ)	ˈæktrəs	actress	55
e347ec82-a54a-40c0-97cf-e2785a7c3253	2025-11-12 13:02:16.024875	2025-11-12 16:24:05.096746	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F385a163b-ec0a-45ea-ba56-e8997e7cc129.mp3?alt=media	A2		[Cinema] Film a dramatic scene. | [Film] The scene was emotional. | [Art] Direct the next scene.	\N	A part of a film or play showing a single event.	cảnh (phim)	siːn	scene	55
7929df3a-c3e2-44c2-9a67-880cb1e2740b	2025-11-12 13:02:16.038267	2025-11-12 16:24:05.194842	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F74f1604b-2a51-444a-8190-9e6681bb69a7.mp3?alt=media	B2		[Cinema] Editing improves the film. | [Film] Learn video editing skills. | [Art] Editing shapes the story.	\N	The process of selecting and arranging film or text.	biên tập (phim)	ˈedɪtɪŋ	editing	55
61ac5798-f150-4dab-a76b-d6690967ecfa	2025-11-12 13:02:16.04479	2025-11-12 16:24:05.366649	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5ee6e318-1b63-43ec-8ddd-0e0efefbf416.mp3?alt=media	B1		[Cinema] The soundtrack was memorable. | [Film] Choose a movie soundtrack. | [Art] Soundtracks set the mood.	\N	Music accompanying a film or show.	nhạc nền (phim)	ˈsaʊndtræk	soundtrack	55
5d050834-9c7a-4d6c-b705-61c4bbd94665	2025-11-12 13:02:16.058975	2025-11-12 16:24:05.556898	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff41f580c-f5ab-4b5e-8c94-d10240573d15.mp3?alt=media	B1		[Photography] Choose a zoom lens. | [Camera] Clean the camera lens. | [Art] Lenses affect photo quality.	\N	A piece of glass in a camera that focuses light.	ống kính	lenz	lens	56
9cc5c12f-7b6d-4785-b3c1-3b689d3b5d14	2025-11-12 13:02:16.066461	2025-11-12 16:24:05.572493	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffcc18cc5-0eb1-4d4c-bf7b-1b8ecb9cbb35.mp3?alt=media	B2		[Photography] Adjust the shutter speed. | [Camera] The shutter controls light. | [Art] Shutter settings impact photos.	\N	A camera part controlling light exposure.	màn trập	ˈʃʌtə	shutter	56
956493ff-c490-4fb0-a014-68cdbe8e7f42	2025-11-12 13:02:16.080384	2025-11-12 16:24:05.824197	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1b4da657-0f51-4ca0-9e34-6657cadfc505.mp3?alt=media	A2		[Photography] Adjust the camera focus. | [Art] Focus on the subject. | [Camera] Sharp focus improves photos.	\N	The clarity or sharpness of an image.	tiêu điểm	ˈfəʊkəs	focus	56
ee75b2b2-c3dc-46f1-b943-ad2fe0ebfad5	2025-11-12 13:02:16.098923	2025-11-12 16:24:05.947117	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4f5e787c-3b9b-400a-9b7d-b677bc852a7e.mp3?alt=media	C1		[Photography] Practice portraiture in studios. | [Art] Portraiture captures emotions. | [Hobby] Learn portraiture techniques.	\N	The art of creating portraits through photography or painting.	nghệ thuật chụp chân dung	ˈpɔːtrətʃə	portraiture	56
e14df28b-c552-43d9-b6f6-916029add7c8	2025-11-12 13:02:16.09248	2025-11-12 16:24:05.95313	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe7185af9-9887-4c3b-8169-5d876111ebc5.mp3?alt=media	B1		[Photography] Use soft lighting. | [Art] Lighting sets the mood. | [Film] Adjust lighting for the scene.	\N	The use of light in photography or performance.	ánh sáng	ˈlaɪtɪŋ	lighting	56
2f0b521f-d365-4f23-b35b-27af92ded2ac	2025-11-12 13:02:16.104351	2025-11-12 16:24:06.177304	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff437de71-22a5-4126-be74-250bc6bef722.mp3?alt=media	B2		[Photography] Apply a photo filter. | [Camera] Use a UV filter. | [Art] Filters enhance colors.	\N	A device or effect altering a photoâ€™s appearance.	bộ lọc (ảnh)	ˈfɪltə	filter	56
58a74d03-5f05-4baf-bf56-ef2086d6c02d	2025-11-12 13:02:09.324522	2025-11-12 13:02:09.32455	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8ec9a3c4-a3bb-4793-8584-ad5a9d6f6c5b.mp3?alt=media	A1		[Work] The baby was recorded carefully in the report. | [Problem] The baby broke suddenly, so we had to fix it. | [Story] A traveler found a baby near the old counter.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fbc8b46fd-8aa4-4d1a-a881-1a005b819072.jpg?alt=media	A very young child who requires care and attention.	em bé	ˈbeɪbi	baby	2
2e8d9781-c720-4fd1-a275-95be1f236b04	2025-11-12 12:10:11.041023	2025-11-12 12:10:11.041083	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5668b814-c5c6-4b20-9b1d-98663c52c6c3.mp3?alt=media	A1	“Father with child.jpg” by Unknown author, source: https://commons.wikimedia.org/wiki/File:Father_with_child.jpg, license: Public Domain (https://creativecommons.org/publicdomain/mark/1.0/).	[Memory] This father reminds me of my childhood in the countryside. | [Hobby] He collects photos of fathers from different countries. | [Description] That father looks modern in the afternoon light.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F853d806c-aa9a-48c0-9733-f1f117547c14.jpeg?alt=media	A male parent who provides care and guidance to his children.	cha	ˈfɑːðə	father	2
2f6a493d-722f-46cc-8c97-56622c5818e1	2025-11-12 13:02:09.224663	2025-11-12 13:02:09.224687	null	A1	“Coffee Beans Photographed in Macro.jpg” by Robert Knapp, source: https://commons.wikimedia.org/wiki/File:Coffee_Beans_Photographed_in_Macro.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).	[Memory] This coffee reminds me of my childhood in the countryside. | [Hobby] He collects photos of coffees from different countries. | [Description] That coffee looks modern in the afternoon light.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F4214c909-a980-4d69-9259-d11b710f3853.jpeg?alt=media	A drink made from roasted coffee beans, known for its stimulating effect.	cà phê	ˈkɒfi	coffee	1
153f4950-96a1-41a2-b7e1-8de7a9e3e858	2025-11-12 13:02:09.273738	2025-11-12 13:02:09.273763	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb25bddde-a526-438e-844c-60c3fc2e41d7.mp3?alt=media	A1	“Sisters.jpg” by User:Khamul, source: https://commons.wikimedia.org/wiki/File:Sisters.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).	[Story] A traveler found a sister near the old floor. | [Work] The sister was recorded carefully in the report. | [Everyday] I put the sister on the floor before dinner.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F8a592e53-49d2-43cf-ae53-e2d06ba42e09.jpg?alt=media	A female sibling who fosters close family ties.	chị/em gái	ˈsɪstə	sister	2
dd252972-a777-4a8b-b702-8cfb354fa5c8	2025-11-12 13:02:09.307039	2025-11-12 13:02:09.307079	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7efc39fb-46b5-42fa-9a5f-b35a785d884f.mp3?alt=media	A1		[Memory] This daughter reminds me of my childhood in the countryside. | [Hobby] He collects photos of daughters from different countries. | [Description] That daughter looks modern in the afternoon light.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F3cdf1fe8-967c-4407-bdd9-2ff65a630103.jpg?alt=media	A female child in a family.	con gái	ˈdɔːtə	daughter	2
084acc4c-f95e-491e-922e-ea5088700f61	2025-11-12 13:02:09.116917	2025-11-12 13:02:09.116961	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F89fd2310-f33d-402a-9308-ecaa2c919d33.mp3?alt=media	A1		[School] The teacher asked us to describe a water in two sentences. | [Everyday] I put the water on the bag before dinner. | [Advice] Keep the water away from fire to stay safe.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F4018283a-4dbf-4396-8ed2-b3ea4f49f8c2.jpeg?alt=media	A clear liquid essential for life, used for drinking, cooking, and cleaning.	nước	ˈwɔːtə	water	1
1a0b5632-1558-44f5-8e72-320993b492dd	2025-11-12 13:02:16.141461	2025-11-12 16:24:08.17014	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F92a38d1f-afed-4e5c-9ed2-9955209b9e3e.mp3?alt=media	B2		[Technology] Design a user interface. | [Software] Improve the interface. | [Innovation] Interfaces enhance usability.	\N	A point where users interact with a computer or device.	giao diện	ˈɪntəfeɪs	interface	58
8fd63640-eb6b-4b05-bc10-40f038d70c26	2025-11-12 13:02:16.147622	2025-11-12 16:24:08.245248	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F481e3176-0adb-4936-98b7-905c1eaf2373.mp3?alt=media	B2		[Technology] Explore virtual reality. | [Innovation] Use virtual meetings. | [Gaming] Virtual worlds are immersive.	\N	Simulated or existing online, not physically.	ảo	ˈvɜːtʃuəl	virtual	58
d45bf7d7-74e8-479a-a0b0-66e427df1bab	2025-11-12 13:02:16.152797	2025-11-12 16:24:08.332835	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3c80f0c6-a42b-40af-8440-a0a278b3306a.mp3?alt=media	C1		[Technology] Improve internet connectivity. | [Industry] Connectivity boosts communication. | [Innovation] Connectivity drives progress.	\N	The ability to connect to networks or devices.	kết nối	kəˌnekˈtɪvəti	connectivity	58
9e292f9f-e60e-4d9a-8758-cb991b9100ce	2025-11-12 13:02:16.180228	2025-11-12 16:24:08.87193	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6cfed434-c150-47bb-992d-44881d089f69.mp3?alt=media	B2		[Business] Study finance in college. | [Economy] Finance drives growth. | [Career] Work in corporate finance.	\N	The management of money and investments.	tài chính	fɪˈnæns	finance	59
51a4f9a3-af8e-4e01-8826-deb537672b39	2025-11-12 13:02:16.174322	2025-11-12 16:24:08.997545	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F72a55ee2-cfed-46e3-baab-3f9731ec2e8a.mp3?alt=media	A2		[Business] Plan a monthly budget. | [Finance] Stick to the budget. | [Economy] Budget for new projects.	\N	A plan for managing income and expenses.	ngân sách	ˈbʌdʒɪt	budget	59
e519cf49-a1b5-4dc9-a7e9-768f86d8b744	2025-11-12 13:02:16.198696	2025-11-12 16:24:09.047198	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9d8e6260-4e09-4deb-b46e-b1865bda7359.mp3?alt=media	B2		[Business] Work for a corporation. | [Economy] Corporations drive markets. | [Industry] Start a new corporation.	\N	A large company or group acting as a single entity.	tập đoàn	ˌkɔːpəˈreɪʃn	corporation	59
a201d6d0-db76-45d0-83eb-6f2c385ce580	2025-11-12 13:02:09.726372	2025-11-12 13:02:09.726438	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F33a6fa9c-a051-4cf0-b009-c0da66c51cfb.mp3?alt=media	A2		[Memory] This manager reminds me of my childhood in the countryside. | [Hobby] He collects photos of managers from different countries. | [Description] That manager looks modern in the afternoon light.	\N	A person responsible for controlling or administering an organization or group.	quản lý	ˈmænɪdʒə	manager	4
e8a496a2-4141-45df-a62a-968ce0649a9e	2025-11-12 13:02:09.390221	2025-11-12 13:02:09.390262	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F152ece4a-36e0-47c6-9006-ec56229af269.mp3?alt=media	A1	“Woman smiling.jpg” by Happy Sloth, source: https://commons.wikimedia.org/wiki/File:Woman_smiling.jpg, license: CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/).	[Memory] This woman reminds me of my childhood in the countryside. | [Hobby] He collects photos of womans from different countries. | [Description] That woman looks modern in the afternoon light.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fd25da32f-6f3d-4947-8744-440a0a4672f0.jpeg?alt=media	An adult female human, often influential in family or society.	người phụ nữ	ˈwʊmən	woman	2
3a6a9ca2-813f-40f2-a2d4-5b8614022d98	2025-11-12 13:02:09.48196	2025-11-12 13:02:09.482013	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4a99ec13-a5d4-4e25-84bf-290f697bc343.mp3?alt=media	A1		[Problem] The pencil broke suddenly, so we had to fix it. | [Description] That pencil looks safe in the afternoon light. | [Work] The pencil was recorded carefully in the report.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F9b2a1536-369e-4644-938b-e2a880a4ee50.jpg?alt=media	A writing tool with an erasable graphite core.	bút chì	ˈpensl	pencil	3
90b17b2c-c63d-4090-a96b-183dbcccbc48	2025-11-12 13:02:09.520445	2025-11-12 13:02:09.520481	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2179a3fb-5dda-42dd-a05c-42ee735cef00.mp3?alt=media	A1		[Work] The school was recorded carefully in the report. | [Problem] The school broke suddenly, so we had to fix it. | [Story] A traveler found a school near the old bench.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fe98be88c-6545-45ee-ae23-bbe8f479aafd.jpg?alt=media	A place where students learn from teachers.	trường học	skuːl	school	3
53402206-d0b0-42f5-bd7a-edba93101226	2025-11-12 13:02:09.565472	2025-11-12 13:02:09.565496	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F633babad-79ac-41e8-8384-07aeef1cdfd4.mp3?alt=media	A1		[Work] The homework was recorded carefully in the report. | [Problem] The homework broke suddenly, so we had to fix it. | [Story] A traveler found a homework near the old counter.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F72c9b6a8-b71d-49d5-a340-1b5b8a38f43c.jpg?alt=media	Tasks assigned by teachers to be done outside class.	bài tập về nhà	ˈhəʊmwɜːk	homework	3
f9826fce-b05f-40d9-8d4e-fc699ca9690a	2025-11-12 13:02:09.551722	2025-11-12 13:02:09.551746	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F98984cf7-7a2e-430b-b289-3aaa7cd31e23.mp3?alt=media	A1		[Hobby] He collects photos of lessons from different countries. | [Shopping] She compared three lessons and chose the freshest one. | [Memory] This lesson reminds me of my childhood in the countryside.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F9428584b-9bbe-48a0-8840-db48c1e99473.jpg?alt=media	A period of learning or teaching on a specific topic.	bài học	ˈlesn	lesson	3
7f7d360f-cac9-4eb7-a829-7f82834de662	2025-11-12 13:02:09.648029	2025-11-12 13:02:09.64806	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2100ac1b-a1ca-41e9-a38b-43575a90363e.mp3?alt=media	A2		[Everyday] I put the worker on the doorway before dinner. | [Story] A traveler found a worker near the old doorway. | [School] The teacher asked us to describe a worker in two sentences.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F04fb0e3e-77b3-440f-8ac1-5ac74f7769b1.jpg?alt=media	A person who does a particular job to earn money.	công nhân	ˈwɜːkə	worker	4
fdc4fd5d-7329-4252-ab0e-94ea37adcf6e	2025-11-12 13:02:09.675456	2025-11-12 13:02:09.675477	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F49fee623-9d04-42bf-b0c4-f60004209517.mp3?alt=media	A1		[Everyday] I put the doctor on the shelf before dinner. | [Story] A traveler found a doctor near the old shelf. | [School] The teacher asked us to describe a doctor in two sentences.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fb2bd48ea-cdde-4b43-94df-c7583d4a8fe4.jpg?alt=media	A person qualified to treat people who are ill.	bác sĩ	ˈdɒktə	doctor	4
b1d54dd2-4329-488f-a95c-2e727b446fd2	2025-11-12 13:02:09.714043	2025-11-12 13:02:09.714127	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0b71131c-d1cf-4526-b88a-6a5bc38eef07.mp3?alt=media	A1		[Story] A traveler found a driver near the old wall. | [Work] The driver was recorded carefully in the report. | [Everyday] I put the driver on the wall before dinner.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F01ff7d35-8d3c-465b-bf84-ab53ff4e02b9.jpg?alt=media	A person who drives a vehicle.	tài xế	ˈdraɪvə	driver	4
7b655c4e-6463-4071-b397-3da907201f81	2025-11-12 13:02:09.701402	2025-11-12 13:02:09.701425	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8ad39497-6f69-4f29-acae-d6212c52e323.mp3?alt=media	A1	“Indian farmer.jpg” by Yann, source: https://commons.wikimedia.org/wiki/File:Indian_farmer.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).	[Memory] This farmer reminds me of my childhood in the countryside. | [Hobby] He collects photos of farmers from different countries. | [Description] That farmer looks modern in the afternoon light.	\N	A person who owns or manages a farm.	nông dân	ˈfɑːmə	farmer	4
15c41d03-b901-49e4-9b19-43befd322627	2025-11-12 12:10:12.286867	2025-11-12 12:10:12.286884	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F10aeca48-7976-4f0b-bbc7-220622c38dcc.mp3?alt=media	A1		[Story] A traveler found a dog near the old floor. | [Work] The dog was recorded carefully in the report. | [Everyday] I put the dog on the floor before dinner.	\N	A domesticated carnivorous mammal kept as a pet or for work.	chó	dɒɡ	dog	7
ed31c7d0-cfe4-4f46-8822-a04a702640b0	2025-11-12 13:02:11.309859	2025-11-12 13:02:11.309876	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff3e4e19e-9322-42da-b61e-e9be98bb6a0e.mp3?alt=media	B2		[School] The teacher asked us to describe a fiction in two sentences. | [Everyday] I put the fiction on the bag before dinner. | [Advice] Keep the fiction away from water to stay safe.	\N	Literature in the form of prose that describes imaginary events.	văn hư cấu	ˈfɪkʃn	fiction	19
6950f251-0c04-4a00-8598-9362ed1ca395	2025-11-12 13:02:09.461501	2025-11-12 13:02:09.461535	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6b4be171-670f-49be-a762-0a50616f3eac.mp3?alt=media	A1		[Memory] This pen reminds me of my childhood in the countryside. | [Hobby] He collects photos of pens from different countries. | [Description] That pen looks modern in the afternoon light.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fd1290767-dab6-4c0b-893a-ffed8fa86b5c.jpg?alt=media	A tool used for writing or drawing with ink.	bút mực	pen	pen	3
859a67dd-5dd0-4193-9d04-87fc41a03c59	2025-11-12 13:02:09.932509	2025-11-12 13:02:09.932531	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5c1601ea-54bc-43f9-b907-1db98e945240.mp3?alt=media	A1		[Work] The player was recorded carefully in the report. | [Problem] The player broke suddenly, so we had to fix it. | [Story] A traveler found a player near the old bag.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fd5698e24-51a6-40f4-b2f5-433a4b8e518b.jpg?alt=media	A person taking part in a sport or game.	cầu thủ; người chơi	ˈpleɪə	player	6
88dbb0be-571e-4b1e-81ab-6dcdc8d2ea84	2025-11-12 13:02:09.8547	2025-11-12 13:02:09.854719	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F60afe60b-62df-441e-8c99-58981da8a956.mp3?alt=media	A1		[Health] Doctors say you should swim regularly to stay healthy. | [Weather] It's hard to swim when the sun is very strong. | [Tip] If you swim too fast at the start, you'll get tired quickly.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F495d0ac4-9ff8-4565-8924-d379c1d126f0.jpg?alt=media	To propel oneself through water using limbs.	bơi	swɪm	swim	6
6f5f430b-90cc-4a94-a1ec-fc27af478b2d	2025-11-12 13:02:09.7653	2025-11-12 13:02:09.76532	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbbc895ff-4afd-4db7-9fda-2c39b15148fd.mp3?alt=media	A1		[Everyday] I put the plane on the table before dinner. | [Story] A traveler found a plane near the old table. | [School] The teacher asked us to describe a plane in two sentences.	\N	An aircraft that flies through the air, used for long-distance travel.	máy bay	pleɪn	plane	5
d8dad4c0-48e7-4270-8799-b8dd6787b0bf	2025-11-12 13:02:09.815372	2025-11-12 13:02:09.815395	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd59d995b-1227-4bad-9e58-3866f05a51c1.mp3?alt=media	A1		[Hobby] He collects photos of trips from different countries. | [Shopping] She compared three trips and chose the freshest one. | [Memory] This trip reminds me of my childhood in the countryside.	\N	A journey or excursion, especially for pleasure.	chuyến đi	trɪp	trip	5
c45aef5b-c3a0-424e-b2a2-030596c81b09	2025-11-12 13:02:09.777755	2025-11-12 13:02:09.777789	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F55ad6e77-9fa0-46d2-8292-a8804691dead.mp3?alt=media	A1		[School] The teacher asked us to describe a airport in two sentences. | [Everyday] I put the airport on the doorway before dinner. | [Advice] Keep the airport away from heat to stay safe.	\N	A place where aircraft take off and land, with facilities for passengers.	sân bay	ˈeəpɔːt	airport	5
a42fb061-d0a3-4fa9-a51b-1eade4ca02b9	2025-11-12 13:02:09.827632	2025-11-12 13:02:09.827656	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F77afd861-bafa-4617-bced-f42cc6f1fe89.mp3?alt=media	A1		[Problem] The holiday broke suddenly, so we had to fix it. | [Description] That holiday looks safe in the afternoon light. | [Work] The holiday was recorded carefully in the report.	\N	A day of festivity or recreation when no work is done.	kỳ nghỉ	ˈhɒlədeɪ	holiday	5
c11a7711-57e8-4eff-bf2c-6f8aa10acc8f	2025-11-12 13:02:09.893295	2025-11-12 13:02:09.893314	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2fbec6b7-bd9c-42dc-98d3-76a97d471478.mp3?alt=media	A1	“Tennis player.jpg” by Carine06, source: https://commons.wikimedia.org/wiki/File:Tennis_player.jpg, license: CC BY-SA 2.0 (https://creativecommons.org/licenses/by-sa/2.0/).	[Work] The tennis was recorded carefully in the report. | [Problem] The tennis broke suddenly, so we had to fix it. | [Story] A traveler found a tennis near the old counter.	\N	A game in which two or four players strike a ball with rackets over a net.	quần vợt	ˈtenɪs	tennis	6
fe4bc1b7-b085-482f-bba7-93c796bc7588	2025-11-12 13:02:09.866849	2025-11-12 13:02:09.866878	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F592333c4-aaa4-42e9-bf01-8e9e9230535a.mp3?alt=media	A1	“Football player.jpg” by Ben Sutherland, source: https://commons.wikimedia.org/wiki/File:Football_player.jpg, license: CC BY 2.0 (https://creativecommons.org/licenses/by/2.0/).	[Work] The football was recorded carefully in the report. | [Problem] The football broke suddenly, so we had to fix it. | [Story] A traveler found a football near the old bench.	\N	A game played by two teams of eleven players with a round ball.	bóng đá	ˈfʊtbɔːl	football	6
03723ee8-f250-4240-885a-7edc8eda1974	2025-11-12 13:02:09.909046	2025-11-12 13:02:09.909072	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6a1f36db-8014-4208-a6dd-56cacf2e1415.mp3?alt=media	A1		[Work] The exercise was recorded carefully in the report. | [Problem] The exercise broke suddenly, so we had to fix it. | [Story] A traveler found a exercise near the old table.	\N	Physical activity done to improve health or fitness.	bài tập; tập luyện	ˈeksəsaɪz	exercise	6
0c8ef2c5-f839-49e4-9834-3955853357d3	2025-11-12 13:02:09.753473	2025-11-12 13:02:09.753492	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe169e395-4088-4474-b9e9-3fb1aa884b11.mp3?alt=media	A1		[Story] A traveler found a train near the old table. | [Work] The train was recorded carefully in the report. | [Everyday] I put the train on the table before dinner.	\N	A series of connected vehicles that run along a railway track.	tàu hỏa	treɪn	train	5
cbbc3855-f8f4-401d-9dad-787e3753a7f2	2025-11-12 13:02:09.537373	2025-11-12 13:02:09.537413	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fde117342-7172-42c0-9371-efb5a7e92043.mp3?alt=media	A1		[Hobby] He collects photos of classrooms from different countries. | [Shopping] She compared three classrooms and chose the freshest one. | [Memory] This classroom reminds me of my childhood in the countryside.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F5f35e261-fb1c-4287-b282-7f1327b8c893.jpg?alt=media	A room where students attend lessons.	phòng học	ˈklɑːsruːm	classroom	3
7f0a1765-6092-49d2-b7f1-a3f64d5a30e9	2025-11-12 13:02:10.032983	2025-11-12 13:02:10.03305	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd116943d-a151-4ddc-9e09-cbe32d53e16e.mp3?alt=media	A1		[Shopping] She compared three goats and chose the freshest one. | [Advice] Keep the goat away from heat to stay safe. | [Hobby] He collects photos of goats from different countries.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F1c918c95-9e68-4a10-ad1e-1462a4cdc331.jpg?alt=media	A hardy domesticated ruminant mammal with horns.	dê	ɡəʊt	goat	7
b6ffdff8-d64d-4785-a693-e238afec6a38	2025-11-12 13:02:10.072183	2025-11-12 13:02:10.072214	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4a10a51d-270b-44c6-96f5-29b10f568c74.mp3?alt=media	A1	“Duck swimming.jpg” by Bernard Spragg, source: https://commons.wikimedia.org/wiki/File:Duck_swimming.jpg, license: CC0 1.0 (https://creativecommons.org/publicdomain/zero/1.0/).	[Everyday] I put the duck on the table before dinner. | [Story] A traveler found a duck near the old table. | [School] The teacher asked us to describe a duck in two sentences.	\N	A swimming bird with a broad bill and webbed feet.	vịt	dʌk	duck	7
02524785-3026-48f4-b538-9f32298d5736	2025-11-12 13:02:10.053708	2025-11-12 13:02:10.053741	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F540d2b51-f3fa-4ea3-bf8c-804719ace5ba.mp3?alt=media	A1	“Chicken portrait.jpg” by Luis Miguel Bugallo Sánchez, source: https://commons.wikimedia.org/wiki/File:Chicken_portrait.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).	[School] The teacher asked us to describe a chicken in two sentences. | [Everyday] I put the chicken on the bench before dinner. | [Advice] Keep the chicken away from heat to stay safe.	\N	A domesticated fowl kept for eggs or meat.	gà	ˈtʃɪkɪn	chicken	7
370c6ff5-c28c-4756-ba16-ee19fcd6d8c5	2025-11-12 13:02:10.089601	2025-11-12 13:02:10.089637	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Faa78f738-de4e-485f-a0dc-bffd11705a45.mp3?alt=media	A1	“Rabbit in grass.jpg” by Aconcagua, source: https://commons.wikimedia.org/wiki/File:Rabbit_in_grass.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).	[Problem] The rabbit broke suddenly, so we had to fix it. | [Description] That rabbit looks safe in the afternoon light. | [Work] The rabbit was recorded carefully in the report.	\N	A small burrowing mammal with long ears and soft fur.	thỏ	ˈræbɪt	rabbit	7
ac75bf56-ecb8-4e04-921d-0eda3338229a	2025-11-12 13:02:10.107987	2025-11-12 13:02:10.108015	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff5c91dc5-5740-431e-b367-611548b7bb84.mp3?alt=media	A1	“Full moon.jpg” by Gregory H. Revera, source: https://commons.wikimedia.org/wiki/File:Full_moon.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).	[Memory] This moon reminds me of my childhood in the countryside. | [Hobby] He collects photos of moons from different countries. | [Description] That moon looks modern in the afternoon light.	\N	The natural satellite of the earth, visible at night.	mặt trăng	muːn	moon	8
3bada75d-ff07-4aa5-8622-2b54f3c5eb59	2025-11-12 13:02:10.133245	2025-11-12 13:02:10.133266	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fff477b39-6901-4de3-9bd8-36518f20b95b.mp3?alt=media	A1	“Blue sky with clouds.jpg” by Diego Delso, source: https://commons.wikimedia.org/wiki/File:Blue_sky_with_clouds.jpg, license: CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/).	[Work] The sky was recorded carefully in the report. | [Problem] The sky broke suddenly, so we had to fix it. | [Story] A traveler found a sky near the old desk.	\N	The region above the earth, appearing blue during the day.	bầu trời	skaɪ	sky	8
22124e5f-d914-45a9-9bd3-311453433cf8	2025-11-12 13:02:10.160625	2025-11-12 13:02:10.160646	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3dba2de5-b556-484c-8088-fcbbf55cdde7.mp3?alt=media	A1	“Red rose.jpg” by André Karwath, source: https://commons.wikimedia.org/wiki/File:Red_rose.jpg, license: CC BY-SA 2.5 (https://creativecommons.org/licenses/by-sa/2.5/).	[Advice] Keep the flower away from noise to stay safe. | [School] The teacher asked us to describe a flower in two sentences. | [Shopping] She compared three flowers and chose the freshest one.	\N	The reproductive structure of flowering plants, often colorful.	hoa	ˈflaʊə	flower	8
8b9f764d-12f4-4add-90d6-dc72cd1cedd0	2025-11-12 13:02:10.195369	2025-11-12 13:02:10.195385	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb315ea84-2138-4242-9811-cdfa10e8af9e.mp3?alt=media	A1		[Work] The mountain was recorded carefully in the report. | [Problem] The mountain broke suddenly, so we had to fix it. | [Story] A traveler found a mountain near the old bench.	\N	A large natural elevation of the earth's surface.	núi	ˈmaʊntən	mountain	8
08a915e2-f0ab-4dee-8d2c-0f4f18538dad	2025-11-12 13:02:10.002135	2025-11-12 13:02:10.002158	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa00924d3-4644-4861-b946-d32d6c0eed75.mp3?alt=media	A1	“Horse in field.jpg” by Dirk Ingo Franke, source: https://commons.wikimedia.org/wiki/File:Horse_in_field.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).	[Memory] This horse reminds me of my childhood in the countryside. | [Hobby] He collects photos of horses from different countries. | [Description] That horse looks modern in the afternoon light.	\N	A large domesticated mammal used for riding or work.	ngựa	hɔːs	horse	7
ad50fa9d-3d44-416b-b8db-115e4748a685	2025-11-12 13:02:09.620324	2025-11-12 13:02:09.62035	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8cef3a89-784f-4dd8-9485-9507d85a779c.mp3?alt=media	A1		[Story] A traveler found a office near the old counter. | [Work] The office was recorded carefully in the report. | [Everyday] I put the office on the counter before dinner.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fbe61236c-c209-43bb-9f3d-ff1dea687d48.jpg?alt=media	A building or room where people work, especially in business or administration.	văn phòng	ˈɒfɪs	office	4
06d8d1e2-7c63-4eff-a469-4b085c1f4bc5	2025-11-12 13:02:10.235655	2025-11-12 13:02:10.23567	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffd17e01d-d2d2-4e85-a83f-ccf370360286.mp3?alt=media	A1		[School] The teacher asked us to describe a bed in two sentences. | [Everyday] I put the bed on the counter before dinner. | [Advice] Keep the bed away from sunlight to stay safe.	\N	A piece of furniture for sleeping.	giường	bed	bed	9
46385d57-e64f-4da2-9a66-a6c5f2a87992	2025-11-12 13:02:10.278767	2025-11-12 13:02:10.278828	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc5f7950e-c27c-4288-9ec9-7b869d07c47b.mp3?alt=media	A1	“Open window.jpg” by Vitold Muratov, source: https://commons.wikimedia.org/wiki/File:Open_window.jpg, license: CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/).	[Hobby] He collects photos of windows from different countries. | [Shopping] She compared three windows and chose the freshest one. | [Memory] This window reminds me of my childhood in the countryside.	\N	An opening in a wall for admitting light or air, usually with glass.	cửa sổ	ˈwɪndəʊ	window	9
53b3a771-6068-4301-8bfb-229e6833f892	2025-11-12 13:02:10.246805	2025-11-12 13:02:10.246825	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9382f817-d22a-4c3d-b7d8-88242b2e29db.mp3?alt=media	A1		[Shopping] She compared three chairs and chose the freshest one. | [Advice] Keep the chair away from fire to stay safe. | [Hobby] He collects photos of chairs from different countries.	\N	A seat for one person, typically with a back and four legs.	ghế	tʃeə	chair	9
e3adda41-0054-4342-bfaf-b0fa555b6c03	2025-11-12 13:02:10.29025	2025-11-12 13:02:10.290267	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa37f120c-5de5-41e8-b46f-2aac9e34185c.mp3?alt=media	A1	“Smartphone.jpg” by AndrixNet, source: https://commons.wikimedia.org/wiki/File:Smartphone.jpg, license: CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/).	[Shopping] She compared three phones and chose the freshest one. | [Advice] Keep the phone away from fire to stay safe. | [Hobby] He collects photos of phones from different countries.	\N	A device for making calls or sending messages.	điện thoại	fəʊn	phone	9
4af3eadc-fc22-47ea-8b9d-54586f3afa21	2025-11-12 13:02:10.301235	2025-11-12 13:02:10.301251	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdf63702d-a589-42fc-834b-a6f54949946e.mp3?alt=media	A1		[Story] A traveler found a computer near the old table. | [Work] The computer was recorded carefully in the report. | [Everyday] I put the computer on the table before dinner.	\N	An electronic device for storing and processing data.	máy tính	kəmˈpjuːtə	computer	9
5f98317b-df76-444b-924c-5db30ada0503	2025-11-12 13:02:10.311719	2025-11-12 13:02:10.311734	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa1b24b55-6c29-446d-a60b-a046d9f008b7.mp3?alt=media	A1		[Hobby] He collects photos of televisions from different countries. | [Shopping] She compared three televisions and chose the freshest one. | [Memory] This television reminds me of my childhood in the countryside.	\N	A device for receiving broadcast signals and displaying images and sound.	tivi	ˈtelɪvɪʒn	television	9
b53753a9-c99f-4ad4-92b7-869e5b2f9bef	2025-11-12 13:02:10.323591	2025-11-12 13:02:10.323605	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa548501e-e748-4e61-85e0-d49c54692a40.mp3?alt=media	A1		[Advice] Keep the village away from fire to stay safe. | [School] The teacher asked us to describe a village in two sentences. | [Shopping] She compared three villages and chose the freshest one.	\N	A small community in a rural area.	làng	ˈvɪlɪdʒ	village	10
eb523b41-fb1b-48d9-9aed-05dfc7760bc1	2025-11-12 13:02:10.346815	2025-11-12 13:02:10.346836	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4315b4a5-0dd3-4e29-b439-f5dec5e655cc.mp3?alt=media	A1	“City street.jpg” by Diliff, source: https://commons.wikimedia.org/wiki/File:City_street.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).	[Story] A traveler found a street near the old wall. | [Work] The street was recorded carefully in the report. | [Everyday] I put the street on the wall before dinner.	\N	A public road in a city or town.	đường phố	striːt	street	10
a09781ec-8520-4cda-9fc8-e254daf382de	2025-11-12 13:02:10.369772	2025-11-12 13:02:10.36979	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2b8f7663-454b-4089-b042-a33675adf5c0.mp3?alt=media	A1		[Hobby] He collects photos of banks from different countries. | [Shopping] She compared three banks and chose the freshest one. | [Memory] This bank reminds me of my childhood in the countryside.	\N	An institution for financial transactions.	ngân hàng	bæŋk	bank	10
a2cfdc7d-06d8-4785-a5d5-b9f851467795	2025-11-12 13:02:10.381808	2025-11-12 13:02:10.381826	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2b23f8ac-c1b7-4e13-9d37-2ba7b757bcf5.mp3?alt=media	A1		[Shopping] She compared three post offices and chose the freshest one. | [Advice] Keep the post office away from traffic to stay safe. | [Hobby] He collects photos of post offices from different countries.	\N	A place for postal services.	bưu điện	ˈpəʊst ˌɒfɪs	post office	10
830dde69-2c19-429a-bf42-9c0b7bf7a022	2025-11-12 13:02:10.394017	2025-11-12 13:02:10.394041	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F61c15be9-dcca-4576-804c-485a43d08f49.mp3?alt=media	A1		[Story] A traveler found a hospital near the old counter. | [Work] The hospital was recorded carefully in the report. | [Everyday] I put the hospital on the counter before dinner.	\N	A place for medical treatment.	bệnh viện	ˈhɒspɪtl	hospital	10
d3d30637-4e02-4b5b-aa05-5bea49dba687	2025-11-12 13:02:10.224306	2025-11-12 13:02:10.224321	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff48f6ca2-556e-4b6c-bab3-61c20ab1adf4.mp3?alt=media	A1		[Advice] Keep the room away from heat to stay safe. | [School] The teacher asked us to describe a room in two sentences. | [Shopping] She compared three rooms and chose the freshest one.	\N	A space within a building, enclosed by walls.	phòng	ruːm	room	9
e9d25433-c37b-4b50-8994-3504082c7d62	2025-11-12 12:10:11.84908	2025-11-12 12:10:11.849113	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3968a3fc-b0fc-4f06-a13e-69e2fadaa561.mp3?alt=media	A1	“Red car.jpg” by Spurzem, source: https://commons.wikimedia.org/wiki/File:Red_car.jpg, license: CC BY-SA 2.0 de (https://creativecommons.org/licenses/by-sa/2.0/de/deed.en).	[Hobby] He collects photos of cars from different countries. | [Shopping] She compared three cars and chose the freshest one. | [Memory] This car reminds me of my childhood in the countryside.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F8817752e-5486-41be-a170-6b1a0130ada9.jpeg?alt=media	A road vehicle powered by an engine, typically with four wheels.	xe hơi	kɑː	car	5
b48770f5-b418-444c-a865-44e49dbd600d	2025-11-12 13:02:10.494767	2025-11-12 13:02:10.494788	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4cf96f0b-5166-4ab5-85e4-309b552644f4.mp3?alt=media	B1		[Routine] I download along the river before the city wakes up. | [Event] They downloaded together during the school charity day. | [Weather] It's hard to download when the sun is very strong.	\N	To transfer data from a remote system to one's own computer.	tải xuống	ˌdaʊnˈləʊd	download	11
78c1ab2e-2888-42f4-851a-953f167a3ef0	2025-11-12 13:02:10.515206	2025-11-12 13:02:10.515231	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8ee3b216-6429-48cd-be61-4bee2ffac2f3.mp3?alt=media	A2		[Memory] This keyboard reminds me of my childhood in the countryside. | [Hobby] He collects photos of keyboards from different countries. | [Description] That keyboard looks modern in the afternoon light.	\N	A panel of keys that operate a computer or typewriter.	bàn phím	ˈkiːbɔːd	keyboard	11
eb7bbf42-e079-47e9-99e3-17f9f34b587e	2025-11-12 13:02:10.456067	2025-11-12 16:24:07.544206	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe13c6426-8296-4399-a6c8-dae030d4b31c.mp3?alt=media	B2		[Shopping] She compared three databases and chose the freshest one. | [Advice] Keep the database away from children to stay safe. | [Hobby] He collects photos of databases from different countries.	\N	An organized collection of data stored and accessed electronically.	cơ sở dữ liệu	ˈdeɪtəbeɪs	database	11
1472a0d6-cfe7-4146-948f-d5c56c6b3604	2025-11-12 13:02:10.475623	2025-11-12 13:02:10.475645	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9606beb5-cc40-4cbe-9aef-e09275dd3f34.mp3?alt=media	B1		[Health] Doctors say you should upload regularly to stay healthy. | [Weather] It's hard to upload when the sun is very strong. | [Tip] If you upload too fast at the start, you'll get tired quickly.	\N	To transfer data from one computer to another, typically to a server.	tải lên	ˈʌpləʊd	upload	11
aa92801f-c636-47df-918c-ad97852bb522	2025-11-12 12:10:13.012537	2025-11-12 12:10:13.012554	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9e70269a-45c5-438e-b992-199f56f0978d.mp3?alt=media	A1		[Story] A traveler found a happy near the old bench. | [Work] The happy was recorded carefully in the report. | [Everyday] I put the happy on the bench before dinner.	\N	Feeling or showing pleasure or contentment.	hạnh phúc	ˈhæpi	happy	12
154fb5c1-e8cf-4333-93d3-0fdc0d25c280	2025-11-12 13:02:10.612314	2025-11-12 13:02:10.612331	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F95e87cd4-7db8-4145-bc5b-0877439b421d.mp3?alt=media	A1		[Memory] This sad reminds me of my childhood in the countryside. | [Hobby] He collects photos of sads from different countries. | [Description] That sad looks modern in the afternoon light.	\N	Feeling or showing sorrow; unhappy.	buồn	sæd	sad	12
c0f1bab6-8c2a-4ca5-8180-12ad803ed38b	2025-11-12 13:02:10.634963	2025-11-12 13:02:10.634979	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F454d6c3d-a7fe-4f44-8693-65d1721b496d.mp3?alt=media	B1		[School] The teacher asked us to describe a proud in two sentences. | [Everyday] I put the proud on the doorway before dinner. | [Advice] Keep the proud away from fire to stay safe.	\N	Feeling deep pleasure or satisfaction due to one's achievements.	tự hào	praʊd	proud	12
b8f43757-e78c-4a75-8172-60c680417968	2025-11-12 13:02:10.646541	2025-11-12 13:02:10.646557	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F131d0e00-d8c6-4949-918f-347735620594.mp3?alt=media	B2		[Shopping] She compared three jealouses and chose the freshest one. | [Advice] Keep the jealous away from fire to stay safe. | [Hobby] He collects photos of jealouses from different countries.	\N	Feeling envious of someone else's achievements or advantages.	ghen tị	ˈdʒeləs	jealous	12
e1efbcad-65b6-477b-9c0f-8c9e33966f60	2025-11-12 13:02:10.65855	2025-11-12 13:02:10.658581	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2439bc3a-558b-4cc3-97da-5e791aa2f681.mp3?alt=media	B2		[Problem] The anxious broke suddenly, so we had to fix it. | [Description] That anxious looks safe in the afternoon light. | [Work] The anxious was recorded carefully in the report.	\N	Feeling nervous or uneasy about something uncertain.	lo lắng	ˈæŋkʃəs	anxious	12
328dd37d-a53e-4d0a-a2e2-7e3c04912444	2025-11-12 13:02:10.686738	2025-11-12 13:02:10.686757	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe2118567-571d-41e4-a921-dcb19b9693de.mp3?alt=media	B2		[School] The teacher asked us to describe a grateful in two sentences. | [Everyday] I put the grateful on the bag before dinner. | [Advice] Keep the grateful away from sunlight to stay safe.	\N	Feeling or showing appreciation for something received.	biết ơn	ˈɡreɪtfl	grateful	12
493b8402-9923-49a6-8562-3c1cca69f0e8	2025-11-12 13:02:10.698845	2025-11-12 13:02:10.698868	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd26513a4-c624-454f-95c0-3f1a5b4d13d4.mp3?alt=media	B1		[Problem] The lonely broke suddenly, so we had to fix it. | [Description] That lonely looks safe in the afternoon light. | [Work] The lonely was recorded carefully in the report.	\N	Feeling sad because one has no friends or company.	cô đơn	ˈləʊnli	lonely	12
bf97afe9-593a-4b97-860c-9566712ba88b	2025-11-12 13:02:10.889501	2025-11-12 13:02:10.889524	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7dab506e-786c-4e87-ad53-b41e06092c5b.mp3?alt=media	A2		[Tip] If you celebrate too fast at the start, you'll get tired quickly. | [Health] Doctors say you should celebrate regularly to stay healthy. | [Travel] We celebrateed through the old town and took photos.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F16b92e4c-011b-4a14-b268-f3f6edb803f4.jpg?alt=media	To acknowledge a significant or happy day or event with a social gathering.	tổ chức ăn mừng	ˈselɪbreɪt	celebrate	14
cd90b8c8-9181-4d03-849c-9a8ad0666f7c	2025-11-12 13:02:10.899627	2025-11-12 13:02:10.89965	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff661894f-5a4b-458f-87e5-83e817055961.mp3?alt=media	B2		[Description] That artwork looks heavy in the afternoon light. | [Memory] This artwork reminds me of my childhood in the countryside. | [Problem] The artwork broke suddenly, so we had to fix it.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Ff5df8469-4927-4e0b-a326-fb05d05ba317.jpg?alt=media	A work of art, such as a painting or sculpture.	tác phẩm nghệ thuật	ˈɑːtwɜːk	artwork	14
ab0804db-d953-4f97-8a04-c622cc0b9671	2025-11-12 13:02:10.585555	2025-11-12 16:24:07.544206	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6d1a9b8f-6f18-4f22-9ae7-fdbd4d42b441.mp3?alt=media	B2		[Work] The programming was recorded carefully in the report. | [Problem] The programming broke suddenly, so we had to fix it. | [Story] A traveler found a programming near the old desk.	\N	The process of writing computer programs.	lập trình	ˈprəʊɡræmɪŋ	programming	11
b5474bb0-a804-4f58-bf24-32dc728a5f52	2025-11-12 12:10:22.609996	2025-11-12 16:24:00.77967	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb3aa6809-52fc-4256-93b7-bac8f54519b6.mp3?alt=media	B1		[Education] Study classic literature. | [School] Read literature for class. | [Culture] Literature reflects society.	\N	Written works, especially those of artistic value.	văn học	ˈlɪtərətʃə	literature	51
763bbcde-95ca-4f07-8975-03a1e028aa71	2025-11-12 13:02:10.542838	2025-11-12 16:24:07.058875	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb4b67cbd-99d8-4314-8ccf-134e194893be.mp3?alt=media	B1		[Hobby] He collects photos of softwares from different countries. | [Shopping] She compared three softwares and chose the freshest one. | [Memory] This software reminds me of my childhood in the countryside.	\N	Programs and other operating information used by a computer.	phần mềm	ˈsɒftweə	software	11
71089e55-0f30-4564-a67c-8ec58011bb11	2025-11-12 13:02:10.734562	2025-11-12 13:02:10.734577	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1ad45136-5847-411d-92d0-d18064efbad8.mp3?alt=media	B1		[Travel] We recycleed through the old town and took photos. | [Tip] If you recycle too fast at the start, you'll get tired quickly. | [Goal] She plans to recycle farther than last week.	\N	To convert waste into reusable material.	tái chế	ˌriːˈsaɪkl	recycle	13
c56d4e00-b915-4794-8284-0a1189e6af99	2025-11-12 13:02:10.745356	2025-11-12 13:02:10.745372	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdd2d67cd-0f85-46b6-aee6-56fa96cac758.mp3?alt=media	B2		[Advice] Keep the sustainable away from heat to stay safe. | [School] The teacher asked us to describe a sustainable in two sentences. | [Shopping] She compared three sustainables and chose the freshest one.	\N	Able to be maintained at a certain rate or level.	bền vững	səˈsteɪnəbl	sustainable	13
65fc243f-8c65-405d-b212-0268d3595125	2025-11-12 12:10:12.073652	2025-11-12 12:10:12.073721	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F17387f81-8bcb-4583-8527-f64cacd54429.mp3?alt=media	A1		[Health] Doctors say you should run regularly to stay healthy. | [Weather] It's hard to run when the sun is very strong. | [Tip] If you run too fast at the start, you'll get tired quickly.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F55fdc13e-1131-4540-b43e-5d9b6a8bcd1b.jpg?alt=media	To move at a speed faster than a walk.	chạy	rʌn	run	6
e79577f2-1dc1-4055-97da-24530a547e93	2025-11-12 13:02:11.075965	2025-11-12 13:02:11.07598	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe54ac8a1-3203-4449-8b28-dc02332cda86.mp3?alt=media	C1		[Everyday] I put the thesis on the table before dinner. | [Story] A traveler found a thesis near the old table. | [School] The teacher asked us to describe a thesis in two sentences.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F519be1e3-9fcf-4ac2-9ebd-d93ccd2a20dd.png?alt=media	A statement or theory put forward to be maintained or proved.	luận văn	ˈθiːsɪs	thesis	16
a5d05e26-2999-4448-8794-3f52d952189b	2025-11-12 13:02:10.780894	2025-11-12 16:23:58.147158	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5bed3e93-f4b4-41bc-81ca-39e839cde164.mp3?alt=media	B2		[Problem] The renewable broke suddenly, so we had to fix it. | [Description] That renewable looks safe in the afternoon light. | [Work] The renewable was recorded carefully in the report.	\N	Able to be replenished naturally, like energy from sun or wind.	tái tạo (năng lượng)	rɪˈnjuːəbl	renewable	13
33999813-15a4-47ff-9352-ca34dc90b02c	2025-11-12 12:10:13.147169	2025-11-12 16:23:58.044908	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F394b8416-3a6a-4507-bef5-49c2e2509a81.mp3?alt=media	B1		[Work] The climate was recorded carefully in the report. | [Problem] The climate broke suddenly, so we had to fix it. | [Story] A traveler found a climate near the old doorway.	\N	The weather conditions prevailing in an area over a long period.	khí hậu	ˈklaɪmət	climate	13
b9dc59c0-5d8f-47ac-b980-4beba9364f06	2025-11-12 13:02:10.813004	2025-11-12 16:23:39.244294	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F86ca1329-1ef5-4b0c-93a1-46dc4a22caae.mp3?alt=media	B1		[Hobby] He collects photos of wastes from different countries. | [Shopping] She compared three wastes and chose the freshest one. | [Memory] This waste reminds me of my childhood in the countryside.	\N	Material that is not wanted; discarded or useless material.	rác thải	weɪst	waste	13
9797f5b7-d84d-44c1-b859-511994cd987c	2025-11-12 12:10:21.451295	2025-11-12 16:23:54.145349	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F17c36a74-d8a4-4d42-89e3-97e373c32bd5.mp3?alt=media	B1		[Science] Study chemistry in school. | [Research] Chemistry explores reactions. | [Career] Work in organic chemistry.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc5e18c57-6e34-4992-8f19-c6822f93f3c7.jpg?alt=media	The science of substances and their interactions.	hóa học	ˈkemɪstri	chemistry	43
34299ada-be55-47c7-9e5a-8aabb92c0bb1	2025-11-12 13:02:10.836146	2025-11-12 16:23:41.949195	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F821ced0e-acb3-4963-896d-1db69207477f.mp3?alt=media	B2		[Advice] Keep the ritual away from traffic to stay safe. | [School] The teacher asked us to describe a ritual in two sentences. | [Shopping] She compared three rituals and chose the freshest one.	\N	A religious or solemn ceremony consisting of a series of actions.	nghi lễ	ˈrɪtʃuəl	ritual	14
24cef67d-63d2-41c1-872b-de6f0c3f8d0c	2025-11-12 13:02:10.856165	2025-11-12 16:23:49.38969	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5302b330-458d-4ca6-9aaf-0e9fcbcc0f95.mp3?alt=media	B1		[Shopping] She compared three beliefs and chose the freshest one. | [Advice] Keep the belief away from water to stay safe. | [Hobby] He collects photos of beliefs from different countries.	\N	An acceptance that something exists or is true, especially without proof.	niềm tin	bɪˈliːf	belief	14
a0d13899-7e52-4a0b-813d-66969add8083	2025-11-12 12:10:13.309142	2025-11-12 16:23:49.913169	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F623d97a9-fe27-4716-8960-889b80e60872.mp3?alt=media	B1		[Everyday] I put the tradition on the doorway before dinner. | [Story] A traveler found a tradition near the old doorway. | [School] The teacher asked us to describe a tradition in two sentences.	\N	A belief or behavior passed down within a group or society.	truyền thống	trəˈdɪʃn	tradition	14
704182c9-645b-481e-9b05-f33dfcb80330	2025-11-12 13:02:10.791782	2025-11-12 16:23:57.779002	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1dd445af-cc72-48dc-900e-8d22e65dbf92.mp3?alt=media	C1		[Memory] This biodiversity reminds me of my childhood in the countryside. | [Hobby] He collects photos of biodiversities from different countries. | [Description] That biodiversity looks modern in the afternoon light.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fffafe50c-a6e3-4522-b269-2e7acada830a.jpg?alt=media	The variety of plant and animal life in a particular habitat.	đa dạng sinh học	ˌbaɪəʊdaɪˈvɜːsəti	biodiversity	13
0626856e-6775-4c16-9a2c-3433da8d4799	2025-11-12 13:02:10.769041	2025-11-12 16:23:57.975764	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe37de160-e6c6-4e92-94cc-d4363159e07e.mp3?alt=media	C1		[Description] That deforestation looks heavy in the afternoon light. | [Memory] This deforestation reminds me of my childhood in the countryside. | [Problem] The deforestation broke suddenly, so we had to fix it.	\N	The clearing of trees, transforming a forest into cleared land.	phá rừng	ˌdiːˌfɒrɪˈsteɪʃn	deforestation	13
50bc29cf-1544-479a-a1cd-45e4daffea16	2025-11-12 13:02:11.025883	2025-11-12 13:02:11.025924	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa9a50550-1ed4-4cc3-8101-9b0c64bf4ea0.mp3?alt=media	B2		[School] The teacher asked us to describe a tuition in two sentences. | [Everyday] I put the tuition on the doorway before dinner. | [Advice] Keep the tuition away from sunlight to stay safe.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F3b472003-8774-4e4f-92e9-3ea6ea504252.png?alt=media	The fee for instruction, especially at a college or university.	học phí	tjuˈɪʃn	tuition	16
27e6d57f-7435-453e-9947-1771bc0d7e93	2025-11-12 13:02:11.006073	2025-11-12 13:02:11.006086	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F88b324f0-fa13-4279-a2f8-4e296214c601.mp3?alt=media	B2		[Advice] Keep the discipline away from noise to stay safe. | [School] The teacher asked us to describe a discipline in two sentences. | [Shopping] She compared three disciplines and chose the freshest one.	\N	The practice of training people to obey rules or a code of behavior.	kỷ luật; môn học	ˈdɪsɪplɪn	discipline	16
c730b0e8-d96c-4bfa-9f85-64b3783cb38b	2025-11-12 13:02:11.045724	2025-11-12 13:02:11.045741	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fff037e13-22d0-4cb9-b9b5-eab838b15277.mp3?alt=media	B2		[Story] A traveler found a academic near the old wall. | [Work] The academic was recorded carefully in the report. | [Everyday] I put the academic on the wall before dinner.	\N	Relating to education and scholarship.	học thuật	ˌækəˈdemɪk	academic	16
109bb267-fdeb-4a66-930f-e964c7b6407f	2025-11-12 13:02:10.148917	2025-11-12 13:02:10.14895	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F607e9798-758e-4857-b8c0-18753e51ae70.mp3?alt=media	A1		[Everyday] I put the tree on the window before dinner. | [Story] A traveler found a tree near the old window. | [School] The teacher asked us to describe a tree in two sentences.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fe7825385-0432-4889-ae6a-c5cfc5b476e7.jpg?alt=media	A perennial plant with a trunk and branches, producing leaves.	cây	triː	tree	8
66e65231-9d57-47e1-99db-65d3ecfad2d3	2025-11-12 13:02:11.10711	2025-11-12 13:02:11.107126	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc4695140-8507-49d5-a4d5-9dca701bfdbc.mp3?alt=media	B1		[Shopping] She compared three lawyers and chose the freshest one. | [Advice] Keep the lawyer away from traffic to stay safe. | [Hobby] He collects photos of lawyers from different countries.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F01601cc6-9689-48e9-8090-ae30c2dbca21.jpg?alt=media	A person who practices or studies law.	luật sư	ˈlɔːjə	lawyer	17
a00c85b2-4b86-4390-b4b3-eca8694891f5	2025-11-12 13:02:13.826822	2025-11-12 13:02:13.826827	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fca5a641b-3e1f-48cf-aee8-ab6ce3140167.mp3?alt=media	A1		[Kitchen] Cook on the stove. | [Appliance] Turn on the stove. | [Gas] Use a gas stove.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Ff8646333-d771-458c-bc91-97a2d581fecb.jpg?alt=media	An appliance used for cooking food, typically with burners.	bếp	stəʊv	stove	9
f6c56139-fbc4-46ce-b40f-1825fe644b9f	2025-11-12 13:02:11.138088	2025-11-12 13:02:11.138114	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F279ea8dd-71cd-450a-aadc-f20c43fae705.mp3?alt=media	B2		[Story] A traveler found a policy near the old shelf. | [Work] The policy was recorded carefully in the report. | [Everyday] I put the policy on the shelf before dinner.	\N	A course or principle of action adopted by a government or organization.	chính sách	ˈpɒləsi	policy	17
a54b0212-bbde-4068-8f0b-7a41439871cd	2025-11-12 13:02:11.147797	2025-11-12 13:02:11.147815	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8bbcad6f-c64f-4cca-b34c-d4046f0fac00.mp3?alt=media	A2		[Story] A traveler found a government near the old bench. | [Work] The government was recorded carefully in the report. | [Everyday] I put the government on the bench before dinner.	\N	The governing body of a nation, state, or community.	chính phủ	ˈɡʌvənmənt	government	17
41ec88f0-2367-4f65-b7d6-b61ab19ac7a0	2025-11-12 13:02:11.615564	2025-11-12 13:02:11.615578	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff871c888-39c9-4d9e-af12-6ad4b3d4ccdc.mp3?alt=media	A1		[Study] She wrote her ideas in a notebook during the lecture. | [Organization] The notebook was filled with to-do lists for the week. | [Travel] He carried a small notebook to sketch landscapes on his trip.	\N	A book with blank pages for recording notes.	sổ tay	ˈnəʊtbʊk	notebook	3
5072a8fa-ec88-4ddc-9067-05ffc00f2a2e	2025-11-12 13:02:10.995492	2025-11-12 16:24:00.253047	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2e0db598-64b8-420e-ab2c-1641d9155904.mp3?alt=media	B2		[Story] A traveler found a curriculum near the old bench. | [Work] The curriculum was recorded carefully in the report. | [Everyday] I put the curriculum on the bench before dinner.	\N	The subjects comprising a course of study in a school or college.	chương trình học	kəˈrɪkjələm	curriculum	16
eb423b79-43fd-4b13-8562-29762adb5b62	2025-11-12 12:10:21.216876	2025-11-12 16:23:52.739846	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff760cd77-9c01-4cc7-89c8-a0c87776822e.mp3?alt=media	B1		[Science] Study biology in school. | [Research] Biology explores life. | [Career] Work in marine biology.	\N	The study of living organisms and their processes.	sinh học	baɪˈɒlədʒi	biology	41
a4de8321-acbc-497d-91d4-604c59179cfd	2025-11-12 13:02:11.066521	2025-11-12 16:24:00.411259	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe015e8f3-e3ea-4c4c-a381-63e7fa5d17e7.mp3?alt=media	B2		[Story] A traveler found a lecture near the old counter. | [Work] The lecture was recorded carefully in the report. | [Everyday] I put the lecture on the counter before dinner.	\N	An educational talk to an audience, especially students.	bài giảng	ˈlektʃə	lecture	16
1cce1ea5-443b-4b06-a56d-bd3fb820e5b8	2025-11-12 13:02:10.984388	2025-11-12 16:24:00.690503	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F90553aae-23a9-4198-873e-4e998aebf23c.mp3?alt=media	B2		[Problem] The research broke suddenly, so we had to fix it. | [Description] That research looks safe in the afternoon light. | [Work] The research was recorded carefully in the report.	\N	The systematic investigation into materials or sources to establish facts.	nghiên cứu	rɪˈsɜːtʃ	research	15
1ea36371-2054-4874-be8b-cc2290d27679	2025-11-12 13:02:10.973035	2025-11-12 16:24:08.308353	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F28fde700-5f9f-4e5a-ad51-21b23e04b5fc.mp3?alt=media	B2		[Memory] This innovation reminds me of my childhood in the countryside. | [Hobby] He collects photos of innovations from different countries. | [Description] That innovation looks modern in the afternoon light.	\N	The introduction of new ideas, methods, or products.	sự đổi mới	ˌɪnəˈveɪʃn	innovation	15
f3baffb6-30f9-4702-aa0a-ecdb4f9e1c99	2025-11-12 13:02:11.165988	2025-11-12 13:02:11.166005	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe6793065-40ce-4e56-9cdb-f846ba797019.mp3?alt=media	B2		[Memory] This democracy reminds me of my childhood in the countryside. | [Hobby] He collects photos of democracies from different countries. | [Description] That democracy looks modern in the afternoon light.	\N	A system of government by the whole population, typically through elected representatives.	dân chủ	dɪˈmɒkrəsi	democracy	17
aa2ae4a7-75c4-40a7-8a84-d7d0a7da2614	2025-11-12 13:02:11.195951	2025-11-12 13:02:11.195964	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdb129998-af11-4b37-8258-77de6f0b36f9.mp3?alt=media	A2		[Hobby] He collects photos of customers from different countries. | [Shopping] She compared three customers and chose the freshest one. | [Memory] This customer reminds me of my childhood in the countryside.	\N	A person who buys goods or services from a shop or business.	khách hàng	ˈkʌstəmə	customer	18
c9d964c2-e2b0-415f-bb99-cd3eb504cfbc	2025-11-12 13:02:11.225216	2025-11-12 13:02:11.225232	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F608d3335-3425-4c63-89a6-bd6f4acac37a.mp3?alt=media	B2		[Hobby] He collects photos of enterprises from different countries. | [Shopping] She compared three enterprises and chose the freshest one. | [Memory] This enterprise reminds me of my childhood in the countryside.	\N	A business or company, especially one involving initiative.	doanh nghiệp	ˈentəpraɪz	enterprise	18
6ae04002-9525-4ecc-addb-382ce6f43498	2025-11-12 13:02:11.2349	2025-11-12 13:02:11.234914	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F605d5bea-f0ea-4fbc-89b8-750486b17cba.mp3?alt=media	B2		[Memory] This shareholder reminds me of my childhood in the countryside. | [Hobby] He collects photos of shareholders from different countries. | [Description] That shareholder looks modern in the afternoon light.	\N	A person who owns shares in a company.	cổ đông	ˈʃeəhəʊldə	shareholder	18
70e4025a-d1ec-499f-8542-a46d3fff9e15	2025-11-12 13:02:11.255011	2025-11-12 13:02:11.255026	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5a0daa53-7601-489e-bca1-ba3cf44b966e.mp3?alt=media	A2		[Problem] The poem broke suddenly, so we had to fix it. | [Description] That poem looks safe in the afternoon light. | [Work] The poem was recorded carefully in the report.	\N	A piece of writing in which the expression of feelings is arranged in verse.	bài thơ	ˈpəʊɪm	poem	19
c3df60dd-0e74-4560-b5cc-684a6344bb67	2025-11-12 13:02:13.043397	2025-11-12 13:02:13.043413	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6a282e97-5c9e-47c2-a1c5-c374d93fd7f7.mp3?alt=media	C1		[Literature] Read an anthology of poems. | [Collection] Publish an anthology of stories. | [Book] The anthology features various authors.	\N	A published collection of poems or other pieces of writing.	tuyển tập	ænˈθɒlədʒi	anthology	19
fb7d6528-85f5-4a07-b670-94b1edce84fb	2025-11-12 13:02:10.016415	2025-11-12 13:02:10.016454	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd9775895-aac9-40b9-8f32-bb111f293bb6.mp3?alt=media	A1	“Goat portrait.jpg” by Muhammad Mahdi Karim, source: https://commons.wikimedia.org/wiki/File:Goat_portrait.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).	[Everyday] I put the sheep on the doorway before dinner. | [Story] A traveler found a sheep near the old doorway. | [School] The teacher asked us to describe a sheep in two sentences.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F6374c37a-f9b7-40c5-b6a7-17784259868f.jpg?alt=media	A domesticated ruminant mammal with thick woolly fleece.	cừu	ʃiːp	sheep	7
851d42da-cd26-45b4-9e86-400271288115	2025-11-12 13:02:11.3469	2025-11-12 13:02:11.346915	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F00664374-839f-4933-8f99-35e3ee91e006.mp3?alt=media	B2		[Problem] The viral broke suddenly, so we had to fix it. | [Description] That viral looks safe in the afternoon light. | [Work] The viral was recorded carefully in the report.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F0b664ed9-e689-427f-a285-542dd52e490c.png?alt=media	Relating to content that spreads rapidly through social media.	lan truyền nhanh	ˈvaɪrəl	viral	20
566c920a-e6db-4f65-841c-8dddefa0e0ac	2025-11-12 12:10:19.471515	2025-11-12 16:24:09.100003	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd494c961-08d9-4091-8368-286a21a806b1.mp3?alt=media	B1		[Business] Develop a marketing strategy. | [Plan] Implement a new strategy. | [Success] Strategy drives growth.	\N	A plan to achieve a long-term goal.	chiến lược	ˈstrætədʒi	strategy	29
b119ac71-74c0-47d1-ba19-bc8900ee5afd	2025-11-12 13:02:11.291983	2025-11-12 16:24:00.978548	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2631c9e3-a4ba-4262-8c5b-e9b6561a9cdd.mp3?alt=media	B1		[Story] A traveler found a author near the old counter. | [Work] The author was recorded carefully in the report. | [Everyday] I put the author on the counter before dinner.	\N	A writer of a book, article, or document.	tác giả	ˈɔːθə	author	19
3798374d-da4b-4887-b577-a11dc08e6289	2025-11-12 13:02:11.405045	2025-11-12 16:24:07.463419	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F094112bf-904d-4871-9406-a08188618aeb.mp3?alt=media	B2		[School] The teacher asked us to describe a network in two sentences. | [Everyday] I put the network on the desk before dinner. | [Advice] Keep the network away from heat to stay safe.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F4e7b68e2-63b9-45cf-a93d-af47bd6925da.JPG?alt=media	A group of interconnected people or systems, especially in social media.	mạng lưới	ˈnetwɜːk	network	20
2fea9967-8549-4573-a32f-9bccfb95f9c2	2025-11-12 12:10:13.795835	2025-11-12 16:24:08.611617	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fcb3813ec-da99-458b-94f4-2808697dc3a2.mp3?alt=media	B1		[Memory] This profit reminds me of my childhood in the countryside. | [Hobby] He collects photos of profits from different countries. | [Description] That profit looks modern in the afternoon light.	\N	A financial gain, especially the difference between revenue and costs.	lợi nhuận	ˈprɒfɪt	profit	18
938273da-9b46-40b8-84af-6ead421430de	2025-11-12 13:02:11.186442	2025-11-12 16:24:08.640329	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8d5583a3-a9e7-460d-94bf-9e8ac0a2606e.mp3?alt=media	A2		[Work] The market was recorded carefully in the report. | [Problem] The market broke suddenly, so we had to fix it. | [Story] A traveler found a market near the old bag.	\N	A place where goods are bought and sold, or the demand for goods.	thị trường	ˈmɑːkɪt	market	18
42f6c12e-b091-44a2-b3ae-b86edf60eb4b	2025-11-12 13:02:11.338131	2025-11-12 13:02:11.338153	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff702117d-c088-4b09-a676-3cbc09052b79.mp3?alt=media	B1		[Work] The hashtag was recorded carefully in the report. | [Problem] The hashtag broke suddenly, so we had to fix it. | [Story] A traveler found a hashtag near the old table.	\N	A word or phrase preceded by a hash sign (#) used to identify messages on a topic.	dấu hashtag	ˈhæʃtæɡ	hashtag	20
b5f229c5-5a61-4c96-b432-d127e9b1090d	2025-11-12 13:02:11.366866	2025-11-12 13:02:11.366879	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F92f74f5e-07b2-4b29-a2dc-e5cca0014f7e.mp3?alt=media	B2		[Everyday] I put the influence on the bag before dinner. | [Story] A traveler found a influence near the old bag. | [School] The teacher asked us to describe a influence in two sentences.	\N	The capacity to have an effect on someone or something.	ảnh hưởng	ˈɪnfluəns	influence	20
2ae4233b-7a93-42d3-a928-83baf5f654d1	2025-11-12 13:02:11.386327	2025-11-12 13:02:11.386341	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fcc1ae220-9e0d-49f0-a0d7-6cd9d4f46bc3.mp3?alt=media	B1		[Story] A traveler found a follower near the old table. | [Work] The follower was recorded carefully in the report. | [Everyday] I put the follower on the table before dinner.	\N	A person who supports or subscribes to anotherâ€™s updates, especially on social media.	người theo dõi	ˈfɒləʊə	follower	20
7dbc5f81-4e96-48f7-8a71-2c953387e0b4	2025-11-12 13:02:11.42564	2025-11-12 13:02:11.425656	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F164da034-baf3-42c2-9e24-6af83157528f.mp3?alt=media	A1		[Picnic] Pack some cheese and crackers for a simple outdoor snack. | [Cooking] Grate the cheese over pasta to add a creamy flavor. | [Diet] He avoided cheese to reduce his dairy intake for better health.	\N	A food made from the pressed curds of milk.	phô mai	tʃiːz	cheese	1
6e48003f-c4c4-4e6c-9ded-b954bc7a66eb	2025-11-12 13:02:11.445461	2025-11-12 13:02:11.445474	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F66fb90ea-40a8-4671-83fe-ad83784485d1.mp3?alt=media	A1		[Relaxation] Sip hot tea while reading a book on a rainy afternoon. | [Culture] In Japan, the tea ceremony is a traditional art form. | [Health] Drinking green tea daily can boost your immune system.	\N	A hot drink made by infusing dried leaves in boiling water.	trà	tiː	tea	1
b69cbc79-58e8-4100-9d28-074c3a844169	2025-11-12 13:02:11.356133	2025-11-12 13:02:11.356146	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5ba27c18-23ef-48ef-ac33-de571c70e811.mp3?alt=media	B2		[Work] The platform was recorded carefully in the report. | [Problem] The platform broke suddenly, so we had to fix it. | [Story] A traveler found a platform near the old wall.	\N	A digital service or system that facilitates interactions or content sharing.	nền tảng	ˈplætfɔːm	platform	20
ec8a3377-08ea-4690-aa93-e6202e891dfc	2025-11-12 13:02:11.525262	2025-11-12 13:02:11.525278	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Feccd311a-e7f5-476c-a254-571ba761160c.mp3?alt=media	A1		[Cooking] Grandmother shared her secret recipe for homemade jam. | [Tradition] Every Sunday, grandmother knits blankets for the family. | [Visit] We spent the afternoon with grandmother, playing board games.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc62bec74-48c5-4b7f-a2b3-a5e3494e6a19.jpg?alt=media	The mother of a parent.	bà	ˈɡrændˌmʌðə	grandmother	2
f0769317-4202-4471-a47c-53865c348391	2025-11-12 13:02:11.535365	2025-11-12 13:02:11.535378	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6d6c8249-6877-472e-af31-122dde22a487.mp3?alt=media	A1		[Reunion] My cousin and I caught up at the family gathering. | [Travel] We went hiking with my cousin during the summer vacation. | [School] My cousin helped me with math homework last night.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F6db17487-30af-4a3e-a1c6-20972928f7aa.jpg?alt=media	A child of oneâ€™s aunt or uncle.	anh/chị/em họ	ˈkʌzn	cousin	2
39a08be2-8047-4040-8a7c-1c539dcf3385	2025-11-12 13:02:11.484631	2025-11-12 13:02:11.484646	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F043a7629-4f3e-4502-ae9a-e56684d57d2e.mp3?alt=media	A1		[Cooking] A pinch of salt enhances the flavor of the soup. | [Preservation] Salt was used to preserve fish in ancient times. | [Health] Doctors advised reducing salt to control blood pressure.	\N	A white crystalline substance used to season food.	muối	sɔːlt	salt	1
2bfeee07-3877-4ed6-b496-088e102a38bd	2025-11-12 13:02:11.494666	2025-11-12 13:02:11.49468	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff00e04d8-2895-4f10-9d1f-38ffbf06191e.mp3?alt=media	A1		[Breakfast] Spread honey on toast for a sweet morning treat. | [Health] Honey with lemon is a natural remedy for sore throats. | [Market] The farmer sold pure honey from his beehives.	\N	A sweet, sticky substance made by bees from nectar.	mật ong	ˈhʌni	honey	1
b6a00cbf-39d2-47c7-bd84-44841cd61619	2025-11-12 13:02:11.554347	2025-11-12 13:02:11.554361	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F077bb627-3925-43a2-a493-0ef38194954b.mp3?alt=media	A1		[Community] The neighbor lent us tools to fix the garden fence. | [Daily Life] I chat with my neighbor every morning while walking the dog. | [Help] Our neighbor offered to babysit during the emergency.	\N	A person living near or next door.	hàng xóm	ˈneɪbə	neighbor	2
b5b80670-d815-491e-adb2-8e39e8b30b21	2025-11-12 13:02:11.563422	2025-11-12 13:02:11.563436	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0d39b730-5bbe-47b5-8fd8-dc363405f932.mp3?alt=media	A1		[Family] Uncle brought gifts from his trip abroad last week. | [Story] My uncle shared tales of his adventures as a sailor. | [Celebration] We invited uncle to join us for the holiday dinner.	\N	The brother of oneâ€™s parent.	chú/bác	ˈʌŋkl	uncle	2
8caee82a-40cb-4232-89db-f586d7daf1ff	2025-11-12 13:02:11.581757	2025-11-12 13:02:11.581775	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F23e50771-5522-4aec-9489-2c921d7715df.mp3?alt=media	A2		[Business] She met her partner to discuss the new project proposal. | [Dance] My partner and I practiced salsa for the competition. | [Life] He introduced his partner to the family at the reunion.	\N	A person who shares in an activity or business, or a significant other.	đối tác; bạn đời	ˈpɑːrtnə	partner	2
623d3f10-6178-4761-b3d7-c9a2b6cf8e4e	2025-11-12 13:02:11.590689	2025-11-12 13:02:11.590706	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3f8ad8e9-6a49-49a1-879a-6f1e762688f6.mp3?alt=media	A2		[Work] My colleague shared ideas for improving our presentation. | [Meeting] We had lunch with a colleague to discuss the project timeline. | [Team] The colleague offered to cover my shift during the holiday.	\N	A person with whom one works in a profession or business.	đồng nghiệp	ˈkɒliːɡ	colleague	2
f0086b87-8b1b-4cbf-897d-30dfdf1c8bde	2025-11-12 13:02:11.642002	2025-11-12 13:02:11.64202	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe90cb03b-e950-469a-bd4f-fd5b90287ebf.mp3?alt=media	A1		[Teaching] The board was covered with notes from the history lesson. | [Meeting] She wrote the agenda on the board for the team. | [Class] Students took turns solving problems on the board.	\N	A flat surface used for writing or displaying information, often in classrooms.	bảng	bɔːrd	board	3
b52383c8-31ce-43e9-80bf-dfb830b03108	2025-11-12 13:02:11.624222	2025-11-12 13:02:11.624237	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff839664c-a9d3-44c1-88de-4418a457b38a.mp3?alt=media	A1		[Office] The desk was cluttered with papers and coffee cups. | [School] She sat at her desk, focused on solving math problems. | [Home] We bought a new desk for the study room renovation.	\N	A piece of furniture with a flat surface for writing or working.	bàn học/làm việc	desk	desk	3
ec398494-9000-479e-8de4-5a081c70735c	2025-11-12 13:02:11.607051	2025-11-12 13:02:11.607064	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7b530be6-1c85-4d0f-bdc3-bd0453748cee.mp3?alt=media	A1		[Class] The teacher explained the math problem clearly to the students. | [Mentor] My teacher encouraged me to pursue my passion for art. | [Event] The teacher led the school choir at the annual concert.	\N	A person who teaches, especially in a school.	giáo viên	ˈtiːtʃə	teacher	3
e39b2c01-6842-41ed-bc64-9c4502989898	2025-11-12 13:02:11.650539	2025-11-12 13:02:11.650558	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Faf1c4e68-ecb7-43e7-b930-cb28eeefca21.mp3?alt=media	A2		[School] The group worked on a science project about renewable energy. | [Work] The project required months of planning and research. | [Community] The city launched a project to improve public parks.	\N	A planned piece of work with a specific purpose.	dự án	ˈprɒdʒekt	project	3
3ba29603-21f6-44f3-bee3-79b944a405d2	2025-11-12 13:02:10.947515	2025-11-12 13:02:10.947537	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffafc688b-dfdb-4ee5-85a2-6285fe2282de.mp3?alt=media	B1		[Problem] The laboratory broke suddenly, so we had to fix it. | [Description] That laboratory looks safe in the afternoon light. | [Work] The laboratory was recorded carefully in the report.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fb9880d71-3896-40e8-b9a7-860f5374829e.jpg?alt=media	A room or building equipped for scientific experiments or research.	phòng thí nghiệm	ləˈbɒrətri	laboratory	15
96ac9f6c-62eb-4600-ab32-d3cb2ea90531	2025-11-12 13:02:11.689141	2025-11-12 13:02:11.689162	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F85da4fda-3a61-441c-bd16-7ad02e85bc4b.mp3?alt=media	A2		[Work] The employee received a promotion after years of hard work. | [Team] She collaborated with employees from different departments. | [Training] The new employee attended a workshop to learn company policies.	\N	A person employed for wages or salary.	nhân viên	ɪmˈplɔɪi	employee	4
80b1bc66-66fa-4a8b-8025-f299a4ec0c46	2025-11-12 13:02:11.715643	2025-11-12 13:02:11.715657	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fcfc53758-b164-4527-8673-a49ab0485ff9.mp3?alt=media	A2		[Finance] His salary increased after the company’s successful year. | [Negotiation] She discussed her salary expectations during the interview. | [Budget] Most of his salary goes toward rent and bills.	\N	A fixed regular payment for work, typically paid monthly.	lương	ˈsæləri	salary	4
163cf3bb-b4fa-43a3-a750-44d314275498	2025-11-12 13:02:11.724106	2025-11-12 13:02:11.72412	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F321dad38-246b-4473-af32-8a64eb273771.mp3?alt=media	A2		[Goal] She planned her career to become a software engineer. | [Advice] He sought a mentor to guide his career choices. | [Change] After years in sales, she switched to a teaching career.	\N	An occupation undertaken for a significant period of a personâ€™s life.	sự nghiệp	kəˈrɪə	career	4
27cb45a2-4418-4371-b0d3-03ce029b189e	2025-11-12 13:02:11.697739	2025-11-12 13:02:11.697783	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5468dd0f-e671-4dd5-8360-46fac77de467.mp3?alt=media	A2		[Work] The meeting was scheduled to discuss the annual budget. | [Virtual] We joined the meeting via video call from home. | [Planning] She prepared slides for the team meeting tomorrow.	\N	A gathering of people for discussion or decision-making.	cuộc họp	ˈmiːtɪŋ	meeting	4
0c0fa3c5-13ce-419e-9005-2f0afed24592	2025-11-12 13:02:11.747765	2025-11-12 13:02:11.747779	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8f5fa639-5d21-4d9e-ba6d-9b7b24b3ed5f.mp3?alt=media	B1		[Career] Teaching is a rewarding profession for those who love learning. | [Choice] He chose a profession in architecture after university. | [Respect] Her profession as a doctor earned her great admiration.	\N	A paid occupation, especially one requiring advanced education.	nghề nghiệp	prəˈfeʃn	profession	4
f2da4c5d-39f0-4786-90f0-b35a4e50f706	2025-11-12 13:02:11.756059	2025-11-12 13:02:11.756072	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3542eaf0-8772-4c13-aa74-7169fb38c4e8.mp3?alt=media	B1		[Environment] The workplace was designed to encourage creativity. | [Safety] New rules were introduced to keep the workplace safe. | [Team] She enjoyed the friendly atmosphere at her workplace.	\N	The place where people work, such as an office or factory.	nơi làm việc	ˈwɜːkpleɪs	workplace	4
c74b4f02-e7b1-4aee-a0d9-9662f221cc3e	2025-11-12 13:02:11.775823	2025-11-12 13:02:11.775842	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb307fcc5-503c-4e34-ba81-354962394290.mp3?alt=media	A1		[Exercise] Riding a bicycle to work keeps her fit and healthy. | [Travel] We explored the city on bicycles during the weekend. | [Environment] Using a bicycle reduces your carbon footprint.	\N	A vehicle with two wheels powered by pedals.	xe đạp	ˈbaɪsɪkl	bicycle	5
0f7015dc-fba1-4553-a7d5-6a296550af25	2025-11-12 13:02:11.786315	2025-11-12 13:02:11.786333	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9bd12c24-4fbf-4d6c-8128-1b752305d9a8.mp3?alt=media	A1		[Adventure] They sailed a boat across the lake on a sunny day. | [Fishing] The fisherman used a small boat for his daily catch. | [Vacation] Renting a boat was the highlight of our coastal trip.	\N	A small vessel for traveling over water.	thuyền	bəʊt	boat	5
2ea5ddb6-e0a4-428e-bf68-4dffe96f1ad2	2025-11-12 13:02:11.825897	2025-11-12 13:02:11.825913	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F73e70866-ae2e-464c-a387-2479c61a4921.mp3?alt=media	A1		[Travel] The road to the village was lined with tall trees. | [Construction] Workers repaired the road after the heavy rain. | [Adventure] We took a scenic road trip through the mountains.	\N	A wide way leading from one place to another, especially for vehicles.	đường	rəʊd	road	5
5f433de4-8057-4c12-9033-85e68e54ba41	2025-11-12 13:02:12.027937	2025-11-12 13:02:12.027952	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F31b6d7da-4d59-4d7e-923f-be2779f425cd.mp3?alt=media	A1		[Wildlife] The bear was fishing for salmon in the river. | [Story] The children’s book featured a friendly bear as the hero. | [Camping] We stored food securely to avoid attracting bears.	\N	A large, heavy mammal with thick fur, often found in forests.	gấu	beə	bear	7
23193be4-66b5-493b-8533-271c4b99a3fc	2025-11-12 13:02:11.865471	2025-11-12 13:02:11.865492	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6bc31be6-78fe-49be-ad5f-2123ec4ad320.mp3?alt=media	A2		[Adventure] The journey through the desert was unforgettable. | [Life] Her journey to becoming a doctor was full of challenges. | [Travel] We planned a long journey across Europe by train.	\N	The act of traveling from one place to another.	hành trình	ˈdʒɜːni	journey	5
b82c614e-0457-4514-8c86-1003eab624b9	2025-11-12 13:02:11.876479	2025-11-12 13:02:11.876495	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F959de72b-4b53-47ba-b5e2-94ef691c2d55.mp3?alt=media	A1		[Health] Doctors recommend a daily walk to stay active. | [City] We took a walk through the park to enjoy the flowers. | [Relaxation] A morning walk by the beach is so refreshing.	\N	To move at a regular pace by lifting and setting down each foot in turn.	đi bộ	wɔːk	walk	6
50dc838b-283a-416a-8453-c31a922c8caf	2025-11-12 13:02:12.018372	2025-11-12 13:02:12.018392	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff600e7e3-a07d-4f84-a6cf-87b6b988a2e6.mp3?alt=media	A1		[Zoo] The monkey swung from branch to branch playfully. | [Nature] Monkeys are known for their intelligence and social behavior. | [Travel] We spotted monkeys while hiking in the forest.	\N	A small to medium-sized primate that typically lives in trees.	con khỉ	ˈmʌŋki	monkey	7
61dc91f4-b189-4ec5-b85e-d915b27b581a	2025-11-12 13:02:11.915101	2025-11-12 13:02:11.915116	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff1f6642a-f887-4f3b-842c-b4f9f674553f.mp3?alt=media	A2		[Goal] She worked on her fitness to prepare for the hike. | [Gym] The fitness center offered new classes for all levels. | [Lifestyle] Fitness is important for a balanced and healthy life.	\N	The condition of being physically fit and healthy.	sức khỏe; thể dục	ˈfɪtnəs	fitness	6
6f5552fd-ee21-4b7c-8306-7773b59289e6	2025-11-12 13:02:11.967231	2025-11-12 13:02:11.967247	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F480130a7-f6f6-4aad-84aa-62b4d180f247.mp3?alt=media	A2		[Gym] The trainer designed a workout plan for beginners. | [Sport] The football trainer motivated the team before the match. | [Support] She hired a personal trainer to improve her fitness.	\N	A person who trains people or animals.	huấn luyện viên	ˈtreɪnə	trainer	6
0a0d1074-c593-44bc-b2f4-e10681233acd	2025-11-12 13:02:11.997437	2025-11-12 13:02:11.99745	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F438653f6-d34a-45f2-9d07-0c1831d79e6a.mp3?alt=media	A1		[Safari] We saw an elephant herd during our trip to Africa. | [Culture] In some countries, elephants are symbols of wisdom. | [Conservation] Efforts to save elephants focus on stopping poaching.	\N	A large herbivorous mammal with a trunk and tusks.	con voi	ˈelɪfənt	elephant	7
f3577519-3693-43af-8453-350b4cd2b1ec	2025-11-12 13:02:12.068105	2025-11-12 13:02:12.068119	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbd5b11c6-7629-4dc4-a438-3b475d951763.mp3?alt=media	A1		[Forest] A deer grazed peacefully in the meadow at sunrise. | [Hunting] Hunters are regulated to protect the deer population. | [Symbol] The deer is often seen as a symbol of grace and gentleness.	\N	A hoofed mammal with antlers (in males), found in forests.	nai	dɪə	deer	7
7fd19eea-0fd7-4d51-9cf9-27cd2d7dfbfa	2025-11-12 13:02:11.81602	2025-11-12 16:23:43.543472	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4c3fd4b3-a9e7-4ac0-ab39-4e71bd1b8c08.mp3?alt=media	A2		[City] Heavy traffic delayed our trip to the museum. | [Safety] Always check traffic before crossing the street. | [Morning] She left early to avoid rush-hour traffic.	\N	Vehicles moving on a road or public highway.	giao thông	ˈtræfɪk	traffic	5
8b6e2bc1-b225-4c87-8fbc-9a8c60723dc3	2025-11-12 13:02:11.796716	2025-11-12 16:23:43.603145	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff4298888-dd68-44f8-b5ff-18c0b284bf6f.mp3?alt=media	A2		[Commute] She takes the subway to work to avoid traffic. | [City] The subway system in Tokyo is incredibly efficient. | [Travel] We used the subway to visit famous landmarks in the city.	\N	An underground railway system in a city.	tàu điện ngầm	ˈsʌbweɪ	subway	5
50fb0c06-8c18-49df-8ad9-89c999d76e6d	2025-11-12 13:02:11.854888	2025-11-12 16:23:43.946539	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff47bb676-5f24-4775-b854-05b7f961802c.mp3?alt=media	A2		[Airport] He lost his luggage during the connecting flight. | [Packing] She packed light luggage for the weekend getaway. | [Travel] The hotel staff helped carry our luggage to the room.	\N	Bags and suitcases a person carries when traveling.	hành lý	ˈlʌɡɪdʒ	luggage	5
7aeb308d-af14-4145-ba7e-7a636162c5db	2025-11-12 13:02:11.94665	2025-11-12 16:23:44.63819	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7fe654f0-1726-4989-8973-55bf427f4698.mp3?alt=media	A2		[Competition] The athlete won a gold medal in the marathon. | [Training] She trained as an athlete for years to compete professionally. | [Inspiration] Young athletes admire her dedication and skill.	\N	A person who is proficient in sports and other forms of physical exercise.	vận động viên	ˈæθliːt	athlete	6
16a2e56b-21ad-44c2-b69d-74787649e004	2025-11-12 12:10:21.353942	2025-11-12 16:23:53.357638	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff267e560-3acf-47a4-8efb-ebce4fba6de4.mp3?alt=media	B1		[Science] Study physics at university. | [Research] Physics explains motion. | [Career] Work in theoretical physics.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F2702800c-842a-4454-b17c-a133457005f8.jpg?alt=media	The science of matter, energy, and their interactions.	vật lý học	ˈfɪzɪks	physics	42
8bb7dfcc-0f90-48af-ad37-0174deb34c4a	2025-11-12 13:02:12.057506	2025-11-12 13:02:12.057522	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbb5c3e67-754b-4ce7-bbea-33dfe0f214af.mp3?alt=media	A1		[Wildlife] The fox darted across the field at dawn. | [Story] The clever fox outsmarted the hunter in the tale. | [Nature] Foxes are known for their adaptability in urban areas.	\N	A small to medium-sized carnivorous mammal with a bushy tail.	cáo	fɒks	fox	7
8dff9b8f-8b76-48fe-b062-ff6a53834753	2025-11-12 13:02:11.906347	2025-11-12 13:02:11.906362	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5f718ab6-95b9-476d-8b42-9ddb39d2bbf6.mp3?alt=media	A1		[Exercise] Running in the park is part of her daily routine. | [Competition] He trained for months for the running race. | [Health] Running improves heart health and builds stamina.	\N	The action of moving rapidly on foot as a sport or exercise.	chạy bộ	ˈrʌnɪŋ	running	6
2aab92c0-5380-4eab-93e2-1ebc53438c1f	2025-11-12 13:02:12.133188	2025-11-12 13:02:12.133205	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdf8bc058-e1c0-4351-b978-dfa7406598c4.mp3?alt=media	A1		[Hiking] Climbing the hill offered a stunning view of the valley. | [Exercise] She jogged up the hill to improve her stamina. | [History] The ancient fort was built on top of a hill.	\N	A naturally raised area of land, not as high as a mountain.	đồi	hɪl	hill	8
3ede4f0c-c898-4baa-8e56-565eb9a889f0	2025-11-12 13:02:12.164554	2025-11-12 13:02:12.164572	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F15f8fa5b-dac1-4c01-b525-5a0892ead71f.mp3?alt=media	A1		[Agriculture] The field was full of ripe wheat ready for harvest. | [Sport] The kids played soccer in the field near the school. | [Nature] Wildflowers covered the field in vibrant colors.	\N	An open area of land, especially used for farming or sports.	đồng ruộng	fiːld	field	8
2c24bb92-a78a-4e51-a5d7-07751c57d866	2025-11-12 13:02:12.196108	2025-11-12 13:02:12.196128	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4aa25b80-68b4-4e33-a485-f28076360964.mp3?alt=media	A1		[Home] The bathroom was remodeled with modern tiles. | [Routine] He takes a quick shower in the bathroom every morning. | [Cleaning] She scrubbed the bathroom to keep it spotless.	\N	A room containing a toilet and sink, often a bathtub or shower.	phòng tắm	ˈbɑːθruːm	bathroom	9
da51edbb-9283-4d7d-879b-4ef6fff0d692	2025-11-12 13:02:12.213555	2025-11-12 13:02:12.213585	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa800451d-b074-4503-8341-ead6aed04d09.mp3?alt=media	A1		[Living Room] The sofa was the perfect spot for family movie nights. | [Furniture] They bought a new sofa for the cozy apartment. | [Relaxation] She napped on the sofa after a long day.	\N	A long, upholstered seat with a back and arms for multiple people.	ghế sofa	ˈsəʊfə	sofa	9
63b72980-16be-44a3-8909-2c409855da00	2025-11-12 13:02:12.232925	2025-11-12 13:02:12.232943	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3c263b65-ae01-4f65-8174-9c4e55e36ca0.mp3?alt=media	A1		[Bathroom] She checked her outfit in the mirror before leaving. | [Decor] A large mirror made the small room feel bigger. | [Daily Life] The mirror in the hallway was a gift from her aunt.	\N	A reflective surface, typically glass, for viewing oneself.	gương	ˈmɪrə	mirror	9
67855177-90ed-4f1a-b473-d4e0e5e14204	2025-11-12 13:02:12.242109	2025-11-12 13:02:12.242128	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F71622461-93e2-4d0a-8e70-c5720c5fe7cc.mp3?alt=media	A1		[Time] The clock on the wall ticked loudly in the quiet room. | [Decor] They hung a vintage clock in the dining area. | [Routine] He checked the clock to make sure he wasn’t late.	\N	A device for measuring and showing time.	đồng hồ	klɒk	clock	9
9ff88cd7-7d55-4d8f-8bdb-780035bd1858	2025-11-12 13:02:12.25096	2025-11-12 13:02:12.250979	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa388cf86-b59c-4321-a518-dd64965ccdf4.mp3?alt=media	A1		[Home] The soft carpet felt warm under her feet in winter. | [Decor] They chose a blue carpet to match the room’s theme. | [Cleaning] Vacuuming the carpet regularly keeps it dust-free.	\N	A floor covering made of thick woven fabric.	thảm	ˈkɑːrpɪt	carpet	9
dcc7db0c-eafb-4718-954f-13597a769525	2025-11-12 13:02:12.267585	2025-11-12 13:02:12.267599	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F111fb558-4ac3-4fe2-a1a3-07ec3700ff39.mp3?alt=media	A1		[Kitchen] The cupboard was stocked with canned goods and spices. | [Storage] She hid gifts in the cupboard before the party. | [Home] They painted the cupboard to match the new decor.	\N	A cabinet or closet for storing items, especially in a kitchen.	tủ đựng đồ	ˈkʌbərd	cupboard	9
e980fdc3-95ea-4c0f-a7f0-9b28f173870a	2025-11-12 13:02:12.276412	2025-11-12 13:02:12.276427	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F80a64436-d9df-4f9c-8e77-5457f18b26ce.mp3?alt=media	A1		[Winter] She wrapped herself in a warm blanket by the fire. | [Travel] He packed a blanket for the picnic in the park. | [Comfort] The soft blanket was a gift from her grandmother.	\N	A large piece of fabric used for warmth, typically on a bed.	chăn	ˈblæŋkɪt	blanket	9
7a302faa-2796-4313-9fa0-9e2701ee2a0b	2025-11-12 13:02:13.745214	2025-11-12 16:23:56.294867	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffb88c398-708d-463a-9379-a4db3a62e219.mp3?alt=media	C1		[Geology] Tectonic plates move. | [Earth] Tectonic activity causes earthquakes. | [Theory] Study tectonic theory.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F066cac25-a131-4e6f-9bfd-c5fc2f363ccd.jpg?alt=media	Relating to the structure and movement of the Earthâ€™s crust.	kiến tạo	tekˈtɒnɪk	tectonic	8
29d1056b-eb32-4df5-94ad-fbc845197410	2025-11-12 13:02:12.174926	2025-11-12 16:23:58.686812	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F63b0a5f2-4b0a-4a7a-ae77-912edfdc8d50.mp3?alt=media	A2		[Gardening] Rich soil is essential for growing healthy plants. | [Science] The soil sample was tested for nutrient content. | [Agriculture] Farmers rotate crops to keep the soil fertile.	\N	The upper layer of earth in which plants grow.	đất	sɔɪl	soil	8
b533d652-0856-467d-bc2b-aa32f01c32b7	2025-11-12 13:02:12.079188	2025-11-12 16:24:07.926829	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9f74d7f1-8d2b-40cd-bd76-50aa7483606b.mp3?alt=media	A1		[Weather] Dark clouds gathered before the storm began. | [Photography] The sunset behind the clouds created a stunning view. | [Science] We studied how clouds form in our geography class.	\N	A visible mass of condensed water vapor in the atmosphere.	mây	klaʊd	cloud	8
fd4690c5-f9ee-412f-8710-8bd78ae48985	2025-11-12 13:02:12.317558	2025-11-12 13:02:12.317571	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F67fe973d-e1ae-40d2-b091-f7458e05e210.mp3?alt=media	A2		[Culture] The mosque’s minaret towered over the city skyline. | [Travel] We admired the intricate designs inside the mosque. | [Community] The mosque welcomed everyone for the festival prayer.	\N	A Muslim place of worship.	nhà thờ Hồi giáo	mɒsk	mosque	10
ca4db7c3-0f35-48dc-b95e-706dd677502e	2025-11-12 13:02:12.120926	2025-11-12 13:02:12.120953	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa09a5c88-93f3-43fd-afd2-554dfe67e0fd.mp3?alt=media	A1		[Vacation] The lake was perfect for swimming and kayaking. | [Nature] Fish thrive in the clear waters of the mountain lake. | [Photography] The lake reflected the stars beautifully at night.	\N	A large body of water surrounded by land.	hồ	leɪk	lake	8
52fa281c-0b64-4c86-b06f-82370e46bb2e	2025-11-12 13:02:11.116578	2025-11-12 13:02:11.116592	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffb567621-5b7f-4bad-9a46-0c95127a149c.mp3?alt=media	B2		[Everyday] I put the election on the window before dinner. | [Story] A traveler found a election near the old window. | [School] The teacher asked us to describe a election in two sentences.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F874f757a-8bbf-440d-a3a3-f7bf7facf08f.jpg?alt=media	A formal process of choosing a person for public office.	cuộc bầu cử	ɪˈlekʃn	election	17
a419fb29-1e45-4c90-ab03-1707c594e110	2025-11-12 13:02:12.418386	2025-11-12 13:02:12.418401	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F20a81bcd-9666-4bcd-b0df-9106be87c2c7.mp3?alt=media	B1		[Technology] The phone received a software update last night. | [Work] She updated the team on the project’s progress. | [Security] Regular updates keep the system safe from threats.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F55444a5e-bd9a-43a4-8ccb-3272f05bcbd6.jpg?alt=media	To make something more modern or current.	cập nhật	ˈʌpdeɪt	update	11
eb358f77-8308-46c9-b3ca-5a3de80ffbbb	2025-11-12 13:02:12.45461	2025-11-12 13:02:12.454626	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbd950dc0-c8f9-44dc-9348-4de4a293724d.mp3?alt=media	A1		[Work] He was tired after working a double shift. | [Travel] The long hike left her tired but satisfied. | [Daily Life] She felt tired and went to bed early tonight.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fa79f3221-0c8b-4ad4-be91-3933c49166b7.jpg?alt=media	In need of rest or sleep.	mệt mỏi	ˈtaɪərd	tired	12
f5071c3f-626e-4bc2-bddf-2edbb53c80c2	2025-11-12 13:02:12.478252	2025-11-12 13:02:12.478265	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7870a20c-c96f-4a64-b823-69102df6d872.mp3?alt=media	A2		[Vacation] She felt relaxed sitting by the pool with a book. | [Evening] A warm bath made him relaxed after a long day. | [Activity] The yoga class left everyone relaxed and refreshed.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F32a49708-9ac7-4f79-abe7-c4933e0a6925.jpg?alt=media	Free from tension and anxiety.	thư giãn	rɪˈlækst	relaxed	12
0c96e09d-b956-4537-bfc5-84b47d7df94d	2025-11-12 13:02:12.486095	2025-11-12 13:02:12.486108	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F18cd6798-2aaa-4f96-8a0d-ef5f12037df3.mp3?alt=media	B1		[Technology] He was frustrated when the computer crashed again. | [Task] She felt frustrated trying to solve the difficult puzzle. | [Work] The delayed project left the team frustrated.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F3f864fed-490f-413c-a866-89892a8311a3.jpg?alt=media	Feeling annoyed or upset due to inability to achieve something.	bực bội	frʌˈstreɪtɪd	frustrated	12
bb35e58b-87bd-4158-9d57-44975e9db300	2025-11-12 13:02:12.401365	2025-11-12 13:02:12.401383	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2a6a8bc0-f1f5-49b1-b45a-6dcfca4dbed6.mp3?alt=media	B1		[Programming] She wrote code to create a simple game. | [Security] The code was needed to access the secure system. | [Learning] He studied how to code in Python during the summer.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F9222f72d-ee0e-4471-b851-09cd3e578582.jpg?alt=media	A system of words, letters, or symbols used in programming.	mã code	kəʊd	code	11
f69759a8-2073-4d4c-be5a-dcb0e0da4acf	2025-11-12 13:02:12.351332	2025-11-12 13:02:12.351348	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd39061fd-45b8-4d9d-a28a-3d4a96c02d37.mp3?alt=media	A2		[History] The monument honors soldiers who fought in the war. | [Tourism] Visitors took photos in front of the famous monument. | [City] The monument stands tall in the center of the park.	\N	A structure built to commemorate a person or event.	đài tưởng niệm	ˈmɒnjumənt	monument	10
5765feac-f474-4d2d-bb51-9975db16fc83	2025-11-12 13:02:12.390596	2025-11-12 13:02:12.390623	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7728fb9e-21e8-43af-86d9-27a28aa9487d.mp3?alt=media	B2		[Technology] The server crashed, causing a website outage. | [Business] They upgraded the server to handle more traffic. | [IT] He works as a server administrator for a tech company.	\N	A computer that provides data to other computers.	máy chủ	ˈsɜːrvə	server	11
c6e188d3-f0e4-48a2-a51d-8e45895d5f98	2025-11-12 13:02:12.42714	2025-11-12 13:02:12.427157	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff06f895b-68d1-4c03-aed0-c1c3fc2ddcda.mp3?alt=media	B1		[Data] Always create a backup of important files. | [Technology] The system crashed, but the backup saved the data. | [Routine] He backs up his computer every week to avoid data loss.	\N	A copy of data saved to prevent loss.	sao lưu	ˈbækʌp	backup	11
f2452ca7-11a7-4711-9e4b-c4722fe82ef0	2025-11-12 13:02:12.444845	2025-11-12 13:02:12.444859	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe54f7b36-f305-4949-bdeb-45c35933412d.mp3?alt=media	A2		[Relaxation] The calm atmosphere of the lake was soothing. | [Reaction] She stayed calm during the stressful meeting. | [Advice] Take deep breaths to remain calm in tough situations.	\N	Peaceful and free from agitation or excitement.	bình tĩnh	kɑːm	calm	12
d1469c4a-dc73-415f-ab7f-abc2ef35180e	2025-11-12 13:02:12.502085	2025-11-12 13:02:12.502101	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3429face-53c0-4f84-bf94-2b8c7244b0dc.mp3?alt=media	B1		[Event] She was disappointed when the concert was canceled. | [Result] He felt disappointed with his low test score. | [Expectation] The meal was disappointing compared to the reviews.	\N	Feeling sad or dissatisfied because something was not as expected.	thất vọng	ˌdɪsəˈpɔɪntɪd	disappointed	12
1cb43ac6-bfaa-4a4e-991a-277577c54900	2025-11-12 13:02:11.127804	2025-11-12 13:02:11.127825	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7bf245c4-22ff-4365-a47e-df6bcd813928.mp3?alt=media	B1		[Goal] She plans to vote farther than last week. | [Travel] We voteed through the old town and took photos. | [Event] They voteed together during the school charity day.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fb8b5f383-5072-4004-84f6-713650602cce.jpg?alt=media	A formal indication of a choice between candidates or proposals.	bầu cử; lá phiếu	vəʊt	vote	17
bea4aa5f-6864-4b4c-b0be-7ef9ded81e01	2025-11-12 13:02:12.63714	2025-11-12 13:02:12.637155	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F85b4b29b-4c57-4012-8243-ffdd3c2da160.mp3?alt=media	A2		[Education] Science classes teach students about the natural world. | [Research] The science of genetics has advanced rapidly. | [Interest] She loves science and wants to become a biologist.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F6edf4280-0ad1-4db3-9fd7-a60c76dabe1f.jpg?alt=media	The systematic study of the structure and behavior of the physical world.	khoa học	ˈsaɪəns	science	15
080bfe65-9bdf-43b6-9629-5cae824f9b4a	2025-11-12 13:02:12.659038	2025-11-12 13:02:12.659058	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4f17d29a-c748-4b26-b483-7751e584bdd0.mp3?alt=media	B2		[Science] The researcher published a paper on marine biology. | [Team] She worked as a researcher on a climate project. | [Career] Becoming a researcher requires years of study.	\N	A person who conducts research, especially in science or academia.	nhà nghiên cứu	rɪˈsɜːrtʃə	researcher	15
1ca2a324-6b58-4ad7-8bf5-5d84b3bdede7	2025-11-12 13:02:12.526225	2025-11-12 13:02:12.526239	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F49671f0a-f06b-45a7-bed7-ab63643ea824.mp3?alt=media	B2		[Science] Climate change affects weather patterns worldwide. | [Policy] Governments are working to combat climate change with new laws. | [Awareness] The documentary raised awareness about climate change.	\N	A long-term change in weather patterns, often due to human activity.	biến đổi khí hậu	ˈklaɪmət tʃeɪndʒ	climate change	13
7006fd0e-8ece-4ab1-b0e9-93550917f925	2025-11-12 13:02:13.378382	2025-11-12 13:02:13.378386	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdba1498a-448c-46f7-9007-525d12526ac5.mp3?alt=media	B2		[Business] Hire a contractor for the project. | [Work] Work as an independent contractor. | [Agreement] Sign with the contractor.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F84490e45-5286-4799-8698-03b4a1b1fe8e.jpg?alt=media	A person or company hired to perform specific tasks.	nhà thầu	kənˈtræktə	contractor	4
c144d313-df01-4fd9-b80b-3a7023d2d4b7	2025-11-12 12:10:22.496216	2025-11-12 16:24:00.163987	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fba4cfbb0-702f-4d48-96ed-52075935dc79.mp3?alt=media	A2		[School] Education shapes futures. | [System] Improve public education. | [Career] Study education theory.	\N	The process of teaching or learning in a structured environment.	giáo dục	ˌedʒuˈkeɪʃn	education	50
67e2c791-0083-46db-8349-d2836b8f7b80	2025-11-12 13:02:12.57346	2025-11-12 16:23:38.891879	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdae2f79e-c509-4195-8950-afb625172a0b.mp3?alt=media	B2		[Agriculture] The greenhouse allows plants to grow year-round. | [Science] Greenhouse gases contribute to global warming. | [Gardening] She built a small greenhouse in her backyard.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F5ed4f8ad-6940-4df5-966b-3620382a2246.jpg?alt=media	A structure where plants are grown in a controlled environment.	nhà kính	ˈɡriːnhaʊs	greenhouse	13
3bbd2c7b-6e78-4ea7-b79f-546412f8acb2	2025-11-12 13:02:12.624484	2025-11-12 16:23:42.091301	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F598c9eb2-0c94-4371-bfc7-7b062f27eb4c.mp3?alt=media	B1		[Story] The legend of the dragon fascinated the children. | [History] The city is famous for its ancient legends. | [Culture] She read a book about local legends and myths.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F23ddb2b6-1cd0-454b-8831-ee239565a29a.jpg?alt=media	A traditional story regarded as historical but unauthenticated.	truyền thuyết	ˈledʒənd	legend	14
b7a507a7-e8fc-4f1c-9bc4-1d5f6cf42610	2025-11-12 12:10:23.039778	2025-11-12 16:24:03.807241	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7634f49e-e651-449d-b638-b52f4b447d64.mp3?alt=media	A1		[Art] Learn a new dance. | [Performance] Dance at the festival. | [Culture] Traditional dances are fun.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F7634b2d1-b004-4937-a6d0-3f003fefbf45.jpg?alt=media	A series of movements performed to music.	điệu nhảy	dɑːns	dance	54
f54ccc80-48b4-4b03-9b5b-8379eb2d79ed	2025-11-12 13:02:11.282691	2025-11-12 16:24:02.288502	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F975c5b14-1220-4e8d-bed6-58b64d65a4f6.mp3?alt=media	B2		[Work] The sculpture was recorded carefully in the report. | [Problem] The sculpture broke suddenly, so we had to fix it. | [Story] A traveler found a sculpture near the old bench.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F388a2d12-0028-47dd-be22-d77324893ddc.jpg?alt=media	The art of making two- or three-dimensional representative or abstract forms.	điêu khắc	ˈskʌlptʃə	sculpture	19
28ce11b6-5226-42c3-a2d7-77578273887d	2025-11-12 13:02:12.581389	2025-11-12 16:23:49.185305	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd0f86a3e-16b9-4c9f-acdc-5a13601c960a.mp3?alt=media	B1		[Culture] The custom of giving gifts is common during festivals. | [Travel] We learned about local customs during our trip. | [Tradition] The wedding followed ancient family customs.	\N	A traditional or widely accepted way of behaving.	phong tục	ˈkʌstəm	custom	14
3b659095-3635-4624-a07f-c2b547ae32e4	2025-11-12 13:02:12.534426	2025-11-12 16:23:58.237367	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F25b0b924-cc64-4e39-8a1b-a4616518384e.mp3?alt=media	B1		[Environment] Recycling plastic reduces waste in landfills. | [School] The recycling program encouraged students to sort trash. | [Community] The town built a new recycling center for residents.	\N	The process of converting waste into reusable material.	tái chế	riːˈsaɪklɪŋ	recycling	13
3ac0c3a0-07a2-4469-b227-b6237b6c50fc	2025-11-12 13:02:13.035761	2025-11-12 16:24:01.018407	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F257ce187-aea4-4a66-a559-ec6f3450dcb9.mp3?alt=media	B2		[Literature] Submit the manuscript to publishers. | [History] Discover an ancient manuscript. | [Writing] Edit the manuscript carefully.	\N	A handwritten or typed document, especially an authorâ€™s original text.	bản thảo	ˈmænjəskrɪpt	manuscript	19
f215434d-0261-443e-ac8d-d42288a179d0	2025-11-12 13:02:12.651132	2025-11-12 16:24:07.985465	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe7825215-67e7-40b8-be82-5a83c23dbb63.mp3?alt=media	B2		[Research] The data showed a clear trend in temperature rise. | [Technology] She analyzed data to improve the app’s performance. | [Business] Accurate data is key to making informed decisions.	\N	Facts and statistics collected for analysis.	dữ liệu	ˈdeɪtə	data	15
ed1929bc-d5a0-4948-84d5-df4073ec0988	2025-11-12 13:02:12.699854	2025-11-12 13:02:12.699879	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F21fbde1f-3b51-42bc-acf2-052faff32e11.mp3?alt=media	B1		[University] She earned a degree in computer science. | [Achievement] His degree opened doors to new career opportunities. | [Study] Getting a degree requires years of hard work.	\N	An academic qualification awarded by a college or university.	bằng cấp	dɪˈɡriː	degree	16
316d0b94-4014-4af8-b352-c262c646d3fd	2025-11-12 13:02:12.70707	2025-11-12 13:02:12.707084	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F80f22f6d-ca8b-4073-bffa-6c14edb86f61.mp3?alt=media	B1		[Education] The online course taught coding for beginners. | [University] She enrolled in a course on environmental science. | [Learning] The course included weekly quizzes and projects.	\N	A series of lessons or lectures on a particular subject.	khóa học	kɔːrs	course	16
d8eaf9aa-8771-409c-9313-b583e0887725	2025-11-12 13:02:12.732465	2025-11-12 13:02:12.732481	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1b6bf749-b458-4ab4-a032-924dcd55c170.mp3?alt=media	B2		[Education] The syllabus outlined the topic for the semester. | [Planning] She reviewed the syllabus to prepare for the course. | [School] The teacher handed out the syllabus on the first day.	\N	An outline of the subjects in a course of study.	đề cương môn học	ˈsɪləbəs	syllabus	16
017ab29e-a00b-49d0-a6b4-68dba88d0599	2025-11-12 13:02:12.724068	2025-11-12 13:02:12.724085	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F8d92184a-ce64-4b5a-8db1-b67211591828.mp3?alt=media	B1		[University] The professor explained complex theories clearly. | [Research] She worked with a professor on a biology project. | [Lecture] The professor’s talk on history was fascinating.	\N	A senior academic teacher at a university.	giáo sư	prəˈfesə	professor	16
05cfcdde-434e-4eaf-8b3f-2e46755264db	2025-11-12 13:02:12.765593	2025-11-12 13:02:12.765619	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc6dea09e-cfb0-4c5c-8457-8342eaafd31f.mp3?alt=media	B1		[Education] Lifelong learning keeps the mind sharp. | [Class] The new method improved students’ learning experience. | [Technology] Online learning platforms are growing in popularity.	\N	The acquisition of knowledge or skills through study or experience.	học tập	ˈlɜːrnɪŋ	learning	16
d3c8cbab-2645-45bf-a1cf-82b9baefc553	2025-11-12 13:02:12.748518	2025-11-12 13:02:12.748534	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe58defd9-98e2-48f1-817a-a34a3d738012.mp3?alt=media	B2		[Research] The scholar published a book on ancient history. | [Education] She was recognized as a scholar for her academic work. | [History] Scholars debated the meaning of the ancient texts.	\N	A person who has detailed knowledge in a particular field.	học giả	ˈskɒlə	scholar	16
33f9d01d-b7d2-4b73-ad7a-e0154d0f792f	2025-11-12 13:02:12.779647	2025-11-12 13:02:12.779669	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe748fc9a-6ee6-4cfd-889c-f313ded72fab.mp3?alt=media	B2		[Business] The regulation ensures fair trade practices. | [Safety] New regulations were introduced to protect workers. | [Government] The regulation limits pollution from factories.	\N	A rule or directive made and maintained by an authority.	quy định	ˌreɡjəˈleɪʃn	regulation	17
e5b061f2-610b-4786-8309-ba113aad296f	2025-11-12 13:02:12.809777	2025-11-12 13:02:12.809796	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Feb06c091-c847-433b-bdf9-b68dc73a32f6.mp3?alt=media	B2		[Government] The legislation was passed to reduce emissions. | [Study] She researched legislation on renewable energy. | [Politics] New legislation aims to improve public healthcare.	\N	Laws collectively, or the process of making laws.	luật pháp	ˌledʒɪsˈleɪʃn	legislation	17
0786bcd3-2e8e-46b5-a65d-2c955218b8ab	2025-11-12 13:02:12.803651	2025-11-12 13:02:12.803664	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F89796e55-604f-4b4f-88fe-3b2b3911f445.mp3?alt=media	B1		[Law] Human rights are protected by international agreements. | [Protest] They marched to demand equal rights for all. | [Education] She studied the rights of workers in her course.	\N	Legal, social, or ethical principles of entitlement.	quyền	raɪts	rights	17
a7ebb9f5-a7d7-4620-87fe-28c7ab255381	2025-11-12 13:02:12.825712	2025-11-12 13:02:12.825727	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7d391932-ce04-4a49-a938-1c962596d613.mp3?alt=media	B2		[Politics] Diplomacy helped resolve the international dispute peacefully. | [Career] She pursued a career in diplomacy after studying international relations. | [History] Effective diplomacy prevented a major war in the region.	\N	The profession or activity of managing international relations.	ngoại giao	dɪˈpləʊməsi	diplomacy	17
788860bc-cf6b-489f-8066-d94289b84419	2025-11-12 13:02:11.395773	2025-11-12 13:02:11.395786	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F18a5a921-495a-45fd-b9e7-4a3e2168c455.mp3?alt=media	B1		[Everyday] I put the content on the doorway before dinner. | [Story] A traveler found a content near the old doorway. | [School] The teacher asked us to describe a content in two sentences.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F432a1fdf-f1a9-4674-b1da-78f369503c55.jpg?alt=media	Information made available by a website or other electronic medium.	nội dung	ˈkɒntent	content	20
28811039-3078-49c3-8222-7695806ee1ac	2025-11-12 13:02:12.856526	2025-11-12 13:02:12.856538	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fee8d1d75-3faa-4f01-8f2a-d4b6cc20af5a.mp3?alt=media	B2		[Politics] Leaders met at the summit to discuss trade. | [Event] The annual summit focused on climate issues. | [Diplomacy] The summit resulted in new agreements.	\N	A meeting of heads of state or government.	hội nghị thượng đỉnh	ˈsʌmɪt	summit	17
b9db97f5-1608-4916-a965-04d82071c554	2025-11-12 13:02:12.73989	2025-11-12 16:24:00.299341	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9227c917-7de8-41b9-bea1-19deec3ed148.mp3?alt=media	B2		[Education] The assessment included both a test and an essay. | [Work] The manager conducted an assessment of the team’s performance. | [School] Her assessment showed she excelled in math.	\N	The evaluation or estimation of the nature or quality of something.	đánh giá	əˈsesmənt	assessment	16
e00df4a7-9136-44b6-b321-ff1399fad098	2025-11-12 13:02:12.756953	2025-11-12 16:24:00.606185	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F374b2b9e-e849-4303-a89c-1a3e137f55d3.mp3?alt=media	B2		[Career] Her mentor guided her through the job application process. | [Education] The mentor helped students with their research projects. | [Support] He acted as a mentor to young entrepreneurs.	\N	An experienced person who advises and guides a less experienced person.	cố vấn	ˈmentɔːr	mentor	16
5bd98ad9-a73f-4d77-9007-c7a0b30c986e	2025-11-12 13:02:12.871792	2025-11-12 13:02:12.87181	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbe1e2740-fdb0-49b5-9d26-7fdac4afa3ee.mp3?alt=media	B1		[Politics] Citizens organized a protest against the policy. | [Rights] The protest drew thousands of participants. | [Event] Police monitored the peaceful protest.	\N	A public expression of objection or disapproval.	biểu tình	ˈprəʊtest	protest	17
431ea127-22c0-4e8a-b7e3-a7f0c7acaa76	2025-11-12 13:02:12.879137	2025-11-12 13:02:12.87915	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F73a1c5a5-715a-40fe-9dbf-dde664c6edb3.mp3?alt=media	C1		[Law] The amendment protected freedom of speech. | [Constitution] Propose an amendment to the bill. | [Politics] The amendment passed with majority support.	\N	A change or addition to a legal document or law.	sửa đổi (luật)	əˈmendmənt	amendment	17
277f0277-dbc7-481b-9e45-ba108d8f1911	2025-11-12 13:02:12.904558	2025-11-12 13:02:12.904572	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc9af866f-1d64-4f48-b07a-ad30b48adb31.mp3?alt=media	B2		[Finance] The company's assets include property and equipment. | [Investment] Diversify your assets for better returns. | [Business] Sell assets to raise capital.	\N	A useful or valuable thing or person.	tài sản	ˈæset	asset	18
42359d61-8ba5-4947-8823-3a981c3b35b1	2025-11-12 13:02:12.91302	2025-11-12 13:02:12.913037	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F893ea453-f14b-455b-bd96-38651e4c1825.mp3?alt=media	C1		[Law] Limit liability with insurance. | [Business] Assess the company's liabilities. | [Finance] Liabilities exceed assets in bankruptcy.	\N	The state of being responsible for something, especially by law.	trách nhiệm pháp lý	ˌlaɪəˈbɪləti	liability	18
fceeec77-bbcb-4292-a1ef-c2253be91094	2025-11-12 13:02:12.895886	2025-11-12 13:02:12.895901	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F46d04abb-d883-4658-b6fd-aae42655a494.mp3?alt=media	B2		[Law] The judge announced the verdict. | [Trial] Await the jury's verdict. | [Case] The verdict surprised everyone.	\N	A decision on an issue of fact in a court case.	phán quyết	ˈvɜːdɪkt	verdict	17
95001aed-22b7-4d52-9aea-38bd4b4a7b54	2025-11-12 13:02:12.928466	2025-11-12 13:02:12.928478	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff19c9222-4020-4632-adc5-f5063381dc7f.mp3?alt=media	B2		[Business] The acquisition expanded the product line. | [Strategy] Plan a strategic acquisition. | [Finance] Fund the acquisition with loans.	\N	The purchase or takeover of one company by another.	mua lại	ˌækwɪˈzɪʃn	acquisition	18
3f4d6090-beb2-4de5-b887-654035b2ab07	2025-11-12 13:02:12.955057	2025-11-12 13:02:12.955071	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F61e9bc93-c0cc-4937-b971-384071b584a5.mp3?alt=media	B2		[Business] Engage stakeholders in decisions. | [Project] Identify key stakeholders. | [Management] Communicate with stakeholders regularly.	\N	A person with an interest or concern in a business or project.	người liên quan	ˈsteɪkhəʊldə	stakeholder	18
29c21f02-b398-4ce2-8fd6-a53a93e5727b	2025-11-12 13:02:12.962465	2025-11-12 13:02:12.962483	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd6ae84e5-01e6-4e33-b4e6-80ab82d02af3.mp3?alt=media	B2		[Finance] Pay dividends to shareholders. | [Investment] Receive annual dividends. | [Profit] Dividends reflect company profits.	\N	A sum of money paid to shareholders from profits.	cổ tức	ˈdɪvɪdend	dividend	18
fc7f0bbd-8a36-40e4-ab41-de56aee6b383	2025-11-12 13:02:12.97159	2025-11-12 13:02:12.971622	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb2f1968c-42f7-48df-83cd-09d4bf87433f.mp3?alt=media	B2		[Finance] File for bankruptcy protection. | [Business] Avoid bankruptcy with restructuring. | [Law] Bankruptcy affects credit ratings.	\N	The state of being unable to pay debts, leading to legal insolvency.	phá sản	ˈbæŋkrʌptsi	bankruptcy	18
b9300ab5-b98c-488e-b660-0c07752e3fd4	2025-11-12 13:02:13.027788	2025-11-12 13:02:13.027802	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb2b1c805-892e-466f-99fd-e314494fa6a0.mp3?alt=media	B1		[Theater] Enjoy an opera show. | [Music] Sing in the opera. | [Culture] Opera combines music and drama.	\N	A dramatic work combining music, singing, and often dance.	nhạc kịch	ˈɒpərə	opera	19
3a86b88f-9368-4547-9f4b-d20d6fd38fd4	2025-11-12 13:02:13.07204	2025-11-12 13:02:13.072056	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F318bef18-5ca9-4f30-bf5b-d4a58ad88a17.mp3?alt=media	A1		[Online] Join the group chat. | [Communication] Chat with friends daily. | [App] Use the chat feature.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F66feda3f-c83f-4f09-955a-000ecfbea45d.jpg?alt=media	Informal conversation, often online.	cuộc trò chuyện	tʃæt	chat	20
3672e187-d6c6-4487-adff-b10a2872c817	2025-11-12 13:02:13.126103	2025-11-12 13:02:13.126116	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3f8c21bb-3da2-4f47-9b56-dc341e44c21b.mp3?alt=media	A1		[Snack] Have yogurt for dessert. | [Health] Yogurt aids digestion. | [Flavor] Add fruit to yogurt.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fcd433852-a739-4351-8128-6d86dc5308d0.jpg?alt=media	A food produced by bacterial fermentation of milk.	sữa chua	ˈjɒɡət	yogurt	1
6d0508d3-41e7-4db8-8461-451691d2d8b7	2025-11-12 13:02:13.134792	2025-11-12 13:02:13.134805	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3c5c0c9e-3d4b-471c-9040-6ca106efd9ed.mp3?alt=media	A2		[Meal] Grill a juicy steak. | [Restaurant] Order medium rare steak. | [Protein] Steak provides protein.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fdbd508bb-047e-4823-a749-52f29a9b0d72.jpg?alt=media	A slice of meat, typically beef, cooked by grilling or frying.	bò bít tết	steɪk	steak	1
5ed01ed0-8b75-4038-9b36-46a6ffb9b743	2025-11-12 13:02:13.014224	2025-11-12 16:24:03.594244	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5481a805-fd95-4129-b2fd-26730cc2adb6.mp3?alt=media	B2		[Music] Listen to the symphony orchestra. | [Composition] Compose a new symphony. | [Performance] Attend the symphony concert.	\N	An elaborate musical composition for a full orchestra.	giao hưởng	ˈsɪmfəni	symphony	19
a953729e-6681-4c98-86d7-e891999dcad3	2025-11-12 13:02:12.989848	2025-11-12 16:24:02.411983	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe4c8bce0-788c-4d0a-b4e3-cce4ff281b79.mp3?alt=media	B1		[Art] Paint on a stretched canvas. | [Material] Buy canvas for the project. | [Exhibit] Display the canvas artwork.	\N	A strong, coarse fabric used for painting or sails.	vải tranh	ˈkænvəs	canvas	19
1e6c1d08-c4e5-455a-aef9-362a839e045d	2025-11-12 13:02:13.020446	2025-11-12 16:24:04.072137	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F58f22c9b-1842-45d6-b0a8-dabe8b23542d.mp3?alt=media	B1		[Dance] Watch a ballet performance. | [Art] Study ballet dancing. | [Theater] The ballet tells a story.	\N	An artistic dance form performed to music, using precise movements.	vũ ba lê	ˈbæleɪ	ballet	19
b9942da1-c34f-4223-8720-58af2deb62f3	2025-11-12 13:02:13.143695	2025-11-12 13:02:13.143708	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F53f239e7-5c73-40f3-952a-d29d4fe789ab.mp3?alt=media	A2		[Drink] Blend a fruit smoothie. | [Health] Drink smoothie for breakfast. | [Recipe] Add spinach to smoothie.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fb1eec683-c019-414d-8727-a6d19aab3446.JPG?alt=media	A thick beverage made from blended fruits, vegetables, or yogurt.	sinh tố	ˈsmuːði	smoothie	1
0375bcb4-c667-48d5-bcd2-b834be90329b	2025-11-12 13:02:13.16649	2025-11-12 13:02:13.166501	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F13573e6f-992e-478d-b496-ec3653e81e03.mp3?alt=media	A2		[Cooking] Chop fresh herbs. | [Garden] Grow herbs at home. | [Flavor] Herbs add aroma.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fba233c06-1789-40f9-9211-e3349e3bbe7c.jpg?alt=media	A plant used for flavoring food or medicine.	thảo mộc	hɜːb	herb	1
df321c58-ccaf-4796-a613-1762d17b8009	2025-11-12 13:02:13.198579	2025-11-12 13:02:13.198592	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdcf6e0e0-4e54-4c9f-85eb-54a9df2dc68e.mp3?alt=media	A2		[Family] Visit your siblings. | [Relationship] Share with siblings. | [Bond] Strengthen sibling bonds.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F60c1b479-f0ee-47fe-b446-2bcfd9882c12.jpg?alt=media	A brother or sister.	anh chị em	ˈsɪblɪŋ	sibling	2
932969f5-a2f2-4ee6-938f-7aab7f2e0969	2025-11-12 13:02:13.223094	2025-11-12 13:02:13.223107	null	B1		[Relationship] Meet the fiancée. | [Planning] Discuss with fiancée. | [Future] Build life with fiancée.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F87257d25-b9ae-4b7a-ac95-07acce83eb6e.jpg?alt=media	A woman engaged to be married.	vị hôn thê	fiˈɒnseɪ	fiancée	2
2ac74791-7577-43b8-b0af-7d2b4877664a	2025-11-12 13:02:13.246208	2025-11-12 13:02:13.246222	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd58b6fef-a4e3-4087-91a8-eb565364eba4.mp3?alt=media	B2		[Family] Comfort the widower. | [Grief] The widower mourned. | [Support] Assist widowers.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F26c23a96-8ad7-48fb-866c-07d4c67a3324.jpg?alt=media	A man whose spouse has died and who has not remarried.	goá chồng	ˈwɪdəʊə	widower	2
9358b67d-e110-477c-83d8-c456453ed53a	2025-11-12 13:02:13.088079	2025-11-12 13:02:13.088091	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0b83b6cd-e8e3-454b-8cf0-f7baf34deb02.mp3?alt=media	B1		[Media] Listen to a podcast episode. | [Series] Subscribe to the podcast. | [Content] Create your own podcast.	\N	A digital audio file available for downloading, often part of a series.	podcast	ˈpɒdkɑːst	podcast	20
d6267e9b-f2e1-46ca-92fc-72f592f12b1b	2025-11-12 13:02:13.102867	2025-11-12 13:02:13.10288	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbe6ad878-5fce-40de-8457-bb668e85b9cf.mp3?alt=media	B1		[Online] Post on the discussion forum. | [Community] Join the forum community. | [Question] Ask questions in the forum.	\N	A place, especially online, for public discussion.	diễn đàn	ˈfɔːrəm	forum	20
4809051d-27ac-4d8c-b5a3-ede7df04c50d	2025-11-12 13:02:13.207237	2025-11-12 13:02:13.207249	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F157986c2-b55d-4031-af6b-e934d1cac349.mp3?alt=media	B1		[Family] Meet the in-laws. | [Relationship] Get along with in-laws. | [Holiday] Celebrate with in-laws.	\N	A relative by marriage, such as a mother-in-law.	nhà thông gia	ˈɪn lɔː	in-law	2
bb407877-7dc2-41a4-8f87-d3bb38cca262	2025-11-12 13:02:13.063976	2025-11-12 13:02:13.06401	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2ed8966a-9cc4-455b-b09e-4f8856ac34a1.mp3?alt=media	A2		[Communication] Use emoji in messages. | [Expression] Add emoji to express emotions. | [Text] The message included heart emoji.	\N	A small digital image used to express an idea or emotion.	biểu tượng cảm xúc	ɪˈməʊdʒi	emoji	20
bb7a35f9-b58b-40e9-ab48-052eae961a9b	2025-11-12 13:02:11.514625	2025-11-12 13:02:11.514641	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc356bea9-77d2-4231-b753-617c06e11d51.mp3?alt=media	A1		[Memory] My grandfather told stories of his childhood every evening. | [Family] The grandfather taught his grandson how to fish by the lake. | [Celebration] We visited grandfather to celebrate his 80th birthday.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F905aa952-6f53-4285-8b87-47c2dcec9c74.jpg?alt=media	The father of a parent.	ông	ˈɡrændˌfɑːðə	grandfather	2
d31f9df9-8b87-485a-8ab9-fbfddece5014	2025-11-12 13:02:13.355858	2025-11-12 13:02:13.355863	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F934f1ff6-d30d-4bf8-a941-618d8b72d38e.mp3?alt=media	B2		[Business] Face company layoffs. | [Economy] Avoid mass layoffs. | [Support] Provide aid after layoffs.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F518d1585-aea8-4d2b-930f-fcfe80a1cc44.jpg?alt=media	The termination of employees due to lack of work or funds.	sa thải	ˈleɪɒf	layoff	4
e9a067f2-c5a5-40a1-a407-2f43b1a5fd32	2025-11-12 13:02:13.385892	2025-11-12 13:02:13.385898	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd8b1a743-2097-4a62-96ee-1bfc505da34e.mp3?alt=media	B1		[Career] Become a freelancer writer. | [Work] Freelancers set their schedules. | [Platform] Find jobs as freelancer.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fb52f92ee-6253-4dc8-ad9e-8cbc19baa55b.jpg?alt=media	A self-employed person offering services to multiple clients.	người làm tự do	ˈfriːlɑːnsə	freelancer	4
0f53d512-f34d-48f8-a0ea-a25bc319d9c2	2025-11-12 13:02:13.395222	2025-11-12 13:02:13.395228	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa5f789c7-4851-4ea9-aef6-4bb76e3ed934.mp3?alt=media	B2		[Career] Attend networking events. | [Connections] Expand professional networking. | [Benefit] Networking leads to opportunities.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fb518f6b0-af83-490e-9405-95f6cb75c1a5.jpg?alt=media	The act of building professional or social relationships.	xây dựng mạng lưới	ˈnetwɜːkɪŋ	networking	4
350d9e20-e09f-462b-9761-ace26a1a39fb	2025-11-12 13:02:13.409895	2025-11-12 13:02:13.409902	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdd144f91-1d9d-4c04-a304-47ad3342442a.mp3?alt=media	A2		[Transport] Drive through the tunnel. | [Construction] Build a long tunnel. | [Light] See light at tunnel end.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F2dd8986f-f562-40ca-9979-f37e75b78d7a.jpg?alt=media	An underground passage, often for vehicles or trains.	đường hầm	ˈtʌnl	tunnel	5
b060039d-e209-4c18-b9aa-62b28f5b80c9	2025-11-12 13:02:13.417555	2025-11-12 13:02:13.417561	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb8f84da7-9295-4fcd-8bf3-4c7228f49d87.mp3?alt=media	A2		[Safety] Use the crosswalk to cross. | [City] Wait at the crosswalk. | [Sign] Follow crosswalk signals.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc2e25ee6-6f83-4cee-912b-38ad05a2eb53.jpg?alt=media	A marked part of a road where pedestrians can cross.	lối đi bộ	ˈkrɒswɔːk	crosswalk	5
b7a6e9f8-c29a-4790-8d10-a705079906b5	2025-11-12 13:02:13.432387	2025-11-12 13:02:13.432393	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd3d0d0c2-50a0-4f3d-bb00-da46988b99db.mp3?alt=media	B1		[Road] Pay the toll at the booth. | [Highway] Collect toll for maintenance. | [Pass] Use electronic toll pass.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F55b90b66-ca22-464a-b9cb-4ca55166888f.jpg?alt=media	A fee charged for using a road, bridge, or tunnel.	phí cầu đường	təʊl	toll	5
c2f25b64-d425-4b53-afdd-289c7bdeb5c0	2025-11-12 13:02:13.476997	2025-11-12 13:02:13.477004	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3dabc0f3-5f25-437c-b2e1-92618c8c44d7.mp3?alt=media	A2		[Travel] Go sightseeing in the city. | [Tour] Join a sightseeing bus. | [Activity] Enjoy sightseeing spots.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F7e765003-4cb8-4a5d-af1b-7f7830fa0155.jpg?alt=media	The activity of visiting places of interest as a tourist.	tham quan	ˈsaɪtsiːɪŋ	sightseeing	5
715811b3-7dc0-45d2-bae1-22fc0eb53336	2025-11-12 13:02:13.509077	2025-11-12 13:02:13.509084	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fce10c77b-a4be-4596-bbdc-04043d3471ea.mp3?alt=media	B1		[Fitness] Join aerobics classes. | [Workout] Do aerobics for cardio. | [Music] Aerobics with upbeat music.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F4cffca39-a071-4b21-84d6-623381560e8f.jpg?alt=media	A form of exercise involving rhythmic movements to improve fitness.	thể dục nhịp điệu	eəˈrəʊbɪks	aerobics	6
3b809984-ad54-49f9-b477-375f3e292f67	2025-11-12 13:02:13.328939	2025-11-12 13:02:13.328947	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7cb34874-301e-4923-b19e-c5e64ac43650.mp3?alt=media	B1		[Education] Start the new semester. | [Schedule] Plan courses for the semester. | [Break] Enjoy semester holidays.	\N	An academic term, typically lasting several months.	học kỳ	sɪˈmestə	semester	3
3ab76406-e93a-44f6-9f3d-e9902119c5f8	2025-11-12 13:02:13.370885	2025-11-12 13:02:13.370896	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1a6465fe-0e3c-497d-8383-94adfaebbf88.mp3?alt=media	B2		[Job] Enjoy company perks. | [Benefit] Health insurance is a perk. | [Attraction] Perks attract employees.	\N	A benefit given to employees in addition to salary.	phúc lợi	pɜːk	perk	4
d7466330-c1c4-47e5-bac0-98a2fd96618a	2025-11-12 13:02:13.44621	2025-11-12 13:02:13.446216	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb5c53503-09b5-4bf6-b7c4-b94678a28f74.mp3?alt=media	B2		[Travel] Plan your trip itinerary. | [Schedule] Follow the itinerary. | [Details] Include flights in itinerary.	\N	A planned route or journey.	lịch trình	aɪˈtɪnərəri	itinerary	5
e03d59d2-d4b1-4db7-8b3c-b9abd14d4b01	2025-11-12 13:02:13.574788	2025-11-12 13:02:13.574797	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F69f9f090-b4bb-4c73-9edf-73dbd152e076.mp3?alt=media	A1		[Animal] See kangaroos in Australia. | [Jump] Kangaroos hop quickly. | [Pouch] Kangaroos carry joeys in pouches.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Ff3d2faee-d44e-4d9c-a8f0-6fc761c75b66.jpg?alt=media	A large marsupial native to Australia with strong hind legs for jumping.	chuột túi	ˌkæŋɡəˈruː	kangaroo	7
2adf9665-1f3d-42b8-9926-f594aac2f0ff	2025-11-12 13:02:13.605179	2025-11-12 13:02:13.605215	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F94cecfcd-e290-4547-b98a-46edf53a3c1e.mp3?alt=media	A1		[Ocean] Watch whales migrate. | [Size] Whales are huge mammals. | [Song] Hear whale songs underwater.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F33e568b0-8e87-43c3-8f54-d636dd412db0.jpg?alt=media	A large marine mammal that breathes air through a blowhole.	cá voi	weɪl	whale	7
8e1da24a-731c-46ad-89c2-014d0b0abbab	2025-11-12 13:02:13.61398	2025-11-12 13:02:13.61399	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F53e1b7b1-404d-47d7-860c-fea6997aeba9.mp3?alt=media	A1		[Ocean] Dolphins are intelligent. | [Play] Dolphins jump in waves. | [Show] See dolphin performances.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Ff7d06a45-e724-4dec-bd8d-65c077588bba.jpg?alt=media	A small, social marine mammal known for its intelligence.	cá heo	ˈdɒlfɪn	dolphin	7
0863166f-24f6-4add-82ed-1676dd03faa0	2025-11-12 13:02:13.637736	2025-11-12 13:02:13.637744	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F84f66a0b-7522-4680-9032-91054b486f90.mp3?alt=media	A2		[Ocean] Jellyfish sting can hurt. | [Glow] Some jellyfish glow. | [Beach] Avoid jellyfish in water.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F18d5fc8e-3856-48bc-b385-06d6103dc774.jpg?alt=media	A marine animal with a gelatinous body and stinging tentacles.	sứa	ˈdʒelifiʃ	jellyfish	7
791c9880-f8ef-4465-bff2-18c7267ab953	2025-11-12 13:02:11.740024	2025-11-12 13:02:11.74004	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdeb7de9e-b913-4a74-ac82-2dc264422ee4.mp3?alt=media	B1		[Business] The client was impressed with the new marketing plan. | [Meeting] She prepared a report for the client’s visit tomorrow. | [Service] We aim to satisfy every client with excellent support.	\N	A person or organization using the services of a professional.	khách hàng \n	klaɪənt	client	4
708b45fb-e628-4b57-9e6d-8b6fcbf75ecf	2025-11-12 13:02:13.681978	2025-11-12 16:23:56.53765	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F825987ca-bbdc-471b-9ec1-3b2583559060.mp3?alt=media	B1		[Space] Milky Way is our galaxy. | [Stars] Galaxies contain billions of stars. | [Universe] Explore distant galaxies.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc36e6568-3627-41a1-9adb-9515b38142b3.jpg?alt=media	A system of stars, gas, and dust bound by gravity.	thiên hà	ˈɡæləksi	galaxy	8
b64837cb-2e32-4646-b070-dfdc013ca3fa	2025-11-12 13:02:13.670393	2025-11-12 16:23:56.854763	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd4299961-342d-4577-8f54-b0d9129d5f8d.mp3?alt=media	A1		[Space] Earth is a planet. | [Solar] Study solar planets. | [Explore] Discover new planets.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F1728795d-a328-4172-b4d1-b23158cf72dd.jpg?alt=media	A celestial body orbiting a star, like Earth or Mars.	hành tinh	ˈplænɪt	planet	8
0fd28df1-5e05-4481-9455-076e0ee6e9af	2025-11-12 13:02:13.755714	2025-11-12 13:02:13.755728	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Feb3a4de1-6259-4dc8-827f-d983021fc2ef.mp3?alt=media	A1		[Kitchen] Store food in refrigerator. | [Appliance] Buy a new refrigerator. | [Cool] Keep drinks cold in refrigerator.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F0b82b060-a2ab-4758-82a1-0083dfa5feb9.jpg?alt=media	An appliance for keeping food and drinks cold.	tủ lạnh	rɪˈfrɪdʒəreɪtə	refrigerator	9
3a0df300-b644-43b2-8ff2-baf58db0a9f5	2025-11-12 13:02:13.765651	2025-11-12 13:02:13.765659	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff68b3a1e-b040-4a89-8e0d-7570f64c4f67.mp3?alt=media	A1		[Kitchen] Heat food in microwave. | [Appliance] Use the microwave oven. | [Quick] Microwave meals are convenient.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F434d6671-5829-4ddc-8945-153f64065491.jpg?alt=media	An appliance that cooks or heats food using electromagnetic waves.	lò vi sóng	ˈmaɪkrəʊweɪv	microwave	9
c7d37063-3bf9-44a6-9873-614094386af7	2025-11-12 13:02:13.774152	2025-11-12 13:02:13.774159	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F853f6af4-e820-4abe-861c-7b8312e7da03.mp3?alt=media	A2		[Home] Clean with vacuum cleaner. | [Tool] Buy a cordless vacuum. | [Chore] Vacuum the carpets weekly.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fa03d02f1-a62e-4334-80b0-09bcc541ebd8.jpg?alt=media	A device that cleans floors by sucking up dirt.	máy hút bụi	ˈvækjuːm ˈkliːnə	vacuum cleaner	9
bb305338-a523-474b-9c37-5042e4dc9b4e	2025-11-12 13:02:13.789047	2025-11-12 13:02:13.789052	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6da5fa7b-983d-43c4-9bab-10c6ec7e62dc.mp3?alt=media	A2		[Kitchen] Load the dishwasher. | [Appliance] Run the dishwasher cycle. | [Convenience] Use dishwasher for cleaning.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc291252c-60d1-4594-aa29-8cef1e3754b3.jpg?alt=media	A machine for washing dishes automatically.	máy rửa chén	ˈdɪʃwɒʃə	dishwasher	9
4aa9f5c6-99a5-4d75-b753-54e3fc78e93c	2025-11-12 13:02:13.564103	2025-11-12 13:02:13.564112	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3d91db33-baae-475e-95ce-f4b6b2c69431.mp3?alt=media	B2		[Sport] Build endurance with training. | [Test] Endurance is key in marathons. | [Improvement] Increase endurance gradually.	\N	The ability to sustain prolonged physical or mental effort.	sức chịu đựng	ɪnˈdjʊərəns	endurance	6
1d840e64-0880-43ae-8d14-d7a3fba28fe4	2025-11-12 13:02:12.294365	2025-11-12 13:02:12.294388	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6f8ffc55-702a-40cb-8a45-b527571d1a75.mp3?alt=media	A2		[Shopping] The marketplace was bustling with vendors selling fresh produce. | [Culture] Visiting the local marketplace is a cultural experience. | [Food] She bought spices and fruits at the marketplace.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fa3c2db00-a1ab-4c4e-92a7-f76ce357333a.jpg?alt=media	A place where goods are bought and sold, often outdoors.	chợ	ˈmɑːrkɪtpleɪs	marketplace	10
f54abaf7-a969-4e42-b2ae-b68148732a97	2025-11-12 13:02:09.043622	2025-11-12 13:02:09.04372	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F60290668-034a-46ab-80b7-365eb961af8a.mp3?alt=media	A1		[Story] A traveler found a bread near the old bench. | [Work] The bread was recorded carefully in the report. | [Everyday] I put the bread on the bench before dinner.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F928c3111-e4b0-4f90-be86-0bdcde894193.jpeg?alt=media&token=7541f2a7-b9d7-4d33-a958-faf9afc8360d	A staple food made from flour and water, baked into various forms like loaves or rolls.	bánh mì	bred	bread	1
759bce7b-66d5-428d-802a-0e4c885d7faf	2025-11-12 13:02:09.092	2025-11-12 13:02:09.092057	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F68523d83-1011-4498-93c3-ad86306f0bb1.mp3?alt=media	A1		[Everyday] I put the milk on the table before dinner. | [Story] A traveler found a milk near the old table. | [School] The teacher asked us to describe a milk in two sentences.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F6e343263-f8ad-42ca-97d2-720ff871e711.jpeg?alt=media	A white liquid produced by mammals, commonly used as a drink or in cooking.	sữa	mɪlk	milk	1
ac23d750-ee93-4eb8-b87a-931ea23c5aee	2025-11-12 13:02:09.136139	2025-11-12 13:02:09.136203	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F93a5a571-4c23-426d-a956-5e71f4e204e6.mp3?alt=media	A1		[Description] That rice looks heavy in the afternoon light. | [Memory] This rice reminds me of my childhood in the countryside. | [Problem] The rice broke suddenly, so we had to fix it.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Ff96a1a8b-5f95-499a-9890-1b6bee481ffb.jpeg?alt=media	A grain that serves as a staple food in many cultures, often boiled or steamed.	gạo; cơm	raɪs	rice	1
7df11371-9269-472a-a403-5032e60a6823	2025-11-12 13:02:09.207598	2025-11-12 13:02:09.207635	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3389c71b-9568-4418-894d-ef175a1acc97.mp3?alt=media	A1	“Bowl of chicken soup.jpg” by RWS, source: https://commons.wikimedia.org/wiki/File:Bowl_of_chicken_soup.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).	[Hobby] He collects photos of soups from different countries. | [Shopping] She compared three soups and chose the freshest one. | [Memory] This soup reminds me of my childhood in the countryside.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fe4f4b040-844a-4e61-af2a-0b5aac7361cd.jpeg?alt=media	A liquid dish made by boiling ingredients like vegetables or meat in water or broth.	súp	suːp	soup	1
792b188b-298d-4293-b1b2-8a54e8f06134	2025-11-12 12:10:11.327857	2025-11-12 12:10:11.327903	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1b4ccd5d-921a-48db-afb9-33a2716beae4.mp3?alt=media	A1		[Advice] Keep the book away from sunlight to stay safe. | [School] The teacher asked us to describe a book in two sentences. | [Shopping] She compared three books and chose the freshest one.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F0645df59-423b-4bdd-98f7-3820501e46b9.jpg?alt=media	A collection of pages with text or images, used for reading or study.	cuốn sách	bʊk	book	3
334e8c87-444d-4985-92e2-6fca87b8b14e	2025-11-12 12:10:23.126298	2025-11-12 16:24:04.592561	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F282c6462-8f6f-41c6-ad6e-e556f5179265.mp3?alt=media	A2		[Art] Watch a film in the cinema. | [Culture] Cinema tells stories. | [Entertainment] Visit the local cinema.	\N	The art or industry of making films.	điện ảnh	ˈsɪnəmə	cinema	55
33cf8faf-0d02-47f5-910b-31f58f54c8e9	2025-11-12 13:02:09.243375	2025-11-12 13:02:09.243401	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdaf4e3c2-eaf4-4de3-a7f0-2f31de01d6a8.mp3?alt=media	A1		[Story] A traveler found a mother near the old counter. | [Work] The mother was recorded carefully in the report. | [Everyday] I put the mother on the counter before dinner.	\N	A female parent who nurtures and supports her children.	mẹ	ˈmʌðə	mother	2
f864585d-bdea-4e88-b945-69c4ccadb361	2025-11-12 13:02:09.98935	2025-11-12 13:02:09.989385	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F221657fb-be83-4c18-9882-027986ec2ea0.mp3?alt=media	A1		[Everyday] I put the cow on the table before dinner. | [Story] A traveler found a cow near the old table. | [School] The teacher asked us to describe a cow in two sentences.	\N	A large domesticated mammal kept for milk or meat.	bò	kaʊ	cow	7
e22c3939-dce7-4919-9d97-3e50f84c7715	2025-11-12 13:02:09.920976	2025-11-12 13:02:09.920996	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0dba90f0-e659-404b-8d4c-aa7e45478438.mp3?alt=media	A1		[Shopping] She compared three teams and chose the freshest one. | [Advice] Keep the team away from sunlight to stay safe. | [Hobby] He collects photos of teams from different countries.	\N	A group of players forming one side in a competitive game or sport.	đội	tiːm	team	6
26b5c93b-517a-4eb1-966f-0405438b0f87	2025-11-12 13:02:10.623726	2025-11-12 13:02:10.623741	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F32be19f7-86c7-4283-be34-585288c9fc27.mp3?alt=media	A1		[Story] A traveler found a angry near the old bench. | [Work] The angry was recorded carefully in the report. | [Everyday] I put the angry on the bench before dinner.	\N	Feeling or showing strong annoyance or displeasure.	tức giận	ˈæŋɡri	angry	12
2cece5fb-67f3-4b3c-bc11-99d26302e376	2025-11-12 13:02:11.47502	2025-11-12 13:02:11.475034	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa357880f-af6b-4d4a-96b4-564508ef38a1.mp3?alt=media	A1		[Baking] Add two spoons of sugar to the cake batter for sweetness. | [Health] Too much sugar can lead to health problems like diabetes. | [Culture] In some countries, sugar cubes are served with coffee.	\N	A sweet crystalline substance used in food and drink.	đường	ˈʃʊɡə	sugar	1
5d558b44-904c-4509-be28-ae9e2389af8b	2025-11-12 13:02:11.572402	2025-11-12 13:02:11.57242	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1656f10a-eb7d-44cf-bfad-cecf0cd114b2.mp3?alt=media	A1		[Visit] Aunt baked cookies for us when we came to her house. | [Tradition] My aunt teaches me traditional songs every summer. | [Support] Aunt helped organize the charity event in our town.	\N	The sister of oneâ€™s parent.	cô/dì	ɑːnt	aunt	2
86baac9e-f5f7-43f7-9f66-3b883380bb3d	2025-11-12 13:02:11.70677	2025-11-12 13:02:11.706798	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F83567f4c-c4f2-4804-981a-8a2bd72f1a64.mp3?alt=media	B1		[Business] They signed a contract to start the new partnership. | [Work] The contract outlined the job responsibilities clearly. | [Legal] She reviewed the contract with a lawyer before agreeing.	\N	A written or spoken agreement enforceable by law.	hợp đồng	ˈkɒntrækt	contract	4
13bade7f-64bd-4a8e-9bb9-b92a2207bc7a	2025-11-12 13:02:12.088075	2025-11-12 13:02:12.088089	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1c7d937f-cb65-4e0c-a1ef-196ffa5b5741.mp3?alt=media	A1		[Weather] The rain forced us to cancel the outdoor picnic. | [Agriculture] Farmers welcomed the rain after a long drought. | [Mood] She loved the sound of rain tapping on the window.	\N	Water falling in drops from the atmosphere.	mưa	reɪn	rain	8
299c3c82-8ced-42df-b8e5-ac682da0664c	2025-11-12 13:02:12.335275	2025-11-12 13:02:12.335293	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F34fd020f-eb4a-4963-84cd-5512c8748f4b.mp3?alt=media	A2		[City] The town square was decorated for the holiday festival. | [Protest] People gathered in the square to demand change. | [Tourism] The square was filled with street performers and tourists.	\N	An open public space in a city, often square-shaped.	quảng trường	skweə	square	10
d2768678-b708-4936-a9ff-440c5bbbaf47	2025-11-12 13:02:09.414706	2025-11-12 13:02:09.41474	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd068c92b-d430-492d-9415-f44b5ae7ab0e.mp3?alt=media	A1		[School] The teacher asked us to describe a child in two sentences. | [Everyday] I put the child on the wall before dinner. | [Advice] Keep the child away from fire to stay safe.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fccfdd73c-ecf6-472c-ba3b-29afead767d8.jpg?alt=media	A young human, typically under the age of puberty.	trẻ em	tʃaɪld	child	2
b4250cbd-09ca-4e26-bf46-9ae807496675	2025-11-12 13:02:09.577361	2025-11-12 13:02:09.577396	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F74c0cd3c-d82b-4ca8-806f-61d1c7a94d4f.mp3?alt=media	A2		[Work] The exam was recorded carefully in the report. | [Problem] The exam broke suddenly, so we had to fix it. | [Story] A traveler found a exam near the old doorway.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F36a6445a-91bc-4e2a-b486-651b082f5428.jpg?alt=media	A test to assess knowledge or skills.	kỳ thi	ɪɡˈzæm	exam	3
46b9fb76-bf31-4ccb-8335-f3cc9ecdb6c1	2025-11-12 13:02:11.659641	2025-11-12 16:24:00.389139	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd1699a70-a102-4555-b48d-f15239fca3f9.mp3?alt=media	A2		[School] The assignment on literature was due by next Monday. | [Work] He completed the assignment before the team meeting. | [Study] She organized her notes to tackle the tough assignment.	\N	A task or piece of work allocated to someone as part of a job or study.	bài tập	əˈsaɪnmənt	assignment	3
262063d0-86d2-4f4e-997d-28faa6349590	2025-11-12 13:02:10.802423	2025-11-12 16:23:57.821725	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9fa052ef-6bf9-45b9-9eb2-3524e6d17df4.mp3?alt=media	B2		[Story] A traveler found a conservation near the old counter. | [Work] The conservation was recorded carefully in the report. | [Everyday] I put the conservation on the counter before dinner.	\N	The protection of plants, animals, and natural resources.	bảo tồn	ˌkɒnsəˈveɪʃn	conservation	13
4e60fe3f-1c3f-4fa1-a0e8-698320b0380c	2025-11-12 13:02:11.273406	2025-11-12 16:24:02.129325	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fcba6aefa-786f-440b-948f-f30354bb8ea4.mp3?alt=media	A2		[Work] The painting was recorded carefully in the report. | [Problem] The painting broke suddenly, so we had to fix it. | [Story] A traveler found a painting near the old bench.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fe74fe7ec-d764-4291-ad9c-de949a1b9854.jpg?alt=media	The practice of applying paint to a surface.	bức tranh	ˈpeɪntɪŋ	painting	19
9a503c37-5881-4093-9601-ccf4212a38a3	2025-11-12 13:02:10.925819	2025-11-12 13:02:10.925836	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F208c4b0a-5176-41dc-b2c0-7f6c1a3181cb.mp3?alt=media	B2		[Advice] Keep the theory away from children to stay safe. | [School] The teacher asked us to describe a theory in two sentences. | [Shopping] She compared three theories and chose the freshest one.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fa6142baa-a832-413d-8f4c-e66d77d276f6.jpg?alt=media	A system of ideas to explain something, based on general principles.	lý thuyết	ˈθɪəri	theory	15
f04aec5d-05a1-4a93-8146-4e24cb116317	2025-11-12 13:02:09.879797	2025-11-12 13:02:09.87982	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fec95e267-4561-41ee-9274-7ad95b80afce.mp3?alt=media	A1	“Basketball game.jpg” by Kelly Bailey, source: https://commons.wikimedia.org/wiki/File:Basketball_game.jpg, license: CC BY 2.0 (https://creativecommons.org/licenses/by/2.0/).	[Problem] The basketball broke suddenly, so we had to fix it. | [Description] That basketball looks safe in the afternoon light. | [Work] The basketball was recorded carefully in the report.	\N	A game played by two teams of five players with a ball thrown into a basket.	bóng rổ	ˈbɑːskɪtbɔːl	basketball	6
5bae7d43-6678-4494-b5ac-bd401f22b928	2025-11-12 13:02:12.463448	2025-11-12 13:02:12.463463	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F628ed695-d299-4d89-bd13-bd87f1114a30.mp3?alt=media	A2		[Class] He was bored during the long lecture on history. | [Home] She felt bored and decided to watch a movie. | [Activity] Playing the same game made the kids bored quickly.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Ff8325c27-7574-477f-9ab6-a00fdfa0c182.jpg?alt=media	Feeling uninterested or lacking engagement.	nhàm chán	bɔːrd	bored	12
fbd38cd6-7dbe-48db-834e-dedf519f22ec	2025-11-12 12:10:12.443711	2025-11-12 12:10:12.443742	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F77a6ab69-0201-4056-ab0a-07e88ab43021.mp3?alt=media	A1	“Sun in the sky.jpg” by NASA, source: https://commons.wikimedia.org/wiki/File:Sun_in_the_sky.jpg, license: Public Domain (https://creativecommons.org/publicdomain/mark/1.0/).	[Description] That sun looks heavy in the afternoon light. | [Memory] This sun reminds me of my childhood in the countryside. | [Problem] The sun broke suddenly, so we had to fix it.	\N	The star at the center of our solar system, providing light and heat.	mặt trời	sʌn	sun	8
4f412954-3b79-441f-a851-04a7acb4302c	2025-11-12 13:02:10.673064	2025-11-12 13:02:10.673082	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4adca986-fdb3-4bd8-94b3-7cf7912a5eaa.mp3?alt=media	B1		[Everyday] I put the confident on the floor before dinner. | [Story] A traveler found a confident near the old floor. | [School] The teacher asked us to describe a confident in two sentences.	\N	Feeling certain about one's abilities or qualities.	tự tin	ˈkɒnfɪdənt	confident	12
992cd1bf-d08a-4637-99a6-6e21aa69dd2e	2025-11-12 13:02:11.93532	2025-11-12 13:02:11.935335	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa966d5f9-b876-4faf-8ba9-14550f170422.mp3?alt=media	A1		[School] The sport event included soccer and volleyball matches. | [Hobby] Playing a sport like tennis is a fun way to stay active. | [Community] The town built a new sport complex for residents.	\N	An activity involving physical exertion and skill.	thể thao	spɔːrt	sport	6
84c7ea29-f93d-48ed-8dc5-4bfd37d55893	2025-11-12 13:02:11.176877	2025-11-12 13:02:11.176891	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4d71dad9-03cd-49a8-aa34-1a4f6df937d8.mp3?alt=media	B1		[Hobby] He collects photos of losses from different countries. | [Shopping] She compared three losses and chose the freshest one. | [Memory] This loss reminds me of my childhood in the countryside.	\N	The fact or process of losing something, especially money.	thua lỗ	lɒs	loss	18
b78b3a93-8ab4-486a-a3b5-934bdca032c5	2025-11-12 13:02:11.376502	2025-11-12 13:02:11.376515	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb05682b9-9c34-45b2-83a9-e88127ff9fd5.mp3?alt=media	B1		[Travel] We subscribeed through the old town and took photos. | [Tip] If you subscribe too fast at the start, you'll get tired quickly. | [Goal] She plans to subscribe farther than last week.	\N	To arrange to receive something regularly, typically a publication or service.	đăng ký (kênh)	səbˈskraɪb	subscribe	20
643ca149-470f-43b1-b04e-d0ef59fb3544	2025-11-12 13:02:09.68814	2025-11-12 13:02:09.688175	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7c48d93c-8e8e-4725-bcb6-000673663082.mp3?alt=media	A1		[Story] A traveler found a nurse near the old wall. | [Work] The nurse was recorded carefully in the report. | [Everyday] I put the nurse on the wall before dinner.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fb1a1b2c5-0714-4a75-8942-3f93fb334d4f.jpg?alt=media	A person trained to care for the sick or infirm.	y tá; điều dưỡng	nɜːs	nurse	4
3e902e56-5be7-44f3-b720-78453268523b	2025-11-12 13:02:09.803512	2025-11-12 13:02:09.803531	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F58b55f23-0c84-4538-bcfe-011f06f48ba8.mp3?alt=media	A1		[Advice] Keep the hotel away from pets to stay safe. | [School] The teacher asked us to describe a hotel in two sentences. | [Shopping] She compared three hotels and chose the freshest one.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Faaa7b296-e49a-439e-ab7f-57bc0eaf5ef2.jpg?alt=media	A building providing lodging and usually meals for the public.	khách sạn	həʊˈtel	hotel	5
fb1cb2f1-efd5-47cd-82ef-9d437a62acd9	2025-11-12 13:02:09.604526	2025-11-12 13:02:09.604549	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6a2f3d0d-e371-4b16-8c25-ac9b23ed1691.mp3?alt=media	A1		[Everyday] I put the subject on the bag before dinner. | [Story] A traveler found a subject near the old bag. | [School] The teacher asked us to describe a subject in two sentences.	\N	A specific area of study, like math or history.	môn học	ˈsʌbdʒɪkt	subject	3
9b448f19-c664-4082-a61c-b1db3029fb6c	2025-11-12 13:02:11.264049	2025-11-12 16:24:02.065168	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe1d36765-4dfa-4a7e-898e-8a1dc30835b7.mp3?alt=media	B2		[Advice] Keep the drama away from rain to stay safe. | [School] The teacher asked us to describe a drama in two sentences. | [Shopping] She compared three dramas and chose the freshest one.	\N	A play for theater, radio, or television.	kịch	ˈdrɑːmə	drama	19
c65b7bc6-c470-4b7b-8ba1-c76d322385bb	2025-11-12 13:02:10.723442	2025-11-12 16:23:57.916677	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F07376ec3-174c-43a2-851c-64ad015800ef.mp3?alt=media	B1		[Work] The pollution was recorded carefully in the report. | [Problem] The pollution broke suddenly, so we had to fix it. | [Story] A traveler found a pollution near the old doorway.	\N	The presence of harmful substances in the environment.	ô nhiễm	pəˈluːʃn	pollution	13
0841a70f-c509-47f2-92e4-236a48797f80	2025-11-12 13:02:10.171881	2025-11-12 13:02:10.17193	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F529b560c-4b7d-46ab-95f6-39b1b0e6b7cd.mp3?alt=media	A1		[Hobby] He collects photos of grasses from different countries. | [Shopping] She compared three grasses and chose the freshest one. | [Memory] This grass reminds me of my childhood in the countryside.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fe09ba29e-ece3-4b4e-8299-882c10b6285c.jpg?alt=media	A low green plant that covers the ground in lawns or fields.	cỏ	ɡrɑːs	grass	8
6ed690b4-9db2-4f67-8658-7de753790982	2025-11-12 13:02:09.741533	2025-11-12 13:02:09.741552	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe3f0f4cd-023d-4e84-81ec-538c1fcccbe7.mp3?alt=media	A1		[Work] The bus was recorded carefully in the report. | [Problem] The bus broke suddenly, so we had to fix it. | [Story] A traveler found a bus near the old counter.	\N	A large vehicle carrying many passengers, used for public transport.	xe buýt	bʌs	bus	5
7bc58a91-c278-40a7-b3ef-70970091f075	2025-11-12 13:02:09.973594	2025-11-12 13:02:09.973614	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa5bd357a-c874-4080-be86-afcd36867d35.mp3?alt=media	A1		[School] The teacher asked us to describe a bird in two sentences. | [Everyday] I put the bird on the wall before dinner. | [Advice] Keep the bird away from noise to stay safe.	\N	A warm-blooded egg-laying vertebrate with feathers and wings.	chim	bɜːd	bird	7
73c3d22f-3c66-44f5-a7c4-1203d86fd0ea	2025-11-12 13:02:10.210613	2025-11-12 13:02:10.210631	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc59146c2-97b5-4fc4-aa99-b9ac9fb5b01d.mp3?alt=media	A1	“Calm sea.jpg” by Jorge Morales Piderit, source: https://commons.wikimedia.org/wiki/File:Calm_sea.jpg, license: CC BY 2.0 (https://creativecommons.org/licenses/by/2.0/).	[School] The teacher asked us to describe a sea in two sentences. | [Everyday] I put the sea on the bench before dinner. | [Advice] Keep the sea away from heat to stay safe.	\N	A large body of salt water covering much of the earth's surface.	biển	siː	sea	8
4768a173-79cc-4d2d-a316-bd702fca5929	2025-11-12 12:10:12.580953	2025-11-12 12:10:12.58098	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F44853642-1f5b-4ebd-b02b-47f62852584c.mp3?alt=media	A1	“House in countryside.jpg” by Rufus46, source: https://commons.wikimedia.org/wiki/File:House_in_countryside.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).	[Hobby] He collects photos of houses from different countries. | [Shopping] She compared three houses and chose the freshest one. | [Memory] This house reminds me of my childhood in the countryside.	\N	A building for human habitation.	ngôi nhà	haʊs	house	9
3e9e2393-36ab-44ad-b83a-e731bf296439	2025-11-12 13:02:10.257297	2025-11-12 13:02:10.257317	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fab9e57c8-742a-4f24-9daf-a2642f368066.mp3?alt=media	A1	“Wooden table.jpg” by Evan-Amos, source: https://commons.wikimedia.org/wiki/File:Wooden_table.jpg\n, license: CC0 1.0 (https://creativecommons.org/publicdomain/zero/1.0/\n).	[Work] The table was recorded carefully in the report. | [Problem] The table broke suddenly, so we had to fix it. | [Story] A traveler found a table near the old counter.	\N	A piece of furniture with a flat top and legs, used for eating or working.	bàn	ˈteɪbl	table	9
37f9f568-89fb-4b8a-9838-9bd55bb201b5	2025-11-12 12:10:12.719696	2025-11-12 12:10:12.719729	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Faf0dcaa4-1d43-41a4-9d8c-17d7eb8e1f26.mp3?alt=media	A1	“New York City skyline.jpg” by King of Hearts, source: https://commons.wikimedia.org/wiki/File:New_York_City_skyline.jpg, license: CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/).	[Story] A traveler found a city near the old floor. | [Work] The city was recorded carefully in the report. | [Everyday] I put the city on the floor before dinner.	\N	A large town with many inhabitants.	thành phố	ˈsɪti	city	10
bf212564-97ea-4455-95af-6be8bcc87876	2025-11-12 13:02:10.358268	2025-11-12 13:02:10.358292	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd9cd11ba-93ea-4d5a-bd6e-7968251955c5.mp3?alt=media	A1	“Shop interior.jpg” by MOs810, source: https://commons.wikimedia.org/wiki/File:Shop_interior.jpg, license: CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/).	[Memory] This shop reminds me of my childhood in the countryside. | [Hobby] He collects photos of shops from different countries. | [Description] That shop looks modern in the afternoon light.	\N	A place where goods are sold.	cửa hàng	ʃɒp	shop	10
9f75f6b5-353d-46f7-ad0f-d749047c6c89	2025-11-12 13:02:11.09575	2025-11-12 13:02:11.095764	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffdf35a69-28ff-4e82-8b73-afed7f75eb68.mp3?alt=media	B1		[Memory] This judge reminds me of my childhood in the countryside. | [Hobby] He collects photos of judges from different countries. | [Description] That judge looks modern in the afternoon light.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F91fe70e2-5a2e-4ad5-bff1-38b83ef5bea6.jpg?alt=media	A public official appointed to decide cases in a court of law.	thẩm phán	dʒʌdʒ	judge	17
bfb374a3-96af-4ce9-8095-44a74f8f1789	2025-11-12 13:02:10.418336	2025-11-12 13:02:10.418359	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fddf967c0-3b0b-407f-a31d-958d4fe46b74.mp3?alt=media	A2	“Restaurant interior.jpg” by Jorge Royan, source: https://commons.wikimedia.org/wiki/File:Restaurant_interior.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).	[Advice] Keep the restaurant away from water to stay safe. | [School] The teacher asked us to describe a restaurant in two sentences. | [Shopping] She compared three restaurants and chose the freshest one.	\N	A place where meals are served to customers.	nhà hàng	ˈrest(ə)rɒnt	restaurant	10
d6cbea4c-f5b2-4f4c-8765-ae68ecc45cef	2025-11-12 13:02:12.493881	2025-11-12 13:02:12.493895	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F56f451d3-55c8-4026-97d3-fdd1b72c7ff1.mp3?alt=media	B1		[Future] She was hopeful about her chances of getting the job. | [Event] The team felt hopeful after a strong practice session. | [Dream] He remained hopeful that his goals would come true.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F329690f2-a353-4b0c-a216-88fd746fb6a3.jpg?alt=media	Feeling optimistic about a future outcome.	lạc quan	ˈhəʊpfl	hopeful	12
5f95b153-2ea6-4373-958a-f165612d23bb	2025-11-12 13:02:09.943939	2025-11-12 16:23:44.260846	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc2557239-7f01-47f4-8d0c-a818c79b1f23.mp3?alt=media	A2		[Problem] The coach broke suddenly, so we had to fix it. | [Description] That coach looks safe in the afternoon light. | [Work] The coach was recorded carefully in the report.	\N	A person who trains and directs athletes or teams.	huấn luyện viên	kəʊtʃ	coach	6
a2a329f2-4f33-43ff-a562-ce3407cba32e	2025-11-12 13:02:12.564892	2025-11-12 13:02:12.564906	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F21f3dce9-67c8-4d2c-9ec5-c2777d31d5fb.mp3?alt=media	B1		[Conservation] Wildlife sanctuaries protect endangered species. | [Travel] We saw incredible wildlife on the safari tour. | [Education] The book teaches kids about wildlife in different regions.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fd53bbcf5-786d-4872-ad0c-047153f6684b.jpg?alt=media	Animals living in their natural environment.	động vật hoang dã	ˈwaɪldlaɪf	wildlife	13
e28ea120-607e-4bf4-b437-8009011bc135	2025-11-12 13:02:11.455421	2025-11-12 13:02:11.455455	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F322e281c-20cf-48e3-b408-d0f249e9cab8.mp3?alt=media	A1		[Cooking] Chop the vegetables finely for a colorful stir-fry dish. | [Shopping] She bought fresh vegetables from the local farmer’s market. | [Health] Eating a variety of vegetables improves your overall nutrition.	\N	A plant or part of a plant used as food.	rau củ	ˈvedʒtəbl	vegetable	1
7e7d5bc3-7bb9-4cbe-b913-990c12239456	2025-11-12 13:02:11.598722	2025-11-12 13:02:11.598737	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F89202332-6ac2-4f5d-8956-ab598200786b.mp3?alt=media	A1		[Class] The student raised her hand to answer the teacher’s question. | [Study] He stayed late in the library as a student preparing for exams. | [Event] The student organized a science fair for the school.	\N	A person who is studying at a school or college.	học sinh; sinh viên	ˈstuːdnt	student	3
c44295e9-2449-46c0-8f0b-1bb26c8d1fe1	2025-11-12 13:02:12.184527	2025-11-12 13:02:12.184542	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F81710e44-5e35-4446-98f5-fbde9b1da7af.mp3?alt=media	A1		[Home] The kitchen smelled amazing with freshly baked bread. | [Renovation] They installed new cabinets in the kitchen last month. | [Cooking] She spent hours in the kitchen preparing a feast.	\N	A room or area where food is prepared and cooked.	nhà bếp	ˈkɪtʃɪn	kitchen	9
582219c5-7c94-4022-b4b0-31fdf2536af5	2025-11-12 13:02:12.285738	2025-11-12 13:02:12.285753	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F736bcca5-ec22-44b2-aed5-f5bd6d72f9e3.mp3?alt=media	A1		[City] The bridge lit up beautifully at night with colorful lights. | [Travel] We crossed the old stone bridge to reach the village. | [Engineering] The bridge was designed to withstand earthquakes.	\N	A structure carrying a road or path across a river or other obstacle.	cầu	brɪdʒ	bridge	10
da9da278-9fa1-43b0-87cd-594826a0fcd8	2025-11-12 13:02:12.32667	2025-11-12 13:02:12.326684	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F53a7d20d-d16b-45b2-99b7-c3e071e72b65.mp3?alt=media	A1		[Home] She planted roses and tulips in her garden. | [Relaxation] The garden was a quiet place to read and relax. | [Community] The city garden hosts summer concerts for residents.	\N	A piece of land used for growing flowers, vegetables, or plants.	vườn	ˈɡɑːrdn	garden	10
434c2f44-4dca-402b-972f-d501ce23ff24	2025-11-12 13:02:10.532123	2025-11-12 13:02:10.532139	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F581723ed-55d2-411f-8002-dd7f7d20fe19.mp3?alt=media	A2		[Shopping] She compared three screens and chose the freshest one. | [Advice] Keep the screen away from dust to stay safe. | [Hobby] He collects photos of screens from different countries.	\N	The flat surface of a device where images and data are displayed.	màn hình	skriːn	screen	11
5b77ceb8-17f7-4292-aecb-82738d019867	2025-11-12 13:02:10.757938	2025-11-12 13:02:10.75802	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fea7f9e4f-f113-40a1-9c56-c4c05e7e1723.mp3?alt=media	B2		[Problem] The global warming broke suddenly, so we had to fix it. | [Description] That global warming looks safe in the afternoon light. | [Work] The global warming was recorded carefully in the report.	\N	The increase in the earth's average temperature due to greenhouse gases.	nóng lên toàn cầu	ˌɡləʊbl ˈwɔːmɪŋ	global warming	13
a0c97f84-a9f3-4d25-bf3c-acd9ee8917b5	2025-11-12 12:10:13.55174	2025-11-12 16:24:00.567189	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F62be964c-5e49-48e8-86ca-65310261cdd4.mp3?alt=media	B2		[Everyday] I put the scholarship on the window before dinner. | [Story] A traveler found a scholarship near the old window. | [School] The teacher asked us to describe a scholarship in two sentences.	\N	A grant or payment made to support a student's education.	học bổng	ˈskɒləʃɪp	scholarship	16
476f1a64-b192-43b3-b82d-b63f25e66a0b	2025-11-12 13:02:12.590736	2025-11-12 16:24:04.157618	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F38fe856d-9e9c-4936-a3b4-5665800049eb.mp3?alt=media	B1		[Theater] The performance of the play received a standing ovation. | [Music] Her piano performance was flawless and moving. | [Event] The street performance attracted a large crowd.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc4ac1a01-5e4c-48cd-9144-cf7028e3c452.jpg?alt=media	An act of presenting a play, concert, or other form of entertainment.	biểu diễn	pəˈfɔːrməns	performance	14
cd851ffa-8933-4259-ba6f-13d3adae1e00	2025-11-12 13:02:10.866313	2025-11-12 16:24:04.204844	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F792397e0-57c9-475a-b789-73c3708a99e5.mp3?alt=media	B1		[School] The teacher asked us to describe a costume in two sentences. | [Everyday] I put the costume on the doorway before dinner. | [Advice] Keep the costume away from dust to stay safe.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc43cddac-0489-4992-8443-214879d8270a.jpg?alt=media	A set of clothes worn for a particular occasion or performance.	trang phục	ˈkɒstjuːm	costume	14
6ebf5a8e-0735-4c50-9eaf-906fe05d5b96	2025-11-12 13:02:10.598907	2025-11-12 16:24:07.930121	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F236f27e3-b628-4d96-8904-0815d999802d.mp3?alt=media	C1		[Hobby] He collects photos of cybersecurities from different countries. | [Shopping] She compared three cybersecurities and chose the freshest one. | [Memory] This cybersecurity reminds me of my childhood in the countryside.	\N	The practice of protecting systems, networks, and programs from digital attacks.	an ninh mạng	ˌsaɪbəsɪˈkjʊərəti	cybersecurity	11
44d84416-0007-4779-9a66-4f324ed3dc72	2025-11-12 13:02:11.244649	2025-11-12 16:24:08.731481	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb8ecf4b8-151a-4010-b2eb-545683bac630.mp3?alt=media	C1		[Description] That entrepreneur looks heavy in the afternoon light. | [Memory] This entrepreneur reminds me of my childhood in the countryside. | [Problem] The entrepreneur broke suddenly, so we had to fix it.	\N	A person who sets up a business, taking on financial risks.	doanh nhân khởi nghiệp	ˌɒntrəprəˈnɜː	entrepreneur	18
5fe97aa5-68d8-4879-803d-61e3968021b3	2025-11-12 13:02:11.086556	2025-11-12 13:02:11.086572	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff481c4be-67fc-4215-9660-d2402ae7a8a5.mp3?alt=media	B1		[Description] That court looks heavy in the afternoon light. | [Memory] This court reminds me of my childhood in the countryside. | [Problem] The court broke suddenly, so we had to fix it.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fb088aa11-9417-4724-aa8e-6f06b934e227.jpg?alt=media	A place where legal cases are heard.	tòa án	kɔːt	court	17
ce830192-718f-41fb-b3fe-9082c80d7c71	2025-11-12 13:02:11.016783	2025-11-12 13:02:11.016827	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd35e73b6-726c-4df0-95c3-2b1edf660aed.mp3?alt=media	B2		[Description] That literacy looks heavy in the afternoon light. | [Memory] This literacy reminds me of my childhood in the countryside. | [Problem] The literacy broke suddenly, so we had to fix it.	\N	The ability to read and write.	khả năng đọc viết	ˈlɪtərəsi	literacy	16
46d30020-2aca-4abf-ba2d-70b263253879	2025-11-12 13:02:11.057237	2025-11-12 13:02:11.057253	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbbdae01d-07e9-4309-ba00-5e854134eacb.mp3?alt=media	B2		[School] The teacher asked us to describe a graduate in two sentences. | [Everyday] I put the graduate on the bench before dinner. | [Advice] Keep the graduate away from dust to stay safe.	\N	A person who has successfully completed a course of study.	tốt nghiệp; cử nhân	ˈɡrædʒuət	graduate	16
0b677710-8b1f-4ae2-9d28-276983427c63	2025-11-12 13:02:11.977575	2025-11-12 13:02:11.977596	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4099c386-fe01-4751-ad61-33fd22adebbb.mp3?alt=media	A1		[Home] The pet dog greeted us happily at the door. | [Care] She spends time every day feeding and walking her pet. | [Adoption] They decided to adopt a pet from the local shelter.	\N	A domesticated animal kept for companionship.	thú cưng	pet	pet	7
41e2ad95-e15f-4086-b147-6111f5fc49b0	2025-11-12 13:02:12.03799	2025-11-12 13:02:12.038004	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6ff4f320-a1d7-4c70-924c-6b17e4ce104a.mp3?alt=media	A1		[Nature] The wolf howled under the full moon in the forest. | [Myth] Wolves are often portrayed as mysterious in folklore. | [Conservation] Efforts are underway to protect wolves in the region.	\N	A wild carnivorous mammal, often living in packs.	sói	wʊlf	wolf	7
14d9fc8c-d5f8-4891-97e7-6f9dc8140b25	2025-11-12 13:02:11.156873	2025-11-12 13:02:11.156887	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd9120463-c911-40d1-b54d-0cae029000c4.mp3?alt=media	C1		[Advice] Keep the constitution away from traffic to stay safe. | [School] The teacher asked us to describe a constitution in two sentences. | [Shopping] She compared three constitutions and chose the freshest one.	\N	A body of fundamental principles by which a nation is governed.	hiến pháp	ˌkɒnstɪˈtjuːʃn	constitution	17
4cb5142a-d164-4327-ab35-2e7114828ccb	2025-11-12 13:02:11.328584	2025-11-12 13:02:11.328606	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe55e6218-2fbc-407e-be78-f424b9ddaa45.mp3?alt=media	B1		[School] The teacher asked us to describe a comment in two sentences. | [Everyday] I put the comment on the wall before dinner. | [Advice] Keep the comment away from dust to stay safe.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F660b638d-d34d-490c-a57d-4ea622ca24c3.png?alt=media	A verbal or written remark expressing an opinion or reaction.	bình luận	ˈkɒment	comment	20
ccea1431-c9a8-4a61-a618-d0cc578717db	2025-11-12 13:02:11.544963	2025-11-12 13:02:11.54498	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa88c17fd-df6f-462a-9a6c-5c5600d3a3a8.mp3?alt=media	A1		[Party] I invited my friend to the birthday celebration at home. | [Support] My friend helped me move furniture into my new apartment. | [School] We worked together with my friend on a group project.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F779f92b8-3547-4bc6-b98e-7a52314c7795.jpg?alt=media	A person with whom one has a bond of mutual affection.	bạn bè	frend	friend	2
2321a95b-c48e-4d11-b400-e7fc1e79e97d	2025-11-12 13:02:11.301521	2025-11-12 13:02:11.301539	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa2667c0a-c86a-42a9-ae04-97e9207ad5ec.mp3?alt=media	B2		[Problem] The critic broke suddenly, so we had to fix it. | [Description] That critic looks safe in the afternoon light. | [Work] The critic was recorded carefully in the report.	\N	A person who expresses an unfavorable opinion of something or reviews art.	nhà phê bình	ˈkrɪtɪk	critic	19
3971a4e1-6044-4e26-a866-555395e5ee10	2025-11-12 13:02:13.468384	2025-11-12 13:02:13.46839	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb1f16e50-5a91-41cc-83c1-aad20d5e9cd0.mp3?alt=media	B1		[Travel] Apply for a tourist visa. | [Document] Check visa requirements. | [Entry] Get visa on arrival.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F0136b2b1-8be4-45a9-9836-ef812e253669.jpg?alt=media	An official document allowing entry to a country.	thị thực	ˈviːzə	visa	5
8f6cd00b-6784-4e6e-88dd-76984709d7dd	2025-11-12 13:02:11.435674	2025-11-12 13:02:11.435688	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5422391f-505e-4c40-81ca-811be217699b.mp3?alt=media	A1		[Breakfast] Pour orange juice into glasses for a refreshing start to the day. | [Fitness] After workout, she drank vegetable juice to replenish nutrients. | [Market] The vendor squeezed fresh juice from fruits right in front of customers.	\N	A drink made from the extraction of liquid from fruits or vegetables.	nước ép	dʒuːs	juice	1
b04b6920-9b1e-4790-844b-91c54551142d	2025-11-12 13:02:11.632497	2025-11-12 13:02:11.632512	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa1f48639-88a3-4207-b119-3ce178bbe461.mp3?alt=media	A1		[Classroom] The teacher used chalk to draw a diagram on the blackboard. | [Art] Kids drew hopscotch on the pavement with colorful chalk. | [Memory] The smell of chalk reminded her of her old school days.	\N	A soft white limestone used for writing on blackboards.	phấn viết bảng	tʃɔːk	chalk	3
60ac6b50-c0d7-41c5-8390-a47b154165e1	2025-11-12 13:02:11.678008	2025-11-12 13:02:11.678028	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbb870426-e30c-490d-bc6f-23faff958b35.mp3?alt=media	A1		[Routine] She studies for two hours every evening to prepare for exams. | [Research] The study on climate change was published last week. | [Library] He found a quiet corner to study in peace.	\N	The act of learning or revising academic subjects.	học tập	ˈstʌdi	study	3
9d6b4239-3e2d-445e-a02e-22c73a3d01e0	2025-11-12 13:02:11.765507	2025-11-12 13:02:11.765523	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F323c06f4-9d22-4b37-8ef2-b2e6ea407939.mp3?alt=media	B1		[Experience] The intern gained valuable skills during the summer program. | [Work] She worked as an intern at a tech startup last year. | [Opportunity] The intern impressed the team with her dedication.	\N	A student or trainee who works to gain experience.	thực tập sinh	ˈɪntɜːrn	intern	4
19284869-c16c-44e9-aac6-52b29c46f382	2025-11-12 13:02:11.835311	2025-11-12 13:02:11.835327	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F17491db6-54ad-46f4-8351-b970fca917f5.mp3?alt=media	A1		[Travel] The train station was crowded with morning commuters. | [Waiting] We met at the station before heading to the festival. | [City] The bus station is just a short walk from the hotel.	\N	A place where trains or buses regularly stop.	ga; trạm	ˈsteɪʃn	station	5
9d291b05-5a0b-4b97-90fd-a0eea3e012cf	2025-11-12 13:02:12.715649	2025-11-12 13:02:12.715664	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F63f79691-1ea5-42c0-9441-68c6145ff28b.mp3?alt=media	B2		[Education] The seminar on leadership was very inspiring. | [Work] She attended a seminar to learn about new technologies. | [Event] The university hosted a seminar on global health.	\N	A meeting for discussion or training on a specific topic.	hội thảo	ˈsemɪnɑːr	seminar	16
d2b774ce-6b44-47a0-9f5c-e95c468d57b4	2025-11-12 13:02:11.925426	2025-11-12 13:02:11.925442	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb02c472b-fe61-41c3-b5b5-fd1d474854e6.mp3?alt=media	A1		[Advice] Good health requires a balanced diet and exercise. | [Checkup] She visited the doctor for a health assessment. | [Community] The campaign promoted mental health awareness.	\N	The state of being free from illness or injury.	sức khỏe	helθ	health	6
041d10f3-10cd-41fb-9e8b-8e7fb3fa7365	2025-11-12 13:02:12.107448	2025-11-12 13:02:12.107465	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffc3ee64a-19ea-4038-8d18-a75fa1c05c50.mp3?alt=media	A1		[Hiking] We explored the forest and found a hidden waterfall. | [Conservation] Protecting forests helps maintain biodiversity. | [Story] The forest was the setting for a magical adventure.	\N	A large area covered with trees and undergrowth.	rừng	ˈfɒrɪst	forest	8
3eb1cac3-39a0-4abc-bdeb-6e8f8448e573	2025-11-12 13:02:12.223257	2025-11-12 13:02:12.223272	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F004dd9a7-bd6b-44d9-b339-204684856a4c.mp3?alt=media	A1		[Decor] The lamp added a warm glow to the living room. | [Study] She turned on the desk lamp to read late at night. | [Shopping] They found a vintage lamp at the flea market.	\N	A device for giving light, typically portable.	đèn	læmp	lamp	9
f81b9942-d3bd-47fd-9977-a0c1c2a14cfc	2025-11-12 13:02:12.310577	2025-11-12 13:02:12.3106	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fffe49184-3323-4979-a931-4b213112e9a6.mp3?alt=media	A1		[Community] The church hosted a charity event for the homeless. | [History] The old church was a landmark in the small town. | [Celebration] They got married in a beautiful church ceremony.	\N	A building used for Christian worship.	nhà thờ	tʃɜːrtʃ	church	10
0dcfdb9f-fa2f-4bb0-a206-4cdf472a09c4	2025-11-12 13:02:12.436204	2025-11-12 13:02:12.436217	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Faf0e26dd-d10a-4f42-9e05-a2a8b1a3c1f0.mp3?alt=media	A2		[Performance] She felt nervous before her piano recital. | [Interview] He was nervous but prepared for the job interview. | [Situation] The loud noise made the dog nervous and jumpy.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Ff347bb8f-e538-44a2-88f3-122d24c41395.jpg?alt=media	Feeling uneasy or apprehensive about something.	lo lắng	ˈnɜːrvəs	nervous	12
989e56df-f77f-4833-861a-f0d483d14851	2025-11-12 13:02:12.508887	2025-11-12 13:02:12.508907	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdfd4718a-6446-433a-ae89-1720c26b1b1a.mp3?alt=media	B1		[Science] Protecting the environment is crucial for future generations. | [Work] The office environment was friendly and supportive. | [Nature] The clean environment attracted many tourists to the park.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F280d5db1-cd41-4fac-b791-91b95bb8ba89.jpg?alt=media	The surroundings or conditions in which a person, animal, or plant lives.	môi trường	ɪnˈvaɪrənmənt	environment	13
c023891d-ef25-4fb3-ac41-2290671aa874	2025-11-12 13:02:12.556466	2025-11-12 13:02:12.556479	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F322c6d54-7596-46b1-8d63-308864c971b0.mp3?alt=media	B2		[Technology] Wind and solar are forms of renewable energy. | [Environment] Investing in renewable energy reduces fossil fuel use. | [Future] Renewable energy is key to a sustainable planet.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F468674f2-24c9-4e81-884b-8a6058df682a.jpg?alt=media	Energy from sources that are naturally replenishing, like solar or wind.	năng lượng tái tạo	rɪˈnjuːəbl ˈenərdʒi	renewable energy	13
5018a3c7-a908-46c8-946e-893da3724e6f	2025-11-12 13:02:13.049539	2025-11-12 13:02:13.049559	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F830daed4-7af8-486c-b432-288cd92394db.mp3?alt=media	B2		[Literature] Write a personal memoir. | [Book] Read the celebrity's memoir. | [Story] The memoir recounts life experiences.	\N	A written account of oneâ€™s personal life and experiences.	hồi ký	ˈmemwɑː	memoir	19
b43ea470-95ad-4d88-a391-4560d927e843	2025-11-12 12:10:21.987913	2025-11-12 16:23:57.737238	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc2f991c3-eacd-4f9f-abe0-0622ade44330.mp3?alt=media	B1		[Environment] Protect the forest ecosystem. | [Science] Study marine ecosystems. | [Nature] Ecosystems support biodiversity.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fb962dc8c-0af5-4b42-b5b1-c98f3156af27.jpg?alt=media	A community of organisms interacting with their environment.	hệ sinh thái	ˈiːkəʊsɪstəm	ecosystem	47
707fb1ad-27fd-41f0-9202-7928137aa19c	2025-11-12 12:10:22.934816	2025-11-12 16:24:02.893522	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1035683d-1629-47b9-9802-23529864f135.mp3?alt=media	A1		[Art] Listen to classical music. | [Culture] Music brings joy. | [School] Study music theory.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F427fb2d4-ddbc-4159-b318-4c97d0f9073d.jpg?alt=media	Sounds arranged to create harmony or expression.	âm nhạc	ˈmjuːzɪk	music	53
d95457f7-a8fd-4d4b-880b-33560a18e7e1	2025-11-12 13:02:12.60724	2025-11-12 13:02:12.607254	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5e16b398-7228-4529-8d4d-e64659e5b1b2.mp3?alt=media	B1		[Hobby] She sells handmade crafts at the local market. | [Art] The craft of pottery requires patience and skill. | [Tradition] The village is known for its traditional crafts.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fd217941f-22b3-4907-b4aa-46b153f51ea6.jpg?alt=media	An activity involving skill in making things by hand.	thủ công	kræft	craft	14
fa9addd8-443c-4c3a-b23e-af06ae1b496d	2025-11-12 13:02:11.98749	2025-11-12 13:02:11.987504	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3bef6363-4f60-46b6-a22d-6063e0cf9d53.mp3?alt=media	A1		[Zoo] The tiger paced gracefully in its enclosure at the zoo. | [Wildlife] Conservationists work to protect tigers from extinction. | [Story] The book described a tiger roaming the jungle at night.	\N	A large wild cat with a striped coat, native to Asia.	con hổ	ˈtaɪɡə	tiger	7
4e968190-0e78-4ce3-9f4a-b5ef572063f2	2025-11-12 13:02:12.008875	2025-11-12 13:02:12.008895	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0c3d6dd5-ca39-4218-8d8f-6572b201ba07.mp3?alt=media	A1		[Wildlife] The lion roared loudly in the savanna at dusk. | [Documentary] We watched a film about a lion pride’s survival. | [Symbol] The lion is often used as a symbol of courage.	\N	A large wild cat, known as the king of the jungle.	sư tử	ˈlaɪən	lion	7
19e0d2fd-aae3-4292-9692-0a29b8f1ddf2	2025-11-12 13:02:12.09774	2025-11-12 13:02:12.097755	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F09e845b6-38fb-4ae5-9244-0c40a3202cc7.mp3?alt=media	A1		[Weather] The strong wind blew the leaves across the yard. | [Energy] Wind turbines generate clean energy for the town. | [Sailing] Sailors adjusted the sails to catch the wind.	\N	The natural movement of air, especially in the form of a current.	gió	wɪnd	wind	8
78042145-2403-4c7d-adae-554f08965db0	2025-11-12 13:02:12.259241	2025-11-12 13:02:12.259267	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F545b22ea-cb3f-4e68-bc17-f0fadd2a8999.mp3?alt=media	A1		[Storage] She organized her books neatly on the shelf. | [Decor] The shelf displayed family photos and small plants. | [Shop] He built a wooden shelf for his workshop tools.	\N	A flat surface fixed to a wall or frame for storage.	kệ	ʃelf	shelf	9
2ae4aaba-014a-47f7-a2d5-ed11f36cc422	2025-11-12 13:02:12.470671	2025-11-12 13:02:12.470691	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd1200e10-4920-423f-9fc6-5a48e923ce41.mp3?alt=media	A1		[Movie] The horror movie left her scared for hours. | [Experience] He was scared when he got lost in the forest. | [Reaction] The loud thunder made the child scared and clingy.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F140e4395-d1b3-4f4d-9101-eb3c16558a43.jpeg?alt=media	Feeling afraid or frightened.	sợ hãi	skeərd	scared	12
6133729e-9d1d-4d34-90b5-e56dbaf386ec	2025-11-12 13:02:12.54847	2025-11-12 13:02:12.548483	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fde52b254-cf3c-4b97-bfe3-86fc7cec54d2.mp3?alt=media	B2		[Environment] Reducing emissions helps fight air pollution. | [Industry] Factories must monitor their carbon emissions carefully. | [Policy] New laws aim to lower vehicle emissions in cities.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fbabcb030-bca2-4e9b-afaf-1ed4181053df.jpg?alt=media	The production and discharge of something, especially gas or radiation.	khí thải	ɪˈmɪʃn	emission	13
7e8f88a9-b822-411f-9707-b22a9c550cae	2025-11-12 13:02:12.409214	2025-11-12 13:02:12.409233	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd7543043-cfb1-48b2-b37e-f97b296e985c.mp3?alt=media	B2		[Programming] The developer fixed a bug in the application. | [Testing] They found a bug during the software testing phase. | [Frustration] The bug caused the program to crash unexpectedly.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F63dd0fb4-3cbd-457c-b61e-0cc65f1dba87.jpg?alt=media	An error or flaw in a computer program.	lỗi phần mềm	bʌɡ	bug	11
005b0a8f-7747-450b-bcea-9fbabff0fea5	2025-11-12 13:02:10.710326	2025-11-12 13:02:10.710344	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fecaa161b-a39c-4971-8ad4-f7efda3074e1.mp3?alt=media	A2		[Hobby] He collects photos of exciteds from different countries. | [Shopping] She compared three exciteds and chose the freshest one. | [Memory] This excited reminds me of my childhood in the countryside.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F4edc35f5-99ba-4ddf-a351-8093e8c912f5.jpg?alt=media	Feeling very enthusiastic and eager.	hào hứng	ɪkˈsaɪtɪd	excited	12
698e9cff-9475-471f-ad18-c869a6407b6c	2025-11-12 13:02:13.0799	2025-11-12 13:02:13.07992	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7e4f025c-8314-4ff4-8930-fa327a18b279.mp3?alt=media	A2		[Writing] Start a personal blog. | [Content] Update the blog weekly. | [Read] Follow interesting blogs.	\N	A regularly updated website or web page, typically run by an individual.	blog	blɒɡ	blog	20
9f455312-742e-4314-a5a9-25e76cddc8b9	2025-11-12 13:02:12.517381	2025-11-12 16:23:53.369895	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F30541eb5-a025-45f7-abdf-260e4fce9a6b.mp3?alt=media	B1		[Science] Solar energy is a renewable source of power. | [Daily Life] She lacked energy after staying up late to study. | [Technology] The device saves energy with its efficient design.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F4e4eee5f-e0e1-461b-baf2-b73669589697.jpg?alt=media	The strength and vitality required for sustained activity.	năng lượng	ˈenərdʒi	energy	13
865a3184-1109-4195-87f1-6d713eae3606	2025-11-12 13:02:12.359167	2025-11-12 16:24:07.366597	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0f3c463d-6af4-4d3e-bce7-e7d2896404b6.mp3?alt=media	A2		[Technology] The internet connects people across the globe instantly. | [Work] She relies on the internet for remote meetings and research. | [Daily Life] Without the internet, checking news would be much harder.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F97298cb7-49f5-4335-a0ce-6420aa1855cd.jpg?alt=media	A global computer network providing information and communication.	mạng internet	ˈɪntərnet	internet	11
1171fe7f-d05f-4a4e-a3d7-386702fcd60b	2025-11-12 13:02:12.541711	2025-11-12 13:02:12.541738	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa7f91e95-d855-4fe0-8fca-7ea9fae56069.mp3?alt=media	B2		[Nature] Preservation of forests ensures wildlife habitats remain. | [History] The museum focuses on the preservation of ancient artifacts. | [Food] Preservation techniques like canning extend shelf life.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc4ea3f64-993a-492b-91f4-8185a6b80b2c.jpg?alt=media	The act of maintaining something in its original state.	bảo tồn	ˌprezəˈveɪʃn	preservation	13
6f98e4e2-c74d-4ec7-9466-1e1d124612df	2025-11-12 13:02:13.621584	2025-11-12 13:02:13.621596	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F180c0db3-267c-401a-8d4f-2af6c242c2f4.mp3?alt=media	A2		[Ocean] Octopuses have eight arms. | [Intelligence] Octopuses solve puzzles. | [Camouflage] Octopuses change colors.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc6813116-92bc-456d-93f6-80f9f47002d3.jpg?alt=media	A marine animal with eight arms and a soft body.	bạch tuộc	ˈɒktəpəs	octopus	7
c6791511-e473-4954-be32-9716b621bcd8	2025-11-12 13:02:12.66751	2025-11-12 13:02:12.667524	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9c75d729-8695-4f39-ab7e-c1c4c9121cf2.mp3?alt=media	B2		[Study] The analysis of the data revealed surprising results. | [Business] Market analysis helped the company plan its strategy. | [Science] Her analysis of the experiment was very thorough.	\N	Detailed examination of the elements or structure of something.	phân tích	əˈnæləsɪs	analysis	15
a1fa2cb7-de92-47c6-8853-cfe135a41b54	2025-11-12 13:02:12.675271	2025-11-12 13:02:12.675286	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9a3bc48f-7157-4ead-abd2-d5bd2ebd8e3f.mp3?alt=media	B1		[Math] The formula helped solve the complex equation. | [Science] Chemists use a formula to predict reactions. | [Cooking] The recipe’s formula included precise measurements.	\N	A mathematical or scientific expression or rule.	công thức	ˈfɔːrmjələ	formula	15
cf3d57c3-3ae8-4255-9043-62736e94a06c	2025-11-12 13:02:12.773001	2025-11-12 13:02:12.773014	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fcde9581a-5f67-4266-af3c-a5555454cf47.mp3?alt=media	B1		[Society] The new law promotes equal rights for everyone. | [Study] He studied law to become a human rights lawyer. | [Enforcement] Breaking the law can lead to serious consequences.	\N	A system of rules enforced by a government or institution.	luật pháp	lɔː	law	17
1901eb3a-7c02-4cea-86ba-de18ff559ee1	2025-11-12 13:02:12.787609	2025-11-12 13:02:12.787622	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F001eb593-0bab-4b95-aa4b-0295d593dd16.mp3?alt=media	B2		[Politics] The parliament voted on the new education bill. | [History] The parliament building is a historic landmark. | [Government] She was elected to serve in the parliament.	\N	The supreme legislative body in a country.	quốc hội	ˈpɑːrləmənt	parliament	17
a49b6317-fe61-4fb6-ae50-daac2d0a3816	2025-11-12 13:02:12.796167	2025-11-12 13:02:12.796179	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9eed5ecf-e9d7-42e4-bc9d-2647f4bc49f4.mp3?alt=media	B1		[Society] Every citizen has the right to vote in elections. | [Community] Citizens gathered to discuss local issues. | [Law] The law protects the rights of all citizens.	\N	A legally recognized member of a state or nation.	công dân	ˈsɪtɪzn	citizen	17
5696b8f6-02b3-4532-bc0c-a7b9b686bf68	2025-11-12 13:02:12.83304	2025-11-12 13:02:12.833054	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9e7639ec-6ff5-45c0-9db9-7eb122f42f29.mp3?alt=media	C1		[Politics] The government imposed sanctions on the rogue nation. | [Economy] Sanctions affected trade between the two countries. | [International] Lifting sanctions improved diplomatic relations.	\N	A penalty or measure to enforce compliance with law or policy.	trừng phạt	ˈsæŋkʃn	sanction	17
a67f58ba-5b15-498c-a57c-07e20d24a4ce	2025-11-12 13:02:12.84014	2025-11-12 13:02:12.840161	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F683b3867-1372-4f08-83cc-ca01a4f7e41c.mp3?alt=media	B2		[History] The treaty ended the long-standing conflict. | [Politics] Nations signed a treaty on environmental protection. | [Law] The treaty outlined terms for mutual cooperation.	\N	A formally concluded agreement between countries.	hiệp ước	ˈtriːti	treaty	17
ef0454f7-d69a-4344-8ac9-9693e4fc38aa	2025-11-12 13:02:12.863984	2025-11-12 13:02:12.863996	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F185fa5f2-a8e7-49dd-8b61-ca28ab84a1c3.mp3?alt=media	B1		[Diplomacy] The embassy hosted a cultural exchange event. | [Travel] Contact the embassy for visa information. | [Politics] The embassy represents the country's interests abroad.	\N	The official residence or office of an ambassador.	đại sứ quán	ˈembəsi	embassy	17
bcb5ed35-a994-451c-a9c5-816f815032d0	2025-11-12 13:02:12.887015	2025-11-12 13:02:12.887028	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ffd8eafa6-863a-4e26-93cf-6ffc12fb1b94.mp3?alt=media	B2		[Law] The jury deliberated for hours. | [Trial] Serve on a jury for the case. | [Verdict] The jury reached a unanimous decision.	\N	A group of people sworn to give a verdict in a legal case.	bồi thẩm đoàn	ˈdʒʊəri	jury	17
66076e01-5670-4571-a236-074fed3a7342	2025-11-12 13:02:12.920603	2025-11-12 13:02:12.920624	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F53a67abe-250a-48b3-bf2b-5c4e3001a379.mp3?alt=media	B2		[Business] The merger created a larger corporation. | [Economy] Approve the merger after review. | [Strategy] The merger enhanced market share.	\N	The combining of two or more companies into one.	sáp nhập	ˈmɜːdʒə	merger	18
ab9b8f12-3bfd-45ec-8c05-05756eb223ca	2025-11-12 13:02:12.93689	2025-11-12 13:02:12.936905	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F14271f8b-a2ce-45e0-a282-1b9477ddeabb.mp3?alt=media	B2		[Business] Open a franchise of the restaurant. | [Model] The franchise model is profitable. | [Expansion] Buy a franchise opportunity.	\N	A license to operate a business under a brandâ€™s name.	nhượng quyền	ˈfræntʃaɪz	franchise	18
0a665cc9-959c-41c6-9b89-3b530a9c9e02	2025-11-12 13:02:13.253768	2025-11-12 13:02:13.253783	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa5c2db33-3fcb-4434-ab94-dce6a052f764.mp3?alt=media	B1		[Child] Help the orphan. | [Home] Adopt an orphan. | [Support] Care for orphans.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F81070a52-e38d-4daa-a917-98e76c7b77ab.jpg?alt=media	A child whose parents are dead.	mồ côi	ˈɔːfn	orphan	2
e1058861-bff5-4752-86a4-6954d2a2b5f6	2025-11-12 12:10:20.128793	2025-11-12 16:24:02.691041	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff1f0fe81-2f06-4b05-884e-ef04507dd173.mp3?alt=media	B1		[Art] Visit an art exhibition. | [Event] Organize a science exhibition. | [Display] The exhibition showcases talent.	\N	A public display of art, products, or skills.	triển lãm	ˌeksɪˈbɪʃn	exhibition	34
a47241cb-5f21-4c18-be93-f8f1efb2d4d6	2025-11-12 13:02:13.42555	2025-11-12 13:02:13.425556	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fe0b794b3-a7d8-4227-8d5f-41c86a8abd7a.mp3?alt=media	B1		[Traffic] Navigate the roundabout carefully. | [Road] Enter the roundabout. | [Flow] Roundabout improves traffic flow.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fa390f9b2-2adf-48dc-800c-ceff472fa770.jpg?alt=media	A circular intersection where traffic flows around a central island.	vòng xuyến	ˈraʊndəbaʊt	roundabout	5
7a5a35ca-a8dd-401d-8b1c-5d4c76f5e55f	2025-11-12 13:02:13.656154	2025-11-12 13:02:13.656162	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa33d6448-3776-4a8d-ad11-703970d42a5a.mp3?alt=media	A2		[Ocean] Starfish regenerate arms. | [Beach] Find starfish on shore. | [Color] Starfish are colorful.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F149c4c88-cf85-4134-a841-f2800b06f162.jpg?alt=media	A marine animal with a star-shaped body and five arms.	sao biển	ˈstɑːfɪʃ	starfish	7
972cf628-c286-4e94-8351-2e8993ecd1a5	2025-11-12 13:02:13.109124	2025-11-12 13:02:13.109136	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2eef16aa-2421-4393-b7c9-cf4943db494a.mp3?alt=media	B1		[Internet] Share a funny meme. | [Culture] The meme went viral. | [Humor] Create original memes.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fbb000d64-6c0c-4629-986c-906cbf7b6686.png?alt=media	A humorous image, video, or text copied and spread online.	meme	miːm	meme	20
b7545269-2e72-4e28-81a0-1cf6e5b15c11	2025-11-12 13:02:13.363845	2025-11-12 13:02:13.363851	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F89d7e4b5-057f-4ca1-9e40-6d133c77f047.mp3?alt=media	B1		[Work] Receive a performance bonus. | [Incentive] Offer year-end bonus. | [Motivation] Earn extra bonus.	\N	An extra payment given for good performance.	tiền thưởng	ˈbəʊnəs	bonus	4
87a0c571-e36d-40f3-890b-03a239e0ab0e	2025-11-12 13:02:13.717902	2025-11-12 13:02:13.717909	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Feb40b2ef-a7e7-40c2-9ba4-7083c121aa9b.mp3?alt=media	B1		[Planet] Earth's atmosphere protects life. | [Weather] Atmosphere causes weather changes. | [Space] Study Mars' atmosphere.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F397241c9-f465-439e-95b4-afad4f5bf7f1.jpg?alt=media	The layer of gases surrounding a planet.	khí quyển	ˈætməsfɪə	atmosphere	8
b35eab5c-7c05-4560-a33e-bc4868fbcfc2	2025-11-12 13:02:13.461325	2025-11-12 13:02:13.461334	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fba61fcb8-f315-4f13-80ff-50ef4eb8f596.mp3?alt=media	B2		[Travel] Recover from jet lag. | [Symptom] Feel tired due to jet lag. | [Tip] Adjust to jet lag quickly.	\N	Fatigue caused by traveling across time zones.	mệt mỏi do lệch múi giờ	dʒet læɡ	jet lag	5
fa5fbe96-3eb2-4896-8e64-35a9b8344a21	2025-11-12 13:02:13.797372	2025-11-12 13:02:13.797377	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd6fea967-d290-4c80-a654-76e0433f0a56.mp3?alt=media	A1		[Clothes] Iron the shirt. | [Tool] Use a steam iron. | [Chore] Iron wrinkled clothes.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F2d302481-87a1-4436-9276-7dae9f869007.jpg?alt=media	A device used to press clothes to remove wrinkles.	bàn ủi	ˈaɪən	iron	9
b8e11e83-cbb1-4c74-8ef6-247847b743ec	2025-11-12 13:02:13.554271	2025-11-12 13:02:13.554281	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F11222aa5-5e51-459c-88c6-b664c9233857.mp3?alt=media	B2		[Lifestyle] Promote overall wellness. | [Program] Participate in wellness activities. | [Balance] Achieve mental and physical wellness.	\N	The state of being in good health, especially as an active goal.	sức khỏe tổng thể	ˈwelnəs	wellness	6
49f22de2-c773-447c-b1b3-74b95ad689a4	2025-11-12 13:02:13.819713	2025-11-12 13:02:13.819719	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fff68f319-2db6-4d4b-9c02-2f34a204fb10.mp3?alt=media	A1		[Kitchen] Bake in the oven. | [Cooking] Preheat the oven. | [Appliance] Clean the oven.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F0cb50ce2-acdf-4426-be6e-9d7184fc338e.jpg?alt=media	An appliance for baking or roasting food.	lò nướng	ˈʌvn	oven	9
48504209-b93f-4741-b4a9-eed3f1240354	2025-11-12 13:02:09.290281	2025-11-12 13:02:09.290316	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F525eb789-fc64-49aa-a48f-07ce0122ef94.mp3?alt=media	A1		[Story] A traveler found a son near the old shelf. | [Work] The son was recorded carefully in the report. | [Everyday] I put the son on the shelf before dinner.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fe3807f41-610e-4c31-ba92-b5c38b3a13df.jpg?alt=media	A male child in a family.	con trai	sʌn	son	2
3850922e-f2c5-44ff-8ed2-158d5a1f7ae8	2025-11-12 13:02:10.182607	2025-11-12 13:02:10.182622	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fab8f8a48-59aa-441a-99a7-d149452afa94.mp3?alt=media	A1	“Amazon River.jpg” by Neil Palmer, source: https://commons.wikimedia.org/wiki/File:Amazon_River.jpg, license: CC BY-SA 2.0 (https://creativecommons.org/licenses/by-sa/2.0/).	[Hobby] He collects photos of rivers from different countries. | [Shopping] She compared three rivers and chose the freshest one. | [Memory] This river reminds me of my childhood in the countryside.	\N	A large natural stream of water flowing to the sea or a lake.	sông	ˈrɪvə	river	8
867b747c-27ab-4ad1-9544-0475b24a4fef	2025-11-12 13:02:13.174957	2025-11-12 16:23:50.506904	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fcdca6976-7d8e-4007-a7ce-abfdcb24ae23.mp3?alt=media	B1		[Menu] Choose a beverage. | [Variety] Offer hot beverages. | [Refresh] Enjoy a cold beverage.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Ffb92067c-54de-49c9-86fa-0bc38fbf0c0b.jpg?alt=media	A drink, such as water, juice, or soda.	đồ uống	ˈbevərɪdʒ	beverage	1
217152b9-85e3-41f3-87b4-1b597d73b37b	2025-11-12 12:10:21.761196	2025-11-12 16:23:56.576128	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F678c35a1-de15-411a-bb1d-4f1a734fba35.mp3?alt=media	B2		[Science] Astronomy studies stars. | [Research] Work in astronomy labs. | [Hobby] Enjoy astronomy at night.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F45e1b6f7-7e66-477a-9b67-4b495b035a03.jpg?alt=media	The study of celestial bodies like stars and planets.	thiên văn học	əˈstrɒnəmi	astronomy	45
f787ac02-2585-463e-bde9-167d33189ee2	2025-11-12 13:02:09.633787	2025-11-12 13:02:09.633811	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6e23242f-5c89-4dc5-ab98-e2b607bf9814.mp3?alt=media	A2		[Description] That boss looks heavy in the afternoon light. | [Memory] This boss reminds me of my childhood in the countryside. | [Problem] The boss broke suddenly, so we had to fix it.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fd2887b0f-c070-43a7-8018-b5d80e44079e.jpg?alt=media	A person in charge of a worker or organization.	sếp	bɒs	boss	4
79c97127-14a6-418a-b9f7-1fde0774e7b5	2025-11-12 13:02:12.84847	2025-11-12 13:02:12.848486	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fdef79367-0750-4a4c-aaf4-a179b12027a8.mp3?alt=media	B2		[Politics] The alliance strengthened defense capabilities. | [Business] Companies formed an alliance to share resources. | [History] The alliance shifted the balance of power.	\N	A union or association formed for mutual benefit.	liên minh	əˈlaɪəns	alliance	17
d73b22af-20dc-429e-954d-a591b44b18f8	2025-11-12 13:02:12.980087	2025-11-12 13:02:12.98011	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd4c5c664-9cf7-4973-9b67-e6721c1e1311.mp3?alt=media	B2		[Finance] Diversify your investment portfolio. | [Art] Showcase your portfolio online. | [Career] Build a professional portfolio.	\N	A collection of investments or works.	danh mục đầu tư	pɔːtˈfəʊliəʊ	portfolio	18
d848ee34-88c3-481e-84ad-c4e5a1f6a1ce	2025-11-12 13:02:13.005897	2025-11-12 13:02:13.005909	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F940ddd0a-7975-4867-afba-3d903eb31cb1.mp3?alt=media	B2		[Art] Paint a mural on the wall. | [Community] The mural depicts local history. | [Decoration] Admire the colorful mural.	\N	A large painting or artwork applied directly to a wall.	tranh tường	ˈmjʊərəl	mural	19
33ef5780-eec0-467c-a2d8-0c6fb7b03081	2025-11-12 13:02:13.284362	2025-11-12 13:02:13.284368	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F614a0147-4028-4869-9e20-890ea0e93317.mp3?alt=media	B1		[Education] Receive your diploma. | [Achievement] Frame the diploma. | [Qualification] Earn a diploma.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fbe6d06b4-f4cb-459f-b741-3c505e3d03ee.jpg?alt=media	A certificate awarded for completing a course of study.	bằng cấp	dɪˈpləʊmə	diploma	3
052895de-9ae1-49ba-a0ca-2c8cf575c164	2025-11-12 13:02:11.215845	2025-11-12 13:02:11.215859	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F9add9bf9-4742-4867-a63d-aba9dc0bc6d5.mp3?alt=media	B2		[Work] The negotiation was recorded carefully in the report. | [Problem] The negotiation broke suddenly, so we had to fix it. | [Story] A traveler found a negotiation near the old desk.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fcba3a942-0fc0-4a58-9c49-25c9353da239.jpg?alt=media	Discussion aimed at reaching an agreement.	đàm phán	nɪˌɡəʊʃiˈeɪʃn	negotiation	18
4913d2f7-67c9-4430-9ba3-f9b6bfb8a7d5	2025-11-12 13:02:13.453533	2025-11-12 13:02:13.453538	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F67402df6-cb06-4f45-8e11-dd20e39c5906.mp3?alt=media	B2		[Flight] Have a short layover. | [Airport] Shop during layover. | [Travel] Avoid long layovers.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F27d9719a-99de-4d50-aca7-bbb945b77ad2.jpg?alt=media	A stop between flights during a journey.	dừng chân	ˈleɪəʊvə	layover	5
cf164465-2eed-430a-ae69-8479b55d098f	2025-11-12 13:02:13.595335	2025-11-12 13:02:13.595343	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F130a16c7-c41e-47f7-8b80-12cbcc3f072c.mp3?alt=media	A1		[Ocean] Sharks swim in deep waters. | [Fear] Avoid shark attacks. | [Species] Study great white sharks.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F4aef8f35-56ad-4a1c-9808-24d90b85c10d.jpg?alt=media	A large marine fish with sharp teeth, often predatory.	cá mập	ʃɑːk	shark	7
b6c5f849-4336-4db1-936d-b103f682ed72	2025-11-12 13:02:11.504904	2025-11-12 13:02:11.504919	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F47c5a01e-3ae5-4f2c-bb8a-e70980caf446.mp3?alt=media	A1		[Dinner] She cooked pasta with a rich tomato sauce for the family. | [Restaurant] The menu offered a variety of pasta dishes with seafood. | [Travel] In Italy, we learned to make fresh pasta from scratch.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fa57d5a8b-1433-47d6-a27c-4254521d7830.jpg?alt=media	A food made from flour and water, shaped into various forms.	mì Ý	ˈpæstə	pasta	1
e97f39b4-18d0-4e56-87b2-a8ff33c9025f	2025-11-12 13:02:13.095754	2025-11-12 13:02:13.095767	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6671482e-6cde-45a3-a59a-c89ea85345cd.mp3?alt=media	B2		[Education] Attend a webinar on marketing. | [Event] Host a free webinar. | [Learning] Register for the webinar.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fcfc320b5-6fa0-4428-bab5-d25d0c22df44.png?alt=media	An online seminar conducted over the internet.	hội thảo trực tuyến	ˈwebɪnɑː	webinar	20
0a5e9015-7207-410d-b19f-f33d1a460396	2025-11-12 13:02:09.25936	2025-11-12 13:02:09.25941	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5c603b35-9c44-4c4d-96a3-d1aaed0b9ec0.mp3?alt=media	A1	“Brothers.jpg” by Alex, source: https://commons.wikimedia.org/wiki/File:Brothers.jpg, license: CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/).	[Advice] Keep the brother away from heat to stay safe. | [School] The teacher asked us to describe a brother in two sentences. | [Shopping] She compared three brothers and chose the freshest one.	\N	A male sibling who shares family bonds.	anh/em trai	ˈbrʌðə	brother	2
f4627f7b-faba-460d-92d7-435fe42645f4	2025-11-12 13:02:10.267647	2025-11-12 13:02:10.267665	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F32e80a2f-801f-4909-93f6-991a78ac6a93.mp3?alt=media	A1	“Wooden door.jpg” by Maderibeyza, source: https://commons.wikimedia.org/wiki/File:Wooden_door.jpg, license: CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/).	[Work] The door was recorded carefully in the report. | [Problem] The door broke suddenly, so we had to fix it. | [Story] A traveler found a door near the old bag.	\N	A hinged or sliding barrier for closing an entrance.	cửa	dɔː	door	9
d3221fb4-8734-48d3-9175-851a70157819	2025-11-12 13:02:11.206605	2025-11-12 16:24:08.584191	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0fcab8cf-2133-4a1d-8b5e-942dfc3690f3.mp3?alt=media	B2		[Advice] Keep the investment away from noise to stay safe. | [School] The teacher asked us to describe a investment in two sentences. | [Shopping] She compared three investments and chose the freshest one.	\N	The action or process of investing money for profit.	đầu tư	ɪnˈvestmənt	investment	18
21ac255e-ea43-416a-ab69-8d23a1d26e0f	2025-11-12 13:02:13.056499	2025-11-12 13:02:13.056511	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fbf87d3b8-02a9-4a92-9f55-a5fdd173ee16.mp3?alt=media	B1		[Social Media] The topic is trending worldwide. | [News] Check trending hashtags. | [Popularity] The video is trending on the platform.	\N	Currently popular or widely discussed, especially on social media.	đang thịnh hành	ˈtrendɪŋ	trending	20
1346aca6-353a-4f6f-a184-00f503fb05ea	2025-11-12 13:02:13.190249	2025-11-12 13:02:13.190266	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F026d931d-614c-4b64-8b16-4569494b5e2a.mp3?alt=media	B1		[Family] Introduce your spouse. | [Marriage] Support your spouse. | [Relationship] Travel with your spouse.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F912c2ee6-a1dc-4efa-9a6a-4ad012ba20e9.jpg?alt=media	A husband or wife, considered in relation to their partner.	vợ/chồng	spaʊz	spouse	2
5c60e40b-c7d5-477f-8bb9-d1a4d9217348	2025-11-12 13:02:13.232266	2025-11-12 13:02:13.232281	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb3326043-bc14-4b63-8051-d0ff260a153e.mp3?alt=media	B1		[Marriage] File for divorce. | [Process] Go through divorce. | [Law] Settle divorce terms.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F70cd3c36-1bf1-4585-8faf-d62b9f40894f.jpg?alt=media	The legal dissolution of a marriage.	ly hôn	dɪˈvɔːs	divorce	2
19774f9c-f54f-4359-857b-34d609b62b58	2025-11-12 13:02:13.403269	2025-11-12 13:02:13.403276	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb816acff-17d7-4ab0-b7dc-de34f51dfd79.mp3?alt=media	B2		[Work] Receive annual appraisal. | [Feedback] Use appraisal for improvement. | [Process] Conduct fair appraisals.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Ff20106a0-691e-4120-9d1a-58add35a0386.png?alt=media	An assessment of someoneâ€™s performance or the value of something.	đánh giá hiệu suất	əˈpreɪzl	appraisal	4
120c765f-1cd1-4917-8baa-668d35a0e240	2025-11-12 13:02:13.536684	2025-11-12 13:02:13.53669	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5385d181-477e-42be-b39d-929bc1365f15.mp3?alt=media	B2		[Health] Maintain proper hydration. | [Exercise] Drink water for hydration. | [Importance] Hydration prevents fatigue.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Ff0989e02-04ed-4de0-8953-122b15ee82e1.jpg?alt=media	The process of keeping the body supplied with water.	sự hydrat hóa	haɪˈdreɪʃn	hydration	6
b5cfcae1-90ca-42a1-be0e-7592b74040a8	2025-11-12 13:02:13.782477	2025-11-12 13:02:13.782486	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F06e0c24f-9a17-4d4c-b880-47a6755b663e.mp3?alt=media	A1		[Home] Load the washing machine. | [Appliance] Repair the washing machine. | [Laundry] Wash clothes in machine.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F4767d5d0-274c-449b-872b-46013669973d.jpg?alt=media	A machine for washing clothes.	máy giặt	ˈwɒʃɪŋ məˈʃiːn	washing machine	9
8b192c7e-49f8-48a6-a116-eec5a3af8b20	2025-11-12 13:02:13.152886	2025-11-12 13:02:13.152904	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fae049aaa-720f-4d0e-9094-a8fe04539070.mp3?alt=media	A1		[Snack] Make popcorn for movies. | [Cinema] Buy popcorn at the theater. | [Flavor] Season popcorn with butter.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F0af8a05c-c664-4aa3-8bf4-e81d61e1ee5d.jpg?alt=media	Corn kernels that expand and puff up when heated.	bắp rang	ˈpɒpkɔːn	popcorn	1
32951e03-7d86-4ca1-af5b-0d860e6b6dd8	2025-11-12 12:10:13.676487	2025-11-12 12:10:13.676503	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F318e12ba-914a-4438-bf6a-819bd2dc4a91.mp3?alt=media	B2		[Shopping] She compared three justices and chose the freshest one. | [Advice] Keep the justice away from sunlight to stay safe. | [Hobby] He collects photos of justices from different countries.	\N	The quality of being fair and reasonable.	công lý	ˈdʒʌstɪs	justice	17
4e8b6432-2315-448f-9547-c8c65c02e3fe	2025-11-12 13:02:13.486812	2025-11-12 13:02:13.486818	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd7427f6d-b682-48ff-a490-5a4a2063c52b.mp3?alt=media	B1		[Sport] Train for a marathon. | [Event] Run in the city marathon. | [Endurance] Finish the marathon race.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F24bad548-b808-47c3-bd67-d468e424b207.jpg?alt=media	A long-distance running race, typically 42.195 kilometers.	cuộc chạy maratông	ˈmærəθən	marathon	6
40e5d110-0cdc-4d52-9180-05fb7f13c9db	2025-11-12 13:02:13.528685	2025-11-12 13:02:13.528693	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc8f8fca0-bb02-4ed0-9185-bd693c8015bf.mp3?alt=media	B1		[Health] Focus on balanced nutrition. | [Diet] Study sports nutrition. | [Advice] Get nutrition tips from experts.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F36019470-18fc-4ba2-a42f-39ec1ffb7e8c.png?alt=media	The process of obtaining or providing food for health and growth.	dinh dưỡng	njuːˈtrɪʃn	nutrition	6
34a2138c-77ac-4e90-8741-f6eb9f9807ee	2025-11-12 13:02:13.316344	2025-11-12 13:02:13.316353	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F36edaac5-4bcd-4c2b-91d1-a31f27291b9e.mp3?alt=media	B2		[School] Complete enrollment process. | [University] Increase enrollment numbers. | [Course] Check enrollment status.	\N	The act of registering or enrolling in a course or institution.	đăng ký học	ɪnˈrəʊlmənt	enrollment	3
70ef9f88-2713-44a8-9590-947b9fe0147c	2025-11-12 12:10:13.916492	2025-11-12 16:24:00.926993	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd3ed324c-ad57-4f74-b463-e56f5cc1ff11.mp3?alt=media	B1		[Hobby] He collects photos of novels from different countries. | [Shopping] She compared three novels and chose the freshest one. | [Memory] This novel reminds me of my childhood in the countryside.	\N	A fictitious prose narrative of book length.	tiểu thuyết	ˈnɒvl	novel	19
33a57938-da13-472b-877f-04f12ec2900d	2025-11-12 12:10:12.863871	2025-11-12 16:24:07.7764	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F2adb4047-47cc-41f5-adc0-cd310eff109a.mp3?alt=media	B2		[Story] A traveler found a algorithm near the old shelf. | [Work] The algorithm was recorded carefully in the report. | [Everyday] I put the algorithm on the shelf before dinner.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F754809fb-47d0-42eb-82f1-c020f29909b1.jpg?alt=media	A step-by-step procedure for solving a problem or performing a computation.	thuật toán	ˈælɡərɪðəm	algorithm	11
0840a1ed-01b0-46ae-aa89-e9e836fb21a2	2025-11-12 13:02:13.629881	2025-11-12 13:02:13.629886	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F7f7c5698-e898-4eef-9a19-9ab73febebe0.mp3?alt=media	A2		[Ocean] Squids squirt ink. | [Food] Eat fried squid. | [Size] Giant squids are mysterious.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fbf868e39-83b6-4353-8ec7-bf89377f4cb2.jpg?alt=media	A marine animal with a long body and ten arms, related to octopuses.	mực ống	skwɪd	squid	7
2037557c-bf1d-43cf-a39d-0207d6ec0ede	2025-11-12 13:02:13.805149	2025-11-12 13:02:13.805157	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fa3d2f6fd-076b-4f14-877b-89778f11a243.mp3?alt=media	A1		[Kitchen] Toast bread in toaster. | [Breakfast] Use the toaster daily. | [Appliance] Buy a new toaster.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fab038b6b-1cd7-4bdc-a8fb-8fb3cd822a33.jpg?alt=media	An appliance for toasting bread.	máy nướng bánh mì	ˈtəʊstə	toaster	9
00a1e05a-16e2-40e2-af56-1dcd9feb1dcf	2025-11-12 13:02:13.812952	2025-11-12 13:02:13.812962	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5562fe69-c6ac-4c99-afad-7d1d87a1b161.mp3?alt=media	A2		[Kitchen] Blend fruits in blender. | [Appliance] Clean the blender. | [Recipe] Use blender for smoothies.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc748720b-b982-43a5-ab76-3f973c28e372.jpg?alt=media	An appliance for blending or pureeing food.	máy xay	ˈblendə	blender	9
58fd19f5-fb00-48a5-988d-5a55b5891181	2025-11-12 13:02:13.118346	2025-11-12 13:02:13.118358	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc0e4052d-71f9-4cbb-96b4-5072215bf877.mp3?alt=media	A1		[Breakfast] Eat cereal with milk. | [Healthy] Choose whole grain cereal. | [Variety] Try different cereal flavors.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc852bb4c-678c-4ffc-8e9f-ec300b1f51aa.jpg?alt=media	A grain-based food, often eaten for breakfast.	ngũ cốc	ˈsɪəriəl	cereal	1
313c6356-433e-493d-bc78-e5dfd0a0cfad	2025-11-12 13:02:13.159219	2025-11-12 13:02:13.159229	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fee24e03a-4491-4a58-800a-a6e9549ee608.mp3?alt=media	A2		[Cooking] Add spice to the dish. | [Variety] Use different spices. | [Flavor] Spice enhances taste.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F54b6bc03-529d-4b6a-b419-a38f14f23d13.jpg?alt=media	A substance used to flavor food, often dried seeds or bark.	gia vị	spaɪs	spice	1
4d138ea2-62cc-4703-bb3b-c97885a0ffc7	2025-11-12 13:02:13.238731	2025-11-12 13:02:13.238744	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4dd07636-1a83-4fba-bc8b-f6892c95ef44.mp3?alt=media	B2		[Family] Support the widow. | [Loss] Become a widow. | [Community] Help widows in need.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F0139c0e8-abc3-48a9-a7f7-d59f9d579bbf.jpg?alt=media	A woman whose spouse has died and who has not remarried.	goá phụ	ˈwɪdəʊ	widow	2
7cf44e5f-9067-4543-a50d-01b9d458c65b	2025-11-12 13:02:13.276959	2025-11-12 13:02:13.276965	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F6a62b06f-58af-4cc2-a904-33e4f10b79dd.mp3?alt=media	A2		[Presentation] Connect the projector. | [Class] Use projector for slides. | [Meeting] Set up the projector.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc13bd101-3c35-4ae4-9f0c-b7daf72505b4.jpg?alt=media	A device that projects images by shining light through a small transparent image.	máy chiếu	prəˈdʒektə	projector	3
29aae360-84b9-4615-a58e-c0085ea5d921	2025-11-12 13:02:13.261504	2025-11-12 13:02:13.26153	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff9747075-7ca8-4c03-87be-3e1426176f27.mp3?alt=media	B2		[Family] Consider adoption options. | [Process] Complete the adoption. | [Child] Find home through adoption.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fd6ec7573-ec65-422e-8ed3-f4d58660112d.jpg?alt=media	The act of legally taking anotherâ€™s child as oneâ€™s own.	nhận con nuôi	əˈdɒpʃn	adoption	2
e5d5ce4e-2d99-469d-a6db-b580d58df6a2	2025-11-12 13:02:11.465029	2025-11-12 13:02:11.465072	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F0a0e5a42-7b3b-4d0c-b60b-1da23f9022eb.mp3?alt=media	A1		[Snack] He grabbed a piece of fruit from the bowl for a quick bite. | [Dessert] The fruit salad was a refreshing end to the meal. | [Travel] Tropical fruits like mangoes were abundant in the island market.	\N	The sweet, edible part of a plant, typically containing seeds.	trái cây	fruːt	fruit	1
fcce226a-b494-4a1b-9c29-7c51986cc6cc	2025-11-12 13:02:11.668107	2025-11-12 13:02:11.668124	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Ff112a993-7ce1-4350-8fe1-40d4690cb231.mp3?alt=media	A1		[School] She was thrilled to receive a high grade on her essay. | [Feedback] The teacher wrote comments next to the grade on the test. | [Goal] He studied hard to improve his math grade.	\N	A mark indicating the quality of a studentâ€™s work.	điểm số	ɡreɪd	grade	3
5fee7ae3-46ec-4bd9-ab6c-cbdd35d13b83	2025-11-12 13:02:11.414343	2025-11-12 13:02:11.414357	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb2e83ac2-ed76-4356-9216-f651ac4c16c1.mp3?alt=media	A1		[Recipe] Mix banana with yogurt for a healthy smoothie in the morning. | [Travel] During the tropical trip, we picked fresh bananas from the trees. | [Party] She decorated the table with banana leaves for an exotic theme.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fb8a57913-8abb-4677-bb1a-30aeef91f457.jpg?alt=media	A long, curved fruit with a soft sweet flesh inside a thick skin.	quả chuối	bəˈnɑːnə	banana	1
fa4a8281-b39a-4889-9a83-0fb44ca8723f	2025-11-12 13:02:13.296113	2025-11-12 13:02:13.296138	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd114e3f8-a944-4b23-9ed4-c98121bb5ef6.mp3?alt=media	B2		[Education] Avoid plagiarism in essays. | [Ethics] Check for plagiarism. | [Consequence] Punish plagiarism.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F2a52b0d6-037d-4e17-8781-bd824207ee1b.png?alt=media	The act of using someone elseâ€™s work or ideas without credit.	đạo văn	ˈpleɪdʒərɪzəm	plagiarism	3
ed681fc8-d0fc-4a5f-a928-0bc7c1cad6d4	2025-11-12 13:02:13.304801	2025-11-12 13:02:13.30481	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F1f366cfd-b68a-4498-982a-135e0156ef3b.mp3?alt=media	B1		[School] Record student attendance. | [Event] High attendance at the lecture. | [Policy] Require regular attendance.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F1f6ebe05-9969-4f6d-9206-d085df8cd847.jpg?alt=media	The act of being present at an event or place.	sự tham dự	əˈtendəns	attendance	3
f7b0baed-79b4-468b-801a-4c56f114662e	2025-11-12 13:02:13.347485	2025-11-12 13:02:13.347491	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fb77d05b7-9f4d-4346-a8f9-5fc591cd9fbc.mp3?alt=media	B2		[Career] Submit a resignation letter. | [Decision] Announce the resignation. | [Process] Handle resignation professionally.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F78a60d99-ff98-4590-b04b-9e2c25b18cea.jpg?alt=media	The act of voluntarily leaving a job or position.	từ chức	ˌrezɪɡˈneɪʃn	resignation	4
4bd286c1-6053-4cb8-b2e0-2d452a4afeed	2025-11-12 13:02:11.896983	2025-11-12 13:02:11.896997	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F68f66796-37ac-468d-b5bc-5318f86ec69e.mp3?alt=media	A2		[Sport] Cycling is a great way to explore the countryside. | [Fitness] He joined a cycling group to train for a marathon. | [Environment] Cycling to work helps reduce air pollution.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F180df758-fbb6-4b68-bd3f-52d89c8d2df6.jpg?alt=media	The activity of riding a bicycle for sport or exercise.	đạp xe	ˈsaɪklɪŋ	cycling	6
8fc9266d-5c9c-4c1a-bc34-712cb8777a06	2025-11-12 13:02:13.49899	2025-11-12 13:02:13.498997	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fc50baa03-d359-499d-ab89-84e27566eed9.mp3?alt=media	B1		[Gym] Practice weightlifting routines. | [Strength] Build muscle with weightlifting. | [Competition] Enter weightlifting contests.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F421b2110-3955-4a52-b210-e036954832a8.jpg?alt=media	The sport of lifting heavy weights for exercise or competition.	nâng tạ	ˈweɪtlɪftɪŋ	weightlifting	6
0024f17b-e0a5-4628-b4fa-6adcda56c746	2025-11-12 13:02:13.545018	2025-11-12 13:02:13.545025	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F742a8849-7d5c-488b-aefd-2b9a60599ff5.mp3?alt=media	C1		[Health] Undergo rehabilitation after injury. | [Program] Join a rehabilitation center. | [Process] Rehabilitation takes time.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F048e11b4-be3b-4efc-9763-13605d86bccb.jpg?alt=media	The process of restoring someone to health or normal life.	phục hồi chức năng	ˌriːhəˌbɪlɪˈteɪʃn	rehabilitation	6
c315d0f6-f15c-4fc0-87dd-430ed1f47672	2025-11-12 13:02:13.646432	2025-11-12 13:02:13.64644	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F695677bb-a4ff-48bc-b699-e041e37d10cd.mp3?alt=media	A1		[Beach] Catch crabs in rocks. | [Food] Eat crab meat. | [Walk] Crabs walk sideways.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fffc7161c-d9a4-40e4-8bfd-a97a64d89439.jpg?alt=media	A marine or terrestrial crustacean with a hard shell and pincers.	cua	kræb	crab	7
13cd2972-2dfe-4455-8166-9db7255b956e	2025-11-12 13:02:11.844635	2025-11-12 13:02:11.84465	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F5424b38d-d0d0-4cdf-883b-f1aa963b8944.mp3?alt=media	A2		[Travel] She checked her passport before boarding the international flight. | [Security] The officer stamped the passport at the border. | [Preparation] Always keep your passport safe when traveling abroad.	\N	An official document for international travel.	hộ chiếu	ˈpæspɔːrt	passport	5
3e59414c-d3f0-4c63-ba7d-a425f72b54b3	2025-11-12 13:02:12.343558	2025-11-12 13:02:12.343571	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F96ec8a03-e74d-417c-a504-594f62773af6.mp3?alt=media	A1		[History] The castle was built in the 12th century by a king. | [Tourism] We explored the castle’s towers and dungeons on the tour. | [Story] The fairy tale was set in a magical castle.	\N	A large fortified building or group of buildings.	lâu đài	ˈkæsl	castle	10
17ed210b-5e04-4e3e-a1a1-1fdd511b7e30	2025-11-12 13:02:12.946331	2025-11-12 13:02:12.946344	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd4ef1252-0e62-4c0e-a76b-f905dd5d1e31.mp3?alt=media	B2		[Finance] Conduct an annual audit. | [Business] Prepare for the external audit. | [Compliance] The audit revealed discrepancies.	\N	An official inspection of an organizationâ€™s accounts.	kiểm toán	ˈɔːdɪt	audit	18
6cfabcc1-12ec-42f9-82ad-a1c13ff6ce68	2025-11-12 13:02:13.340278	2025-11-12 13:02:13.340286	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F4f8c4aa5-8a83-4abc-82ba-a96d9962a08d.mp3?alt=media	B1		[University] Live in the dormitory. | [Room] Share a dormitory room. | [Life] Experience dormitory life.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fc429f502-efd4-4ca7-8e64-05e84220e96d.jpg?alt=media	A building where students live, typically at a school or university.	ký túc xá	dɔːˈmɪtəri	dormitory	3
6f3636bb-bd03-419d-80c9-4a006f25a965	2025-11-12 13:02:13.438808	2025-11-12 13:02:13.438813	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2Fd0224321-2950-40e9-94c6-8a585ce67500.mp3?alt=media	B2		[Road] Take a detour due to construction. | [Route] Follow the detour signs. | [Travel] The detour added time.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F5b957d18-fd63-4a4e-a16a-828b1ae749ca.jpg?alt=media	A route taken to avoid an obstacle or delay.	lối vòng	ˈdiːtʊə	detour	5
2c76684e-ba16-437f-93c5-b1d40a04eae7	2025-11-12 13:02:13.517953	2025-11-12 13:02:13.517959	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F00e36470-2653-4c52-b403-2ac355f03429.mp3?alt=media	B2		[Exercise] Practice pilates for core strength. | [Class] Attend pilates sessions. | [Benefit] Pilates improves posture.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Ff51a6bec-944f-459c-8552-d5f480e17818.jpg?alt=media	A system of exercises to improve flexibility and core strength.	pilates	pɪˈlɑːtiːz	pilates	6
0b5d3157-56a3-459c-8560-768edee1e4f0	2025-11-12 13:02:13.584774	2025-11-12 13:02:13.584784	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F50597e79-19f8-4a15-94e5-2f3c1295cd99.mp3?alt=media	A1		[Animal] Koalas sleep in trees. | [Australia] Koalas eat eucalyptus leaves. | [Cute] Koalas look cuddly.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2F22edd9ba-612c-402f-9866-07946620aa61.jpg?alt=media	A marsupial native to Australia that lives in eucalyptus trees.	gấu koala	kəʊˈɑːlə	koala	7
d057614d-0f21-42a0-a6f9-bc7e2e270e87	2025-11-12 13:02:13.737127	2025-11-12 16:23:55.950084	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F67a95c68-c56e-44f2-85f1-fa10c2b3f363.mp3?alt=media	B2		[Nature] Prevent soil erosion. | [Coast] Erosion shapes coastlines. | [Wind] Wind causes erosion.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Fef064b1a-572f-4389-b3fe-c5f008b05a7f.jpg?alt=media	The process of wearing away land by wind, water, or ice.	xói mòn	ɪˈrəʊʒn	erosion	8
b817e23a-425e-4fc1-9ee8-cb83e8dadc60	2025-11-12 13:02:13.706647	2025-11-12 16:23:56.652543	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Faudios%2F3671a362-67e4-4dbd-acfa-45b63933ca82.mp3?alt=media	B2		[Space] Asteroids are rocky bodies. | [Belt] Asteroid belt between planets. | [Impact] Asteroids hit Earth rarely.	https://firebasestorage.googleapis.com/v0/b/card-b1260.firebasestorage.app/o/vocab%2Fimages%2Faa4a5435-897f-46f8-bfa4-6873ffea1f5b.jpg?alt=media	A small rocky body orbiting the sun, smaller than a planet.	tiểu hành tinh	ˈæstərɔɪd	asteroid	8
\.


--
-- Data for Name: vocab_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vocab_types (vocab_id, type_id) FROM stdin;
9ffb6f21-0147-4e77-92c3-9f186e196fcd	1
2e8d9781-c720-4fd1-a275-95be1f236b04	1
792b188b-298d-4293-b1b2-8a54e8f06134	1
5da17287-9084-407c-bc4a-86a09fe7d5f3	1
e9d25433-c37b-4b50-8994-3504082c7d62	1
65fc243f-8c65-405d-b212-0268d3595125	2
15c41d03-b901-49e4-9b19-43befd322627	1
fbd38cd6-7dbe-48db-834e-dedf519f22ec	1
4768a173-79cc-4d2d-a316-bd702fca5929	1
37f9f568-89fb-4b8a-9838-9bd55bb201b5	1
33a57938-da13-472b-877f-04f12ec2900d	1
aa92801f-c636-47df-918c-ad97852bb522	3
33999813-15a4-47ff-9352-ca34dc90b02c	1
a0d13899-7e52-4a0b-813d-66969add8083	1
31a3a10b-a7a7-4cd6-b29b-f4d707e5c0c2	1
a0c97f84-a9f3-4d25-bf3c-acd9ee8917b5	1
32951e03-7d86-4ca1-af5b-0d860e6b6dd8	1
2fea9967-8549-4573-a32f-9bccfb95f9c2	1
70ef9f88-2713-44a8-9590-947b9fe0147c	1
ae8c73c5-e8c3-4a08-9a26-910b36a293da	1
345304b4-a7f0-4503-b7f4-b2908691fe6a	1
7f320c22-f58b-49c2-8b63-06f54ad72202	1
a841b05e-c7bf-4b6d-a35d-2361d0ce0c91	1
44ec4b12-00d3-4828-bd2f-1c4adbba24ec	1
8357bb68-ae8d-49fa-bb83-10160f616c88	1
d2dcd908-6402-431e-ba00-3ec08e58fef8	1
bb7463b0-d3ae-4ca7-a2a9-8b8b7db6c1f3	1
41ab2822-0554-4986-b128-b50eb7f2d94b	1
566c920a-e6db-4f65-841c-8dddefa0e0ac	1
97c9e3d4-c481-4633-acda-957d1a8a3400	1
b77712c1-feda-4166-b534-c069c7d1aa3f	1
b917ef3b-fb1f-4a2e-ba50-5348e5faf409	1
b917ef3b-fb1f-4a2e-ba50-5348e5faf409	2
fbc4fbfd-ec46-49d1-bd15-13b995329ec0	1
e1058861-bff5-4752-86a4-6954d2a2b5f6	1
4d9d677f-d6e3-4a2b-a8e9-923c4f06e73d	1
8fdb76c8-6371-4703-b035-2ab30f809825	1
d9dcc38c-1380-446b-ac08-2594b429f95a	2
d9dcc38c-1380-446b-ac08-2594b429f95a	1
5ce00eb5-e51a-43a8-8638-8d63eb3db87f	1
a1953234-29a0-4f29-80ce-31a724178199	1
efca1680-42ec-4383-bae5-39e64d271bef	1
eb423b79-43fd-4b13-8562-29762adb5b62	1
16a2e56b-21ad-44c2-b69d-74787649e004	1
9797f5b7-d84d-44c1-b859-511994cd987c	1
bbecdbcc-9a02-4b82-bd6f-41bb50fedb4a	1
217152b9-85e3-41f3-87b4-1b597d73b37b	1
47156ec8-3a3e-4850-b7ed-2621fc459084	1
b43ea470-95ad-4d88-a391-4560d927e843	1
41f04f92-023a-4289-82dd-87d5b68ab9a6	1
c8782b72-039a-464b-acd9-fd7e81edc6fb	1
c144d313-df01-4fd9-b80b-3a7023d2d4b7	1
b5474bb0-a804-4f58-bf24-32dc728a5f52	1
64caeaed-1a63-4b5a-87e4-8305762822f7	1
707fb1ad-27fd-41f0-9202-7928137aa19c	1
b7a507a7-e8fc-4f1c-9bc4-1d5f6cf42610	2
b7a507a7-e8fc-4f1c-9bc4-1d5f6cf42610	1
334e8c87-444d-4985-92e2-6fca87b8b14e	1
c49693d2-97fe-4ff2-870b-a5dc3229bc12	1
d3079c79-096c-489b-907b-2d89b0e48216	1
3203bff7-c122-431d-8525-9784b1c80909	1
981c1e0f-de6f-4f2b-a44b-df79184310af	1
f54abaf7-a969-4e42-b2ae-b68148732a97	1
759bce7b-66d5-428d-802a-0e4c885d7faf	1
084acc4c-f95e-491e-922e-ea5088700f61	1
ac23d750-ee93-4eb8-b87a-931ea23c5aee	1
f0a321f4-eb5f-48d1-8638-dfc6757b6458	1
457337e3-f5db-416f-81ce-f6e2cfbb7f58	1
7df11371-9269-472a-a403-5032e60a6823	1
2f6a493d-722f-46cc-8c97-56622c5818e1	1
33cf8faf-0d02-47f5-910b-31f58f54c8e9	1
0a5e9015-7207-410d-b19f-f33d1a460396	1
153f4950-96a1-41a2-b7e1-8de7a9e3e858	1
48504209-b93f-4741-b4a9-eed3f1240354	1
dd252972-a777-4a8b-b702-8cfb354fa5c8	1
58a74d03-5f05-4baf-bf56-ef2086d6c02d	1
44f2140a-2a22-40d5-b89d-9f70c485098a	1
e8a496a2-4141-45df-a62a-968ce0649a9e	1
d2768678-b708-4936-a9ff-440c5bbbaf47	1
6950f251-0c04-4a00-8598-9362ed1ca395	1
3a6a9ca2-813f-40f2-a2d4-5b8614022d98	1
90b17b2c-c63d-4090-a96b-183dbcccbc48	1
cbbc3855-f8f4-401d-9dad-787e3753a7f2	1
f9826fce-b05f-40d9-8d4e-fc699ca9690a	1
53402206-d0b0-42f5-bd7a-edba93101226	1
b4250cbd-09ca-4e26-bf46-9ae807496675	1
1d6cd7c7-a599-4126-8e20-aefa3af45143	1
fb1cb2f1-efd5-47cd-82ef-9d437a62acd9	1
ad50fa9d-3d44-416b-b8db-115e4748a685	1
f787ac02-2585-463e-bde9-167d33189ee2	1
7f7d360f-cac9-4eb7-a829-7f82834de662	1
c959c7ca-bb2c-4b4d-b924-c85a3669dfcb	1
fdc4fd5d-7329-4252-ab0e-94ea37adcf6e	1
643ca149-470f-43b1-b04e-d0ef59fb3544	1
7b655c4e-6463-4071-b397-3da907201f81	1
b1d54dd2-4329-488f-a95c-2e727b446fd2	1
a201d6d0-db76-45d0-83eb-6f2c385ce580	1
6ed690b4-9db2-4f67-8658-7de753790982	1
0c8ef2c5-f839-49e4-9834-3955853357d3	1
6f5f430b-90cc-4a94-a1ec-fc27af478b2d	1
c45aef5b-c3a0-424e-b2a2-030596c81b09	1
878a2529-f9b7-4a66-8e37-431db9d744d0	1
3e902e56-5be7-44f3-b720-78453268523b	1
d8dad4c0-48e7-4270-8799-b8dd6787b0bf	1
a42fb061-d0a3-4fa9-a51b-1eade4ca02b9	1
1180bddd-a97a-4967-9b41-8fa1a138dceb	1
88dbb0be-571e-4b1e-81ab-6dcdc8d2ea84	2
fe4bc1b7-b085-482f-bba7-93c796bc7588	1
f04aec5d-05a1-4a93-8146-4e24cb116317	1
c11a7711-57e8-4eff-bf2c-6f8aa10acc8f	1
03723ee8-f250-4240-885a-7edc8eda1974	2
03723ee8-f250-4240-885a-7edc8eda1974	1
e22c3939-dce7-4919-9d97-3e50f84c7715	1
859a67dd-5dd0-4193-9d04-87fc41a03c59	1
5f95b153-2ea6-4373-958a-f165612d23bb	1
7bc58a91-c278-40a7-b3ef-70970091f075	1
f864585d-bdea-4e88-b945-69c4ccadb361	1
08a915e2-f0ab-4dee-8d2c-0f4f18538dad	1
fb7d6528-85f5-4a07-b670-94b1edce84fb	1
7f0a1765-6092-49d2-b7f1-a3f64d5a30e9	1
02524785-3026-48f4-b538-9f32298d5736	1
b6ffdff8-d64d-4785-a693-e238afec6a38	1
370c6ff5-c28c-4756-ba16-ee19fcd6d8c5	1
ac75bf56-ecb8-4e04-921d-0eda3338229a	1
d07640e3-e9ea-4063-8580-1936249122f5	1
3bada75d-ff07-4aa5-8622-2b54f3c5eb59	1
109bb267-fdeb-4a66-930f-e964c7b6407f	1
22124e5f-d914-45a9-9bd3-311453433cf8	1
0841a70f-c509-47f2-92e4-236a48797f80	1
3850922e-f2c5-44ff-8ed2-158d5a1f7ae8	1
8b9f764d-12f4-4add-90d6-dc72cd1cedd0	1
73c3d22f-3c66-44f5-a7c4-1203d86fd0ea	1
d3d30637-4e02-4b5b-aa05-5bea49dba687	1
06d8d1e2-7c63-4eff-a469-4b085c1f4bc5	1
53b3a771-6068-4301-8bfb-229e6833f892	1
3e9e2393-36ab-44ad-b83a-e731bf296439	1
f4627f7b-faba-460d-92d7-435fe42645f4	1
46385d57-e64f-4da2-9a66-a6c5f2a87992	1
e3adda41-0054-4342-bfaf-b0fa555b6c03	1
4af3eadc-fc22-47ea-8b9d-54586f3afa21	1
5f98317b-df76-444b-924c-5db30ada0503	1
b53753a9-c99f-4ad4-92b7-869e5b2f9bef	1
2c152098-7f90-4a19-b5bb-1f94f689bcbf	1
eb523b41-fb1b-48d9-9aed-05dfc7760bc1	1
bf212564-97ea-4455-95af-6be8bcc87876	1
a09781ec-8520-4cda-9fc8-e254daf382de	1
a2cfdc7d-06d8-4785-a5d5-b9f851467795	1
830dde69-2c19-429a-bf42-9c0b7bf7a022	1
bfb374a3-96af-4ce9-8095-44a74f8f1789	1
dd378064-30a3-4209-b3e4-1a73918cdc3c	1
eb7bbf42-e079-47e9-99e3-17f9f34b587e	1
1472a0d6-cfe7-4146-948f-d5c56c6b3604	2
b48770f5-b418-444c-a865-44e49dbd600d	2
78c1ab2e-2888-42f4-851a-953f167a3ef0	1
434c2f44-4dca-402b-972f-d501ce23ff24	1
763bbcde-95ca-4f07-8975-03a1e028aa71	1
178a6c31-2142-417f-bc8c-9a514c91b776	1
ab0804db-d953-4f97-8a04-c622cc0b9671	1
6ebf5a8e-0735-4c50-9eaf-906fe05d5b96	1
154fb5c1-e8cf-4333-93d3-0fdc0d25c280	3
26b5c93b-517a-4eb1-966f-0405438b0f87	3
c0f1bab6-8c2a-4ca5-8180-12ad803ed38b	3
b8f43757-e78c-4a75-8172-60c680417968	3
e1efbcad-65b6-477b-9c0f-8c9e33966f60	3
4f412954-3b79-441f-a851-04a7acb4302c	3
328dd37d-a53e-4d0a-a2e2-7e3c04912444	3
493b8402-9923-49a6-8562-3c1cca69f0e8	3
005b0a8f-7747-450b-bcea-9fbabff0fea5	3
c65b7bc6-c470-4b7b-8ba1-c76d322385bb	1
71089e55-0f30-4564-a67c-8ec58011bb11	2
c56d4e00-b915-4794-8284-0a1189e6af99	3
5b77ceb8-17f7-4292-aecb-82738d019867	1
0626856e-6775-4c16-9a2c-3433da8d4799	1
a5d05e26-2999-4448-8794-3f52d952189b	3
704182c9-645b-481e-9b05-f33dfcb80330	1
262063d0-86d2-4f4e-997d-28faa6349590	1
b9dc59c0-5d8f-47ac-b980-4beba9364f06	1
5d97e6d6-a97e-4083-8d90-2fcf869c5063	1
34299ada-be55-47c7-9e5a-8aabb92c0bb1	1
6a4b8007-9803-4c31-b317-940bdf7cc3c3	1
24cef67d-63d2-41c1-872b-de6f0c3f8d0c	1
cd851ffa-8933-4259-ba6f-13d3adae1e00	1
f40f66a3-a016-4ad0-b3ce-6231646d6a9a	1
bf97afe9-593a-4b97-860c-9566712ba88b	2
cd90b8c8-9181-4d03-849c-9a8ad0666f7c	1
ebdc2808-9f12-41e0-ac88-a8138c8b0055	1
9a503c37-5881-4093-9601-ccf4212a38a3	1
c8a8f89b-e631-4ce6-8167-a08c122f30ef	1
3ba29603-21f6-44f3-bee3-79b944a405d2	1
94585577-e407-41ee-96c9-8e44e516571b	1
1ea36371-2054-4874-be8b-cc2290d27679	1
1cce1ea5-443b-4b06-a56d-bd3fb820e5b8	1
1cce1ea5-443b-4b06-a56d-bd3fb820e5b8	2
5072a8fa-ec88-4ddc-9067-05ffc00f2a2e	1
27e6d57f-7435-453e-9947-1771bc0d7e93	1
ce830192-718f-41fb-b3fe-9082c80d7c71	1
50bc29cf-1544-479a-a1cd-45e4daffea16	1
911a4eb8-e048-46f2-9a03-5cb3b5d1389f	1
c730b0e8-d96c-4bfa-9f85-64b3783cb38b	3
46d30020-2aca-4abf-ba2d-70b263253879	2
46d30020-2aca-4abf-ba2d-70b263253879	1
a4de8321-acbc-497d-91d4-604c59179cfd	1
e79577f2-1dc1-4055-97da-24530a547e93	1
5fe97aa5-68d8-4879-803d-61e3968021b3	1
9f75f6b5-353d-46f7-ad0f-d749047c6c89	1
66e65231-9d57-47e1-99db-65d3ecfad2d3	1
52fa281c-0b64-4c86-b06f-82370e46bb2e	1
1cb43ac6-bfaa-4a4e-991a-277577c54900	1
1cb43ac6-bfaa-4a4e-991a-277577c54900	2
f6c56139-fbc4-46ce-b40f-1825fe644b9f	1
a54b0212-bbde-4068-8f0b-7a41439871cd	1
14d9fc8c-d5f8-4891-97e7-6f9dc8140b25	1
f3baffb6-30f9-4702-aa0a-ecdb4f9e1c99	1
84c7ea29-f93d-48ed-8dc5-4bfd37d55893	1
938273da-9b46-40b8-84af-6ead421430de	1
aa2ae4a7-75c4-40a7-8a84-d7d0a7da2614	1
d3221fb4-8734-48d3-9175-851a70157819	1
052895de-9ae1-49ba-a0ca-2c8cf575c164	1
c9d964c2-e2b0-415f-bb99-cd3eb504cfbc	1
6ae04002-9525-4ecc-addb-382ce6f43498	1
44d84416-0007-4779-9a66-4f324ed3dc72	1
70e4025a-d1ec-499f-8542-a46d3fff9e15	1
9b448f19-c664-4082-a61c-b1db3029fb6c	1
4e60fe3f-1c3f-4fa1-a0e8-698320b0380c	1
f54ccc80-48b4-4b03-9b5b-8379eb2d79ed	1
b119ac71-74c0-47d1-ba19-bc8900ee5afd	1
2321a95b-c48e-4d11-b400-e7fc1e79e97d	1
ed31c7d0-cfe4-4f46-8822-a04a702640b0	1
736466d4-0e22-4369-a036-e54f155c5398	1
4cb5142a-d164-4327-ab35-2e7114828ccb	1
4cb5142a-d164-4327-ab35-2e7114828ccb	2
42f6c12e-b091-44a2-b3ae-b86edf60eb4b	1
851d42da-cd26-45b4-9e86-400271288115	3
b69cbc79-58e8-4100-9d28-074c3a844169	1
b5f229c5-5a61-4c96-b432-d127e9b1090d	2
b5f229c5-5a61-4c96-b432-d127e9b1090d	1
b78b3a93-8ab4-486a-a3b5-934bdca032c5	2
2ae4233b-7a93-42d3-a928-83baf5f654d1	1
788860bc-cf6b-489f-8066-d94289b84419	1
3798374d-da4b-4887-b577-a11dc08e6289	1
5fee7ae3-46ec-4bd9-ab6c-cbdd35d13b83	1
7dbc5f81-4e96-48f7-8a71-2c953387e0b4	1
8f6cd00b-6784-4e6e-88dd-76984709d7dd	1
6e48003f-c4c4-4e6c-9ded-b954bc7a66eb	1
e28ea120-607e-4bf4-b437-8009011bc135	1
e5d5ce4e-2d99-469d-a6db-b580d58df6a2	1
2cece5fb-67f3-4b3c-bc11-99d26302e376	1
39a08be2-8047-4040-8a7c-1c539dcf3385	1
2bfeee07-3877-4ed6-b496-088e102a38bd	1
b6c5f849-4336-4db1-936d-b103f682ed72	1
bb7a35f9-b58b-40e9-ab48-052eae961a9b	1
ec8a3377-08ea-4690-aa93-e6202e891dfc	1
f0769317-4202-4471-a47c-53865c348391	1
ccea1431-c9a8-4a61-a618-d0cc578717db	1
b6a00cbf-39d2-47c7-bd84-44841cd61619	1
b5b80670-d815-491e-adb2-8e39e8b30b21	1
5d558b44-904c-4509-be28-ae9e2389af8b	1
8caee82a-40cb-4232-89db-f586d7daf1ff	1
623d3f10-6178-4761-b3d7-c9a2b6cf8e4e	1
7e7d5bc3-7bb9-4cbe-b913-990c12239456	1
ec398494-9000-479e-8de4-5a081c70735c	1
41ec88f0-2367-4f65-b7d6-b61ab19ac7a0	1
b52383c8-31ce-43e9-80bf-dfb830b03108	1
b04b6920-9b1e-4790-844b-91c54551142d	1
f0086b87-8b1b-4cbf-897d-30dfdf1c8bde	1
e39b2c01-6842-41ed-bc64-9c4502989898	1
46b9fb76-bf31-4ccb-8335-f3cc9ecdb6c1	1
fcce226a-b494-4a1b-9c29-7c51986cc6cc	1
60ac6b50-c0d7-41c5-8390-a47b154165e1	2
60ac6b50-c0d7-41c5-8390-a47b154165e1	1
96ac9f6c-62eb-4600-ab32-d3cb2ea90531	1
27cb45a2-4418-4371-b0d3-03ce029b189e	1
86baac9e-f5f7-43f7-9f66-3b883380bb3d	1
80b1bc66-66fa-4a8b-8025-f299a4ec0c46	1
163cf3bb-b4fa-43a3-a750-44d314275498	1
dc96f71f-453f-4422-aa9f-a4a68c9569af	1
791c9880-f8ef-4465-bff2-18c7267ab953	1
0c0fa3c5-13ce-419e-9005-2f0afed24592	1
f2da4c5d-39f0-4786-90f0-b35a4e50f706	1
9d6b4239-3e2d-445e-a02e-22c73a3d01e0	1
c74b4f02-e7b1-4aee-a0d9-9662f221cc3e	1
0f7015dc-fba1-4553-a7d5-6a296550af25	1
8b6e2bc1-b225-4c87-8fbc-9a8c60723dc3	1
5d1198f5-0c66-4c16-a487-67cc7e0f007f	1
7fd19eea-0fd7-4d51-9cf9-27cd2d7dfbfa	1
2ea5ddb6-e0a4-428e-bf68-4dffe96f1ad2	1
19284869-c16c-44e9-aac6-52b29c46f382	1
13cd2972-2dfe-4455-8166-9db7255b956e	1
50fb0c06-8c18-49df-8ad9-89c999d76e6d	1
23193be4-66b5-493b-8533-271c4b99a3fc	1
b82c614e-0457-4514-8c86-1003eab624b9	2
b82c614e-0457-4514-8c86-1003eab624b9	1
39782550-cf03-40d1-9ff3-8f39d5543410	1
4bd286c1-6053-4cb8-b2e0-2d452a4afeed	1
8dff9b8f-8b76-48fe-b062-ff6a53834753	1
61dc91f4-b189-4ec5-b85e-d915b27b581a	1
d2b774ce-6b44-47a0-9f5c-e95c468d57b4	1
992cd1bf-d08a-4637-99a6-6e21aa69dd2e	1
7aeb308d-af14-4145-ba7e-7a636162c5db	1
cd24ee8c-d708-46c2-8c45-17bc20bf367e	1
6f5552fd-ee21-4b7c-8306-7773b59289e6	1
0b677710-8b1f-4ae2-9d28-276983427c63	1
fa9addd8-443c-4c3a-b23e-af06ae1b496d	1
0a0d1074-c593-44bc-b2f4-e10681233acd	1
4e968190-0e78-4ce3-9f4a-b5ef572063f2	1
50dc838b-283a-416a-8453-c31a922c8caf	1
5f433de4-8057-4c12-9033-85e68e54ba41	1
41e2ad95-e15f-4086-b147-6111f5fc49b0	1
d862efeb-34b6-4289-9322-07c0d1841e4c	1
8bb7dfcc-0f90-48af-ad37-0174deb34c4a	1
f3577519-3693-43af-8453-350b4cd2b1ec	1
b533d652-0856-467d-bc2b-aa32f01c32b7	1
13bade7f-64bd-4a8e-9bb9-b92a2207bc7a	1
19e0d2fd-aae3-4292-9692-0a29b8f1ddf2	1
041d10f3-10cd-41fb-9e8b-8e7fb3fa7365	1
ca4db7c3-0f35-48dc-b95e-706dd677502e	1
2aab92c0-5380-4eab-93e2-1ebc53438c1f	1
d7d68f0f-3938-4875-9bfe-ee13cc2cd99e	1
c8c738e3-b93a-4917-bd18-8ae166f66705	1
3ede4f0c-c898-4baa-8e56-565eb9a889f0	1
29d1056b-eb32-4df5-94ad-fbc845197410	1
c44295e9-2449-46c0-8f0b-1bb26c8d1fe1	1
2c24bb92-a78a-4e51-a5d7-07751c57d866	1
da51edbb-9283-4d7d-879b-4ef6fff0d692	1
3eb1cac3-39a0-4abc-bdeb-6e8f8448e573	1
63b72980-16be-44a3-8909-2c409855da00	1
67855177-90ed-4f1a-b473-d4e0e5e14204	1
9ff88cd7-7d55-4d8f-8bdb-780035bd1858	1
78042145-2403-4c7d-adae-554f08965db0	1
dcc7db0c-eafb-4718-954f-13597a769525	1
e980fdc3-95ea-4c0f-a7f0-9b28f173870a	1
582219c5-7c94-4022-b4b0-31fdf2536af5	1
1d840e64-0880-43ae-8d14-d7a3fba28fe4	1
48f931f7-abf4-498e-8a7d-591b5990b899	1
f81b9942-d3bd-47fd-9977-a0c1c2a14cfc	1
fd4690c5-f9ee-412f-8710-8bd78ae48985	1
da9da278-9fa1-43b0-87cd-594826a0fcd8	1
299c3c82-8ced-42df-b8e5-ac682da0664c	1
3e59414c-d3f0-4c63-ba7d-a425f72b54b3	1
f69759a8-2073-4d4c-be5a-dcb0e0da4acf	1
865a3184-1109-4195-87f1-6d713eae3606	1
28ea5086-4430-4098-9469-17b6f69625ff	1
61430b2c-53f0-43f5-8cb7-bb3e16fd49a6	1
a7240bcd-a764-4222-8b50-b4438a73b006	1
5765feac-f474-4d2d-bb51-9975db16fc83	1
bb35e58b-87bd-4158-9d57-44975e9db300	2
bb35e58b-87bd-4158-9d57-44975e9db300	1
7e8f88a9-b822-411f-9707-b22a9c550cae	1
a419fb29-1e45-4c90-ab03-1707c594e110	2
a419fb29-1e45-4c90-ab03-1707c594e110	1
c6e188d3-f0e4-48a2-a51d-8e45895d5f98	1
c6e188d3-f0e4-48a2-a51d-8e45895d5f98	2
0dcfdb9f-fa2f-4bb0-a206-4cdf472a09c4	3
f2452ca7-11a7-4711-9e4b-c4722fe82ef0	3
eb358f77-8308-46c9-b3ca-5a3de80ffbbb	3
5bae7d43-6678-4494-b5ac-bd401f22b928	3
2ae4aaba-014a-47f7-a2d5-ed11f36cc422	3
f5071c3f-626e-4bc2-bddf-2edbb53c80c2	3
0c96e09d-b956-4537-bfc5-84b47d7df94d	3
d6cbea4c-f5b2-4f4c-8765-ae68ecc45cef	3
d1469c4a-dc73-415f-ab7f-abc2ef35180e	3
989e56df-f77f-4833-861a-f0d483d14851	1
9f455312-742e-4314-a5a9-25e76cddc8b9	1
1ca2a324-6b58-4ad7-8bf5-5d84b3bdede7	1
3b659095-3635-4624-a07f-c2b547ae32e4	1
1171fe7f-d05f-4a4e-a3d7-386702fcd60b	1
6133729e-9d1d-4d34-90b5-e56dbaf386ec	1
c023891d-ef25-4fb3-ac41-2290671aa874	1
a2a329f2-4f33-43ff-a562-ce3407cba32e	1
67e2c791-0083-46db-8349-d2836b8f7b80	1
28ce11b6-5226-42c3-a2d7-77578273887d	1
476f1a64-b192-43b3-b82d-b63f25e66a0b	1
599c7f09-7a89-4698-8397-2c9592331b89	1
d95457f7-a8fd-4d4b-880b-33560a18e7e1	1
b54dc0c2-6837-4511-b086-e76695ba9bc0	1
3bbd2c7b-6e78-4ea7-b79f-546412f8acb2	1
bea4aa5f-6864-4b4c-b0be-7ef9ded81e01	1
f215434d-0261-443e-ac8d-d42288a179d0	1
080bfe65-9bdf-43b6-9629-5cae824f9b4a	1
c6791511-e473-4954-be32-9716b621bcd8	1
a1fa2cb7-de92-47c6-8853-cfe135a41b54	1
af9327fe-313e-4ae4-bfd5-0ec0c0cb99c7	1
4b4fe656-f8b9-4f7f-af9a-ac492d2b4dcb	1
ed1929bc-d5a0-4948-84d5-df4073ec0988	1
316d0b94-4014-4af8-b352-c262c646d3fd	1
9d291b05-5a0b-4b97-90fd-a0eea3e012cf	1
017ab29e-a00b-49d0-a6b4-68dba88d0599	1
d8eaf9aa-8771-409c-9313-b583e0887725	1
b9db97f5-1608-4916-a965-04d82071c554	1
d3c8cbab-2645-45bf-a1cf-82b9baefc553	1
e00df4a7-9136-44b6-b321-ff1399fad098	1
05cfcdde-434e-4eaf-8b3f-2e46755264db	1
cf3d57c3-3ae8-4255-9043-62736e94a06c	1
33f9d01d-b7d2-4b73-ad7a-e0154d0f792f	1
1901eb3a-7c02-4cea-86ba-de18ff559ee1	1
a49b6317-fe61-4fb6-ae50-daac2d0a3816	1
0786bcd3-2e8e-46b5-a65d-2c955218b8ab	1
e5b061f2-610b-4786-8309-ba113aad296f	1
e131a1d6-ec3c-472f-bc98-b6fd221cd7fc	1
a7ebb9f5-a7d7-4620-87fe-28c7ab255381	1
5696b8f6-02b3-4532-bc0c-a7b9b686bf68	1
a67f58ba-5b15-498c-a57c-07e20d24a4ce	1
79c97127-14a6-418a-b9f7-1fde0774e7b5	1
28811039-3078-49c3-8222-7695806ee1ac	1
ef0454f7-d69a-4344-8ac9-9693e4fc38aa	1
5bd98ad9-a73f-4d77-9007-c7a0b30c986e	1
5bd98ad9-a73f-4d77-9007-c7a0b30c986e	2
431ea127-22c0-4e8a-b7e3-a7f0c7acaa76	1
bcb5ed35-a994-451c-a9c5-816f815032d0	1
fceeec77-bbcb-4292-a1ef-c2253be91094	1
277f0277-dbc7-481b-9e45-ba108d8f1911	1
42359d61-8ba5-4947-8823-3a981c3b35b1	1
66076e01-5670-4571-a236-074fed3a7342	1
95001aed-22b7-4d52-9aea-38bd4b4a7b54	1
ab9b8f12-3bfd-45ec-8c05-05756eb223ca	1
17ed210b-5e04-4e3e-a1a1-1fdd511b7e30	2
17ed210b-5e04-4e3e-a1a1-1fdd511b7e30	1
3f4d6090-beb2-4de5-b887-654035b2ab07	1
29c21f02-b398-4ce2-8fd6-a53a93e5727b	1
fc7f0bbd-8a36-40e4-ab41-de56aee6b383	1
d73b22af-20dc-429e-954d-a591b44b18f8	1
a953729e-6681-4c98-86d7-e891999dcad3	1
078632cf-fc79-4d28-9fa3-69e4dea84ee7	2
078632cf-fc79-4d28-9fa3-69e4dea84ee7	1
d848ee34-88c3-481e-84ad-c4e5a1f6a1ce	1
5ed01ed0-8b75-4038-9b36-46a6ffb9b743	1
1e6c1d08-c4e5-455a-aef9-362a839e045d	1
b9300ab5-b98c-488e-b660-0c07752e3fd4	1
3ac0c3a0-07a2-4469-b227-b6237b6c50fc	1
c3df60dd-0e74-4560-b5cc-684a6344bb67	1
5018a3c7-a908-46c8-946e-893da3724e6f	1
21ac255e-ea43-416a-ab69-8d23a1d26e0f	3
bb407877-7dc2-41a4-8f87-d3bb38cca262	1
3a86b88f-9368-4547-9f4b-d20d6fd38fd4	2
3a86b88f-9368-4547-9f4b-d20d6fd38fd4	1
698e9cff-9475-471f-ad18-c869a6407b6c	1
698e9cff-9475-471f-ad18-c869a6407b6c	2
9358b67d-e110-477c-83d8-c456453ed53a	1
e97f39b4-18d0-4e56-87b2-a8ff33c9025f	1
d6267e9b-f2e1-46ca-92fc-72f592f12b1b	1
972cf628-c286-4e94-8351-2e8993ecd1a5	1
58fd19f5-fb00-48a5-988d-5a55b5891181	1
3672e187-d6c6-4487-adff-b10a2872c817	1
6d0508d3-41e7-4db8-8461-451691d2d8b7	1
b9942da1-c34f-4223-8720-58af2deb62f3	1
8b192c7e-49f8-48a6-a116-eec5a3af8b20	1
313c6356-433e-493d-bc78-e5dfd0a0cfad	1
0375bcb4-c667-48d5-bcd2-b834be90329b	1
867b747c-27ab-4ad1-9544-0475b24a4fef	1
43097049-1164-47b4-9f4c-430a5df195ba	1
1346aca6-353a-4f6f-a184-00f503fb05ea	1
df321c58-ccaf-4796-a613-1762d17b8009	1
4809051d-27ac-4d8c-b5a3-ede7df04c50d	1
4affe0c6-16e8-4a89-9467-9f98fbe5ccf7	1
932969f5-a2f2-4ee6-938f-7aab7f2e0969	1
5c60e40b-c7d5-477f-8bb9-d1a4d9217348	2
5c60e40b-c7d5-477f-8bb9-d1a4d9217348	1
4d138ea2-62cc-4703-bb3b-c97885a0ffc7	1
2ac74791-7577-43b8-b0af-7d2b4877664a	1
0a665cc9-959c-41c6-9b89-3b530a9c9e02	1
29aae360-84b9-4615-a58e-c0085ea5d921	1
789ad328-e77d-4963-9801-609420ac5ab0	1
7cf44e5f-9067-4543-a50d-01b9d458c65b	1
33ef5780-eec0-467c-a2d8-0c6fb7b03081	1
fa4a8281-b39a-4889-9a83-0fb44ca8723f	1
ed681fc8-d0fc-4a5f-a928-0bc7c1cad6d4	1
34a2138c-77ac-4e90-8741-f6eb9f9807ee	1
3b809984-ad54-49f9-b477-375f3e292f67	1
6cfabcc1-12ec-42f9-82ad-a1c13ff6ce68	1
f7b0baed-79b4-468b-801a-4c56f114662e	1
d31f9df9-8b87-485a-8ab9-fbfddece5014	1
b7545269-2e72-4e28-81a0-1cf6e5b15c11	1
3ab76406-e93a-44f6-9f3d-e9902119c5f8	1
7006fd0e-8ece-4ab1-b0e9-93550917f925	1
e9a067f2-c5a5-40a1-a407-2f43b1a5fd32	1
0f53d512-f34d-48f8-a0ea-a25bc319d9c2	1
19774f9c-f54f-4359-857b-34d609b62b58	1
350d9e20-e09f-462b-9761-ace26a1a39fb	1
b060039d-e209-4c18-b9aa-62b28f5b80c9	1
a47241cb-5f21-4c18-be93-f8f1efb2d4d6	1
b7a6e9f8-c29a-4790-8d10-a705079906b5	1
6f3636bb-bd03-419d-80c9-4a006f25a965	1
d7466330-c1c4-47e5-bac0-98a2fd96618a	1
4913d2f7-67c9-4430-9ba3-f9b6bfb8a7d5	1
b35eab5c-7c05-4560-a33e-bc4868fbcfc2	1
3971a4e1-6044-4e26-a866-555395e5ee10	1
c2f25b64-d425-4b53-afdd-289c7bdeb5c0	1
4e8b6432-2315-448f-9547-c8c65c02e3fe	1
8fc9266d-5c9c-4c1a-bc34-712cb8777a06	1
715811b3-7dc0-45d2-bae1-22fc0eb53336	1
2c76684e-ba16-437f-93c5-b1d40a04eae7	1
40e5d110-0cdc-4d52-9180-05fb7f13c9db	1
120c765f-1cd1-4917-8baa-668d35a0e240	1
0024f17b-e0a5-4628-b4fa-6adcda56c746	1
b8e11e83-cbb1-4c74-8ef6-247847b743ec	1
4aa9f5c6-99a5-4d75-b753-54e3fc78e93c	1
e03d59d2-d4b1-4db7-8b3c-b9abd14d4b01	1
0b5d3157-56a3-459c-8560-768edee1e4f0	1
cf164465-2eed-430a-ae69-8479b55d098f	1
2adf9665-1f3d-42b8-9926-f594aac2f0ff	1
8e1da24a-731c-46ad-89c2-014d0b0abbab	1
6f98e4e2-c74d-4ec7-9466-1e1d124612df	1
0840a1ed-01b0-46ae-aa89-e9e836fb21a2	1
0863166f-24f6-4add-82ed-1676dd03faa0	1
c315d0f6-f15c-4fc0-87dd-430ed1f47672	1
7a5a35ca-a8dd-401d-8b1c-5d4c76f5e55f	1
b64837cb-2e32-4646-b070-dfdc013ca3fa	1
708b45fb-e628-4b57-9e6d-8b6fcbf75ecf	1
ce0e409a-3e12-42be-89a1-dedd40896d2b	1
b817e23a-425e-4fc1-9ee8-cb83e8dadc60	1
87a0c571-e36d-40f3-890b-03a239e0ab0e	1
98c5ac17-5b37-4c2d-b97f-eaf06972d325	1
d057614d-0f21-42a0-a6f9-bc7e2e270e87	1
7a302faa-2796-4313-9fa0-9e2701ee2a0b	1
0fd28df1-5e05-4481-9455-076e0ee6e9af	1
3a0df300-b644-43b2-8ff2-baf58db0a9f5	2
3a0df300-b644-43b2-8ff2-baf58db0a9f5	1
c7d37063-3bf9-44a6-9873-614094386af7	1
b5cfcae1-90ca-42a1-be0e-7592b74040a8	1
bb305338-a523-474b-9c37-5042e4dc9b4e	1
fa5fbe96-3eb2-4896-8e64-35a9b8344a21	2
fa5fbe96-3eb2-4896-8e64-35a9b8344a21	1
2037557c-bf1d-43cf-a39d-0207d6ec0ede	1
00a1e05a-16e2-40e2-af56-1dcd9feb1dcf	1
49f22de2-c773-447c-b1b3-74b95ad689a4	1
a00c85b2-4b86-4390-b4b3-eca8694891f5	1
15fc2d88-7e0a-4882-a2bf-48a24c243db9	1
dfc0b856-0015-4d56-ba9a-e59151d00dc2	1
d3cd05be-7e6d-4902-95f5-a44bf407bacd	1
e5082a29-995c-4960-b419-6a23258e7054	1
00658e2b-6de4-454c-a530-ed86ffebf67e	1
79280daf-9caa-4e62-904a-02b118e9f83e	1
fb6327cc-86a0-4f0d-8e94-c55c5c709bd3	1
a03a8673-323c-401e-b00f-ea06b3889687	1
a4509e82-820f-4c6e-aae2-af656e916bf7	1
b6b7c42d-f686-438d-ad53-df8744cd8a58	1
0043366f-7e4b-46fd-ac9d-aee29c6dd59f	1
e1b3304f-5bc4-4369-bd98-3c5a4fe7149b	1
6f5cdd96-95a4-42a9-a7a7-a5078910298b	1
5b74f86c-8faa-4b96-8881-aaff4ce207c6	1
4575084a-33d9-4ec5-a96c-2d9ad75eb16a	2
4575084a-33d9-4ec5-a96c-2d9ad75eb16a	1
758fec20-ce70-49cc-a596-1ec274d43e7b	2
758fec20-ce70-49cc-a596-1ec274d43e7b	1
80b860e3-a6b8-442e-86de-f7d4f954f47b	1
023f5b27-4fbb-4831-aae4-4f493baba6cb	1
0de4090f-efc6-4442-a646-295c53255ed8	1
f6bef4c6-30e7-4a99-bca9-193f9cd9d3cc	1
0bd35561-1d28-4791-8d44-28875ac80409	1
622afca8-954a-4432-952e-b414a35015f1	2
622afca8-954a-4432-952e-b414a35015f1	1
a0b70ac1-2369-4ab3-ac39-704c331f6bc1	1
65bb454c-788a-45f5-b9be-b1fc99e11f0c	1
16f7834d-cab3-4f22-87fa-2b1678bf6a2a	1
b28a7d92-ceea-4af5-94d6-b248549f94db	1
55ea21ac-5d08-4797-8b8c-f786b5fa66a8	1
a407d40a-3df6-438f-9c8e-a776b9e64620	1
e4c4d6ae-e4f9-442e-88ed-147c738b1032	1
fd88c589-5031-4499-9b6b-7eb47e8e4186	1
eef9c57f-3e29-4914-802a-768c7d288084	1
8d3f81a4-8688-40ef-a191-f88c6a8e785a	1
1d0787b0-3e1a-4b0b-b515-72c4207c50ab	1
d19e1c25-51aa-4e24-adae-8f69a7d87454	1
284be977-1d57-4d2d-a2e3-543878786244	1
c6b1a8c6-8805-4e13-8300-0610feba12d1	1
52d317e6-92bf-41db-86e3-d3e37d792b49	1
e842b215-6353-4695-ad46-9e44ddc5dad6	1
f59a639c-5f5f-420a-9809-1a5ea967474a	1
66c17f1c-f583-4c9d-8e77-5942f3d53d95	1
6a9a7aa9-274a-41d3-9d10-52d595a0477f	1
50a8c217-bb55-46b4-b3c3-8034b25d2d09	1
09ea9ad0-8839-4879-837b-be72cfdd73f5	1
185fe36d-1c33-48f6-ada4-5ba75f7829b5	1
cf60fdaf-86fb-45bb-8ab4-7314d293f301	1
ce67698b-d1df-487e-a1f9-966bd6739db0	1
861d6961-4f1a-4db7-b591-2f426f56a5b2	1
a91e03af-78cc-4991-9296-423ad62fc899	1
1cf494a2-216d-4568-b00d-8c5f8fe47eec	1
2b51fbe4-944d-40f0-a689-df3ca3369a43	1
bf106a14-9012-449b-a3f2-b4e9acc560b9	1
7a9de0dd-39f5-4d84-b190-d11948eb9b68	1
66d907ea-ef65-425d-a90b-db8cae8c99e5	1
48d1502f-ab7d-4a9d-9a91-6c365e028fe4	2
9fd7c448-de26-4677-b72d-1d85aab16e15	2
9fd7c448-de26-4677-b72d-1d85aab16e15	1
505f8dba-b465-4ae0-84b7-a241ad34e646	2
7acec91b-c7de-4c95-ae18-ed84cbdafbe3	2
e2e294d8-db39-4278-ba5f-e1650c44b500	2
c1302334-fec8-48a6-bb53-5c9f4cbf4830	1
54e7d5af-2e0f-4c67-a3b1-54cd4218c9cd	1
c8decee8-6865-4f78-84b2-01144d75040d	1
e626e976-3dd7-44f5-8a38-19779a72fd99	1
2278d559-9c2f-4d6a-bf2a-b2403dcd2724	1
2fa6ce06-3006-486b-b35c-82d217007506	1
5cfc6c97-341b-4a05-8392-432b803b1511	1
89faaf63-0df4-457f-ae62-3ce091cd8910	1
3b2b7616-27df-4656-86da-9ceac6285632	1
b34617e0-9fa1-4969-868b-4f6d0cd4e4aa	1
0a8076f2-f9f5-4e4a-a04b-6ad2e93bc4b6	1
389cf908-bbd2-49c3-bfff-b4996d011c66	1
07cb68dd-6e78-4f7f-b126-00dfba86eb44	1
f11426a2-4bf1-4aa4-8f51-028ff55be6ca	1
d2f7e97a-eee3-4ebe-b8f6-0d3f92f7a130	1
d2f7e97a-eee3-4ebe-b8f6-0d3f92f7a130	2
be31cfac-8838-4411-bd81-124b2a3a481e	1
8f27df91-39e3-4da7-b137-762a4444844f	1
2c23a3de-0ec7-4f6a-85d2-581b9dabe6da	1
eb41f6ca-93ca-4f02-a81b-5ea2e94c6ee6	1
e288ff7c-5f68-422e-80e4-04d829c3793e	1
e2deb4df-8f48-47c3-bb33-6fc37bd13f6a	3
e2deb4df-8f48-47c3-bb33-6fc37bd13f6a	1
3f22bfe9-2b10-47cb-8d99-41e6c54fff2c	1
8a904e36-1ff1-4d69-95ba-3eba5f33cd66	1
a50e9453-3fc6-4fbd-918f-27dadae61376	1
74aaa5d8-9f08-435a-b02e-2959c458680a	1
74aaa5d8-9f08-435a-b02e-2959c458680a	2
b5c02a52-04f4-4f78-b74d-4478902dac7e	1
cc63ef3a-7344-4dd0-aa70-bcdc257eed34	1
430f0fa6-a211-4f1c-ac2a-8a9e1fd643ba	1
2dd4d526-5575-45e5-9285-cf69dee83912	1
e8a0f006-0830-4356-b9fb-f8f95165aff8	1
e8a0f006-0830-4356-b9fb-f8f95165aff8	3
4f700034-7bc7-4773-860e-9d579188b099	1
3b979a22-93e5-4f44-80f0-b843cce355e2	1
1118f1c5-35d3-4a49-be56-a93869ab8387	1
074c4480-4ef1-4daf-a02a-aac169bab7ee	1
fbbe7037-c23b-4f73-ae3f-879d40e51650	1
00050568-175b-4ac2-96de-b92c451691f8	1
d386d78d-d6b3-46d1-9b82-ca95d1864774	1
5bdc135d-c505-4cee-b6ca-ce49ed3fac52	1
8c1446bd-0a4e-40cd-a26a-0f097b1c1b9e	1
dd70a898-48e5-4a83-833c-d57da8e1c5fb	1
784b56c3-d281-45b7-b11c-343938bc5b13	1
53f5ec1a-e275-4e85-a8c0-532fef9b57bc	1
53f5ec1a-e275-4e85-a8c0-532fef9b57bc	2
ae4ddfbb-3d13-403c-b59b-0f92cc3e0627	1
d6743769-601d-4806-94ef-f5ed2a6c93f8	1
cb5d9aec-39e4-4423-82a9-644d3861ad9e	1
b967e91f-d61c-43df-b9f3-49a31c1d2db7	1
4c46173c-2e5b-40cf-80ce-0f3910db5064	1
321ad9bb-7d33-4dce-93aa-fddd264d3443	3
321ad9bb-7d33-4dce-93aa-fddd264d3443	1
827d3f45-f8ec-4139-9ae2-565f33776469	1
811a1a75-5725-4df2-96e6-9e7e6bcd9a98	1
2321a9e8-b01c-4dee-9bda-523834362c85	1
7f8f79bd-9d3a-4d14-90ba-22ab156b9342	1
2e3693ec-e8dc-4cdc-94f2-7251a1d95b91	1
ca3b8e66-f7f2-42a9-ab95-2cb46a1cd619	1
85ff5ac8-7ca0-402c-8dd9-e6ca46925ea4	1
53c50a4f-cae0-4912-95ce-d64693c554d8	1
d4be79e2-d5c5-45ac-9025-272f70eb360d	1
27fe1367-5d6a-446b-a6f0-e0e3e87e91de	1
f90f4069-0b58-4cd5-b037-a0d23b59a823	1
d2bbacc0-e9ea-4763-b945-753361a51ecc	1
7600f77c-d799-40d2-a246-848721ed8051	1
0785be95-5804-42b1-916b-0be966d583e0	1
a324a408-9425-4fe2-b08f-8fe6741d96c2	2
f832aff1-bb3c-421d-a7d2-8ef0cb2a7941	1
e086974f-5ac9-4d3f-9cf3-aa12a9db8808	1
28c56e90-0aa4-4ccc-b1fc-2ddc6aab2bd2	1
72bff958-63d1-4fe9-92cf-5485c219b8ce	1
b1251b71-f7fe-4a0e-a865-84adec3cde90	1
5005a23b-67b5-4292-aa4d-c0d8f2dea29a	1
26dba188-bbf8-4be3-b984-9fd1b1195c5a	1
8f9941b7-5c5c-4345-94d3-32aaab6aca58	1
6adacc1d-54a5-4818-933f-2874e581560d	1
2dc8f962-0f80-4008-ab71-4e6860238332	1
54d73f0a-2d18-4d85-816e-c6007ae01583	1
54d73f0a-2d18-4d85-816e-c6007ae01583	2
528d2aa4-ea02-449b-9c0e-782e2bfec418	1
c6910f69-e6d1-4aa6-bda6-a676b7182e2f	1
4b308bce-2444-4711-9503-e17939012d4f	1
e942e98e-425f-4d51-a001-9281b4b47260	1
6f0c9a55-400e-48ad-8bc5-9b3324f8bddc	1
8860e79a-d38b-4265-a6a9-aa2639428f56	1
5bd62008-a487-4281-81e2-c0e2b4177091	1
5bd62008-a487-4281-81e2-c0e2b4177091	2
bb32ba75-a22c-4507-9c92-2b952756db94	1
bb32ba75-a22c-4507-9c92-2b952756db94	2
927074d2-ed34-4665-986a-40e26f61df6f	1
b8ee0544-fef3-4371-824d-1ce619a589de	2
b8ee0544-fef3-4371-824d-1ce619a589de	1
57876120-02eb-44f1-bf43-3bbd82b85414	1
4774147a-a2d3-4705-a0ce-3264a98575b8	1
9d27127c-1468-434d-b2ff-a46c8d134bba	3
6a049afa-ea90-4118-bbc2-8b5d285d6e8f	1
fe0fbc1d-8b90-45bd-8885-49dd5d216a15	1
5edc7dea-b448-4ee1-90d1-61df8f65fca4	1
08fcbb09-e6a1-4e13-8c1a-ccd6fb14dea0	1
6ff8936f-db00-4c3d-a549-c90f03fc297a	1
05ea1a0b-a7ab-4b32-a6fe-97aa04c3002b	1
9aafbe96-16ac-46a2-9466-0482b300bcbd	1
c9eda977-381a-42d2-a620-2d5b1afbd56c	1
a97a2646-9e7c-4a40-8e88-cae48c4200af	1
a08995e5-b8a5-4f67-8e05-77ba4a1ce710	1
c26e7139-9000-4d44-a12e-981d553309c1	1
cf837ea1-f998-4ba0-be59-4b7ab81e3e55	1
1ee604e2-db20-461c-91d5-db5f24d3596a	1
912e3750-258a-4422-9abf-9a40d33ff34d	1
c47b44d6-fda1-45a0-8860-fc7d4a2c0755	1
31c1326e-e080-4a26-ba8c-2ab4ade5b524	1
31c1326e-e080-4a26-ba8c-2ab4ade5b524	3
9167c93d-789f-4a1c-826c-f8a46b9872ef	3
9167c93d-789f-4a1c-826c-f8a46b9872ef	1
701bced5-9cef-47ee-8901-9230f5e763be	3
701bced5-9cef-47ee-8901-9230f5e763be	1
a59dc0bc-b43c-40c6-8768-24c5bc92b47e	1
7d846086-572e-43a2-9654-5edda6e4e1ed	1
e9455682-ff87-4f1c-8816-6cd6ccd57949	1
5f83ecc3-d4ef-41d4-8fb3-7a1a71207ae3	1
f244a100-e7f9-4060-ac78-20223c5d104c	1
58a6dd13-e451-4b32-8ea4-749fa2e91d3c	1
4945f830-9930-4f41-8286-e7fd1f8b3274	1
a0d1557a-0343-4ef0-a787-0489c3fae7f5	1
82422053-d7fb-490e-84c3-4f5f776c0990	1
82422053-d7fb-490e-84c3-4f5f776c0990	2
2d4daf51-c1f9-48b8-ac76-ea25842b809f	1
e5703ffb-cc7d-4b22-a071-bd66cf487f05	1
5abbb529-e469-46b2-91d4-0bd6249e4bb3	1
b9deac75-2af0-40c3-840a-c4078ba68487	1
bd93d05f-d6ff-44df-af8d-b181df4c9a2e	1
09c9b84d-80a5-4a51-90f7-28476add7b6e	1
07b1b806-652c-4a23-8c61-05612c3f1f94	1
c582d14d-dc01-479e-96ce-a82015f7129d	1
0e4c9acf-5b13-4c55-aeec-fdaf68c548b1	1
f846407b-627f-48f3-a11c-ed922cac35bb	1
27f4dc31-3e52-4784-a4a4-e135906619cf	1
2b0bd6e6-b4b9-4474-92ec-782999231f90	1
2fa3aec5-2c18-4c15-a544-e427fcfd04a1	1
0105ab68-a360-4bb8-9f7b-247f1b6bd6b2	1
d66abbf2-d733-4f6c-879f-c26aa73b226f	1
ffc8329c-9bac-472d-8c88-bd661ca89d76	1
e75c8729-02f1-4dd0-9542-bb061427c8f1	1
b47d0845-6674-41c8-82a9-99175aa634ca	1
de7bec8d-89a3-454a-889c-cf4214006386	1
3f33d494-3651-4a1d-921e-3cb9ebb2a2b1	1
b312b774-11e3-4576-ab10-f9fc404e8e29	1
14fcbee8-bf6b-428b-a3f1-325af632a365	1
87603370-6158-4c99-b972-0bfcb6fddb56	1
d9ad84f7-6b2b-44a5-b943-3a09d51257e7	1
6bc7ee70-9171-44f4-8235-4abb80ce492f	1
86141a37-ce63-4534-b67c-3c6ae9d99797	1
febaddd8-3b24-47c1-9863-020861993e61	1
d8e4b01e-2524-4614-ab04-97ae90f7cef9	1
ca355235-f4a9-4fcf-a03f-e428587ca061	1
2397a98d-bb2f-44b9-9b49-2ae29ab13a24	1
7e57572d-db4d-49b5-a228-f894773d1797	1
17aaea4b-bc69-4f3d-8f56-894453489bb7	1
51b95a12-44ba-4fe1-9da0-4b6c25e32b1a	1
51b95a12-44ba-4fe1-9da0-4b6c25e32b1a	2
b10a9d5b-c69e-4e09-a8ce-719e64a5fa36	1
6ae1ee95-22c0-4717-8d49-bb4402ecad47	1
7b1e0a29-e9e4-46a6-be85-3842fcde05d6	1
e59b0b6f-38d9-452f-bcba-25c54db9b156	1
ab87ffa2-3f1f-4986-a9a4-dbcdf24d7ad9	1
49515d26-046f-4b7c-91d1-8d56fa64a258	1
6bf49713-0aa6-4180-b3de-3e003928a602	1
8d263b76-fefd-46e2-8c88-023aa3c39df0	1
e9f4b352-101e-4508-a599-b76411852cc5	1
8f053ce5-7743-4f5e-8898-ec24f5345c6d	1
38dfd2c3-ff54-420f-bd93-a323203686d8	1
1b69a7bd-1ab3-461c-ad9c-5230bc348bdc	1
9bf624a7-2907-435d-aa9c-5a85bc1c74ec	1
552d95f5-a6de-4fe8-86c0-3af24207695d	1
663754d9-6233-4eab-8f16-c903672fd3be	1
06aee5e0-6f75-4dfe-8548-c3da620a0b94	1
839a436a-4016-4c71-9db3-f93a72c6bfb4	1
7911f1b9-ac88-43e4-80ed-ed1b911e11de	1
12393c83-74b4-4263-bd47-4c2c48b2736c	1
93a8ec5e-f297-4dff-ad50-5f5c7d8a0693	1
9020e62c-338e-4e7d-b9e0-913ffce241b9	2
9020e62c-338e-4e7d-b9e0-913ffce241b9	1
963dfde1-8d9e-4790-9f3d-1aa0a66ce827	1
963dfde1-8d9e-4790-9f3d-1aa0a66ce827	2
cce47762-fcc9-4183-be2e-39f3e6231d37	1
c96183ea-41f7-4b75-b0c0-e74067d01cbe	3
ed22b00e-e2d4-4302-aed5-a4489340c75d	1
3dddad6f-8a25-48d7-8d03-3e69cd99c6c0	1
3d8f11e9-dbca-489d-a036-02e355913e20	1
7a366bde-8c6c-45e6-a965-43439cbf8ea3	1
d097a40c-7030-454b-9188-aff2770d49ca	1
0b28f7fb-77c7-4838-91dd-2ee714efc586	1
2acbeaed-37a9-4130-8e5d-1a5b202f780b	1
164cf5ff-ba65-4b2c-9c2d-04e569be18ee	1
564849b1-a7d6-4c3f-bff0-2bf4de1c3612	1
77d6bc2c-81ef-4ae4-8c2f-30f083767f40	1
ee3d130e-a931-4c2b-98f0-71e72d7aa866	1
f009a599-81a0-4f83-9c78-78ba22c23fac	1
65168a87-67b4-42e3-8085-e4f97ab99a00	1
b3aa70db-7a07-4d54-8d24-ee32e21bb697	1
61277383-a538-46e1-b916-890a278c9081	1
1573b23c-a47a-4d21-936f-92fa47f2bed7	1
c3fd0dcf-bf20-4a0d-bec8-d383289c76ac	1
93c07785-6ce1-4145-b5ad-e55845294cf7	1
e16db8f7-5f1b-4207-811a-1387297c0d8b	1
4985dfb9-385a-4240-a7c9-b480e0e35f0f	1
36ad352c-081f-405f-879f-b34198db2d31	1
ffc17443-e2d4-4249-baf9-992dbf8d2989	1
1e6fd319-a39b-4316-9aee-f36729520cbc	1
223cef1b-8e90-44ba-9d3a-e04db886ed9a	1
dc154a91-27eb-49f1-8a3b-04ebb2faa627	1
dc154a91-27eb-49f1-8a3b-04ebb2faa627	2
1c54a0ba-896d-4ffc-af15-b268a2815230	1
1c2eb9ac-606a-4ad6-b86e-427ccac7cfc7	1
5492da96-5740-44f2-adcd-5c19deeedefd	1
1a408a2d-7ff3-475e-b33c-f6cce70f5813	1
1a7ed071-0dc4-40aa-b913-0ea297ab7f1b	1
b9413a6c-d5f4-4af8-b964-d6452f7ec184	1
d8e403e7-b424-4ea3-96e0-c119f91ef384	1
6772375b-0b2d-48bd-b1eb-003c960dff42	1
8f2d7678-1dc3-4e9c-8176-ccf6ddb3a848	1
26048055-6a5c-400d-bac6-8aa859fc7bee	1
a3e5cded-0d28-4615-90e3-0b36b2736aa8	1
e334935f-3b7f-4595-ab7f-f43d201d979d	1
b389c041-71f0-4b12-a276-8d9818a3d134	1
321c6da7-6557-4ee7-8e4c-99e941ce8139	1
cdb71b50-b71d-4bde-8351-41008b46c11a	1
22d125f4-99ed-4f08-af85-32d1198e4085	1
e0077224-3faf-454f-ac45-3240b397f880	1
cf5cbcce-2c9e-4499-9544-24d97d69cd57	1
5f5e90a0-805b-45b3-9747-569614688c0c	1
641ec099-ae1a-4ac7-8ba2-c0adb85ea2ac	1
74774577-c266-461d-b068-97e2285e0ef9	1
e347ec82-a54a-40c0-97cf-e2785a7c3253	1
07910790-9d9e-4c84-8f23-c75bacc3f82f	1
7929df3a-c3e2-44c2-9a67-880cb1e2740b	1
61ac5798-f150-4dab-a76b-d6690967ecfa	1
55407c6b-e3ad-4451-a575-09ab869167d1	1
5d050834-9c7a-4d6c-b705-61c4bbd94665	1
9cc5c12f-7b6d-4785-b3c1-3b689d3b5d14	1
f0a6ebe2-eaca-4a2e-b7b5-18668364b31e	1
956493ff-c490-4fb0-a014-68cdbe8e7f42	2
956493ff-c490-4fb0-a014-68cdbe8e7f42	1
29408e38-ef13-4421-a8f2-c2a121a7ab2a	1
e14df28b-c552-43d9-b6f6-916029add7c8	1
ee75b2b2-c3dc-46f1-b943-ad2fe0ebfad5	1
2f0b521f-d365-4f23-b35b-27af92ded2ac	1
8f4e866e-f320-4356-b6a7-bd102fb75276	1
e8e71b42-2ced-442d-a3ec-47465ba5f622	1
4f27d24c-b889-4346-bc5f-51e7835e98c2	1
a93fa8a6-d9a7-40ce-bf1b-f95b52ebf30e	1
1a0b5632-1558-44f5-8e72-320993b492dd	1
8fd63640-eb6b-4b05-bc10-40f038d70c26	3
d45bf7d7-74e8-479a-a0b0-66e427df1bab	1
2c0ff467-ee3c-4460-bc3c-9e42d2f47bef	1
51a4f9a3-af8e-4e01-8826-deb537672b39	1
9e292f9f-e60e-4d9a-8758-cb991b9100ce	1
f9705093-d763-4c2c-a31e-8f8a8f53be74	1
f9705093-d763-4c2c-a31e-8f8a8f53be74	2
e519cf49-a1b5-4dc9-a7e9-768f86d8b744	1
\.


--
-- Name: action_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.action_logs_id_seq', 4, true);


--
-- Name: game_session_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.game_session_details_id_seq', 30, true);


--
-- Name: game_sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.game_sessions_id_seq', 5, true);


--
-- Name: games_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.games_id_seq', 3, true);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_id_seq', 1, false);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 2, true);


--
-- Name: topics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.topics_id_seq', 60, true);


--
-- Name: types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.types_id_seq', 4, true);


--
-- Name: action_logs action_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action_logs
    ADD CONSTRAINT action_logs_pkey PRIMARY KEY (id);


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
-- Name: user_game_settings uq_user_game_settings_user_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_game_settings
    ADD CONSTRAINT uq_user_game_settings_user_id UNIQUE (user_id);


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
-- Name: vocab vocab_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vocab
    ADD CONSTRAINT vocab_pkey PRIMARY KEY (id);


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
-- Name: idx_action_log_action_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_action_log_action_type ON public.action_logs USING btree (action_type);


--
-- Name: idx_action_log_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_action_log_created_at ON public.action_logs USING btree (created_at);


--
-- Name: idx_action_log_resource_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_action_log_resource_type ON public.action_logs USING btree (resource_type);


--
-- Name: idx_action_log_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_action_log_status ON public.action_logs USING btree (status);


--
-- Name: idx_action_log_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_action_log_user_id ON public.action_logs USING btree (user_id);


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
-- Name: idx_vocab_topic_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vocab_topic_id ON public.vocab USING btree (topic_id);


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
-- Name: vocab fk7qogloulpjcrjq1hyby2jf9f5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vocab
    ADD CONSTRAINT fk7qogloulpjcrjq1hyby2jf9f5 FOREIGN KEY (topic_id) REFERENCES public.topics(id);


--
-- Name: notifications fk9y21adhxn0ayjhfocscqox7bh; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk9y21adhxn0ayjhfocscqox7bh FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: action_logs fk_action_log_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action_logs
    ADD CONSTRAINT fk_action_log_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: game_sessions fkb1wbt36yrcq4dbrjgneswj7q6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_sessions
    ADD CONSTRAINT fkb1wbt36yrcq4dbrjgneswj7q6 FOREIGN KEY (user_id) REFERENCES public.users(id);


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
-- PostgreSQL database dump complete
--

\unrestrict Cc6JvX4wpIduzDNUrtzPXO07PNrzkGe9X1C7ctTaC0ejt8gyJdABSNDuIapcgTS

