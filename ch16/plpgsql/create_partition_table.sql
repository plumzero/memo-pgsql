
-- 参考: postgresql-13 从 1208 页开始

--
-- 序列: 每个表对应一个序列
--
CREATE SEQUENCE IF NOT EXISTS tbl_trade_order_id_seq START WITH 1;
CREATE SEQUENCE IF NOT EXISTS tbl_trade_transaction_id_seq START WITH 1;

--
-- 分区表
--
CREATE TABLE tbl_trade_order (
    "id"                varchar(32),
    "serverId"          integer,
    "orderId"           integer,
    "symbol"            varchar(16),
    "account"           integer,
    "type"              integer,
    "status"            integer,
    "submitTime"        varchar(32),
    "closeTime"         varchar(32),
    "acceptTime"        varchar(32),
    "createTime"        varchar(32),
    "orderVolumn"       integer,
    "dealVolumn"        integer,
    "orderPrice"        integer,
    "orderType"         integer,
    "nTime"             bigint,
    "tag"               varchar(8),
    "risker"            varchar(8),
    "timeout"           integer,
    "force"             boolean,
    "dealPrice"         integer,
    "errCode"           text,
    "errDetail"         text,
    "DRI"               text,
    "DIO"               text,
    "DIA"               text,
    "DAM"               text,
    "partitionKey"      varchar(32) DEFAULT get_unique_ts('tbl_trade_order_id_seq'),
    CONSTRAINT pk_tbl_trade_order primary key("id", "partitionKey")
) PARTITION BY RANGE("partitionKey");

CREATE TABLE tbl_trade_transaction (
    "reqId"               varchar(32),
    "orderId"             varchar(32),
    "matchId"             varchar(32),
    "time"                integer,
    "dealPrice"           integer,
    "dealVolumn"          integer,
    "account_id"          integer,
    "fix_order"           boolean,
    "Delay_Accept_Match"  integer,
    "serverId"            integer,
    "partitionKey"        varchar(32) DEFAULT get_unique_ts('tbl_trade_transaction_id_seq'),
    CONSTRAINT pk_tbl_trade_transaction primary key("partitionKey")
) PARTITION BY RANGE("partitionKey");

--------------------------------------------------------------------
--------------------------------------------------------------------

--
-- 小函数: 获取唯一标识
--
CREATE OR REPLACE FUNCTION get_unique_ts(seqname text)
RETURNS text
AS $BODY$
DECLARE
    unique_ts text;
    this_ts text;
    this_seq integer;
BEGIN
    SELECT now()::timestamp(0) INTO this_ts;
    SELECT nextval(seqname) INTO this_seq;
    
    this_seq := this_seq % 100000;

    SELECT FORMAT('%s.%s', this_ts, this_seq::text) INTO unique_ts;

    RETURN unique_ts;
END;
$BODY$
LANGUAGE plpgsql;

--------------------------------------------------------------------
--------------------------------------------------------------------

--
-- 大函数
--
CREATE OR REPLACE FUNCTION create_partition_table(tblname text, begin_date date DEFAULT now()::date)
RETURNS void
AS $BODY$
DECLARE
    end_date date := begin_date + interval '20 days';
    this_date date := begin_date;
    str_year  text;
    str_month text;
    str_day   text;
    sub_tblname text;
    this_date_begin timestamp(0);
    this_date_end timestamp(0);
    str_sql text;
    str_index text;
BEGIN
    RAISE NOTICE 'tblname: %, begin_date: %, end_date: %', tblname, begin_date, end_date;

    LOOP
        IF this_date >= end_date THEN
            EXIT;
        END IF;

        SELECT EXTRACT(year  FROM this_date) INTO str_year;
        SELECT EXTRACT(month FROM this_date) INTO str_month;
        SELECT EXTRACT(day   FROM this_date) INTO str_day;

        SELECT lpad(str_month, 2, '0') INTO str_month;
        SELECT lpad(str_day, 2, '0') INTO str_day;
        SELECT FORMAT('%s_%s%s%s', tblname, str_year, str_month, str_day) INTO sub_tblname;

        this_date_begin := this_date::timestamp(0);
        this_date_end := this_date + interval '1 days' - interval '1 second';
 
        SELECT FORMAT('CREATE TABLE IF NOT EXISTS %s PARTITION OF %s FOR VALUES FROM (%L) to (%L)', sub_tblname, tblname, this_date_begin, this_date_end) INTO str_sql;
        EXECUTE str_sql;

        -- 不会根据分区键查询历史数据，所以暂时不必创建分区键索引
        -- SELECT FORMAT('idx_%s_partition', sub_tblname) INTO str_index;
        -- SELECT FORMAT('CREATE INDEX IF NOT EXISTS %s ON %s USING btree(%s)', str_index, sub_tblname, 'partitionKey') INTO str_sql;
        -- EXECUTE str_sql;

        this_date := this_date + interval '1 days';
    END LOOP;

    RAISE NOTICE '========== function ok ==========';
    RETURN ;
END;
$BODY$
LANGUAGE plpgsql;

--
-- tbl_trade_order 测试
--
SELECT create_partition_table('tbl_trade_order', now()::date);

INSERT INTO tbl_trade_order VALUES('109350001',10,1,'000333',10094,1,4,'1633916100052.988','1633916101071.197','1633916100058.973','1633916100052.762',600,600,723300,
                                   1,93500020,'t4','t4',10000,false,723300,'JErrorType_None',' ','0','0','0','1009'),
                                  ('109350002',10,1,'000333',10066,1,4,'1633916100053.051','1633916102084.015','1633916100075.454','1633916100052.933',600,600,723300,
                                   1,93500020,'t5','t5',10000,false,723300,'JErrorType_None',' ','0','0','12','2009'),
                                  ('109350003',10,2,'600171',10066,-1,4,'1633916100055.779','1633916105089.064','1633916100075.466','1633916100055.611',6800,6800,348700,
                                   1,93459000,'t7','t7',10000,false,348700,'JErrorType_None',' ','0','0','10','5014')
                            ON CONFLICT ("id", "partitionKey")
                            DO UPDATE SET status = excluded.status,"submitTime" = excluded."submitTime","closeTime" = excluded."closeTime","dealVolumn" = excluded."dealVolumn";

--
-- tbl_trade_transaction 测试
--
SELECT create_partition_table('tbl_trade_transaction', now()::date);

INSERT INTO tbl_trade_transaction VALUES('109350001','ord109350001','mth109350001',93500020,600,10000,10094,false,100,10),
                                        ('109350002','ord109350001','mth109350001',93500020,600,10000,10094,false,100,30)
                            ON CONFLICT ("partitionKey")
                            DO UPDATE SET "dealVolumn" = tbl_trade_transaction."dealVolumn" + excluded."dealVolumn";
