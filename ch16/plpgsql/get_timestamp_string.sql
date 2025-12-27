
--
-- 序列: 每个表对应一个序列
--
CREATE SEQUENCE IF NOT EXISTS tbl_trade_order_id_seq START WITH 1;
CREATE SEQUENCE IF NOT EXISTS tbl_trade_transaction_id_seq START WITH 1;

--
-- 小函数: 唯一标识
--
DROP FUNCTION IF EXISTS get_unique_ts(text);

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

---
--- 小函数测试
---
SELECT get_unique_ts('tbl_trade_order_id_seq');