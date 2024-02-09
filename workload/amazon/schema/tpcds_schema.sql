create table customer_address
(
    ca_address_sk    integer  not null encode az64 distkey
        primary key,
    ca_address_id    char(16) not null,
    ca_street_number char(10),
    ca_street_name   varchar(60),
    ca_street_type   char(15),
    ca_suite_number  char(10),
    ca_city          varchar(60),
    ca_county        varchar(30),
    ca_state         char(2),
    ca_zip           char(10),
    ca_country       varchar(20),
    ca_gmt_offset    numeric(5, 2) encode az64,
    ca_location_type char(20)
)
    diststyle key;

create table customer_demographics
(
    cd_demo_sk            integer not null encode az64 distkey
        primary key,
    cd_gender             char,
    cd_marital_status     char,
    cd_education_status   char(20),
    cd_purchase_estimate  integer encode az64,
    cd_credit_rating      char(10),
    cd_dep_count          integer encode az64,
    cd_dep_employed_count integer encode az64,
    cd_dep_college_count  integer encode az64
)
    diststyle key;

create table date_dim
(
    d_date_sk           integer  not null encode az64
        primary key,
    d_date_id           char(16) not null,
    d_date              date     not null encode az64,
    d_month_seq         integer encode az64,
    d_week_seq          integer encode az64,
    d_quarter_seq       integer encode az64,
    d_year              integer encode az64,
    d_dow               integer encode az64,
    d_moy               integer encode az64,
    d_dom               integer encode az64,
    d_qoy               integer encode az64,
    d_fy_year           integer encode az64,
    d_fy_quarter_seq    integer encode az64,
    d_fy_week_seq       integer encode az64,
    d_day_name          char(9),
    d_quarter_name      char(6),
    d_holiday           char,
    d_weekend           char,
    d_following_holiday char,
    d_first_dom         integer encode az64,
    d_last_dom          integer encode az64,
    d_same_day_ly       integer encode az64,
    d_same_day_lq       integer encode az64,
    d_current_day       char,
    d_current_week      char,
    d_current_month     char,
    d_current_quarter   char,
    d_current_year      char
)
    diststyle all;

create table call_center
(
    cc_call_center_sk integer  not null encode az64
        primary key,
    cc_call_center_id char(16) not null,
    cc_rec_start_date date encode az64,
    cc_rec_end_date   date encode az64,
    cc_closed_date_sk integer encode az64
        constraint cc_d1
            references date_dim,
    cc_open_date_sk   integer encode az64
        constraint cc_d2
            references date_dim,
    cc_name           varchar(50),
    cc_class          varchar(50),
    cc_employees      integer encode az64,
    cc_sq_ft          integer encode az64,
    cc_hours          char(20),
    cc_manager        varchar(40),
    cc_mkt_id         integer encode az64,
    cc_mkt_class      char(50),
    cc_mkt_desc       varchar(100),
    cc_market_manager varchar(40),
    cc_division       integer encode az64,
    cc_division_name  varchar(50),
    cc_company        integer encode az64,
    cc_company_name   char(50),
    cc_street_number  char(10),
    cc_street_name    varchar(60),
    cc_street_type    char(15),
    cc_suite_number   char(10),
    cc_city           varchar(60),
    cc_county         varchar(30),
    cc_state          char(2),
    cc_zip            char(10),
    cc_country        varchar(20),
    cc_gmt_offset     numeric(5, 2) encode az64,
    cc_tax_percentage numeric(5, 2) encode az64
)
    diststyle all;

create table catalog_page
(
    cp_catalog_page_sk     integer  not null encode az64
        primary key,
    cp_catalog_page_id     char(16) not null,
    cp_start_date_sk       integer encode az64
        constraint cp_d2
            references date_dim,
    cp_end_date_sk         integer encode az64
        constraint cp_d1
            references date_dim,
    cp_department          varchar(50),
    cp_catalog_number      integer encode az64,
    cp_catalog_page_number integer encode az64,
    cp_description         varchar(100),
    cp_type                varchar(100)
)
    diststyle all;

create table income_band
(
    ib_income_band_sk integer not null encode az64
        primary key,
    ib_lower_bound    integer encode az64,
    ib_upper_bound    integer encode az64
)
    diststyle all;

create table household_demographics
(
    hd_demo_sk        integer not null encode az64
        primary key,
    hd_income_band_sk integer encode az64
        constraint hd_ib
            references income_band,
    hd_buy_potential  char(15),
    hd_dep_count      integer encode az64,
    hd_vehicle_count  integer encode az64
)
    diststyle all;

create table customer
(
    c_customer_sk          integer  not null encode az64 distkey
        primary key,
    c_customer_id          char(16) not null,
    c_current_cdemo_sk     integer encode az64
        constraint c_cd
            references customer_demographics,
    c_current_hdemo_sk     integer encode az64
        constraint c_hd
            references household_demographics,
    c_current_addr_sk      integer encode az64
        constraint c_a
            references customer_address,
    c_first_shipto_date_sk integer encode az64
        constraint c_fsd2
            references date_dim,
    c_first_sales_date_sk  integer encode az64
        constraint c_fsd
            references date_dim,
    c_salutation           char(10),
    c_first_name           char(20),
    c_last_name            char(30),
    c_preferred_cust_flag  char,
    c_birth_day            integer encode az64,
    c_birth_month          integer encode az64,
    c_birth_year           integer encode az64,
    c_birth_country        varchar(20),
    c_login                char(13),
    c_email_address        char(50),
    c_last_review_date_sk  integer encode az64
)
    diststyle key;

create table item
(
    i_item_sk        integer  not null encode az64 distkey
        primary key,
    i_item_id        char(16) not null,
    i_rec_start_date date encode az64,
    i_rec_end_date   date encode az64,
    i_item_desc      varchar(200),
    i_current_price  numeric(7, 2) encode az64,
    i_wholesale_cost numeric(7, 2) encode az64,
    i_brand_id       integer encode az64,
    i_brand          char(50),
    i_class_id       integer encode az64,
    i_class          char(50),
    i_category_id    integer encode az64,
    i_category       char(50),
    i_manufact_id    integer encode az64,
    i_manufact       char(50),
    i_size           char(20),
    i_formulation    char(20),
    i_color          char(20),
    i_units          char(10),
    i_container      char(10),
    i_manager_id     integer encode az64,
    i_product_name   char(50)
)
    diststyle key
    sortkey (i_category);

create table promotion
(
    p_promo_sk        integer  not null encode az64
        primary key,
    p_promo_id        char(16) not null,
    p_start_date_sk   integer encode az64
        constraint p_start_date
            references date_dim,
    p_end_date_sk     integer encode az64
        constraint p_end_date
            references date_dim,
    p_item_sk         integer encode az64
        constraint p_i
            references item,
    p_cost            numeric(15, 2) encode az64,
    p_response_target integer encode az64,
    p_promo_name      char(50),
    p_channel_dmail   char,
    p_channel_email   char,
    p_channel_catalog char,
    p_channel_tv      char,
    p_channel_radio   char,
    p_channel_press   char,
    p_channel_event   char,
    p_channel_demo    char,
    p_channel_details varchar(100),
    p_purpose         char(15),
    p_discount_active char
)
    diststyle all;

create table reason
(
    r_reason_sk   integer  not null encode az64
        primary key,
    r_reason_id   char(16) not null,
    r_reason_desc char(100)
)
    diststyle all;

create table ship_mode
(
    sm_ship_mode_sk integer  not null encode az64
        primary key,
    sm_ship_mode_id char(16) not null,
    sm_type         char(30),
    sm_code         char(10),
    sm_carrier      char(20),
    sm_contract     char(20)
)
    diststyle all;

create table store
(
    s_store_sk         integer  not null encode az64
        primary key,
    s_store_id         char(16) not null,
    s_rec_start_date   date encode az64,
    s_rec_end_date     date encode az64,
    s_closed_date_sk   integer encode az64
        constraint s_close_date
            references date_dim,
    s_store_name       varchar(50),
    s_number_employees integer encode az64,
    s_floor_space      integer encode az64,
    s_hours            char(20),
    s_manager          varchar(40),
    s_market_id        integer encode az64,
    s_geography_class  varchar(100),
    s_market_desc      varchar(100),
    s_market_manager   varchar(40),
    s_division_id      integer encode az64,
    s_division_name    varchar(50),
    s_company_id       integer encode az64,
    s_company_name     varchar(50),
    s_street_number    varchar(10),
    s_street_name      varchar(60),
    s_street_type      char(15),
    s_suite_number     char(10),
    s_city             varchar(60),
    s_county           varchar(30),
    s_state            char(2),
    s_zip              char(10),
    s_country          varchar(20),
    s_gmt_offset       numeric(5, 2) encode az64,
    s_tax_precentage   numeric(5, 2) encode az64
)
    diststyle all;

create table time_dim
(
    t_time_sk   integer  not null encode az64
        primary key,
    t_time_id   char(16) not null,
    t_time      integer  not null encode az64,
    t_hour      integer encode az64,
    t_minute    integer encode az64,
    t_second    integer encode az64,
    t_am_pm     char(2),
    t_shift     char(20),
    t_sub_shift char(20),
    t_meal_time char(20)
)
    diststyle all;

create table store_returns
(
    sr_returned_date_sk   integer
        constraint sr_ret_d
            references date_dim,
    sr_return_time_sk     integer encode az64
        constraint sr_t
            references time_dim,
    sr_item_sk            integer not null encode az64 distkey
        constraint sr_i
            references item,
    sr_customer_sk        integer encode az64
        constraint sr_c
            references customer,
    sr_cdemo_sk           integer encode az64
        constraint sr_cd
            references customer_demographics,
    sr_hdemo_sk           integer encode az64
        constraint sr_hd
            references household_demographics,
    sr_addr_sk            integer encode az64
        constraint sr_a
            references customer_address,
    sr_store_sk           integer encode az64
        constraint sr_s
            references store,
    sr_reason_sk          integer encode az64
        constraint sr_r
            references reason,
    sr_ticket_number      integer not null encode az64,
    sr_return_quantity    integer encode az64,
    sr_return_amt         
    (7, 2) encode az64,
    sr_return_tax         numeric(7, 2) encode az64,
    sr_return_amt_inc_tax numeric(7, 2) encode az64,
    sr_fee                numeric(7, 2) encode az64,
    sr_return_ship_cost   numeric(7, 2) encode az64,
    sr_refunded_cash      numeric(7, 2) encode az64,
    sr_reversed_charge    numeric(7, 2) encode az64,
    sr_store_credit       numeric(7, 2) encode az64,
    sr_net_loss           numeric(7, 2) encode az64,
    primary key (sr_item_sk, sr_ticket_number)
)
    diststyle key
    sortkey (sr_returned_date_sk);

create table store_sales
(
    ss_sold_date_sk       integer
        constraint ss_d
            references date_dim,
    ss_sold_time_sk       integer encode az64
        constraint ss_t
            references time_dim,
    ss_item_sk            integer not null encode az64 distkey
        constraint ss_i
            references item,
    ss_customer_sk        integer encode az64
        constraint ss_c
            references customer,
    ss_cdemo_sk           integer encode az64
        constraint ss_cd
            references customer_demographics,
    ss_hdemo_sk           integer encode az64
        constraint ss_hd
            references household_demographics,
    ss_addr_sk            integer encode az64
        constraint ss_a
            references customer_address,
    ss_store_sk           integer encode az64
        constraint ss_s
            references store,
    ss_promo_sk           integer encode az64
        constraint ss_p
            references promotion,
    ss_ticket_number      integer not null encode az64,
    ss_quantity           integer encode az64,
    ss_wholesale_cost     numeric(7, 2) encode az64,
    ss_list_price         numeric(7, 2) encode az64,
    ss_sales_price        numeric(7, 2) encode az64,
    ss_ext_discount_amt   numeric(7, 2) encode az64,
    ss_ext_sales_price    numeric(7, 2) encode az64,
    ss_ext_wholesale_cost numeric(7, 2) encode az64,
    ss_ext_list_price     numeric(7, 2) encode az64,
    ss_ext_tax            numeric(7, 2) encode az64,
    ss_coupon_amt         numeric(7, 2) encode az64,
    ss_net_paid           numeric(7, 2) encode az64,
    ss_net_paid_inc_tax   numeric(7, 2) encode az64,
    ss_net_profit         numeric(7, 2) encode az64,
    primary key (ss_item_sk, ss_ticket_number)
)
    diststyle key
    sortkey (ss_sold_date_sk);

create table warehouse
(
    w_warehouse_sk    integer  not null encode az64
        primary key,
    w_warehouse_id    char(16) not null,
    w_warehouse_name  varchar(20),
    w_warehouse_sq_ft integer encode az64,
    w_street_number   char(10),
    w_street_name     varchar(60),
    w_street_type     char(15),
    w_suite_number    char(10),
    w_city            varchar(60),
    w_county          varchar(30),
    w_state           char(2),
    w_zip             char(10),
    w_country         varchar(20),
    w_gmt_offset      numeric(5, 2) encode az64
)
    diststyle all;

create table catalog_returns
(
    cr_returned_date_sk      integer
        constraint cr_d1
            references date_dim,
    cr_returned_time_sk      integer encode az64
        constraint cr_t
            references time_dim,
    cr_item_sk               integer not null encode az64 distkey
        constraint cr_i
            references item,
    cr_refunded_customer_sk  integer encode az64
        constraint cr_c1
            references customer,
    cr_refunded_cdemo_sk     integer encode az64
        constraint cr_cd1
            references customer_demographics,
    cr_refunded_hdemo_sk     integer encode az64
        constraint cr_hd1
            references household_demographics,
    cr_refunded_addr_sk      integer encode az64
        constraint cr_a1
            references customer_address,
    cr_returning_customer_sk integer encode az64
        constraint cr_c2
            references customer,
    cr_returning_cdemo_sk    integer encode az64
        constraint cr_cd2
            references customer_demographics,
    cr_returning_hdemo_sk    integer encode az64
        constraint cr_hd2
            references household_demographics,
    cr_returning_addr_sk     integer encode az64
        constraint cr_a2
            references customer_address,
    cr_call_center_sk        integer encode az64
        constraint cr_cc
            references call_center,
    cr_catalog_page_sk       integer encode az64
        constraint cr_cp
            references catalog_page,
    cr_ship_mode_sk          integer encode az64
        constraint cr_sm
            references ship_mode,
    cr_warehouse_sk          integer encode az64
        constraint cr_w2
            references warehouse,
    cr_reason_sk             integer encode az64
        constraint cr_r
            references reason,
    cr_order_number          integer not null encode az64,
    cr_return_quantity       integer encode az64,
    cr_return_amount         numeric(7, 2) encode az64,
    cr_return_tax            numeric(7, 2) encode az64,
    cr_return_amt_inc_tax    numeric(7, 2) encode az64,
    cr_fee                   numeric(7, 2) encode az64,
    cr_return_ship_cost      numeric(7, 2) encode az64,
    cr_refunded_cash         numeric(7, 2) encode az64,
    cr_reversed_charge       numeric(7, 2) encode az64,
    cr_store_credit          numeric(7, 2) encode az64,
    cr_net_loss              numeric(7, 2) encode az64,
    primary key (cr_item_sk, cr_order_number)
)
    diststyle key
    sortkey (cr_returned_date_sk);

create table catalog_sales
(
    cs_sold_date_sk          integer
        constraint cs_d2
            references date_dim,
    cs_sold_time_sk          integer encode az64
        constraint cs_t
            references time_dim,
    cs_ship_date_sk          integer encode az64
        constraint cs_d1
            references date_dim,
    cs_bill_customer_sk      integer encode az64
        constraint cs_b_c
            references customer,
    cs_bill_cdemo_sk         integer encode az64
        constraint cs_b_cd
            references customer_demographics,
    cs_bill_hdemo_sk         integer encode az64
        constraint cs_b_hd
            references household_demographics,
    cs_bill_addr_sk          integer encode az64
        constraint cs_b_a
            references customer_address,
    cs_ship_customer_sk      integer encode az64
        constraint cs_s_c
            references customer,
    cs_ship_cdemo_sk         integer encode az64
        constraint cs_s_cd
            references customer_demographics,
    cs_ship_hdemo_sk         integer encode az64
        constraint cs_s_hd
            references household_demographics,
    cs_ship_addr_sk          integer encode az64
        constraint cs_s_a
            references customer_address,
    cs_call_center_sk        integer encode az64
        constraint cs_cc
            references call_center,
    cs_catalog_page_sk       integer encode az64
        constraint cs_cp
            references catalog_page,
    cs_ship_mode_sk          integer encode az64
        constraint cs_sm
            references ship_mode,
    cs_warehouse_sk          integer encode az64
        constraint cs_w
            references warehouse,
    cs_item_sk               integer not null encode az64 distkey
        constraint cs_i
            references item,
    cs_promo_sk              integer encode az64
        constraint cs_p
            references promotion,
    cs_order_number          integer not null encode az64,
    cs_quantity              integer encode az64,
    cs_wholesale_cost        numeric(7, 2) encode az64,
    cs_list_price            numeric(7, 2) encode az64,
    cs_sales_price           numeric(7, 2) encode az64,
    cs_ext_discount_amt      numeric(7, 2) encode az64,
    cs_ext_sales_price       numeric(7, 2) encode az64,
    cs_ext_wholesale_cost    numeric(7, 2) encode az64,
    cs_ext_list_price        numeric(7, 2) encode az64,
    cs_ext_tax               numeric(7, 2) encode az64,
    cs_coupon_amt            numeric(7, 2) encode az64,
    cs_ext_ship_cost         numeric(7, 2) encode az64,
    cs_net_paid              numeric(7, 2) encode az64,
    cs_net_paid_inc_tax      numeric(7, 2) encode az64,
    cs_net_paid_inc_ship     numeric(7, 2) encode az64,
    cs_net_paid_inc_ship_tax numeric(7, 2) encode az64,
    cs_net_profit            numeric(7, 2) encode az64,
    primary key (cs_item_sk, cs_order_number)
)
    diststyle key
    sortkey (cs_sold_date_sk);

create table inventory
(
    inv_date_sk          integer not null
        constraint inv_d
            references date_dim,
    inv_item_sk          integer not null encode az64 distkey
        constraint inv_i
            references item,
    inv_warehouse_sk     integer not null encode az64
        constraint inv_w
            references warehouse,
    inv_quantity_on_hand integer encode az64,
    primary key (inv_date_sk, inv_item_sk, inv_warehouse_sk)
)
    diststyle key
    sortkey (inv_date_sk);

create table web_page
(
    wp_web_page_sk      integer  not null encode az64
        primary key,
    wp_web_page_id      char(16) not null,
    wp_rec_start_date   date encode az64,
    wp_rec_end_date     date encode az64,
    wp_creation_date_sk integer encode az64
        constraint wp_cd
            references date_dim,
    wp_access_date_sk   integer encode az64
        constraint wp_ad
            references date_dim,
    wp_autogen_flag     char,
    wp_customer_sk      integer encode az64,
    wp_url              varchar(100),
    wp_type             char(50),
    wp_char_count       integer encode az64,
    wp_link_count       integer encode az64,
    wp_image_count      integer encode az64,
    wp_max_ad_count     integer encode az64
)
    diststyle all;

create table web_returns
(
    wr_returned_date_sk      integer
        constraint wr_ret_d
            references date_dim,
    wr_returned_time_sk      integer encode az64
        constraint wr_ret_t
            references time_dim,
    wr_item_sk               integer not null encode az64
        constraint wr_i
            references item,
    wr_refunded_customer_sk  integer encode az64
        constraint wr_ref_c
            references customer,
    wr_refunded_cdemo_sk     integer encode az64
        constraint wr_ref_cd
            references customer_demographics,
    wr_refunded_hdemo_sk     integer encode az64
        constraint wr_ref_hd
            references household_demographics,
    wr_refunded_addr_sk      integer encode az64
        constraint wr_ref_a
            references customer_address,
    wr_returning_customer_sk integer encode az64
        constraint wr_ret_c
            references customer,
    wr_returning_cdemo_sk    integer encode az64
        constraint wr_ret_cd
            references customer_demographics,
    wr_returning_hdemo_sk    integer encode az64
        constraint wr_ret_hd
            references household_demographics,
    wr_returning_addr_sk     integer encode az64
        constraint wr_ret_a
            references customer_address,
    wr_web_page_sk           integer encode az64
        constraint wr_wp
            references web_page,
    wr_reason_sk             integer encode az64
        constraint wr_r
            references reason,
    wr_order_number          integer not null encode az64 distkey,
    wr_return_quantity       integer encode az64,
    wr_return_amt            numeric(7, 2) encode az64,
    wr_return_tax            numeric(7, 2) encode az64,
    wr_return_amt_inc_tax    numeric(7, 2) encode az64,
    wr_fee                   numeric(7, 2) encode az64,
    wr_return_ship_cost      numeric(7, 2) encode az64,
    wr_refunded_cash         numeric(7, 2) encode az64,
    wr_reversed_charge       numeric(7, 2) encode az64,
    wr_account_credit        numeric(7, 2) encode az64,
    wr_net_loss              numeric(7, 2) encode az64,
    primary key (wr_item_sk, wr_order_number)
)
    diststyle key
    sortkey (wr_returned_date_sk);

create table web_site
(
    web_site_sk        integer  not null encode az64
        primary key,
    web_site_id        char(16) not null,
    web_rec_start_date date encode az64,
    web_rec_end_date   date encode az64,
    web_name           varchar(50),
    web_open_date_sk   integer encode az64
        constraint web_d2
            references date_dim,
    web_close_date_sk  integer encode az64
        constraint web_d1
            references date_dim,
    web_class          varchar(50),
    web_manager        varchar(40),
    web_mkt_id         integer encode az64,
    web_mkt_class      varchar(50),
    web_mkt_desc       varchar(100),
    web_market_manager varchar(40),
    web_company_id     integer encode az64,
    web_company_name   char(50),
    web_street_number  char(10),
    web_street_name    varchar(60),
    web_street_type    char(15),
    web_suite_number   char(10),
    web_city           varchar(60),
    web_county         varchar(30),
    web_state          char(2),
    web_zip            char(10),
    web_country        varchar(20),
    web_gmt_offset     numeric(5, 2) encode az64,
    web_tax_percentage numeric(5, 2) encode az64
)
    diststyle all;

create table web_sales
(
    ws_sold_date_sk          integer
        constraint ws_d2
            references date_dim,
    ws_sold_time_sk          integer encode az64
        constraint ws_t
            references time_dim,
    ws_ship_date_sk          integer encode az64
        constraint ws_s_d
            references date_dim,
    ws_item_sk               integer not null encode az64
        constraint ws_i
            references item,
    ws_bill_customer_sk      integer encode az64
        constraint ws_b_c
            references customer,
    ws_bill_cdemo_sk         integer encode az64
        constraint ws_b_cd
            references customer_demographics,
    ws_bill_hdemo_sk         integer encode az64
        constraint ws_b_cd2
            references household_demographics,
    ws_bill_addr_sk          integer encode az64
        constraint ws_b_a
            references customer_address,
    ws_ship_customer_sk      integer encode az64
        constraint ws_s_c
            references customer,
    ws_ship_cdemo_sk         integer encode az64
        constraint ws_s_cd
            references customer_demographics,
    ws_ship_hdemo_sk         integer encode az64
        constraint ws_s_hd
            references household_demographics,
    ws_ship_addr_sk          integer encode az64
        constraint ws_s_a
            references customer_address,
    ws_web_page_sk           integer encode az64
        constraint ws_wp
            references web_page,
    ws_web_site_sk           integer encode az64
        constraint ws_ws
            references web_site,
    ws_ship_mode_sk          integer encode az64
        constraint ws_sm
            references ship_mode,
    ws_warehouse_sk          integer encode az64
        constraint ws_w2
            references warehouse,
    ws_promo_sk              integer encode az64
        constraint ws_p
            references promotion,
    ws_order_number          integer not null encode az64 distkey,
    ws_quantity              integer encode az64,
    ws_wholesale_cost        numeric(7, 2) encode az64,
    ws_list_price            numeric(7, 2) encode az64,
    ws_sales_price           numeric(7, 2) encode az64,
    ws_ext_discount_amt      numeric(7, 2) encode az64,
    ws_ext_sales_price       numeric(7, 2) encode az64,
    ws_ext_wholesale_cost    numeric(7, 2) encode az64,
    ws_ext_list_price        numeric(7, 2) encode az64,
    ws_ext_tax               numeric(7, 2) encode az64,
    ws_coupon_amt            numeric(7, 2) encode az64,
    ws_ext_ship_cost         numeric(7, 2) encode az64,
    ws_net_paid              numeric(7, 2) encode az64,
    ws_net_paid_inc_tax      numeric(7, 2) encode az64,
    ws_net_paid_inc_ship     numeric(7, 2) encode az64,
    ws_net_paid_inc_ship_tax numeric(7, 2) encode az64,
    ws_net_profit            numeric(7, 2) encode az64,
    primary key (ws_item_sk, ws_order_number)
)
    diststyle key
    sortkey (ws_sold_date_sk);

create table catalog_returns_2
(
    cr_returned_date_sk      integer encode az64
        constraint cr_d1
            references date_dim,
    cr_returned_time_sk      integer encode az64
        constraint cr_t
            references time_dim,
    cr_item_sk               integer not null encode az64 distkey
        constraint cr_i
            references item,
    cr_refunded_customer_sk  integer encode az64
        constraint cr_c1
            references customer,
    cr_refunded_cdemo_sk     integer encode az64
        constraint cr_cd1
            references customer_demographics,
    cr_refunded_hdemo_sk     integer encode az64
        constraint cr_hd1
            references household_demographics,
    cr_refunded_addr_sk      integer encode az64
        constraint cr_a1
            references customer_address,
    cr_returning_customer_sk integer encode az64
        constraint cr_c2
            references customer,
    cr_returning_cdemo_sk    integer encode az64
        constraint cr_cd2
            references customer_demographics,
    cr_returning_hdemo_sk    integer encode az64
        constraint cr_hd2
            references household_demographics,
    cr_returning_addr_sk     integer encode az64
        constraint cr_a2
            references customer_address,
    cr_call_center_sk        integer encode az64
        constraint cr_cc
            references call_center,
    cr_catalog_page_sk       integer encode az64
        constraint cr_cp
            references catalog_page,
    cr_ship_mode_sk          integer encode az64
        constraint cr_sm
            references ship_mode,
    cr_warehouse_sk          integer encode az64
        constraint cr_w2
            references warehouse,
    cr_reason_sk             integer encode az64
        constraint cr_r
            references reason,
    cr_order_number          integer not null encode az64,
    cr_return_quantity       integer encode az64,
    cr_return_amount         numeric(7, 2) encode az64,
    cr_return_tax            numeric(7, 2) encode az64,
    cr_return_amt_inc_tax    numeric(7, 2) encode az64,
    cr_fee                   numeric(7, 2) encode az64,
    cr_return_ship_cost      numeric(7, 2) encode az64,
    cr_refunded_cash         numeric(7, 2) encode az64,
    cr_reversed_charge       numeric(7, 2) encode az64,
    cr_store_credit          numeric(7, 2) encode az64,
    cr_net_loss              numeric(7, 2) encode az64,
    primary key (cr_item_sk, cr_order_number)
)
    diststyle key;
