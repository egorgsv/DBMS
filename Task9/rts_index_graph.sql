select * from rts_index
fetch first 10 rows only
/
DROP type rts_index_tab
/
CREATE OR REPLACE TYPE rts_index_row AS OBJECT ( id NUMBER, C_TIME_ TIMESTAMP, PRICE NUMBER, EMA NUMBER);
/
CREATE OR REPLACE TYPE rts_index_tab IS TABLE OF rts_index_row;
/
CREATE OR REPLACE FUNCTION get_tab_rts RETURN rts_index_tab PIPELINED AS
ema number;
ema_prev number;
price number;
counter number;
c_time timestamp;
BEGIN
select count(*) into counter from rts_index;
FOR i IN 1..counter LOOP
    SELECT (c_open_ + c_high_ + c_low_ + c_close_)/4 into price FROM rts_index order by c_time_ asc offset i-1 rows fetch next 1 rows only;
    if i = 1 then
        ema := price;
    else
        ema := price * 0.4  + (0.6) * ema_prev;
    end if;
    SELECT c_time_ into c_time FROM rts_index order by c_time_ asc offset i-1 rows fetch next 1 rows only ;
    PIPE ROW(rts_index_row(i, c_time, price, ema));
    ema_prev := ema;
END LOOP;
END;
/
select * from get_tab_rts()
fetch first 10 rows only
/
create or replace view rts_index_view as
select to_char(c_time_, 'HH24:MI') as c_time_, price, ema
from get_tab_rts()
where price is not null
order by c_time_ asc
/
select * from rts_index_view
fetch first 10 rows only
