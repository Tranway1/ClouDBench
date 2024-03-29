create table tpcds_1.customer_address
(
    ca_address_sk    integer  not null,
    ca_address_id    string not null,
    ca_street_number string,
    ca_street_name   string,
    ca_street_type   string,
    ca_suite_number  string,
    ca_city          string,
    ca_county        string,
    ca_state         string,
    ca_zip           string,
    ca_country       string,
    ca_gmt_offset    float64,
    ca_location_type string
);

create table tpcds_1.customer_demographics
(
    cd_demo_sk            integer not null  
        ,
    cd_gender             string,
    cd_marital_status     string,
    cd_education_status   string,
    cd_purchase_estimate  integer ,
    cd_credit_rating      string,
    cd_dep_count          integer ,
    cd_dep_employed_count integer ,
    cd_dep_college_count  integer 
)
    ;

create table tpcds_1.date_dim
(
    d_date_sk           integer  not null 
        ,
    d_date_id           string not null,
    d_date              date     not null ,
    d_month_seq         integer ,
    d_week_seq          integer ,
    d_quarter_seq       integer ,
    d_year              integer ,
    d_dow               integer ,
    d_moy               integer ,
    d_dom               integer ,
    d_qoy               integer ,
    d_fy_year           integer ,
    d_fy_quarter_seq    integer ,
    d_fy_week_seq       integer ,
    d_day_name          string,
    d_quarter_name      string,
    d_holiday           string,
    d_weekend           string,
    d_following_holiday string,
    d_first_dom         integer ,
    d_last_dom          integer ,
    d_same_day_ly       integer ,
    d_same_day_lq       integer ,
    d_current_day       string,
    d_current_week      string,
    d_current_month     string,
    d_current_quarter   string,
    d_current_year      string
)
    ;

create table tpcds_1.call_center
(
    cc_call_center_sk integer  not null 
        ,
    cc_call_center_id string not null,
    cc_rec_start_date date ,
    cc_rec_end_date   date ,
    cc_closed_date_sk integer 
        
            ,
    cc_open_date_sk   integer 
        
            ,
    cc_name           string,
    cc_class          string,
    cc_employees      integer ,
    cc_sq_ft          integer ,
    cc_hours          string,
    cc_manager        string,
    cc_mkt_id         integer ,
    cc_mkt_class      string,
    cc_mkt_desc       string,
    cc_market_manager string,
    cc_division       integer ,
    cc_division_name  string,
    cc_company        integer ,
    cc_company_name   string,
    cc_street_number  string,
    cc_street_name    string,
    cc_street_type    string,
    cc_suite_number   string,
    cc_city           string,
    cc_county         string,
    cc_state          string,
    cc_zip            string,
    cc_country        string,
    cc_gmt_offset     float64 ,
    cc_tax_percentage float64 
)
    ;

create table tpcds_1.catalog_page
(
    cp_catalog_page_sk     integer  not null 
        ,
    cp_catalog_page_id     string not null,
    cp_start_date_sk       integer 
        
            ,
    cp_end_date_sk         integer 
        
            ,
    cp_department          string,
    cp_catalog_number      integer ,
    cp_catalog_page_number integer ,
    cp_description         string,
    cp_type                string
)
    ;

create table tpcds_1.income_band
(
    ib_income_band_sk integer not null 
        ,
    ib_lower_bound    integer ,
    ib_upper_bound    integer 
)
    ;

create table tpcds_1.household_demographics
(
    hd_demo_sk        integer not null 
        ,
    hd_income_band_sk integer 
        
            ,
    hd_buy_potential  string,
    hd_dep_count      integer ,
    hd_vehicle_count  float64 
)
    ;

create table tpcds_1.customer
(
    c_customer_sk          integer  not null  
        ,
    c_customer_id          string not null,
    c_current_cdemo_sk     integer 
        
            ,
    c_current_hdemo_sk     integer 
        
            ,
    c_current_addr_sk      integer 
        
            ,
    c_first_shipto_date_sk integer 
        
            ,
    c_first_sales_date_sk  integer 
        
            ,
    c_salutation           string,
    c_first_name           string,
    c_last_name            string,
    c_preferred_cust_flag  string,
    c_birth_day            integer ,
    c_birth_month          integer ,
    c_birth_year           integer ,
    c_birth_country        string,
    c_login                string,
    c_email_address        string,
    c_last_review_date_sk  integer 
)
    ;

create table tpcds_1.item
(
    i_item_sk        integer  not null  
        ,
    i_item_id        string not null,
    i_rec_start_date date ,
    i_rec_end_date   date ,
    i_item_desc      string,
    i_current_price  float64 ,
    i_wholesale_cost float64 ,
    i_brand_id       integer ,
    i_brand          string,
    i_class_id       integer ,
    i_class          string,
    i_category_id    integer ,
    i_category       string,
    i_manufact_id    integer ,
    i_manufact       string,
    i_size           string,
    i_formulation    string,
    i_color          string,
    i_units          string,
    i_container      string,
    i_manager_id     integer ,
    i_product_name   string
)
    
    ;

create table tpcds_1.promotion
(
    p_promo_sk        integer  not null 
        ,
    p_promo_id        string not null,
    p_start_date_sk   integer 
        
            ,
    p_end_date_sk     integer 
        
            ,
    p_item_sk         integer 
        
            ,
    p_cost            float64 ,
    p_response_target integer ,
    p_promo_name      string,
    p_channel_dmail   string,
    p_channel_email   string,
    p_channel_catalog string,
    p_channel_tv      string,
    p_channel_radio   string,
    p_channel_press   string,
    p_channel_event   string,
    p_channel_demo    string,
    p_channel_details string,
    p_purpose         string,
    p_discount_active string
)
    ;

create table tpcds_1.reason
(
    r_reason_sk   integer  not null 
        ,
    r_reason_id   string not null,
    r_reason_desc string
)
    ;

create table tpcds_1.ship_mode
(
    sm_ship_mode_sk integer not null 
        ,
    sm_ship_mode_id string not null,
    sm_type         string,
    sm_code         string,
    sm_carrier      string,
    sm_contract     string
)
    ;

create table tpcds_1.store
(
    s_store_sk         integer  not null 
        ,
    s_store_id         string not null,
    s_rec_start_date   date ,
    s_rec_end_date     date ,
    s_closed_date_sk   integer 
        
            ,
    s_store_name       string,
    s_number_employees integer ,
    s_floor_space      integer ,
    s_hours            string,
    s_manager          string,
    s_market_id        integer ,
    s_geography_class  string,
    s_market_desc      string,
    s_market_manager   string,
    s_division_id      integer ,
    s_division_name    string,
    s_company_id       integer ,
    s_company_name     string,
    s_street_number    string,
    s_street_name      string,
    s_street_type      string,
    s_suite_number     string,
    s_city             string,
    s_county           string,
    s_state            string,
    s_zip              string,
    s_country          string,
    s_gmt_offset       float64 ,
    s_tax_precentage   float64 
)
    ;

create table tpcds_1.time_dim
(
    t_time_sk   integer not null 
        ,
    t_time_id   string not null,
    t_time      integer  not null ,
    t_hour      integer ,
    t_minute    integer ,
    t_second    integer ,
    t_am_pm     string,
    t_shift     string,
    t_sub_shift string,
    t_meal_time string
)
    ;

create table tpcds_1.store_returns
(
    sr_returned_date_sk   integer
        
            ,
    sr_return_time_sk     integer 
        
            ,
    sr_item_sk            integer not null  
        
            ,
    sr_customer_sk        integer 
        
            ,
    sr_cdemo_sk           integer 
        
            ,
    sr_hdemo_sk           integer 
        
            ,
    sr_addr_sk            integer 
        
            ,
    sr_store_sk           integer 
        
            ,
    sr_reason_sk          integer 
        
            ,
    sr_ticket_number      integer not null ,
    sr_return_quantity    integer ,
    sr_return_amt         float64 ,
    sr_return_tax         float64 ,
    sr_return_amt_inc_tax float64 ,
    sr_fee                float64 ,
    sr_return_ship_cost   float64 ,
    sr_refunded_cash      float64 ,
    sr_reversed_charge    float64 ,
    sr_store_credit       float64 ,
    sr_net_loss           float64
)
    
    ;

create table tpcds_1.store_sales
(
    ss_sold_date_sk       integer
        
            ,
    ss_sold_time_sk       integer 
        
            ,
    ss_item_sk            integer not null  
        
            ,
    ss_customer_sk        integer 
        
            ,
    ss_cdemo_sk           integer 
        
            ,
    ss_hdemo_sk           integer 
        
            ,
    ss_addr_sk            integer 
        
            ,
    ss_store_sk           integer 
        
            ,
    ss_promo_sk           integer 
        
            ,
    ss_ticket_number      integer not null ,
    ss_quantity           integer ,
    ss_wholesale_cost     float64 ,
    ss_list_price         float64 ,
    ss_sales_price        float64 ,
    ss_ext_discount_amt   float64 ,
    ss_ext_sales_price    float64 ,
    ss_ext_wholesale_cost float64 ,
    ss_ext_list_price     float64 ,
    ss_ext_tax            float64 ,
    ss_coupon_amt         float64 ,
    ss_net_paid           float64 ,
    ss_net_paid_inc_tax   float64 ,
    ss_net_profit         float64
)
    
    ;

create table tpcds_1.warehouse
(
    w_warehouse_sk    integer  not null 
        ,
    w_warehouse_id    string not null,
    w_warehouse_name  string,
    w_warehouse_sq_ft integer ,
    w_street_number   string,
    w_street_name     string,
    w_street_type     string,
    w_suite_number    string,
    w_city            string,
    w_county          string,
    w_state           string,
    w_zip             string,
    w_country         string,
    w_gmt_offset      float64 
)
    ;

create table tpcds_1.catalog_returns
(
    cr_returned_date_sk      integer
        
            ,
    cr_returned_time_sk      integer 
        
            ,
    cr_item_sk               integer not null  
        
            ,
    cr_refunded_customer_sk  integer 
        
            ,
    cr_refunded_cdemo_sk     integer 
        
            ,
    cr_refunded_hdemo_sk     integer 
        
            ,
    cr_refunded_addr_sk      integer 
        
            ,
    cr_returning_customer_sk integer 
        
            ,
    cr_returning_cdemo_sk    integer 
        
            ,
    cr_returning_hdemo_sk    integer 
        
            ,
    cr_returning_addr_sk     integer 
        
            ,
    cr_call_center_sk        integer 
        
            ,
    cr_catalog_page_sk       integer 
        
            ,
    cr_ship_mode_sk          integer 
        
            ,
    cr_warehouse_sk          integer 
        
            ,
    cr_reason_sk             integer 
        
            ,
    cr_order_number          integer not null ,
    cr_return_quantity       integer ,
    cr_return_amount         float64 ,
    cr_return_tax            float64 ,
    cr_return_amt_inc_tax    float64 ,
    cr_fee                   float64 ,
    cr_return_ship_cost      float64 ,
    cr_refunded_cash         float64 ,
    cr_reversed_charge       float64 ,
    cr_store_credit          float64 ,
    cr_net_loss              float64
)
    
    ;

create table tpcds_1.catalog_sales
(
    cs_sold_date_sk          integer
        
            ,
    cs_sold_time_sk          integer 
        
            ,
    cs_ship_date_sk          integer 
        
            ,
    cs_bill_customer_sk      integer 
        
            ,
    cs_bill_cdemo_sk         integer 
        
            ,
    cs_bill_hdemo_sk         integer 
        
            ,
    cs_bill_addr_sk          integer 
        
            ,
    cs_ship_customer_sk      integer 
        
            ,
    cs_ship_cdemo_sk         integer 
        
            ,
    cs_ship_hdemo_sk         integer 
        
            ,
    cs_ship_addr_sk          integer 
        
            ,
    cs_call_center_sk        integer 
        
            ,
    cs_catalog_page_sk       integer 
        
            ,
    cs_ship_mode_sk          integer 
        
            ,
    cs_warehouse_sk          integer 
        
            ,
    cs_item_sk               integer not null  
        
            ,
    cs_promo_sk              integer 
        
            ,
    cs_order_number          integer not null ,
    cs_quantity              integer ,
    cs_wholesale_cost        float64 ,
    cs_list_price            float64 ,
    cs_sales_price           float64 ,
    cs_ext_discount_amt      float64 ,
    cs_ext_sales_price       float64 ,
    cs_ext_wholesale_cost    float64 ,
    cs_ext_list_price        float64 ,
    cs_ext_tax               float64 ,
    cs_coupon_amt            float64 ,
    cs_ext_ship_cost         float64 ,
    cs_net_paid              float64 ,
    cs_net_paid_inc_tax      float64 ,
    cs_net_paid_inc_ship     float64 ,
    cs_net_paid_inc_ship_tax float64 ,
    cs_net_profit            float64
)
    
    ;

create table tpcds_1.inventory
(
    inv_date_sk          integer not null
        
            ,
    inv_item_sk          integer not null  
        
            ,
    inv_warehouse_sk     integer not null 
        
            ,
    inv_quantity_on_hand integer
)
    
    ;

create table tpcds_1.web_page
(
    wp_web_page_sk      integer  not null 
        ,
    wp_web_page_id      string not null,
    wp_rec_start_date   date ,
    wp_rec_end_date     date ,
    wp_creation_date_sk integer 
        
            ,
    wp_access_date_sk   integer 
        
            ,
    wp_autogen_flag     string,
    wp_customer_sk      integer ,
    wp_url              string,
    wp_type             string,
    wp_char_count       integer ,
    wp_link_count       integer ,
    wp_image_count      integer ,
    wp_max_ad_count     integer 
)
    ;

create table tpcds_1.web_returns
(
    wr_returned_date_sk      integer
        
            ,
    wr_returned_time_sk      integer 
        
            ,
    wr_item_sk               integer not null 
        
            ,
    wr_refunded_customer_sk  integer 
        
            ,
    wr_refunded_cdemo_sk     integer 
        
            ,
    wr_refunded_hdemo_sk     integer 
        
            ,
    wr_refunded_addr_sk      integer 
        
            ,
    wr_returning_customer_sk integer 
        
            ,
    wr_returning_cdemo_sk    integer 
        
            ,
    wr_returning_hdemo_sk    integer 
        
            ,
    wr_returning_addr_sk     integer 
        
            ,
    wr_web_page_sk           integer 
        
            ,
    wr_reason_sk             integer 
        
            ,
    wr_order_number          integer not null  ,
    wr_return_quantity       integer ,
    wr_return_amt            float64 ,
    wr_return_tax            float64 ,
    wr_return_amt_inc_tax    float64 ,
    wr_fee                   float64 ,
    wr_return_ship_cost      float64 ,
    wr_refunded_cash         float64 ,
    wr_reversed_charge       float64 ,
    wr_account_credit        float64 ,
    wr_net_loss              float64
)
    
    ;

create table tpcds_1.web_site
(
    web_site_sk        integer  not null 
        ,
    web_site_id        string not null,
    web_rec_start_date date ,
    web_rec_end_date   date ,
    web_name           string,
    web_open_date_sk   integer 
        
            ,
    web_close_date_sk  integer 
        
            ,
    web_class          string,
    web_manager        string,
    web_mkt_id         integer ,
    web_mkt_class      string,
    web_mkt_desc       string,
    web_market_manager string,
    web_company_id     integer ,
    web_company_name   string,
    web_street_number  string,
    web_street_name    string,
    web_street_type    string,
    web_suite_number   string,
    web_city           string,
    web_county         string,
    web_state          string,
    web_zip            string,
    web_country        string,
    web_gmt_offset     float64 ,
    web_tax_percentage float64 
)
    ;

create table tpcds_1.web_sales
(
    ws_sold_date_sk          integer
        
            ,
    ws_sold_time_sk          integer 
        
            ,
    ws_ship_date_sk          integer 
        
            ,
    ws_item_sk               integer not null 
        
            ,
    ws_bill_customer_sk      integer 
        
            ,
    ws_bill_cdemo_sk         integer 
        
            ,
    ws_bill_hdemo_sk         integer 
        
            ,
    ws_bill_addr_sk          integer 
        
            ,
    ws_ship_customer_sk      integer 
        
            ,
    ws_ship_cdemo_sk         integer 
        
            ,
    ws_ship_hdemo_sk         integer 
        
            ,
    ws_ship_addr_sk          integer 
        
            ,
    ws_web_page_sk           integer 
        
            ,
    ws_web_site_sk           integer 
        
            ,
    ws_ship_mode_sk          integer 
        
            ,
    ws_warehouse_sk          integer 
        
            ,
    ws_promo_sk              integer 
        
            ,
    ws_order_number          integer not null  ,
    ws_quantity              integer ,
    ws_wholesale_cost        float64 ,
    ws_list_price            float64 ,
    ws_sales_price           float64 ,
    ws_ext_discount_amt      float64 ,
    ws_ext_sales_price       float64 ,
    ws_ext_wholesale_cost    float64 ,
    ws_ext_list_price        float64 ,
    ws_ext_tax               float64 ,
    ws_coupon_amt            float64 ,
    ws_ext_ship_cost         float64 ,
    ws_net_paid              float64 ,
    ws_net_paid_inc_tax      float64 ,
    ws_net_paid_inc_ship     float64 ,
    ws_net_paid_inc_ship_tax float64 ,
    ws_net_profit            float64 
)
    
    ;

create table tpcds_1.catalog_returns_2
(
    cr_returned_date_sk      integer 
        
            ,
    cr_returned_time_sk      integer 
        
            ,
    cr_item_sk               integer not null  
        
            ,
    cr_refunded_customer_sk  integer 
        
            ,
    cr_refunded_cdemo_sk     integer 
        
            ,
    cr_refunded_hdemo_sk     integer 
        
            ,
    cr_refunded_addr_sk      integer 
        
            ,
    cr_returning_customer_sk integer 
        
            ,
    cr_returning_cdemo_sk    integer 
        
            ,
    cr_returning_hdemo_sk    integer 
        
            ,
    cr_returning_addr_sk     integer 
        
            ,
    cr_call_center_sk        integer 
        
            ,
    cr_catalog_page_sk       integer 
        
            ,
    cr_ship_mode_sk          integer 
        
            ,
    cr_warehouse_sk          integer 
        
            ,
    cr_reason_sk             integer 
        
            ,
    cr_order_number          integer not null ,
    cr_return_quantity       integer ,
    cr_return_amount         float64 ,
    cr_return_tax            float64 ,
    cr_return_amt_inc_tax    float64 ,
    cr_fee                   float64 ,
    cr_return_ship_cost      float64 ,
    cr_refunded_cash         float64 ,
    cr_reversed_charge       float64 ,
    cr_store_credit          float64 ,
    cr_net_loss              float64
)
    ;