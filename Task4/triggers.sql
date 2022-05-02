--Задание 4.1
--Создайте триггер, обеспечивающий автоматическую генерацию значений в одной из таблиц своей базы (для получения очередного номера используйте секвенцию).

CREATE SEQUENCE DEPT_TR_SEQ START WITH 1 INCREMENT BY 2
MAXVALUE 99
/
DELETE FROM DEPT1
/
create or replace trigger DEPT1NO_TR1
BEFORE
insert on "DEPT1"
for each row
begin
:NEW.DEPTNO := DEPT_TR_SEQ.NEXTVAL;
end;
/
INSERT INTO DEPT1 (DNAME, LOC)
VALUES ('DEPARTMENT1', 'PETERHOF')
/
INSERT INTO DEPT1 (DNAME, LOC)
VALUES ('DEPARTMENT1', 'PETERHOF')
/
INSERT INTO DEPT1 (DNAME, LOC)
VALUES ('DEPARTMENT1', 'PETERHOF')
/
INSERT INTO DEPT1 (DNAME, LOC)
VALUES ('DEPARTMENT1', 'PETERHOF')
/
SELECT * FROM DEPT1
/
ALTER TRIGGER DEPT1NO_TR1 DISABLE
/
--Задание 4.2

--Создайте триггер, обеспечивающий автоматическую генерацию значений  в одной из таблиц своей базы (без использования секвенции).

create or replace trigger DEPT1NO_TR2
BEFORE
insert on DEPT1
for each row
begin
:NEW.DEPTNO := MOD(DBMS_RANDOM.RANDOM, 1000);
end;
/
INSERT INTO DEPT1 (DNAME, LOC) VALUES ('DEPARTMENT2',
'PETERHOF')
/
INSERT INTO DEPT1 (DNAME, LOC) VALUES ('DEPARTMENT2',
'PETERHOF')
/
INSERT INTO DEPT1 (DNAME, LOC) VALUES ('DEPARTMENT2',
'PETERHOF')
/
INSERT INTO DEPT1 (DNAME, LOC) VALUES ('DEPARTMENT2',
'PETERHOF')
/
SELECT * FROM DEPT1
/
--Задание 4.3
--Создайте триггер, который будет записывать в журнал события, связанные с созданием, изменением и удалением таблиц , представлений и секвенций (какое событие, имя объекта, когда и т.п.). Продемонстрируйте работу триггера.
DELETE FROM debug_log
/
CREATE OR REPLACE TRIGGER SCHEMA_LOG
BEFORE DDL ON SCHEMA
BEGIN
    LogInfo(ora_sysevent || ' ' || ora_dict_obj_type, ora_dict_obj_name);
END;

/
ALTER TRIGGER DEPT1NO_TR1 ENABLE
/
DROP SEQUENCE DEPT_TR_SEQ
/
SELECT * FROM debug_log
ORDER BY LOGTIME DESC
/
--Задание 4.4
--Продемонстрируйте созданные триггеры через соответствующие системные представления.
SELECT * FROM USER_TRIGGERS
