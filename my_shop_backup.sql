--
-- PostgreSQL database dump
--

\restrict qUsEmReWPN9e3KFaVRz93BzTL3hhohpqBBa9Gy5RJG0Y16HdyPdw8tIihfLotKh

-- Dumped from database version 14.20 (Homebrew)
-- Dumped by pg_dump version 14.20 (Homebrew)

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
-- Name: Order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Order" (
    order_id integer NOT NULL,
    customer_id integer NOT NULL,
    employee_id integer,
    order_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    total_amount numeric(10,2) NOT NULL,
    status character varying(20) DEFAULT 'new'::character varying,
    CONSTRAINT "Order_total_amount_check" CHECK ((total_amount >= (0)::numeric))
);


ALTER TABLE public."Order" OWNER TO postgres;

--
-- Name: Order_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Order_order_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Order_order_id_seq" OWNER TO postgres;

--
-- Name: Order_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Order_order_id_seq" OWNED BY public."Order".order_id;


--
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    category_id integer NOT NULL,
    category_name character varying(100) NOT NULL,
    description text
);


ALTER TABLE public.category OWNER TO postgres;

--
-- Name: category_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.category_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.category_category_id_seq OWNER TO postgres;

--
-- Name: category_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.category_category_id_seq OWNED BY public.category.category_id;


--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    customer_id integer NOT NULL,
    full_name character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(20),
    address text
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- Name: customer_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_customer_id_seq OWNER TO postgres;

--
-- Name: customer_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customer_customer_id_seq OWNED BY public.customer.customer_id;


--
-- Name: employee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee (
    employee_id integer NOT NULL,
    full_name character varying(100) NOT NULL,
    "position" character varying(50),
    email character varying(255)
);


ALTER TABLE public.employee OWNER TO postgres;

--
-- Name: employee_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_employee_id_seq OWNER TO postgres;

--
-- Name: employee_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_employee_id_seq OWNED BY public.employee.employee_id;


--
-- Name: manufacturer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.manufacturer (
    manufacturer_id integer NOT NULL,
    manufacturer_name character varying(100) NOT NULL,
    country character varying(50)
);


ALTER TABLE public.manufacturer OWNER TO postgres;

--
-- Name: manufacturer_manufacturer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.manufacturer_manufacturer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.manufacturer_manufacturer_id_seq OWNER TO postgres;

--
-- Name: manufacturer_manufacturer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.manufacturer_manufacturer_id_seq OWNED BY public.manufacturer.manufacturer_id;


--
-- Name: orderitem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orderitem (
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    CONSTRAINT orderitem_quantity_check CHECK ((quantity > 0)),
    CONSTRAINT orderitem_unit_price_check CHECK ((unit_price >= (0)::numeric))
);


ALTER TABLE public.orderitem OWNER TO postgres;

--
-- Name: payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment (
    payment_id integer NOT NULL,
    order_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    payment_method character varying(50),
    payment_status character varying(20) DEFAULT 'pending'::character varying,
    CONSTRAINT payment_amount_check CHECK ((amount > (0)::numeric))
);


ALTER TABLE public.payment OWNER TO postgres;

--
-- Name: payment_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payment_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payment_payment_id_seq OWNER TO postgres;

--
-- Name: payment_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payment_payment_id_seq OWNED BY public.payment.payment_id;


--
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    product_id integer NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    price numeric(10,2) NOT NULL,
    manufacturer_id integer,
    category_id integer,
    CONSTRAINT product_price_check CHECK ((price > (0)::numeric))
);


ALTER TABLE public.product OWNER TO postgres;

--
-- Name: product_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_product_id_seq OWNER TO postgres;

--
-- Name: product_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_product_id_seq OWNED BY public.product.product_id;


--
-- Name: review; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review (
    review_id integer NOT NULL,
    customer_id integer NOT NULL,
    product_id integer NOT NULL,
    rating integer NOT NULL,
    review_text text,
    review_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT review_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.review OWNER TO postgres;

--
-- Name: review_review_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.review_review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.review_review_id_seq OWNER TO postgres;

--
-- Name: review_review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.review_review_id_seq OWNED BY public.review.review_id;


--
-- Name: warehouse; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.warehouse (
    employee_id integer NOT NULL,
    product_id integer NOT NULL,
    stock_quantity integer DEFAULT 0 NOT NULL,
    CONSTRAINT warehouse_stock_quantity_check CHECK ((stock_quantity >= 0))
);


ALTER TABLE public.warehouse OWNER TO postgres;

--
-- Name: Order order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Order" ALTER COLUMN order_id SET DEFAULT nextval('public."Order_order_id_seq"'::regclass);


--
-- Name: category category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category ALTER COLUMN category_id SET DEFAULT nextval('public.category_category_id_seq'::regclass);


--
-- Name: customer customer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer ALTER COLUMN customer_id SET DEFAULT nextval('public.customer_customer_id_seq'::regclass);


--
-- Name: employee employee_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee ALTER COLUMN employee_id SET DEFAULT nextval('public.employee_employee_id_seq'::regclass);


--
-- Name: manufacturer manufacturer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manufacturer ALTER COLUMN manufacturer_id SET DEFAULT nextval('public.manufacturer_manufacturer_id_seq'::regclass);


--
-- Name: payment payment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment ALTER COLUMN payment_id SET DEFAULT nextval('public.payment_payment_id_seq'::regclass);


--
-- Name: product product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product ALTER COLUMN product_id SET DEFAULT nextval('public.product_product_id_seq'::regclass);


--
-- Name: review review_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review ALTER COLUMN review_id SET DEFAULT nextval('public.review_review_id_seq'::regclass);


--
-- Data for Name: Order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Order" (order_id, customer_id, employee_id, order_date, total_amount, status) FROM stdin;
1	1	1	2025-12-11 19:22:38.141153	89999.99	completed
2	2	1	2025-12-11 19:22:38.141153	2500.00	processing
58	1	1	2025-12-11 21:24:57.006294	149999.99	completed
59	2	2	2025-12-11 21:24:57.006294	129999.99	shipped
60	3	3	2025-12-11 21:24:57.006294	89999.99	processing
61	4	4	2025-12-11 21:24:57.006294	349999.99	new
62	5	5	2025-12-11 21:24:57.006294	199999.99	completed
63	6	6	2025-12-11 21:24:57.006294	149999.99	shipped
64	7	7	2025-12-11 21:24:57.006294	129999.99	processing
65	8	8	2025-12-11 21:24:57.006294	109999.99	completed
66	9	9	2025-12-11 21:24:57.006294	79999.99	new
67	10	10	2025-12-11 21:24:57.006294	69999.99	completed
68	6	1	2025-12-11 21:24:57.006294	89999.99	shipped
69	3	2	2025-12-11 21:24:57.006294	29999.99	processing
70	1	3	2025-12-11 21:24:57.006294	24999.99	completed
71	2	4	2025-12-11 21:24:57.006294	12999.99	new
72	3	5	2025-12-11 21:24:57.006294	5999.99	completed
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category (category_id, category_name, description) FROM stdin;
6	Смартфоны	Мобильные телефоны и коммуникаторы
7	Ноутбуки	Портативные компьютеры
8	Планшеты	Планшетные компьютеры
9	Умные часы	Смарт-часы и фитнес-браслеты
10	Аксессуары	Чехлы, наушники, зарядные устройства
1	Смартфоны	Мобильные телефоны и коммуникаторы
2	Ноутбуки	Портативные компьютеры
3	Планшеты	Планшетные компьютеры
4	Умные часы	Смарт-часы и фитнес-браслеты
5	Аксессуары	Чехлы, наушники, зарядные устройства
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer (customer_id, full_name, email, phone, address) FROM stdin;
1	Иванов Иван Иванович	test@mail.ru	79091119911	Волгоград, ул. Мира, д. 19
2	Петров Петр Петрович	test232124@mail.ru	79999999911	Москва, ул. Ленина, д. 15
3	Ольгина Ольга Ольговна	petrova@yandex.ru	+79169876543	Санкт-Петербург, пр. Невский, д. 1
4	Новиков Дмитрий Андреевич	novikov@yandex.ru	+79163334455	Новосибирск, Красный пр. 20
5	Федорова Анна Викторовна	fedorova@gmail.com	+79164445566	Ростов-на-Дону, ул. Большая Садовая 25
6	Морозов Сергей Николаевич	morozov@mail.ru	+79165556677	Краснодар, ул. Красная 30
7	Захарова Екатерина Павловна	zaharova@yandex.ru	+79166667788	Владивосток, ул. Светланская 35
8	Ковалев Артем Игоревич	kovalev@gmail.com	+79167778899	Сочи, ул. Навагинская 40
9	Григорьева Наталья Олеговна	grigorieva@mail.ru	+79168889900	Уфа, ул. Ленина 45
10	Лебедев Михаил Андреевич	lebedev@yandex.ru	+79169990011	Пермь, ул. Попова 50
11	Соколова Татьяна Владимировна	sokolova@gmail.com	+79160001122	Волгоград, пр. Ленина 55
\.


--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee (employee_id, full_name, "position", email) FROM stdin;
1	Сидоров Алексей Петрович	Менеджер по продажам	sidorov@company.ru
2	Козлова Ольга Ивановна	Кладовщик	kozlova@company.ru
6	Попов Александр Сергеевич	Менеджер	popov@digitalshop.ru
7	Васильева Ирина Михайловна	Консультант	vasilyeva@digitalshop.ru
8	Фролов Павел Дмитриевич	Технический специалист	frolov@digitalshop.ru
9	Андреева Елена Викторовна	Кассир	andreeva@digitalshop.ru
10	Тихонов Владимир Ильич	Курьер	tikhonov@digitalshop.ru
11	Семенова Ольга Петровна	Администратор	semenova@digitalshop.ru
12	Макаров Игорь Николаевич	Менеджер по закупкам	makarov@digitalshop.ru
3	Кузьмина Анна Сергеевна	Бухгалтер	kuzmina@digitalshop.ru
4	Борисов Алексей Владимирович	Системный администратор	borisov@digitalshop.ru
5	Орлова Марина Александровна	Маркетолог	orlova@digitalshop.ru
\.


--
-- Data for Name: manufacturer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.manufacturer (manufacturer_id, manufacturer_name, country) FROM stdin;
1	Apple	США
2	Эксмо	Россия
3	Nike	США
6	Apple	США
7	Samsung	Южная Корея
8	Xiaomi	Китай
9	Huawei	Китай
10	Asus	Тайвань
11	Lenovo	Китай
12	Garmin	США
13	JBL	США
4	Apple2	США2
5	Samsung2	Южная Корея2
\.


--
-- Data for Name: orderitem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orderitem (order_id, product_id, quantity, unit_price) FROM stdin;
1	1	1	89999.99
2	2	1	2500.00
58	3	1	89999.99
59	4	1	349999.99
60	5	1	199999.99
61	6	1	149999.99
62	7	1	129999.99
63	8	1	109999.99
64	9	1	79999.99
65	10	1	69999.99
66	11	1	89999.99
67	12	1	29999.99
68	13	1	24999.99
69	14	1	12999.99
70	2	1	5999.99
71	13	1	24999.99
72	14	1	12999.99
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment (payment_id, order_id, amount, payment_method, payment_status) FROM stdin;
1	1	89999.99	credit_card	paid
2	2	2500.00	cash	pending
18	58	89999.99	cash	pending
19	59	349999.99	bank_transfer	processing
20	60	199999.99	credit_card	paid
21	61	149999.99	online	paid
22	62	129999.99	cash	pending
23	63	109999.99	credit_card	paid
24	64	79999.99	online	paid
25	65	69999.99	cash	pending
26	66	89999.99	credit_card	paid
27	67	29999.99	online	paid
28	68	24999.99	cash	pending
29	69	12999.99	credit_card	paid
30	70	5999.99	online	paid
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product (product_id, name, description, price, manufacturer_id, category_id) FROM stdin;
3	Xiaomi 14 Pro	Флагманский смартфон с камерой Leica	89999.99	3	1
1	iPhone 15	Смартфон Apple	89999.99	1	6
2	Умные часы подделка	Умные часы как оригинал	2500.00	2	9
4	MacBook Pro 16" M3 Max	Ноутбук Apple с чипом M3 Max, 36GB RAM	349999.99	1	2
5	ASUS ROG Zephyrus G16	Игровой ноутбук с RTX 4070	199999.99	5	2
6	Lenovo Yoga 9i	Ноутбук-трансформер с OLED-экраном	149999.99	6	2
7	iPad Pro 12.9" M2	Планшет Apple с дисплеем Liquid Retina XDR	129999.99	1	3
8	Samsung Galaxy Tab S9 Ultra	Планшет с AMOLED экраном 14.6"	109999.99	2	3
9	Huawei MatePad Pro	Планшет с гармонией OS и экраном 12.6"	79999.99	4	3
10	Apple Watch Ultra 2	Умные часы для экстремальных условий	69999.99	1	4
11	Garmin Fenix 7X Pro	Спортивные умные часы с GPS	89999.99	7	4
12	Samsung Galaxy Watch 6	Умные часы с Wear OS	29999.99	2	4
13	AirPods Pro 2	Наушники с активным шумоподавлением	24999.99	1	5
14	JBL Charge 5	Портативная колонка с защитой IP67	12999.99	8	5
15	iPhone 17 Pro Max	super new, super fast	180000.00	1	1
56	iPhone 100 Pro	test	990000.00	1	1
\.


--
-- Data for Name: review; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.review (review_id, customer_id, product_id, rating, review_text, review_date) FROM stdin;
1	1	1	5	Отличный телефон, быстрая доставка	2025-12-11 19:22:38.19048
2	2	2	4	Хорошее издание, но мелковат шрифт	2025-12-11 19:22:38.19048
48	1	1	5	Отличный телефон! Камера просто супер.	2025-12-11 21:31:31.088176
49	2	2	4	Хороший смартфон, но быстро садится батарея.	2025-12-11 21:31:31.088176
50	3	3	5	Лучшее соотношение цены и качества!	2025-12-11 21:31:31.088176
51	4	4	5	Мощный ноутбук для работы и игр.	2025-12-11 21:31:31.088176
52	5	5	5	Игры летают на максималках!	2025-12-11 21:31:31.088176
53	6	6	4	Удобный трансформер, но тяжеловат.	2025-12-11 21:31:31.088176
54	7	7	5	Лучший планшет на рынке!	2025-12-11 21:31:31.088176
55	8	8	4	Отличный экран, но мало приложений.	2025-12-11 21:31:31.088176
56	9	9	3	Нормальный планшет, но есть тормоза.	2025-12-11 21:31:31.088176
57	10	10	5	Часы выдерживают всё! Плавал, бегал - работает.	2025-12-11 21:31:31.088176
58	11	11	5	Для спорта - лучшие часы!	2025-12-11 21:31:31.088176
59	3	12	4	Стильные часы, но автономность слабая.	2025-12-11 21:31:31.088176
60	1	13	5	Шумоподавление на высоте!	2025-12-11 21:31:31.088176
61	2	14	4	Громкая колонка, заряда хватает надолго.	2025-12-11 21:31:31.088176
62	3	6	5	Удобная беспроводная зарядка.	2025-12-11 21:31:31.088176
\.


--
-- Data for Name: warehouse; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.warehouse (employee_id, product_id, stock_quantity) FROM stdin;
2	1	50
2	2	200
3	1	25
3	2	30
3	3	50
3	4	10
3	5	15
3	6	20
3	7	35
3	8	40
3	9	45
3	10	30
3	11	25
3	12	50
3	13	100
3	14	80
\.


--
-- Name: Order_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Order_order_id_seq"', 72, true);


--
-- Name: category_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.category_category_id_seq', 10, true);


--
-- Name: customer_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customer_customer_id_seq', 11, true);


--
-- Name: employee_employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_employee_id_seq', 15, true);


--
-- Name: manufacturer_manufacturer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.manufacturer_manufacturer_id_seq', 2, true);


--
-- Name: payment_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payment_payment_id_seq', 30, true);


--
-- Name: product_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_product_id_seq', 56, true);


--
-- Name: review_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.review_review_id_seq', 62, true);


--
-- Name: Order Order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Order"
    ADD CONSTRAINT "Order_pkey" PRIMARY KEY (order_id);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (category_id);


--
-- Name: customer customer_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_email_key UNIQUE (email);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);


--
-- Name: employee employee_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_email_key UNIQUE (email);


--
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (employee_id);


--
-- Name: manufacturer manufacturer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manufacturer
    ADD CONSTRAINT manufacturer_pkey PRIMARY KEY (manufacturer_id);


--
-- Name: orderitem orderitem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderitem
    ADD CONSTRAINT orderitem_pkey PRIMARY KEY (order_id, product_id);


--
-- Name: payment payment_order_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_order_id_key UNIQUE (order_id);


--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (payment_id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product_id);


--
-- Name: review review_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_pkey PRIMARY KEY (review_id);


--
-- Name: warehouse warehouse_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warehouse
    ADD CONSTRAINT warehouse_pkey PRIMARY KEY (employee_id, product_id);


--
-- Name: Order Order_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Order"
    ADD CONSTRAINT "Order_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- Name: Order Order_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Order"
    ADD CONSTRAINT "Order_employee_id_fkey" FOREIGN KEY (employee_id) REFERENCES public.employee(employee_id);


--
-- Name: orderitem orderitem_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderitem
    ADD CONSTRAINT orderitem_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."Order"(order_id);


--
-- Name: orderitem orderitem_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderitem
    ADD CONSTRAINT orderitem_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(product_id);


--
-- Name: payment payment_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."Order"(order_id);


--
-- Name: product product_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.category(category_id);


--
-- Name: product product_manufacturer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_manufacturer_id_fkey FOREIGN KEY (manufacturer_id) REFERENCES public.manufacturer(manufacturer_id);


--
-- Name: review review_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- Name: review review_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(product_id);


--
-- Name: warehouse warehouse_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warehouse
    ADD CONSTRAINT warehouse_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employee(employee_id);


--
-- Name: warehouse warehouse_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warehouse
    ADD CONSTRAINT warehouse_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(product_id);


--
-- PostgreSQL database dump complete
--

\unrestrict qUsEmReWPN9e3KFaVRz93BzTL3hhohpqBBa9Gy5RJG0Y16HdyPdw8tIihfLotKh

