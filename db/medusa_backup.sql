--
-- PostgreSQL database dump
--

\restrict PYvgSjTqfHOV1iVZ9vyTURM6jDT0wduDpveKp5fwm0rLy7KCg6Mox4nzRSrLvPs

-- Dumped from database version 14.19 (Homebrew)
-- Dumped by pg_dump version 14.19 (Homebrew)

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
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: claim_reason_enum; Type: TYPE; Schema: public; Owner: medusa_admin
--

CREATE TYPE public.claim_reason_enum AS ENUM (
    'missing_item',
    'wrong_item',
    'production_failure',
    'other'
);


ALTER TYPE public.claim_reason_enum OWNER TO medusa_admin;

--
-- Name: order_claim_type_enum; Type: TYPE; Schema: public; Owner: medusa_admin
--

CREATE TYPE public.order_claim_type_enum AS ENUM (
    'refund',
    'replace'
);


ALTER TYPE public.order_claim_type_enum OWNER TO medusa_admin;

--
-- Name: order_status_enum; Type: TYPE; Schema: public; Owner: medusa_admin
--

CREATE TYPE public.order_status_enum AS ENUM (
    'pending',
    'completed',
    'draft',
    'archived',
    'canceled',
    'requires_action'
);


ALTER TYPE public.order_status_enum OWNER TO medusa_admin;

--
-- Name: return_status_enum; Type: TYPE; Schema: public; Owner: medusa_admin
--

CREATE TYPE public.return_status_enum AS ENUM (
    'open',
    'requested',
    'received',
    'partially_received',
    'canceled'
);


ALTER TYPE public.return_status_enum OWNER TO medusa_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account_holder; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.account_holder (
    id text NOT NULL,
    provider_id text NOT NULL,
    external_id text NOT NULL,
    email text,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.account_holder OWNER TO medusa_admin;

--
-- Name: api_key; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.api_key (
    id text NOT NULL,
    token text NOT NULL,
    salt text NOT NULL,
    redacted text NOT NULL,
    title text NOT NULL,
    type text NOT NULL,
    last_used_at timestamp with time zone,
    created_by text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_by text,
    revoked_at timestamp with time zone,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT api_key_type_check CHECK ((type = ANY (ARRAY['publishable'::text, 'secret'::text])))
);


ALTER TABLE public.api_key OWNER TO medusa_admin;

--
-- Name: application_method_buy_rules; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.application_method_buy_rules (
    application_method_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.application_method_buy_rules OWNER TO medusa_admin;

--
-- Name: application_method_target_rules; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.application_method_target_rules (
    application_method_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.application_method_target_rules OWNER TO medusa_admin;

--
-- Name: auth_identity; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.auth_identity (
    id text NOT NULL,
    app_metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.auth_identity OWNER TO medusa_admin;

--
-- Name: capture; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.capture (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    payment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text,
    metadata jsonb
);


ALTER TABLE public.capture OWNER TO medusa_admin;

--
-- Name: cart; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.cart (
    id text NOT NULL,
    region_id text,
    customer_id text,
    sales_channel_id text,
    email text,
    currency_code text NOT NULL,
    shipping_address_id text,
    billing_address_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    completed_at timestamp with time zone
);


ALTER TABLE public.cart OWNER TO medusa_admin;

--
-- Name: cart_address; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.cart_address (
    id text NOT NULL,
    customer_id text,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_address OWNER TO medusa_admin;

--
-- Name: cart_line_item; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.cart_line_item (
    id text NOT NULL,
    cart_id text NOT NULL,
    title text NOT NULL,
    subtitle text,
    thumbnail text,
    quantity integer NOT NULL,
    variant_id text,
    product_id text,
    product_title text,
    product_description text,
    product_subtitle text,
    product_type text,
    product_collection text,
    product_handle text,
    variant_sku text,
    variant_barcode text,
    variant_title text,
    variant_option_values jsonb,
    requires_shipping boolean DEFAULT true NOT NULL,
    is_discountable boolean DEFAULT true NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb,
    unit_price numeric NOT NULL,
    raw_unit_price jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    product_type_id text,
    is_custom_price boolean DEFAULT false NOT NULL,
    is_giftcard boolean DEFAULT false NOT NULL,
    CONSTRAINT cart_line_item_unit_price_check CHECK ((unit_price >= (0)::numeric))
);


ALTER TABLE public.cart_line_item OWNER TO medusa_admin;

--
-- Name: cart_line_item_adjustment; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.cart_line_item_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    item_id text,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    CONSTRAINT cart_line_item_adjustment_check CHECK ((amount >= (0)::numeric))
);


ALTER TABLE public.cart_line_item_adjustment OWNER TO medusa_admin;

--
-- Name: cart_line_item_tax_line; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.cart_line_item_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate real NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    item_id text
);


ALTER TABLE public.cart_line_item_tax_line OWNER TO medusa_admin;

--
-- Name: cart_payment_collection; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.cart_payment_collection (
    cart_id character varying(255) NOT NULL,
    payment_collection_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_payment_collection OWNER TO medusa_admin;

--
-- Name: cart_promotion; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.cart_promotion (
    cart_id character varying(255) NOT NULL,
    promotion_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_promotion OWNER TO medusa_admin;

--
-- Name: cart_shipping_method; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.cart_shipping_method (
    id text NOT NULL,
    cart_id text NOT NULL,
    name text NOT NULL,
    description jsonb,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    shipping_option_id text,
    data jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT cart_shipping_method_check CHECK ((amount >= (0)::numeric))
);


ALTER TABLE public.cart_shipping_method OWNER TO medusa_admin;

--
-- Name: cart_shipping_method_adjustment; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.cart_shipping_method_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    shipping_method_id text
);


ALTER TABLE public.cart_shipping_method_adjustment OWNER TO medusa_admin;

--
-- Name: cart_shipping_method_tax_line; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.cart_shipping_method_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate real NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    shipping_method_id text
);


ALTER TABLE public.cart_shipping_method_tax_line OWNER TO medusa_admin;

--
-- Name: credit_line; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.credit_line (
    id text NOT NULL,
    cart_id text NOT NULL,
    reference text,
    reference_id text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.credit_line OWNER TO medusa_admin;

--
-- Name: currency; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.currency (
    code text NOT NULL,
    symbol text NOT NULL,
    symbol_native text NOT NULL,
    decimal_digits integer DEFAULT 0 NOT NULL,
    rounding numeric DEFAULT 0 NOT NULL,
    raw_rounding jsonb NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.currency OWNER TO medusa_admin;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.customer (
    id text NOT NULL,
    company_name text,
    first_name text,
    last_name text,
    email text,
    phone text,
    has_account boolean DEFAULT false NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.customer OWNER TO medusa_admin;

--
-- Name: customer_account_holder; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.customer_account_holder (
    customer_id character varying(255) NOT NULL,
    account_holder_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_account_holder OWNER TO medusa_admin;

--
-- Name: customer_address; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.customer_address (
    id text NOT NULL,
    customer_id text NOT NULL,
    address_name text,
    is_default_shipping boolean DEFAULT false NOT NULL,
    is_default_billing boolean DEFAULT false NOT NULL,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_address OWNER TO medusa_admin;

--
-- Name: customer_group; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.customer_group (
    id text NOT NULL,
    name text NOT NULL,
    metadata jsonb,
    created_by text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_group OWNER TO medusa_admin;

--
-- Name: customer_group_customer; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.customer_group_customer (
    id text NOT NULL,
    customer_id text NOT NULL,
    customer_group_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_group_customer OWNER TO medusa_admin;

--
-- Name: fulfillment; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.fulfillment (
    id text NOT NULL,
    location_id text NOT NULL,
    packed_at timestamp with time zone,
    shipped_at timestamp with time zone,
    delivered_at timestamp with time zone,
    canceled_at timestamp with time zone,
    data jsonb,
    provider_id text,
    shipping_option_id text,
    metadata jsonb,
    delivery_address_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    marked_shipped_by text,
    created_by text,
    requires_shipping boolean DEFAULT true NOT NULL
);


ALTER TABLE public.fulfillment OWNER TO medusa_admin;

--
-- Name: fulfillment_address; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.fulfillment_address (
    id text NOT NULL,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_address OWNER TO medusa_admin;

--
-- Name: fulfillment_item; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.fulfillment_item (
    id text NOT NULL,
    title text NOT NULL,
    sku text NOT NULL,
    barcode text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    line_item_id text,
    inventory_item_id text,
    fulfillment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_item OWNER TO medusa_admin;

--
-- Name: fulfillment_label; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.fulfillment_label (
    id text NOT NULL,
    tracking_number text NOT NULL,
    tracking_url text NOT NULL,
    label_url text NOT NULL,
    fulfillment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_label OWNER TO medusa_admin;

--
-- Name: fulfillment_provider; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.fulfillment_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_provider OWNER TO medusa_admin;

--
-- Name: fulfillment_set; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.fulfillment_set (
    id text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_set OWNER TO medusa_admin;

--
-- Name: geo_zone; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.geo_zone (
    id text NOT NULL,
    type text DEFAULT 'country'::text NOT NULL,
    country_code text NOT NULL,
    province_code text,
    city text,
    service_zone_id text NOT NULL,
    postal_expression jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT geo_zone_type_check CHECK ((type = ANY (ARRAY['country'::text, 'province'::text, 'city'::text, 'zip'::text])))
);


ALTER TABLE public.geo_zone OWNER TO medusa_admin;

--
-- Name: image; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.image (
    id text NOT NULL,
    url text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    rank integer DEFAULT 0 NOT NULL,
    product_id text NOT NULL
);


ALTER TABLE public.image OWNER TO medusa_admin;

--
-- Name: inventory_item; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.inventory_item (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    sku text,
    origin_country text,
    hs_code text,
    mid_code text,
    material text,
    weight integer,
    length integer,
    height integer,
    width integer,
    requires_shipping boolean DEFAULT true NOT NULL,
    description text,
    title text,
    thumbnail text,
    metadata jsonb
);


ALTER TABLE public.inventory_item OWNER TO medusa_admin;

--
-- Name: inventory_level; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.inventory_level (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    inventory_item_id text NOT NULL,
    location_id text NOT NULL,
    stocked_quantity numeric DEFAULT 0 NOT NULL,
    reserved_quantity numeric DEFAULT 0 NOT NULL,
    incoming_quantity numeric DEFAULT 0 NOT NULL,
    metadata jsonb,
    raw_stocked_quantity jsonb,
    raw_reserved_quantity jsonb,
    raw_incoming_quantity jsonb
);


ALTER TABLE public.inventory_level OWNER TO medusa_admin;

--
-- Name: invite; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.invite (
    id text NOT NULL,
    email text NOT NULL,
    accepted boolean DEFAULT false NOT NULL,
    token text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.invite OWNER TO medusa_admin;

--
-- Name: link_module_migrations; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.link_module_migrations (
    id integer NOT NULL,
    table_name character varying(255) NOT NULL,
    link_descriptor jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.link_module_migrations OWNER TO medusa_admin;

--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: medusa_admin
--

CREATE SEQUENCE public.link_module_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.link_module_migrations_id_seq OWNER TO medusa_admin;

--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: medusa_admin
--

ALTER SEQUENCE public.link_module_migrations_id_seq OWNED BY public.link_module_migrations.id;


--
-- Name: location_fulfillment_provider; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.location_fulfillment_provider (
    stock_location_id character varying(255) NOT NULL,
    fulfillment_provider_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.location_fulfillment_provider OWNER TO medusa_admin;

--
-- Name: location_fulfillment_set; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.location_fulfillment_set (
    stock_location_id character varying(255) NOT NULL,
    fulfillment_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.location_fulfillment_set OWNER TO medusa_admin;

--
-- Name: mikro_orm_migrations; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.mikro_orm_migrations (
    id integer NOT NULL,
    name character varying(255),
    executed_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.mikro_orm_migrations OWNER TO medusa_admin;

--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: medusa_admin
--

CREATE SEQUENCE public.mikro_orm_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mikro_orm_migrations_id_seq OWNER TO medusa_admin;

--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: medusa_admin
--

ALTER SEQUENCE public.mikro_orm_migrations_id_seq OWNED BY public.mikro_orm_migrations.id;


--
-- Name: notification; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.notification (
    id text NOT NULL,
    "to" text NOT NULL,
    channel text NOT NULL,
    template text NOT NULL,
    data jsonb,
    trigger_type text,
    resource_id text,
    resource_type text,
    receiver_id text,
    original_notification_id text,
    idempotency_key text,
    external_id text,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    status text DEFAULT 'pending'::text NOT NULL,
    CONSTRAINT notification_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'success'::text, 'failure'::text])))
);


ALTER TABLE public.notification OWNER TO medusa_admin;

--
-- Name: notification_provider; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.notification_provider (
    id text NOT NULL,
    handle text NOT NULL,
    name text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    channels text[] DEFAULT '{}'::text[] NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.notification_provider OWNER TO medusa_admin;

--
-- Name: order; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public."order" (
    id text NOT NULL,
    region_id text,
    display_id integer,
    customer_id text,
    version integer DEFAULT 1 NOT NULL,
    sales_channel_id text,
    status public.order_status_enum DEFAULT 'pending'::public.order_status_enum NOT NULL,
    is_draft_order boolean DEFAULT false NOT NULL,
    email text,
    currency_code text NOT NULL,
    shipping_address_id text,
    billing_address_id text,
    no_notification boolean,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone
);


ALTER TABLE public."order" OWNER TO medusa_admin;

--
-- Name: order_address; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.order_address (
    id text NOT NULL,
    customer_id text,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_address OWNER TO medusa_admin;

--
-- Name: order_cart; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.order_cart (
    order_id character varying(255) NOT NULL,
    cart_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_cart OWNER TO medusa_admin;

--
-- Name: order_change; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.order_change (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    description text,
    status text DEFAULT 'pending'::text NOT NULL,
    internal_note text,
    created_by text,
    requested_by text,
    requested_at timestamp with time zone,
    confirmed_by text,
    confirmed_at timestamp with time zone,
    declined_by text,
    declined_reason text,
    metadata jsonb,
    declined_at timestamp with time zone,
    canceled_by text,
    canceled_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    change_type text,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text,
    CONSTRAINT order_change_status_check CHECK ((status = ANY (ARRAY['confirmed'::text, 'declined'::text, 'requested'::text, 'pending'::text, 'canceled'::text])))
);


ALTER TABLE public.order_change OWNER TO medusa_admin;

--
-- Name: order_change_action; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.order_change_action (
    id text NOT NULL,
    order_id text,
    version integer,
    ordering bigint NOT NULL,
    order_change_id text,
    reference text,
    reference_id text,
    action text NOT NULL,
    details jsonb,
    amount numeric,
    raw_amount jsonb,
    internal_note text,
    applied boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_change_action OWNER TO medusa_admin;

--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE; Schema: public; Owner: medusa_admin
--

CREATE SEQUENCE public.order_change_action_ordering_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_change_action_ordering_seq OWNER TO medusa_admin;

--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: medusa_admin
--

ALTER SEQUENCE public.order_change_action_ordering_seq OWNED BY public.order_change_action.ordering;


--
-- Name: order_claim; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.order_claim (
    id text NOT NULL,
    order_id text NOT NULL,
    return_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    type public.order_claim_type_enum NOT NULL,
    no_notification boolean,
    refund_amount numeric,
    raw_refund_amount jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.order_claim OWNER TO medusa_admin;

--
-- Name: order_claim_display_id_seq; Type: SEQUENCE; Schema: public; Owner: medusa_admin
--

CREATE SEQUENCE public.order_claim_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_claim_display_id_seq OWNER TO medusa_admin;

--
-- Name: order_claim_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: medusa_admin
--

ALTER SEQUENCE public.order_claim_display_id_seq OWNED BY public.order_claim.display_id;


--
-- Name: order_claim_item; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.order_claim_item (
    id text NOT NULL,
    claim_id text NOT NULL,
    item_id text NOT NULL,
    is_additional_item boolean DEFAULT false NOT NULL,
    reason public.claim_reason_enum,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_claim_item OWNER TO medusa_admin;

--
-- Name: order_claim_item_image; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.order_claim_item_image (
    id text NOT NULL,
    claim_item_id text NOT NULL,
    url text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_claim_item_image OWNER TO medusa_admin;

--
-- Name: order_credit_line; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.order_credit_line (
    id text NOT NULL,
    order_id text NOT NULL,
    reference text,
    reference_id text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_credit_line OWNER TO medusa_admin;

--
-- Name: order_display_id_seq; Type: SEQUENCE; Schema: public; Owner: medusa_admin
--

CREATE SEQUENCE public.order_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_display_id_seq OWNER TO medusa_admin;

--
-- Name: order_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: medusa_admin
--

ALTER SEQUENCE public.order_display_id_seq OWNED BY public."order".display_id;


--
-- Name: order_exchange; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.order_exchange (
    id text NOT NULL,
    order_id text NOT NULL,
    return_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    no_notification boolean,
    allow_backorder boolean DEFAULT false NOT NULL,
    difference_due numeric,
    raw_difference_due jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.order_exchange OWNER TO medusa_admin;

--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE; Schema: public; Owner: medusa_admin
--

CREATE SEQUENCE public.order_exchange_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_exchange_display_id_seq OWNER TO medusa_admin;

--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: medusa_admin
--

ALTER SEQUENCE public.order_exchange_display_id_seq OWNED BY public.order_exchange.display_id;


--
-- Name: order_exchange_item; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.order_exchange_item (
    id text NOT NULL,
    exchange_id text NOT NULL,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_exchange_item OWNER TO medusa_admin;

--
-- Name: order_fulfillment; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.order_fulfillment (
    order_id character varying(255) NOT NULL,
    fulfillment_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_fulfillment OWNER TO medusa_admin;

--
-- Name: order_item; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.order_item (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    fulfilled_quantity numeric NOT NULL,
    raw_fulfilled_quantity jsonb NOT NULL,
    shipped_quantity numeric NOT NULL,
    raw_shipped_quantity jsonb NOT NULL,
    return_requested_quantity numeric NOT NULL,
    raw_return_requested_quantity jsonb NOT NULL,
    return_received_quantity numeric NOT NULL,
    raw_return_received_quantity jsonb NOT NULL,
    return_dismissed_quantity numeric NOT NULL,
    raw_return_dismissed_quantity jsonb NOT NULL,
    written_off_quantity numeric NOT NULL,
    raw_written_off_quantity jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    delivered_quantity numeric DEFAULT 0 NOT NULL,
    raw_delivered_quantity jsonb NOT NULL,
    unit_price numeric,
    raw_unit_price jsonb,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb
);


ALTER TABLE public.order_item OWNER TO medusa_admin;

--
-- Name: order_line_item; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.order_line_item (
    id text NOT NULL,
    totals_id text,
    title text NOT NULL,
    subtitle text,
    thumbnail text,
    variant_id text,
    product_id text,
    product_title text,
    product_description text,
    product_subtitle text,
    product_type text,
    product_collection text,
    product_handle text,
    variant_sku text,
    variant_barcode text,
    variant_title text,
    variant_option_values jsonb,
    requires_shipping boolean DEFAULT true NOT NULL,
    is_discountable boolean DEFAULT true NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb,
    unit_price numeric NOT NULL,
    raw_unit_price jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    is_custom_price boolean DEFAULT false NOT NULL,
    product_type_id text,
    is_giftcard boolean DEFAULT false NOT NULL
);


ALTER TABLE public.order_line_item OWNER TO medusa_admin;

--
-- Name: order_line_item_adjustment; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.order_line_item_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    item_id text NOT NULL,
    deleted_at timestamp with time zone,
    is_tax_inclusive boolean DEFAULT false NOT NULL
);


ALTER TABLE public.order_line_item_adjustment OWNER TO medusa_admin;

--
-- Name: order_line_item_tax_line; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.order_line_item_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    raw_rate jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    item_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_line_item_tax_line OWNER TO medusa_admin;

--
-- Name: order_payment_collection; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.order_payment_collection (
    order_id character varying(255) NOT NULL,
    payment_collection_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_payment_collection OWNER TO medusa_admin;

--
-- Name: order_promotion; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.order_promotion (
    order_id character varying(255) NOT NULL,
    promotion_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_promotion OWNER TO medusa_admin;

--
-- Name: order_shipping; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.order_shipping (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    shipping_method_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_shipping OWNER TO medusa_admin;

--
-- Name: order_shipping_method; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.order_shipping_method (
    id text NOT NULL,
    name text NOT NULL,
    description jsonb,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    shipping_option_id text,
    data jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    is_custom_amount boolean DEFAULT false NOT NULL
);


ALTER TABLE public.order_shipping_method OWNER TO medusa_admin;

--
-- Name: order_shipping_method_adjustment; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.order_shipping_method_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    shipping_method_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_shipping_method_adjustment OWNER TO medusa_admin;

--
-- Name: order_shipping_method_tax_line; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.order_shipping_method_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    raw_rate jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    shipping_method_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_shipping_method_tax_line OWNER TO medusa_admin;

--
-- Name: order_summary; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.order_summary (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    totals jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_summary OWNER TO medusa_admin;

--
-- Name: order_transaction; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.order_transaction (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    currency_code text NOT NULL,
    reference text,
    reference_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_transaction OWNER TO medusa_admin;

--
-- Name: payment; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.payment (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    currency_code text NOT NULL,
    provider_id text NOT NULL,
    data jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    captured_at timestamp with time zone,
    canceled_at timestamp with time zone,
    payment_collection_id text NOT NULL,
    payment_session_id text NOT NULL,
    metadata jsonb
);


ALTER TABLE public.payment OWNER TO medusa_admin;

--
-- Name: payment_collection; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.payment_collection (
    id text NOT NULL,
    currency_code text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    authorized_amount numeric,
    raw_authorized_amount jsonb,
    captured_amount numeric,
    raw_captured_amount jsonb,
    refunded_amount numeric,
    raw_refunded_amount jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    completed_at timestamp with time zone,
    status text DEFAULT 'not_paid'::text NOT NULL,
    metadata jsonb,
    CONSTRAINT payment_collection_status_check CHECK ((status = ANY (ARRAY['not_paid'::text, 'awaiting'::text, 'authorized'::text, 'partially_authorized'::text, 'canceled'::text, 'failed'::text, 'partially_captured'::text, 'completed'::text])))
);


ALTER TABLE public.payment_collection OWNER TO medusa_admin;

--
-- Name: payment_collection_payment_providers; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.payment_collection_payment_providers (
    payment_collection_id text NOT NULL,
    payment_provider_id text NOT NULL
);


ALTER TABLE public.payment_collection_payment_providers OWNER TO medusa_admin;

--
-- Name: payment_provider; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.payment_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.payment_provider OWNER TO medusa_admin;

--
-- Name: payment_session; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.payment_session (
    id text NOT NULL,
    currency_code text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    context jsonb,
    status text DEFAULT 'pending'::text NOT NULL,
    authorized_at timestamp with time zone,
    payment_collection_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT payment_session_status_check CHECK ((status = ANY (ARRAY['authorized'::text, 'captured'::text, 'pending'::text, 'requires_more'::text, 'error'::text, 'canceled'::text])))
);


ALTER TABLE public.payment_session OWNER TO medusa_admin;

--
-- Name: price; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.price (
    id text NOT NULL,
    title text,
    price_set_id text NOT NULL,
    currency_code text NOT NULL,
    raw_amount jsonb NOT NULL,
    rules_count integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    price_list_id text,
    amount numeric NOT NULL,
    min_quantity integer,
    max_quantity integer
);


ALTER TABLE public.price OWNER TO medusa_admin;

--
-- Name: price_list; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.price_list (
    id text NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    rules_count integer DEFAULT 0,
    title text NOT NULL,
    description text NOT NULL,
    type text DEFAULT 'sale'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT price_list_status_check CHECK ((status = ANY (ARRAY['active'::text, 'draft'::text]))),
    CONSTRAINT price_list_type_check CHECK ((type = ANY (ARRAY['sale'::text, 'override'::text])))
);


ALTER TABLE public.price_list OWNER TO medusa_admin;

--
-- Name: price_list_rule; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.price_list_rule (
    id text NOT NULL,
    price_list_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    value jsonb,
    attribute text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.price_list_rule OWNER TO medusa_admin;

--
-- Name: price_preference; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.price_preference (
    id text NOT NULL,
    attribute text NOT NULL,
    value text,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.price_preference OWNER TO medusa_admin;

--
-- Name: price_rule; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.price_rule (
    id text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    price_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    attribute text DEFAULT ''::text NOT NULL,
    operator text DEFAULT 'eq'::text NOT NULL,
    CONSTRAINT price_rule_operator_check CHECK ((operator = ANY (ARRAY['gte'::text, 'lte'::text, 'gt'::text, 'lt'::text, 'eq'::text])))
);


ALTER TABLE public.price_rule OWNER TO medusa_admin;

--
-- Name: price_set; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.price_set (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.price_set OWNER TO medusa_admin;

--
-- Name: product; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.product (
    id text NOT NULL,
    title text NOT NULL,
    handle text NOT NULL,
    subtitle text,
    description text,
    is_giftcard boolean DEFAULT false NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    thumbnail text,
    weight text,
    length text,
    height text,
    width text,
    origin_country text,
    hs_code text,
    mid_code text,
    material text,
    collection_id text,
    type_id text,
    discountable boolean DEFAULT true NOT NULL,
    external_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb,
    CONSTRAINT product_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'proposed'::text, 'published'::text, 'rejected'::text])))
);


ALTER TABLE public.product OWNER TO medusa_admin;

--
-- Name: product_category; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.product_category (
    id text NOT NULL,
    name text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    handle text NOT NULL,
    mpath text NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    is_internal boolean DEFAULT false NOT NULL,
    rank integer DEFAULT 0 NOT NULL,
    parent_category_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb
);


ALTER TABLE public.product_category OWNER TO medusa_admin;

--
-- Name: product_category_product; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.product_category_product (
    product_id text NOT NULL,
    product_category_id text NOT NULL
);


ALTER TABLE public.product_category_product OWNER TO medusa_admin;

--
-- Name: product_collection; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.product_collection (
    id text NOT NULL,
    title text NOT NULL,
    handle text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_collection OWNER TO medusa_admin;

--
-- Name: product_option; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.product_option (
    id text NOT NULL,
    title text NOT NULL,
    product_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_option OWNER TO medusa_admin;

--
-- Name: product_option_value; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.product_option_value (
    id text NOT NULL,
    value text NOT NULL,
    option_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_option_value OWNER TO medusa_admin;

--
-- Name: product_sales_channel; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.product_sales_channel (
    product_id character varying(255) NOT NULL,
    sales_channel_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_sales_channel OWNER TO medusa_admin;

--
-- Name: product_shipping_profile; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.product_shipping_profile (
    product_id character varying(255) NOT NULL,
    shipping_profile_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_shipping_profile OWNER TO medusa_admin;

--
-- Name: product_tag; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.product_tag (
    id text NOT NULL,
    value text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_tag OWNER TO medusa_admin;

--
-- Name: product_tags; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.product_tags (
    product_id text NOT NULL,
    product_tag_id text NOT NULL
);


ALTER TABLE public.product_tags OWNER TO medusa_admin;

--
-- Name: product_type; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.product_type (
    id text NOT NULL,
    value text NOT NULL,
    metadata json,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_type OWNER TO medusa_admin;

--
-- Name: product_variant; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.product_variant (
    id text NOT NULL,
    title text NOT NULL,
    sku text,
    barcode text,
    ean text,
    upc text,
    allow_backorder boolean DEFAULT false NOT NULL,
    manage_inventory boolean DEFAULT true NOT NULL,
    hs_code text,
    origin_country text,
    mid_code text,
    material text,
    weight integer,
    length integer,
    height integer,
    width integer,
    metadata jsonb,
    variant_rank integer DEFAULT 0,
    product_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant OWNER TO medusa_admin;

--
-- Name: product_variant_inventory_item; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.product_variant_inventory_item (
    variant_id character varying(255) NOT NULL,
    inventory_item_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    required_quantity integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant_inventory_item OWNER TO medusa_admin;

--
-- Name: product_variant_option; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.product_variant_option (
    variant_id text NOT NULL,
    option_value_id text NOT NULL
);


ALTER TABLE public.product_variant_option OWNER TO medusa_admin;

--
-- Name: product_variant_price_set; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.product_variant_price_set (
    variant_id character varying(255) NOT NULL,
    price_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant_price_set OWNER TO medusa_admin;

--
-- Name: promotion; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.promotion (
    id text NOT NULL,
    code text NOT NULL,
    campaign_id text,
    is_automatic boolean DEFAULT false NOT NULL,
    type text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    status text DEFAULT 'draft'::text NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    CONSTRAINT promotion_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'active'::text, 'inactive'::text]))),
    CONSTRAINT promotion_type_check CHECK ((type = ANY (ARRAY['standard'::text, 'buyget'::text])))
);


ALTER TABLE public.promotion OWNER TO medusa_admin;

--
-- Name: promotion_application_method; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.promotion_application_method (
    id text NOT NULL,
    value numeric,
    raw_value jsonb,
    max_quantity integer,
    apply_to_quantity integer,
    buy_rules_min_quantity integer,
    type text NOT NULL,
    target_type text NOT NULL,
    allocation text,
    promotion_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    currency_code text,
    CONSTRAINT promotion_application_method_allocation_check CHECK ((allocation = ANY (ARRAY['each'::text, 'across'::text]))),
    CONSTRAINT promotion_application_method_target_type_check CHECK ((target_type = ANY (ARRAY['order'::text, 'shipping_methods'::text, 'items'::text]))),
    CONSTRAINT promotion_application_method_type_check CHECK ((type = ANY (ARRAY['fixed'::text, 'percentage'::text])))
);


ALTER TABLE public.promotion_application_method OWNER TO medusa_admin;

--
-- Name: promotion_campaign; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.promotion_campaign (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    campaign_identifier text NOT NULL,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.promotion_campaign OWNER TO medusa_admin;

--
-- Name: promotion_campaign_budget; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.promotion_campaign_budget (
    id text NOT NULL,
    type text NOT NULL,
    campaign_id text NOT NULL,
    "limit" numeric,
    raw_limit jsonb,
    used numeric DEFAULT 0 NOT NULL,
    raw_used jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    currency_code text,
    CONSTRAINT promotion_campaign_budget_type_check CHECK ((type = ANY (ARRAY['spend'::text, 'usage'::text])))
);


ALTER TABLE public.promotion_campaign_budget OWNER TO medusa_admin;

--
-- Name: promotion_promotion_rule; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.promotion_promotion_rule (
    promotion_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.promotion_promotion_rule OWNER TO medusa_admin;

--
-- Name: promotion_rule; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.promotion_rule (
    id text NOT NULL,
    description text,
    attribute text NOT NULL,
    operator text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT promotion_rule_operator_check CHECK ((operator = ANY (ARRAY['gte'::text, 'lte'::text, 'gt'::text, 'lt'::text, 'eq'::text, 'ne'::text, 'in'::text])))
);


ALTER TABLE public.promotion_rule OWNER TO medusa_admin;

--
-- Name: promotion_rule_value; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.promotion_rule_value (
    id text NOT NULL,
    promotion_rule_id text NOT NULL,
    value text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.promotion_rule_value OWNER TO medusa_admin;

--
-- Name: provider_identity; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.provider_identity (
    id text NOT NULL,
    entity_id text NOT NULL,
    provider text NOT NULL,
    auth_identity_id text NOT NULL,
    user_metadata jsonb,
    provider_metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.provider_identity OWNER TO medusa_admin;

--
-- Name: publishable_api_key_sales_channel; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.publishable_api_key_sales_channel (
    publishable_key_id character varying(255) NOT NULL,
    sales_channel_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.publishable_api_key_sales_channel OWNER TO medusa_admin;

--
-- Name: refund; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.refund (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    payment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text,
    metadata jsonb,
    refund_reason_id text,
    note text
);


ALTER TABLE public.refund OWNER TO medusa_admin;

--
-- Name: refund_reason; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.refund_reason (
    id text NOT NULL,
    label text NOT NULL,
    description text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.refund_reason OWNER TO medusa_admin;

--
-- Name: region; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.region (
    id text NOT NULL,
    name text NOT NULL,
    currency_code text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    automatic_taxes boolean DEFAULT true NOT NULL
);


ALTER TABLE public.region OWNER TO medusa_admin;

--
-- Name: region_country; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.region_country (
    iso_2 text NOT NULL,
    iso_3 text NOT NULL,
    num_code text NOT NULL,
    name text NOT NULL,
    display_name text NOT NULL,
    region_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.region_country OWNER TO medusa_admin;

--
-- Name: region_payment_provider; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.region_payment_provider (
    region_id character varying(255) NOT NULL,
    payment_provider_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.region_payment_provider OWNER TO medusa_admin;

--
-- Name: reservation_item; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.reservation_item (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    line_item_id text,
    location_id text NOT NULL,
    quantity numeric NOT NULL,
    external_id text,
    description text,
    created_by text,
    metadata jsonb,
    inventory_item_id text NOT NULL,
    allow_backorder boolean DEFAULT false,
    raw_quantity jsonb
);


ALTER TABLE public.reservation_item OWNER TO medusa_admin;

--
-- Name: return; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.return (
    id text NOT NULL,
    order_id text NOT NULL,
    claim_id text,
    exchange_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    status public.return_status_enum DEFAULT 'open'::public.return_status_enum NOT NULL,
    no_notification boolean,
    refund_amount numeric,
    raw_refund_amount jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    received_at timestamp with time zone,
    canceled_at timestamp with time zone,
    location_id text,
    requested_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.return OWNER TO medusa_admin;

--
-- Name: return_display_id_seq; Type: SEQUENCE; Schema: public; Owner: medusa_admin
--

CREATE SEQUENCE public.return_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.return_display_id_seq OWNER TO medusa_admin;

--
-- Name: return_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: medusa_admin
--

ALTER SEQUENCE public.return_display_id_seq OWNED BY public.return.display_id;


--
-- Name: return_fulfillment; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.return_fulfillment (
    return_id character varying(255) NOT NULL,
    fulfillment_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.return_fulfillment OWNER TO medusa_admin;

--
-- Name: return_item; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.return_item (
    id text NOT NULL,
    return_id text NOT NULL,
    reason_id text,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    received_quantity numeric DEFAULT 0 NOT NULL,
    raw_received_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    damaged_quantity numeric DEFAULT 0 NOT NULL,
    raw_damaged_quantity jsonb NOT NULL
);


ALTER TABLE public.return_item OWNER TO medusa_admin;

--
-- Name: return_reason; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.return_reason (
    id character varying NOT NULL,
    value character varying NOT NULL,
    label character varying NOT NULL,
    description character varying,
    metadata jsonb,
    parent_return_reason_id character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.return_reason OWNER TO medusa_admin;

--
-- Name: sales_channel; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.sales_channel (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    is_disabled boolean DEFAULT false NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.sales_channel OWNER TO medusa_admin;

--
-- Name: sales_channel_stock_location; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.sales_channel_stock_location (
    sales_channel_id character varying(255) NOT NULL,
    stock_location_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.sales_channel_stock_location OWNER TO medusa_admin;

--
-- Name: script_migrations; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.script_migrations (
    id integer NOT NULL,
    script_name character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    finished_at timestamp with time zone
);


ALTER TABLE public.script_migrations OWNER TO medusa_admin;

--
-- Name: script_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: medusa_admin
--

CREATE SEQUENCE public.script_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.script_migrations_id_seq OWNER TO medusa_admin;

--
-- Name: script_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: medusa_admin
--

ALTER SEQUENCE public.script_migrations_id_seq OWNED BY public.script_migrations.id;


--
-- Name: service_zone; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.service_zone (
    id text NOT NULL,
    name text NOT NULL,
    metadata jsonb,
    fulfillment_set_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.service_zone OWNER TO medusa_admin;

--
-- Name: shipping_option; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.shipping_option (
    id text NOT NULL,
    name text NOT NULL,
    price_type text DEFAULT 'flat'::text NOT NULL,
    service_zone_id text NOT NULL,
    shipping_profile_id text,
    provider_id text,
    data jsonb,
    metadata jsonb,
    shipping_option_type_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT shipping_option_price_type_check CHECK ((price_type = ANY (ARRAY['calculated'::text, 'flat'::text])))
);


ALTER TABLE public.shipping_option OWNER TO medusa_admin;

--
-- Name: shipping_option_price_set; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.shipping_option_price_set (
    shipping_option_id character varying(255) NOT NULL,
    price_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_option_price_set OWNER TO medusa_admin;

--
-- Name: shipping_option_rule; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.shipping_option_rule (
    id text NOT NULL,
    attribute text NOT NULL,
    operator text NOT NULL,
    value jsonb,
    shipping_option_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT shipping_option_rule_operator_check CHECK ((operator = ANY (ARRAY['in'::text, 'eq'::text, 'ne'::text, 'gt'::text, 'gte'::text, 'lt'::text, 'lte'::text, 'nin'::text])))
);


ALTER TABLE public.shipping_option_rule OWNER TO medusa_admin;

--
-- Name: shipping_option_type; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.shipping_option_type (
    id text NOT NULL,
    label text NOT NULL,
    description text,
    code text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_option_type OWNER TO medusa_admin;

--
-- Name: shipping_profile; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.shipping_profile (
    id text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_profile OWNER TO medusa_admin;

--
-- Name: stock_location; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.stock_location (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    name text NOT NULL,
    address_id text,
    metadata jsonb
);


ALTER TABLE public.stock_location OWNER TO medusa_admin;

--
-- Name: stock_location_address; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.stock_location_address (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    address_1 text NOT NULL,
    address_2 text,
    company text,
    city text,
    country_code text NOT NULL,
    phone text,
    province text,
    postal_code text,
    metadata jsonb
);


ALTER TABLE public.stock_location_address OWNER TO medusa_admin;

--
-- Name: store; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.store (
    id text NOT NULL,
    name text DEFAULT 'Medusa Store'::text NOT NULL,
    default_sales_channel_id text,
    default_region_id text,
    default_location_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.store OWNER TO medusa_admin;

--
-- Name: store_currency; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.store_currency (
    id text NOT NULL,
    currency_code text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    store_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.store_currency OWNER TO medusa_admin;

--
-- Name: tax_provider; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.tax_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_provider OWNER TO medusa_admin;

--
-- Name: tax_rate; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.tax_rate (
    id text NOT NULL,
    rate real,
    code text NOT NULL,
    name text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    is_combinable boolean DEFAULT false NOT NULL,
    tax_region_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_rate OWNER TO medusa_admin;

--
-- Name: tax_rate_rule; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.tax_rate_rule (
    id text NOT NULL,
    tax_rate_id text NOT NULL,
    reference_id text NOT NULL,
    reference text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_rate_rule OWNER TO medusa_admin;

--
-- Name: tax_region; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.tax_region (
    id text NOT NULL,
    provider_id text,
    country_code text NOT NULL,
    province_code text,
    parent_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone,
    CONSTRAINT "CK_tax_region_country_top_level" CHECK (((parent_id IS NULL) OR (province_code IS NOT NULL))),
    CONSTRAINT "CK_tax_region_provider_top_level" CHECK (((parent_id IS NULL) OR (provider_id IS NULL)))
);


ALTER TABLE public.tax_region OWNER TO medusa_admin;

--
-- Name: user; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public."user" (
    id text NOT NULL,
    first_name text,
    last_name text,
    email text NOT NULL,
    avatar_url text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public."user" OWNER TO medusa_admin;

--
-- Name: user_preference; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.user_preference (
    id text NOT NULL,
    user_id text NOT NULL,
    key text NOT NULL,
    value jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.user_preference OWNER TO medusa_admin;

--
-- Name: view_configuration; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.view_configuration (
    id text NOT NULL,
    entity text NOT NULL,
    name text,
    user_id text,
    is_system_default boolean DEFAULT false NOT NULL,
    configuration jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.view_configuration OWNER TO medusa_admin;

--
-- Name: workflow_execution; Type: TABLE; Schema: public; Owner: medusa_admin
--

CREATE TABLE public.workflow_execution (
    id character varying DEFAULT ('wf_exec_'::text || encode(public.gen_random_bytes(6), 'hex'::text)) NOT NULL,
    workflow_id character varying NOT NULL,
    transaction_id character varying NOT NULL,
    execution jsonb,
    context jsonb,
    state character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    retention_time integer,
    run_id text DEFAULT '01K7ES73YJCNJY1S1PN62SJ99B'::text NOT NULL
);


ALTER TABLE public.workflow_execution OWNER TO medusa_admin;

--
-- Name: link_module_migrations id; Type: DEFAULT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.link_module_migrations ALTER COLUMN id SET DEFAULT nextval('public.link_module_migrations_id_seq'::regclass);


--
-- Name: mikro_orm_migrations id; Type: DEFAULT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.mikro_orm_migrations ALTER COLUMN id SET DEFAULT nextval('public.mikro_orm_migrations_id_seq'::regclass);


--
-- Name: order display_id; Type: DEFAULT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public."order" ALTER COLUMN display_id SET DEFAULT nextval('public.order_display_id_seq'::regclass);


--
-- Name: order_change_action ordering; Type: DEFAULT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_change_action ALTER COLUMN ordering SET DEFAULT nextval('public.order_change_action_ordering_seq'::regclass);


--
-- Name: order_claim display_id; Type: DEFAULT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_claim ALTER COLUMN display_id SET DEFAULT nextval('public.order_claim_display_id_seq'::regclass);


--
-- Name: order_exchange display_id; Type: DEFAULT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_exchange ALTER COLUMN display_id SET DEFAULT nextval('public.order_exchange_display_id_seq'::regclass);


--
-- Name: return display_id; Type: DEFAULT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.return ALTER COLUMN display_id SET DEFAULT nextval('public.return_display_id_seq'::regclass);


--
-- Name: script_migrations id; Type: DEFAULT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.script_migrations ALTER COLUMN id SET DEFAULT nextval('public.script_migrations_id_seq'::regclass);


--
-- Data for Name: account_holder; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.account_holder (id, provider_id, external_id, email, data, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: api_key; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.api_key (id, token, salt, redacted, title, type, last_used_at, created_by, created_at, revoked_by, revoked_at, updated_at, deleted_at) FROM stdin;
apk_01K7ES77H4W9T1RSE9N4S9GPVF	pk_cd02fba29bb2f7a2b25e3e7654609b0ae534fe11b15d74cb4cbfc216ef4f9148		pk_cd0***148	Webshop	publishable	\N		2025-10-13 14:37:43.076+02	\N	\N	2025-10-13 14:37:43.076+02	\N
apk_01K7RZJCVV2HG3ZP945PS2YV34	b096ba2a5741bd32be3dab6ae4aa73a6f6746574b5e07cafd029eda7b2eeec6185cf16b325f6e7ebff2b30df3d37935085d9b2eca7fb97a3fe78d5b31148a37a	a07ff57309fd9a3237916fc49fdbc090	sk_339***32d	CLI Token	secret	\N	user_01K7ES8R10QJV2H779G7ARRSB9	2025-10-17 13:41:04.763+02	\N	\N	2025-10-17 13:41:04.763+02	\N
\.


--
-- Data for Name: application_method_buy_rules; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.application_method_buy_rules (application_method_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: application_method_target_rules; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.application_method_target_rules (application_method_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: auth_identity; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.auth_identity (id, app_metadata, created_at, updated_at, deleted_at) FROM stdin;
authid_01K7ES8R0EKSDTYCTR2ZW1YKGD	{"user_id": "user_01K7ES8R10QJV2H779G7ARRSB9"}	2025-10-13 14:38:32.718+02	2025-10-13 14:38:32.741+02	\N
\.


--
-- Data for Name: capture; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.capture (id, amount, raw_amount, payment_id, created_at, updated_at, deleted_at, created_by, metadata) FROM stdin;
\.


--
-- Data for Name: cart; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.cart (id, region_id, customer_id, sales_channel_id, email, currency_code, shipping_address_id, billing_address_id, metadata, created_at, updated_at, deleted_at, completed_at) FROM stdin;
\.


--
-- Data for Name: cart_address; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.cart_address (id, customer_id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_line_item; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.cart_line_item (id, cart_id, title, subtitle, thumbnail, quantity, variant_id, product_id, product_title, product_description, product_subtitle, product_type, product_collection, product_handle, variant_sku, variant_barcode, variant_title, variant_option_values, requires_shipping, is_discountable, is_tax_inclusive, compare_at_unit_price, raw_compare_at_unit_price, unit_price, raw_unit_price, metadata, created_at, updated_at, deleted_at, product_type_id, is_custom_price, is_giftcard) FROM stdin;
\.


--
-- Data for Name: cart_line_item_adjustment; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.cart_line_item_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, metadata, created_at, updated_at, deleted_at, item_id, is_tax_inclusive) FROM stdin;
\.


--
-- Data for Name: cart_line_item_tax_line; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.cart_line_item_tax_line (id, description, tax_rate_id, code, rate, provider_id, metadata, created_at, updated_at, deleted_at, item_id) FROM stdin;
\.


--
-- Data for Name: cart_payment_collection; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.cart_payment_collection (cart_id, payment_collection_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_promotion; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.cart_promotion (cart_id, promotion_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_shipping_method; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.cart_shipping_method (id, cart_id, name, description, amount, raw_amount, is_tax_inclusive, shipping_option_id, data, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_shipping_method_adjustment; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.cart_shipping_method_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, metadata, created_at, updated_at, deleted_at, shipping_method_id) FROM stdin;
\.


--
-- Data for Name: cart_shipping_method_tax_line; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.cart_shipping_method_tax_line (id, description, tax_rate_id, code, rate, provider_id, metadata, created_at, updated_at, deleted_at, shipping_method_id) FROM stdin;
\.


--
-- Data for Name: credit_line; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.credit_line (id, cart_id, reference, reference_id, amount, raw_amount, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: currency; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.currency (code, symbol, symbol_native, decimal_digits, rounding, raw_rounding, name, created_at, updated_at, deleted_at) FROM stdin;
usd	$	$	2	0	{"value": "0", "precision": 20}	US Dollar	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
cad	CA$	$	2	0	{"value": "0", "precision": 20}	Canadian Dollar	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
eur	€	€	2	0	{"value": "0", "precision": 20}	Euro	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
aed	AED	د.إ.‏	2	0	{"value": "0", "precision": 20}	United Arab Emirates Dirham	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
afn	Af	؋	0	0	{"value": "0", "precision": 20}	Afghan Afghani	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
all	ALL	Lek	0	0	{"value": "0", "precision": 20}	Albanian Lek	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
amd	AMD	դր.	0	0	{"value": "0", "precision": 20}	Armenian Dram	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
ars	AR$	$	2	0	{"value": "0", "precision": 20}	Argentine Peso	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
aud	AU$	$	2	0	{"value": "0", "precision": 20}	Australian Dollar	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
azn	man.	ман.	2	0	{"value": "0", "precision": 20}	Azerbaijani Manat	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
bam	KM	KM	2	0	{"value": "0", "precision": 20}	Bosnia-Herzegovina Convertible Mark	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
bdt	Tk	৳	2	0	{"value": "0", "precision": 20}	Bangladeshi Taka	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
bgn	BGN	лв.	2	0	{"value": "0", "precision": 20}	Bulgarian Lev	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
bhd	BD	د.ب.‏	3	0	{"value": "0", "precision": 20}	Bahraini Dinar	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
bif	FBu	FBu	0	0	{"value": "0", "precision": 20}	Burundian Franc	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
bnd	BN$	$	2	0	{"value": "0", "precision": 20}	Brunei Dollar	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
bob	Bs	Bs	2	0	{"value": "0", "precision": 20}	Bolivian Boliviano	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
brl	R$	R$	2	0	{"value": "0", "precision": 20}	Brazilian Real	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
bwp	BWP	P	2	0	{"value": "0", "precision": 20}	Botswanan Pula	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
byn	Br	руб.	2	0	{"value": "0", "precision": 20}	Belarusian Ruble	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
bzd	BZ$	$	2	0	{"value": "0", "precision": 20}	Belize Dollar	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
cdf	CDF	FrCD	2	0	{"value": "0", "precision": 20}	Congolese Franc	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
chf	CHF	CHF	2	0.05	{"value": "0.05", "precision": 20}	Swiss Franc	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
clp	CL$	$	0	0	{"value": "0", "precision": 20}	Chilean Peso	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
cny	CN¥	CN¥	2	0	{"value": "0", "precision": 20}	Chinese Yuan	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
cop	CO$	$	0	0	{"value": "0", "precision": 20}	Colombian Peso	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
crc	₡	₡	0	0	{"value": "0", "precision": 20}	Costa Rican Colón	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
cve	CV$	CV$	2	0	{"value": "0", "precision": 20}	Cape Verdean Escudo	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
czk	Kč	Kč	2	0	{"value": "0", "precision": 20}	Czech Republic Koruna	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
djf	Fdj	Fdj	0	0	{"value": "0", "precision": 20}	Djiboutian Franc	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
dkk	Dkr	kr	2	0	{"value": "0", "precision": 20}	Danish Krone	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
dop	RD$	RD$	2	0	{"value": "0", "precision": 20}	Dominican Peso	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
dzd	DA	د.ج.‏	2	0	{"value": "0", "precision": 20}	Algerian Dinar	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
eek	Ekr	kr	2	0	{"value": "0", "precision": 20}	Estonian Kroon	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
egp	EGP	ج.م.‏	2	0	{"value": "0", "precision": 20}	Egyptian Pound	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
ern	Nfk	Nfk	2	0	{"value": "0", "precision": 20}	Eritrean Nakfa	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
etb	Br	Br	2	0	{"value": "0", "precision": 20}	Ethiopian Birr	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
gbp	£	£	2	0	{"value": "0", "precision": 20}	British Pound Sterling	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
gel	GEL	GEL	2	0	{"value": "0", "precision": 20}	Georgian Lari	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
ghs	GH₵	GH₵	2	0	{"value": "0", "precision": 20}	Ghanaian Cedi	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
gnf	FG	FG	0	0	{"value": "0", "precision": 20}	Guinean Franc	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
gtq	GTQ	Q	2	0	{"value": "0", "precision": 20}	Guatemalan Quetzal	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
hkd	HK$	$	2	0	{"value": "0", "precision": 20}	Hong Kong Dollar	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
hnl	HNL	L	2	0	{"value": "0", "precision": 20}	Honduran Lempira	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
hrk	kn	kn	2	0	{"value": "0", "precision": 20}	Croatian Kuna	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
huf	Ft	Ft	0	0	{"value": "0", "precision": 20}	Hungarian Forint	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
idr	Rp	Rp	0	0	{"value": "0", "precision": 20}	Indonesian Rupiah	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
ils	₪	₪	2	0	{"value": "0", "precision": 20}	Israeli New Sheqel	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
inr	Rs	₹	2	0	{"value": "0", "precision": 20}	Indian Rupee	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
iqd	IQD	د.ع.‏	0	0	{"value": "0", "precision": 20}	Iraqi Dinar	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
irr	IRR	﷼	0	0	{"value": "0", "precision": 20}	Iranian Rial	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
isk	Ikr	kr	0	0	{"value": "0", "precision": 20}	Icelandic Króna	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
jmd	J$	$	2	0	{"value": "0", "precision": 20}	Jamaican Dollar	2025-10-13 14:37:40.366+02	2025-10-13 14:37:40.366+02	\N
jod	JD	د.أ.‏	3	0	{"value": "0", "precision": 20}	Jordanian Dinar	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
jpy	¥	￥	0	0	{"value": "0", "precision": 20}	Japanese Yen	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
kes	Ksh	Ksh	2	0	{"value": "0", "precision": 20}	Kenyan Shilling	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
khr	KHR	៛	2	0	{"value": "0", "precision": 20}	Cambodian Riel	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
kmf	CF	FC	0	0	{"value": "0", "precision": 20}	Comorian Franc	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
krw	₩	₩	0	0	{"value": "0", "precision": 20}	South Korean Won	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
kwd	KD	د.ك.‏	3	0	{"value": "0", "precision": 20}	Kuwaiti Dinar	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
kzt	KZT	тңг.	2	0	{"value": "0", "precision": 20}	Kazakhstani Tenge	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
lbp	LB£	ل.ل.‏	0	0	{"value": "0", "precision": 20}	Lebanese Pound	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
lkr	SLRs	SL Re	2	0	{"value": "0", "precision": 20}	Sri Lankan Rupee	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
ltl	Lt	Lt	2	0	{"value": "0", "precision": 20}	Lithuanian Litas	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
lvl	Ls	Ls	2	0	{"value": "0", "precision": 20}	Latvian Lats	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
lyd	LD	د.ل.‏	3	0	{"value": "0", "precision": 20}	Libyan Dinar	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
mad	MAD	د.م.‏	2	0	{"value": "0", "precision": 20}	Moroccan Dirham	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
mdl	MDL	MDL	2	0	{"value": "0", "precision": 20}	Moldovan Leu	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
mga	MGA	MGA	0	0	{"value": "0", "precision": 20}	Malagasy Ariary	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
mkd	MKD	MKD	2	0	{"value": "0", "precision": 20}	Macedonian Denar	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
mmk	MMK	K	0	0	{"value": "0", "precision": 20}	Myanma Kyat	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
mnt	MNT	₮	0	0	{"value": "0", "precision": 20}	Mongolian Tugrig	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
mop	MOP$	MOP$	2	0	{"value": "0", "precision": 20}	Macanese Pataca	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
mur	MURs	MURs	0	0	{"value": "0", "precision": 20}	Mauritian Rupee	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
mwk	K	K	2	0	{"value": "0", "precision": 20}	Malawian Kwacha	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
mxn	MX$	$	2	0	{"value": "0", "precision": 20}	Mexican Peso	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
myr	RM	RM	2	0	{"value": "0", "precision": 20}	Malaysian Ringgit	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
mzn	MTn	MTn	2	0	{"value": "0", "precision": 20}	Mozambican Metical	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
nad	N$	N$	2	0	{"value": "0", "precision": 20}	Namibian Dollar	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
ngn	₦	₦	2	0	{"value": "0", "precision": 20}	Nigerian Naira	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
nio	C$	C$	2	0	{"value": "0", "precision": 20}	Nicaraguan Córdoba	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
nok	Nkr	kr	2	0	{"value": "0", "precision": 20}	Norwegian Krone	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
npr	NPRs	नेरू	2	0	{"value": "0", "precision": 20}	Nepalese Rupee	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
nzd	NZ$	$	2	0	{"value": "0", "precision": 20}	New Zealand Dollar	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
omr	OMR	ر.ع.‏	3	0	{"value": "0", "precision": 20}	Omani Rial	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
pab	B/.	B/.	2	0	{"value": "0", "precision": 20}	Panamanian Balboa	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
pen	S/.	S/.	2	0	{"value": "0", "precision": 20}	Peruvian Nuevo Sol	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
php	₱	₱	2	0	{"value": "0", "precision": 20}	Philippine Peso	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
pkr	PKRs	₨	0	0	{"value": "0", "precision": 20}	Pakistani Rupee	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
pln	zł	zł	2	0	{"value": "0", "precision": 20}	Polish Zloty	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
pyg	₲	₲	0	0	{"value": "0", "precision": 20}	Paraguayan Guarani	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
qar	QR	ر.ق.‏	2	0	{"value": "0", "precision": 20}	Qatari Rial	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
ron	RON	RON	2	0	{"value": "0", "precision": 20}	Romanian Leu	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
rsd	din.	дин.	0	0	{"value": "0", "precision": 20}	Serbian Dinar	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
rub	RUB	₽.	2	0	{"value": "0", "precision": 20}	Russian Ruble	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
rwf	RWF	FR	0	0	{"value": "0", "precision": 20}	Rwandan Franc	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
sar	SR	ر.س.‏	2	0	{"value": "0", "precision": 20}	Saudi Riyal	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
sdg	SDG	SDG	2	0	{"value": "0", "precision": 20}	Sudanese Pound	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
sek	Skr	kr	2	0	{"value": "0", "precision": 20}	Swedish Krona	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
sgd	S$	$	2	0	{"value": "0", "precision": 20}	Singapore Dollar	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
sos	Ssh	Ssh	0	0	{"value": "0", "precision": 20}	Somali Shilling	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
syp	SY£	ل.س.‏	0	0	{"value": "0", "precision": 20}	Syrian Pound	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
thb	฿	฿	2	0	{"value": "0", "precision": 20}	Thai Baht	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
tnd	DT	د.ت.‏	3	0	{"value": "0", "precision": 20}	Tunisian Dinar	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
top	T$	T$	2	0	{"value": "0", "precision": 20}	Tongan Paʻanga	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
tjs	TJS	с.	2	0	{"value": "0", "precision": 20}	Tajikistani Somoni	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
try	₺	₺	2	0	{"value": "0", "precision": 20}	Turkish Lira	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
ttd	TT$	$	2	0	{"value": "0", "precision": 20}	Trinidad and Tobago Dollar	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
twd	NT$	NT$	2	0	{"value": "0", "precision": 20}	New Taiwan Dollar	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
tzs	TSh	TSh	0	0	{"value": "0", "precision": 20}	Tanzanian Shilling	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
uah	₴	₴	2	0	{"value": "0", "precision": 20}	Ukrainian Hryvnia	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
ugx	USh	USh	0	0	{"value": "0", "precision": 20}	Ugandan Shilling	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
uyu	$U	$	2	0	{"value": "0", "precision": 20}	Uruguayan Peso	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
uzs	UZS	UZS	0	0	{"value": "0", "precision": 20}	Uzbekistan Som	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
vef	Bs.F.	Bs.F.	2	0	{"value": "0", "precision": 20}	Venezuelan Bolívar	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
vnd	₫	₫	0	0	{"value": "0", "precision": 20}	Vietnamese Dong	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
xaf	FCFA	FCFA	0	0	{"value": "0", "precision": 20}	CFA Franc BEAC	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
xof	CFA	CFA	0	0	{"value": "0", "precision": 20}	CFA Franc BCEAO	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
xpf	₣	₣	0	0	{"value": "0", "precision": 20}	CFP Franc	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
yer	YR	ر.ي.‏	0	0	{"value": "0", "precision": 20}	Yemeni Rial	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
zar	R	R	2	0	{"value": "0", "precision": 20}	South African Rand	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
zmk	ZK	ZK	0	0	{"value": "0", "precision": 20}	Zambian Kwacha	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
zwl	ZWL$	ZWL$	0	0	{"value": "0", "precision": 20}	Zimbabwean Dollar	2025-10-13 14:37:40.367+02	2025-10-13 14:37:40.367+02	\N
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.customer (id, company_name, first_name, last_name, email, phone, has_account, metadata, created_at, updated_at, deleted_at, created_by) FROM stdin;
\.


--
-- Data for Name: customer_account_holder; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.customer_account_holder (customer_id, account_holder_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_address; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.customer_address (id, customer_id, address_name, is_default_shipping, is_default_billing, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_group; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.customer_group (id, name, metadata, created_by, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_group_customer; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.customer_group_customer (id, customer_id, customer_group_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.fulfillment (id, location_id, packed_at, shipped_at, delivered_at, canceled_at, data, provider_id, shipping_option_id, metadata, delivery_address_id, created_at, updated_at, deleted_at, marked_shipped_by, created_by, requires_shipping) FROM stdin;
\.


--
-- Data for Name: fulfillment_address; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.fulfillment_address (id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_item; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.fulfillment_item (id, title, sku, barcode, quantity, raw_quantity, line_item_id, inventory_item_id, fulfillment_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_label; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.fulfillment_label (id, tracking_number, tracking_url, label_url, fulfillment_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_provider; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.fulfillment_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
manual_manual	t	2025-10-13 14:37:40.371+02	2025-10-13 14:37:40.371+02	\N
\.


--
-- Data for Name: fulfillment_set; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.fulfillment_set (id, name, type, metadata, created_at, updated_at, deleted_at) FROM stdin;
fuset_01K7ES77FYWAPFFAEYJWJ4GJGF	European Warehouse delivery	shipping	\N	2025-10-13 14:37:43.038+02	2025-10-13 14:37:43.038+02	\N
\.


--
-- Data for Name: geo_zone; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.geo_zone (id, type, country_code, province_code, city, service_zone_id, postal_expression, metadata, created_at, updated_at, deleted_at) FROM stdin;
fgz_01K7ES77FYJTWXDRPMMHD4Q5SR	country	gb	\N	\N	serzo_01K7ES77FYQCP03ZN68QG3QG6C	\N	\N	2025-10-13 14:37:43.038+02	2025-10-13 14:37:43.038+02	\N
fgz_01K7ES77FYJGFNTN4HM4FK6JBH	country	de	\N	\N	serzo_01K7ES77FYQCP03ZN68QG3QG6C	\N	\N	2025-10-13 14:37:43.038+02	2025-10-13 14:37:43.038+02	\N
fgz_01K7ES77FYR84CQFYFA8ZWQM9Q	country	dk	\N	\N	serzo_01K7ES77FYQCP03ZN68QG3QG6C	\N	\N	2025-10-13 14:37:43.038+02	2025-10-13 14:37:43.038+02	\N
fgz_01K7ES77FYR5XVBFB9KJX7701A	country	se	\N	\N	serzo_01K7ES77FYQCP03ZN68QG3QG6C	\N	\N	2025-10-13 14:37:43.038+02	2025-10-13 14:37:43.038+02	\N
fgz_01K7ES77FYWB249DN8T2CFBNPB	country	fr	\N	\N	serzo_01K7ES77FYQCP03ZN68QG3QG6C	\N	\N	2025-10-13 14:37:43.038+02	2025-10-13 14:37:43.038+02	\N
fgz_01K7ES77FYK6E6ZWPX1X9RYDG9	country	es	\N	\N	serzo_01K7ES77FYQCP03ZN68QG3QG6C	\N	\N	2025-10-13 14:37:43.038+02	2025-10-13 14:37:43.038+02	\N
fgz_01K7ES77FYXWA59REBPS2C6AH1	country	it	\N	\N	serzo_01K7ES77FYQCP03ZN68QG3QG6C	\N	\N	2025-10-13 14:37:43.038+02	2025-10-13 14:37:43.038+02	\N
\.


--
-- Data for Name: image; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.image (id, url, metadata, created_at, updated_at, deleted_at, rank, product_id) FROM stdin;
img_01K7ES77HJ6RK9YFRNJWHYDP4R	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	\N	2025-10-13 14:37:43.091+02	2025-10-13 14:37:43.091+02	\N	0	prod_01K7ES77HH9P1ZCSCMGX3RHHR3
img_01K7ES77HJJ2FKVHG2X7JES53G	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-back.png	\N	2025-10-13 14:37:43.091+02	2025-10-13 14:37:43.091+02	\N	1	prod_01K7ES77HH9P1ZCSCMGX3RHHR3
img_01K7ES77HJY02CKCAECY5DEC5B	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-white-front.png	\N	2025-10-13 14:37:43.091+02	2025-10-13 14:37:43.091+02	\N	2	prod_01K7ES77HH9P1ZCSCMGX3RHHR3
img_01K7ES77HJ01KH28ZSNQHWC411	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-white-back.png	\N	2025-10-13 14:37:43.091+02	2025-10-13 14:37:43.091+02	\N	3	prod_01K7ES77HH9P1ZCSCMGX3RHHR3
img_01K7ES77HK7W8279GVFJ76XS8C	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-front.png	\N	2025-10-13 14:37:43.092+02	2025-10-13 14:37:43.092+02	\N	0	prod_01K7ES77HH0BV45MM5T369WV9M
img_01K7ES77HKT46NB7MJD3MB4EHP	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-back.png	\N	2025-10-13 14:37:43.092+02	2025-10-13 14:37:43.092+02	\N	1	prod_01K7ES77HH0BV45MM5T369WV9M
img_01K7ES77HKE87YVG1JTZHEKVC8	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-front.png	\N	2025-10-13 14:37:43.092+02	2025-10-13 14:37:43.092+02	\N	0	prod_01K7ES77HH69PKQSHH4F21KQQ8
img_01K7ES77HKGE0BQS1336V7PTWC	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-back.png	\N	2025-10-13 14:37:43.092+02	2025-10-13 14:37:43.092+02	\N	1	prod_01K7ES77HH69PKQSHH4F21KQQ8
img_01K7ES77HKSDVB2KCGPK8TKXPF	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png	\N	2025-10-13 14:37:43.092+02	2025-10-13 14:37:43.092+02	\N	0	prod_01K7ES77HHSKCAJXB0SS0Q6P3F
img_01K7ES77HKWC1F2KX0F8ABR6CD	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-back.png	\N	2025-10-13 14:37:43.092+02	2025-10-13 14:37:43.092+02	\N	1	prod_01K7ES77HHSKCAJXB0SS0Q6P3F
img_01K7KSDA275KBRRJK9G9PE4775	http://localhost:9000/static/1760527034422-camden_retreat.png	\N	2025-10-15 13:17:14.44+02	2025-10-15 13:17:14.44+02	\N	0	prod_01K7KSDA268TQ4K31J8VMYHZZG
img_01K7KSN27PK1GPEBPCY2AKEHRQ	http://localhost:9000/static/1760527288553-oslo_drift.png	\N	2025-10-15 13:21:28.567+02	2025-10-15 13:21:28.567+02	\N	0	prod_01K7KSN27P21FYJSRXFPXT7ME0
img_01K7KSQ75K5PTPN49BDR4YGKJR	http://localhost:9000/static/1760527359137-sutton_royale.png	\N	2025-10-15 13:22:39.155+02	2025-10-15 13:22:39.155+02	\N	0	prod_01K7KSQ75J61K7Z7Q7V16C9K8C
img_01K7PEJV2B3VSYYGB9Y41VYRB5	http://localhost:9000/static/1760615602182-paloma_image_one.png	\N	2025-10-16 14:05:44.651+02	2025-10-16 14:05:44.651+02	\N	0	prod_01K7P7DXVF2Y1MMY4NXFW2PQ6A
img_01K7PEJV2B2C4V8Y3KZV5CPMGZ	http://localhost:9000/static/1760616344607-paloma_image_one.png	\N	2025-10-16 14:05:44.651+02	2025-10-16 14:05:44.651+02	\N	1	prod_01K7P7DXVF2Y1MMY4NXFW2PQ6A
\.


--
-- Data for Name: inventory_item; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.inventory_item (id, created_at, updated_at, deleted_at, sku, origin_country, hs_code, mid_code, material, weight, length, height, width, requires_shipping, description, title, thumbnail, metadata) FROM stdin;
iitem_01K7ES77K024VPPY9JCFSAVQYN	2025-10-13 14:37:43.137+02	2025-10-13 14:37:43.137+02	\N	SHIRT-S-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	S / Black	S / Black	\N	\N
iitem_01K7ES77K01CVQPDH49MZJ7Y41	2025-10-13 14:37:43.137+02	2025-10-13 14:37:43.137+02	\N	SHIRT-S-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	S / White	S / White	\N	\N
iitem_01K7ES77K0W0MVPKTHV694Z6DR	2025-10-13 14:37:43.137+02	2025-10-13 14:37:43.137+02	\N	SHIRT-M-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	M / Black	M / Black	\N	\N
iitem_01K7ES77K0WCTV1PSXBQHPD9MS	2025-10-13 14:37:43.137+02	2025-10-13 14:37:43.137+02	\N	SHIRT-M-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	M / White	M / White	\N	\N
iitem_01K7ES77K1Y4R6W6XG42QVJMH1	2025-10-13 14:37:43.137+02	2025-10-13 14:37:43.137+02	\N	SHIRT-L-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	L / Black	L / Black	\N	\N
iitem_01K7ES77K1K50GHYRHTJVAG047	2025-10-13 14:37:43.137+02	2025-10-13 14:37:43.137+02	\N	SHIRT-L-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	L / White	L / White	\N	\N
iitem_01K7ES77K1S1T1488AV1QQWQFQ	2025-10-13 14:37:43.137+02	2025-10-13 14:37:43.137+02	\N	SHIRT-XL-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	XL / Black	XL / Black	\N	\N
iitem_01K7ES77K1XMT7D93SEKGNFAH2	2025-10-13 14:37:43.137+02	2025-10-13 14:37:43.137+02	\N	SHIRT-XL-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	XL / White	XL / White	\N	\N
iitem_01K7ES77K13BDQP8EPGKH84N2C	2025-10-13 14:37:43.137+02	2025-10-13 14:37:43.137+02	\N	SWEATSHIRT-S	\N	\N	\N	\N	\N	\N	\N	\N	t	S	S	\N	\N
iitem_01K7ES77K1KFZE9KX19BAAQB8G	2025-10-13 14:37:43.137+02	2025-10-13 14:37:43.137+02	\N	SWEATSHIRT-M	\N	\N	\N	\N	\N	\N	\N	\N	t	M	M	\N	\N
iitem_01K7ES77K1FRZZAQ9043HFC03N	2025-10-13 14:37:43.137+02	2025-10-13 14:37:43.137+02	\N	SWEATSHIRT-L	\N	\N	\N	\N	\N	\N	\N	\N	t	L	L	\N	\N
iitem_01K7ES77K1859APVJJ6JHR2P8B	2025-10-13 14:37:43.137+02	2025-10-13 14:37:43.137+02	\N	SWEATSHIRT-XL	\N	\N	\N	\N	\N	\N	\N	\N	t	XL	XL	\N	\N
iitem_01K7ES77K1VJ372XVY3DF9RZ90	2025-10-13 14:37:43.137+02	2025-10-13 14:37:43.137+02	\N	SWEATPANTS-S	\N	\N	\N	\N	\N	\N	\N	\N	t	S	S	\N	\N
iitem_01K7ES77K1RMF8NN09R6Y463Z5	2025-10-13 14:37:43.137+02	2025-10-13 14:37:43.137+02	\N	SWEATPANTS-M	\N	\N	\N	\N	\N	\N	\N	\N	t	M	M	\N	\N
iitem_01K7ES77K1Z624EBREA5NEAV17	2025-10-13 14:37:43.137+02	2025-10-13 14:37:43.137+02	\N	SWEATPANTS-L	\N	\N	\N	\N	\N	\N	\N	\N	t	L	L	\N	\N
iitem_01K7ES77K1XPS8AJ0335JKTQRG	2025-10-13 14:37:43.137+02	2025-10-13 14:37:43.137+02	\N	SWEATPANTS-XL	\N	\N	\N	\N	\N	\N	\N	\N	t	XL	XL	\N	\N
iitem_01K7ES77K1V39FDX4Y1F177A5V	2025-10-13 14:37:43.137+02	2025-10-13 14:37:43.137+02	\N	SHORTS-S	\N	\N	\N	\N	\N	\N	\N	\N	t	S	S	\N	\N
iitem_01K7ES77K14Z1AR610VA138G0Y	2025-10-13 14:37:43.137+02	2025-10-13 14:37:43.137+02	\N	SHORTS-M	\N	\N	\N	\N	\N	\N	\N	\N	t	M	M	\N	\N
iitem_01K7ES77K1J5FT420N1AHKGXXQ	2025-10-13 14:37:43.137+02	2025-10-13 14:37:43.137+02	\N	SHORTS-L	\N	\N	\N	\N	\N	\N	\N	\N	t	L	L	\N	\N
iitem_01K7ES77K16FBY9ZN53D5P8H7R	2025-10-13 14:37:43.137+02	2025-10-13 14:37:43.137+02	\N	SHORTS-XL	\N	\N	\N	\N	\N	\N	\N	\N	t	XL	XL	\N	\N
\.


--
-- Data for Name: inventory_level; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.inventory_level (id, created_at, updated_at, deleted_at, inventory_item_id, location_id, stocked_quantity, reserved_quantity, incoming_quantity, metadata, raw_stocked_quantity, raw_reserved_quantity, raw_incoming_quantity) FROM stdin;
ilev_01K7ES77MMBMDA40YYRPSPSSKC	2025-10-13 14:37:43.189+02	2025-10-13 14:37:43.189+02	\N	iitem_01K7ES77K01CVQPDH49MZJ7Y41	sloc_01K7ES77FK2N5KVD364ABE0NCQ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K7ES77MMMGQ6KCWFDJRDWJJW	2025-10-13 14:37:43.189+02	2025-10-13 14:37:43.189+02	\N	iitem_01K7ES77K024VPPY9JCFSAVQYN	sloc_01K7ES77FK2N5KVD364ABE0NCQ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K7ES77MMQGW6WRRYN6BGTHX1	2025-10-13 14:37:43.189+02	2025-10-13 14:37:43.189+02	\N	iitem_01K7ES77K0W0MVPKTHV694Z6DR	sloc_01K7ES77FK2N5KVD364ABE0NCQ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K7ES77MN5W00VRSWGFEM0CX7	2025-10-13 14:37:43.189+02	2025-10-13 14:37:43.189+02	\N	iitem_01K7ES77K0WCTV1PSXBQHPD9MS	sloc_01K7ES77FK2N5KVD364ABE0NCQ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K7ES77MNGRQF4H473NXR25YE	2025-10-13 14:37:43.189+02	2025-10-13 14:37:43.189+02	\N	iitem_01K7ES77K13BDQP8EPGKH84N2C	sloc_01K7ES77FK2N5KVD364ABE0NCQ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K7ES77MNA7REFC1QDCNVRSZ2	2025-10-13 14:37:43.189+02	2025-10-13 14:37:43.189+02	\N	iitem_01K7ES77K14Z1AR610VA138G0Y	sloc_01K7ES77FK2N5KVD364ABE0NCQ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K7ES77MNCB25DDV9PX86N2XZ	2025-10-13 14:37:43.189+02	2025-10-13 14:37:43.189+02	\N	iitem_01K7ES77K16FBY9ZN53D5P8H7R	sloc_01K7ES77FK2N5KVD364ABE0NCQ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K7ES77MNT4YCS42VS0RKDAJR	2025-10-13 14:37:43.189+02	2025-10-13 14:37:43.189+02	\N	iitem_01K7ES77K1859APVJJ6JHR2P8B	sloc_01K7ES77FK2N5KVD364ABE0NCQ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K7ES77MNBQKHC3R7YKDCX38F	2025-10-13 14:37:43.189+02	2025-10-13 14:37:43.189+02	\N	iitem_01K7ES77K1FRZZAQ9043HFC03N	sloc_01K7ES77FK2N5KVD364ABE0NCQ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K7ES77MNC8KS6FSW8H4GQ25F	2025-10-13 14:37:43.189+02	2025-10-13 14:37:43.189+02	\N	iitem_01K7ES77K1J5FT420N1AHKGXXQ	sloc_01K7ES77FK2N5KVD364ABE0NCQ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K7ES77MN17WT8TAVEW3W0XB5	2025-10-13 14:37:43.189+02	2025-10-13 14:37:43.189+02	\N	iitem_01K7ES77K1K50GHYRHTJVAG047	sloc_01K7ES77FK2N5KVD364ABE0NCQ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K7ES77MNESYVGNX1PDNE6WEZ	2025-10-13 14:37:43.189+02	2025-10-13 14:37:43.189+02	\N	iitem_01K7ES77K1KFZE9KX19BAAQB8G	sloc_01K7ES77FK2N5KVD364ABE0NCQ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K7ES77MNQV57BS5VRFBWJPP4	2025-10-13 14:37:43.189+02	2025-10-13 14:37:43.189+02	\N	iitem_01K7ES77K1RMF8NN09R6Y463Z5	sloc_01K7ES77FK2N5KVD364ABE0NCQ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K7ES77MNKK61XJPW9JXVYVKN	2025-10-13 14:37:43.189+02	2025-10-13 14:37:43.189+02	\N	iitem_01K7ES77K1S1T1488AV1QQWQFQ	sloc_01K7ES77FK2N5KVD364ABE0NCQ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K7ES77MN55GVARENV93HWCAV	2025-10-13 14:37:43.189+02	2025-10-13 14:37:43.189+02	\N	iitem_01K7ES77K1V39FDX4Y1F177A5V	sloc_01K7ES77FK2N5KVD364ABE0NCQ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K7ES77MNBQ92Q7D9HTR4MCNM	2025-10-13 14:37:43.189+02	2025-10-13 14:37:43.189+02	\N	iitem_01K7ES77K1VJ372XVY3DF9RZ90	sloc_01K7ES77FK2N5KVD364ABE0NCQ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K7ES77MN34GSDBC3WK4S25ES	2025-10-13 14:37:43.189+02	2025-10-13 14:37:43.189+02	\N	iitem_01K7ES77K1XMT7D93SEKGNFAH2	sloc_01K7ES77FK2N5KVD364ABE0NCQ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K7ES77MNBB83GH75K6V5T2SV	2025-10-13 14:37:43.189+02	2025-10-13 14:37:43.189+02	\N	iitem_01K7ES77K1XPS8AJ0335JKTQRG	sloc_01K7ES77FK2N5KVD364ABE0NCQ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K7ES77MNDECPQXYERG96HKE5	2025-10-13 14:37:43.189+02	2025-10-13 14:37:43.189+02	\N	iitem_01K7ES77K1Y4R6W6XG42QVJMH1	sloc_01K7ES77FK2N5KVD364ABE0NCQ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K7ES77MN8W6FJXXGA6W1C7SS	2025-10-13 14:37:43.189+02	2025-10-13 14:37:43.189+02	\N	iitem_01K7ES77K1Z624EBREA5NEAV17	sloc_01K7ES77FK2N5KVD364ABE0NCQ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
\.


--
-- Data for Name: invite; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.invite (id, email, accepted, token, expires_at, metadata, created_at, updated_at, deleted_at) FROM stdin;
invite_01K7ES767JJNERGNJ9C1E8P9H8	admin@medusa-test.com	f	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Imludml0ZV8wMUs3RVM3NjdKSk5FUkdOSjlDMUU4UDlIOCIsImVtYWlsIjoiYWRtaW5AbWVkdXNhLXRlc3QuY29tIiwiaWF0IjoxNzYwMzU5MDYxLCJleHAiOjE3NjA0NDU0NjEsImp0aSI6IjAzNGM2ZjAyLWIxZDEtNDBjMi05M2Q1LWU4NjVlMmFkZmE1MCJ9.-Ei4-NuJDV60D2XSPVVW3LRCNo-eKiXsg3ns7iqWzzg	2025-10-14 14:37:41.746+02	\N	2025-10-13 14:37:41.747+02	2025-10-13 14:38:32.742+02	2025-10-13 14:38:32.742+02
\.


--
-- Data for Name: link_module_migrations; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.link_module_migrations (id, table_name, link_descriptor, created_at) FROM stdin;
1	cart_promotion	{"toModel": "promotions", "toModule": "promotion", "fromModel": "cart", "fromModule": "cart"}	2025-10-13 14:37:39.633043
2	location_fulfillment_provider	{"toModel": "fulfillment_provider", "toModule": "fulfillment", "fromModel": "location", "fromModule": "stock_location"}	2025-10-13 14:37:39.633102
3	location_fulfillment_set	{"toModel": "fulfillment_set", "toModule": "fulfillment", "fromModel": "location", "fromModule": "stock_location"}	2025-10-13 14:37:39.633348
4	order_cart	{"toModel": "cart", "toModule": "cart", "fromModel": "order", "fromModule": "order"}	2025-10-13 14:37:39.633821
5	order_fulfillment	{"toModel": "fulfillments", "toModule": "fulfillment", "fromModel": "order", "fromModule": "order"}	2025-10-13 14:37:39.633982
6	order_payment_collection	{"toModel": "payment_collection", "toModule": "payment", "fromModel": "order", "fromModule": "order"}	2025-10-13 14:37:39.635939
7	order_promotion	{"toModel": "promotions", "toModule": "promotion", "fromModel": "order", "fromModule": "order"}	2025-10-13 14:37:39.636036
8	return_fulfillment	{"toModel": "fulfillments", "toModule": "fulfillment", "fromModel": "return", "fromModule": "order"}	2025-10-13 14:37:39.637515
9	product_sales_channel	{"toModel": "sales_channel", "toModule": "sales_channel", "fromModel": "product", "fromModule": "product"}	2025-10-13 14:37:39.638188
10	product_variant_inventory_item	{"toModel": "inventory", "toModule": "inventory", "fromModel": "variant", "fromModule": "product"}	2025-10-13 14:37:39.638632
11	publishable_api_key_sales_channel	{"toModel": "sales_channel", "toModule": "sales_channel", "fromModel": "api_key", "fromModule": "api_key"}	2025-10-13 14:37:39.640638
12	product_variant_price_set	{"toModel": "price_set", "toModule": "pricing", "fromModel": "variant", "fromModule": "product"}	2025-10-13 14:37:39.640382
13	region_payment_provider	{"toModel": "payment_provider", "toModule": "payment", "fromModel": "region", "fromModule": "region"}	2025-10-13 14:37:39.640801
14	sales_channel_stock_location	{"toModel": "location", "toModule": "stock_location", "fromModel": "sales_channel", "fromModule": "sales_channel"}	2025-10-13 14:37:39.64156
15	shipping_option_price_set	{"toModel": "price_set", "toModule": "pricing", "fromModel": "shipping_option", "fromModule": "fulfillment"}	2025-10-13 14:37:39.641964
16	product_shipping_profile	{"toModel": "shipping_profile", "toModule": "fulfillment", "fromModel": "product", "fromModule": "product"}	2025-10-13 14:37:39.642714
17	customer_account_holder	{"toModel": "account_holder", "toModule": "payment", "fromModel": "customer", "fromModule": "customer"}	2025-10-13 14:37:39.644295
18	cart_payment_collection	{"toModel": "payment_collection", "toModule": "payment", "fromModel": "cart", "fromModule": "cart"}	2025-10-13 14:37:39.644632
\.


--
-- Data for Name: location_fulfillment_provider; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.location_fulfillment_provider (stock_location_id, fulfillment_provider_id, id, created_at, updated_at, deleted_at) FROM stdin;
sloc_01K7ES77FK2N5KVD364ABE0NCQ	manual_manual	locfp_01K7ES77FTDF3P3827X7W8CDKS	2025-10-13 14:37:43.034355+02	2025-10-13 14:37:43.034355+02	\N
\.


--
-- Data for Name: location_fulfillment_set; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.location_fulfillment_set (stock_location_id, fulfillment_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
sloc_01K7ES77FK2N5KVD364ABE0NCQ	fuset_01K7ES77FYWAPFFAEYJWJ4GJGF	locfs_01K7ES77G4CCYRWZPEW8B8MHRG	2025-10-13 14:37:43.044039+02	2025-10-13 14:37:43.044039+02	\N
\.


--
-- Data for Name: mikro_orm_migrations; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.mikro_orm_migrations (id, name, executed_at) FROM stdin;
1	Migration20240307161216	2025-10-13 14:37:38.5947+02
2	Migration20241210073813	2025-10-13 14:37:38.5947+02
3	Migration20250106142624	2025-10-13 14:37:38.5947+02
4	Migration20250120110820	2025-10-13 14:37:38.5947+02
5	Migration20240307132720	2025-10-13 14:37:38.635604+02
6	Migration20240719123015	2025-10-13 14:37:38.635604+02
7	Migration20241213063611	2025-10-13 14:37:38.635604+02
8	InitialSetup20240401153642	2025-10-13 14:37:38.669746+02
9	Migration20240601111544	2025-10-13 14:37:38.669746+02
10	Migration202408271511	2025-10-13 14:37:38.669746+02
11	Migration20241122120331	2025-10-13 14:37:38.669746+02
12	Migration20241125090957	2025-10-13 14:37:38.669746+02
13	Migration20250411073236	2025-10-13 14:37:38.669746+02
14	Migration20250516081326	2025-10-13 14:37:38.669746+02
15	Migration20250910154539	2025-10-13 14:37:38.669746+02
16	Migration20250911092221	2025-10-13 14:37:38.669746+02
17	Migration20230929122253	2025-10-13 14:37:38.724351+02
18	Migration20240322094407	2025-10-13 14:37:38.724351+02
19	Migration20240322113359	2025-10-13 14:37:38.724351+02
20	Migration20240322120125	2025-10-13 14:37:38.724351+02
21	Migration20240626133555	2025-10-13 14:37:38.724351+02
22	Migration20240704094505	2025-10-13 14:37:38.724351+02
23	Migration20241127114534	2025-10-13 14:37:38.724351+02
24	Migration20241127223829	2025-10-13 14:37:38.724351+02
25	Migration20241128055359	2025-10-13 14:37:38.724351+02
26	Migration20241212190401	2025-10-13 14:37:38.724351+02
27	Migration20250408145122	2025-10-13 14:37:38.724351+02
28	Migration20250409122219	2025-10-13 14:37:38.724351+02
29	Migration20240227120221	2025-10-13 14:37:38.77149+02
30	Migration20240617102917	2025-10-13 14:37:38.77149+02
31	Migration20240624153824	2025-10-13 14:37:38.77149+02
32	Migration20241211061114	2025-10-13 14:37:38.77149+02
33	Migration20250113094144	2025-10-13 14:37:38.77149+02
34	Migration20250120110700	2025-10-13 14:37:38.77149+02
35	Migration20250226130616	2025-10-13 14:37:38.77149+02
36	Migration20250508081510	2025-10-13 14:37:38.77149+02
37	Migration20250828075407	2025-10-13 14:37:38.77149+02
38	Migration20250916120552	2025-10-13 14:37:38.77149+02
39	Migration20250917143818	2025-10-13 14:37:38.77149+02
40	Migration20240124154000	2025-10-13 14:37:38.813801+02
41	Migration20240524123112	2025-10-13 14:37:38.813801+02
42	Migration20240602110946	2025-10-13 14:37:38.813801+02
43	Migration20241211074630	2025-10-13 14:37:38.813801+02
44	Migration20240115152146	2025-10-13 14:37:38.83403+02
45	Migration20240222170223	2025-10-13 14:37:38.844188+02
46	Migration20240831125857	2025-10-13 14:37:38.844188+02
47	Migration20241106085918	2025-10-13 14:37:38.844188+02
48	Migration20241205095237	2025-10-13 14:37:38.844188+02
49	Migration20241216183049	2025-10-13 14:37:38.844188+02
50	Migration20241218091938	2025-10-13 14:37:38.844188+02
51	Migration20250120115059	2025-10-13 14:37:38.844188+02
52	Migration20250212131240	2025-10-13 14:37:38.844188+02
53	Migration20250326151602	2025-10-13 14:37:38.844188+02
54	Migration20250508081553	2025-10-13 14:37:38.844188+02
55	Migration20240205173216	2025-10-13 14:37:38.89259+02
56	Migration20240624200006	2025-10-13 14:37:38.89259+02
57	Migration20250120110744	2025-10-13 14:37:38.89259+02
58	InitialSetup20240221144943	2025-10-13 14:37:38.929116+02
59	Migration20240604080145	2025-10-13 14:37:38.929116+02
60	Migration20241205122700	2025-10-13 14:37:38.929116+02
61	InitialSetup20240227075933	2025-10-13 14:37:38.948078+02
62	Migration20240621145944	2025-10-13 14:37:38.948078+02
63	Migration20241206083313	2025-10-13 14:37:38.948078+02
64	Migration20240227090331	2025-10-13 14:37:38.968383+02
65	Migration20240710135844	2025-10-13 14:37:38.968383+02
66	Migration20240924114005	2025-10-13 14:37:38.968383+02
67	Migration20241212052837	2025-10-13 14:37:38.968383+02
68	InitialSetup20240228133303	2025-10-13 14:37:39.009087+02
69	Migration20240624082354	2025-10-13 14:37:39.009087+02
70	Migration20240225134525	2025-10-13 14:37:39.029952+02
71	Migration20240806072619	2025-10-13 14:37:39.029952+02
72	Migration20241211151053	2025-10-13 14:37:39.029952+02
73	Migration20250115160517	2025-10-13 14:37:39.029952+02
74	Migration20250120110552	2025-10-13 14:37:39.029952+02
75	Migration20250123122334	2025-10-13 14:37:39.029952+02
76	Migration20250206105639	2025-10-13 14:37:39.029952+02
77	Migration20250207132723	2025-10-13 14:37:39.029952+02
78	Migration20250625084134	2025-10-13 14:37:39.029952+02
79	Migration20240219102530	2025-10-13 14:37:39.083912+02
80	Migration20240604100512	2025-10-13 14:37:39.083912+02
81	Migration20240715102100	2025-10-13 14:37:39.083912+02
82	Migration20240715174100	2025-10-13 14:37:39.083912+02
83	Migration20240716081800	2025-10-13 14:37:39.083912+02
84	Migration20240801085921	2025-10-13 14:37:39.083912+02
85	Migration20240821164505	2025-10-13 14:37:39.083912+02
86	Migration20240821170920	2025-10-13 14:37:39.083912+02
87	Migration20240827133639	2025-10-13 14:37:39.083912+02
88	Migration20240902195921	2025-10-13 14:37:39.083912+02
89	Migration20240913092514	2025-10-13 14:37:39.083912+02
90	Migration20240930122627	2025-10-13 14:37:39.083912+02
91	Migration20241014142943	2025-10-13 14:37:39.083912+02
92	Migration20241106085223	2025-10-13 14:37:39.083912+02
93	Migration20241129124827	2025-10-13 14:37:39.083912+02
94	Migration20241217162224	2025-10-13 14:37:39.083912+02
95	Migration20250326151554	2025-10-13 14:37:39.083912+02
96	Migration20250522181137	2025-10-13 14:37:39.083912+02
97	Migration20250702095353	2025-10-13 14:37:39.083912+02
98	Migration20250704120229	2025-10-13 14:37:39.083912+02
99	Migration20250910130000	2025-10-13 14:37:39.083912+02
100	Migration20250717162007	2025-10-13 14:37:39.200985+02
101	Migration20240205025928	2025-10-13 14:37:39.217087+02
102	Migration20240529080336	2025-10-13 14:37:39.217087+02
103	Migration20241202100304	2025-10-13 14:37:39.217087+02
104	Migration20240214033943	2025-10-13 14:37:39.254472+02
105	Migration20240703095850	2025-10-13 14:37:39.254472+02
106	Migration20241202103352	2025-10-13 14:37:39.254472+02
107	Migration20240311145700_InitialSetupMigration	2025-10-13 14:37:39.278657+02
108	Migration20240821170957	2025-10-13 14:37:39.278657+02
109	Migration20240917161003	2025-10-13 14:37:39.278657+02
110	Migration20241217110416	2025-10-13 14:37:39.278657+02
111	Migration20250113122235	2025-10-13 14:37:39.278657+02
112	Migration20250120115002	2025-10-13 14:37:39.278657+02
113	Migration20250822130931	2025-10-13 14:37:39.278657+02
114	Migration20250825132614	2025-10-13 14:37:39.278657+02
115	Migration20240509083918_InitialSetupMigration	2025-10-13 14:37:39.338702+02
116	Migration20240628075401	2025-10-13 14:37:39.338702+02
117	Migration20240830094712	2025-10-13 14:37:39.338702+02
118	Migration20250120110514	2025-10-13 14:37:39.338702+02
119	Migration20231228143900	2025-10-13 14:37:39.396101+02
120	Migration20241206101446	2025-10-13 14:37:39.396101+02
121	Migration20250128174331	2025-10-13 14:37:39.396101+02
122	Migration20250505092459	2025-10-13 14:37:39.396101+02
123	Migration20250819104213	2025-10-13 14:37:39.396101+02
124	Migration20250819110924	2025-10-13 14:37:39.396101+02
125	Migration20250908080305	2025-10-13 14:37:39.396101+02
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.notification (id, "to", channel, template, data, trigger_type, resource_id, resource_type, receiver_id, original_notification_id, idempotency_key, external_id, provider_id, created_at, updated_at, deleted_at, status) FROM stdin;
\.


--
-- Data for Name: notification_provider; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.notification_provider (id, handle, name, is_enabled, channels, created_at, updated_at, deleted_at) FROM stdin;
local	local	local	t	{feed}	2025-10-13 14:37:40.373+02	2025-10-13 14:37:40.373+02	\N
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public."order" (id, region_id, display_id, customer_id, version, sales_channel_id, status, is_draft_order, email, currency_code, shipping_address_id, billing_address_id, no_notification, metadata, created_at, updated_at, deleted_at, canceled_at) FROM stdin;
\.


--
-- Data for Name: order_address; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.order_address (id, customer_id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_cart; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.order_cart (order_id, cart_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_change; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.order_change (id, order_id, version, description, status, internal_note, created_by, requested_by, requested_at, confirmed_by, confirmed_at, declined_by, declined_reason, metadata, declined_at, canceled_by, canceled_at, created_at, updated_at, change_type, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- Data for Name: order_change_action; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.order_change_action (id, order_id, version, ordering, order_change_id, reference, reference_id, action, details, amount, raw_amount, internal_note, applied, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- Data for Name: order_claim; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.order_claim (id, order_id, return_id, order_version, display_id, type, no_notification, refund_amount, raw_refund_amount, metadata, created_at, updated_at, deleted_at, canceled_at, created_by) FROM stdin;
\.


--
-- Data for Name: order_claim_item; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.order_claim_item (id, claim_id, item_id, is_additional_item, reason, quantity, raw_quantity, note, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_claim_item_image; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.order_claim_item_image (id, claim_item_id, url, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_credit_line; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.order_credit_line (id, order_id, reference, reference_id, amount, raw_amount, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_exchange; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.order_exchange (id, order_id, return_id, order_version, display_id, no_notification, allow_backorder, difference_due, raw_difference_due, metadata, created_at, updated_at, deleted_at, canceled_at, created_by) FROM stdin;
\.


--
-- Data for Name: order_exchange_item; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.order_exchange_item (id, exchange_id, item_id, quantity, raw_quantity, note, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_fulfillment; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.order_fulfillment (order_id, fulfillment_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_item; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.order_item (id, order_id, version, item_id, quantity, raw_quantity, fulfilled_quantity, raw_fulfilled_quantity, shipped_quantity, raw_shipped_quantity, return_requested_quantity, raw_return_requested_quantity, return_received_quantity, raw_return_received_quantity, return_dismissed_quantity, raw_return_dismissed_quantity, written_off_quantity, raw_written_off_quantity, metadata, created_at, updated_at, deleted_at, delivered_quantity, raw_delivered_quantity, unit_price, raw_unit_price, compare_at_unit_price, raw_compare_at_unit_price) FROM stdin;
\.


--
-- Data for Name: order_line_item; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.order_line_item (id, totals_id, title, subtitle, thumbnail, variant_id, product_id, product_title, product_description, product_subtitle, product_type, product_collection, product_handle, variant_sku, variant_barcode, variant_title, variant_option_values, requires_shipping, is_discountable, is_tax_inclusive, compare_at_unit_price, raw_compare_at_unit_price, unit_price, raw_unit_price, metadata, created_at, updated_at, deleted_at, is_custom_price, product_type_id, is_giftcard) FROM stdin;
\.


--
-- Data for Name: order_line_item_adjustment; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.order_line_item_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, created_at, updated_at, item_id, deleted_at, is_tax_inclusive) FROM stdin;
\.


--
-- Data for Name: order_line_item_tax_line; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.order_line_item_tax_line (id, description, tax_rate_id, code, rate, raw_rate, provider_id, created_at, updated_at, item_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_payment_collection; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.order_payment_collection (order_id, payment_collection_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_promotion; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.order_promotion (order_id, promotion_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_shipping; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.order_shipping (id, order_id, version, shipping_method_id, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- Data for Name: order_shipping_method; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.order_shipping_method (id, name, description, amount, raw_amount, is_tax_inclusive, shipping_option_id, data, metadata, created_at, updated_at, deleted_at, is_custom_amount) FROM stdin;
\.


--
-- Data for Name: order_shipping_method_adjustment; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.order_shipping_method_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, created_at, updated_at, shipping_method_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_shipping_method_tax_line; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.order_shipping_method_tax_line (id, description, tax_rate_id, code, rate, raw_rate, provider_id, created_at, updated_at, shipping_method_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_summary; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.order_summary (id, order_id, version, totals, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_transaction; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.order_transaction (id, order_id, version, amount, raw_amount, currency_code, reference, reference_id, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.payment (id, amount, raw_amount, currency_code, provider_id, data, created_at, updated_at, deleted_at, captured_at, canceled_at, payment_collection_id, payment_session_id, metadata) FROM stdin;
\.


--
-- Data for Name: payment_collection; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.payment_collection (id, currency_code, amount, raw_amount, authorized_amount, raw_authorized_amount, captured_amount, raw_captured_amount, refunded_amount, raw_refunded_amount, created_at, updated_at, deleted_at, completed_at, status, metadata) FROM stdin;
\.


--
-- Data for Name: payment_collection_payment_providers; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.payment_collection_payment_providers (payment_collection_id, payment_provider_id) FROM stdin;
\.


--
-- Data for Name: payment_provider; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.payment_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
pp_system_default	t	2025-10-13 14:37:40.37+02	2025-10-13 14:37:40.37+02	\N
\.


--
-- Data for Name: payment_session; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.payment_session (id, currency_code, amount, raw_amount, provider_id, data, context, status, authorized_at, payment_collection_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: price; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.price (id, title, price_set_id, currency_code, raw_amount, rules_count, created_at, updated_at, deleted_at, price_list_id, amount, min_quantity, max_quantity) FROM stdin;
price_01K7ES77GNFAMBFGGPF6RM0FYT	\N	pset_01K7ES77GPD8BPH3SZ57AA0G0Q	usd	{"value": "10", "precision": 20}	0	2025-10-13 14:37:43.062+02	2025-10-13 14:37:43.062+02	\N	\N	10	\N	\N
price_01K7ES77GNK4EYXTVBZYYY9K0Z	\N	pset_01K7ES77GPD8BPH3SZ57AA0G0Q	eur	{"value": "10", "precision": 20}	0	2025-10-13 14:37:43.062+02	2025-10-13 14:37:43.062+02	\N	\N	10	\N	\N
price_01K7ES77GP9Y7HSVKR3VW82HZY	\N	pset_01K7ES77GPD8BPH3SZ57AA0G0Q	eur	{"value": "10", "precision": 20}	1	2025-10-13 14:37:43.062+02	2025-10-13 14:37:43.062+02	\N	\N	10	\N	\N
price_01K7ES77GPDMVPJAQM8Z52TX9X	\N	pset_01K7ES77GPSWY3RR0QJB3D7ZZQ	usd	{"value": "10", "precision": 20}	0	2025-10-13 14:37:43.062+02	2025-10-13 14:37:43.062+02	\N	\N	10	\N	\N
price_01K7ES77GPW068H5XRDBYVSKRS	\N	pset_01K7ES77GPSWY3RR0QJB3D7ZZQ	eur	{"value": "10", "precision": 20}	0	2025-10-13 14:37:43.062+02	2025-10-13 14:37:43.062+02	\N	\N	10	\N	\N
price_01K7ES77GPQS3PHN3JZVGG1W7A	\N	pset_01K7ES77GPSWY3RR0QJB3D7ZZQ	eur	{"value": "10", "precision": 20}	1	2025-10-13 14:37:43.062+02	2025-10-13 14:37:43.062+02	\N	\N	10	\N	\N
price_01K7ES77KF2HE5XYW3AD0AF5G6	\N	pset_01K7ES77KFDPYPRSR8AY4GC7HD	eur	{"value": "10", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	10	\N	\N
price_01K7ES77KFRGJH306V7X2PP8EA	\N	pset_01K7ES77KFDPYPRSR8AY4GC7HD	usd	{"value": "15", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	15	\N	\N
price_01K7ES77KF25NE93NTYW4S7YJV	\N	pset_01K7ES77KFCQNB9VW5SMGXB2MM	eur	{"value": "10", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	10	\N	\N
price_01K7ES77KFA8TPZXT06JF63GE9	\N	pset_01K7ES77KFCQNB9VW5SMGXB2MM	usd	{"value": "15", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	15	\N	\N
price_01K7ES77KFMNZGK30M803GXRCZ	\N	pset_01K7ES77KFJWSAWMCA276102YM	eur	{"value": "10", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	10	\N	\N
price_01K7ES77KF6QEQVGNHSQ4XPWAX	\N	pset_01K7ES77KFJWSAWMCA276102YM	usd	{"value": "15", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	15	\N	\N
price_01K7ES77KFT0K13YG9X1TNWER3	\N	pset_01K7ES77KF518JGXQ008ZEENW7	eur	{"value": "10", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	10	\N	\N
price_01K7ES77KF0AKX2THZ0V1W96PW	\N	pset_01K7ES77KF518JGXQ008ZEENW7	usd	{"value": "15", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	15	\N	\N
price_01K7ES77KF8KYAK0B4BJM0M2N5	\N	pset_01K7ES77KFNJ18R0FW7PMD31BN	eur	{"value": "10", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	10	\N	\N
price_01K7ES77KFJGEFB62Z467FVC9V	\N	pset_01K7ES77KFNJ18R0FW7PMD31BN	usd	{"value": "15", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	15	\N	\N
price_01K7ES77KF2GQK1RY2XZZE03BF	\N	pset_01K7ES77KFZH7BRNG60WV8NC4G	eur	{"value": "10", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	10	\N	\N
price_01K7ES77KF560SZR77JA6CACVR	\N	pset_01K7ES77KFZH7BRNG60WV8NC4G	usd	{"value": "15", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	15	\N	\N
price_01K7ES77KF0F9EP5NRPRQ0F4QR	\N	pset_01K7ES77KFR40KN0XF7YPX3TWV	eur	{"value": "10", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	10	\N	\N
price_01K7ES77KFN4EHGTEJEV9HY0AN	\N	pset_01K7ES77KFR40KN0XF7YPX3TWV	usd	{"value": "15", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	15	\N	\N
price_01K7ES77KFFZEDJQQ1DZ8GTYND	\N	pset_01K7ES77KFX0BFMEKFEHW3YMHV	eur	{"value": "10", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	10	\N	\N
price_01K7ES77KF70JJB95PHTHF2NBB	\N	pset_01K7ES77KFX0BFMEKFEHW3YMHV	usd	{"value": "15", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	15	\N	\N
price_01K7ES77KF5F1PJ9PF9HWJ0PY3	\N	pset_01K7ES77KFPTVK4HY36PQPYJJG	eur	{"value": "10", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	10	\N	\N
price_01K7ES77KFMMYWA6BW08Q4ZYGD	\N	pset_01K7ES77KFPTVK4HY36PQPYJJG	usd	{"value": "15", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	15	\N	\N
price_01K7ES77KF9TFBC1GE58E9RTM2	\N	pset_01K7ES77KGWXCGV0GCQE75VRXE	eur	{"value": "10", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	10	\N	\N
price_01K7ES77KGTEXXC2RS7WK4E38K	\N	pset_01K7ES77KGWXCGV0GCQE75VRXE	usd	{"value": "15", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	15	\N	\N
price_01K7ES77KGA95QQANTHE65BBSW	\N	pset_01K7ES77KGY9WR024T4GECEQW8	eur	{"value": "10", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	10	\N	\N
price_01K7ES77KGWXHQANXW6ASGV8F0	\N	pset_01K7ES77KGY9WR024T4GECEQW8	usd	{"value": "15", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	15	\N	\N
price_01K7ES77KGR2APN47P8KW9PNXC	\N	pset_01K7ES77KG9P2264KKBTGGM70S	eur	{"value": "10", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	10	\N	\N
price_01K7ES77KGSWAXXCZAG9Z0013A	\N	pset_01K7ES77KG9P2264KKBTGGM70S	usd	{"value": "15", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	15	\N	\N
price_01K7ES77KG06SC1CKYHW3HV0YA	\N	pset_01K7ES77KGE45NV06521A9FR1V	eur	{"value": "10", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	10	\N	\N
price_01K7ES77KG2RMWH1XJAR48VQPQ	\N	pset_01K7ES77KGE45NV06521A9FR1V	usd	{"value": "15", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	15	\N	\N
price_01K7ES77KGD3MPA9HTXFGMV51X	\N	pset_01K7ES77KGBQBJ6JCVV6Q249Q8	eur	{"value": "10", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	10	\N	\N
price_01K7ES77KG98BW3RJWDJ2KPYWP	\N	pset_01K7ES77KGBQBJ6JCVV6Q249Q8	usd	{"value": "15", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	15	\N	\N
price_01K7ES77KGHC919BYDVQZ6J7SX	\N	pset_01K7ES77KGZMXND47DSQ4KYKAR	eur	{"value": "10", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	10	\N	\N
price_01K7ES77KG37NCW2FKJENDJRY5	\N	pset_01K7ES77KGZMXND47DSQ4KYKAR	usd	{"value": "15", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	15	\N	\N
price_01K7ES77KGXNWZN5M3C3QYXRAQ	\N	pset_01K7ES77KGRSYWA3NMC8R2H93A	eur	{"value": "10", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	10	\N	\N
price_01K7ES77KG0NTHY1H9NQ21N7RQ	\N	pset_01K7ES77KGRSYWA3NMC8R2H93A	usd	{"value": "15", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	15	\N	\N
price_01K7ES77KGSJWMTVT5VF5HSNST	\N	pset_01K7ES77KG9F9TSHKN1YVWHX09	eur	{"value": "10", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	10	\N	\N
price_01K7ES77KG6WGP9DVSG6ZJ0VBM	\N	pset_01K7ES77KG9F9TSHKN1YVWHX09	usd	{"value": "15", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	15	\N	\N
price_01K7ES77KGPB3WZ10M17XFAV42	\N	pset_01K7ES77KG5J8PXYVBC58F6P26	eur	{"value": "10", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	10	\N	\N
price_01K7ES77KG9J53QWA75HJ8ENEJ	\N	pset_01K7ES77KG5J8PXYVBC58F6P26	usd	{"value": "15", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	15	\N	\N
price_01K7ES77KG60CRD5MWCTA6KWFB	\N	pset_01K7ES77KGB732S4ZRZ559YP0K	eur	{"value": "10", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	10	\N	\N
price_01K7ES77KGZ6W2R3KNFF68V000	\N	pset_01K7ES77KGB732S4ZRZ559YP0K	usd	{"value": "15", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	15	\N	\N
price_01K7ES77KGRCARGNFYYN42S4TN	\N	pset_01K7ES77KG90GNTWPZB8G4QNJW	eur	{"value": "10", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	10	\N	\N
price_01K7ES77KGJ6KW3ATPAPNVXSN1	\N	pset_01K7ES77KG90GNTWPZB8G4QNJW	usd	{"value": "15", "precision": 20}	0	2025-10-13 14:37:43.153+02	2025-10-13 14:37:43.153+02	\N	\N	15	\N	\N
price_01K7KSFTX5S0QM5276YNR6F3YB	\N	pset_01K7KSDA3E7M8BF6SNFA7S28RY	eur	{"value": "1000", "precision": 20}	0	2025-10-15 13:18:37.222+02	2025-10-15 13:18:37.223+02	\N	\N	1000	\N	\N
price_01K7KSFTX5XV0VNN96YGZ1KF2B	\N	pset_01K7KSDA3E7M8BF6SNFA7S28RY	usd	{"value": "1000", "precision": 20}	0	2025-10-15 13:18:37.223+02	2025-10-15 13:18:37.223+02	\N	\N	1000	\N	\N
price_01K7KSFTX59ZYA76HW3VH5PZT0	\N	pset_01K7KSDA3E7M8BF6SNFA7S28RY	eur	{"value": "1000", "precision": 20}	1	2025-10-15 13:18:37.223+02	2025-10-15 13:18:37.223+02	\N	\N	1000	\N	\N
price_01K7KSP4P0S5BWF128W8C2SQE9	\N	pset_01K7KSN28NZTZR6GSMDK6GT4X7	eur	{"value": "2000", "precision": 20}	0	2025-10-15 13:22:03.842+02	2025-10-15 13:22:03.842+02	\N	\N	2000	\N	\N
price_01K7KSP4P0D1CXXNY709D905ET	\N	pset_01K7KSN28NZTZR6GSMDK6GT4X7	usd	{"value": "2000", "precision": 20}	0	2025-10-15 13:22:03.842+02	2025-10-15 13:22:03.842+02	\N	\N	2000	\N	\N
price_01K7KSP4P0DK0E4KZV57P87RY1	\N	pset_01K7KSN28NZTZR6GSMDK6GT4X7	eur	{"value": "2000", "precision": 20}	1	2025-10-15 13:22:03.842+02	2025-10-15 13:22:03.842+02	\N	\N	2000	\N	\N
price_01K7KSQT8JHT19CETHY7ZXH707	\N	pset_01K7KSQ76K5CME6D6XG8D0PTN4	eur	{"value": "2500", "precision": 20}	0	2025-10-15 13:22:58.708+02	2025-10-15 13:22:58.708+02	\N	\N	2500	\N	\N
price_01K7KSQT8JJ46W83NK9T1YJWPJ	\N	pset_01K7KSQ76K5CME6D6XG8D0PTN4	usd	{"value": "2500", "precision": 20}	0	2025-10-15 13:22:58.708+02	2025-10-15 13:22:58.708+02	\N	\N	2500	\N	\N
price_01K7KSQT8JAXWJPYC95WJ7RN37	\N	pset_01K7KSQ76K5CME6D6XG8D0PTN4	eur	{"value": "2500", "precision": 20}	1	2025-10-15 13:22:58.708+02	2025-10-15 13:22:58.708+02	\N	\N	2500	\N	\N
price_01K7PBTFN9WSGX8ZGKHXZ5WR4D	\N	pset_01K7P7DXX7142EF74061J3VYK5	eur	{"value": "2000", "precision": 20}	0	2025-10-16 13:17:29.389+02	2025-10-16 13:17:29.389+02	\N	\N	2000	\N	\N
price_01K7PBTFN980MJSRQN920G2NQP	\N	pset_01K7P7DXX7142EF74061J3VYK5	usd	{"value": "2000", "precision": 20}	0	2025-10-16 13:17:29.389+02	2025-10-16 13:17:29.389+02	\N	\N	2000	\N	\N
price_01K7PBTFN95RFSG4S4SPPK36K0	\N	pset_01K7P7DXX7142EF74061J3VYK5	eur	{"value": "2000", "precision": 20}	1	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFN904JCZ16FW0M0PJ80	\N	pset_01K7P7DXX71DQW19WNYPM301X0	eur	{"value": "2000", "precision": 20}	0	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFN93J6HR825PCMX8NEB	\N	pset_01K7P7DXX71DQW19WNYPM301X0	usd	{"value": "2000", "precision": 20}	0	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFN9PVWANW2HQ1FVD7EM	\N	pset_01K7P7DXX71DQW19WNYPM301X0	eur	{"value": "2000", "precision": 20}	1	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNAGTA4TM4KABKGEJ37	\N	pset_01K7P7DXX71VEXK1JY1F0FHG9A	eur	{"value": "2000", "precision": 20}	0	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNABEZHSVK4D5FT6QV1	\N	pset_01K7P7DXX71VEXK1JY1F0FHG9A	usd	{"value": "2000", "precision": 20}	0	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNADBFX78TGTB2ZE9ST	\N	pset_01K7P7DXX71VEXK1JY1F0FHG9A	eur	{"value": "2000", "precision": 20}	1	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNA1GQHHQZHM9HMA0BE	\N	pset_01K7P7DXX72NPX7NKSG5XG2BR1	eur	{"value": "2000", "precision": 20}	0	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNAGDCJZSYER1TZN2MT	\N	pset_01K7P7DXX72NPX7NKSG5XG2BR1	usd	{"value": "2000", "precision": 20}	0	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNA62WTKSJBA25TGN2F	\N	pset_01K7P7DXX72NPX7NKSG5XG2BR1	eur	{"value": "2000", "precision": 20}	1	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNAZCNS136YT3YX91QR	\N	pset_01K7P7DXX73H9ZT7GA7SX0BWYX	eur	{"value": "2000", "precision": 20}	0	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNA3NJMGJCX8R2EMYXX	\N	pset_01K7P7DXX73H9ZT7GA7SX0BWYX	usd	{"value": "2000", "precision": 20}	0	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNAG0KJSWXF1F9W7QVH	\N	pset_01K7P7DXX73H9ZT7GA7SX0BWYX	eur	{"value": "2000", "precision": 20}	1	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNA58V98118YE1BGJXZ	\N	pset_01K7P7DXX76969HECFMZK5BZZ7	eur	{"value": "2000", "precision": 20}	0	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNACXFV6H6PZJFTWTB6	\N	pset_01K7P7DXX76969HECFMZK5BZZ7	usd	{"value": "2000", "precision": 20}	0	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNAR0ZZNPA36VPTSAE5	\N	pset_01K7P7DXX76969HECFMZK5BZZ7	eur	{"value": "2000", "precision": 20}	1	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNAN7P4R0J6Y9H3QDT2	\N	pset_01K7P7DXX78Q2NS9Z90CZV0XC1	eur	{"value": "2000", "precision": 20}	0	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNA18C177Q3RY8RVADP	\N	pset_01K7P7DXX78Q2NS9Z90CZV0XC1	usd	{"value": "2000", "precision": 20}	0	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNATYFNW3YW2VQ04STC	\N	pset_01K7P7DXX78Q2NS9Z90CZV0XC1	eur	{"value": "2000", "precision": 20}	1	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNAJG6ADY2PJVQJTZM0	\N	pset_01K7P7DXX7CFCK731VRGV651YR	eur	{"value": "2000", "precision": 20}	0	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNA038565WRYVZ6B5EE	\N	pset_01K7P7DXX7CFCK731VRGV651YR	usd	{"value": "2000", "precision": 20}	0	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNAQ0030S9DANB7C48P	\N	pset_01K7P7DXX7CFCK731VRGV651YR	eur	{"value": "2000", "precision": 20}	1	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNAJGW6X9Q1KH6RKSJX	\N	pset_01K7P7DXX7KZ0VGYFXFVP6T144	eur	{"value": "2000", "precision": 20}	0	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNBXZP2SKFYNS47MYQY	\N	pset_01K7P7DXX7KZ0VGYFXFVP6T144	usd	{"value": "2000", "precision": 20}	0	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNBNCKE6V6HFHHD476G	\N	pset_01K7P7DXX7KZ0VGYFXFVP6T144	eur	{"value": "2000", "precision": 20}	1	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNBGTH748M16R7JSCVW	\N	pset_01K7P7DXX7R17HZ4VKM6G7ZG7X	eur	{"value": "2000", "precision": 20}	0	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNBNB8WMST7PBKQ08GK	\N	pset_01K7P7DXX7R17HZ4VKM6G7ZG7X	usd	{"value": "2000", "precision": 20}	0	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNBMYP5F84CACNDM8YP	\N	pset_01K7P7DXX7R17HZ4VKM6G7ZG7X	eur	{"value": "2000", "precision": 20}	1	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNB6KP68DZXESQJAF4G	\N	pset_01K7P7DXX7X4BPTMSZ2V0A980S	eur	{"value": "2000", "precision": 20}	0	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNBQ5AQC4ZYHZRRBVV3	\N	pset_01K7P7DXX7X4BPTMSZ2V0A980S	usd	{"value": "2000", "precision": 20}	0	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNBYH9MPB0BTJA6ZR64	\N	pset_01K7P7DXX7X4BPTMSZ2V0A980S	eur	{"value": "2000", "precision": 20}	1	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNBYCT239CDQFHRNPVT	\N	pset_01K7P7DXX7YTKN3G8SBW861BZT	eur	{"value": "2000", "precision": 20}	0	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNBSA7ZG0YP9P8KN4KV	\N	pset_01K7P7DXX7YTKN3G8SBW861BZT	usd	{"value": "2000", "precision": 20}	0	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
price_01K7PBTFNB5JD4AWF0CBWQXG7W	\N	pset_01K7P7DXX7YTKN3G8SBW861BZT	eur	{"value": "2000", "precision": 20}	1	2025-10-16 13:17:29.39+02	2025-10-16 13:17:29.39+02	\N	\N	2000	\N	\N
\.


--
-- Data for Name: price_list; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.price_list (id, status, starts_at, ends_at, rules_count, title, description, type, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: price_list_rule; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.price_list_rule (id, price_list_id, created_at, updated_at, deleted_at, value, attribute) FROM stdin;
\.


--
-- Data for Name: price_preference; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.price_preference (id, attribute, value, is_tax_inclusive, created_at, updated_at, deleted_at) FROM stdin;
prpref_01K7ES767DN108T90YS724RVRB	currency_code	eur	f	2025-10-13 14:37:41.741+02	2025-10-13 14:37:41.741+02	\N
prpref_01K7ES77ESBSMDPJHKDB70VAYC	currency_code	usd	f	2025-10-13 14:37:43.002+02	2025-10-13 14:37:43.002+02	\N
prpref_01K7ES77F755KSG0AC3Y12Z4S7	region_id	reg_01K7ES77EXHRJ5EH6TDSCEKES8	f	2025-10-13 14:37:43.015+02	2025-10-13 14:37:43.015+02	\N
\.


--
-- Data for Name: price_rule; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.price_rule (id, value, priority, price_id, created_at, updated_at, deleted_at, attribute, operator) FROM stdin;
prule_01K7ES77GP5GHA0TQFF101PVKX	reg_01K7ES77EXHRJ5EH6TDSCEKES8	0	price_01K7ES77GP9Y7HSVKR3VW82HZY	2025-10-13 14:37:43.062+02	2025-10-13 14:37:43.062+02	\N	region_id	eq
prule_01K7ES77GP8Y3P8RVXP7HPH8ZC	reg_01K7ES77EXHRJ5EH6TDSCEKES8	0	price_01K7ES77GPQS3PHN3JZVGG1W7A	2025-10-13 14:37:43.062+02	2025-10-13 14:37:43.062+02	\N	region_id	eq
prule_01K7KSFTX5B9H529CAEZGNV686	reg_01K7ES77EXHRJ5EH6TDSCEKES8	0	price_01K7KSFTX59ZYA76HW3VH5PZT0	2025-10-15 13:18:37.223+02	2025-10-15 13:18:37.223+02	\N	region_id	eq
prule_01K7KSP4P0NPPF4QXB1GSAQC7A	reg_01K7ES77EXHRJ5EH6TDSCEKES8	0	price_01K7KSP4P0DK0E4KZV57P87RY1	2025-10-15 13:22:03.842+02	2025-10-15 13:22:03.842+02	\N	region_id	eq
prule_01K7KSQT8JMB9M1GJZN4P1GAK4	reg_01K7ES77EXHRJ5EH6TDSCEKES8	0	price_01K7KSQT8JAXWJPYC95WJ7RN37	2025-10-15 13:22:58.708+02	2025-10-15 13:22:58.708+02	\N	region_id	eq
prule_01K7PT9D0RKWG9RR54H03VDHCG	reg_01K7ES77EXHRJ5EH6TDSCEKES8	0	price_01K7PBTFN95RFSG4S4SPPK36K0	2025-10-16 17:30:18.28+02	2025-10-16 17:30:18.28+02	\N	region_id	eq
prule_01K7PT9D0S9TDGZA9PA09XQ3TV	reg_01K7ES77EXHRJ5EH6TDSCEKES8	0	price_01K7PBTFN9PVWANW2HQ1FVD7EM	2025-10-16 17:30:18.281+02	2025-10-16 17:30:18.281+02	\N	region_id	eq
prule_01K7PT9D0TVXH5H34J3YMYQ8AV	reg_01K7ES77EXHRJ5EH6TDSCEKES8	0	price_01K7PBTFNADBFX78TGTB2ZE9ST	2025-10-16 17:30:18.281+02	2025-10-16 17:30:18.281+02	\N	region_id	eq
prule_01K7PT9D0TT1XAZRWJV074Q37X	reg_01K7ES77EXHRJ5EH6TDSCEKES8	0	price_01K7PBTFNA62WTKSJBA25TGN2F	2025-10-16 17:30:18.281+02	2025-10-16 17:30:18.281+02	\N	region_id	eq
prule_01K7PT9D0VW4BD4DXRRMA80YM5	reg_01K7ES77EXHRJ5EH6TDSCEKES8	0	price_01K7PBTFNAG0KJSWXF1F9W7QVH	2025-10-16 17:30:18.281+02	2025-10-16 17:30:18.281+02	\N	region_id	eq
prule_01K7PT9D0V432WTEHCHXVB9CQR	reg_01K7ES77EXHRJ5EH6TDSCEKES8	0	price_01K7PBTFNAR0ZZNPA36VPTSAE5	2025-10-16 17:30:18.281+02	2025-10-16 17:30:18.281+02	\N	region_id	eq
prule_01K7PT9D0VV1501NF46FZAVCPS	reg_01K7ES77EXHRJ5EH6TDSCEKES8	0	price_01K7PBTFNATYFNW3YW2VQ04STC	2025-10-16 17:30:18.281+02	2025-10-16 17:30:18.281+02	\N	region_id	eq
prule_01K7PT9D0WJNTDTNBQW0TJ7T4N	reg_01K7ES77EXHRJ5EH6TDSCEKES8	0	price_01K7PBTFNAQ0030S9DANB7C48P	2025-10-16 17:30:18.281+02	2025-10-16 17:30:18.281+02	\N	region_id	eq
prule_01K7PT9D0WPGE5705TRBYFYSSZ	reg_01K7ES77EXHRJ5EH6TDSCEKES8	0	price_01K7PBTFNBNCKE6V6HFHHD476G	2025-10-16 17:30:18.281+02	2025-10-16 17:30:18.281+02	\N	region_id	eq
prule_01K7PT9D0X2DV7N6237NH4ARNA	reg_01K7ES77EXHRJ5EH6TDSCEKES8	0	price_01K7PBTFNBMYP5F84CACNDM8YP	2025-10-16 17:30:18.281+02	2025-10-16 17:30:18.281+02	\N	region_id	eq
prule_01K7PT9D0XDFR2506K55GHZWZB	reg_01K7ES77EXHRJ5EH6TDSCEKES8	0	price_01K7PBTFNBYH9MPB0BTJA6ZR64	2025-10-16 17:30:18.281+02	2025-10-16 17:30:18.281+02	\N	region_id	eq
prule_01K7PT9D0XNP15W6MY6G0J30JJ	reg_01K7ES77EXHRJ5EH6TDSCEKES8	0	price_01K7PBTFNB5JD4AWF0CBWQXG7W	2025-10-16 17:30:18.281+02	2025-10-16 17:30:18.281+02	\N	region_id	eq
\.


--
-- Data for Name: price_set; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.price_set (id, created_at, updated_at, deleted_at) FROM stdin;
pset_01K7ES77GPD8BPH3SZ57AA0G0Q	2025-10-13 14:37:43.062+02	2025-10-13 14:37:43.062+02	\N
pset_01K7ES77GPSWY3RR0QJB3D7ZZQ	2025-10-13 14:37:43.062+02	2025-10-13 14:37:43.062+02	\N
pset_01K7ES77KFDPYPRSR8AY4GC7HD	2025-10-13 14:37:43.152+02	2025-10-13 14:37:43.152+02	\N
pset_01K7ES77KFCQNB9VW5SMGXB2MM	2025-10-13 14:37:43.152+02	2025-10-13 14:37:43.152+02	\N
pset_01K7ES77KFJWSAWMCA276102YM	2025-10-13 14:37:43.152+02	2025-10-13 14:37:43.152+02	\N
pset_01K7ES77KF518JGXQ008ZEENW7	2025-10-13 14:37:43.152+02	2025-10-13 14:37:43.152+02	\N
pset_01K7ES77KFNJ18R0FW7PMD31BN	2025-10-13 14:37:43.152+02	2025-10-13 14:37:43.152+02	\N
pset_01K7ES77KFZH7BRNG60WV8NC4G	2025-10-13 14:37:43.152+02	2025-10-13 14:37:43.152+02	\N
pset_01K7ES77KFR40KN0XF7YPX3TWV	2025-10-13 14:37:43.152+02	2025-10-13 14:37:43.152+02	\N
pset_01K7ES77KFX0BFMEKFEHW3YMHV	2025-10-13 14:37:43.152+02	2025-10-13 14:37:43.152+02	\N
pset_01K7ES77KFPTVK4HY36PQPYJJG	2025-10-13 14:37:43.152+02	2025-10-13 14:37:43.152+02	\N
pset_01K7ES77KGWXCGV0GCQE75VRXE	2025-10-13 14:37:43.152+02	2025-10-13 14:37:43.152+02	\N
pset_01K7ES77KGY9WR024T4GECEQW8	2025-10-13 14:37:43.152+02	2025-10-13 14:37:43.152+02	\N
pset_01K7ES77KG9P2264KKBTGGM70S	2025-10-13 14:37:43.152+02	2025-10-13 14:37:43.152+02	\N
pset_01K7ES77KGE45NV06521A9FR1V	2025-10-13 14:37:43.152+02	2025-10-13 14:37:43.152+02	\N
pset_01K7ES77KGBQBJ6JCVV6Q249Q8	2025-10-13 14:37:43.152+02	2025-10-13 14:37:43.152+02	\N
pset_01K7ES77KGZMXND47DSQ4KYKAR	2025-10-13 14:37:43.152+02	2025-10-13 14:37:43.152+02	\N
pset_01K7ES77KGRSYWA3NMC8R2H93A	2025-10-13 14:37:43.152+02	2025-10-13 14:37:43.152+02	\N
pset_01K7ES77KG9F9TSHKN1YVWHX09	2025-10-13 14:37:43.152+02	2025-10-13 14:37:43.152+02	\N
pset_01K7ES77KG5J8PXYVBC58F6P26	2025-10-13 14:37:43.152+02	2025-10-13 14:37:43.152+02	\N
pset_01K7ES77KGB732S4ZRZ559YP0K	2025-10-13 14:37:43.152+02	2025-10-13 14:37:43.152+02	\N
pset_01K7ES77KG90GNTWPZB8G4QNJW	2025-10-13 14:37:43.152+02	2025-10-13 14:37:43.152+02	\N
pset_01K7J6VP31DT5WC91JMKWV30QV	2025-10-14 22:33:48.129+02	2025-10-15 13:16:13.249+02	2025-10-15 13:16:13.248+02
pset_01K7KSDA3E7M8BF6SNFA7S28RY	2025-10-15 13:17:14.478+02	2025-10-15 13:17:14.478+02	\N
pset_01K7KSN28NZTZR6GSMDK6GT4X7	2025-10-15 13:21:28.597+02	2025-10-15 13:21:28.597+02	\N
pset_01K7KSQ76K5CME6D6XG8D0PTN4	2025-10-15 13:22:39.187+02	2025-10-15 13:22:39.187+02	\N
pset_01K7P7DXX7142EF74061J3VYK5	2025-10-16 12:00:43.687+02	2025-10-16 12:00:43.687+02	\N
pset_01K7P7DXX71VEXK1JY1F0FHG9A	2025-10-16 12:00:43.687+02	2025-10-16 12:00:43.687+02	\N
pset_01K7P7DXX7R17HZ4VKM6G7ZG7X	2025-10-16 12:00:43.687+02	2025-10-16 12:00:43.687+02	\N
pset_01K7P7DXX7X4BPTMSZ2V0A980S	2025-10-16 12:00:43.687+02	2025-10-16 12:00:43.687+02	\N
pset_01K7P7DXX78Q2NS9Z90CZV0XC1	2025-10-16 12:00:43.687+02	2025-10-16 12:00:43.687+02	\N
pset_01K7P7DXX72NPX7NKSG5XG2BR1	2025-10-16 12:00:43.687+02	2025-10-16 12:00:43.687+02	\N
pset_01K7P7DXX76969HECFMZK5BZZ7	2025-10-16 12:00:43.687+02	2025-10-16 12:00:43.687+02	\N
pset_01K7P7DXX7KZ0VGYFXFVP6T144	2025-10-16 12:00:43.687+02	2025-10-16 12:00:43.687+02	\N
pset_01K7P7DXX7YTKN3G8SBW861BZT	2025-10-16 12:00:43.687+02	2025-10-16 12:00:43.687+02	\N
pset_01K7P7DXX71DQW19WNYPM301X0	2025-10-16 12:00:43.687+02	2025-10-16 12:00:43.687+02	\N
pset_01K7P7DXX73H9ZT7GA7SX0BWYX	2025-10-16 12:00:43.687+02	2025-10-16 12:00:43.687+02	\N
pset_01K7P7DXX7CFCK731VRGV651YR	2025-10-16 12:00:43.687+02	2025-10-16 12:00:43.687+02	\N
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.product (id, title, handle, subtitle, description, is_giftcard, status, thumbnail, weight, length, height, width, origin_country, hs_code, mid_code, material, collection_id, type_id, discountable, external_id, created_at, updated_at, deleted_at, metadata) FROM stdin;
prod_01K7ES77HH9P1ZCSCMGX3RHHR3	Medusa T-Shirt	t-shirt	\N	Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-10-13 14:37:43.091+02	2025-10-13 14:37:43.091+02	\N	\N
prod_01K7ES77HH0BV45MM5T369WV9M	Medusa Sweatshirt	sweatshirt	\N	Reimagine the feeling of a classic sweatshirt. With our cotton sweatshirt, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-10-13 14:37:43.091+02	2025-10-13 14:37:43.091+02	\N	\N
prod_01K7ES77HH69PKQSHH4F21KQQ8	Medusa Sweatpants	sweatpants	\N	Reimagine the feeling of classic sweatpants. With our cotton sweatpants, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-10-13 14:37:43.091+02	2025-10-13 14:37:43.091+02	\N	\N
prod_01K7ES77HHSKCAJXB0SS0Q6P3F	Medusa Shorts	shorts	\N	Reimagine the feeling of classic shorts. With our cotton shorts, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-10-13 14:37:43.091+02	2025-10-13 14:37:43.091+02	\N	\N
prod_01K7J6VP19PYN7976P5SEREZXE	Test	test			f	published	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-10-14 22:33:48.076+02	2025-10-15 13:16:13.231+02	2025-10-15 13:16:13.229+02	\N
prod_01K7KSDA268TQ4K31J8VMYHZZG	Camden Retreat	camden-retreat	\N	Boho Chic	f	published	http://localhost:9000/static/1760527034422-camden_retreat.png	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01K7KQVNRC7J576VE2MEBYZZK9	\N	t	\N	2025-10-15 13:17:14.439+02	2025-10-15 13:23:09.441+02	\N	\N
prod_01K7KSN27P21FYJSRXFPXT7ME0	Oslo Drift	oslo-drift		Scandinavian Simplicity	f	published	http://localhost:9000/static/1760527288553-oslo_drift.png	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01K7KQVNRC7J576VE2MEBYZZK9	\N	t	\N	2025-10-15 13:21:28.567+02	2025-10-15 13:23:09.441+02	\N	\N
prod_01K7KSQ75J61K7Z7Q7V16C9K8C	Sutton Royale	sutton-royale		Modern Luxe	f	published	http://localhost:9000/static/1760527359137-sutton_royale.png	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01K7KQVNRC7J576VE2MEBYZZK9	\N	t	\N	2025-10-15 13:22:39.155+02	2025-10-15 13:23:09.442+02	\N	\N
prod_01K7P7DXVF2Y1MMY4NXFW2PQ6A	Paloma Haven	paloma-haven	Modern Luxe	Minimalistic designs, neutral colors, and high-quality textures. Perfect for those who seek comfort with a clean and understated aesthetic. This collection brings the essence of Scandinavian elegance to your living room.	f	published	\N	\N	\N	\N	\N	dk			\N	\N	\N	t	\N	2025-10-16 12:00:43.632+02	2025-10-17 13:08:54.269+02	\N	\N
\.


--
-- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.product_category (id, name, description, handle, mpath, is_active, is_internal, rank, parent_category_id, created_at, updated_at, deleted_at, metadata) FROM stdin;
pcat_01K7ES77HCZX9FBCY8HSNNBRRT	Shirts		shirts	pcat_01K7ES77HCZX9FBCY8HSNNBRRT	t	f	0	\N	2025-10-13 14:37:43.084+02	2025-10-13 14:37:43.084+02	\N	\N
pcat_01K7ES77HC522AZQYBPP1T62CJ	Sweatshirts		sweatshirts	pcat_01K7ES77HC522AZQYBPP1T62CJ	t	f	1	\N	2025-10-13 14:37:43.084+02	2025-10-13 14:37:43.084+02	\N	\N
pcat_01K7ES77HCWT1D845Q049AMPAA	Pants		pants	pcat_01K7ES77HCWT1D845Q049AMPAA	t	f	2	\N	2025-10-13 14:37:43.084+02	2025-10-13 14:37:43.084+02	\N	\N
pcat_01K7ES77HCYQFFSQTW2QQ6J4YJ	Merch		merch	pcat_01K7ES77HCYQFFSQTW2QQ6J4YJ	t	f	3	\N	2025-10-13 14:37:43.084+02	2025-10-13 14:37:43.084+02	\N	\N
\.


--
-- Data for Name: product_category_product; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.product_category_product (product_id, product_category_id) FROM stdin;
prod_01K7ES77HH9P1ZCSCMGX3RHHR3	pcat_01K7ES77HCZX9FBCY8HSNNBRRT
prod_01K7ES77HH0BV45MM5T369WV9M	pcat_01K7ES77HC522AZQYBPP1T62CJ
prod_01K7ES77HH69PKQSHH4F21KQQ8	pcat_01K7ES77HCWT1D845Q049AMPAA
prod_01K7ES77HHSKCAJXB0SS0Q6P3F	pcat_01K7ES77HCYQFFSQTW2QQ6J4YJ
\.


--
-- Data for Name: product_collection; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.product_collection (id, title, handle, metadata, created_at, updated_at, deleted_at) FROM stdin;
pcol_01K7KQVNRC7J576VE2MEBYZZK9	Related products	related-products	\N	2025-10-15 12:50:08.010529+02	2025-10-15 12:50:08.010529+02	\N
\.


--
-- Data for Name: product_option; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.product_option (id, title, product_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
opt_01K7ES77HJ6TSZV8DQ42TDWMXJ	Size	prod_01K7ES77HH9P1ZCSCMGX3RHHR3	\N	2025-10-13 14:37:43.091+02	2025-10-13 14:37:43.091+02	\N
opt_01K7ES77HJEAGQNR9P0DJYFCB7	Color	prod_01K7ES77HH9P1ZCSCMGX3RHHR3	\N	2025-10-13 14:37:43.091+02	2025-10-13 14:37:43.091+02	\N
opt_01K7ES77HJ298SE92BDKGY2T53	Size	prod_01K7ES77HH0BV45MM5T369WV9M	\N	2025-10-13 14:37:43.091+02	2025-10-13 14:37:43.091+02	\N
opt_01K7ES77HKGZCQC2TFF46ZAA39	Size	prod_01K7ES77HH69PKQSHH4F21KQQ8	\N	2025-10-13 14:37:43.092+02	2025-10-13 14:37:43.092+02	\N
opt_01K7ES77HKBYCNBFVB9NW444ND	Size	prod_01K7ES77HHSKCAJXB0SS0Q6P3F	\N	2025-10-13 14:37:43.092+02	2025-10-13 14:37:43.092+02	\N
opt_01K7J6VP1BYPYYPTN3HFZWSFZW	Default option	prod_01K7J6VP19PYN7976P5SEREZXE	\N	2025-10-14 22:33:48.076+02	2025-10-15 13:16:13.243+02	2025-10-15 13:16:13.229+02
opt_01K7KSDA26Q9JAX743DC9A56KR	Default option	prod_01K7KSDA268TQ4K31J8VMYHZZG	\N	2025-10-15 13:17:14.44+02	2025-10-15 13:17:14.44+02	\N
opt_01K7KSN27PRZ5B10VBNP4S3HVF	Default option	prod_01K7KSN27P21FYJSRXFPXT7ME0	\N	2025-10-15 13:21:28.567+02	2025-10-15 13:21:28.567+02	\N
opt_01K7KSQ75KR96YCMR14ZKVEFMK	Default option	prod_01K7KSQ75J61K7Z7Q7V16C9K8C	\N	2025-10-15 13:22:39.155+02	2025-10-15 13:22:39.155+02	\N
opt_01K7P7DXVFXGW8NNS8A2H9QXBN	Color	prod_01K7P7DXVF2Y1MMY4NXFW2PQ6A	\N	2025-10-16 12:00:43.632+02	2025-10-16 12:00:43.632+02	\N
opt_01K7P7DXVGFY3Z57TBAFHK3HP1	Material	prod_01K7P7DXVF2Y1MMY4NXFW2PQ6A	\N	2025-10-16 12:00:43.633+02	2025-10-16 12:00:43.633+02	\N
\.


--
-- Data for Name: product_option_value; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.product_option_value (id, value, option_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
optval_01K7ES77HJYE4F3X27DE051AYC	S	opt_01K7ES77HJ6TSZV8DQ42TDWMXJ	\N	2025-10-13 14:37:43.091+02	2025-10-13 14:37:43.091+02	\N
optval_01K7ES77HJW41BTPV5NX7ESK8D	M	opt_01K7ES77HJ6TSZV8DQ42TDWMXJ	\N	2025-10-13 14:37:43.091+02	2025-10-13 14:37:43.091+02	\N
optval_01K7ES77HJ3H0TJ7S981BDD2KZ	L	opt_01K7ES77HJ6TSZV8DQ42TDWMXJ	\N	2025-10-13 14:37:43.091+02	2025-10-13 14:37:43.091+02	\N
optval_01K7ES77HJZC331V3DV61Z0THT	XL	opt_01K7ES77HJ6TSZV8DQ42TDWMXJ	\N	2025-10-13 14:37:43.091+02	2025-10-13 14:37:43.091+02	\N
optval_01K7ES77HJGQVGZ0KKB1E5Y11X	Black	opt_01K7ES77HJEAGQNR9P0DJYFCB7	\N	2025-10-13 14:37:43.091+02	2025-10-13 14:37:43.091+02	\N
optval_01K7ES77HJ2MCP2R3RQBPTZ79Z	White	opt_01K7ES77HJEAGQNR9P0DJYFCB7	\N	2025-10-13 14:37:43.091+02	2025-10-13 14:37:43.091+02	\N
optval_01K7ES77HJFKZB89K565AE0CPZ	S	opt_01K7ES77HJ298SE92BDKGY2T53	\N	2025-10-13 14:37:43.091+02	2025-10-13 14:37:43.091+02	\N
optval_01K7ES77HJ3N7D522ACC0EYQ5T	M	opt_01K7ES77HJ298SE92BDKGY2T53	\N	2025-10-13 14:37:43.091+02	2025-10-13 14:37:43.091+02	\N
optval_01K7ES77HJSS8S8W2Q4RGTS1F0	L	opt_01K7ES77HJ298SE92BDKGY2T53	\N	2025-10-13 14:37:43.091+02	2025-10-13 14:37:43.091+02	\N
optval_01K7ES77HJREMPP5Y40FMHF0Z5	XL	opt_01K7ES77HJ298SE92BDKGY2T53	\N	2025-10-13 14:37:43.091+02	2025-10-13 14:37:43.091+02	\N
optval_01K7ES77HKR7VRBXKNSKBPG5VR	S	opt_01K7ES77HKGZCQC2TFF46ZAA39	\N	2025-10-13 14:37:43.092+02	2025-10-13 14:37:43.092+02	\N
optval_01K7ES77HKVWD9EQ73645BG67T	M	opt_01K7ES77HKGZCQC2TFF46ZAA39	\N	2025-10-13 14:37:43.092+02	2025-10-13 14:37:43.092+02	\N
optval_01K7ES77HK0SP3R2T2K4P038JH	L	opt_01K7ES77HKGZCQC2TFF46ZAA39	\N	2025-10-13 14:37:43.092+02	2025-10-13 14:37:43.092+02	\N
optval_01K7ES77HKAKFNSH362EDHW9NT	XL	opt_01K7ES77HKGZCQC2TFF46ZAA39	\N	2025-10-13 14:37:43.092+02	2025-10-13 14:37:43.092+02	\N
optval_01K7ES77HKBRVYBK2WSMVHK1XS	S	opt_01K7ES77HKBYCNBFVB9NW444ND	\N	2025-10-13 14:37:43.092+02	2025-10-13 14:37:43.092+02	\N
optval_01K7ES77HKBVMGWXHDX138BPM9	M	opt_01K7ES77HKBYCNBFVB9NW444ND	\N	2025-10-13 14:37:43.092+02	2025-10-13 14:37:43.092+02	\N
optval_01K7ES77HK77SNKSWPJFMPGKN4	L	opt_01K7ES77HKBYCNBFVB9NW444ND	\N	2025-10-13 14:37:43.092+02	2025-10-13 14:37:43.092+02	\N
optval_01K7ES77HKQ9TS6719SGA0Q6PJ	XL	opt_01K7ES77HKBYCNBFVB9NW444ND	\N	2025-10-13 14:37:43.092+02	2025-10-13 14:37:43.092+02	\N
optval_01K7J6VP1B1PHQF48WH54XAV1A	Default option value	opt_01K7J6VP1BYPYYPTN3HFZWSFZW	\N	2025-10-14 22:33:48.076+02	2025-10-15 13:16:13.247+02	2025-10-15 13:16:13.229+02
optval_01K7KSDA26Y6JHYQ96GQWK4254	Default option value	opt_01K7KSDA26Q9JAX743DC9A56KR	\N	2025-10-15 13:17:14.44+02	2025-10-15 13:17:14.44+02	\N
optval_01K7KSN27PF4FAYAH1P2HCMAQK	Default option value	opt_01K7KSN27PRZ5B10VBNP4S3HVF	\N	2025-10-15 13:21:28.567+02	2025-10-15 13:21:28.567+02	\N
optval_01K7KSQ75KFRZ7X2XZ1TG8E80S	Default option value	opt_01K7KSQ75KR96YCMR14ZKVEFMK	\N	2025-10-15 13:22:39.155+02	2025-10-15 13:22:39.155+02	\N
optval_01K7P7DXVFASV6PGM6SZWWEPKF	Medium Gray	opt_01K7P7DXVFXGW8NNS8A2H9QXBN	\N	2025-10-16 12:00:43.633+02	2025-10-16 12:00:43.633+02	\N
optval_01K7P7DXVFG0VRWJP7F260E86S	Light Gray	opt_01K7P7DXVFXGW8NNS8A2H9QXBN	\N	2025-10-16 12:00:43.633+02	2025-10-16 12:00:43.633+02	\N
optval_01K7P7DXVFGVR9Q171F1425BXW	Dark Gray	opt_01K7P7DXVFXGW8NNS8A2H9QXBN	\N	2025-10-16 12:00:43.633+02	2025-10-16 12:00:43.633+02	\N
optval_01K7P7DXVGFNQEN5YEWGZB4MY6	Linen	opt_01K7P7DXVGFY3Z57TBAFHK3HP1	\N	2025-10-16 12:00:43.633+02	2025-10-16 12:00:43.633+02	\N
optval_01K7P7DXVGA9YHVTE1MW9JNZ51	Cotton	opt_01K7P7DXVGFY3Z57TBAFHK3HP1	\N	2025-10-16 12:00:43.633+02	2025-10-16 12:00:43.633+02	\N
optval_01K7P7DXVG7Y3EJT76T8W0SE80	Wool	opt_01K7P7DXVGFY3Z57TBAFHK3HP1	\N	2025-10-16 12:00:43.633+02	2025-10-16 12:00:43.633+02	\N
optval_01K7P7DXVGEPYQ7T6C0R47JFAY	Leather	opt_01K7P7DXVGFY3Z57TBAFHK3HP1	\N	2025-10-16 12:00:43.633+02	2025-10-16 12:00:43.633+02	\N
\.


--
-- Data for Name: product_sales_channel; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.product_sales_channel (product_id, sales_channel_id, id, created_at, updated_at, deleted_at) FROM stdin;
prod_01K7J6VP19PYN7976P5SEREZXE	sc_01K7ES766W9XV4MED4TN61N01E	prodsc_01K7J6VP1YXZYXNBTQTYGJWTVM	2025-10-14 22:33:48.093609+02	2025-10-15 13:16:13.243+02	2025-10-15 13:16:13.243+02
prod_01K7KSDA268TQ4K31J8VMYHZZG	sc_01K7ES766W9XV4MED4TN61N01E	prodsc_01K7KSDA2M54FY3ADSBTTY9SFF	2025-10-15 13:17:14.451826+02	2025-10-15 13:17:14.451826+02	\N
prod_01K7KSN27P21FYJSRXFPXT7ME0	sc_01K7ES766W9XV4MED4TN61N01E	prodsc_01K7KSN27YKTF9Y3J7HG3H2XKQ	2025-10-15 13:21:28.574013+02	2025-10-15 13:21:28.574013+02	\N
prod_01K7KSQ75J61K7Z7Q7V16C9K8C	sc_01K7ES766W9XV4MED4TN61N01E	prodsc_01K7KSQ75SYET460ZN2FTV8NC9	2025-10-15 13:22:39.160948+02	2025-10-15 13:22:39.160948+02	\N
prod_01K7P7DXVF2Y1MMY4NXFW2PQ6A	sc_01K7ES766W9XV4MED4TN61N01E	prodsc_01K7P7DXVZ6SDN2NA83NTMHZGG	2025-10-16 12:00:43.646977+02	2025-10-16 12:00:43.646977+02	\N
prod_01K7ES77HH9P1ZCSCMGX3RHHR3	sc_01K7ES766W9XV4MED4TN61N01E	prodsc_01K7ES77J1XYAM4B63ED475JVQ	2025-10-13 14:37:43.105485+02	2025-10-17 13:27:07.846+02	2025-10-17 13:27:07.844+02
prod_01K7ES77HH0BV45MM5T369WV9M	sc_01K7ES766W9XV4MED4TN61N01E	prodsc_01K7ES77J199Z4YY6928BQ982H	2025-10-13 14:37:43.105485+02	2025-10-17 13:27:07.846+02	2025-10-17 13:27:07.844+02
prod_01K7ES77HH69PKQSHH4F21KQQ8	sc_01K7ES766W9XV4MED4TN61N01E	prodsc_01K7ES77J1H67TE48Z2RR1NKK1	2025-10-13 14:37:43.105485+02	2025-10-17 13:27:07.846+02	2025-10-17 13:27:07.844+02
prod_01K7ES77HHSKCAJXB0SS0Q6P3F	sc_01K7ES766W9XV4MED4TN61N01E	prodsc_01K7ES77J1X78YBFBHEDRJT5XP	2025-10-13 14:37:43.105485+02	2025-10-17 13:27:07.846+02	2025-10-17 13:27:07.844+02
\.


--
-- Data for Name: product_shipping_profile; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.product_shipping_profile (product_id, shipping_profile_id, id, created_at, updated_at, deleted_at) FROM stdin;
prod_01K7ES77HH9P1ZCSCMGX3RHHR3	sp_01K7ES754MEHZFG178X95ZVHY4	prodsp_01K7ES77J7GZD9R0NDA1YXB22W	2025-10-13 14:37:43.11117+02	2025-10-13 14:37:43.11117+02	\N
prod_01K7ES77HH0BV45MM5T369WV9M	sp_01K7ES754MEHZFG178X95ZVHY4	prodsp_01K7ES77J7P57YE3RBSN5E9R7Z	2025-10-13 14:37:43.11117+02	2025-10-13 14:37:43.11117+02	\N
prod_01K7ES77HH69PKQSHH4F21KQQ8	sp_01K7ES754MEHZFG178X95ZVHY4	prodsp_01K7ES77J7GVNKF9ANBNZ4E5M3	2025-10-13 14:37:43.11117+02	2025-10-13 14:37:43.11117+02	\N
prod_01K7ES77HHSKCAJXB0SS0Q6P3F	sp_01K7ES754MEHZFG178X95ZVHY4	prodsp_01K7ES77J745S74TQTSQ4N8H98	2025-10-13 14:37:43.11117+02	2025-10-13 14:37:43.11117+02	\N
\.


--
-- Data for Name: product_tag; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.product_tag (id, value, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: product_tags; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.product_tags (product_id, product_tag_id) FROM stdin;
\.


--
-- Data for Name: product_type; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.product_type (id, value, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: product_variant; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.product_variant (id, title, sku, barcode, ean, upc, allow_backorder, manage_inventory, hs_code, origin_country, mid_code, material, weight, length, height, width, metadata, variant_rank, product_id, created_at, updated_at, deleted_at) FROM stdin;
variant_01K7ES77JJF344J5VWT555Q13M	S / Black	SHIRT-S-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7ES77HH9P1ZCSCMGX3RHHR3	2025-10-13 14:37:43.123+02	2025-10-13 14:37:43.123+02	\N
variant_01K7ES77JJ8QHH1A135C7NF97X	S / White	SHIRT-S-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7ES77HH9P1ZCSCMGX3RHHR3	2025-10-13 14:37:43.123+02	2025-10-13 14:37:43.123+02	\N
variant_01K7ES77JK9N7BTQTHRVTMPWMF	M / Black	SHIRT-M-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7ES77HH9P1ZCSCMGX3RHHR3	2025-10-13 14:37:43.123+02	2025-10-13 14:37:43.123+02	\N
variant_01K7ES77JK7TS6MNE6SFX6RS5F	M / White	SHIRT-M-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7ES77HH9P1ZCSCMGX3RHHR3	2025-10-13 14:37:43.123+02	2025-10-13 14:37:43.123+02	\N
variant_01K7ES77JK9Q6ANSEE0CFN8C7N	L / Black	SHIRT-L-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7ES77HH9P1ZCSCMGX3RHHR3	2025-10-13 14:37:43.123+02	2025-10-13 14:37:43.123+02	\N
variant_01K7ES77JKF9T3VDYV92HE2C8K	L / White	SHIRT-L-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7ES77HH9P1ZCSCMGX3RHHR3	2025-10-13 14:37:43.123+02	2025-10-13 14:37:43.123+02	\N
variant_01K7ES77JKQ5KQQG0BCW11WJQQ	XL / Black	SHIRT-XL-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7ES77HH9P1ZCSCMGX3RHHR3	2025-10-13 14:37:43.124+02	2025-10-13 14:37:43.124+02	\N
variant_01K7ES77JKBYCAXMJWSK4M89F5	XL / White	SHIRT-XL-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7ES77HH9P1ZCSCMGX3RHHR3	2025-10-13 14:37:43.124+02	2025-10-13 14:37:43.124+02	\N
variant_01K7ES77JKX02P95QBWB8EDDEW	S	SWEATSHIRT-S	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7ES77HH0BV45MM5T369WV9M	2025-10-13 14:37:43.124+02	2025-10-13 14:37:43.124+02	\N
variant_01K7ES77JKRQVEMB1DD6STBA88	M	SWEATSHIRT-M	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7ES77HH0BV45MM5T369WV9M	2025-10-13 14:37:43.124+02	2025-10-13 14:37:43.124+02	\N
variant_01K7ES77JKYM1ZDY1F03KPXRRZ	L	SWEATSHIRT-L	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7ES77HH0BV45MM5T369WV9M	2025-10-13 14:37:43.124+02	2025-10-13 14:37:43.124+02	\N
variant_01K7ES77JK182FB2CV0BS810NG	XL	SWEATSHIRT-XL	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7ES77HH0BV45MM5T369WV9M	2025-10-13 14:37:43.124+02	2025-10-13 14:37:43.124+02	\N
variant_01K7ES77JKHTYDN3X3Z4VFSCB5	S	SWEATPANTS-S	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7ES77HH69PKQSHH4F21KQQ8	2025-10-13 14:37:43.124+02	2025-10-13 14:37:43.124+02	\N
variant_01K7ES77JKXCCX6SRNC980A5MV	M	SWEATPANTS-M	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7ES77HH69PKQSHH4F21KQQ8	2025-10-13 14:37:43.124+02	2025-10-13 14:37:43.124+02	\N
variant_01K7ES77JKNRR1BDP68VRZSTG3	L	SWEATPANTS-L	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7ES77HH69PKQSHH4F21KQQ8	2025-10-13 14:37:43.124+02	2025-10-13 14:37:43.124+02	\N
variant_01K7ES77JK7J4HH2FDC9T4JR3J	XL	SWEATPANTS-XL	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7ES77HH69PKQSHH4F21KQQ8	2025-10-13 14:37:43.124+02	2025-10-13 14:37:43.124+02	\N
variant_01K7ES77JKEYR0BG1V82C5XNXE	S	SHORTS-S	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7ES77HHSKCAJXB0SS0Q6P3F	2025-10-13 14:37:43.124+02	2025-10-13 14:37:43.124+02	\N
variant_01K7ES77JK41X3DZNYDTSKR0Q1	M	SHORTS-M	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7ES77HHSKCAJXB0SS0Q6P3F	2025-10-13 14:37:43.124+02	2025-10-13 14:37:43.124+02	\N
variant_01K7ES77JKW02KFTSWSWXSV7TF	L	SHORTS-L	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7ES77HHSKCAJXB0SS0Q6P3F	2025-10-13 14:37:43.124+02	2025-10-13 14:37:43.124+02	\N
variant_01K7ES77JKNZT9DFXYQC6TZ2WN	XL	SHORTS-XL	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7ES77HHSKCAJXB0SS0Q6P3F	2025-10-13 14:37:43.124+02	2025-10-13 14:37:43.124+02	\N
variant_01K7J6VP2MJC5SJ8JN73SPZ7P3	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7J6VP19PYN7976P5SEREZXE	2025-10-14 22:33:48.116+02	2025-10-15 13:16:13.243+02	2025-10-15 13:16:13.229+02
variant_01K7KSDA3164S9T3ZPN5MVY4EC	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7KSDA268TQ4K31J8VMYHZZG	2025-10-15 13:17:14.465+02	2025-10-15 13:17:14.465+02	\N
variant_01K7KSN28BCMH4J6TENXYRQDGB	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7KSN27P21FYJSRXFPXT7ME0	2025-10-15 13:21:28.587+02	2025-10-15 13:21:28.587+02	\N
variant_01K7KSQ762J59AFX4EMKVVYJ0M	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7KSQ75J61K7Z7Q7V16C9K8C	2025-10-15 13:22:39.17+02	2025-10-15 13:22:39.17+02	\N
variant_01K7P7DXWFVR54E2PDS4QPZ0VN	Medium Gray / Linen	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K7P7DXVF2Y1MMY4NXFW2PQ6A	2025-10-16 12:00:43.665+02	2025-10-16 12:00:43.665+02	\N
variant_01K7P7DXWF8K3XMWE9SKD72ZC7	Light Gray / Linen	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	prod_01K7P7DXVF2Y1MMY4NXFW2PQ6A	2025-10-16 12:00:43.665+02	2025-10-16 12:00:43.665+02	\N
variant_01K7P7DXWF6399AFHKWVF27SX3	Dark Gray / Linen	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	prod_01K7P7DXVF2Y1MMY4NXFW2PQ6A	2025-10-16 12:00:43.665+02	2025-10-16 12:00:43.665+02	\N
variant_01K7P7DXWF9ME054SHK6449C81	Medium Gray / Cotton	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	3	prod_01K7P7DXVF2Y1MMY4NXFW2PQ6A	2025-10-16 12:00:43.665+02	2025-10-16 12:00:43.665+02	\N
variant_01K7P7DXWGBWJ8RSTEK4S0FB2Q	Light Gray / Cotton	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	prod_01K7P7DXVF2Y1MMY4NXFW2PQ6A	2025-10-16 12:00:43.665+02	2025-10-16 12:00:43.665+02	\N
variant_01K7P7DXWGBEZPC7C0RS6F27ZA	Dark Gray / Cotton	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	prod_01K7P7DXVF2Y1MMY4NXFW2PQ6A	2025-10-16 12:00:43.665+02	2025-10-16 12:00:43.665+02	\N
variant_01K7P7DXWGSS1S2A96K1ZGTPBW	Medium Gray / Wool	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	6	prod_01K7P7DXVF2Y1MMY4NXFW2PQ6A	2025-10-16 12:00:43.665+02	2025-10-16 12:00:43.665+02	\N
variant_01K7P7DXWG86C7WWEZD0J10DM8	Light Gray / Wool	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	prod_01K7P7DXVF2Y1MMY4NXFW2PQ6A	2025-10-16 12:00:43.665+02	2025-10-16 12:00:43.665+02	\N
variant_01K7P7DXWG99RNWY1GCMEC5WRP	Dark Gray / Wool	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	8	prod_01K7P7DXVF2Y1MMY4NXFW2PQ6A	2025-10-16 12:00:43.665+02	2025-10-16 12:00:43.665+02	\N
variant_01K7P7DXWG0X277ATS249AB4RD	Medium Gray / Leather	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	9	prod_01K7P7DXVF2Y1MMY4NXFW2PQ6A	2025-10-16 12:00:43.665+02	2025-10-16 12:00:43.665+02	\N
variant_01K7P7DXWG953TWX151N9XZT24	Light Gray / Leather	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	10	prod_01K7P7DXVF2Y1MMY4NXFW2PQ6A	2025-10-16 12:00:43.665+02	2025-10-16 12:00:43.665+02	\N
variant_01K7P7DXWGFQK49GR19HPDKWC3	Dark Gray / Leather	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	11	prod_01K7P7DXVF2Y1MMY4NXFW2PQ6A	2025-10-16 12:00:43.665+02	2025-10-16 12:00:43.665+02	\N
\.


--
-- Data for Name: product_variant_inventory_item; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.product_variant_inventory_item (variant_id, inventory_item_id, id, required_quantity, created_at, updated_at, deleted_at) FROM stdin;
variant_01K7ES77JJF344J5VWT555Q13M	iitem_01K7ES77K024VPPY9JCFSAVQYN	pvitem_01K7ES77K97DP57AP3HCFJE7NN	1	2025-10-13 14:37:43.145303+02	2025-10-13 14:37:43.145303+02	\N
variant_01K7ES77JJ8QHH1A135C7NF97X	iitem_01K7ES77K01CVQPDH49MZJ7Y41	pvitem_01K7ES77K9V8PAPGCB9QEDAWF3	1	2025-10-13 14:37:43.145303+02	2025-10-13 14:37:43.145303+02	\N
variant_01K7ES77JK9N7BTQTHRVTMPWMF	iitem_01K7ES77K0W0MVPKTHV694Z6DR	pvitem_01K7ES77K97QTNJ07XZ7F5RZWN	1	2025-10-13 14:37:43.145303+02	2025-10-13 14:37:43.145303+02	\N
variant_01K7ES77JK7TS6MNE6SFX6RS5F	iitem_01K7ES77K0WCTV1PSXBQHPD9MS	pvitem_01K7ES77K936DD9SZ234R659E8	1	2025-10-13 14:37:43.145303+02	2025-10-13 14:37:43.145303+02	\N
variant_01K7ES77JK9Q6ANSEE0CFN8C7N	iitem_01K7ES77K1Y4R6W6XG42QVJMH1	pvitem_01K7ES77K9RPTNBP95B0T1EBNH	1	2025-10-13 14:37:43.145303+02	2025-10-13 14:37:43.145303+02	\N
variant_01K7ES77JKF9T3VDYV92HE2C8K	iitem_01K7ES77K1K50GHYRHTJVAG047	pvitem_01K7ES77K907P1GJ2DX7989Z38	1	2025-10-13 14:37:43.145303+02	2025-10-13 14:37:43.145303+02	\N
variant_01K7ES77JKQ5KQQG0BCW11WJQQ	iitem_01K7ES77K1S1T1488AV1QQWQFQ	pvitem_01K7ES77K91T42K4B81VFYFWKB	1	2025-10-13 14:37:43.145303+02	2025-10-13 14:37:43.145303+02	\N
variant_01K7ES77JKBYCAXMJWSK4M89F5	iitem_01K7ES77K1XMT7D93SEKGNFAH2	pvitem_01K7ES77K9DQQT41NQWPTJCEA7	1	2025-10-13 14:37:43.145303+02	2025-10-13 14:37:43.145303+02	\N
variant_01K7ES77JKX02P95QBWB8EDDEW	iitem_01K7ES77K13BDQP8EPGKH84N2C	pvitem_01K7ES77K91KX950HG78HRV5T2	1	2025-10-13 14:37:43.145303+02	2025-10-13 14:37:43.145303+02	\N
variant_01K7ES77JKRQVEMB1DD6STBA88	iitem_01K7ES77K1KFZE9KX19BAAQB8G	pvitem_01K7ES77K9EFNZ011GXKA088CW	1	2025-10-13 14:37:43.145303+02	2025-10-13 14:37:43.145303+02	\N
variant_01K7ES77JKYM1ZDY1F03KPXRRZ	iitem_01K7ES77K1FRZZAQ9043HFC03N	pvitem_01K7ES77K9EX6ANJXXC011FAXF	1	2025-10-13 14:37:43.145303+02	2025-10-13 14:37:43.145303+02	\N
variant_01K7ES77JK182FB2CV0BS810NG	iitem_01K7ES77K1859APVJJ6JHR2P8B	pvitem_01K7ES77K9GW1ZJF8ESBTJMY5T	1	2025-10-13 14:37:43.145303+02	2025-10-13 14:37:43.145303+02	\N
variant_01K7ES77JKHTYDN3X3Z4VFSCB5	iitem_01K7ES77K1VJ372XVY3DF9RZ90	pvitem_01K7ES77K9MET77BHA7EWAV7MC	1	2025-10-13 14:37:43.145303+02	2025-10-13 14:37:43.145303+02	\N
variant_01K7ES77JKXCCX6SRNC980A5MV	iitem_01K7ES77K1RMF8NN09R6Y463Z5	pvitem_01K7ES77K9RW9NYN5GSH51YGJV	1	2025-10-13 14:37:43.145303+02	2025-10-13 14:37:43.145303+02	\N
variant_01K7ES77JKNRR1BDP68VRZSTG3	iitem_01K7ES77K1Z624EBREA5NEAV17	pvitem_01K7ES77K9BEJMNTWXZV3W6ZYP	1	2025-10-13 14:37:43.145303+02	2025-10-13 14:37:43.145303+02	\N
variant_01K7ES77JK7J4HH2FDC9T4JR3J	iitem_01K7ES77K1XPS8AJ0335JKTQRG	pvitem_01K7ES77K94GD9H8Y2FA2M8R42	1	2025-10-13 14:37:43.145303+02	2025-10-13 14:37:43.145303+02	\N
variant_01K7ES77JKEYR0BG1V82C5XNXE	iitem_01K7ES77K1V39FDX4Y1F177A5V	pvitem_01K7ES77K97KE289CXPVFZZRQY	1	2025-10-13 14:37:43.145303+02	2025-10-13 14:37:43.145303+02	\N
variant_01K7ES77JK41X3DZNYDTSKR0Q1	iitem_01K7ES77K14Z1AR610VA138G0Y	pvitem_01K7ES77KA1NRGYAR504VBB05B	1	2025-10-13 14:37:43.145303+02	2025-10-13 14:37:43.145303+02	\N
variant_01K7ES77JKW02KFTSWSWXSV7TF	iitem_01K7ES77K1J5FT420N1AHKGXXQ	pvitem_01K7ES77KADSP1QYBV52S6YAV5	1	2025-10-13 14:37:43.145303+02	2025-10-13 14:37:43.145303+02	\N
variant_01K7ES77JKNZT9DFXYQC6TZ2WN	iitem_01K7ES77K16FBY9ZN53D5P8H7R	pvitem_01K7ES77KAF2F058Z3SN1BSCJE	1	2025-10-13 14:37:43.145303+02	2025-10-13 14:37:43.145303+02	\N
\.


--
-- Data for Name: product_variant_option; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.product_variant_option (variant_id, option_value_id) FROM stdin;
variant_01K7ES77JJF344J5VWT555Q13M	optval_01K7ES77HJYE4F3X27DE051AYC
variant_01K7ES77JJF344J5VWT555Q13M	optval_01K7ES77HJGQVGZ0KKB1E5Y11X
variant_01K7ES77JJ8QHH1A135C7NF97X	optval_01K7ES77HJYE4F3X27DE051AYC
variant_01K7ES77JJ8QHH1A135C7NF97X	optval_01K7ES77HJ2MCP2R3RQBPTZ79Z
variant_01K7ES77JK9N7BTQTHRVTMPWMF	optval_01K7ES77HJW41BTPV5NX7ESK8D
variant_01K7ES77JK9N7BTQTHRVTMPWMF	optval_01K7ES77HJGQVGZ0KKB1E5Y11X
variant_01K7ES77JK7TS6MNE6SFX6RS5F	optval_01K7ES77HJW41BTPV5NX7ESK8D
variant_01K7ES77JK7TS6MNE6SFX6RS5F	optval_01K7ES77HJ2MCP2R3RQBPTZ79Z
variant_01K7ES77JK9Q6ANSEE0CFN8C7N	optval_01K7ES77HJ3H0TJ7S981BDD2KZ
variant_01K7ES77JK9Q6ANSEE0CFN8C7N	optval_01K7ES77HJGQVGZ0KKB1E5Y11X
variant_01K7ES77JKF9T3VDYV92HE2C8K	optval_01K7ES77HJ3H0TJ7S981BDD2KZ
variant_01K7ES77JKF9T3VDYV92HE2C8K	optval_01K7ES77HJ2MCP2R3RQBPTZ79Z
variant_01K7ES77JKQ5KQQG0BCW11WJQQ	optval_01K7ES77HJZC331V3DV61Z0THT
variant_01K7ES77JKQ5KQQG0BCW11WJQQ	optval_01K7ES77HJGQVGZ0KKB1E5Y11X
variant_01K7ES77JKBYCAXMJWSK4M89F5	optval_01K7ES77HJZC331V3DV61Z0THT
variant_01K7ES77JKBYCAXMJWSK4M89F5	optval_01K7ES77HJ2MCP2R3RQBPTZ79Z
variant_01K7ES77JKX02P95QBWB8EDDEW	optval_01K7ES77HJFKZB89K565AE0CPZ
variant_01K7ES77JKRQVEMB1DD6STBA88	optval_01K7ES77HJ3N7D522ACC0EYQ5T
variant_01K7ES77JKYM1ZDY1F03KPXRRZ	optval_01K7ES77HJSS8S8W2Q4RGTS1F0
variant_01K7ES77JK182FB2CV0BS810NG	optval_01K7ES77HJREMPP5Y40FMHF0Z5
variant_01K7ES77JKHTYDN3X3Z4VFSCB5	optval_01K7ES77HKR7VRBXKNSKBPG5VR
variant_01K7ES77JKXCCX6SRNC980A5MV	optval_01K7ES77HKVWD9EQ73645BG67T
variant_01K7ES77JKNRR1BDP68VRZSTG3	optval_01K7ES77HK0SP3R2T2K4P038JH
variant_01K7ES77JK7J4HH2FDC9T4JR3J	optval_01K7ES77HKAKFNSH362EDHW9NT
variant_01K7ES77JKEYR0BG1V82C5XNXE	optval_01K7ES77HKBRVYBK2WSMVHK1XS
variant_01K7ES77JK41X3DZNYDTSKR0Q1	optval_01K7ES77HKBVMGWXHDX138BPM9
variant_01K7ES77JKW02KFTSWSWXSV7TF	optval_01K7ES77HK77SNKSWPJFMPGKN4
variant_01K7ES77JKNZT9DFXYQC6TZ2WN	optval_01K7ES77HKQ9TS6719SGA0Q6PJ
variant_01K7J6VP2MJC5SJ8JN73SPZ7P3	optval_01K7J6VP1B1PHQF48WH54XAV1A
variant_01K7KSDA3164S9T3ZPN5MVY4EC	optval_01K7KSDA26Y6JHYQ96GQWK4254
variant_01K7KSN28BCMH4J6TENXYRQDGB	optval_01K7KSN27PF4FAYAH1P2HCMAQK
variant_01K7KSQ762J59AFX4EMKVVYJ0M	optval_01K7KSQ75KFRZ7X2XZ1TG8E80S
variant_01K7P7DXWFVR54E2PDS4QPZ0VN	optval_01K7P7DXVFASV6PGM6SZWWEPKF
variant_01K7P7DXWFVR54E2PDS4QPZ0VN	optval_01K7P7DXVGFNQEN5YEWGZB4MY6
variant_01K7P7DXWF8K3XMWE9SKD72ZC7	optval_01K7P7DXVFG0VRWJP7F260E86S
variant_01K7P7DXWF8K3XMWE9SKD72ZC7	optval_01K7P7DXVGFNQEN5YEWGZB4MY6
variant_01K7P7DXWF6399AFHKWVF27SX3	optval_01K7P7DXVFGVR9Q171F1425BXW
variant_01K7P7DXWF6399AFHKWVF27SX3	optval_01K7P7DXVGFNQEN5YEWGZB4MY6
variant_01K7P7DXWF9ME054SHK6449C81	optval_01K7P7DXVFASV6PGM6SZWWEPKF
variant_01K7P7DXWF9ME054SHK6449C81	optval_01K7P7DXVGA9YHVTE1MW9JNZ51
variant_01K7P7DXWGBWJ8RSTEK4S0FB2Q	optval_01K7P7DXVFG0VRWJP7F260E86S
variant_01K7P7DXWGBWJ8RSTEK4S0FB2Q	optval_01K7P7DXVGA9YHVTE1MW9JNZ51
variant_01K7P7DXWGBEZPC7C0RS6F27ZA	optval_01K7P7DXVFGVR9Q171F1425BXW
variant_01K7P7DXWGBEZPC7C0RS6F27ZA	optval_01K7P7DXVGA9YHVTE1MW9JNZ51
variant_01K7P7DXWGSS1S2A96K1ZGTPBW	optval_01K7P7DXVFASV6PGM6SZWWEPKF
variant_01K7P7DXWGSS1S2A96K1ZGTPBW	optval_01K7P7DXVG7Y3EJT76T8W0SE80
variant_01K7P7DXWG86C7WWEZD0J10DM8	optval_01K7P7DXVFG0VRWJP7F260E86S
variant_01K7P7DXWG86C7WWEZD0J10DM8	optval_01K7P7DXVG7Y3EJT76T8W0SE80
variant_01K7P7DXWG99RNWY1GCMEC5WRP	optval_01K7P7DXVFGVR9Q171F1425BXW
variant_01K7P7DXWG99RNWY1GCMEC5WRP	optval_01K7P7DXVG7Y3EJT76T8W0SE80
variant_01K7P7DXWG0X277ATS249AB4RD	optval_01K7P7DXVFASV6PGM6SZWWEPKF
variant_01K7P7DXWG0X277ATS249AB4RD	optval_01K7P7DXVGEPYQ7T6C0R47JFAY
variant_01K7P7DXWG953TWX151N9XZT24	optval_01K7P7DXVFG0VRWJP7F260E86S
variant_01K7P7DXWG953TWX151N9XZT24	optval_01K7P7DXVGEPYQ7T6C0R47JFAY
variant_01K7P7DXWGFQK49GR19HPDKWC3	optval_01K7P7DXVFGVR9Q171F1425BXW
variant_01K7P7DXWGFQK49GR19HPDKWC3	optval_01K7P7DXVGEPYQ7T6C0R47JFAY
\.


--
-- Data for Name: product_variant_price_set; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.product_variant_price_set (variant_id, price_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
variant_01K7ES77JJF344J5VWT555Q13M	pset_01K7ES77KFDPYPRSR8AY4GC7HD	pvps_01K7ES77M2S9D2QTT37Y5BSKX5	2025-10-13 14:37:43.170286+02	2025-10-13 14:37:43.170286+02	\N
variant_01K7ES77JJ8QHH1A135C7NF97X	pset_01K7ES77KFCQNB9VW5SMGXB2MM	pvps_01K7ES77M2184WQJK504HC8KAW	2025-10-13 14:37:43.170286+02	2025-10-13 14:37:43.170286+02	\N
variant_01K7ES77JK9N7BTQTHRVTMPWMF	pset_01K7ES77KFJWSAWMCA276102YM	pvps_01K7ES77M2JHD6Q2V015E7BZSF	2025-10-13 14:37:43.170286+02	2025-10-13 14:37:43.170286+02	\N
variant_01K7ES77JK7TS6MNE6SFX6RS5F	pset_01K7ES77KF518JGXQ008ZEENW7	pvps_01K7ES77M29Y9Y00ZVAGBF05P2	2025-10-13 14:37:43.170286+02	2025-10-13 14:37:43.170286+02	\N
variant_01K7ES77JK9Q6ANSEE0CFN8C7N	pset_01K7ES77KFNJ18R0FW7PMD31BN	pvps_01K7ES77M2R4YF0RSQ8F6HTKBQ	2025-10-13 14:37:43.170286+02	2025-10-13 14:37:43.170286+02	\N
variant_01K7ES77JKF9T3VDYV92HE2C8K	pset_01K7ES77KFZH7BRNG60WV8NC4G	pvps_01K7ES77M2WVRZ6KHY47CR550W	2025-10-13 14:37:43.170286+02	2025-10-13 14:37:43.170286+02	\N
variant_01K7ES77JKQ5KQQG0BCW11WJQQ	pset_01K7ES77KFR40KN0XF7YPX3TWV	pvps_01K7ES77M2JEXY9A5NXS717Z56	2025-10-13 14:37:43.170286+02	2025-10-13 14:37:43.170286+02	\N
variant_01K7ES77JKBYCAXMJWSK4M89F5	pset_01K7ES77KFX0BFMEKFEHW3YMHV	pvps_01K7ES77M2JXYHMW6VR0Q758GR	2025-10-13 14:37:43.170286+02	2025-10-13 14:37:43.170286+02	\N
variant_01K7ES77JKX02P95QBWB8EDDEW	pset_01K7ES77KFPTVK4HY36PQPYJJG	pvps_01K7ES77M2TKDZJWC75021213R	2025-10-13 14:37:43.170286+02	2025-10-13 14:37:43.170286+02	\N
variant_01K7ES77JKRQVEMB1DD6STBA88	pset_01K7ES77KGWXCGV0GCQE75VRXE	pvps_01K7ES77M2SY19VYZGZ93K37DD	2025-10-13 14:37:43.170286+02	2025-10-13 14:37:43.170286+02	\N
variant_01K7ES77JKYM1ZDY1F03KPXRRZ	pset_01K7ES77KGY9WR024T4GECEQW8	pvps_01K7ES77M27KYVTT6ZXWWBH749	2025-10-13 14:37:43.170286+02	2025-10-13 14:37:43.170286+02	\N
variant_01K7ES77JK182FB2CV0BS810NG	pset_01K7ES77KG9P2264KKBTGGM70S	pvps_01K7ES77M2F70GXJD7JVR9DPPW	2025-10-13 14:37:43.170286+02	2025-10-13 14:37:43.170286+02	\N
variant_01K7ES77JKHTYDN3X3Z4VFSCB5	pset_01K7ES77KGE45NV06521A9FR1V	pvps_01K7ES77M247GCT4XH47YHGS3T	2025-10-13 14:37:43.170286+02	2025-10-13 14:37:43.170286+02	\N
variant_01K7ES77JKXCCX6SRNC980A5MV	pset_01K7ES77KGBQBJ6JCVV6Q249Q8	pvps_01K7ES77M2YCFZED8VT73EF70A	2025-10-13 14:37:43.170286+02	2025-10-13 14:37:43.170286+02	\N
variant_01K7ES77JKNRR1BDP68VRZSTG3	pset_01K7ES77KGZMXND47DSQ4KYKAR	pvps_01K7ES77M2X0VY5VCBZAF8ZKZV	2025-10-13 14:37:43.170286+02	2025-10-13 14:37:43.170286+02	\N
variant_01K7ES77JK7J4HH2FDC9T4JR3J	pset_01K7ES77KGRSYWA3NMC8R2H93A	pvps_01K7ES77M2Q5CAV32AP47V1784	2025-10-13 14:37:43.170286+02	2025-10-13 14:37:43.170286+02	\N
variant_01K7ES77JKEYR0BG1V82C5XNXE	pset_01K7ES77KG9F9TSHKN1YVWHX09	pvps_01K7ES77M2JTDR9DND4DZSBBRT	2025-10-13 14:37:43.170286+02	2025-10-13 14:37:43.170286+02	\N
variant_01K7ES77JK41X3DZNYDTSKR0Q1	pset_01K7ES77KG5J8PXYVBC58F6P26	pvps_01K7ES77M287PDH48STBE8GDWN	2025-10-13 14:37:43.170286+02	2025-10-13 14:37:43.170286+02	\N
variant_01K7ES77JKW02KFTSWSWXSV7TF	pset_01K7ES77KGB732S4ZRZ559YP0K	pvps_01K7ES77M2QGJZ5BWTP0M5ET3W	2025-10-13 14:37:43.170286+02	2025-10-13 14:37:43.170286+02	\N
variant_01K7ES77JKNZT9DFXYQC6TZ2WN	pset_01K7ES77KG90GNTWPZB8G4QNJW	pvps_01K7ES77M3CS6YV304ASTPF36H	2025-10-13 14:37:43.170286+02	2025-10-13 14:37:43.170286+02	\N
variant_01K7J6VP2MJC5SJ8JN73SPZ7P3	pset_01K7J6VP31DT5WC91JMKWV30QV	pvps_01K7J6VP3EFF887ZVAHG7CW6B8	2025-10-14 22:33:48.142452+02	2025-10-15 13:16:13.24+02	2025-10-15 13:16:13.24+02
variant_01K7KSDA3164S9T3ZPN5MVY4EC	pset_01K7KSDA3E7M8BF6SNFA7S28RY	pvps_01K7KSDA3Q4V6YG3EXJX939568	2025-10-15 13:17:14.487635+02	2025-10-15 13:17:14.487635+02	\N
variant_01K7KSN28BCMH4J6TENXYRQDGB	pset_01K7KSN28NZTZR6GSMDK6GT4X7	pvps_01K7KSN28T94PXASBD2D8K37GQ	2025-10-15 13:21:28.602088+02	2025-10-15 13:21:28.602088+02	\N
variant_01K7KSQ762J59AFX4EMKVVYJ0M	pset_01K7KSQ76K5CME6D6XG8D0PTN4	pvps_01K7KSQ76S2K2JVMPB6YHE78VS	2025-10-15 13:22:39.193158+02	2025-10-15 13:22:39.193158+02	\N
variant_01K7P7DXWFVR54E2PDS4QPZ0VN	pset_01K7P7DXX7142EF74061J3VYK5	pvps_01K7P7DXXQSNXA1B6ZQQRNTDFS	2025-10-16 12:00:43.703231+02	2025-10-16 12:00:43.703231+02	\N
variant_01K7P7DXWF8K3XMWE9SKD72ZC7	pset_01K7P7DXX71VEXK1JY1F0FHG9A	pvps_01K7P7DXXQ78BFV0C3XD5BE6PN	2025-10-16 12:00:43.703231+02	2025-10-16 12:00:43.703231+02	\N
variant_01K7P7DXWF6399AFHKWVF27SX3	pset_01K7P7DXX7R17HZ4VKM6G7ZG7X	pvps_01K7P7DXXQDS30TDB9V2EQW8G5	2025-10-16 12:00:43.703231+02	2025-10-16 12:00:43.703231+02	\N
variant_01K7P7DXWF9ME054SHK6449C81	pset_01K7P7DXX7X4BPTMSZ2V0A980S	pvps_01K7P7DXXQY9MM1RDC7ZPJRYT1	2025-10-16 12:00:43.703231+02	2025-10-16 12:00:43.703231+02	\N
variant_01K7P7DXWGBWJ8RSTEK4S0FB2Q	pset_01K7P7DXX78Q2NS9Z90CZV0XC1	pvps_01K7P7DXXQ63JB7CXP9K79M847	2025-10-16 12:00:43.703231+02	2025-10-16 12:00:43.703231+02	\N
variant_01K7P7DXWGBEZPC7C0RS6F27ZA	pset_01K7P7DXX72NPX7NKSG5XG2BR1	pvps_01K7P7DXXQTF8XAFJ2NRDYD3KW	2025-10-16 12:00:43.703231+02	2025-10-16 12:00:43.703231+02	\N
variant_01K7P7DXWGSS1S2A96K1ZGTPBW	pset_01K7P7DXX76969HECFMZK5BZZ7	pvps_01K7P7DXXQC1DNXVSMK1SSJ8GW	2025-10-16 12:00:43.703231+02	2025-10-16 12:00:43.703231+02	\N
variant_01K7P7DXWG86C7WWEZD0J10DM8	pset_01K7P7DXX7KZ0VGYFXFVP6T144	pvps_01K7P7DXXQTA38R16Q633FECXQ	2025-10-16 12:00:43.703231+02	2025-10-16 12:00:43.703231+02	\N
variant_01K7P7DXWG99RNWY1GCMEC5WRP	pset_01K7P7DXX7YTKN3G8SBW861BZT	pvps_01K7P7DXXRD24VB8022SWP4J8E	2025-10-16 12:00:43.703231+02	2025-10-16 12:00:43.703231+02	\N
variant_01K7P7DXWG0X277ATS249AB4RD	pset_01K7P7DXX71DQW19WNYPM301X0	pvps_01K7P7DXXRNFE08VDP0FXRDRKY	2025-10-16 12:00:43.703231+02	2025-10-16 12:00:43.703231+02	\N
variant_01K7P7DXWG953TWX151N9XZT24	pset_01K7P7DXX73H9ZT7GA7SX0BWYX	pvps_01K7P7DXXR3PX6KF1XPFJMPJSY	2025-10-16 12:00:43.703231+02	2025-10-16 12:00:43.703231+02	\N
variant_01K7P7DXWGFQK49GR19HPDKWC3	pset_01K7P7DXX7CFCK731VRGV651YR	pvps_01K7P7DXXRF78Z4A7ZRD5MZR3S	2025-10-16 12:00:43.703231+02	2025-10-16 12:00:43.703231+02	\N
\.


--
-- Data for Name: promotion; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.promotion (id, code, campaign_id, is_automatic, type, created_at, updated_at, deleted_at, status, is_tax_inclusive) FROM stdin;
\.


--
-- Data for Name: promotion_application_method; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.promotion_application_method (id, value, raw_value, max_quantity, apply_to_quantity, buy_rules_min_quantity, type, target_type, allocation, promotion_id, created_at, updated_at, deleted_at, currency_code) FROM stdin;
\.


--
-- Data for Name: promotion_campaign; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.promotion_campaign (id, name, description, campaign_identifier, starts_at, ends_at, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: promotion_campaign_budget; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.promotion_campaign_budget (id, type, campaign_id, "limit", raw_limit, used, raw_used, created_at, updated_at, deleted_at, currency_code) FROM stdin;
\.


--
-- Data for Name: promotion_promotion_rule; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.promotion_promotion_rule (promotion_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: promotion_rule; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.promotion_rule (id, description, attribute, operator, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: promotion_rule_value; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.promotion_rule_value (id, promotion_rule_id, value, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: provider_identity; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.provider_identity (id, entity_id, provider, auth_identity_id, user_metadata, provider_metadata, created_at, updated_at, deleted_at) FROM stdin;
01K7ES8R0D2T63FRR1AMA5FJE6	gabela.dominik@gmail.com	emailpass	authid_01K7ES8R0EKSDTYCTR2ZW1YKGD	\N	{"password": "c2NyeXB0AA8AAAAIAAAAAYOcDyckfBZOSCrshSKQUfOqH5E5SmwUUxw0o0DawALsheNEkIQNPUvpmu6YoA6BdLmsd/2crUbUgYQqHdZeto7rOk9xVysjCDLzLgakb4C3"}	2025-10-13 14:38:32.718+02	2025-10-13 14:38:32.718+02	\N
\.


--
-- Data for Name: publishable_api_key_sales_channel; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.publishable_api_key_sales_channel (publishable_key_id, sales_channel_id, id, created_at, updated_at, deleted_at) FROM stdin;
apk_01K7ES77H4W9T1RSE9N4S9GPVF	sc_01K7ES766W9XV4MED4TN61N01E	pksc_01K7ES77H6FC5RX1YK89J2Y325	2025-10-13 14:37:43.078776+02	2025-10-13 14:37:43.078776+02	\N
\.


--
-- Data for Name: refund; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.refund (id, amount, raw_amount, payment_id, created_at, updated_at, deleted_at, created_by, metadata, refund_reason_id, note) FROM stdin;
\.


--
-- Data for Name: refund_reason; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.refund_reason (id, label, description, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.region (id, name, currency_code, metadata, created_at, updated_at, deleted_at, automatic_taxes) FROM stdin;
reg_01K7ES77EXHRJ5EH6TDSCEKES8	Europe	eur	\N	2025-10-13 14:37:43.009+02	2025-10-13 14:37:43.009+02	\N	t
\.


--
-- Data for Name: region_country; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.region_country (iso_2, iso_3, num_code, name, display_name, region_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
af	afg	004	AFGHANISTAN	Afghanistan	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
al	alb	008	ALBANIA	Albania	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
dz	dza	012	ALGERIA	Algeria	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
as	asm	016	AMERICAN SAMOA	American Samoa	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
ad	and	020	ANDORRA	Andorra	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
ao	ago	024	ANGOLA	Angola	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
ai	aia	660	ANGUILLA	Anguilla	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
aq	ata	010	ANTARCTICA	Antarctica	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
ag	atg	028	ANTIGUA AND BARBUDA	Antigua and Barbuda	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
ar	arg	032	ARGENTINA	Argentina	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
am	arm	051	ARMENIA	Armenia	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
aw	abw	533	ARUBA	Aruba	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
au	aus	036	AUSTRALIA	Australia	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
at	aut	040	AUSTRIA	Austria	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
az	aze	031	AZERBAIJAN	Azerbaijan	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
bs	bhs	044	BAHAMAS	Bahamas	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
bh	bhr	048	BAHRAIN	Bahrain	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
bd	bgd	050	BANGLADESH	Bangladesh	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
bb	brb	052	BARBADOS	Barbados	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
by	blr	112	BELARUS	Belarus	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
be	bel	056	BELGIUM	Belgium	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
bz	blz	084	BELIZE	Belize	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
bj	ben	204	BENIN	Benin	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
bm	bmu	060	BERMUDA	Bermuda	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
bt	btn	064	BHUTAN	Bhutan	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
bo	bol	068	BOLIVIA	Bolivia	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
bq	bes	535	BONAIRE, SINT EUSTATIUS AND SABA	Bonaire, Sint Eustatius and Saba	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
ba	bih	070	BOSNIA AND HERZEGOVINA	Bosnia and Herzegovina	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
bw	bwa	072	BOTSWANA	Botswana	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
bv	bvd	074	BOUVET ISLAND	Bouvet Island	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
br	bra	076	BRAZIL	Brazil	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
io	iot	086	BRITISH INDIAN OCEAN TERRITORY	British Indian Ocean Territory	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
bn	brn	096	BRUNEI DARUSSALAM	Brunei Darussalam	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
bg	bgr	100	BULGARIA	Bulgaria	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
bf	bfa	854	BURKINA FASO	Burkina Faso	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
bi	bdi	108	BURUNDI	Burundi	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
kh	khm	116	CAMBODIA	Cambodia	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
cm	cmr	120	CAMEROON	Cameroon	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
ca	can	124	CANADA	Canada	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
cv	cpv	132	CAPE VERDE	Cape Verde	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
ky	cym	136	CAYMAN ISLANDS	Cayman Islands	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
cf	caf	140	CENTRAL AFRICAN REPUBLIC	Central African Republic	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
td	tcd	148	CHAD	Chad	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
cl	chl	152	CHILE	Chile	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
cn	chn	156	CHINA	China	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
cx	cxr	162	CHRISTMAS ISLAND	Christmas Island	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
cc	cck	166	COCOS (KEELING) ISLANDS	Cocos (Keeling) Islands	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
co	col	170	COLOMBIA	Colombia	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
km	com	174	COMOROS	Comoros	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
cg	cog	178	CONGO	Congo	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
cd	cod	180	CONGO, THE DEMOCRATIC REPUBLIC OF THE	Congo, the Democratic Republic of the	\N	\N	2025-10-13 14:37:40.357+02	2025-10-13 14:37:40.357+02	\N
ck	cok	184	COOK ISLANDS	Cook Islands	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
cr	cri	188	COSTA RICA	Costa Rica	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ci	civ	384	COTE D'IVOIRE	Cote D'Ivoire	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
hr	hrv	191	CROATIA	Croatia	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
cu	cub	192	CUBA	Cuba	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
cw	cuw	531	CURAÇAO	Curaçao	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
cy	cyp	196	CYPRUS	Cyprus	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
cz	cze	203	CZECH REPUBLIC	Czech Republic	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
dj	dji	262	DJIBOUTI	Djibouti	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
dm	dma	212	DOMINICA	Dominica	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
do	dom	214	DOMINICAN REPUBLIC	Dominican Republic	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ec	ecu	218	ECUADOR	Ecuador	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
eg	egy	818	EGYPT	Egypt	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
sv	slv	222	EL SALVADOR	El Salvador	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
gq	gnq	226	EQUATORIAL GUINEA	Equatorial Guinea	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
er	eri	232	ERITREA	Eritrea	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ee	est	233	ESTONIA	Estonia	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
et	eth	231	ETHIOPIA	Ethiopia	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
fk	flk	238	FALKLAND ISLANDS (MALVINAS)	Falkland Islands (Malvinas)	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
fo	fro	234	FAROE ISLANDS	Faroe Islands	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
fj	fji	242	FIJI	Fiji	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
fi	fin	246	FINLAND	Finland	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
gf	guf	254	FRENCH GUIANA	French Guiana	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
pf	pyf	258	FRENCH POLYNESIA	French Polynesia	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
tf	atf	260	FRENCH SOUTHERN TERRITORIES	French Southern Territories	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ga	gab	266	GABON	Gabon	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
gm	gmb	270	GAMBIA	Gambia	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ge	geo	268	GEORGIA	Georgia	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
gh	gha	288	GHANA	Ghana	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
gi	gib	292	GIBRALTAR	Gibraltar	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
gr	grc	300	GREECE	Greece	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
gl	grl	304	GREENLAND	Greenland	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
gd	grd	308	GRENADA	Grenada	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
gp	glp	312	GUADELOUPE	Guadeloupe	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
gu	gum	316	GUAM	Guam	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
gt	gtm	320	GUATEMALA	Guatemala	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
gg	ggy	831	GUERNSEY	Guernsey	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
gn	gin	324	GUINEA	Guinea	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
gw	gnb	624	GUINEA-BISSAU	Guinea-Bissau	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
gy	guy	328	GUYANA	Guyana	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ht	hti	332	HAITI	Haiti	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
hm	hmd	334	HEARD ISLAND AND MCDONALD ISLANDS	Heard Island And Mcdonald Islands	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
va	vat	336	HOLY SEE (VATICAN CITY STATE)	Holy See (Vatican City State)	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
hn	hnd	340	HONDURAS	Honduras	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
hk	hkg	344	HONG KONG	Hong Kong	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
hu	hun	348	HUNGARY	Hungary	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
is	isl	352	ICELAND	Iceland	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
in	ind	356	INDIA	India	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
id	idn	360	INDONESIA	Indonesia	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ir	irn	364	IRAN, ISLAMIC REPUBLIC OF	Iran, Islamic Republic of	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
iq	irq	368	IRAQ	Iraq	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ie	irl	372	IRELAND	Ireland	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
im	imn	833	ISLE OF MAN	Isle Of Man	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
il	isr	376	ISRAEL	Israel	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
jm	jam	388	JAMAICA	Jamaica	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
jp	jpn	392	JAPAN	Japan	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
je	jey	832	JERSEY	Jersey	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
jo	jor	400	JORDAN	Jordan	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
kz	kaz	398	KAZAKHSTAN	Kazakhstan	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ke	ken	404	KENYA	Kenya	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ki	kir	296	KIRIBATI	Kiribati	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
kp	prk	408	KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF	Korea, Democratic People's Republic of	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
kr	kor	410	KOREA, REPUBLIC OF	Korea, Republic of	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
xk	xkx	900	KOSOVO	Kosovo	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
kw	kwt	414	KUWAIT	Kuwait	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
kg	kgz	417	KYRGYZSTAN	Kyrgyzstan	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
la	lao	418	LAO PEOPLE'S DEMOCRATIC REPUBLIC	Lao People's Democratic Republic	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
lv	lva	428	LATVIA	Latvia	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
lb	lbn	422	LEBANON	Lebanon	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ls	lso	426	LESOTHO	Lesotho	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
lr	lbr	430	LIBERIA	Liberia	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ly	lby	434	LIBYA	Libya	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
li	lie	438	LIECHTENSTEIN	Liechtenstein	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
lt	ltu	440	LITHUANIA	Lithuania	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
lu	lux	442	LUXEMBOURG	Luxembourg	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
mo	mac	446	MACAO	Macao	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
mg	mdg	450	MADAGASCAR	Madagascar	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
mw	mwi	454	MALAWI	Malawi	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
my	mys	458	MALAYSIA	Malaysia	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
mv	mdv	462	MALDIVES	Maldives	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ml	mli	466	MALI	Mali	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
mt	mlt	470	MALTA	Malta	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
mh	mhl	584	MARSHALL ISLANDS	Marshall Islands	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
mq	mtq	474	MARTINIQUE	Martinique	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
mr	mrt	478	MAURITANIA	Mauritania	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
mu	mus	480	MAURITIUS	Mauritius	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
yt	myt	175	MAYOTTE	Mayotte	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
mx	mex	484	MEXICO	Mexico	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
fm	fsm	583	MICRONESIA, FEDERATED STATES OF	Micronesia, Federated States of	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
md	mda	498	MOLDOVA, REPUBLIC OF	Moldova, Republic of	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
mc	mco	492	MONACO	Monaco	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
mn	mng	496	MONGOLIA	Mongolia	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
me	mne	499	MONTENEGRO	Montenegro	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ms	msr	500	MONTSERRAT	Montserrat	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ma	mar	504	MOROCCO	Morocco	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
mz	moz	508	MOZAMBIQUE	Mozambique	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
mm	mmr	104	MYANMAR	Myanmar	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
na	nam	516	NAMIBIA	Namibia	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
nr	nru	520	NAURU	Nauru	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
np	npl	524	NEPAL	Nepal	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
nl	nld	528	NETHERLANDS	Netherlands	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
nc	ncl	540	NEW CALEDONIA	New Caledonia	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
nz	nzl	554	NEW ZEALAND	New Zealand	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ni	nic	558	NICARAGUA	Nicaragua	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ne	ner	562	NIGER	Niger	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ng	nga	566	NIGERIA	Nigeria	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
nu	niu	570	NIUE	Niue	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
nf	nfk	574	NORFOLK ISLAND	Norfolk Island	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
mk	mkd	807	NORTH MACEDONIA	North Macedonia	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
mp	mnp	580	NORTHERN MARIANA ISLANDS	Northern Mariana Islands	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
no	nor	578	NORWAY	Norway	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
om	omn	512	OMAN	Oman	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
pk	pak	586	PAKISTAN	Pakistan	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
pw	plw	585	PALAU	Palau	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ps	pse	275	PALESTINIAN TERRITORY, OCCUPIED	Palestinian Territory, Occupied	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
pa	pan	591	PANAMA	Panama	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
pg	png	598	PAPUA NEW GUINEA	Papua New Guinea	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
py	pry	600	PARAGUAY	Paraguay	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
pe	per	604	PERU	Peru	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ph	phl	608	PHILIPPINES	Philippines	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
pn	pcn	612	PITCAIRN	Pitcairn	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
pl	pol	616	POLAND	Poland	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
pt	prt	620	PORTUGAL	Portugal	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
pr	pri	630	PUERTO RICO	Puerto Rico	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
qa	qat	634	QATAR	Qatar	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
re	reu	638	REUNION	Reunion	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ro	rom	642	ROMANIA	Romania	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ru	rus	643	RUSSIAN FEDERATION	Russian Federation	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
rw	rwa	646	RWANDA	Rwanda	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
bl	blm	652	SAINT BARTHÉLEMY	Saint Barthélemy	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
sh	shn	654	SAINT HELENA	Saint Helena	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
kn	kna	659	SAINT KITTS AND NEVIS	Saint Kitts and Nevis	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
lc	lca	662	SAINT LUCIA	Saint Lucia	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
mf	maf	663	SAINT MARTIN (FRENCH PART)	Saint Martin (French part)	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
pm	spm	666	SAINT PIERRE AND MIQUELON	Saint Pierre and Miquelon	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
vc	vct	670	SAINT VINCENT AND THE GRENADINES	Saint Vincent and the Grenadines	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ws	wsm	882	SAMOA	Samoa	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
sm	smr	674	SAN MARINO	San Marino	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
st	stp	678	SAO TOME AND PRINCIPE	Sao Tome and Principe	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
sa	sau	682	SAUDI ARABIA	Saudi Arabia	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
sn	sen	686	SENEGAL	Senegal	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
rs	srb	688	SERBIA	Serbia	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
sc	syc	690	SEYCHELLES	Seychelles	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
sl	sle	694	SIERRA LEONE	Sierra Leone	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
sg	sgp	702	SINGAPORE	Singapore	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
sx	sxm	534	SINT MAARTEN	Sint Maarten	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
sk	svk	703	SLOVAKIA	Slovakia	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
si	svn	705	SLOVENIA	Slovenia	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
sb	slb	090	SOLOMON ISLANDS	Solomon Islands	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
so	som	706	SOMALIA	Somalia	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
za	zaf	710	SOUTH AFRICA	South Africa	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
gs	sgs	239	SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS	South Georgia and the South Sandwich Islands	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ss	ssd	728	SOUTH SUDAN	South Sudan	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
lk	lka	144	SRI LANKA	Sri Lanka	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
sd	sdn	729	SUDAN	Sudan	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
sr	sur	740	SURINAME	Suriname	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
sj	sjm	744	SVALBARD AND JAN MAYEN	Svalbard and Jan Mayen	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
sz	swz	748	SWAZILAND	Swaziland	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ch	che	756	SWITZERLAND	Switzerland	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
sy	syr	760	SYRIAN ARAB REPUBLIC	Syrian Arab Republic	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
tw	twn	158	TAIWAN, PROVINCE OF CHINA	Taiwan, Province of China	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
tj	tjk	762	TAJIKISTAN	Tajikistan	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
tz	tza	834	TANZANIA, UNITED REPUBLIC OF	Tanzania, United Republic of	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
th	tha	764	THAILAND	Thailand	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
tl	tls	626	TIMOR LESTE	Timor Leste	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
tg	tgo	768	TOGO	Togo	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
tk	tkl	772	TOKELAU	Tokelau	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
to	ton	776	TONGA	Tonga	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
tt	tto	780	TRINIDAD AND TOBAGO	Trinidad and Tobago	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
tn	tun	788	TUNISIA	Tunisia	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
tr	tur	792	TURKEY	Turkey	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
tm	tkm	795	TURKMENISTAN	Turkmenistan	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
tc	tca	796	TURKS AND CAICOS ISLANDS	Turks and Caicos Islands	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
tv	tuv	798	TUVALU	Tuvalu	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ug	uga	800	UGANDA	Uganda	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ua	ukr	804	UKRAINE	Ukraine	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ae	are	784	UNITED ARAB EMIRATES	United Arab Emirates	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
us	usa	840	UNITED STATES	United States	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
um	umi	581	UNITED STATES MINOR OUTLYING ISLANDS	United States Minor Outlying Islands	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
uy	ury	858	URUGUAY	Uruguay	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
uz	uzb	860	UZBEKISTAN	Uzbekistan	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
vu	vut	548	VANUATU	Vanuatu	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ve	ven	862	VENEZUELA	Venezuela	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
vn	vnm	704	VIET NAM	Viet Nam	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
vg	vgb	092	VIRGIN ISLANDS, BRITISH	Virgin Islands, British	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
vi	vir	850	VIRGIN ISLANDS, U.S.	Virgin Islands, U.S.	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
wf	wlf	876	WALLIS AND FUTUNA	Wallis and Futuna	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
eh	esh	732	WESTERN SAHARA	Western Sahara	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ye	yem	887	YEMEN	Yemen	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
zm	zmb	894	ZAMBIA	Zambia	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
zw	zwe	716	ZIMBABWE	Zimbabwe	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
ax	ala	248	ÅLAND ISLANDS	Åland Islands	\N	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:40.358+02	\N
dk	dnk	208	DENMARK	Denmark	reg_01K7ES77EXHRJ5EH6TDSCEKES8	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:43.009+02	\N
fr	fra	250	FRANCE	France	reg_01K7ES77EXHRJ5EH6TDSCEKES8	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:43.009+02	\N
de	deu	276	GERMANY	Germany	reg_01K7ES77EXHRJ5EH6TDSCEKES8	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:43.009+02	\N
it	ita	380	ITALY	Italy	reg_01K7ES77EXHRJ5EH6TDSCEKES8	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:43.009+02	\N
es	esp	724	SPAIN	Spain	reg_01K7ES77EXHRJ5EH6TDSCEKES8	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:43.009+02	\N
se	swe	752	SWEDEN	Sweden	reg_01K7ES77EXHRJ5EH6TDSCEKES8	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:43.009+02	\N
gb	gbr	826	UNITED KINGDOM	United Kingdom	reg_01K7ES77EXHRJ5EH6TDSCEKES8	\N	2025-10-13 14:37:40.358+02	2025-10-13 14:37:43.009+02	\N
\.


--
-- Data for Name: region_payment_provider; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.region_payment_provider (region_id, payment_provider_id, id, created_at, updated_at, deleted_at) FROM stdin;
reg_01K7ES77EXHRJ5EH6TDSCEKES8	pp_system_default	regpp_01K7ES77F8BQ3CEHX5FBBDSN96	2025-10-13 14:37:43.0161+02	2025-10-13 14:37:43.0161+02	\N
\.


--
-- Data for Name: reservation_item; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.reservation_item (id, created_at, updated_at, deleted_at, line_item_id, location_id, quantity, external_id, description, created_by, metadata, inventory_item_id, allow_backorder, raw_quantity) FROM stdin;
\.


--
-- Data for Name: return; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.return (id, order_id, claim_id, exchange_id, order_version, display_id, status, no_notification, refund_amount, raw_refund_amount, metadata, created_at, updated_at, deleted_at, received_at, canceled_at, location_id, requested_at, created_by) FROM stdin;
\.


--
-- Data for Name: return_fulfillment; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.return_fulfillment (return_id, fulfillment_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: return_item; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.return_item (id, return_id, reason_id, item_id, quantity, raw_quantity, received_quantity, raw_received_quantity, note, metadata, created_at, updated_at, deleted_at, damaged_quantity, raw_damaged_quantity) FROM stdin;
\.


--
-- Data for Name: return_reason; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.return_reason (id, value, label, description, metadata, parent_return_reason_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: sales_channel; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.sales_channel (id, name, description, is_disabled, metadata, created_at, updated_at, deleted_at) FROM stdin;
sc_01K7ES766W9XV4MED4TN61N01E	Default Sales Channel	Created by Medusa	f	\N	2025-10-13 14:37:41.724+02	2025-10-13 14:37:41.724+02	\N
\.


--
-- Data for Name: sales_channel_stock_location; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.sales_channel_stock_location (sales_channel_id, stock_location_id, id, created_at, updated_at, deleted_at) FROM stdin;
sc_01K7ES766W9XV4MED4TN61N01E	sloc_01K7ES77FK2N5KVD364ABE0NCQ	scloc_01K7ES77H2H47KNDYGFXVH9E23	2025-10-13 14:37:43.073954+02	2025-10-13 14:37:43.073954+02	\N
\.


--
-- Data for Name: script_migrations; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.script_migrations (id, script_name, created_at, finished_at) FROM stdin;
1	migrate-product-shipping-profile.js	2025-10-13 14:37:40.618257+02	2025-10-13 14:37:40.631143+02
2	migrate-tax-region-provider.js	2025-10-13 14:37:40.631926+02	2025-10-13 14:37:40.637254+02
\.


--
-- Data for Name: service_zone; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.service_zone (id, name, metadata, fulfillment_set_id, created_at, updated_at, deleted_at) FROM stdin;
serzo_01K7ES77FYQCP03ZN68QG3QG6C	Europe	\N	fuset_01K7ES77FYWAPFFAEYJWJ4GJGF	2025-10-13 14:37:43.038+02	2025-10-13 14:37:43.038+02	\N
\.


--
-- Data for Name: shipping_option; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.shipping_option (id, name, price_type, service_zone_id, shipping_profile_id, provider_id, data, metadata, shipping_option_type_id, created_at, updated_at, deleted_at) FROM stdin;
so_01K7ES77GF7J09EYEYNFFA4PV3	Standard Shipping	flat	serzo_01K7ES77FYQCP03ZN68QG3QG6C	sp_01K7ES754MEHZFG178X95ZVHY4	manual_manual	\N	\N	sotype_01K7ES77GFCB7993SWAQQ67NYE	2025-10-13 14:37:43.056+02	2025-10-13 14:37:43.056+02	\N
so_01K7ES77GGF74AQQ8CMCRXTAQP	Express Shipping	flat	serzo_01K7ES77FYQCP03ZN68QG3QG6C	sp_01K7ES754MEHZFG178X95ZVHY4	manual_manual	\N	\N	sotype_01K7ES77GGCA7BYA82VFAB0MZE	2025-10-13 14:37:43.056+02	2025-10-13 14:37:43.056+02	\N
\.


--
-- Data for Name: shipping_option_price_set; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.shipping_option_price_set (shipping_option_id, price_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
so_01K7ES77GF7J09EYEYNFFA4PV3	pset_01K7ES77GPD8BPH3SZ57AA0G0Q	sops_01K7ES77GZK8KQD3485BC0VVHA	2025-10-13 14:37:43.071802+02	2025-10-13 14:37:43.071802+02	\N
so_01K7ES77GGF74AQQ8CMCRXTAQP	pset_01K7ES77GPSWY3RR0QJB3D7ZZQ	sops_01K7ES77H06Q2J8TKE071RFBPY	2025-10-13 14:37:43.071802+02	2025-10-13 14:37:43.071802+02	\N
\.


--
-- Data for Name: shipping_option_rule; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.shipping_option_rule (id, attribute, operator, value, shipping_option_id, created_at, updated_at, deleted_at) FROM stdin;
sorul_01K7ES77GFT2AE4EPSDJAG2F96	enabled_in_store	eq	"true"	so_01K7ES77GF7J09EYEYNFFA4PV3	2025-10-13 14:37:43.056+02	2025-10-13 14:37:43.056+02	\N
sorul_01K7ES77GFCPQ3C4NMKVFEQ9XW	is_return	eq	"false"	so_01K7ES77GF7J09EYEYNFFA4PV3	2025-10-13 14:37:43.056+02	2025-10-13 14:37:43.056+02	\N
sorul_01K7ES77GG5YEB9HXP40JEDTF1	enabled_in_store	eq	"true"	so_01K7ES77GGF74AQQ8CMCRXTAQP	2025-10-13 14:37:43.056+02	2025-10-13 14:37:43.056+02	\N
sorul_01K7ES77GGQ8S8GV98C6HE4KYE	is_return	eq	"false"	so_01K7ES77GGF74AQQ8CMCRXTAQP	2025-10-13 14:37:43.056+02	2025-10-13 14:37:43.056+02	\N
\.


--
-- Data for Name: shipping_option_type; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.shipping_option_type (id, label, description, code, created_at, updated_at, deleted_at) FROM stdin;
sotype_01K7ES77GFCB7993SWAQQ67NYE	Standard	Ship in 2-3 days.	standard	2025-10-13 14:37:43.056+02	2025-10-13 14:37:43.056+02	\N
sotype_01K7ES77GGCA7BYA82VFAB0MZE	Express	Ship in 24 hours.	express	2025-10-13 14:37:43.056+02	2025-10-13 14:37:43.056+02	\N
\.


--
-- Data for Name: shipping_profile; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.shipping_profile (id, name, type, metadata, created_at, updated_at, deleted_at) FROM stdin;
sp_01K7ES754MEHZFG178X95ZVHY4	Default Shipping Profile	default	\N	2025-10-13 14:37:40.629+02	2025-10-13 14:37:40.629+02	\N
\.


--
-- Data for Name: stock_location; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.stock_location (id, created_at, updated_at, deleted_at, name, address_id, metadata) FROM stdin;
sloc_01K7ES77FK2N5KVD364ABE0NCQ	2025-10-13 14:37:43.028+02	2025-10-13 14:37:43.028+02	\N	European Warehouse	laddr_01K7ES77FKSQ32DNYGK76EMPVK	\N
\.


--
-- Data for Name: stock_location_address; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.stock_location_address (id, created_at, updated_at, deleted_at, address_1, address_2, company, city, country_code, phone, province, postal_code, metadata) FROM stdin;
laddr_01K7ES77FKSQ32DNYGK76EMPVK	2025-10-13 14:37:43.027+02	2025-10-13 14:37:43.027+02	\N		\N	\N	Copenhagen	DK	\N	\N	\N	\N
\.


--
-- Data for Name: store; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.store (id, name, default_sales_channel_id, default_region_id, default_location_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
store_01K7ES767265C9P6Q5KNWMGYQ7	Medusa Store	sc_01K7ES766W9XV4MED4TN61N01E	reg_01K7ES77EXHRJ5EH6TDSCEKES8	sloc_01K7ES77FK2N5KVD364ABE0NCQ	\N	2025-10-13 14:37:41.72954+02	2025-10-13 14:37:41.72954+02	\N
\.


--
-- Data for Name: store_currency; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.store_currency (id, currency_code, is_default, store_id, created_at, updated_at, deleted_at) FROM stdin;
stocur_01K7PAQYHZM9ZABR4SXC782N7K	eur	t	store_01K7ES767265C9P6Q5KNWMGYQ7	2025-10-16 12:58:37.755321+02	2025-10-16 12:58:37.755321+02	\N
stocur_01K7PAQYJ0J45PABP9Y8Z5PBAW	usd	f	store_01K7ES767265C9P6Q5KNWMGYQ7	2025-10-16 12:58:37.755321+02	2025-10-16 12:58:37.755321+02	\N
\.


--
-- Data for Name: tax_provider; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.tax_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
tp_system	t	2025-10-13 14:37:40.371+02	2025-10-13 14:37:40.371+02	\N
\.


--
-- Data for Name: tax_rate; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.tax_rate (id, rate, code, name, is_default, is_combinable, tax_region_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: tax_rate_rule; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.tax_rate_rule (id, tax_rate_id, reference_id, reference, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: tax_region; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.tax_region (id, provider_id, country_code, province_code, parent_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
txreg_01K7ES77FBER7PVF39NDPENH4Z	tp_system	gb	\N	\N	\N	2025-10-13 14:37:43.02+02	2025-10-13 14:37:43.02+02	\N	\N
txreg_01K7ES77FB7ERKFZ5HJZMRGFPC	tp_system	de	\N	\N	\N	2025-10-13 14:37:43.02+02	2025-10-13 14:37:43.02+02	\N	\N
txreg_01K7ES77FBKD5AMVJC3RCE56WK	tp_system	dk	\N	\N	\N	2025-10-13 14:37:43.02+02	2025-10-13 14:37:43.02+02	\N	\N
txreg_01K7ES77FBWVDYNQTEJQ91RYCM	tp_system	se	\N	\N	\N	2025-10-13 14:37:43.02+02	2025-10-13 14:37:43.02+02	\N	\N
txreg_01K7ES77FBTVZ8YDSNX76PCC0Q	tp_system	fr	\N	\N	\N	2025-10-13 14:37:43.02+02	2025-10-13 14:37:43.02+02	\N	\N
txreg_01K7ES77FB1M0PAPT9HJJ4SGWF	tp_system	es	\N	\N	\N	2025-10-13 14:37:43.02+02	2025-10-13 14:37:43.02+02	\N	\N
txreg_01K7ES77FBD2XAG6EA9SPR3SN1	tp_system	it	\N	\N	\N	2025-10-13 14:37:43.02+02	2025-10-13 14:37:43.02+02	\N	\N
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public."user" (id, first_name, last_name, email, avatar_url, metadata, created_at, updated_at, deleted_at) FROM stdin;
user_01K7ES8R10QJV2H779G7ARRSB9	Dominik	Gabela	gabela.dominik@gmail.com	\N	\N	2025-10-13 14:38:32.737+02	2025-10-13 14:38:32.737+02	\N
\.


--
-- Data for Name: user_preference; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.user_preference (id, user_id, key, value, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: view_configuration; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.view_configuration (id, entity, name, user_id, is_system_default, configuration, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: workflow_execution; Type: TABLE DATA; Schema: public; Owner: medusa_admin
--

COPY public.workflow_execution (id, workflow_id, transaction_id, execution, context, state, created_at, updated_at, deleted_at, retention_time, run_id) FROM stdin;
\.


--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: medusa_admin
--

SELECT pg_catalog.setval('public.link_module_migrations_id_seq', 36, true);


--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: medusa_admin
--

SELECT pg_catalog.setval('public.mikro_orm_migrations_id_seq', 125, true);


--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE SET; Schema: public; Owner: medusa_admin
--

SELECT pg_catalog.setval('public.order_change_action_ordering_seq', 1, false);


--
-- Name: order_claim_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: medusa_admin
--

SELECT pg_catalog.setval('public.order_claim_display_id_seq', 1, false);


--
-- Name: order_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: medusa_admin
--

SELECT pg_catalog.setval('public.order_display_id_seq', 1, false);


--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: medusa_admin
--

SELECT pg_catalog.setval('public.order_exchange_display_id_seq', 1, false);


--
-- Name: return_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: medusa_admin
--

SELECT pg_catalog.setval('public.return_display_id_seq', 1, false);


--
-- Name: script_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: medusa_admin
--

SELECT pg_catalog.setval('public.script_migrations_id_seq', 2, true);


--
-- Name: account_holder account_holder_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.account_holder
    ADD CONSTRAINT account_holder_pkey PRIMARY KEY (id);


--
-- Name: api_key api_key_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.api_key
    ADD CONSTRAINT api_key_pkey PRIMARY KEY (id);


--
-- Name: application_method_buy_rules application_method_buy_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id);


--
-- Name: application_method_target_rules application_method_target_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id);


--
-- Name: auth_identity auth_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.auth_identity
    ADD CONSTRAINT auth_identity_pkey PRIMARY KEY (id);


--
-- Name: capture capture_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.capture
    ADD CONSTRAINT capture_pkey PRIMARY KEY (id);


--
-- Name: cart_address cart_address_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.cart_address
    ADD CONSTRAINT cart_address_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item_adjustment cart_line_item_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.cart_line_item_adjustment
    ADD CONSTRAINT cart_line_item_adjustment_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item cart_line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.cart_line_item
    ADD CONSTRAINT cart_line_item_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item_tax_line cart_line_item_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.cart_line_item_tax_line
    ADD CONSTRAINT cart_line_item_tax_line_pkey PRIMARY KEY (id);


--
-- Name: cart_payment_collection cart_payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.cart_payment_collection
    ADD CONSTRAINT cart_payment_collection_pkey PRIMARY KEY (cart_id, payment_collection_id);


--
-- Name: cart cart_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);


--
-- Name: cart_promotion cart_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.cart_promotion
    ADD CONSTRAINT cart_promotion_pkey PRIMARY KEY (cart_id, promotion_id);


--
-- Name: cart_shipping_method_adjustment cart_shipping_method_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.cart_shipping_method_adjustment
    ADD CONSTRAINT cart_shipping_method_adjustment_pkey PRIMARY KEY (id);


--
-- Name: cart_shipping_method cart_shipping_method_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.cart_shipping_method
    ADD CONSTRAINT cart_shipping_method_pkey PRIMARY KEY (id);


--
-- Name: cart_shipping_method_tax_line cart_shipping_method_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.cart_shipping_method_tax_line
    ADD CONSTRAINT cart_shipping_method_tax_line_pkey PRIMARY KEY (id);


--
-- Name: credit_line credit_line_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.credit_line
    ADD CONSTRAINT credit_line_pkey PRIMARY KEY (id);


--
-- Name: currency currency_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (code);


--
-- Name: customer_account_holder customer_account_holder_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.customer_account_holder
    ADD CONSTRAINT customer_account_holder_pkey PRIMARY KEY (customer_id, account_holder_id);


--
-- Name: customer_address customer_address_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_pkey PRIMARY KEY (id);


--
-- Name: customer_group_customer customer_group_customer_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_pkey PRIMARY KEY (id);


--
-- Name: customer_group customer_group_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.customer_group
    ADD CONSTRAINT customer_group_pkey PRIMARY KEY (id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_address fulfillment_address_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.fulfillment_address
    ADD CONSTRAINT fulfillment_address_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_item fulfillment_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.fulfillment_item
    ADD CONSTRAINT fulfillment_item_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_label fulfillment_label_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.fulfillment_label
    ADD CONSTRAINT fulfillment_label_pkey PRIMARY KEY (id);


--
-- Name: fulfillment fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_provider fulfillment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.fulfillment_provider
    ADD CONSTRAINT fulfillment_provider_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_set fulfillment_set_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.fulfillment_set
    ADD CONSTRAINT fulfillment_set_pkey PRIMARY KEY (id);


--
-- Name: geo_zone geo_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.geo_zone
    ADD CONSTRAINT geo_zone_pkey PRIMARY KEY (id);


--
-- Name: image image_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_pkey PRIMARY KEY (id);


--
-- Name: inventory_item inventory_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.inventory_item
    ADD CONSTRAINT inventory_item_pkey PRIMARY KEY (id);


--
-- Name: inventory_level inventory_level_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.inventory_level
    ADD CONSTRAINT inventory_level_pkey PRIMARY KEY (id);


--
-- Name: invite invite_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.invite
    ADD CONSTRAINT invite_pkey PRIMARY KEY (id);


--
-- Name: link_module_migrations link_module_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.link_module_migrations
    ADD CONSTRAINT link_module_migrations_pkey PRIMARY KEY (id);


--
-- Name: link_module_migrations link_module_migrations_table_name_key; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.link_module_migrations
    ADD CONSTRAINT link_module_migrations_table_name_key UNIQUE (table_name);


--
-- Name: location_fulfillment_provider location_fulfillment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.location_fulfillment_provider
    ADD CONSTRAINT location_fulfillment_provider_pkey PRIMARY KEY (stock_location_id, fulfillment_provider_id);


--
-- Name: location_fulfillment_set location_fulfillment_set_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.location_fulfillment_set
    ADD CONSTRAINT location_fulfillment_set_pkey PRIMARY KEY (stock_location_id, fulfillment_set_id);


--
-- Name: mikro_orm_migrations mikro_orm_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.mikro_orm_migrations
    ADD CONSTRAINT mikro_orm_migrations_pkey PRIMARY KEY (id);


--
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: notification_provider notification_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.notification_provider
    ADD CONSTRAINT notification_provider_pkey PRIMARY KEY (id);


--
-- Name: order_address order_address_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_address
    ADD CONSTRAINT order_address_pkey PRIMARY KEY (id);


--
-- Name: order_cart order_cart_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_cart
    ADD CONSTRAINT order_cart_pkey PRIMARY KEY (order_id, cart_id);


--
-- Name: order_change_action order_change_action_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_change_action
    ADD CONSTRAINT order_change_action_pkey PRIMARY KEY (id);


--
-- Name: order_change order_change_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_pkey PRIMARY KEY (id);


--
-- Name: order_claim_item_image order_claim_item_image_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_claim_item_image
    ADD CONSTRAINT order_claim_item_image_pkey PRIMARY KEY (id);


--
-- Name: order_claim_item order_claim_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_claim_item
    ADD CONSTRAINT order_claim_item_pkey PRIMARY KEY (id);


--
-- Name: order_claim order_claim_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_claim
    ADD CONSTRAINT order_claim_pkey PRIMARY KEY (id);


--
-- Name: order_credit_line order_credit_line_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_credit_line
    ADD CONSTRAINT order_credit_line_pkey PRIMARY KEY (id);


--
-- Name: order_exchange_item order_exchange_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_exchange_item
    ADD CONSTRAINT order_exchange_item_pkey PRIMARY KEY (id);


--
-- Name: order_exchange order_exchange_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_exchange
    ADD CONSTRAINT order_exchange_pkey PRIMARY KEY (id);


--
-- Name: order_fulfillment order_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_fulfillment
    ADD CONSTRAINT order_fulfillment_pkey PRIMARY KEY (order_id, fulfillment_id);


--
-- Name: order_item order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id);


--
-- Name: order_line_item_adjustment order_line_item_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_line_item_adjustment
    ADD CONSTRAINT order_line_item_adjustment_pkey PRIMARY KEY (id);


--
-- Name: order_line_item order_line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_line_item
    ADD CONSTRAINT order_line_item_pkey PRIMARY KEY (id);


--
-- Name: order_line_item_tax_line order_line_item_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_line_item_tax_line
    ADD CONSTRAINT order_line_item_tax_line_pkey PRIMARY KEY (id);


--
-- Name: order_payment_collection order_payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_payment_collection
    ADD CONSTRAINT order_payment_collection_pkey PRIMARY KEY (order_id, payment_collection_id);


--
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- Name: order_promotion order_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_promotion
    ADD CONSTRAINT order_promotion_pkey PRIMARY KEY (order_id, promotion_id);


--
-- Name: order_shipping_method_adjustment order_shipping_method_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_shipping_method_adjustment
    ADD CONSTRAINT order_shipping_method_adjustment_pkey PRIMARY KEY (id);


--
-- Name: order_shipping_method order_shipping_method_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_shipping_method
    ADD CONSTRAINT order_shipping_method_pkey PRIMARY KEY (id);


--
-- Name: order_shipping_method_tax_line order_shipping_method_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_shipping_method_tax_line
    ADD CONSTRAINT order_shipping_method_tax_line_pkey PRIMARY KEY (id);


--
-- Name: order_shipping order_shipping_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_shipping
    ADD CONSTRAINT order_shipping_pkey PRIMARY KEY (id);


--
-- Name: order_summary order_summary_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_summary
    ADD CONSTRAINT order_summary_pkey PRIMARY KEY (id);


--
-- Name: order_transaction order_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_transaction
    ADD CONSTRAINT order_transaction_pkey PRIMARY KEY (id);


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_pkey PRIMARY KEY (payment_collection_id, payment_provider_id);


--
-- Name: payment_collection payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.payment_collection
    ADD CONSTRAINT payment_collection_pkey PRIMARY KEY (id);


--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (id);


--
-- Name: payment_provider payment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.payment_provider
    ADD CONSTRAINT payment_provider_pkey PRIMARY KEY (id);


--
-- Name: payment_session payment_session_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.payment_session
    ADD CONSTRAINT payment_session_pkey PRIMARY KEY (id);


--
-- Name: price_list price_list_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.price_list
    ADD CONSTRAINT price_list_pkey PRIMARY KEY (id);


--
-- Name: price_list_rule price_list_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.price_list_rule
    ADD CONSTRAINT price_list_rule_pkey PRIMARY KEY (id);


--
-- Name: price price_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_pkey PRIMARY KEY (id);


--
-- Name: price_preference price_preference_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.price_preference
    ADD CONSTRAINT price_preference_pkey PRIMARY KEY (id);


--
-- Name: price_rule price_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.price_rule
    ADD CONSTRAINT price_rule_pkey PRIMARY KEY (id);


--
-- Name: price_set price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.price_set
    ADD CONSTRAINT price_set_pkey PRIMARY KEY (id);


--
-- Name: product_category product_category_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_pkey PRIMARY KEY (id);


--
-- Name: product_category_product product_category_product_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_pkey PRIMARY KEY (product_id, product_category_id);


--
-- Name: product_collection product_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product_collection
    ADD CONSTRAINT product_collection_pkey PRIMARY KEY (id);


--
-- Name: product_option product_option_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product_option
    ADD CONSTRAINT product_option_pkey PRIMARY KEY (id);


--
-- Name: product_option_value product_option_value_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product_option_value
    ADD CONSTRAINT product_option_value_pkey PRIMARY KEY (id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- Name: product_sales_channel product_sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product_sales_channel
    ADD CONSTRAINT product_sales_channel_pkey PRIMARY KEY (product_id, sales_channel_id);


--
-- Name: product_shipping_profile product_shipping_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product_shipping_profile
    ADD CONSTRAINT product_shipping_profile_pkey PRIMARY KEY (product_id, shipping_profile_id);


--
-- Name: product_tag product_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product_tag
    ADD CONSTRAINT product_tag_pkey PRIMARY KEY (id);


--
-- Name: product_tags product_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_pkey PRIMARY KEY (product_id, product_tag_id);


--
-- Name: product_type product_type_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pkey PRIMARY KEY (id);


--
-- Name: product_variant_inventory_item product_variant_inventory_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product_variant_inventory_item
    ADD CONSTRAINT product_variant_inventory_item_pkey PRIMARY KEY (variant_id, inventory_item_id);


--
-- Name: product_variant_option product_variant_option_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_pkey PRIMARY KEY (variant_id, option_value_id);


--
-- Name: product_variant product_variant_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT product_variant_pkey PRIMARY KEY (id);


--
-- Name: product_variant_price_set product_variant_price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product_variant_price_set
    ADD CONSTRAINT product_variant_price_set_pkey PRIMARY KEY (variant_id, price_set_id);


--
-- Name: promotion_application_method promotion_application_method_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.promotion_application_method
    ADD CONSTRAINT promotion_application_method_pkey PRIMARY KEY (id);


--
-- Name: promotion_campaign_budget promotion_campaign_budget_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.promotion_campaign_budget
    ADD CONSTRAINT promotion_campaign_budget_pkey PRIMARY KEY (id);


--
-- Name: promotion_campaign promotion_campaign_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.promotion_campaign
    ADD CONSTRAINT promotion_campaign_pkey PRIMARY KEY (id);


--
-- Name: promotion promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_pkey PRIMARY KEY (id);


--
-- Name: promotion_promotion_rule promotion_promotion_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_pkey PRIMARY KEY (promotion_id, promotion_rule_id);


--
-- Name: promotion_rule promotion_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.promotion_rule
    ADD CONSTRAINT promotion_rule_pkey PRIMARY KEY (id);


--
-- Name: promotion_rule_value promotion_rule_value_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.promotion_rule_value
    ADD CONSTRAINT promotion_rule_value_pkey PRIMARY KEY (id);


--
-- Name: provider_identity provider_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.provider_identity
    ADD CONSTRAINT provider_identity_pkey PRIMARY KEY (id);


--
-- Name: publishable_api_key_sales_channel publishable_api_key_sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.publishable_api_key_sales_channel
    ADD CONSTRAINT publishable_api_key_sales_channel_pkey PRIMARY KEY (publishable_key_id, sales_channel_id);


--
-- Name: refund refund_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT refund_pkey PRIMARY KEY (id);


--
-- Name: refund_reason refund_reason_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.refund_reason
    ADD CONSTRAINT refund_reason_pkey PRIMARY KEY (id);


--
-- Name: region_country region_country_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.region_country
    ADD CONSTRAINT region_country_pkey PRIMARY KEY (iso_2);


--
-- Name: region_payment_provider region_payment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.region_payment_provider
    ADD CONSTRAINT region_payment_provider_pkey PRIMARY KEY (region_id, payment_provider_id);


--
-- Name: region region_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- Name: reservation_item reservation_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.reservation_item
    ADD CONSTRAINT reservation_item_pkey PRIMARY KEY (id);


--
-- Name: return_fulfillment return_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.return_fulfillment
    ADD CONSTRAINT return_fulfillment_pkey PRIMARY KEY (return_id, fulfillment_id);


--
-- Name: return_item return_item_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.return_item
    ADD CONSTRAINT return_item_pkey PRIMARY KEY (id);


--
-- Name: return return_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.return
    ADD CONSTRAINT return_pkey PRIMARY KEY (id);


--
-- Name: return_reason return_reason_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.return_reason
    ADD CONSTRAINT return_reason_pkey PRIMARY KEY (id);


--
-- Name: sales_channel sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.sales_channel
    ADD CONSTRAINT sales_channel_pkey PRIMARY KEY (id);


--
-- Name: sales_channel_stock_location sales_channel_stock_location_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.sales_channel_stock_location
    ADD CONSTRAINT sales_channel_stock_location_pkey PRIMARY KEY (sales_channel_id, stock_location_id);


--
-- Name: script_migrations script_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.script_migrations
    ADD CONSTRAINT script_migrations_pkey PRIMARY KEY (id);


--
-- Name: service_zone service_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.service_zone
    ADD CONSTRAINT service_zone_pkey PRIMARY KEY (id);


--
-- Name: shipping_option shipping_option_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_pkey PRIMARY KEY (id);


--
-- Name: shipping_option_price_set shipping_option_price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.shipping_option_price_set
    ADD CONSTRAINT shipping_option_price_set_pkey PRIMARY KEY (shipping_option_id, price_set_id);


--
-- Name: shipping_option_rule shipping_option_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.shipping_option_rule
    ADD CONSTRAINT shipping_option_rule_pkey PRIMARY KEY (id);


--
-- Name: shipping_option_type shipping_option_type_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.shipping_option_type
    ADD CONSTRAINT shipping_option_type_pkey PRIMARY KEY (id);


--
-- Name: shipping_profile shipping_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.shipping_profile
    ADD CONSTRAINT shipping_profile_pkey PRIMARY KEY (id);


--
-- Name: stock_location_address stock_location_address_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.stock_location_address
    ADD CONSTRAINT stock_location_address_pkey PRIMARY KEY (id);


--
-- Name: stock_location stock_location_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.stock_location
    ADD CONSTRAINT stock_location_pkey PRIMARY KEY (id);


--
-- Name: store_currency store_currency_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.store_currency
    ADD CONSTRAINT store_currency_pkey PRIMARY KEY (id);


--
-- Name: store store_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT store_pkey PRIMARY KEY (id);


--
-- Name: tax_provider tax_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.tax_provider
    ADD CONSTRAINT tax_provider_pkey PRIMARY KEY (id);


--
-- Name: tax_rate tax_rate_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT tax_rate_pkey PRIMARY KEY (id);


--
-- Name: tax_rate_rule tax_rate_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.tax_rate_rule
    ADD CONSTRAINT tax_rate_rule_pkey PRIMARY KEY (id);


--
-- Name: tax_region tax_region_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT tax_region_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user_preference user_preference_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.user_preference
    ADD CONSTRAINT user_preference_pkey PRIMARY KEY (id);


--
-- Name: view_configuration view_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.view_configuration
    ADD CONSTRAINT view_configuration_pkey PRIMARY KEY (id);


--
-- Name: workflow_execution workflow_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.workflow_execution
    ADD CONSTRAINT workflow_execution_pkey PRIMARY KEY (workflow_id, transaction_id, run_id);


--
-- Name: IDX_account_holder_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_account_holder_deleted_at" ON public.account_holder USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_account_holder_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_account_holder_id_5cb3a0c0" ON public.customer_account_holder USING btree (account_holder_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_account_holder_provider_id_external_id_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_account_holder_provider_id_external_id_unique" ON public.account_holder USING btree (provider_id, external_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_adjustment_item_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_adjustment_item_id" ON public.cart_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_adjustment_shipping_method_id" ON public.cart_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_api_key_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_api_key_deleted_at" ON public.api_key USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_api_key_token_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_api_key_token_unique" ON public.api_key USING btree (token);


--
-- Name: IDX_api_key_type; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_api_key_type" ON public.api_key USING btree (type);


--
-- Name: IDX_application_method_allocation; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_application_method_allocation" ON public.promotion_application_method USING btree (allocation);


--
-- Name: IDX_application_method_target_type; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_application_method_target_type" ON public.promotion_application_method USING btree (target_type);


--
-- Name: IDX_application_method_type; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_application_method_type" ON public.promotion_application_method USING btree (type);


--
-- Name: IDX_auth_identity_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_auth_identity_deleted_at" ON public.auth_identity USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_campaign_budget_type; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_campaign_budget_type" ON public.promotion_campaign_budget USING btree (type);


--
-- Name: IDX_capture_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_capture_deleted_at" ON public.capture USING btree (deleted_at);


--
-- Name: IDX_capture_payment_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_capture_payment_id" ON public.capture USING btree (payment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_address_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_cart_address_deleted_at" ON public.cart_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_billing_address_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_cart_billing_address_id" ON public.cart USING btree (billing_address_id) WHERE ((deleted_at IS NULL) AND (billing_address_id IS NOT NULL));


--
-- Name: IDX_cart_credit_line_reference_reference_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_cart_credit_line_reference_reference_id" ON public.credit_line USING btree (reference, reference_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_currency_code; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_cart_currency_code" ON public.cart USING btree (currency_code);


--
-- Name: IDX_cart_customer_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_cart_customer_id" ON public.cart USING btree (customer_id) WHERE ((deleted_at IS NULL) AND (customer_id IS NOT NULL));


--
-- Name: IDX_cart_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_cart_deleted_at" ON public.cart USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_cart_id_-4a39f6c9" ON public.cart_payment_collection USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_id_-71069c16; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_cart_id_-71069c16" ON public.order_cart USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_cart_id_-a9d4a70b" ON public.cart_promotion USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_line_item_adjustment_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_cart_line_item_adjustment_deleted_at" ON public.cart_line_item_adjustment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_adjustment_item_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_cart_line_item_adjustment_item_id" ON public.cart_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_line_item_cart_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_cart_line_item_cart_id" ON public.cart_line_item USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_line_item_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_cart_line_item_deleted_at" ON public.cart_line_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_tax_line_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_cart_line_item_tax_line_deleted_at" ON public.cart_line_item_tax_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_tax_line_item_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_cart_line_item_tax_line_item_id" ON public.cart_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_region_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_cart_region_id" ON public.cart USING btree (region_id) WHERE ((deleted_at IS NULL) AND (region_id IS NOT NULL));


--
-- Name: IDX_cart_sales_channel_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_cart_sales_channel_id" ON public.cart USING btree (sales_channel_id) WHERE ((deleted_at IS NULL) AND (sales_channel_id IS NOT NULL));


--
-- Name: IDX_cart_shipping_address_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_cart_shipping_address_id" ON public.cart USING btree (shipping_address_id) WHERE ((deleted_at IS NULL) AND (shipping_address_id IS NOT NULL));


--
-- Name: IDX_cart_shipping_method_adjustment_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_cart_shipping_method_adjustment_deleted_at" ON public.cart_shipping_method_adjustment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_cart_shipping_method_adjustment_shipping_method_id" ON public.cart_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_shipping_method_cart_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_cart_shipping_method_cart_id" ON public.cart_shipping_method USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_shipping_method_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_cart_shipping_method_deleted_at" ON public.cart_shipping_method USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_tax_line_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_cart_shipping_method_tax_line_deleted_at" ON public.cart_shipping_method_tax_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_cart_shipping_method_tax_line_shipping_method_id" ON public.cart_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_category_handle_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_category_handle_unique" ON public.product_category USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_collection_handle_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_collection_handle_unique" ON public.product_collection USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_credit_line_cart_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_credit_line_cart_id" ON public.credit_line USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_credit_line_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_credit_line_deleted_at" ON public.credit_line USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_address_customer_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_customer_address_customer_id" ON public.customer_address USING btree (customer_id);


--
-- Name: IDX_customer_address_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_customer_address_deleted_at" ON public.customer_address USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_address_unique_customer_billing; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_billing" ON public.customer_address USING btree (customer_id) WHERE (is_default_billing = true);


--
-- Name: IDX_customer_address_unique_customer_shipping; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_shipping" ON public.customer_address USING btree (customer_id) WHERE (is_default_shipping = true);


--
-- Name: IDX_customer_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_customer_deleted_at" ON public.customer USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_email_has_account_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_customer_email_has_account_unique" ON public.customer USING btree (email, has_account) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_customer_customer_group_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_customer_group_customer_customer_group_id" ON public.customer_group_customer USING btree (customer_group_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_customer_customer_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_customer_group_customer_customer_id" ON public.customer_group_customer USING btree (customer_id);


--
-- Name: IDX_customer_group_customer_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_customer_group_customer_deleted_at" ON public.customer_group_customer USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_customer_group_deleted_at" ON public.customer_group USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_name; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_customer_group_name" ON public.customer_group USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_name_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_customer_group_name_unique" ON public.customer_group USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_customer_id_5cb3a0c0" ON public.customer_account_holder USING btree (customer_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_deleted_at_-1d67bae40; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_deleted_at_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-1e5992737; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_deleted_at_-1e5992737" ON public.location_fulfillment_provider USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-31ea43a; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_deleted_at_-31ea43a" ON public.return_fulfillment USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-4a39f6c9; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_deleted_at_-4a39f6c9" ON public.cart_payment_collection USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-71069c16; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_deleted_at_-71069c16" ON public.order_cart USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-71518339; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_deleted_at_-71518339" ON public.order_promotion USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-a9d4a70b; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_deleted_at_-a9d4a70b" ON public.cart_promotion USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-e88adb96; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_deleted_at_-e88adb96" ON public.location_fulfillment_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-e8d2543e; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_deleted_at_-e8d2543e" ON public.order_fulfillment USING btree (deleted_at);


--
-- Name: IDX_deleted_at_17a262437; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_deleted_at_17a262437" ON public.product_shipping_profile USING btree (deleted_at);


--
-- Name: IDX_deleted_at_17b4c4e35; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_deleted_at_17b4c4e35" ON public.product_variant_inventory_item USING btree (deleted_at);


--
-- Name: IDX_deleted_at_1c934dab0; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_deleted_at_1c934dab0" ON public.region_payment_provider USING btree (deleted_at);


--
-- Name: IDX_deleted_at_20b454295; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_deleted_at_20b454295" ON public.product_sales_channel USING btree (deleted_at);


--
-- Name: IDX_deleted_at_26d06f470; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_deleted_at_26d06f470" ON public.sales_channel_stock_location USING btree (deleted_at);


--
-- Name: IDX_deleted_at_52b23597; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_deleted_at_52b23597" ON public.product_variant_price_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_5cb3a0c0; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_deleted_at_5cb3a0c0" ON public.customer_account_holder USING btree (deleted_at);


--
-- Name: IDX_deleted_at_ba32fa9c; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_deleted_at_ba32fa9c" ON public.shipping_option_price_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_f42b9949; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_deleted_at_f42b9949" ON public.order_payment_collection USING btree (deleted_at);


--
-- Name: IDX_fulfillment_address_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_fulfillment_address_deleted_at" ON public.fulfillment_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_fulfillment_deleted_at" ON public.fulfillment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_id_-31ea43a; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_fulfillment_id_-31ea43a" ON public.return_fulfillment USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_id_-e8d2543e; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_fulfillment_id_-e8d2543e" ON public.order_fulfillment USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_item_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_fulfillment_item_deleted_at" ON public.fulfillment_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_item_fulfillment_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_fulfillment_item_fulfillment_id" ON public.fulfillment_item USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_item_inventory_item_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_fulfillment_item_inventory_item_id" ON public.fulfillment_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_item_line_item_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_fulfillment_item_line_item_id" ON public.fulfillment_item USING btree (line_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_label_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_fulfillment_label_deleted_at" ON public.fulfillment_label USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_label_fulfillment_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_fulfillment_label_fulfillment_id" ON public.fulfillment_label USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_location_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_fulfillment_location_id" ON public.fulfillment USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_provider_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_fulfillment_provider_deleted_at" ON public.fulfillment_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_provider_id_-1e5992737; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_fulfillment_provider_id_-1e5992737" ON public.location_fulfillment_provider USING btree (fulfillment_provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_set_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_fulfillment_set_deleted_at" ON public.fulfillment_set USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_set_id_-e88adb96; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_fulfillment_set_id_-e88adb96" ON public.location_fulfillment_set USING btree (fulfillment_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_set_name_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_fulfillment_set_name_unique" ON public.fulfillment_set USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_shipping_option_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_fulfillment_shipping_option_id" ON public.fulfillment USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_geo_zone_city; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_geo_zone_city" ON public.geo_zone USING btree (city) WHERE ((deleted_at IS NULL) AND (city IS NOT NULL));


--
-- Name: IDX_geo_zone_country_code; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_geo_zone_country_code" ON public.geo_zone USING btree (country_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_geo_zone_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_geo_zone_deleted_at" ON public.geo_zone USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_geo_zone_province_code; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_geo_zone_province_code" ON public.geo_zone USING btree (province_code) WHERE ((deleted_at IS NULL) AND (province_code IS NOT NULL));


--
-- Name: IDX_geo_zone_service_zone_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_geo_zone_service_zone_id" ON public.geo_zone USING btree (service_zone_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_id_-1d67bae40; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (id);


--
-- Name: IDX_id_-1e5992737; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_id_-1e5992737" ON public.location_fulfillment_provider USING btree (id);


--
-- Name: IDX_id_-31ea43a; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_id_-31ea43a" ON public.return_fulfillment USING btree (id);


--
-- Name: IDX_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_id_-4a39f6c9" ON public.cart_payment_collection USING btree (id);


--
-- Name: IDX_id_-71069c16; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_id_-71069c16" ON public.order_cart USING btree (id);


--
-- Name: IDX_id_-71518339; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_id_-71518339" ON public.order_promotion USING btree (id);


--
-- Name: IDX_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_id_-a9d4a70b" ON public.cart_promotion USING btree (id);


--
-- Name: IDX_id_-e88adb96; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_id_-e88adb96" ON public.location_fulfillment_set USING btree (id);


--
-- Name: IDX_id_-e8d2543e; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_id_-e8d2543e" ON public.order_fulfillment USING btree (id);


--
-- Name: IDX_id_17a262437; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_id_17a262437" ON public.product_shipping_profile USING btree (id);


--
-- Name: IDX_id_17b4c4e35; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (id);


--
-- Name: IDX_id_1c934dab0; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_id_1c934dab0" ON public.region_payment_provider USING btree (id);


--
-- Name: IDX_id_20b454295; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_id_20b454295" ON public.product_sales_channel USING btree (id);


--
-- Name: IDX_id_26d06f470; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_id_26d06f470" ON public.sales_channel_stock_location USING btree (id);


--
-- Name: IDX_id_52b23597; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_id_52b23597" ON public.product_variant_price_set USING btree (id);


--
-- Name: IDX_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_id_5cb3a0c0" ON public.customer_account_holder USING btree (id);


--
-- Name: IDX_id_ba32fa9c; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_id_ba32fa9c" ON public.shipping_option_price_set USING btree (id);


--
-- Name: IDX_id_f42b9949; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_id_f42b9949" ON public.order_payment_collection USING btree (id);


--
-- Name: IDX_image_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_image_deleted_at" ON public.image USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_image_product_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_image_product_id" ON public.image USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_item_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_inventory_item_deleted_at" ON public.inventory_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_inventory_item_id_17b4c4e35; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_inventory_item_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_item_sku; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_inventory_item_sku" ON public.inventory_item USING btree (sku) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_inventory_level_deleted_at" ON public.inventory_level USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_inventory_level_inventory_item_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_inventory_level_inventory_item_id" ON public.inventory_level USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_item_location; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_inventory_level_item_location" ON public.inventory_level USING btree (inventory_item_id, location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_location_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_inventory_level_location_id" ON public.inventory_level USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_location_id_inventory_item_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_inventory_level_location_id_inventory_item_id" ON public.inventory_level USING btree (inventory_item_id, location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_invite_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_invite_deleted_at" ON public.invite USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_invite_email_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_invite_email_unique" ON public.invite USING btree (email) WHERE (deleted_at IS NULL);


--
-- Name: IDX_invite_token; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_invite_token" ON public.invite USING btree (token) WHERE (deleted_at IS NULL);


--
-- Name: IDX_line_item_adjustment_promotion_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_line_item_adjustment_promotion_id" ON public.cart_line_item_adjustment USING btree (promotion_id) WHERE ((deleted_at IS NULL) AND (promotion_id IS NOT NULL));


--
-- Name: IDX_line_item_cart_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_line_item_cart_id" ON public.cart_line_item USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_line_item_product_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_line_item_product_id" ON public.cart_line_item USING btree (product_id) WHERE ((deleted_at IS NULL) AND (product_id IS NOT NULL));


--
-- Name: IDX_line_item_product_type_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_line_item_product_type_id" ON public.order_line_item USING btree (product_type_id) WHERE ((deleted_at IS NULL) AND (product_type_id IS NOT NULL));


--
-- Name: IDX_line_item_tax_line_tax_rate_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_line_item_tax_line_tax_rate_id" ON public.cart_line_item_tax_line USING btree (tax_rate_id) WHERE ((deleted_at IS NULL) AND (tax_rate_id IS NOT NULL));


--
-- Name: IDX_line_item_variant_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_line_item_variant_id" ON public.cart_line_item USING btree (variant_id) WHERE ((deleted_at IS NULL) AND (variant_id IS NOT NULL));


--
-- Name: IDX_notification_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_notification_deleted_at" ON public.notification USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_idempotency_key_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_notification_idempotency_key_unique" ON public.notification USING btree (idempotency_key) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_provider_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_notification_provider_deleted_at" ON public.notification_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_provider_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_notification_provider_id" ON public.notification USING btree (provider_id);


--
-- Name: IDX_notification_receiver_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_notification_receiver_id" ON public.notification USING btree (receiver_id);


--
-- Name: IDX_option_product_id_title_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_option_product_id_title_unique" ON public.product_option USING btree (product_id, title) WHERE (deleted_at IS NULL);


--
-- Name: IDX_option_value_option_id_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_option_value_option_id_unique" ON public.product_option_value USING btree (option_id, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_address_customer_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_address_customer_id" ON public.order_address USING btree (customer_id);


--
-- Name: IDX_order_address_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_address_deleted_at" ON public.order_address USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_billing_address_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_billing_address_id" ON public."order" USING btree (billing_address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_action_claim_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_change_action_claim_id" ON public.order_change_action USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_action_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_change_action_deleted_at" ON public.order_change_action USING btree (deleted_at);


--
-- Name: IDX_order_change_action_exchange_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_change_action_exchange_id" ON public.order_change_action USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_action_order_change_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_change_action_order_change_id" ON public.order_change_action USING btree (order_change_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_action_order_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_change_action_order_id" ON public.order_change_action USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_action_ordering; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_change_action_ordering" ON public.order_change_action USING btree (ordering) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_action_return_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_change_action_return_id" ON public.order_change_action USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_change_type; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_change_change_type" ON public.order_change USING btree (change_type);


--
-- Name: IDX_order_change_claim_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_change_claim_id" ON public.order_change USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_change_deleted_at" ON public.order_change USING btree (deleted_at);


--
-- Name: IDX_order_change_exchange_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_change_exchange_id" ON public.order_change USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_order_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_change_order_id" ON public.order_change USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_order_id_version; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_change_order_id_version" ON public.order_change USING btree (order_id, version);


--
-- Name: IDX_order_change_return_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_change_return_id" ON public.order_change USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_status; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_change_status" ON public.order_change USING btree (status) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_version; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_change_version" ON public.order_change USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_claim_deleted_at" ON public.order_claim USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_display_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_claim_display_id" ON public.order_claim USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_claim_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_claim_item_claim_id" ON public.order_claim_item USING btree (claim_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_claim_item_deleted_at" ON public.order_claim_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_image_claim_item_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_claim_item_image_claim_item_id" ON public.order_claim_item_image USING btree (claim_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_image_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_claim_item_image_deleted_at" ON public.order_claim_item_image USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_claim_item_item_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_claim_item_item_id" ON public.order_claim_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_order_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_claim_order_id" ON public.order_claim USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_return_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_claim_return_id" ON public.order_claim USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_credit_line_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_credit_line_deleted_at" ON public.order_credit_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_credit_line_order_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_credit_line_order_id" ON public.order_credit_line USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_currency_code; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_currency_code" ON public."order" USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_customer_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_customer_id" ON public."order" USING btree (customer_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_deleted_at" ON public."order" USING btree (deleted_at);


--
-- Name: IDX_order_display_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_display_id" ON public."order" USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_exchange_deleted_at" ON public.order_exchange USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_display_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_exchange_display_id" ON public.order_exchange USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_exchange_item_deleted_at" ON public.order_exchange_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_exchange_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_exchange_item_exchange_id" ON public.order_exchange_item USING btree (exchange_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_item_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_exchange_item_item_id" ON public.order_exchange_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_order_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_exchange_order_id" ON public.order_exchange USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_return_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_exchange_return_id" ON public.order_exchange USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_id_-71069c16; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_id_-71069c16" ON public.order_cart USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_id_-71518339; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_id_-71518339" ON public.order_promotion USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_id_-e8d2543e; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_id_-e8d2543e" ON public.order_fulfillment USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_id_f42b9949; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_id_f42b9949" ON public.order_payment_collection USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_is_draft_order; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_is_draft_order" ON public."order" USING btree (is_draft_order) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_item_deleted_at" ON public.order_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_item_item_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_item_item_id" ON public.order_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_order_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_item_order_id" ON public.order_item USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_order_id_version; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_item_order_id_version" ON public.order_item USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_version; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_item_version" ON public.order_item USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_adjustment_item_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_line_item_adjustment_item_id" ON public.order_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_product_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_line_item_product_id" ON public.order_line_item USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_tax_line_item_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_line_item_tax_line_item_id" ON public.order_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_variant_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_line_item_variant_id" ON public.order_line_item USING btree (variant_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_region_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_region_id" ON public."order" USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_sales_channel_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_sales_channel_id" ON public."order" USING btree (sales_channel_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_address_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_shipping_address_id" ON public."order" USING btree (shipping_address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_claim_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_shipping_claim_id" ON public.order_shipping USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_shipping_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_shipping_deleted_at" ON public.order_shipping USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_shipping_exchange_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_shipping_exchange_id" ON public.order_shipping USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_shipping_item_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_shipping_item_id" ON public.order_shipping USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_shipping_method_adjustment_shipping_method_id" ON public.order_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_shipping_option_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_shipping_method_shipping_option_id" ON public.order_shipping_method USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_shipping_method_tax_line_shipping_method_id" ON public.order_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_order_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_shipping_order_id" ON public.order_shipping USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_order_id_version; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_shipping_order_id_version" ON public.order_shipping USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_return_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_shipping_return_id" ON public.order_shipping USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_shipping_shipping_method_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_shipping_shipping_method_id" ON public.order_shipping USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_version; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_shipping_version" ON public.order_shipping USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_summary_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_summary_deleted_at" ON public.order_summary USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_summary_order_id_version; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_summary_order_id_version" ON public.order_summary USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_claim_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_transaction_claim_id" ON public.order_transaction USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_transaction_currency_code; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_transaction_currency_code" ON public.order_transaction USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_exchange_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_transaction_exchange_id" ON public.order_transaction USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_transaction_order_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_transaction_order_id" ON public.order_transaction USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_order_id_version; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_transaction_order_id_version" ON public.order_transaction USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_reference_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_transaction_reference_id" ON public.order_transaction USING btree (reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_return_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_order_transaction_return_id" ON public.order_transaction USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_payment_collection_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_payment_collection_deleted_at" ON public.payment_collection USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_payment_collection_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_payment_collection_id_-4a39f6c9" ON public.cart_payment_collection USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_collection_id_f42b9949; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_payment_collection_id_f42b9949" ON public.order_payment_collection USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_payment_deleted_at" ON public.payment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_payment_payment_collection_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_payment_payment_collection_id" ON public.payment USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_payment_session_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_payment_payment_session_id" ON public.payment USING btree (payment_session_id);


--
-- Name: IDX_payment_payment_session_id_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_payment_payment_session_id_unique" ON public.payment USING btree (payment_session_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_payment_provider_deleted_at" ON public.payment_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_payment_provider_id" ON public.payment USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_id_1c934dab0; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_payment_provider_id_1c934dab0" ON public.region_payment_provider USING btree (payment_provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_session_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_payment_session_deleted_at" ON public.payment_session USING btree (deleted_at);


--
-- Name: IDX_payment_session_payment_collection_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_payment_session_payment_collection_id" ON public.payment_session USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_currency_code; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_price_currency_code" ON public.price USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_price_deleted_at" ON public.price USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_price_list_deleted_at" ON public.price_list USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_rule_attribute; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_price_list_rule_attribute" ON public.price_list_rule USING btree (attribute) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_list_rule_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_price_list_rule_deleted_at" ON public.price_list_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_rule_price_list_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_price_list_rule_price_list_id" ON public.price_list_rule USING btree (price_list_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_preference_attribute_value; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_price_preference_attribute_value" ON public.price_preference USING btree (attribute, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_preference_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_price_preference_deleted_at" ON public.price_preference USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_price_list_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_price_price_list_id" ON public.price USING btree (price_list_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_price_set_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_price_price_set_id" ON public.price USING btree (price_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_attribute; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_price_rule_attribute" ON public.price_rule USING btree (attribute) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_attribute_value; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_price_rule_attribute_value" ON public.price_rule USING btree (attribute, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_price_rule_deleted_at" ON public.price_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_rule_operator; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_price_rule_operator" ON public.price_rule USING btree (operator);


--
-- Name: IDX_price_rule_operator_value; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_price_rule_operator_value" ON public.price_rule USING btree (operator, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_price_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_price_rule_price_id" ON public.price_rule USING btree (price_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_price_id_attribute_operator_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_price_rule_price_id_attribute_operator_unique" ON public.price_rule USING btree (price_id, attribute, operator) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_set_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_price_set_deleted_at" ON public.price_set USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_set_id_52b23597; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_price_set_id_52b23597" ON public.product_variant_price_set USING btree (price_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_set_id_ba32fa9c; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_price_set_id_ba32fa9c" ON public.shipping_option_price_set USING btree (price_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_category_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_product_category_deleted_at" ON public.product_collection USING btree (deleted_at);


--
-- Name: IDX_product_category_parent_category_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_product_category_parent_category_id" ON public.product_category USING btree (parent_category_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_category_path; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_product_category_path" ON public.product_category USING btree (mpath) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_collection_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_product_collection_deleted_at" ON public.product_collection USING btree (deleted_at);


--
-- Name: IDX_product_collection_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_product_collection_id" ON public.product USING btree (collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_product_deleted_at" ON public.product USING btree (deleted_at);


--
-- Name: IDX_product_handle_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_product_handle_unique" ON public.product USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_id_17a262437; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_product_id_17a262437" ON public.product_shipping_profile USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_id_20b454295; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_product_id_20b454295" ON public.product_sales_channel USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_image_rank; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_product_image_rank" ON public.image USING btree (rank) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_image_rank_product_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_product_image_rank_product_id" ON public.image USING btree (rank, product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_image_url; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_product_image_url" ON public.image USING btree (url) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_image_url_rank_product_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_product_image_url_rank_product_id" ON public.image USING btree (url, rank, product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_option_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_product_option_deleted_at" ON public.product_option USING btree (deleted_at);


--
-- Name: IDX_product_option_product_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_product_option_product_id" ON public.product_option USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_option_value_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_product_option_value_deleted_at" ON public.product_option_value USING btree (deleted_at);


--
-- Name: IDX_product_option_value_option_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_product_option_value_option_id" ON public.product_option_value USING btree (option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_status; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_product_status" ON public.product USING btree (status) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_tag_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_product_tag_deleted_at" ON public.product_tag USING btree (deleted_at);


--
-- Name: IDX_product_type_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_product_type_deleted_at" ON public.product_type USING btree (deleted_at);


--
-- Name: IDX_product_type_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_product_type_id" ON public.product USING btree (type_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_barcode_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_product_variant_barcode_unique" ON public.product_variant USING btree (barcode) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_product_variant_deleted_at" ON public.product_variant USING btree (deleted_at);


--
-- Name: IDX_product_variant_ean_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_product_variant_ean_unique" ON public.product_variant USING btree (ean) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_id_product_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_product_variant_id_product_id" ON public.product_variant USING btree (id, product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_product_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_product_variant_product_id" ON public.product_variant USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_sku_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_product_variant_sku_unique" ON public.product_variant USING btree (sku) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_upc_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_product_variant_upc_unique" ON public.product_variant USING btree (upc) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_application_method_currency_code; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_promotion_application_method_currency_code" ON public.promotion_application_method USING btree (currency_code) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_promotion_application_method_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_promotion_application_method_deleted_at" ON public.promotion_application_method USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_application_method_promotion_id_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_promotion_application_method_promotion_id_unique" ON public.promotion_application_method USING btree (promotion_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_campaign_id_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_promotion_campaign_budget_campaign_id_unique" ON public.promotion_campaign_budget USING btree (campaign_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_promotion_campaign_budget_deleted_at" ON public.promotion_campaign_budget USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_campaign_identifier_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_promotion_campaign_campaign_identifier_unique" ON public.promotion_campaign USING btree (campaign_identifier) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_promotion_campaign_deleted_at" ON public.promotion_campaign USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_promotion_campaign_id" ON public.promotion USING btree (campaign_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_promotion_deleted_at" ON public.promotion USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_id_-71518339; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_promotion_id_-71518339" ON public.order_promotion USING btree (promotion_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_promotion_id_-a9d4a70b" ON public.cart_promotion USING btree (promotion_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_is_automatic; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_promotion_is_automatic" ON public.promotion USING btree (is_automatic) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_attribute; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_promotion_rule_attribute" ON public.promotion_rule USING btree (attribute);


--
-- Name: IDX_promotion_rule_attribute_operator; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_promotion_rule_attribute_operator" ON public.promotion_rule USING btree (attribute, operator) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_promotion_rule_deleted_at" ON public.promotion_rule USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_operator; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_promotion_rule_operator" ON public.promotion_rule USING btree (operator);


--
-- Name: IDX_promotion_rule_value_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_promotion_rule_value_deleted_at" ON public.promotion_rule_value USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_value_promotion_rule_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_promotion_rule_value_promotion_rule_id" ON public.promotion_rule_value USING btree (promotion_rule_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_value_rule_id_value; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_promotion_rule_value_rule_id_value" ON public.promotion_rule_value USING btree (promotion_rule_id, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_value_value; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_promotion_rule_value_value" ON public.promotion_rule_value USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_status; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_promotion_status" ON public.promotion USING btree (status) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_type; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_promotion_type" ON public.promotion USING btree (type);


--
-- Name: IDX_provider_identity_auth_identity_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_provider_identity_auth_identity_id" ON public.provider_identity USING btree (auth_identity_id);


--
-- Name: IDX_provider_identity_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_provider_identity_deleted_at" ON public.provider_identity USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_provider_identity_provider_entity_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_provider_identity_provider_entity_id" ON public.provider_identity USING btree (entity_id, provider);


--
-- Name: IDX_publishable_key_id_-1d67bae40; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_publishable_key_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (publishable_key_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_refund_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_refund_deleted_at" ON public.refund USING btree (deleted_at);


--
-- Name: IDX_refund_payment_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_refund_payment_id" ON public.refund USING btree (payment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_refund_reason_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_refund_reason_deleted_at" ON public.refund_reason USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_refund_refund_reason_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_refund_refund_reason_id" ON public.refund USING btree (refund_reason_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_region_country_deleted_at" ON public.region_country USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_region_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_region_country_region_id" ON public.region_country USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_region_id_iso_2_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_region_country_region_id_iso_2_unique" ON public.region_country USING btree (region_id, iso_2);


--
-- Name: IDX_region_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_region_deleted_at" ON public.region USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_region_id_1c934dab0; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_region_id_1c934dab0" ON public.region_payment_provider USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_reservation_item_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_reservation_item_deleted_at" ON public.reservation_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_reservation_item_inventory_item_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_reservation_item_inventory_item_id" ON public.reservation_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_reservation_item_line_item_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_reservation_item_line_item_id" ON public.reservation_item USING btree (line_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_reservation_item_location_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_reservation_item_location_id" ON public.reservation_item USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_claim_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_return_claim_id" ON public.return USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_return_display_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_return_display_id" ON public.return USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_exchange_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_return_exchange_id" ON public.return USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_return_id_-31ea43a; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_return_id_-31ea43a" ON public.return_fulfillment USING btree (return_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_return_item_deleted_at" ON public.return_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_item_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_return_item_item_id" ON public.return_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_reason_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_return_item_reason_id" ON public.return_item USING btree (reason_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_return_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_return_item_return_id" ON public.return_item USING btree (return_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_order_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_return_order_id" ON public.return USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_reason_parent_return_reason_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_return_reason_parent_return_reason_id" ON public.return_reason USING btree (parent_return_reason_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_reason_value; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_return_reason_value" ON public.return_reason USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_sales_channel_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_sales_channel_deleted_at" ON public.sales_channel USING btree (deleted_at);


--
-- Name: IDX_sales_channel_id_-1d67bae40; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_sales_channel_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (sales_channel_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_sales_channel_id_20b454295; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_sales_channel_id_20b454295" ON public.product_sales_channel USING btree (sales_channel_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_sales_channel_id_26d06f470; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_sales_channel_id_26d06f470" ON public.sales_channel_stock_location USING btree (sales_channel_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_service_zone_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_service_zone_deleted_at" ON public.service_zone USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_service_zone_fulfillment_set_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_service_zone_fulfillment_set_id" ON public.service_zone USING btree (fulfillment_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_service_zone_name_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_service_zone_name_unique" ON public.service_zone USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_method_adjustment_promotion_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_shipping_method_adjustment_promotion_id" ON public.cart_shipping_method_adjustment USING btree (promotion_id) WHERE ((deleted_at IS NULL) AND (promotion_id IS NOT NULL));


--
-- Name: IDX_shipping_method_cart_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_shipping_method_cart_id" ON public.cart_shipping_method USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_method_option_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_shipping_method_option_id" ON public.cart_shipping_method USING btree (shipping_option_id) WHERE ((deleted_at IS NULL) AND (shipping_option_id IS NOT NULL));


--
-- Name: IDX_shipping_method_tax_line_tax_rate_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_shipping_method_tax_line_tax_rate_id" ON public.cart_shipping_method_tax_line USING btree (tax_rate_id) WHERE ((deleted_at IS NULL) AND (tax_rate_id IS NOT NULL));


--
-- Name: IDX_shipping_option_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_shipping_option_deleted_at" ON public.shipping_option USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_option_id_ba32fa9c; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_shipping_option_id_ba32fa9c" ON public.shipping_option_price_set USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_provider_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_shipping_option_provider_id" ON public.shipping_option USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_rule_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_shipping_option_rule_deleted_at" ON public.shipping_option_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_option_rule_shipping_option_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_shipping_option_rule_shipping_option_id" ON public.shipping_option_rule USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_service_zone_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_shipping_option_service_zone_id" ON public.shipping_option USING btree (service_zone_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_shipping_profile_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_shipping_option_shipping_profile_id" ON public.shipping_option USING btree (shipping_profile_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_type_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_shipping_option_type_deleted_at" ON public.shipping_option_type USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_profile_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_shipping_profile_deleted_at" ON public.shipping_profile USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_profile_id_17a262437; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_shipping_profile_id_17a262437" ON public.product_shipping_profile USING btree (shipping_profile_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_profile_name_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_shipping_profile_name_unique" ON public.shipping_profile USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_single_default_region; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_single_default_region" ON public.tax_rate USING btree (tax_region_id) WHERE ((is_default = true) AND (deleted_at IS NULL));


--
-- Name: IDX_stock_location_address_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_stock_location_address_deleted_at" ON public.stock_location_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_stock_location_address_id_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_stock_location_address_id_unique" ON public.stock_location USING btree (address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_stock_location_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_stock_location_deleted_at" ON public.stock_location USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_stock_location_id_-1e5992737; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_stock_location_id_-1e5992737" ON public.location_fulfillment_provider USING btree (stock_location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_stock_location_id_-e88adb96; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_stock_location_id_-e88adb96" ON public.location_fulfillment_set USING btree (stock_location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_stock_location_id_26d06f470; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_stock_location_id_26d06f470" ON public.sales_channel_stock_location USING btree (stock_location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_store_currency_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_store_currency_deleted_at" ON public.store_currency USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_store_currency_store_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_store_currency_store_id" ON public.store_currency USING btree (store_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_store_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_store_deleted_at" ON public.store USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tag_value_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_tag_value_unique" ON public.product_tag USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_line_item_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_tax_line_item_id" ON public.cart_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_tax_line_shipping_method_id" ON public.cart_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_provider_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_tax_provider_deleted_at" ON public.tax_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_tax_rate_deleted_at" ON public.tax_rate USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_rate_rule_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_tax_rate_rule_deleted_at" ON public.tax_rate_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_rate_rule_reference_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_tax_rate_rule_reference_id" ON public.tax_rate_rule USING btree (reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_rule_tax_rate_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_tax_rate_rule_tax_rate_id" ON public.tax_rate_rule USING btree (tax_rate_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_rule_unique_rate_reference; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_tax_rate_rule_unique_rate_reference" ON public.tax_rate_rule USING btree (tax_rate_id, reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_tax_region_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_tax_rate_tax_region_id" ON public.tax_rate USING btree (tax_region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_region_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_tax_region_deleted_at" ON public.tax_region USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_region_parent_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_tax_region_parent_id" ON public.tax_region USING btree (parent_id);


--
-- Name: IDX_tax_region_provider_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_tax_region_provider_id" ON public.tax_region USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_region_unique_country_nullable_province; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_tax_region_unique_country_nullable_province" ON public.tax_region USING btree (country_code) WHERE ((province_code IS NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_tax_region_unique_country_province; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_tax_region_unique_country_province" ON public.tax_region USING btree (country_code, province_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_type_value_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_type_value_unique" ON public.product_type USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_unique_promotion_code; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_unique_promotion_code" ON public.promotion USING btree (code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_user_deleted_at" ON public."user" USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_user_email_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_user_email_unique" ON public."user" USING btree (email) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_preference_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_user_preference_deleted_at" ON public.user_preference USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_preference_user_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_user_preference_user_id" ON public.user_preference USING btree (user_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_preference_user_id_key_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_user_preference_user_id_key_unique" ON public.user_preference USING btree (user_id, key) WHERE (deleted_at IS NULL);


--
-- Name: IDX_variant_id_17b4c4e35; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_variant_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (variant_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_variant_id_52b23597; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_variant_id_52b23597" ON public.product_variant_price_set USING btree (variant_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_view_configuration_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_view_configuration_deleted_at" ON public.view_configuration USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_view_configuration_entity_is_system_default; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_view_configuration_entity_is_system_default" ON public.view_configuration USING btree (entity, is_system_default) WHERE (deleted_at IS NULL);


--
-- Name: IDX_view_configuration_entity_user_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_view_configuration_entity_user_id" ON public.view_configuration USING btree (entity, user_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_view_configuration_user_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_view_configuration_user_id" ON public.view_configuration USING btree (user_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_deleted_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_workflow_execution_deleted_at" ON public.workflow_execution USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_workflow_execution_id" ON public.workflow_execution USING btree (id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_retention_time_updated_at_state; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_workflow_execution_retention_time_updated_at_state" ON public.workflow_execution USING btree (retention_time, updated_at, state) WHERE ((deleted_at IS NULL) AND (retention_time IS NOT NULL));


--
-- Name: IDX_workflow_execution_run_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_workflow_execution_run_id" ON public.workflow_execution USING btree (run_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_state; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_workflow_execution_state" ON public.workflow_execution USING btree (state) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_state_updated_at; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_workflow_execution_state_updated_at" ON public.workflow_execution USING btree (state, updated_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_transaction_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_workflow_execution_transaction_id" ON public.workflow_execution USING btree (transaction_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_updated_at_retention_time; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_workflow_execution_updated_at_retention_time" ON public.workflow_execution USING btree (updated_at, retention_time) WHERE ((deleted_at IS NULL) AND (retention_time IS NOT NULL) AND ((state)::text = ANY ((ARRAY['done'::character varying, 'failed'::character varying, 'reverted'::character varying])::text[])));


--
-- Name: IDX_workflow_execution_workflow_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_workflow_execution_workflow_id" ON public.workflow_execution USING btree (workflow_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_workflow_id_transaction_id; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE INDEX "IDX_workflow_execution_workflow_id_transaction_id" ON public.workflow_execution USING btree (workflow_id, transaction_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_workflow_id_transaction_id_run_id_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX "IDX_workflow_execution_workflow_id_transaction_id_run_id_unique" ON public.workflow_execution USING btree (workflow_id, transaction_id, run_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_script_name_unique; Type: INDEX; Schema: public; Owner: medusa_admin
--

CREATE UNIQUE INDEX idx_script_name_unique ON public.script_migrations USING btree (script_name);


--
-- Name: tax_rate_rule FK_tax_rate_rule_tax_rate_id; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.tax_rate_rule
    ADD CONSTRAINT "FK_tax_rate_rule_tax_rate_id" FOREIGN KEY (tax_rate_id) REFERENCES public.tax_rate(id) ON DELETE CASCADE;


--
-- Name: tax_rate FK_tax_rate_tax_region_id; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT "FK_tax_rate_tax_region_id" FOREIGN KEY (tax_region_id) REFERENCES public.tax_region(id) ON DELETE CASCADE;


--
-- Name: tax_region FK_tax_region_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT "FK_tax_region_parent_id" FOREIGN KEY (parent_id) REFERENCES public.tax_region(id) ON DELETE CASCADE;


--
-- Name: tax_region FK_tax_region_provider_id; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT "FK_tax_region_provider_id" FOREIGN KEY (provider_id) REFERENCES public.tax_provider(id) ON DELETE SET NULL;


--
-- Name: application_method_buy_rules application_method_buy_rules_application_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES public.promotion_application_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_buy_rules application_method_buy_rules_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_target_rules application_method_target_rules_application_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES public.promotion_application_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_target_rules application_method_target_rules_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: capture capture_payment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.capture
    ADD CONSTRAINT capture_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart cart_billing_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES public.cart_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cart_line_item_adjustment cart_line_item_adjustment_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.cart_line_item_adjustment
    ADD CONSTRAINT cart_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.cart_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_line_item cart_line_item_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.cart_line_item
    ADD CONSTRAINT cart_line_item_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_line_item_tax_line cart_line_item_tax_line_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.cart_line_item_tax_line
    ADD CONSTRAINT cart_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.cart_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart cart_shipping_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES public.cart_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cart_shipping_method_adjustment cart_shipping_method_adjustment_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.cart_shipping_method_adjustment
    ADD CONSTRAINT cart_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.cart_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_shipping_method cart_shipping_method_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.cart_shipping_method
    ADD CONSTRAINT cart_shipping_method_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_shipping_method_tax_line cart_shipping_method_tax_line_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.cart_shipping_method_tax_line
    ADD CONSTRAINT cart_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.cart_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: credit_line credit_line_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.credit_line
    ADD CONSTRAINT credit_line_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE;


--
-- Name: customer_address customer_address_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: customer_group_customer customer_group_customer_customer_group_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_customer_group_id_foreign FOREIGN KEY (customer_group_id) REFERENCES public.customer_group(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: customer_group_customer customer_group_customer_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment fulfillment_delivery_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_delivery_address_id_foreign FOREIGN KEY (delivery_address_id) REFERENCES public.fulfillment_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fulfillment_item fulfillment_item_fulfillment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.fulfillment_item
    ADD CONSTRAINT fulfillment_item_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment_label fulfillment_label_fulfillment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.fulfillment_label
    ADD CONSTRAINT fulfillment_label_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment fulfillment_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.fulfillment_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fulfillment fulfillment_shipping_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES public.shipping_option(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: geo_zone geo_zone_service_zone_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.geo_zone
    ADD CONSTRAINT geo_zone_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES public.service_zone(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: image image_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inventory_level inventory_level_inventory_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.inventory_level
    ADD CONSTRAINT inventory_level_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: notification notification_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.notification_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: order order_billing_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES public.order_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_change_action order_change_action_order_change_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_change_action
    ADD CONSTRAINT order_change_action_order_change_id_foreign FOREIGN KEY (order_change_id) REFERENCES public.order_change(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_change order_change_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_credit_line order_credit_line_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_credit_line
    ADD CONSTRAINT order_credit_line_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_item order_item_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_item order_item_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item_adjustment order_line_item_adjustment_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_line_item_adjustment
    ADD CONSTRAINT order_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item_tax_line order_line_item_tax_line_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_line_item_tax_line
    ADD CONSTRAINT order_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item order_line_item_totals_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_line_item
    ADD CONSTRAINT order_line_item_totals_id_foreign FOREIGN KEY (totals_id) REFERENCES public.order_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order order_shipping_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES public.order_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping_method_adjustment order_shipping_method_adjustment_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_shipping_method_adjustment
    ADD CONSTRAINT order_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.order_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping_method_tax_line order_shipping_method_tax_line_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_shipping_method_tax_line
    ADD CONSTRAINT order_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.order_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping order_shipping_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_shipping
    ADD CONSTRAINT order_shipping_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_summary order_summary_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_summary
    ADD CONSTRAINT order_summary_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_transaction order_transaction_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.order_transaction
    ADD CONSTRAINT order_transaction_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_payment_col_aa276_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_payment_col_aa276_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_payment_pro_2d555_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_payment_pro_2d555_foreign FOREIGN KEY (payment_provider_id) REFERENCES public.payment_provider(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment payment_payment_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_payment_collection_id_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_session payment_session_payment_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.payment_session
    ADD CONSTRAINT payment_session_payment_collection_id_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price_list_rule price_list_rule_price_list_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.price_list_rule
    ADD CONSTRAINT price_list_rule_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES public.price_list(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price price_price_list_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES public.price_list(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price price_price_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_price_set_id_foreign FOREIGN KEY (price_set_id) REFERENCES public.price_set(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price_rule price_rule_price_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.price_rule
    ADD CONSTRAINT price_rule_price_id_foreign FOREIGN KEY (price_id) REFERENCES public.price(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category product_category_parent_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_parent_category_id_foreign FOREIGN KEY (parent_category_id) REFERENCES public.product_category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category_product product_category_product_product_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_product_category_id_foreign FOREIGN KEY (product_category_id) REFERENCES public.product_category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category_product product_category_product_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product product_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_collection_id_foreign FOREIGN KEY (collection_id) REFERENCES public.product_collection(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: product_option product_option_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product_option
    ADD CONSTRAINT product_option_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_option_value product_option_value_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product_option_value
    ADD CONSTRAINT product_option_value_option_id_foreign FOREIGN KEY (option_id) REFERENCES public.product_option(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_tags product_tags_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_tags product_tags_product_tag_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_product_tag_id_foreign FOREIGN KEY (product_tag_id) REFERENCES public.product_tag(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product product_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_type_id_foreign FOREIGN KEY (type_id) REFERENCES public.product_type(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: product_variant_option product_variant_option_option_value_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_option_value_id_foreign FOREIGN KEY (option_value_id) REFERENCES public.product_option_value(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_variant_option product_variant_option_variant_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_variant_id_foreign FOREIGN KEY (variant_id) REFERENCES public.product_variant(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_variant product_variant_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT product_variant_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_application_method promotion_application_method_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.promotion_application_method
    ADD CONSTRAINT promotion_application_method_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_campaign_budget promotion_campaign_budget_campaign_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.promotion_campaign_budget
    ADD CONSTRAINT promotion_campaign_budget_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.promotion_campaign(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion promotion_campaign_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.promotion_campaign(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: promotion_promotion_rule promotion_promotion_rule_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_promotion_rule promotion_promotion_rule_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_rule_value promotion_rule_value_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.promotion_rule_value
    ADD CONSTRAINT promotion_rule_value_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: provider_identity provider_identity_auth_identity_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.provider_identity
    ADD CONSTRAINT provider_identity_auth_identity_id_foreign FOREIGN KEY (auth_identity_id) REFERENCES public.auth_identity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: refund refund_payment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT refund_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: region_country region_country_region_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.region_country
    ADD CONSTRAINT region_country_region_id_foreign FOREIGN KEY (region_id) REFERENCES public.region(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: reservation_item reservation_item_inventory_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.reservation_item
    ADD CONSTRAINT reservation_item_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: return_reason return_reason_parent_return_reason_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.return_reason
    ADD CONSTRAINT return_reason_parent_return_reason_id_foreign FOREIGN KEY (parent_return_reason_id) REFERENCES public.return_reason(id);


--
-- Name: service_zone service_zone_fulfillment_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.service_zone
    ADD CONSTRAINT service_zone_fulfillment_set_id_foreign FOREIGN KEY (fulfillment_set_id) REFERENCES public.fulfillment_set(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.fulfillment_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shipping_option_rule shipping_option_rule_shipping_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.shipping_option_rule
    ADD CONSTRAINT shipping_option_rule_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES public.shipping_option(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_service_zone_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES public.service_zone(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_shipping_option_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_shipping_option_type_id_foreign FOREIGN KEY (shipping_option_type_id) REFERENCES public.shipping_option_type(id) ON UPDATE CASCADE;


--
-- Name: shipping_option shipping_option_shipping_profile_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_shipping_profile_id_foreign FOREIGN KEY (shipping_profile_id) REFERENCES public.shipping_profile(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stock_location stock_location_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.stock_location
    ADD CONSTRAINT stock_location_address_id_foreign FOREIGN KEY (address_id) REFERENCES public.stock_location_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: store_currency store_currency_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: medusa_admin
--

ALTER TABLE ONLY public.store_currency
    ADD CONSTRAINT store_currency_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.store(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict PYvgSjTqfHOV1iVZ9vyTURM6jDT0wduDpveKp5fwm0rLy7KCg6Mox4nzRSrLvPs

