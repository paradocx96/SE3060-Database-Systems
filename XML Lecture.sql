-- Create Table with untyped XML --

CREATE TABLE AdminDocs (
id int primary key,
xDoc XML not null
);

-- Example: Inserting Data into Untyped XML Column --

INSERT INTO AdminDocs VALUES (1,
'<catalog>
<product dept="WMN">
<number>557</number>
<name language="en">Fleece Pullover</name>
<colorChoices>navy black</colorChoices>
</product>
<product dept="ACC">
<number>563</number>
<name language="en">Floppy Sun Hat</name>
</product>
<product dept="ACC">
<number>443</number>
<name language="en">Deluxe Travel Bag</name>
</product>
<product dept="MEN">
<number>784</number>
<name language="en">Cotton Dress Shirt</name>
<colorChoices>white gray</colorChoices>
<desc>Our <i>favorite</i> shirt!</desc>
</product>
</catalog>'
);

INSERT INTO AdminDocs VALUES (2,
'<doc id="123">
<sections>
<section num="1"><title>XML Schema</title></section>
<section num="3"><title>Benefits</title></section>
<section num="4"><title>Features</title></section>
</sections>
</doc>'
);

select * from AdminDocs;

-- Example: Using Query() Method

SELECT id, xDoc.query('/catalog')
FROM AdminDocs;

SELECT id, xDoc.query('/catalog/product')
FROM AdminDocs;

SELECT id, xDoc.query('/catalog/product/number')
FROM AdminDocs;

SELECT id, xDoc.query('/catalog/product/name')
FROM AdminDocs;

SELECT id, xDoc.query('/catalog/product/colorChoices')
FROM AdminDocs;

SELECT id, xDoc.query('//product')
FROM AdminDocs;

SELECT id, xDoc.query('/*/product')
FROM AdminDocs;

SELECT id, xDoc.query('/*/product[@dept="WMN"]')
FROM AdminDocs;

-- CUSTOM -- 

DECLARE @x XML
SET @x = '<ROOT><A>111</A></ROOT>'
SELECT @x.query('ROOT/A');

-- Axes --

SELECT id, xDoc.query('/*/child::product[attribute::dept="WMN"]')
FROM AdminDocs

SELECT id, xDoc.query('//child::product[attribute::dept="WMN"]')
FROM AdminDocs

SELECT id, xDoc.query('//parent::product[attribute::dept="WMN"]')
FROM AdminDocs

SELECT id, xDoc.query('//product[@dept="WMN"]')
FROM AdminDocs

SELECT id, xDoc.query('descendant-or-self::product[attribute::dept="WMN"]')
FROM AdminDocs

-- Print number grater than 500 result sections with all details
SELECT id, xDoc.query('//product[number > 500]')
FROM AdminDocs
where id=1

-- Print number grater than 500 result section's number lines (current node value > 500)
SELECT id, xDoc.query('//product/number[. gt 500]')
FROM AdminDocs
where id=1

-- Print number less than 500 result sections with all details
SELECT id, xDoc.query('//product[number < 500]')
FROM AdminDocs
where id=1

-- Print number less than 500 result section's number lines (current node value < 500)
SELECT id, xDoc.query('//product/number[. lt 500]')
FROM AdminDocs
where id=1

-- Print 4th section
SELECT id, xDoc.query('/catalog/product[4]')
FROM AdminDocs
where id=1

SELECT id, xDoc.query('/catalog/*[4]')
FROM AdminDocs
where id=1

-- Multiple Conditions (Evaluate Left -> Right)
SELECT id, xDoc.query('//product[number > 500][@dept="ACC"]')
FROM AdminDocs
where id=1

-- Print 2nd ACC dept
SELECT id, xDoc.query('//product[@dept="ACC"][2]')
FROM AdminDocs
where id=1

-- Select 2nd product and print if it is dept=ACC
SELECT id, xDoc.query('//product[2][@dept="ACC"]')
FROM AdminDocs
where id=1

-- Print 1st product, result > 500
SELECT id, xDoc.query('//product[number > 500][1]')
FROM AdminDocs
where id=1


-- FLWOR EXPRESSION / XQuery
-- FOR = getting values (Like FOR Loop)
-- LET = declare variable
-- WHERE = conditions
-- RETURN = return result

SELECT xDoc.query(
'for $prod in //product
let $x:=$prod/number
return $x')
FROM AdminDocs
where id=1

SELECT xDoc.query(
'for $prod in //product
let $x:=$prod/number
where $x>500
return $x')
FROM AdminDocs
where id=1

SELECT xDoc.query(
'for $prod in //product
let $x:=$prod/number
where $x>500
return (<Item>{$x}</Item>)')
FROM AdminDocs
where id=1

SELECT xDoc.query(
'for $prod in //product[number > 500]
let $x:=$prod/number
where $x>500
return (<Item>{$x}</Item>)')
FROM AdminDocs
where id=1

SELECT xDoc.query(
'for $prod in //product
let $x:=$prod/number
where $x>500
return (<Item>{data($x)}</Item>)')
FROM AdminDocs
where id=1

SELECT xDoc.query(
'for $prod in //product
let $x:=$prod/number
return if ($x>500)
then <book>{$x}</book>
else <paper>{$x}</paper>')
FROM AdminDocs
where id=1

SELECT xDoc.query(
'for $prod in //product
let $x:=$prod/number
return if ($x>500)
then <book>{data($x)}</book>
else <paper>{data($x)}</paper>')
FROM AdminDocs
where id=1


-- DML
-- Query()
SELECT xDoc.query('/doc[@id = 123]//section')
FROM AdminDocs

-- Example: Using Exist() Method
SELECT id
FROM AdminDocs
WHERE xDoc.exist('/doc[@id = 123]') = 1

SELECT xDoc.query('/doc[@id = 123]//section')
FROM AdminDocs
WHERE xDoc.exist ('/doc[@id = 123]') = 1

--Example: Using Value() Method
SELECT xDoc.value('(/doc//section[@num = 3]/title)[1]', 'varchar(100)')
FROM AdminDocs

SELECT xDoc.value('data((/doc//section[@num = 3]/title)[1])', 'nvarchar(max)')
FROM AdminDocs

--Example: Insertion of Subtree into XML Instances
select * 
from AdminDocs 
where id=2

-- Modify()
-- Adding XML part
UPDATE AdminDocs SET xDoc.modify(
'insert
<section num="2">
<title>Background</title>
</section>
after (/doc//section[@num=1])[1]'
);

-- Delete XML part
UPDATE AdminDocs SET xDoc.modify(
'delete //section[@num="2"]'
)