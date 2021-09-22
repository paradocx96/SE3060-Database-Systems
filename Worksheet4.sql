-- LAB_SHEET 4 --
--  (1)(A) --
ALTER TYPE STOCKS_TYPE
    ADD MEMBER FUNCTION yield
        RETURN FLOAT
        CASCADE
/

CREATE OR REPLACE TYPE BODY STOCKS_TYPE AS
    MEMBER FUNCTION yield
        RETURN FLOAT IS
    BEGIN
        RETURN ((SELF.LASTDIVIDEND / SELF.CURRENTPRICE) * 100);
    END;
END;
/

COMMIT
/

SELECT s.COMPANY, s.LASTDIVIDEND, s.CURRENTPRICE, s.yield()
FROM STOCKS s
/

-- (1)(B) --
-- ADDING NEW MEMBER FUNCTION AFTER FIRST TIME --
CREATE OR REPLACE TYPE BODY STOCKS_TYPE AS
    MEMBER FUNCTION yield
        RETURN FLOAT IS
    BEGIN
        RETURN ((SELF.LASTDIVIDEND / SELF.CURRENTPRICE) * 100);
    END yield;

    MEMBER FUNCTION AUDtoUSD(rate FLOAT)
        RETURN FLOAT IS
    BEGIN
        RETURN (rate * SELF.CURRENTPRICE);
    END AUDtoUSD;
END;
/

-- OR --
-- IF THIS IS FIRST MEMBER FUNCTION --
ALTER TYPE STOCKS_TYPE
    ADD MEMBER FUNCTION AUDtoUSD(rate FLOAT)
        RETURN FLOAT
        CASCADE
/

CREATE OR REPLACE TYPE BODY STOCKS_TYPE AS
    MEMBER FUNCTION AUDtoUSD(rate FLOAT)
        RETURN FLOAT IS
    BEGIN
        RETURN (rate * SELF.CURRENTPRICE);
    END;
END;
/

COMMIT
/

SELECT s.COMPANY, s.yield(), s.AUDtoUSD(0.9)
FROM STOCKS s
/

-- (1)(C) --
-- ADDING NEW MEMBER FUNCTION AFTER FIRST TIME --
ALTER TYPE STOCKS_TYPE
    ADD MEMBER FUNCTION COUNT_TRADE
        RETURN INTEGER
        CASCADE
/

CREATE OR REPLACE TYPE BODY STOCKS_TYPE AS
    MEMBER FUNCTION yield
        RETURN FLOAT IS
    BEGIN
        RETURN ((SELF.LASTDIVIDEND / SELF.CURRENTPRICE) * 100);
    END yield;

    MEMBER FUNCTION AUDtoUSD(rate FLOAT)
        RETURN FLOAT IS
    BEGIN
        RETURN (rate * SELF.CURRENTPRICE);
    END AUDtoUSD;

    MEMBER FUNCTION COUNT_TRADE RETURN INTEGER IS
    RESULT INTEGER;
    BEGIN
        SELECT COUNT(e.COLUMN_VALUE) INTO RESULT
        FROM STOCKS s, TABLE(s.EXCHANGES) e
        WHERE s.COMPANY = SELF.COMPANY;
        RETURN RESULT;
    END COUNT_TRADE;
END;
/

COMMIT
/

SELECT s.COMPANY, s.yield(), s.AUDtoUSD(0.9), s.COUNT_TRADE()
FROM STOCKS s
/

-- (2)(A) --
SELECT s.COMPANY, e.COLUMN_VALUE, s.yield(), s.AUDtoUSD(0.74)
FROM STOCKS s, TABLE ( s.EXCHANGES ) e

COMMIT
/