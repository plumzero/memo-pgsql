
-- 该脚本必须指定 -h ip地址 执行才能达到预期效果。如:
--   psql -h 192.168.a.b -p 5432 testdb pguser
--   
--   因为 inet_server_addr 有 bug ，如下:
--     In PostgreSQL 13 and earlier, inet_server_addr() will always return NULL if executed by a parallel worker. 
--     This has been fixed for PostgreSQL 14 (commit 5a6f9bce), but has not been backpatched to earlier versions. 

DO
$haha$
DECLARE
    _server_ip text;
    _report_path text;
    _account_info_path text;
    _alphaposition_path text;
    _mode text;
    _date text;
BEGIN
    SELECT to_char(now()::date, 'YYYYMMDD') INTO _date;

    _report_path := '/mnt/NAS/sda/AllData/cn_ashare/daily/report/';

    SELECT host(inet_server_addr())::text INTO _server_ip;
    IF _server_ip = '192.168.2.104' THEN
        _mode = 'test/';
    ELSIF _server_ip = '192.168.2.200' THEN
        _mode = '';
    ELSE
        RAISE INFO '未知环境 %', _server_ip;
    END IF;

    _account_info_path := _report_path || _mode || 'account_info/' || _date;
    _alphaposition_path := _report_path || _mode || 'orders/' || _date;

    RAISE INFO '_account_info_path = %', _account_info_path;
    RAISE INFO '_alphaposition_path = %', _alphaposition_path;
END;
$haha$
LANGUAGE plpgsql;
