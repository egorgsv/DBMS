drop sequence debug_log_seq
/
drop table debug_log
/
drop table points
/
BEGIN
DBMS_SCHEDULER.DROP_SCHEDULE(
schedule_name => 'simple_schedule',
force => TRUE
);
END;
/
BEGIN
DBMS_SCHEDULER.DROP_PROGRAM(
program_name => 'simple_program',
force => TRUE
);
END;
/
create table debug_log (
    id           number(4,0) not null enable,
    log_time     timestamp,
    event      varchar2(50),
    constraint debug_log_pk primary key (id)
    using index enable
)
 organization index
/
 create sequence debug_log_seq
    start with 1
    increment by 1
    maxvalue 9999
    minvalue 1
    cache 20
    nocycle
/
create table points
(
    x number,
    y number
)
/
create or replace procedure insertnewpoint as
begin
    insert into points values ( (select dbms_random.value(0,100) from dual) , (select dbms_random.value(0,100) from dual));
    insert into debug_log values( debug_log_seq.nextval , systimestamp , 'new point into table inserted');
end;
/
begin
dbms_scheduler.create_program
( program_name  => 'simple_program',
  program_type  => 'stored_procedure' ,
  program_action => 'insertnewpoint',
  enabled       => true
);
end;
/
begin
   dbms_scheduler.create_schedule
      ( schedule_name   => 'simple_schedule',
        start_date      => systimestamp,
        repeat_interval => 'freq=secondly; interval=4',
        end_date        => systimestamp + interval '1' minute
      ) ;
 end;
/
create or replace procedure clearpoints as
begin
    execute immediate 'truncate table points';
    insert into debug_log values( debug_log_seq.nextval , systimestamp , 'table cleared');
end;
/
