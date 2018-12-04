/*


*****************************************		AS   		 statement 	*************************************

the AS statement allows us to rename columns or table selections with an alias

Example:


SELECT payment_id 
AS my_payment_column  -- this changes the name of payment_id column to "my_payment_column"
FROM payment;


SELECT customer_id, SUM (amount)  -- aggregate function (SUM) just gives the aggregate function as column name "sum"
FROM payment
GROUP BY customer_id;


SELECT customer_id, SUM (amount) 
AS total_spent  -- this changes the SUM(amount) column from "sum" to "total_spent"
FROM payment
GROUP BY customer_id;
*/

/*  *******************************		JOINS 		****************************

Joining allows you to relate data in one table to the data in other tables, so we can
do things like match up the customer_id to the customer's name, since they can be in different tables

suppose you want to get data from two tables named TableA and TableB.  
TableB has the fka ("foreign key for tableA") field that relates to the primary key of TableA.
ex: let's say tableA is customer table, and the primary key (pk) is the customer_id number, an integer;
	and then c1 (character) we can say is the customer's full name, and in B is the payments table
	and that key (pkb) integer would be payment_id, character (c2: varchar(255) ) could be the store name,
	and the foreign key (fka: INTEGER) is the customer_id.

So we have different information between these two tables, 
but are JOINED by the commonality of two corresponding columns or keys; i.e., customer_id

These will be referred to as keys, but they are basically columns (that matches up with a column in another table). 


To get data from both tables, you use the INNER JOIN clause in the SELECT statment as followed:  
The select statement is the same, separating columns by commas(,); 
however, you also have to specify the table name first, 
and separate table name and column from that table by a period (.) like (table_name.column_name).



SELECT table_name.pk_of_table_name, A.c1, B.pkb, B.c2
FROM A  		-- specifies what table you want.  The initial table you want to join on.
INNER JOIN B   		-- joining statement
ON A.pka = B.fka; 	-- corresponds the two columns you want to match up together.

in the example: Table A has column names pka, and c1
		Table B has column names pkb, c2, and fka
(keep in mind the abreviations:   
	TableA = A, pka = primary key of TableA, fka = foreign key of A, c1 = character1 or column1)

SELECT A.pka, A.c1, B.pkb, B.c2
FROM A
INNER JOIN B ON A.pka = B.fka;

********** clarification of the JOINS statement ******

First, you specify the column in both tables from which you want to select data in SELECT clause.
Second, specify the maain table (i.e., A) in the FROM clause.
Third, specify the table that the main table joins to in the INNER JOIN clause.  
	In the above example, we used main table A and joined table B to main table A.
In addition, you put a join condition after the ON keyword, i.e, A.pka = B.fka.


For each row in the A table, PostgreSQL scans the B table to check if there is any row
	that matches the condition (i.e, A.pka = B.fka).
If it finds a match, it combines columns of both rows into one row and adds
	the combined row to the returned result set.

Note:
	Sometimes A and B tables have the same column name, so we have to refer to the
	column as table_name.column_name to avoid ambiguity.

	In case the name of the table is long, you can use a table alias or abriviation,
	for example, table can be tbl and refer to column as tbl.column_name.
*/


/* ****************************		INNER JOIN 		***********************************************

the INNER JOIN clause returns rows in the A table that have corresponding rows in the B table
which is basically the union of the tables, or what columns they have in common.


-- by looking at all the data in payment table, 
-- we see payment_id belongs solely to a customer, but payment_id is in payment table and not customer table
SELECT *
FROM payment;


-- Use INNER JOIN clause to join the customer table to the payment table.

SELECT 
customer.customer_id, 	-- customer_id shows up in more than one table, and therefore table MUST BE SPECIFIED
first_name,		-- 
last_name,		-- rows without table specified are unique to a table.  EX: first/last_name, and email
email,			-- are only in customer table,so do not have to be specified
amount, 		-- 
payment_date		-- Similarly, the amount and payment_date columns are unique to the payment table
FROM customer
INNER JOIN payment ON payment.customer_id = customer.customer_id;  -- joining payment table on to main table, customer.


-- using INNER JOIN and ORDER BY customer.customer_id


SELECT 
customer.customer_id,
first_name,
last_name,
email,
amount,
payment_date
FROM customer
INNER JOIN payment ON payment.customer_id = customer.customer_id
ORDER BY customer.customer_id;

-- using INNER JOIN and ORDER BY first_name

SELECT 
customer.customer_id,
first_name,
last_name,
email,
amount,
payment_date
FROM customer
INNER JOIN payment ON payment.customer_id = customer.customer_id
ORDER BY first_name;  -- don't need to specify table on first name

-- using INNER JOIN and ORDER BY customer.customer_id

-- using WHERE clause to look for specified (conditional) customers


SELECT 
customer.customer_id,
first_name,
last_name,
email,
amount,
payment_date
FROM customer
INNER JOIN payment ON payment.customer_id = customer.customer_id
WHERE customer.customer_id = 2;  -- gives all of customer 2's payments


-- using WHERE clause to get all payment info for customer's with first name starting with 'A'

SELECT 
customer.customer_id,
first_name,
last_name,
email,
amount,
payment_date
FROM customer
INNER JOIN payment ON payment.customer_id = customer.customer_id
WHERE first_name LIKE 'A%';

*/

/*
section 8 , lecture 52
 **********************	Examples of INNER JOINs 	***************************************


-- Joining the payment table witht he staff table.

SELECT payment_id, amount, first_name, last_name 
FROM payment
INNER JOIN staff ON payment.staff_id = staff.staff_id 

SELECT payment_id, amount, first_name, last_name 
FROM payment
JOIN staff ON payment.staff_id = staff.staff_id  -- in most SQL engines, you dont have to specify INNER JOIN, just JOIN is fine.


-- by viewing film and inventory tables, we notice the two tables can by tied by the "film_id" column from both
--  	now join the two tables.  
SELECT store_id,title
FROM inventory
JOIN film ON inventory.film_id = film.film_id;
-- This returned all the instances of a particular title... i.e, number of copies of each dvd by title.

-- typical business task, from the above query: " Find how many copies of each movie are at store_id # 1"


SELECT title, COUNT (title) AS "Stock"  -- notice, selecting title and also counting title.
FROM inventory
JOIN film ON inventory.film_id = film.film_id  -- still needed to join tables due to store_id condition from question above.
WHERE store_id = 1
GROUP BY title
ORDER BY title;

-- Join the film table to language table using the commonality of the "language_id" column

SELECT film.title, language.name AS Movie_Language -- no quotes, not sure why, but assuming it's bc no aggregate function
FROM film
JOIN language ON film.language_id = language.language_id
ORDER BY title
;

-- doing the same thing as above, but using AS clause to create alias and shorten language table name to "lang"

SELECT film.title, lang.name AS Movie_Language -- no quotes, not sure why, but assuming it's bc no aggregate function
FROM film
JOIN language AS lang ON film.language_id = lang.language_id
ORDER BY title
;

-- same as above, but using a space between the column_name and alias, instead of using AS clause.

SELECT film.title, lang.name Movie_Language -- don't need to put AS statement/clause, but the AS makes it more readable.
FROM film
JOIN language AS lang ON film.language_id = lang.language_id
--ORDER BY title;
*/

/* ********     	Trying to do INNER JOINS on the data base schema 	**********************

-- Using the mapping of all the tables in the database-schema.png picture, try tying tables together
-- 	by their indicated common columns / foreign keys (fk)


-- Example 1: "JOIN address and staff tables"  They have "address_id" in common
SELECT first_name,last_name, address.address
FROM staff
JOIN address ON staff.address_id = address.address_id;

-- Ex 2: "JOIN city and country tables"  They have "Country_id" in common

SELECT country, city
FROM country
JOIN city ON country.country_id = city.country_id;
*/

/* ******************  overview of section 8: JOINS	lecture 53 	*************************

view the powerpoint document "JOINS-Overview-2" to see lecture slides with venn diagrams

Examples show tables A and B represented as a venn diagram, where the red shaded area
	is what would be returned based off of the SQL query provided.


************** LEFT JOIN statement	*******************

The data in the B table relates to the data in the A table via the fka field.
Each row in the A table may have zero or many corresponding rows in the B table. 
Each row in the B table has one and only one corresponding row in the A table.
If you want to select rows from the A table that have corresponding rows 
	in the B table, you use the INNER JOIN clause.

SELECT A.pka, A.c1,B.pkb,B.c2
FROM A
LEFT JOIN B ON A.pka = B.fka;

To join the A table to the B table, you need to:
Specify the columns from which you want to select data in the SELECT clause.
Specify the left table i.e., A table where you want to get all rows, in the FROM clause.
Specify the right table i.e., B table in the LEFT JOIN clause. 
In addition, specify the condition for joining two tables.

The LEFT JOIN clause returns all rows in the left table ( A) that are combined with rows in 
	the right table ( B) even though there is no corresponding rows in the right table ( B).
The LEFT JOIN is also referred as LEFT OUTER JOIN.


***********	INNER JOIN	**************
Inner join produces only the set of records that match in both Table A and Table B.

  the intersetction of TableA and TableB.  This is an INNER JOIN.

SELECT * FROM TableA
INNER JOIN TableB
ON TableA.name = TableB.name

-- syntax example
SELECT <select_list>
FROM TableA AS A
INNER JOIN TableB AS B
ON A.key = B.key

******* 	LEFT OUTER JOIN 	***************
Left outer join produces a complete set of records from Table A, with the matching records
	(where available) in Table B. If there is no match, the right side will contain null.
	
EX2: Table A is completly shaded red, meaning SELECT only table_A, not including anything
	that isn't in table A; but does include the intersetction of A and B.  This is a left outer join.
-- syntax example
SELECT <select_list>
FROM TableA AS A
LEFT JOIN TableB AS B
ON A.key = B.key

ex:

SELECT * FROM TableA
LEFT OUTER JOIN TableB
ON TableA.name = TableB.name

**************		LEFT OUTER JOIN with WHERE		***************
To produce the set of records only in Table A, but not in Table B, we perform 
	the same left outer join, then exclude the records we don't want 
		from the right side via a where clause. 

SELECT * FROM TableA
LEFT OUTER JOIN TableB
ON TableA.name = TableB.name
WHERE TableB.id IS null  	-- "IS null" using the IS clause as an equals, but IS null means is empty


**************		FULL OUTER JOIN			********************
Full outer join produces the set of all records in Table A and Table B, 
	with matching records from both sides where available.
	If there is no match, the missing side will contain null.

SELECT * FROM TableA
FULL OUTER JOIN TableB
ON TableA.name = TableB.name	

**************		FULL OUTER JOIN with WHERE	*******************************
To produce the set of records unique to Table A and Table B, we perform the same full outer join, 
	then exclude the records we don't want from both sides via a where clause. 


SELECT * FROM TableA
FULL OUTER JOIN TableB
ON TableA.name = TableB.name
WHERE TableB.id IS null
OR TableB.id IS NULL


*****************		RIGHT JOIN		*****************

SELECT <select_list>
FROM TableA AS A
RIGHT JOIN TableB AS B
ON A.key = B.key

***************		RIGHT JOIN with WHERE 		**************

SELECT <select_list>
FROM TableA AS A
RIGHT JOIN TableB AS B
ON A.key = B.key
WHERE A.key IS null
*/


/*	section8,lecture 54
********************			Example of OUTER JOINs 		************************

LEFT OUTER JOIN: 
	Each row in the filmm table may have zero or many rows in the inventory table.
	Each row in the inventory table has one and only one row in the film table

Can also be written simple as LEFT JOIN, since SQL will know it 
	refers to an OUTER JOIN because LEFT is specified.


-- example of LEFT OUTER JOIN

SELECT film.film_id, film.title, inventory_id
FROM film
LEFT OUTER JOIN inventory ON inventory.film_id = film.film_id;


--  bottom rows of the query results from above, you'll see blank (null) inventory_id values 


-- Business Case: Want to order films that aren't in inventory stock.  So, a customer is going
--			to request a film, and we want to know that we have every single copy of films.
--	meaning - "Where is the (requested film's) inventory_id going to be NULL?"

-- 	can do this by adding a WHERE clause to select only films that are NOT in the inventory.

SELECT film.film_id, film.title, inventory_id
FROM film
LEFT OUTER JOIN inventory ON inventory.film_id = film.film_id
WHERE inventory.film_id IS null  -- Results show all films that are not in inventory.
ORDER BY film.title;
--	"WHERE inventory.film_id IS null" is less intuitive for finding null inventory_id values
--	 since results show film_id's (not null) giving null inventory_id values;
-- 	but "WHERE inventory.film_id IS null" seems like it would return rows where film_id is null.

-- 	another way to do the above query in a more logical way
-- 		 using WHERE clause to see where inventory_id IS null.  Like the Question wanted.

SELECT film.film_id, film.title, inventory_id
FROM film
LEFT OUTER JOIN inventory ON inventory.film_id = film.film_id
WHERE inventory_id IS null  -- Results show all films that are not in inventory, based on inventory_id.
ORDER BY film.title;
*/

/* section 8, lecture 55				**********************************************************

*******************************		UNION		************************************************************

The UNION operator combines result sets of two or more SELECT statements into a single result set.

The following illustrates the syntax of the UNION operator that 
	combines result sets from two queries:

SELECT column_1, column_2
FROM tbl_name_1
UNION
SELECT column_1, column_2
FROM tbl_name_2;

***  2 major rules to follow when using a UNION statement  ***

1) Both queries must return the same number of columns. (syntax shows both return 2 columns)
2) The corresponding columns int he queries must have compatible data types.
	(if column1 from first select statement is an integer, then the second select statment
			must also have column1 be an integer.  They must be same data type.)

The UNION operator removes all duplicate rows unless the UNION ALL clause is used.

The UNION operator may place the rows in the first query before, after or between
	the rows in the result set of the second query.

To sort the rows in the combined result set by a specified column, you use the ORDER BY clause.


We often use the UNION operator to combine data from similar tables that are not perfectly normalized.
meaning two tables with the exact same type of info inside them, and you want to join the info together;
however, a typical JOIN statement doesn't really work in this sense, because you basically
just want to take all the rows from EACH TABLE and essentially concatenate them (combine them) 
	or mix them into a single table..
Those tables are often found in the reporting or data warehouse system.

Imagine we have two tables:
	- sales2007q1: stores sales data in Q1 2007
	- sales2007q2: stores sales data in Q2 2007
Giving separate results that show name and amount for employees sales 
	and two data outputs.  One for quarter 1 and another for quarter 2.  
Take note that the amount for Mike and Jon changes from Q1 to Q2, 
	but Mary sold the exact same amount in both quarters.

** using the UNION here

SELECT * FROM sales2007q1
UNION
SELECT * FROM sales2007q2;

-- Result would be A SINGLE DATA OUTPUT of name and amount columns for employee sales
-- 	which includes Q1 and Q2 data.  i.e., (jon = $132000.75, jon = 142000.75,
--	mary = $100000, Mike = $120000.25, Mike = $150000.25)
-- 
-- Notice Mary only has 1 entry, but jon and mike have two each.  
-- This is bc UNION removes duplicate rows, and mary's Q1 and Q2 values are exactly the same.

Can also use ORDER BY.

This is also very useful if you wanted to GROUP BY name and then SUM(amount) to 
	calculate the total amount of sales for each employee.




