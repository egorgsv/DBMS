drop type power_consumption_stats
/
create or replace type power_consumption_info as object(
    id integer,
    time_period varchar2(40),
    morning_res integer,
    daytime_res integer,
    evening_res integer,
    night_res integer,
    overall_res integer)
/
create or replace type power_consumption_stats is table of power_consumption_info
/
select *
from electric
order by date_, id
fetch first 10 rows only
/
drop table power_consumption
/
create table power_consumption (
    id_ integer,
    value_ integer,
    date_ date,
    hour_ integer
)
/
insert into power_consumption select id, value, to_date(substr(date_, 0, 10), 'dd.mm.yyyy'), to_number(hour) from electric
/
select *
from power_consumption
order by date_, hour_
fetch first 10 rows only
/
drop table consumption_res
/
create global temporary table consumption_res (
    id integer,
    time_period varchar2(40),
    morning_res integer,
    daytime_res integer,
    evening_res integer,
    night_res integer,
    overall_res integer
)
/
create or replace type t_years is table of integer
/
create or replace function calc_consumption return power_consumption_stats pipelined
is
    pragma autonomous_transaction;
    curr_period integer;
    temp_table_id integer;
    j integer;
    years t_years;
    curr_month integer;
    curr_year integer;
    curr_year_i integer;
begin
    execute immediate('truncate table consumption_res');

    select unique trunc(to_number(to_char(date_, 'yyyy'))) bulk collect into years from power_consumption;

    for curr_year_i in years.first..years.last loop
        curr_year := years(curr_year_i);
        for curr_period in 1..4 loop
        temp_table_id := curr_year * 10 + curr_period;
        insert into consumption_res(id, time_period, morning_res, daytime_res, evening_res, night_res, overall_res)
        values(temp_table_id, concat(to_char(curr_period), ' квартал'), 0, 0, 0, 0, 0);
        end loop;
        insert into consumption_res(id, time_period, morning_res, daytime_res, evening_res, night_res, overall_res)
        values(curr_year * 10 + 5, concat(concat('Итого за ', to_char(curr_year)), ' год'), 0, 0, 0, 0, 0);
    end loop;

    insert into consumption_res(id, time_period, morning_res, daytime_res, evening_res, night_res, overall_res)
    values(years(years.last) * 10 + 6, 'Итого', 0, 0, 0, 0, 0);

    for rec in (select * from power_consumption order by date_, hour_) loop
        curr_month := to_number(to_char(rec.date_, 'mm'));
        curr_year := to_number(to_char(rec.date_, 'yyyy'));

        curr_period := CASE

            WHEN curr_month between 1 and 3 THEN 1

            WHEN curr_month between 4 and 6 THEN 2

            WHEN curr_month between 7 and 9 THEN 3

            WHEN curr_month between 10 and 12 THEN 4

        END;

        if rec.hour_ between 6 and 11 then
            update consumption_res
                set morning_res = morning_res + rec.value_
                where id = curr_year * 10 + curr_period;
        elsif rec.hour_ between 12 and 17 then
            update consumption_res
                set daytime_res = daytime_res + rec.value_
                where id = curr_year * 10 + curr_period;
        elsif rec.hour_ between 18 and 23 then
            update consumption_res
                set evening_res = evening_res + rec.value_
                where id = curr_year * 10 + curr_period;
        elsif (rec.hour_ between 1 and 5) or (rec.hour_ = 24) then
            update consumption_res
                set night_res = night_res + rec.value_
                where id = curr_year * 10 + curr_period;
        end if;
    end loop;

    for curr_year_i in years.first..years.last loop
        curr_year := years(curr_year_i);
        for curr_period in 1..4 loop
        temp_table_id := curr_year * 10 + curr_period;
        update consumption_res
            set morning_res = morning_res + (select morning_res from consumption_res where id = temp_table_id),
                daytime_res = daytime_res + (select daytime_res from consumption_res where id = temp_table_id),
                evening_res = evening_res + (select evening_res from consumption_res where id = temp_table_id),
                night_res = night_res + (select night_res from consumption_res where id = temp_table_id)
            where id = curr_year * 10 + 5;
        end loop;
    end loop;

    for curr_year_i in years.first..years.last loop
        curr_year := years(curr_year_i);
        temp_table_id := curr_year * 10 + 5;
        update consumption_res
            set morning_res = morning_res + (select morning_res from consumption_res where id = temp_table_id),
                daytime_res = daytime_res + (select daytime_res from consumption_res where id = temp_table_id),
                evening_res = evening_res + (select evening_res from consumption_res where id = temp_table_id),
                night_res = night_res + (select night_res from consumption_res where id = temp_table_id)
            where id = years(years.last) * 10 + 6;
    end loop;

    for rec in (select * from consumption_res) loop
        update consumption_res
            set overall_res = rec.morning_res + rec.daytime_res + rec.evening_res + rec.night_res
            where id = rec.id;
    end loop;

    for rec in (select * from consumption_res) loop
        commit;
        pipe row(power_consumption_info(rec.id, rec.time_period, rec.morning_res, rec.daytime_res, rec.evening_res, rec.night_res, rec.overall_res));
    end loop;
end;
/
create or replace view total_electricity as
select time_period "Период", round(morning_res / 1000000, 1) "Утро [6-12)", round(daytime_res / 1000000, 1) "День [12-18)",
    round(evening_res / 1000000, 1) "Вечер [18-24)", round(night_res / 1000000, 1) "Ночь [0-6)", round(overall_res / 1000000, 1) "Итого"
from calc_consumption()
/
select * from total_electricity;
