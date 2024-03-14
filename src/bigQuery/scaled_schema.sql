create table tpch.part_3
(
    p_partkey     integer        not null,
    p_name        string    not null,
    p_mfgr        string       not null,
    p_brand       string       not null,
    p_type        string    not null,
    p_size        integer        not null,
    p_container   string       not null,
    p_retailprice float64 not null,
    p_comment     string    not null,
    nil           string
);

create table tpch.region_3
(
    r_regionkey integer  not null,
    r_name      string not null,
    r_comment   string,
    nil           string
);

create table tpch.partsupp_3
(
    ps_partkey    integer        not null,
    ps_suppkey    integer        not null,
    ps_availqty   integer        not null,
    ps_supplycost float64 not null,
    ps_comment    string   not null,
    nil           string
);

create table tpch.nation_3
(
    n_nationkey integer  not null,
    n_name      string not null,
    n_regionkey integer  not null,
    n_comment   string,
    nil           string
);

create table tpch.supplier_3
(
    s_suppkey   integer        not null,
    s_name      string       not null,
    s_address   string    not null,
    s_nationkey integer        not null,
    s_phone     string       not null,
    s_acctbal   float64 not null,
    s_comment   string   not null,
    nil           string
);

create table tpch.customer_3
(
    c_custkey    integer        not null,
    c_name       string    not null,
    c_address    string    not null,
    c_nationkey  integer        not null,
    c_phone      string       not null,
    c_acctbal    float64 not null,
    c_mktsegment string       not null,
    c_comment    string   not null,
    nil           string
);

create table tpch.orders_3
(
    o_orderkey      bigint         not null,
    o_custkey       bigint         not null,
    o_orderstatus   string           not null,
    o_totalprice    float64 not null,
    o_orderdate     date           not null,
    o_orderpriority string       not null,
    o_clerk         string       not null,
    o_shippriority  integer        not null,
    o_comment       string    not null,
    nil           string
);

create table tpch.lineitem_3
(
    l_orderkey      bigint         not null,
    l_partkey       bigint         not null,
    l_suppkey       integer        not null,
    l_linenumber    integer        not null,
    l_quantity      float64 not null,
    l_extendedprice float64 not null,
    l_discount      float64 not null,
    l_tax           float64 not null,
    l_returnflag    string           not null,
    l_linestatus    string           not null,
    l_shipdate      date           not null,
    l_commitdate    date           not null,
    l_receiptdate   date           not null,
    l_shipinstruct  string       not null,
    l_shipmode      string       not null,
    l_comment       string    not null,
    nil           string
);
