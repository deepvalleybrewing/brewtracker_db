--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: brew_log; Type: SCHEMA; Schema: -; Owner: kczadzeck
--

CREATE SCHEMA brew_log;


ALTER SCHEMA brew_log OWNER TO kczadzeck;

--
-- Name: ingredient; Type: SCHEMA; Schema: -; Owner: kczadzeck
--

CREATE SCHEMA ingredient;


ALTER SCHEMA ingredient OWNER TO kczadzeck;

--
-- Name: metadata; Type: SCHEMA; Schema: -; Owner: kczadzeck
--

CREATE SCHEMA metadata;


ALTER SCHEMA metadata OWNER TO kczadzeck;

--
-- Name: recipe; Type: SCHEMA; Schema: -; Owner: kczadzeck
--

CREATE SCHEMA recipe;


ALTER SCHEMA recipe OWNER TO kczadzeck;

--
-- Name: vendor; Type: SCHEMA; Schema: -; Owner: kczadzeck
--

CREATE SCHEMA vendor;


ALTER SCHEMA vendor OWNER TO kczadzeck;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = ingredient, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ingredient; Type: TABLE; Schema: ingredient; Owner: kczadzeck
--

CREATE TABLE ingredient (
    id integer NOT NULL,
    category integer NOT NULL,
    type integer NOT NULL,
    name character varying(150) NOT NULL,
    origin integer NOT NULL,
    brand integer NOT NULL,
    format integer NOT NULL
);


ALTER TABLE ingredient OWNER TO kczadzeck;

SET search_path = metadata, pg_catalog;

--
-- Name: brand; Type: TABLE; Schema: metadata; Owner: kczadzeck
--

CREATE TABLE brand (
    id integer NOT NULL,
    name character varying(250) NOT NULL,
    origin integer NOT NULL
);


ALTER TABLE brand OWNER TO kczadzeck;

--
-- Name: format; Type: TABLE; Schema: metadata; Owner: kczadzeck
--

CREATE TABLE format (
    id integer NOT NULL,
    name character varying(100)
);


ALTER TABLE format OWNER TO kczadzeck;

--
-- Name: origin_country; Type: TABLE; Schema: metadata; Owner: kczadzeck
--

CREATE TABLE origin_country (
    id integer NOT NULL,
    name character varying(250) NOT NULL,
    abbreviation character varying(2),
    continent integer NOT NULL
);


ALTER TABLE origin_country OWNER TO kczadzeck;

--
-- Name: type; Type: TABLE; Schema: metadata; Owner: kczadzeck
--

CREATE TABLE type (
    id integer NOT NULL,
    category integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE type OWNER TO kczadzeck;

SET search_path = ingredient, pg_catalog;

--
-- Name: Adjunct; Type: VIEW; Schema: ingredient; Owner: kczadzeck
--

CREATE VIEW "Adjunct" AS
 SELECT adj.id,
    typ.name AS type,
    adj.name,
    ori.name AS origin,
    bra.name AS brand,
    frm.name AS format
   FROM ((((ingredient adj
     JOIN metadata.type typ ON ((typ.id = adj.type)))
     JOIN metadata.format frm ON ((frm.id = adj.format)))
     JOIN metadata.origin_country ori ON ((ori.id = adj.origin)))
     JOIN metadata.brand bra ON ((bra.id = adj.brand)))
  WHERE (adj.category = 6);


ALTER TABLE "Adjunct" OWNER TO kczadzeck;

--
-- Name: grain; Type: TABLE; Schema: ingredient; Owner: kczadzeck
--

CREATE TABLE grain (
    lovibond real NOT NULL
)
INHERITS (ingredient);


ALTER TABLE grain OWNER TO kczadzeck;

SET search_path = metadata, pg_catalog;

--
-- Name: category; Type: TABLE; Schema: metadata; Owner: kczadzeck
--

CREATE TABLE category (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE category OWNER TO kczadzeck;

SET search_path = ingredient, pg_catalog;

--
-- Name: Grain; Type: VIEW; Schema: ingredient; Owner: kczadzeck
--

CREATE VIEW "Grain" AS
 SELECT gra.id,
    gra.name,
    typ.name AS type,
    gra.lovibond,
    ori.name AS origin,
    bra.name AS brand,
    form.name AS format
   FROM (((((grain gra
     JOIN metadata.category cat ON ((gra.category = cat.id)))
     JOIN metadata.type typ ON ((gra.type = typ.id)))
     JOIN metadata.origin_country ori ON ((gra.origin = ori.id)))
     JOIN metadata.brand bra ON ((gra.brand = bra.id)))
     JOIN metadata.format form ON ((gra.format = form.id)));


ALTER TABLE "Grain" OWNER TO kczadzeck;

--
-- Name: hop; Type: TABLE; Schema: ingredient; Owner: kczadzeck
--

CREATE TABLE hop (
    alpha_acid real NOT NULL
)
INHERITS (ingredient);


ALTER TABLE hop OWNER TO kczadzeck;

--
-- Name: Hop; Type: VIEW; Schema: ingredient; Owner: kczadzeck
--

CREATE VIEW "Hop" AS
 SELECT hop.id,
    hop.name,
    typ.name AS type,
    hop.alpha_acid,
    ori.name AS origin,
    bra.name AS brand,
    form.name AS format
   FROM (((((hop hop
     JOIN metadata.category cat ON ((hop.category = cat.id)))
     JOIN metadata.type typ ON ((hop.type = typ.id)))
     JOIN metadata.origin_country ori ON ((hop.origin = ori.id)))
     JOIN metadata.brand bra ON ((hop.brand = bra.id)))
     JOIN metadata.format form ON ((hop.format = form.id)));


ALTER TABLE "Hop" OWNER TO kczadzeck;

--
-- Name: yeast; Type: TABLE; Schema: ingredient; Owner: kczadzeck
--

CREATE TABLE yeast (
    strain_num character varying(100) NOT NULL,
    ferm_temp_low real NOT NULL,
    ferm_temp_high real NOT NULL,
    ferm_temp_scale integer NOT NULL
)
INHERITS (ingredient);


ALTER TABLE yeast OWNER TO kczadzeck;

SET search_path = metadata, pg_catalog;

--
-- Name: temperature_scale; Type: TABLE; Schema: metadata; Owner: kczadzeck
--

CREATE TABLE temperature_scale (
    id integer NOT NULL,
    name character varying(10) NOT NULL,
    abbreviation "char" NOT NULL
);


ALTER TABLE temperature_scale OWNER TO kczadzeck;

SET search_path = ingredient, pg_catalog;

--
-- Name: Yeast; Type: VIEW; Schema: ingredient; Owner: kczadzeck
--

CREATE VIEW "Yeast" AS
 SELECT yst.id,
    bra.name AS brand,
    yst.strain_num,
    yst.name,
    form.name AS format,
    ori.name AS origin,
    typ.name AS type,
    yst.ferm_temp_low,
    yst.ferm_temp_high,
    tmp.abbreviation AS ferm_temp_scale
   FROM ((((((yeast yst
     JOIN metadata.category cat ON ((yst.category = cat.id)))
     JOIN metadata.type typ ON ((yst.type = typ.id)))
     JOIN metadata.format form ON ((yst.format = form.id)))
     JOIN metadata.origin_country ori ON ((yst.origin = ori.id)))
     JOIN metadata.brand bra ON ((yst.brand = bra.id)))
     JOIN metadata.temperature_scale tmp ON ((yst.ferm_temp_scale = tmp.id)));


ALTER TABLE "Yeast" OWNER TO kczadzeck;

--
-- Name: ingredient_category; Type: TABLE; Schema: ingredient; Owner: kczadzeck
--

CREATE TABLE ingredient_category (
    id integer NOT NULL,
    category integer NOT NULL
);


ALTER TABLE ingredient_category OWNER TO kczadzeck;

--
-- Name: ingredient_category_id_seq; Type: SEQUENCE; Schema: ingredient; Owner: kczadzeck
--

CREATE SEQUENCE ingredient_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ingredient_category_id_seq OWNER TO kczadzeck;

--
-- Name: ingredient_category_id_seq; Type: SEQUENCE OWNED BY; Schema: ingredient; Owner: kczadzeck
--

ALTER SEQUENCE ingredient_category_id_seq OWNED BY ingredient_category.id;


--
-- Name: ingredient_format; Type: TABLE; Schema: ingredient; Owner: kczadzeck
--

CREATE TABLE ingredient_format (
    id integer NOT NULL,
    format integer NOT NULL
);


ALTER TABLE ingredient_format OWNER TO kczadzeck;

--
-- Name: ingredient_format_id_seq; Type: SEQUENCE; Schema: ingredient; Owner: kczadzeck
--

CREATE SEQUENCE ingredient_format_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ingredient_format_id_seq OWNER TO kczadzeck;

--
-- Name: ingredient_format_id_seq; Type: SEQUENCE OWNED BY; Schema: ingredient; Owner: kczadzeck
--

ALTER SEQUENCE ingredient_format_id_seq OWNED BY ingredient_format.id;


--
-- Name: ingredient_ingredient_id_seq; Type: SEQUENCE; Schema: ingredient; Owner: kczadzeck
--

CREATE SEQUENCE ingredient_ingredient_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ingredient_ingredient_id_seq OWNER TO kczadzeck;

--
-- Name: ingredient_ingredient_id_seq; Type: SEQUENCE OWNED BY; Schema: ingredient; Owner: kczadzeck
--

ALTER SEQUENCE ingredient_ingredient_id_seq OWNED BY ingredient.id;


--
-- Name: ingredient_type; Type: TABLE; Schema: ingredient; Owner: kczadzeck
--

CREATE TABLE ingredient_type (
    id integer NOT NULL,
    type integer NOT NULL
);


ALTER TABLE ingredient_type OWNER TO kczadzeck;

--
-- Name: ingredient_type_id_seq; Type: SEQUENCE; Schema: ingredient; Owner: kczadzeck
--

CREATE SEQUENCE ingredient_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ingredient_type_id_seq OWNER TO kczadzeck;

--
-- Name: ingredient_type_id_seq; Type: SEQUENCE OWNED BY; Schema: ingredient; Owner: kczadzeck
--

ALTER SEQUENCE ingredient_type_id_seq OWNED BY ingredient_type.id;


SET search_path = metadata, pg_catalog;

--
-- Name: origin_continent; Type: TABLE; Schema: metadata; Owner: kczadzeck
--

CREATE TABLE origin_continent (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    abbreviation character varying(2) NOT NULL
);


ALTER TABLE origin_continent OWNER TO kczadzeck;

--
-- Name: Origin; Type: VIEW; Schema: metadata; Owner: kczadzeck
--

CREATE VIEW "Origin" AS
 SELECT origin_country.id AS country_id,
    origin_country.name AS country_name,
    origin_country.abbreviation AS country_abbrev,
    origin_continent.id AS continent_id,
    origin_continent.name AS continent,
    origin_continent.abbreviation AS continent_abbrev
   FROM (origin_country
     JOIN origin_continent ON ((origin_country.continent = origin_continent.id)));


ALTER TABLE "Origin" OWNER TO kczadzeck;

--
-- Name: Brand; Type: VIEW; Schema: metadata; Owner: kczadzeck
--

CREATE VIEW "Brand" AS
 SELECT b.id,
    b.name,
    o.country_name,
    o.country_id,
    o.continent AS continent_name,
    o.continent_id
   FROM (brand b
     JOIN "Origin" o ON ((o.country_id = b.origin)));


ALTER TABLE "Brand" OWNER TO kczadzeck;

--
-- Name: category_brand; Type: TABLE; Schema: metadata; Owner: kczadzeck
--

CREATE TABLE category_brand (
    id integer NOT NULL,
    category integer NOT NULL,
    brand integer NOT NULL
);


ALTER TABLE category_brand OWNER TO kczadzeck;

--
-- Name: Category_Brand; Type: VIEW; Schema: metadata; Owner: kczadzeck
--

CREATE VIEW "Category_Brand" AS
 SELECT brct.category AS category_id,
    cat.name AS category,
    brct.brand AS brand_id,
    bra.name AS brand,
    ori.country_id,
    ori.country_name AS country,
    ori.continent,
    ori.continent_id
   FROM (((category_brand brct
     JOIN brand bra ON ((bra.id = brct.brand)))
     JOIN category cat ON ((cat.id = brct.category)))
     JOIN "Origin" ori ON ((ori.country_id = bra.origin)));


ALTER TABLE "Category_Brand" OWNER TO kczadzeck;

--
-- Name: category_format; Type: TABLE; Schema: metadata; Owner: kczadzeck
--

CREATE TABLE category_format (
    id integer NOT NULL,
    category integer NOT NULL,
    format integer NOT NULL
);


ALTER TABLE category_format OWNER TO kczadzeck;

--
-- Name: Category_Format; Type: VIEW; Schema: metadata; Owner: kczadzeck
--

CREATE VIEW "Category_Format" AS
 SELECT ctfr.category AS category_id,
    cat.name AS category,
    ctfr.format AS format_id,
    frm.name AS format
   FROM ((category_format ctfr
     JOIN format frm ON ((frm.id = ctfr.format)))
     JOIN category cat ON ((cat.id = ctfr.category)));


ALTER TABLE "Category_Format" OWNER TO kczadzeck;

--
-- Name: Type; Type: VIEW; Schema: metadata; Owner: kczadzeck
--

CREATE VIEW "Type" WITH (security_barrier='false') AS
 SELECT t.id,
    t.name,
    c.name AS category,
    c.id AS category_id
   FROM (type t
     JOIN category c ON ((t.category = c.id)));


ALTER TABLE "Type" OWNER TO kczadzeck;

--
-- Name: brands_brand_id_seq; Type: SEQUENCE; Schema: metadata; Owner: kczadzeck
--

CREATE SEQUENCE brands_brand_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE brands_brand_id_seq OWNER TO kczadzeck;

--
-- Name: brands_brand_id_seq; Type: SEQUENCE OWNED BY; Schema: metadata; Owner: kczadzeck
--

ALTER SEQUENCE brands_brand_id_seq OWNED BY brand.id;


--
-- Name: category_format_id_seq; Type: SEQUENCE; Schema: metadata; Owner: kczadzeck
--

CREATE SEQUENCE category_format_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE category_format_id_seq OWNER TO kczadzeck;

--
-- Name: category_format_id_seq; Type: SEQUENCE OWNED BY; Schema: metadata; Owner: kczadzeck
--

ALTER SEQUENCE category_format_id_seq OWNED BY category_format.id;


--
-- Name: category_id_seq; Type: SEQUENCE; Schema: metadata; Owner: kczadzeck
--

CREATE SEQUENCE category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE category_id_seq OWNER TO kczadzeck;

--
-- Name: category_id_seq; Type: SEQUENCE OWNED BY; Schema: metadata; Owner: kczadzeck
--

ALTER SEQUENCE category_id_seq OWNED BY category.id;


--
-- Name: format_id_seq; Type: SEQUENCE; Schema: metadata; Owner: kczadzeck
--

CREATE SEQUENCE format_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE format_id_seq OWNER TO kczadzeck;

--
-- Name: format_id_seq; Type: SEQUENCE OWNED BY; Schema: metadata; Owner: kczadzeck
--

ALTER SEQUENCE format_id_seq OWNED BY format.id;


--
-- Name: ingredient_brands_id_seq; Type: SEQUENCE; Schema: metadata; Owner: kczadzeck
--

CREATE SEQUENCE ingredient_brands_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ingredient_brands_id_seq OWNER TO kczadzeck;

--
-- Name: ingredient_brands_id_seq; Type: SEQUENCE OWNED BY; Schema: metadata; Owner: kczadzeck
--

ALTER SEQUENCE ingredient_brands_id_seq OWNED BY category_brand.id;


--
-- Name: origin_continent_origin_continent_id_seq; Type: SEQUENCE; Schema: metadata; Owner: kczadzeck
--

CREATE SEQUENCE origin_continent_origin_continent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE origin_continent_origin_continent_id_seq OWNER TO kczadzeck;

--
-- Name: origin_continent_origin_continent_id_seq; Type: SEQUENCE OWNED BY; Schema: metadata; Owner: kczadzeck
--

ALTER SEQUENCE origin_continent_origin_continent_id_seq OWNED BY origin_continent.id;


--
-- Name: origin_country_origin_country_id_seq; Type: SEQUENCE; Schema: metadata; Owner: kczadzeck
--

CREATE SEQUENCE origin_country_origin_country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE origin_country_origin_country_id_seq OWNER TO kczadzeck;

--
-- Name: origin_country_origin_country_id_seq; Type: SEQUENCE OWNED BY; Schema: metadata; Owner: kczadzeck
--

ALTER SEQUENCE origin_country_origin_country_id_seq OWNED BY origin_country.id;


--
-- Name: temperature_scale_temperature_scale_id_seq; Type: SEQUENCE; Schema: metadata; Owner: kczadzeck
--

CREATE SEQUENCE temperature_scale_temperature_scale_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE temperature_scale_temperature_scale_id_seq OWNER TO kczadzeck;

--
-- Name: temperature_scale_temperature_scale_id_seq; Type: SEQUENCE OWNED BY; Schema: metadata; Owner: kczadzeck
--

ALTER SEQUENCE temperature_scale_temperature_scale_id_seq OWNED BY temperature_scale.id;


--
-- Name: type_id_seq; Type: SEQUENCE; Schema: metadata; Owner: kczadzeck
--

CREATE SEQUENCE type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE type_id_seq OWNER TO kczadzeck;

--
-- Name: type_id_seq; Type: SEQUENCE OWNED BY; Schema: metadata; Owner: kczadzeck
--

ALTER SEQUENCE type_id_seq OWNED BY type.id;


--
-- Name: unit_of_measure; Type: TABLE; Schema: metadata; Owner: kczadzeck
--

CREATE TABLE unit_of_measure (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    abbreviation character varying(3) NOT NULL
);


ALTER TABLE unit_of_measure OWNER TO kczadzeck;

--
-- Name: unit_of_measure_unit_of_measure_id_seq; Type: SEQUENCE; Schema: metadata; Owner: kczadzeck
--

CREATE SEQUENCE unit_of_measure_unit_of_measure_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE unit_of_measure_unit_of_measure_id_seq OWNER TO kczadzeck;

--
-- Name: unit_of_measure_unit_of_measure_id_seq; Type: SEQUENCE OWNED BY; Schema: metadata; Owner: kczadzeck
--

ALTER SEQUENCE unit_of_measure_unit_of_measure_id_seq OWNED BY unit_of_measure.id;


SET search_path = recipe, pg_catalog;

--
-- Name: recipe; Type: TABLE; Schema: recipe; Owner: kczadzeck
--

CREATE TABLE recipe (
    id integer NOT NULL,
    name character varying(250) NOT NULL,
    style integer NOT NULL,
    batch_size real NOT NULL,
    unit_of_measure integer NOT NULL,
    description text
);


ALTER TABLE recipe OWNER TO kczadzeck;

--
-- Name: style; Type: TABLE; Schema: recipe; Owner: kczadzeck
--

CREATE TABLE style (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    origin integer NOT NULL
);


ALTER TABLE style OWNER TO kczadzeck;

--
-- Name: Recipe; Type: VIEW; Schema: recipe; Owner: kczadzeck
--

CREATE VIEW "Recipe" WITH (security_barrier='false') AS
 SELECT recipe.id,
    recipe.name,
    style.name AS style,
    recipe.batch_size,
    unit.name AS unit,
    recipe.description
   FROM ((recipe recipe
     JOIN style style ON ((recipe.style = style.id)))
     JOIN metadata.unit_of_measure unit ON ((recipe.unit_of_measure = unit.id)));


ALTER TABLE "Recipe" OWNER TO kczadzeck;

--
-- Name: water_profile; Type: TABLE; Schema: recipe; Owner: kczadzeck
--

CREATE TABLE water_profile (
    id integer NOT NULL,
    calcium integer NOT NULL,
    magnesium integer NOT NULL,
    sodium integer NOT NULL,
    chloride integer NOT NULL,
    sulfate integer NOT NULL,
    unit_of_measure integer NOT NULL
);


ALTER TABLE water_profile OWNER TO kczadzeck;

--
-- Name: Water; Type: VIEW; Schema: recipe; Owner: kczadzeck
--

CREATE VIEW "Water" WITH (security_barrier='false') AS
 SELECT wtr.id,
    wtr.calcium,
    wtr.magnesium,
    wtr.sodium,
    wtr.chloride,
    wtr.sulfate,
    unit.name AS unit_of_measure
   FROM (water_profile wtr
     JOIN metadata.unit_of_measure unit ON ((unit.id = wtr.unit_of_measure)));


ALTER TABLE "Water" OWNER TO kczadzeck;

--
-- Name: addition; Type: TABLE; Schema: recipe; Owner: kczadzeck
--

CREATE TABLE addition (
    id integer NOT NULL,
    section integer NOT NULL,
    ingredient integer NOT NULL,
    quantity real NOT NULL,
    unit_of_measure integer NOT NULL,
    duration real NOT NULL,
    unit_of_time integer NOT NULL,
    recipe integer NOT NULL,
    temperature real,
    temperature_scale integer
);


ALTER TABLE addition OWNER TO kczadzeck;

--
-- Name: addition_id_seq; Type: SEQUENCE; Schema: recipe; Owner: kczadzeck
--

CREATE SEQUENCE addition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE addition_id_seq OWNER TO kczadzeck;

--
-- Name: addition_id_seq; Type: SEQUENCE OWNED BY; Schema: recipe; Owner: kczadzeck
--

ALTER SEQUENCE addition_id_seq OWNED BY addition.id;


--
-- Name: recipe_id_seq; Type: SEQUENCE; Schema: recipe; Owner: kczadzeck
--

CREATE SEQUENCE recipe_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE recipe_id_seq OWNER TO kczadzeck;

--
-- Name: recipe_id_seq; Type: SEQUENCE OWNED BY; Schema: recipe; Owner: kczadzeck
--

ALTER SEQUENCE recipe_id_seq OWNED BY recipe.id;


--
-- Name: section; Type: TABLE; Schema: recipe; Owner: kczadzeck
--

CREATE TABLE section (
    id integer NOT NULL,
    name character varying(25) NOT NULL
);


ALTER TABLE section OWNER TO kczadzeck;

--
-- Name: section_id_seq; Type: SEQUENCE; Schema: recipe; Owner: kczadzeck
--

CREATE SEQUENCE section_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE section_id_seq OWNER TO kczadzeck;

--
-- Name: section_id_seq; Type: SEQUENCE OWNED BY; Schema: recipe; Owner: kczadzeck
--

ALTER SEQUENCE section_id_seq OWNED BY section.id;


--
-- Name: style_id_seq; Type: SEQUENCE; Schema: recipe; Owner: kczadzeck
--

CREATE SEQUENCE style_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE style_id_seq OWNER TO kczadzeck;

--
-- Name: style_id_seq; Type: SEQUENCE OWNED BY; Schema: recipe; Owner: kczadzeck
--

ALTER SEQUENCE style_id_seq OWNED BY style.id;


--
-- Name: style_water; Type: TABLE; Schema: recipe; Owner: kczadzeck
--

CREATE TABLE style_water (
    id integer NOT NULL,
    style integer NOT NULL,
    water integer NOT NULL
);


ALTER TABLE style_water OWNER TO kczadzeck;

--
-- Name: style_water_id_seq; Type: SEQUENCE; Schema: recipe; Owner: kczadzeck
--

CREATE SEQUENCE style_water_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE style_water_id_seq OWNER TO kczadzeck;

--
-- Name: style_water_id_seq; Type: SEQUENCE OWNED BY; Schema: recipe; Owner: kczadzeck
--

ALTER SEQUENCE style_water_id_seq OWNED BY style_water.id;


--
-- Name: water_profile_id_seq; Type: SEQUENCE; Schema: recipe; Owner: kczadzeck
--

CREATE SEQUENCE water_profile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE water_profile_id_seq OWNER TO kczadzeck;

--
-- Name: water_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: recipe; Owner: kczadzeck
--

ALTER SEQUENCE water_profile_id_seq OWNED BY water_profile.id;


SET search_path = ingredient, pg_catalog;

--
-- Name: grain id; Type: DEFAULT; Schema: ingredient; Owner: kczadzeck
--

ALTER TABLE ONLY grain ALTER COLUMN id SET DEFAULT nextval('ingredient_ingredient_id_seq'::regclass);


--
-- Name: hop id; Type: DEFAULT; Schema: ingredient; Owner: kczadzeck
--

ALTER TABLE ONLY hop ALTER COLUMN id SET DEFAULT nextval('ingredient_ingredient_id_seq'::regclass);


--
-- Name: ingredient id; Type: DEFAULT; Schema: ingredient; Owner: kczadzeck
--

ALTER TABLE ONLY ingredient ALTER COLUMN id SET DEFAULT nextval('ingredient_ingredient_id_seq'::regclass);


--
-- Name: ingredient_category id; Type: DEFAULT; Schema: ingredient; Owner: kczadzeck
--

ALTER TABLE ONLY ingredient_category ALTER COLUMN id SET DEFAULT nextval('ingredient_category_id_seq'::regclass);


--
-- Name: ingredient_format id; Type: DEFAULT; Schema: ingredient; Owner: kczadzeck
--

ALTER TABLE ONLY ingredient_format ALTER COLUMN id SET DEFAULT nextval('ingredient_format_id_seq'::regclass);


--
-- Name: ingredient_type id; Type: DEFAULT; Schema: ingredient; Owner: kczadzeck
--

ALTER TABLE ONLY ingredient_type ALTER COLUMN id SET DEFAULT nextval('ingredient_type_id_seq'::regclass);


--
-- Name: yeast id; Type: DEFAULT; Schema: ingredient; Owner: kczadzeck
--

ALTER TABLE ONLY yeast ALTER COLUMN id SET DEFAULT nextval('ingredient_ingredient_id_seq'::regclass);


SET search_path = metadata, pg_catalog;

--
-- Name: brand id; Type: DEFAULT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY brand ALTER COLUMN id SET DEFAULT nextval('brands_brand_id_seq'::regclass);


--
-- Name: category id; Type: DEFAULT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY category ALTER COLUMN id SET DEFAULT nextval('category_id_seq'::regclass);


--
-- Name: category_brand id; Type: DEFAULT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY category_brand ALTER COLUMN id SET DEFAULT nextval('ingredient_brands_id_seq'::regclass);


--
-- Name: category_format id; Type: DEFAULT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY category_format ALTER COLUMN id SET DEFAULT nextval('category_format_id_seq'::regclass);


--
-- Name: format id; Type: DEFAULT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY format ALTER COLUMN id SET DEFAULT nextval('format_id_seq'::regclass);


--
-- Name: origin_continent id; Type: DEFAULT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY origin_continent ALTER COLUMN id SET DEFAULT nextval('origin_continent_origin_continent_id_seq'::regclass);


--
-- Name: origin_country id; Type: DEFAULT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY origin_country ALTER COLUMN id SET DEFAULT nextval('origin_country_origin_country_id_seq'::regclass);


--
-- Name: temperature_scale id; Type: DEFAULT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY temperature_scale ALTER COLUMN id SET DEFAULT nextval('temperature_scale_temperature_scale_id_seq'::regclass);


--
-- Name: type id; Type: DEFAULT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY type ALTER COLUMN id SET DEFAULT nextval('type_id_seq'::regclass);


--
-- Name: unit_of_measure id; Type: DEFAULT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY unit_of_measure ALTER COLUMN id SET DEFAULT nextval('unit_of_measure_unit_of_measure_id_seq'::regclass);


SET search_path = recipe, pg_catalog;

--
-- Name: addition id; Type: DEFAULT; Schema: recipe; Owner: kczadzeck
--

ALTER TABLE ONLY addition ALTER COLUMN id SET DEFAULT nextval('addition_id_seq'::regclass);


--
-- Name: recipe id; Type: DEFAULT; Schema: recipe; Owner: kczadzeck
--

ALTER TABLE ONLY recipe ALTER COLUMN id SET DEFAULT nextval('recipe_id_seq'::regclass);


--
-- Name: section id; Type: DEFAULT; Schema: recipe; Owner: kczadzeck
--

ALTER TABLE ONLY section ALTER COLUMN id SET DEFAULT nextval('section_id_seq'::regclass);


--
-- Name: style id; Type: DEFAULT; Schema: recipe; Owner: kczadzeck
--

ALTER TABLE ONLY style ALTER COLUMN id SET DEFAULT nextval('style_id_seq'::regclass);


--
-- Name: style_water id; Type: DEFAULT; Schema: recipe; Owner: kczadzeck
--

ALTER TABLE ONLY style_water ALTER COLUMN id SET DEFAULT nextval('style_water_id_seq'::regclass);


--
-- Name: water_profile id; Type: DEFAULT; Schema: recipe; Owner: kczadzeck
--

ALTER TABLE ONLY water_profile ALTER COLUMN id SET DEFAULT nextval('water_profile_id_seq'::regclass);


SET search_path = ingredient, pg_catalog;

--
-- Data for Name: grain; Type: TABLE DATA; Schema: ingredient; Owner: kczadzeck
--

COPY grain (id, category, type, name, origin, brand, lovibond, format) FROM stdin;
1	1	1	2-Row	1	2	1	5
\.


--
-- Data for Name: hop; Type: TABLE DATA; Schema: ingredient; Owner: kczadzeck
--

COPY hop (id, category, alpha_acid, type, name, origin, brand, format) FROM stdin;
\.


--
-- Data for Name: ingredient; Type: TABLE DATA; Schema: ingredient; Owner: kczadzeck
--

COPY ingredient (id, category, type, name, origin, brand, format) FROM stdin;
3	6	7	honey	1	3	1
\.


--
-- Data for Name: ingredient_category; Type: TABLE DATA; Schema: ingredient; Owner: kczadzeck
--

COPY ingredient_category (id, category) FROM stdin;
\.


--
-- Name: ingredient_category_id_seq; Type: SEQUENCE SET; Schema: ingredient; Owner: kczadzeck
--

SELECT pg_catalog.setval('ingredient_category_id_seq', 1, false);


--
-- Data for Name: ingredient_format; Type: TABLE DATA; Schema: ingredient; Owner: kczadzeck
--

COPY ingredient_format (id, format) FROM stdin;
\.


--
-- Name: ingredient_format_id_seq; Type: SEQUENCE SET; Schema: ingredient; Owner: kczadzeck
--

SELECT pg_catalog.setval('ingredient_format_id_seq', 1, false);


--
-- Name: ingredient_ingredient_id_seq; Type: SEQUENCE SET; Schema: ingredient; Owner: kczadzeck
--

SELECT pg_catalog.setval('ingredient_ingredient_id_seq', 3, true);


--
-- Data for Name: ingredient_type; Type: TABLE DATA; Schema: ingredient; Owner: kczadzeck
--

COPY ingredient_type (id, type) FROM stdin;
\.


--
-- Name: ingredient_type_id_seq; Type: SEQUENCE SET; Schema: ingredient; Owner: kczadzeck
--

SELECT pg_catalog.setval('ingredient_type_id_seq', 1, false);


--
-- Data for Name: yeast; Type: TABLE DATA; Schema: ingredient; Owner: kczadzeck
--

COPY yeast (id, category, type, name, origin, brand, strain_num, ferm_temp_low, ferm_temp_high, format, ferm_temp_scale) FROM stdin;
\.


SET search_path = metadata, pg_catalog;

--
-- Data for Name: brand; Type: TABLE DATA; Schema: metadata; Owner: kczadzeck
--

COPY brand (id, name, origin) FROM stdin;
1	White Labs	1
2	any	10
3	L.R. Rice	1
\.


--
-- Name: brands_brand_id_seq; Type: SEQUENCE SET; Schema: metadata; Owner: kczadzeck
--

SELECT pg_catalog.setval('brands_brand_id_seq', 3, true);


--
-- Data for Name: category; Type: TABLE DATA; Schema: metadata; Owner: kczadzeck
--

COPY category (id, name) FROM stdin;
1	grain
3	mineral
4	water
5	yeast
6	adjunct
2	hop
\.


--
-- Data for Name: category_brand; Type: TABLE DATA; Schema: metadata; Owner: kczadzeck
--

COPY category_brand (id, category, brand) FROM stdin;
1	5	1
2	6	2
3	1	2
4	2	2
5	3	2
6	4	2
7	5	2
8	6	3
\.


--
-- Data for Name: category_format; Type: TABLE DATA; Schema: metadata; Owner: kczadzeck
--

COPY category_format (id, category, format) FROM stdin;
1	5	1
2	6	1
3	5	2
4	2	3
5	2	4
6	1	5
7	1	6
8	1	7
\.


--
-- Name: category_format_id_seq; Type: SEQUENCE SET; Schema: metadata; Owner: kczadzeck
--

SELECT pg_catalog.setval('category_format_id_seq', 8, true);


--
-- Name: category_id_seq; Type: SEQUENCE SET; Schema: metadata; Owner: kczadzeck
--

SELECT pg_catalog.setval('category_id_seq', 12, true);


--
-- Data for Name: format; Type: TABLE DATA; Schema: metadata; Owner: kczadzeck
--

COPY format (id, name) FROM stdin;
3	pellet
4	leaf
5	malted
6	un-malted
7	flaked
1	liquid
2	dry
\.


--
-- Name: format_id_seq; Type: SEQUENCE SET; Schema: metadata; Owner: kczadzeck
--

SELECT pg_catalog.setval('format_id_seq', 7, true);


--
-- Name: ingredient_brands_id_seq; Type: SEQUENCE SET; Schema: metadata; Owner: kczadzeck
--

SELECT pg_catalog.setval('ingredient_brands_id_seq', 8, true);


--
-- Data for Name: origin_continent; Type: TABLE DATA; Schema: metadata; Owner: kczadzeck
--

COPY origin_continent (id, name, abbreviation) FROM stdin;
1	North America	NA
2	South America	SA
3	Europe	EU
4	Africa	AF
5	Asia	AS
6	Australia	AU
7	Antarctica	AN
8	unknown	??
\.


--
-- Name: origin_continent_origin_continent_id_seq; Type: SEQUENCE SET; Schema: metadata; Owner: kczadzeck
--

SELECT pg_catalog.setval('origin_continent_origin_continent_id_seq', 8, true);


--
-- Data for Name: origin_country; Type: TABLE DATA; Schema: metadata; Owner: kczadzeck
--

COPY origin_country (id, name, abbreviation, continent) FROM stdin;
1	United States	US	1
3	Canada	CA	1
4	Mexico	MX	1
5	United Kingdom	UK	3
6	France	FR	3
7	Belgium	BE	3
8	Germany	DE	3
9	Ireland	IE	3
10	unknown	??	8
\.


--
-- Name: origin_country_origin_country_id_seq; Type: SEQUENCE SET; Schema: metadata; Owner: kczadzeck
--

SELECT pg_catalog.setval('origin_country_origin_country_id_seq', 10, true);


--
-- Data for Name: temperature_scale; Type: TABLE DATA; Schema: metadata; Owner: kczadzeck
--

COPY temperature_scale (id, name, abbreviation) FROM stdin;
1	Fahrenheit	F
2	Celcius	C
\.


--
-- Name: temperature_scale_temperature_scale_id_seq; Type: SEQUENCE SET; Schema: metadata; Owner: kczadzeck
--

SELECT pg_catalog.setval('temperature_scale_temperature_scale_id_seq', 2, true);


--
-- Data for Name: type; Type: TABLE DATA; Schema: metadata; Owner: kczadzeck
--

COPY type (id, category, name) FROM stdin;
1	1	base
2	1	specialty
3	2	multi-purpose
4	2	bittering
5	2	flavor
6	2	aroma
7	6	fermentable
\.


--
-- Name: type_id_seq; Type: SEQUENCE SET; Schema: metadata; Owner: kczadzeck
--

SELECT pg_catalog.setval('type_id_seq', 7, true);


--
-- Data for Name: unit_of_measure; Type: TABLE DATA; Schema: metadata; Owner: kczadzeck
--

COPY unit_of_measure (id, name, abbreviation) FROM stdin;
1	milligrams	mg
2	grams	g
3	kilograms	kg
4	ounces	oz
5	pounds	lb
6	parts per million	ppm
7	gallons	gal
\.


--
-- Name: unit_of_measure_unit_of_measure_id_seq; Type: SEQUENCE SET; Schema: metadata; Owner: kczadzeck
--

SELECT pg_catalog.setval('unit_of_measure_unit_of_measure_id_seq', 7, true);


SET search_path = recipe, pg_catalog;

--
-- Data for Name: addition; Type: TABLE DATA; Schema: recipe; Owner: kczadzeck
--

COPY addition (id, section, ingredient, quantity, unit_of_measure, duration, unit_of_time, recipe, temperature, temperature_scale) FROM stdin;
\.


--
-- Name: addition_id_seq; Type: SEQUENCE SET; Schema: recipe; Owner: kczadzeck
--

SELECT pg_catalog.setval('addition_id_seq', 1, false);


--
-- Data for Name: recipe; Type: TABLE DATA; Schema: recipe; Owner: kczadzeck
--

COPY recipe (id, name, style, batch_size, unit_of_measure, description) FROM stdin;
1	Deep Valley IPL	1	3	7	Our flagship IPL. Based on a famous midwestern IPA, but lagered for clean flavors and easy-drinking.
\.


--
-- Name: recipe_id_seq; Type: SEQUENCE SET; Schema: recipe; Owner: kczadzeck
--

SELECT pg_catalog.setval('recipe_id_seq', 1, true);


--
-- Data for Name: section; Type: TABLE DATA; Schema: recipe; Owner: kczadzeck
--

COPY section (id, name) FROM stdin;
1	mash
2	boil
3	primary
4	secondary
\.


--
-- Name: section_id_seq; Type: SEQUENCE SET; Schema: recipe; Owner: kczadzeck
--

SELECT pg_catalog.setval('section_id_seq', 4, true);


--
-- Data for Name: style; Type: TABLE DATA; Schema: recipe; Owner: kczadzeck
--

COPY style (id, name, origin) FROM stdin;
1	India Pale Lager	1
\.


--
-- Name: style_id_seq; Type: SEQUENCE SET; Schema: recipe; Owner: kczadzeck
--

SELECT pg_catalog.setval('style_id_seq', 1, true);


--
-- Data for Name: style_water; Type: TABLE DATA; Schema: recipe; Owner: kczadzeck
--

COPY style_water (id, style, water) FROM stdin;
\.


--
-- Name: style_water_id_seq; Type: SEQUENCE SET; Schema: recipe; Owner: kczadzeck
--

SELECT pg_catalog.setval('style_water_id_seq', 1, false);


--
-- Data for Name: water_profile; Type: TABLE DATA; Schema: recipe; Owner: kczadzeck
--

COPY water_profile (id, calcium, magnesium, sodium, chloride, sulfate, unit_of_measure) FROM stdin;
\.


--
-- Name: water_profile_id_seq; Type: SEQUENCE SET; Schema: recipe; Owner: kczadzeck
--

SELECT pg_catalog.setval('water_profile_id_seq', 1, false);


SET search_path = ingredient, pg_catalog;

--
-- Name: grain grain_pkey; Type: CONSTRAINT; Schema: ingredient; Owner: kczadzeck
--

ALTER TABLE ONLY grain
    ADD CONSTRAINT grain_pkey PRIMARY KEY (id);


--
-- Name: hop hop_pkey; Type: CONSTRAINT; Schema: ingredient; Owner: kczadzeck
--

ALTER TABLE ONLY hop
    ADD CONSTRAINT hop_pkey PRIMARY KEY (id);


--
-- Name: ingredient_category ingredient_category_pkey; Type: CONSTRAINT; Schema: ingredient; Owner: kczadzeck
--

ALTER TABLE ONLY ingredient_category
    ADD CONSTRAINT ingredient_category_pkey PRIMARY KEY (id);


--
-- Name: ingredient_format ingredient_format_pkey; Type: CONSTRAINT; Schema: ingredient; Owner: kczadzeck
--

ALTER TABLE ONLY ingredient_format
    ADD CONSTRAINT ingredient_format_pkey PRIMARY KEY (id);


--
-- Name: ingredient ingredient_pkey; Type: CONSTRAINT; Schema: ingredient; Owner: kczadzeck
--

ALTER TABLE ONLY ingredient
    ADD CONSTRAINT ingredient_pkey PRIMARY KEY (id);


--
-- Name: ingredient_type ingredient_type_pkey; Type: CONSTRAINT; Schema: ingredient; Owner: kczadzeck
--

ALTER TABLE ONLY ingredient_type
    ADD CONSTRAINT ingredient_type_pkey PRIMARY KEY (id);


--
-- Name: yeast yeast_pkey; Type: CONSTRAINT; Schema: ingredient; Owner: kczadzeck
--

ALTER TABLE ONLY yeast
    ADD CONSTRAINT yeast_pkey PRIMARY KEY (id);


SET search_path = metadata, pg_catalog;

--
-- Name: brand brands_pkey; Type: CONSTRAINT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY brand
    ADD CONSTRAINT brands_pkey PRIMARY KEY (id);


--
-- Name: category_format category_format_pkey; Type: CONSTRAINT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY category_format
    ADD CONSTRAINT category_format_pkey PRIMARY KEY (id);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- Name: format format_pkey; Type: CONSTRAINT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY format
    ADD CONSTRAINT format_pkey PRIMARY KEY (id);


--
-- Name: category_brand ingredient_brands_pkey; Type: CONSTRAINT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY category_brand
    ADD CONSTRAINT ingredient_brands_pkey PRIMARY KEY (id);


--
-- Name: origin_continent origin_continent_pkey; Type: CONSTRAINT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY origin_continent
    ADD CONSTRAINT origin_continent_pkey PRIMARY KEY (id);


--
-- Name: origin_country origin_country_pkey; Type: CONSTRAINT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY origin_country
    ADD CONSTRAINT origin_country_pkey PRIMARY KEY (id);


--
-- Name: temperature_scale temperature_scale_pkey; Type: CONSTRAINT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY temperature_scale
    ADD CONSTRAINT temperature_scale_pkey PRIMARY KEY (id);


--
-- Name: type type_pkey; Type: CONSTRAINT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY type
    ADD CONSTRAINT type_pkey PRIMARY KEY (id);


--
-- Name: unit_of_measure unit_of_measure_pkey; Type: CONSTRAINT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY unit_of_measure
    ADD CONSTRAINT unit_of_measure_pkey PRIMARY KEY (id);


SET search_path = recipe, pg_catalog;

--
-- Name: addition addition_pkey; Type: CONSTRAINT; Schema: recipe; Owner: kczadzeck
--

ALTER TABLE ONLY addition
    ADD CONSTRAINT addition_pkey PRIMARY KEY (id);


--
-- Name: recipe recipe_pkey; Type: CONSTRAINT; Schema: recipe; Owner: kczadzeck
--

ALTER TABLE ONLY recipe
    ADD CONSTRAINT recipe_pkey PRIMARY KEY (id);


--
-- Name: section section_pkey; Type: CONSTRAINT; Schema: recipe; Owner: kczadzeck
--

ALTER TABLE ONLY section
    ADD CONSTRAINT section_pkey PRIMARY KEY (id);


--
-- Name: style style_pkey; Type: CONSTRAINT; Schema: recipe; Owner: kczadzeck
--

ALTER TABLE ONLY style
    ADD CONSTRAINT style_pkey PRIMARY KEY (id);


--
-- Name: water_profile water_profile_pkey; Type: CONSTRAINT; Schema: recipe; Owner: kczadzeck
--

ALTER TABLE ONLY water_profile
    ADD CONSTRAINT water_profile_pkey PRIMARY KEY (id);


SET search_path = ingredient, pg_catalog;

--
-- Name: ingredient brand_fkey; Type: FK CONSTRAINT; Schema: ingredient; Owner: kczadzeck
--

ALTER TABLE ONLY ingredient
    ADD CONSTRAINT brand_fkey FOREIGN KEY (brand) REFERENCES metadata.brand(id);


--
-- Name: ingredient category_fkey; Type: FK CONSTRAINT; Schema: ingredient; Owner: kczadzeck
--

ALTER TABLE ONLY ingredient
    ADD CONSTRAINT category_fkey FOREIGN KEY (category) REFERENCES metadata.category(id);


--
-- Name: ingredient_category category_fkey; Type: FK CONSTRAINT; Schema: ingredient; Owner: kczadzeck
--

ALTER TABLE ONLY ingredient_category
    ADD CONSTRAINT category_fkey FOREIGN KEY (category) REFERENCES metadata.category(id);


--
-- Name: yeast ferm_temp_scale_fkey; Type: FK CONSTRAINT; Schema: ingredient; Owner: kczadzeck
--

ALTER TABLE ONLY yeast
    ADD CONSTRAINT ferm_temp_scale_fkey FOREIGN KEY (ferm_temp_scale) REFERENCES metadata.temperature_scale(id);


--
-- Name: ingredient format_fkey; Type: FK CONSTRAINT; Schema: ingredient; Owner: kczadzeck
--

ALTER TABLE ONLY ingredient
    ADD CONSTRAINT format_fkey FOREIGN KEY (format) REFERENCES metadata.format(id);


--
-- Name: ingredient_format format_fkey; Type: FK CONSTRAINT; Schema: ingredient; Owner: kczadzeck
--

ALTER TABLE ONLY ingredient_format
    ADD CONSTRAINT format_fkey FOREIGN KEY (format) REFERENCES metadata.format(id);


--
-- Name: ingredient origin_fkey; Type: FK CONSTRAINT; Schema: ingredient; Owner: kczadzeck
--

ALTER TABLE ONLY ingredient
    ADD CONSTRAINT origin_fkey FOREIGN KEY (origin) REFERENCES metadata.origin_country(id);


--
-- Name: ingredient type_fkey; Type: FK CONSTRAINT; Schema: ingredient; Owner: kczadzeck
--

ALTER TABLE ONLY ingredient
    ADD CONSTRAINT type_fkey FOREIGN KEY (type) REFERENCES metadata.type(id);


--
-- Name: ingredient_type type_fkey; Type: FK CONSTRAINT; Schema: ingredient; Owner: kczadzeck
--

ALTER TABLE ONLY ingredient_type
    ADD CONSTRAINT type_fkey FOREIGN KEY (type) REFERENCES metadata.type(id);


SET search_path = metadata, pg_catalog;

--
-- Name: category_brand brand_fkey; Type: FK CONSTRAINT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY category_brand
    ADD CONSTRAINT brand_fkey FOREIGN KEY (brand) REFERENCES brand(id);


--
-- Name: category_brand category_fkey; Type: FK CONSTRAINT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY category_brand
    ADD CONSTRAINT category_fkey FOREIGN KEY (category) REFERENCES category(id);


--
-- Name: category_format category_fkey; Type: FK CONSTRAINT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY category_format
    ADD CONSTRAINT category_fkey FOREIGN KEY (category) REFERENCES category(id);


--
-- Name: category_format format_fkey; Type: FK CONSTRAINT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY category_format
    ADD CONSTRAINT format_fkey FOREIGN KEY (format) REFERENCES format(id);


--
-- Name: origin_country origin_continent_fkey; Type: FK CONSTRAINT; Schema: metadata; Owner: kczadzeck
--

ALTER TABLE ONLY origin_country
    ADD CONSTRAINT origin_continent_fkey FOREIGN KEY (continent) REFERENCES origin_continent(id);


SET search_path = recipe, pg_catalog;

--
-- Name: addition ingredient_fkey; Type: FK CONSTRAINT; Schema: recipe; Owner: kczadzeck
--

ALTER TABLE ONLY addition
    ADD CONSTRAINT ingredient_fkey FOREIGN KEY (ingredient) REFERENCES ingredient.ingredient(id);


--
-- Name: style origin_fkey; Type: FK CONSTRAINT; Schema: recipe; Owner: kczadzeck
--

ALTER TABLE ONLY style
    ADD CONSTRAINT origin_fkey FOREIGN KEY (origin) REFERENCES metadata.origin_country(id);


--
-- Name: addition recipe_fkey; Type: FK CONSTRAINT; Schema: recipe; Owner: kczadzeck
--

ALTER TABLE ONLY addition
    ADD CONSTRAINT recipe_fkey FOREIGN KEY (recipe) REFERENCES recipe(id);


--
-- Name: addition section_fkey; Type: FK CONSTRAINT; Schema: recipe; Owner: kczadzeck
--

ALTER TABLE ONLY addition
    ADD CONSTRAINT section_fkey FOREIGN KEY (section) REFERENCES section(id);


--
-- Name: style_water style_fkey; Type: FK CONSTRAINT; Schema: recipe; Owner: kczadzeck
--

ALTER TABLE ONLY style_water
    ADD CONSTRAINT style_fkey FOREIGN KEY (style) REFERENCES style(id);


--
-- Name: addition temperature_scale_fkey; Type: FK CONSTRAINT; Schema: recipe; Owner: kczadzeck
--

ALTER TABLE ONLY addition
    ADD CONSTRAINT temperature_scale_fkey FOREIGN KEY (temperature_scale) REFERENCES metadata.temperature_scale(id);


--
-- Name: addition unit_of_measure_fkey; Type: FK CONSTRAINT; Schema: recipe; Owner: kczadzeck
--

ALTER TABLE ONLY addition
    ADD CONSTRAINT unit_of_measure_fkey FOREIGN KEY (unit_of_measure) REFERENCES metadata.unit_of_measure(id);


--
-- Name: addition unit_of_time_fkey; Type: FK CONSTRAINT; Schema: recipe; Owner: kczadzeck
--

ALTER TABLE ONLY addition
    ADD CONSTRAINT unit_of_time_fkey FOREIGN KEY (unit_of_time) REFERENCES metadata.unit_of_measure(id);


--
-- Name: style_water water_fkey; Type: FK CONSTRAINT; Schema: recipe; Owner: kczadzeck
--

ALTER TABLE ONLY style_water
    ADD CONSTRAINT water_fkey FOREIGN KEY (water) REFERENCES water_profile(id);


--
-- PostgreSQL database dump complete
--

