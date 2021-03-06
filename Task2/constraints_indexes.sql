--Задание 2.1.1
SELECT * FROM USER_TABLES
/
SELECT * FROM ALL_TABLES
where rownum <= 10
/
--Задание 2.1.2
SELECT * FROM TABLE_PRIVILEGE_MAP
where rownum <= 10
/
--Задание 2.1.3
DROP TABLE test
/
CREATE TABLE test  (
    num  NUMBER(2),
    strchar CHAR(5),
    strvarshar VARCHAR2(10),
    dt DATE,
    ts TIMESTAMP
)
/
SELECT * FROM USER_TABLES
/
--Задание 2.2.1
DROP TABLE STOPS
/
DROP TABLE TRAMS
/
DROP TABLE ROUTES
/
CREATE TABLE ROUTES  (
    ROUTEID  NUMBER(3) NOT NULL,
    ROUTENAME VARCHAR2(10) NOT NULL,
    ROUTELENGHT NUMBER
)
/
CREATE TABLE STOPS  (
    ROUTEID NUMBER(3) NOT NULL,
    STOPID NUMBER(3) NOT NULL,
    STOPNAME VARCHAR2(10)
)
/
CREATE TABLE TRAMS  (
    ROUTEID  NUMBER(3) NOT NULL,
    TRAMID NUMBER(4) NOT NULL,
    SEATS NUMBER(3),
    BUILDDATE DATE
)
/
ALTER TABLE ROUTES ADD CONSTRAINT route_pk PRIMARY KEY (ROUTEID)
/
ALTER TABLE STOPS ADD CONSTRAINT stop_pk PRIMARY KEY (STOPID)
/
ALTER TABLE TRAMS ADD CONSTRAINT tram_pk PRIMARY KEY (TRAMID)
/
ALTER TABLE STOPS ADD CONSTRAINT STOP_ROUTE_FK FOREIGN KEY (ROUTEID) REFERENCES ROUTES (ROUTEID)
/
ALTER TABLE TRAMS ADD CONSTRAINT TRAM_ROUTE_FK FOREIGN KEY (ROUTEID) REFERENCES ROUTES (ROUTEID)
/
ALTER TABLE ROUTES
ADD CONSTRAINT check_route_lenght CHECK (ROUTELENGHT > 0)
/
INSERT INTO ROUTES
(ROUTEID, ROUTENAME, ROUTELENGHT)
VALUES
(1, '123', 10)
/
INSERT INTO ROUTES
(ROUTEID, ROUTENAME, ROUTELENGHT)
VALUES
(1, '124', 10)
/
INSERT INTO ROUTES
(ROUTEID, ROUTENAME, ROUTELENGHT)
VALUES
(2, '127', -1)
/
INSERT INTO ROUTES
(ROUTEID, ROUTENAME, ROUTELENGHT)
VALUES
(3, '3', 5)
/
INSERT INTO STOPS
(ROUTEID, STOPID, STOPNAME)
VALUES
(1, 2, 'Uni2')
/
INSERT INTO STOPS
(ROUTEID, STOPID, STOPNAME)
VALUES
(1, 2, 'Uni2')
/
INSERT INTO STOPS
(ROUTEID, STOPID, STOPNAME)
VALUES
(2, 3, 'Uni3')
/
INSERT INTO TRAMS
(ROUTEID, TRAMID, SEATS)
VALUES
(1, 5519, 40)
/
INSERT INTO TRAMS
(ROUTEID, TRAMID)
VALUES
(3, 5520)
/
--Задание 2.2.2
SELECT * FROM USER_CONSTRAINTS
/
SELECT COUNT(*) FROM USER_CONSTRAINTS
/
--Задание 2.2.3
ALTER TABLE EMP
ADD CHECK (SAL >= 500 AND SAL <= 5000)
/
SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'EMP'
AND CONSTRAINT_TYPE = 'C'
/
ALTER TABLE EMP
ADD CONSTRAINT CHECK_SAL CHECK (SAL >= 500 AND SAL <= 5000)
/
--Задание 2.3
SELECT COUNT(*) FROM USER_INDEXES
/
DROP TABLE DEPT1
/
CREATE TABLE DEPT1
(
    DEPTNO NUMBER(2,0) NOT NULL ENABLE,
	DNAME VARCHAR2(50),
	LOC VARCHAR2(50),
	CONSTRAINT DEPT1_PK PRIMARY KEY (DEPTNO)
    USING INDEX  ENABLE
)
ORGANIZATION INDEX
/
INSERT INTO DEPT1
SELECT * FROM DEPT
/
