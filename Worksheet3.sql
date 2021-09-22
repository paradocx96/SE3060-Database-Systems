-- WORKSHEET 3 --
-- CREATE TYPES --
CREATE TYPE EXCHANGES_VARRAY AS VARRAY(3) OF VARCHAR(20)
/

CREATE TYPE STOCKS_TYPE AS OBJECT
(
    COMPANY         VARCHAR(10),
    CURRENTPRICE    NUMBER(10, 2),
    EXCHANGES       EXCHANGES_VARRAY,
    LASTDIVIDEND    NUMBER(5, 2),
    EARNINGPERSHARE NUMBER(5, 2)
)
/

CREATE TYPE ADDRESS_TYPE AS OBJECT
(
    STREETNUMBER CHAR(10),
    STREETNAME   CHAR(20),
    SUBURB       CHAR(20),
    STATE        CHAR(20),
    PIN          CHAR(10)
)
/

CREATE TYPE INVESTMENTS_TYPE AS OBJECT
(
    COMPANY       REF STOCKS_TYPE,
    PURCHASEPRICE NUMBER(6, 2),
    PURCHASEDATE  DATE,
    QTY           NUMBER(10)
)
/

CREATE TYPE INVESTMENTS_NESTED_TABLE_TYPE AS TABLE
    OF INVESTMENTS_TYPE
/

CREATE TYPE CLIENTS_TYPE AS OBJECT
(
    NAME        VARCHAR(50),
    ADDRESS     ADDRESS_TYPE,
    INVESTMENTS INVESTMENTS_NESTED_TABLE_TYPE
)
/
COMMIT;

-- CREATE TABLE --
CREATE TABLE STOCKS OF STOCKS_TYPE
(
    CONSTRAINT STOCKS_PK PRIMARY KEY (COMPANY)
)
/

CREATE TABLE CLIENTS OF CLIENTS_TYPE
(
    CONSTRAINT CLIENTS_PK PRIMARY KEY (NAME)
) NESTED TABLE INVESTMENTS STORE AS INVESTMENTS_TABLE
/

ALTER TABLE INVESTMENTS_TABLE
    ADD SCOPE FOR(COMPANY) IS STOCKS
/

-- INSERT VALUES --
INSERT INTO STOCKS
VALUES (STOCKS_TYPE(
        'BHP',
        10.50,
        EXCHANGES_VARRAY('Sydney', 'New York'),
        1.50,
        3.20
    ))
/

INSERT INTO STOCKS
VALUES (STOCKS_TYPE(
        'IBM',
        70.00,
        EXCHANGES_VARRAY('New York', 'London', 'Tokyo'),
        4.25,
        10.00
    ))
/

INSERT INTO STOCKS
VALUES (STOCKS_TYPE(
        'INTEL',
        76.50,
        EXCHANGES_VARRAY('New York', 'London'),
        5.00,
        12.40
    ))
/

INSERT INTO STOCKS
VALUES (STOCKS_TYPE(
        'FORD',
        40.00,
        EXCHANGES_VARRAY('New York'),
        2.00,
        8.50
    ))
/

INSERT INTO STOCKS
VALUES (STOCKS_TYPE(
        'GM',
        60.00,
        EXCHANGES_VARRAY('New York'),
        2.50,
        9.20
    ))
/

INSERT INTO STOCKS
VALUES (STOCKS_TYPE(
        'INFOSYS',
        45.00,
        EXCHANGES_VARRAY('New York'),
        3.00,
        7.80
    ))
/

SELECT *
FROM STOCKS
/

COMMIT;

INSERT INTO CLIENTS
VALUES (CLIENTS_TYPE(
        'John Smith',
        ADDRESS_TYPE('3', 'East Av', 'Bentley', 'WA', '6102'),
        INVESTMENTS_NESTED_TABLE_TYPE(
                INVESTMENTS_TYPE(
                        (SELECT REF(s) FROM STOCKS s WHERE s.COMPANY = 'BHP'),
                        12.00,
                        '02-OCT-2001',
                        1000),
                INVESTMENTS_TYPE(
                        (SELECT REF(s) FROM STOCKS s WHERE s.COMPANY = 'BHP'),
                        10.50,
                        '08-JUN-2002',
                        2000),
                INVESTMENTS_TYPE(
                        (SELECT REF(s) FROM STOCKS s WHERE s.COMPANY = 'IBM'),
                        58.00,
                        '12-FEB-2000',
                        500),
                INVESTMENTS_TYPE(
                        (SELECT REF(s) FROM STOCKS s WHERE s.COMPANY = 'IBM'),
                        65.00,
                        '10-APR-2001',
                        1200),
                INVESTMENTS_TYPE(
                        (SELECT REF(s) FROM STOCKS s WHERE s.COMPANY = 'INFOSYS'),
                        64.00,
                        '11-AUG-2001',
                        1000)
            )
    ))
/

INSERT INTO CLIENTS
VALUES (CLIENTS_TYPE(
        'Jill Brody',
        ADDRESS_TYPE('42', 'Bent St', 'Perth', 'WA', '6001'),
        INVESTMENTS_NESTED_TABLE_TYPE(
                INVESTMENTS_TYPE(
                        (SELECT REF(s) FROM STOCKS s WHERE s.COMPANY = 'INTEL'),
                        35.00,
                        '30-JAN-2000',
                        300),
                INVESTMENTS_TYPE(
                        (SELECT REF(s) FROM STOCKS s WHERE s.COMPANY = 'INTEL'),
                        54.00,
                        '30-JAN-2001',
                        400),
                INVESTMENTS_TYPE(
                        (SELECT REF(s) FROM STOCKS s WHERE s.COMPANY = 'INTEL'),
                        60.00,
                        '02-OCT-2001',
                        200),
                INVESTMENTS_TYPE(
                        (SELECT REF(s) FROM STOCKS s WHERE s.COMPANY = 'FORD'),
                        40.00,
                        '05-OCT-1999',
                        300),
                INVESTMENTS_TYPE(
                        (SELECT REF(s) FROM STOCKS s WHERE s.COMPANY = 'GM'),
                        55.50,
                        '12-DEC-2000',
                        500)
            )
    ))
/


COMMIT;

-- DELETE FROM CLIENTS WHERE NAME='John Smith';
-- DELETE FROM CLIENTS WHERE NAME='Jill Brody';

SELECT *
FROM CLIENTS;

-- GET VALUES --
-- (3)(a) --
SELECT DISTINCT C.NAME,
                i.COMPANY.COMPANY,
                i.COMPANY.CURRENTPRICE,
                i.COMPANY.LASTDIVIDEND,
                i.COMPANY.EARNINGPERSHARE
FROM CLIENTS c,
     TABLE (c.INVESTMENTS) i
/

-- (3)(b) --
SELECT c.NAME,
       i.COMPANY.COMPANY,
       SUM(i.QTY)                                TOTAL_QTY,
       SUM(i.QTY * i.PURCHASEPRICE)              TOTAL,
       SUM(i.QTY * i.PURCHASEPRICE) / SUM(i.QTY) AVARAGE_PRICE
FROM CLIENTS c,
     TABLE (c.INVESTMENTS) i
GROUP BY c.NAME, i.COMPANY.COMPANY
/

-- (3)(c) --
SELECT c.NAME,
       i.COMPANY.COMPANY,
       SUM(i.QTY),
       SUM(i.QTY * i.COMPANY.CURRENTPRICE)
FROM CLIENTS c,
     TABLE (c.INVESTMENTS) i,
     TABLE (i.COMPANY.EXCHANGES) e
WHERE e.COLUMN_VALUE = 'New York'
GROUP BY c.NAME, i.COMPANY.COMPANY
/

-- (3)(d) --
SELECT c.NAME,
       SUM(i.QTY * i.PURCHASEPRICE) TOTAL
FROM CLIENTS c,
     TABLE (c.INVESTMENTS) i
GROUP BY c.NAME
/

-- (3)(e) --
SELECT c.NAME,
       SUM(i.QTY * (i.COMPANY.CURRENTPRICE - i.PURCHASEPRICE)) PROFIT
FROM CLIENTS c,
     TABLE (c.INVESTMENTS) i
GROUP BY c.NAME
/

