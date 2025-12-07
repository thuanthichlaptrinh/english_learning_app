--
-- PostgreSQL database dump
--

\restrict gaGpXq0mdOJV6O3SYtzJT0ogimfkAGPl9eRbA5Pm03BMVoy0DD24TFzjfEXuH3C

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
-- Name: action_logs; Type: TABLE; Schema: public; Owner: -
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
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    user_email character varying(100),
    user_name character varying(100),
    action_category character varying(50),
    metadata text
);


--
-- Name: action_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.action_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: action_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.action_logs_id_seq OWNED BY public.action_logs.id;


--
-- Name: chat_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_messages (
    id uuid NOT NULL,
    session_id uuid NOT NULL,
    user_id uuid NOT NULL,
    role character varying(10) NOT NULL,
    content text NOT NULL,
    context_used text,
    tokens_used integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chat_messages_role_check CHECK (((role)::text = ANY ((ARRAY['USER'::character varying, 'ASSISTANT'::character varying, 'SYSTEM'::character varying])::text[])))
);


--
-- Name: TABLE chat_messages; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.chat_messages IS 'Store chat history between users and AI chatbot';


--
-- Name: COLUMN chat_messages.session_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chat_messages.session_id IS 'Session ID to group related conversations';


--
-- Name: COLUMN chat_messages.role; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chat_messages.role IS 'Message sender role: USER, ASSISTANT, or SYSTEM';


--
-- Name: COLUMN chat_messages.context_used; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chat_messages.context_used IS 'Context data used to generate AI response (FAQ + DB data)';


--
-- Name: COLUMN chat_messages.tokens_used; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chat_messages.tokens_used IS 'Number of tokens consumed by Gemini API';


--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: game_session_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.game_session_details (
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    is_correct boolean NOT NULL,
    time_taken integer,
    vocab_id uuid NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    session_id uuid NOT NULL
);


--
-- Name: game_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.game_sessions (
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
    user_id uuid NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: games; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.games (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    description character varying(500),
    name character varying(100) NOT NULL,
    rules_json text
);


--
-- Name: games_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.games_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.games_id_seq OWNED BY public.games.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    description character varying(255),
    name character varying(50) NOT NULL
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: tokens; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: topics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.topics (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    description character varying(500),
    name character varying(100) NOT NULL,
    img character varying(500)
);


--
-- Name: COLUMN topics.img; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.topics.img IS 'Firebase Storage URL for topic image';


--
-- Name: topics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.topics_id_seq OWNED BY public.topics.id;


--
-- Name: types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.types (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    name character varying(50) NOT NULL
);


--
-- Name: types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.types_id_seq OWNED BY public.types.id;


--
-- Name: user_game_settings; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_roles (
    user_id uuid NOT NULL,
    role_id bigint NOT NULL
);


--
-- Name: user_vocab_progress; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: vocab; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: vocab_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vocab_types (
    vocab_id uuid NOT NULL,
    type_id bigint NOT NULL
);


--
-- Name: action_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.action_logs ALTER COLUMN id SET DEFAULT nextval('public.action_logs_id_seq'::regclass);


--
-- Name: games id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.games ALTER COLUMN id SET DEFAULT nextval('public.games_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: topics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topics ALTER COLUMN id SET DEFAULT nextval('public.topics_id_seq'::regclass);


--
-- Name: types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.types ALTER COLUMN id SET DEFAULT nextval('public.types_id_seq'::regclass);


--
-- Name: action_logs action_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.action_logs
    ADD CONSTRAINT action_logs_pkey PRIMARY KEY (id);


--
-- Name: chat_messages chat_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_messages
    ADD CONSTRAINT chat_messages_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: game_session_details game_session_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_session_details
    ADD CONSTRAINT game_session_details_pkey PRIMARY KEY (id);


--
-- Name: game_sessions game_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_sessions
    ADD CONSTRAINT game_sessions_pkey PRIMARY KEY (id);


--
-- Name: games games_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: roles idx_role_name; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT idx_role_name UNIQUE (name);


--
-- Name: user_vocab_progress idx_uvp_user_vocab; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_vocab_progress
    ADD CONSTRAINT idx_uvp_user_vocab UNIQUE (user_id, vocab_id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (id);


--
-- Name: topics topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- Name: types types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.types
    ADD CONSTRAINT types_pkey PRIMARY KEY (id);


--
-- Name: types uk_17go525ou3scbmd4pcftq130f; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.types
    ADD CONSTRAINT uk_17go525ou3scbmd4pcftq130f UNIQUE (name);


--
-- Name: users uk_6dotkott2kjsp8vw4d0m25fb7; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uk_6dotkott2kjsp8vw4d0m25fb7 UNIQUE (email);


--
-- Name: topics uk_7tuhnscjpohbffmp7btit1uff; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT uk_7tuhnscjpohbffmp7btit1uff UNIQUE (name);


--
-- Name: tokens uk_868xfj44b89t1voh058wevbqg; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT uk_868xfj44b89t1voh058wevbqg UNIQUE (refresh_token);


--
-- Name: games uk_dp39yy9j9cn10v9vhyr2j1uaa; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.games
    ADD CONSTRAINT uk_dp39yy9j9cn10v9vhyr2j1uaa UNIQUE (name);


--
-- Name: vocab uk_km7blpn65sakml18nhnnhvxfc; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vocab
    ADD CONSTRAINT uk_km7blpn65sakml18nhnnhvxfc UNIQUE (word);


--
-- Name: tokens uk_na3v9f8s7ucnj16tylrs822qj; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT uk_na3v9f8s7ucnj16tylrs822qj UNIQUE (token);


--
-- Name: user_game_settings uq_user_game_settings_user_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_game_settings
    ADD CONSTRAINT uq_user_game_settings_user_id UNIQUE (user_id);


--
-- Name: user_game_settings user_game_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_game_settings
    ADD CONSTRAINT user_game_settings_pkey PRIMARY KEY (id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role_id);


--
-- Name: user_vocab_progress user_vocab_progress_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_vocab_progress
    ADD CONSTRAINT user_vocab_progress_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vocab vocab_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vocab
    ADD CONSTRAINT vocab_pkey PRIMARY KEY (id);


--
-- Name: vocab_types vocab_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vocab_types
    ADD CONSTRAINT vocab_types_pkey PRIMARY KEY (vocab_id, type_id);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: idx_action_log_action_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_action_log_action_type ON public.action_logs USING btree (action_type);


--
-- Name: idx_action_log_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_action_log_created_at ON public.action_logs USING btree (created_at);


--
-- Name: idx_action_log_resource_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_action_log_resource_type ON public.action_logs USING btree (resource_type);


--
-- Name: idx_action_log_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_action_log_status ON public.action_logs USING btree (status);


--
-- Name: idx_action_log_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_action_log_user_id ON public.action_logs USING btree (user_id);


--
-- Name: idx_action_logs_action_type_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_action_logs_action_type_time ON public.action_logs USING btree (action_type, created_at DESC);


--
-- Name: idx_action_logs_user_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_action_logs_user_created ON public.action_logs USING btree (user_id, created_at DESC);


--
-- Name: idx_chat_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_chat_created_at ON public.chat_messages USING btree (created_at);


--
-- Name: idx_chat_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_chat_session_id ON public.chat_messages USING btree (session_id);


--
-- Name: idx_chat_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_chat_user_id ON public.chat_messages USING btree (user_id);


--
-- Name: idx_game_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_game_name ON public.games USING btree (name);


--
-- Name: idx_game_sessions_game_score; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_game_sessions_game_score ON public.game_sessions USING btree (game_id, score DESC);


--
-- Name: idx_game_sessions_user_game; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_game_sessions_user_game ON public.game_sessions USING btree (user_id, game_id);


--
-- Name: idx_game_sessions_user_started; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_game_sessions_user_started ON public.game_sessions USING btree (user_id, started_at DESC);


--
-- Name: idx_gs_game_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_gs_game_id ON public.game_sessions USING btree (game_id);


--
-- Name: idx_gs_score; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_gs_score ON public.game_sessions USING btree (score);


--
-- Name: idx_gs_started_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_gs_started_at ON public.game_sessions USING btree (started_at);


--
-- Name: idx_gs_topic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_gs_topic_id ON public.game_sessions USING btree (topic_id);


--
-- Name: idx_gs_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_gs_user_id ON public.game_sessions USING btree (user_id);


--
-- Name: idx_gsd_is_correct; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_gsd_is_correct ON public.game_session_details USING btree (is_correct);


--
-- Name: idx_gsd_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_gsd_session_id ON public.game_session_details USING btree (session_id);


--
-- Name: idx_gsd_vocab_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_gsd_vocab_id ON public.game_session_details USING btree (vocab_id);


--
-- Name: idx_notif_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notif_created_at ON public.notifications USING btree (created_at);


--
-- Name: idx_notif_is_read; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notif_is_read ON public.notifications USING btree (is_read);


--
-- Name: idx_notif_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notif_type ON public.notifications USING btree (type);


--
-- Name: idx_notif_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notif_user_id ON public.notifications USING btree (user_id);


--
-- Name: idx_notifications_user_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notifications_user_created ON public.notifications USING btree (user_id, created_at DESC);


--
-- Name: idx_notifications_user_read; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notifications_user_read ON public.notifications USING btree (user_id, is_read, created_at DESC);


--
-- Name: idx_token_refresh_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_token_refresh_token ON public.tokens USING btree (refresh_token);


--
-- Name: idx_token_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_token_token ON public.tokens USING btree (token);


--
-- Name: idx_token_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_token_user_id ON public.tokens USING btree (user_id);


--
-- Name: idx_topic_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_topic_name ON public.topics USING btree (name);


--
-- Name: idx_topics_name_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_topics_name_unique ON public.topics USING btree (name);


--
-- Name: idx_type_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_type_name ON public.types USING btree (name);


--
-- Name: idx_ugs_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ugs_user_id ON public.user_game_settings USING btree (user_id);


--
-- Name: idx_user_activated; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_activated ON public.users USING btree (activated);


--
-- Name: idx_user_activation_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_activation_key ON public.users USING btree (activation_key);


--
-- Name: idx_user_current_streak; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_current_streak ON public.users USING btree (current_streak);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_email ON public.users USING btree (email);


--
-- Name: idx_user_last_activity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_last_activity ON public.users USING btree (last_activity_date);


--
-- Name: idx_user_roles_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_roles_role_id ON public.user_roles USING btree (role_id);


--
-- Name: idx_user_roles_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_roles_user_id ON public.user_roles USING btree (user_id);


--
-- Name: idx_user_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_status ON public.users USING btree (status);


--
-- Name: idx_user_vocab_progress_last_reviewed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_vocab_progress_last_reviewed ON public.user_vocab_progress USING btree (user_id, last_reviewed DESC);


--
-- Name: idx_user_vocab_progress_next_review; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_vocab_progress_next_review ON public.user_vocab_progress USING btree (user_id, next_review_date) WHERE (next_review_date IS NOT NULL);


--
-- Name: idx_user_vocab_progress_user_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_vocab_progress_user_status ON public.user_vocab_progress USING btree (user_id, status);


--
-- Name: idx_users_email_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_email_unique ON public.users USING btree (email);


--
-- Name: idx_users_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_name ON public.users USING btree (name);


--
-- Name: idx_uvp_next_review_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_uvp_next_review_date ON public.user_vocab_progress USING btree (next_review_date);


--
-- Name: idx_uvp_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_uvp_status ON public.user_vocab_progress USING btree (status);


--
-- Name: idx_uvp_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_uvp_user_id ON public.user_vocab_progress USING btree (user_id);


--
-- Name: idx_uvp_vocab_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_uvp_vocab_id ON public.user_vocab_progress USING btree (vocab_id);


--
-- Name: idx_vocab_cefr; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vocab_cefr ON public.vocab USING btree (cefr);


--
-- Name: idx_vocab_img_notnull; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vocab_img_notnull ON public.vocab USING btree (img) WHERE (img IS NOT NULL);


--
-- Name: idx_vocab_topic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vocab_topic_id ON public.vocab USING btree (topic_id);


--
-- Name: idx_vocab_types_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vocab_types_type_id ON public.vocab_types USING btree (type_id);


--
-- Name: idx_vocab_types_vocab_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vocab_types_vocab_id ON public.vocab_types USING btree (vocab_id);


--
-- Name: idx_vocab_word; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vocab_word ON public.vocab USING btree (word);


--
-- Name: tokens fk2dylsfo39lgjyqml2tbe0b0ss; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT fk2dylsfo39lgjyqml2tbe0b0ss FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_vocab_progress fk33pgqxu66c8cqcxntofkb4y2s; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_vocab_progress
    ADD CONSTRAINT fk33pgqxu66c8cqcxntofkb4y2s FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: vocab fk7qogloulpjcrjq1hyby2jf9f5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vocab
    ADD CONSTRAINT fk7qogloulpjcrjq1hyby2jf9f5 FOREIGN KEY (topic_id) REFERENCES public.topics(id);


--
-- Name: notifications fk9y21adhxn0ayjhfocscqox7bh; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk9y21adhxn0ayjhfocscqox7bh FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: action_logs fk_action_log_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.action_logs
    ADD CONSTRAINT fk_action_log_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: chat_messages fk_chat_messages_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_messages
    ADD CONSTRAINT fk_chat_messages_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: game_session_details fk_game_session_details_session; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_session_details
    ADD CONSTRAINT fk_game_session_details_session FOREIGN KEY (session_id) REFERENCES public.game_sessions(id) ON DELETE CASCADE;


--
-- Name: game_sessions fkb1wbt36yrcq4dbrjgneswj7q6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_sessions
    ADD CONSTRAINT fkb1wbt36yrcq4dbrjgneswj7q6 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: game_session_details fkc5ypsx4atnxtbp3nwmn65aa68; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_session_details
    ADD CONSTRAINT fkc5ypsx4atnxtbp3nwmn65aa68 FOREIGN KEY (vocab_id) REFERENCES public.vocab(id);


--
-- Name: vocab_types fkfabr2gt9t8gq2o5sbvlqeni04; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vocab_types
    ADD CONSTRAINT fkfabr2gt9t8gq2o5sbvlqeni04 FOREIGN KEY (type_id) REFERENCES public.types(id);


--
-- Name: user_vocab_progress fkfiilqe47oy4tqrnhjut9k795m; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_vocab_progress
    ADD CONSTRAINT fkfiilqe47oy4tqrnhjut9k795m FOREIGN KEY (vocab_id) REFERENCES public.vocab(id);


--
-- Name: game_sessions fkgpy7f1n4exl7o8hvngciklah3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_sessions
    ADD CONSTRAINT fkgpy7f1n4exl7o8hvngciklah3 FOREIGN KEY (topic_id) REFERENCES public.topics(id);


--
-- Name: user_roles fkh8ciramu9cc9q3qcqiv4ue8a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT fkh8ciramu9cc9q3qcqiv4ue8a6 FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: user_roles fkhfh9dx7w3ubf1co1vdev94g3f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT fkhfh9dx7w3ubf1co1vdev94g3f FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_game_settings fkid0uayock06pjyd23fj5doibb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_game_settings
    ADD CONSTRAINT fkid0uayock06pjyd23fj5doibb FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: game_sessions fklg198vj4h7ejkp6n710neylxx; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_sessions
    ADD CONSTRAINT fklg198vj4h7ejkp6n710neylxx FOREIGN KEY (game_id) REFERENCES public.games(id);


--
-- Name: vocab_types fkm941banl9315i644h1l8htolv; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vocab_types
    ADD CONSTRAINT fkm941banl9315i644h1l8htolv FOREIGN KEY (vocab_id) REFERENCES public.vocab(id);


--
-- PostgreSQL database dump complete
--

\unrestrict gaGpXq0mdOJV6O3SYtzJT0ogimfkAGPl9eRbA5Pm03BMVoy0DD24TFzjfEXuH3C

