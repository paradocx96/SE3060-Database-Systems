-- WORKSHEET 2 --

select *
from tab

CREATE TYPE dept_t
/

CREATE TYPE emp_t AS OBJECT
(
    EMPNO     CHAR(6),
    FIRSTNAME VARCHAR(12),
    LASTNAME  VARCHAR(12),
    WORKDEPT  REF DEPT_T,
    SEX       CHAR(1),
    BIRTHDAY  DATE,
    SALARY    NUMBER(8, 2)
)
/

CREATE TYPE dept_t AS OBJECT
(
    DEPTNO   CHAR(3),
    DEPTNAME VARCHAR(36),
    MGRNO    REF emp_t,
    ADMRDEPT REF dept_t
)
/

COMMIT
/

CREATE TABLE OREMP OF emp_t
(
    CONSTRAINT OREMP_PK PRIMARY KEY (EMPNO),
    CONSTRAINT OREMP_FIRSTNAME_NN FIRSTNAME NOT NULL,
    CONSTRAINT OREMP_LASTNAME_NN LASTNAME NOT NULL,
    CONSTRAINT OREMP_SEX_CHECK CHECK (SEX='M' OR SEX='m' OR SEX='F' OR SEX='f')
)
/

CREATE TABLE ORDEPT OF dept_t
(
    CONSTRAINT ORDEPT_PK PRIMARY KEY (DEPTNO),
    CONSTRAINT ORDEPT_DEPTNAME_NN DEPTNAME NOT NULL,
    CONSTRAINT ORDEPT_MGRNO_FK FOREIGN KEY (MGRNO) REFERENCES OREMP,
    CONSTRAINT ORDEPT_ADMRDEPT_FK FOREIGN KEY (ADMRDEPT) REFERENCES ORDEPT
)
/

ALTER TABLE OREMP
    ADD CONSTRAINT OREMP_WORKDEPT_FK FOREIGN KEY (WORKDEPT) REFERENCES ORDEPT
/

COMMIT;

-- INSERT DATA --

insert into ORDEPT
values (DEPT_T('A00', 'SPIFFY COMPUTER SERVICE DIV', null, null))
/
insert into ORDEPT
values (DEPT_T('B01', 'Planning', null, (select ref(d) from ORDEPT d where d.DEPTNO = 'A00')))
/
insert into ORDEPT
values (DEPT_T('C01', 'Information Center', null, (select ref(d) from ORDEPT d where d.DEPTNO = 'A00')))
/
insert into ORDEPT
values (DEPT_T('D01', 'Development Center', null, (select ref(d) from ORDEPT d where d.DEPTNO = 'C01')))
/

UPDATE ORDEPT d
SET d.ADMRDEPT=(SELECT REF(d) FROM ORDEPT d WHERE d.DEPTNO = 'A00')
WHERE d.DEPTNO = 'A00'
/

COMMIT
/

insert into OREMP
values (EMP_T('000010', 'Christine', 'Hass', (select ref(d) from ORDEPT d where d.DEPTNO = 'A00'), 'F', '14-AUG-1953', 72750))
/
insert into OREMP
values (EMP_T('000020', 'Michell', 'Thompson', (select ref(d) from ORDEPT d where d.DEPTNO = 'B01'), 'M', '02-FEB-1968', 61250))
/
insert into OREMP
values (EMP_T('000030', 'Sally', 'Kwan', (select ref(d) from ORDEPT d where d.DEPTNO = 'C01'), 'F', '11-MAY-1971', 58250))
/
insert into OREMP
values (EMP_T('000060', 'Irving', 'Stern', (select ref(d) from ORDEPT d where d.DEPTNO = 'D01'), 'M', '07-JUL-1965', 55555))
/
insert into OREMP
values (EMP_T('000070', 'Eva', 'Pulaksi', (select ref(d) from ORDEPT d where d.DEPTNO = 'D01'), 'F', '26-MAY-1973', 56170))
/
insert into OREMP
values (EMP_T('000050', 'Jhon', 'Geyer', (select ref(d) from ORDEPT d where d.DEPTNO = 'C01'), 'M', '15-SEP-1955', 60175))
/
insert into OREMP
values (EMP_T('000090', 'Eileen', 'Henderson', (select ref(d) from ORDEPT d where d.DEPTNO = 'B01'), 'F', '15-MAY-1961', 49750))
/
insert into OREMP
values (EMP_T('000100', 'Theodore', 'Spenser', (select ref(d) from ORDEPT d where d.DEPTNO = 'B01'), 'M', '18-AUG-1976', 46150))
/
COMMIT
/

update ORDEPT d
set d.MGRNO = (select ref(e) from OREMP e where e.EMPNO = '000010')
where d.DEPTNO = 'A00'
/
update ORDEPT d
set d.MGRNO = (select ref(e) from OREMP e where e.EMPNO = '000020')
where d.DEPTNO = 'B01'
/
update ORDEPT d
set d.MGRNO = (select ref(e) from OREMP e where e.EMPNO = '000030')
where d.DEPTNO = 'C01'
/
update ORDEPT d
set d.MGRNO = (select ref(e) from OREMP e where e.EMPNO = '000060')
where d.DEPTNO = 'D01'
/
COMMIT
/

-- QUESTIONS --

-- ##A)
select d.DEPTNAME, d.MGRNO.LASTNAME AS MANAGER
FROM ORDEPT d
/

-- ##B)
select e.EMPNO, e.LASTNAME, e.WORKDEPT.DEPTNAME AS DEPTNAME
FROM OREMP e
/

-- ##C)
select d.DEPTNO, d.DEPTNAME, d.ADMRDEPT.DEPTNAME AS ADMRNAME
FROM ORDEPT d
/

-- ##D)
select d.DEPTNO, d.DEPTNAME, d.ADMRDEPT.DEPTNAME AS ADMRNAME, d.ADMRDEPT.MGRNO.LASTNAME AS ADMANAGER
FROM ORDEPT d
/

-- ##E)
select e.EMPNO,
       e.FIRSTNAME,
       e.LASTNAME,
       e.SALARY,
       e.WORKDEPT.MGRNO.LASTNAME AS MANAGER,
       e.WORKDEPT.MGRNO.SALARY   AS MGRSAL
FROM OREMP e
/

-- ##F)
select e.WORKDEPT.DEPTNO AS DEPTNO, e.WORKDEPT.DEPTNAME AS DEPTNAME, e.SEX, AVG(e.SALARY) AS AVGSAL
from OREMP e
group by e.WORKDEPT.DEPTNO, e.WORKDEPT.DEPTNAME, e.SEX
/

select *
from user_types
/

select *
from user_type_attrs
/

-- (2) --
-- (2)(a) --
SELECT d.DEPTNAME, d.MGRNO.LASTNAME AS LAST_NAME
FROM ORDEPT d
/

-- (2)(b) --
SELECT E.EMPNO, e.LASTNAME, E.WORKDEPT.DEPTNAME AS DEPARTMENT_NAME
FROM OREMP e
/

-- (2)(c) --
SELECT d.DEPTNO, d.DEPTNAME, d.ADMRDEPT.DEPTNAME AS SUB_DEPT
FROM ORDEPT d
/

-- (2)(d) --
SELECT d.DEPTNO, d.DEPTNAME, d.ADMRDEPT.DEPTNAME AS SUB_DEPT, D.MGRNO.LASTNAME AS MANAGER_LAST_NAME
FROM ORDEPT d
/

-- (2)(e) --
SELECT e.EMPNO,
       e.FIRSTNAME,
       e.LASTNAME,
       e.SALARY,
       e.WORKDEPT.MGRNO.LASTNAME AS MANAGER_NAME,
       e.WORKDEPT.MGRNO.SALARY   AS MANAGER_SALARY
FROM OREMP e
/

-- (2)(f) --
SELECT d.DEPTNO, d.DEPTNAME
FROM ORDEPT d
/

SELECT e.WORKDEPT.DEPTNO   AS DEPARTMENT_NO,
       e.WORKDEPT.DEPTNAME AS DEPARTMENT_NAME,
       e.SEX,
       AVG(e.SALARY)       AS AVARAGE_SALARY
FROM OREMP e
GROUP BY e.WORKDEPT.DEPTNO, e.WORKDEPT.DEPTNAME, e.SEX
/

COMMIT;
