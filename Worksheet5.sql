-- PL / SQL --
-- Worksheet 5 --

-- Simple Print Line
BEGIN
    DBMS_OUTPUT.PUT_LINE('This is my first PL/SQL Program');
END;
/

-- Declare & Assign vales
DECLARE
    text VARCHAR(50) := 'This is my first PL/SQL Program';
BEGIN
    DBMS_OUTPUT.PUT_LINE(text);
END;
/

-- CREATE TABLE CUSTOMERS
-- (
--     ID      INT         NOT NULL,
--     NAME    VARCHAR(20) NOT NULL,
--     AGE     INT         NOT NULL,
--     ADDRESS CHAR(25),
--     SALARY  DECIMAL(18, 2),
--     PRIMARY KEY (ID)
-- );
-- INSERT INTO CUSTOMERS (ID, NAME, AGE, ADDRESS, SALARY) VALUES (1, 'Ramesh', 32, 'Colombo', 2000.00);
-- INSERT INTO CUSTOMERS (ID, NAME, AGE, ADDRESS, SALARY) VALUES (2, 'Kamal', 25, 'Kandy', 1500.00);
-- INSERT INTO CUSTOMERS (ID, NAME, AGE, ADDRESS, SALARY) VALUES (3, 'Saman', 23, 'Piliyandala', 2000.00);
-- INSERT INTO CUSTOMERS (ID, NAME, AGE, ADDRESS, SALARY) VALUES (4, 'Kapila', 25, 'Matara', 6500.00);
-- INSERT INTO CUSTOMERS (ID, NAME, AGE, ADDRESS, SALARY) VALUES (5, 'Harsha', 27, 'Maharagama', 8500.00);
-- INSERT INTO CUSTOMERS (ID, NAME, AGE, ADDRESS, SALARY) VALUES (6, 'Janith', 22, 'Hatton', 4500.00);

-- Example 2
DECLARE
	var_cname varchar(12);
	var_cid int := 2;
BEGIN
    SELECT c.name INTO var_cname
	FROM  CUSTOMERS c
	WHERE c.ID = var_cid;
    DBMS_OUTPUT.PUT_LINE('Name of the customer with cid : ' || var_cid || ' is ' || var_cname );
END;
/

-- Exercise 01
-- Write a PL/SQL to get the current price of a stock belongs to company ‘IBM’.
-- Store the company name (‘IBM’) in a variable.
SELECT * FROM STOCKS;

DECLARE
    current_price FLOAT;
    company_name VARCHAR(5) := 'IBM';
BEGIN
    SELECT s.CURRENTPRICE INTO current_price
    FROM STOCKS s
    WHERE s.COMPANY = company_name;
    DBMS_OUTPUT.PUT_LINE('Company Name : ' || company_name || ', Current Price : ' || current_price);
END;
/

-- RECORDS EXAMPLE
DECLARE
    cus_rec CUSTOMERS%ROWTYPE;
    var_cid CUSTOMERS.ID%TYPE := 2;
BEGIN
    SELECT * INTO cus_rec
    FROM CUSTOMERS c
    WHERE c.ID = var_cid;
    DBMS_OUTPUT.PUT_LINE('Customer ID : ' || cus_rec.ID );
    DBMS_OUTPUT.PUT_LINE('Name : ' || cus_rec.name );
    DBMS_OUTPUT.PUT_LINE('Address : ' || cus_rec.address );
END;
/

--  Exercise 02
-- Write a PL/SQL to display a message for a given stock of ‘IBM’
-- company according to the following criteria.
-- Current price < 45 - ‘Current price is very low !’
-- 45 <= Current price < 55 - ‘Current price is low !’
-- 55 <= Current price < 65 - ‘Current price is medium !’
-- 65 <= Current price < 75 - ‘Current price is medium high !’
-- 75 <= Current price - ‘Current price is high !’
-- Store the company name in a variable.
SELECT * FROM STOCKS;

DECLARE
    current_price FLOAT;
    company_name VARCHAR(5) := 'IBM';
BEGIN
    SELECT s.CURRENTPRICE INTO current_price
    FROM STOCKS s
    WHERE s.COMPANY = company_name;
    IF (current_price < 45) THEN
        DBMS_OUTPUT.PUT_LINE('Current price is very low !');
    ELSIF (45 <= current_price AND current_price < 55) THEN
        DBMS_OUTPUT.PUT_LINE('Current price is low !');
    ELSIF (55 <= current_price AND current_price < 65) THEN
        DBMS_OUTPUT.PUT_LINE('Current price is medium !');
    ELSIF (65 <= current_price AND current_price < 75) THEN
        DBMS_OUTPUT.PUT_LINE('Current price is medium high !');
    ELSIF (75 <= current_price) THEN
        DBMS_OUTPUT.PUT_LINE('Current price is high !');
    end if;
    DBMS_OUTPUT.PUT_LINE('Company Name : ' || company_name || ', Current Price : ' || current_price);
END;
/

-- Simple Loop
DECLARE
    x NUMBER := 10;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(x);
        x := x + 10;
        EXIT WHEN x > 50;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('AFTER ALL X=' || x);
END;
/

--  While Loop
DECLARE
    x NUMBER := 10;
BEGIN
    WHILE x < 50 LOOP
        DBMS_OUTPUT.PUT_LINE('Value X=' || x);
        x := x + 10;
    END LOOP;
END;
/

-- FOR Loop
DECLARE
    x NUMBER;
BEGIN
    FOR x IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE('VALUE X=' || x);
    END LOOP;
END;
/

-- Labels
begin
    <<i_loop>> for i in 1 .. 10 loop
        <<j_loop>> for j in 1 .. 10 loop
            dbms_output.put(to_char(j, '999'));
        exit j_loop when j=i;
        end loop;
        dbms_output.new_line;
    end loop;
end;
/

-- Exercise 03
-- Write three PL/SQLs to draw the following shape. Use all three types of loops in each PL/SQL.
-- 9 9 9 9 9 9 9 9 9
-- 8 8 8 8 8 8 8 8
-- 7 7 7 7 7 7 7
-- 6 6 6 6 6 6
-- 5 5 5 5 5
-- 4 4 4 4
-- 3 3 3
-- 2 2
-- 1
BEGIN
    FOR x IN REVERSE 1..9 LOOP
        FOR y IN  1..x LOOP
            DBMS_OUTPUT.PUT(x ||' ');
        END LOOP;
        DBMS_OUTPUT.NEW_LINE;
    end loop;
end;
/

-- Cursors
-- Implicit Cursors
-- The cursor attributes available are
-- %FOUND, %NOTFOUND, %ROWCOUNT, %ISOPEN

DECLARE
    CURSOR stock_cur IS
        SELECT s.COMPANY, s.CURRENTPRICE
        FROM STOCKS s;
    stock_rec stock_cur%rowtype;
BEGIN
    FOR stock_rec in stock_cur LOOP
        dbms_output.put_line('Company : ' || stock_rec.COMPANY || ' - Current Price : ' ||stock_rec.CURRENTPRICE);
    END LOOP;
END;
/

-- Explicit Cursors
DECLARE
    CURSOR cus_cur IS
        SELECT * FROM CUSTOMERS c WHERE c.SALARY > 4000;
    cus_rec cus_cur%ROWTYPE;
BEGIN
    IF NOT cus_cur%ISOPEN THEN
        OPEN cus_cur;
    END IF;
    LOOP
        FETCH cus_cur INTO cus_rec;
        EXIT WHEN cus_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('NAME :' || cus_rec.NAME || ', SALARY:' || cus_rec.SALARY);
    END LOOP;
END;
/
