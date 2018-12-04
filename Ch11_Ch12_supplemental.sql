/* 		Timestamps, Subqueries, string functions, and self join


**********************	Timestamps and Extract 		***********************

SQL allow us to use the timestamp data type to retain time information.

Later, we will learn how to create timestamp columns, but for now we are focusing on
	extracting information from timestamp objects.

*********	EXTRACT function 	*********

The PostgreSQL extract function extracts parts from a date. 
	- extract( unit from date )

We can extract many types of time-based information.

The following is a table of extract function units on left and their explanation after.
*************************************************************************************************************
Units ********	Explanation ********************
**************************************************************************************************************
day		Day of the month (1 to 31)
dow		Day of the week (0=Sunday, 1=Monday,.... 6=Saturday)
doy		Day of the year (1=first day of year, 365/366= last day of year, depending if it's a leap year)
epoch		Number of seconds since '1970-01-01 00:00:00 UTC', if date value.
			Number of seconds in an interval, if interval value.
hour		Hour (o to 23)
microseconds	Seconds (and fractional seconds) multiplied by 1,000,000
millennium	Millennium value
milliseconds	Seconds (and fractional seconds) multiplied by 1,000
minute 		Minute (0 to 59)
month		Number for the month (1 to 12), if date value. Number of months (0 to 11), if interval value.
quarter		Quarter (1 to 4)
second		Seconds (and fractional seconds)
week		Number of the week of the year, based on ISO 8601 (where the year begins on the Monday of
			the week that contains January 4th)
year		Year as 4-digits
***************************************************************************************************************
***************************************************************************************************************

For a full list of all the functions, visit https://www.postgresql.org/docs/9.5/static/functions.html


-- Using this for following example.
SELECT payment_date
FROM payment;

-- Extract examples:  Getting the payment date column itself.

SELECT extract(day from payment_date) -- use "extract" and "from" in lower case to avoid confusion.
FROM payment;

-- Extract examples:  filtering by customer_id.

SELECT customer_id, extract(day from payment_date) AS day
FROM payment;

-- Extract examples:  find total amount expenditure by the month.

SELECT SUM (amount), extract(month from payment_date) AS month
FROM payment
GROUP BY month  -- Need to use GROUP BY, since we used aggregate function SUM (amount)
ORDER BY SUM(amount) DESC;


-- Extract examples:  find highest grossing month

SELECT SUM (amount) AS total, extract(month from payment_date) AS month
FROM payment
GROUP BY month  -- Need to use GROUP BY, since we used aggregate function SUM (amount)
ORDER BY SUM(amount) DESC  -- or you can use ORDER BY total
LIMIT 1;





-- Example:  Let's say we wanted to make a new ID for a specific event, and that ID was 
--		going to be defined by the customer_id, and the rental_id.

SELECT customer_id + rental_id AS new_id -- adding customer_id to rental_id to make new_id
FROM payment;

-- customer_id multiplied by rental_id = new_id

SELECT customer_id * rental_id AS new_id  -- multiplication.
FROM payment;

-- Division; Smaller number divided by larger number.
--	customer_id divided by rental_id. this results in truncation.  (341 / 1520) = 0.   new_id = 0
SELECT customer_id,rental_id, customer_id/rental_id AS new_id -- new_id is an integer
FROM payment;


-- Division; showing the opposite of above.  Larger number divided by smaller number.
--	rental / customer. Ex:  (1520 / 341) = 4.   new_id = 4
SELECT customer_id,rental_id, rental_id/customer_id AS new_id 
FROM payment;





**********************		String Functions and Operators		********************************



-- Working with the Customer Table to see string function examples.

SELECT *
FROM customer;


-- Example of using || for Concatenation (meaning adding together strings together)

SELECT first_name || last_name  -- returns both columns, unlabeled, and without a space between first and last name
FROM customer;


-- Example of using || for Concatenation of first and last name, with space between.
--	Returns column named "full_name" with the format of "first_name last_name" (space between)
SELECT first_name || ' ' || last_name AS full_name -- the use of || joins things on both sides of it.
FROM customer;		-- must use || twice to join first_name with the space ' ', and again to join ' ' with last_name


-- char_length() 
-- Example of trying to find how many characters a name has, using "char_length(column_name)"

SELECT first_name, char_length(first_name)
FROM customer;


-- upper() and lower()
-- Example of returning uppercase

SELECT upper(first_name), lower(last_name), first_name || ' ' || last_name AS name
FROM customer;



***********************			SubQuery		***********************************

A subquery is a query nested inside another query, and  allows us to use multiple SELECT statements,
	where we basically have a query within a query.

To construct a subquery, we put the second query in brackets and use it in the WHERE clause as an expression.

**************************************************************
SubQuery syntax:
**************************************************************
SELECT film_id, title, rental_rate
FROM film
WHERE rental_rate > (SELECT AVG (rental_rate) FROM film);
***************************************************************
for example, suppose we want to find the films whose rental rate is higher than the average rental rate.
We can do this in two steps:
	1) Find the avg rental rate:  SELECT AVG()
	2) Use the result of the firstt query in the second SELECT statement to find films we want.


-- Find the movies whose rental rate is higher than the average rental rate.
-- Can be done in two ways.  

-- Method 1: Using two distinct separate steps.

--SELECT AVG(rental_rate) -- 2.98 is the result of first query
--FROM film;
-- second part of query
SELECT title, rental_rate
FROM film
WHERE rental_rate > 2.98;


-- Method 2: Using subquery (put the second query in brackets and use it in the WHERE clause as an expression.)

SELECT title, rental_rate
FROM film
WHERE rental_rate > (SELECT AVG (rental_rate) FROM film);

-- PostgreSQL executes the query that contains a subquery in the following sequence:
-- First,  it executes the subquery "(SELECT AVG (rental_rate) FROM film)"
-- Second, passes results to outer query, which is everything else outside of parentheses.
-- Third, it executes the outer query.

-- Can almost think of this subquery as a variable but in the form of a query.

-- Subquery can return zero or more rows


-- Subquery using IN operator in the WHERE clause, to match an inventory_id integer in the inventory table
-- 	to get films that have been returned between two specific dates: May 29th and 30th.

-- also using JOIN
SELECT inventory.film_id	-- selecting film_id column, from inventory table, which is also in rental table.
FROM rental
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id	-- joining the two tables based on common column
WHERE return_date 
BETWEEN '2005-05-29' AND '2005-05-30';  -- condition for return date, returning film_id's returned between these dates.

-- Now we can actually use the entire query from above as a subquery to get the titles of the films
-- 	by puting the above query inside parentheses.

******************* IMPORTANT ********

-- using subquery as first step, and then everything outside parentheses as the sequential steps
--	We want to get the film titles from the film_id.  multiple rows returned, use IN operator

SELECT film_id,title
FROM film
WHERE film_id IN 

-- subquery below

(SELECT inventory.film_id	
FROM rental
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
WHERE return_date 
BETWEEN '2005-05-29' AND '2005-05-30')


******************* IMPORTANT ********

-- If it was just a single integer or single string returned, then we'd use either a comparison operator
--	an equals (=), or a LIKE operator.
-- If subquery is going to return many rows, then you use the IN operator.

********************************	Self Join	****************************************************

A Self Join is a special case where you join a table to itself, 
	instead of using INNER JOIN, LEFT OUTER JOIN or RIGHT OUTER JOIN satements.

Use self join to combine rows with other rows, within the same table.

To perform the self join operation, you must use a table alias (AS statement) to help SQL distinguish
	the left table from the right table, of the same table.


Example: Imagine we have the following table:
__________________________________________

employee_name		employee_location
__________________________________________
	Joe		New York
	Sunil		India
	Alex		Russia
	Albert		Canada
	Jack		New York
__________________________________________

"Suppose we want to find out which employees are from the same location as the employee named Joe."
In this example, the location will be New York; and we will assume that we can NOT directly search
	the table for people who live in New York with a simple query like this
	(maybe because we don't want to hardcode the city name) in the SQL query.
meaning we can NOT just say:

SELECT employee_name
FROM employee
WHERE employee_location = 'New York'

So we could use a subquery, which would look like this:

SELECT employee_name
FROM employee
WHERE employee_location IN 
	(SELECT employee_location   	-- subquery starts here.
	FROM employee
	WHERE employee_name = 'Joe')

While using a subquery, like in the above example, is a valid solution, it is more efficient 
	to use a self join, where we join a table to itself.

As a general rule, we need to always use aliases (remember the AS statement) when using a self join.

Self Join Syntax Example:  

SELECT e1.employee_name
FROM employee AS e1, employee AS e2
WHERE e1.employee_location = e2.employee_location
	AND e2.employee_name = 'Joe';

-- notice the above syntax doesn't actually use any of the JOIN terms, because this is a self join
		using the aliasing technique, saying employee AS e1, employee AS e2.
		So basically we have two tables in this query with FROM as two different aliases,
			but they're actually the same table, employee.

This query will return the names Joe and Jack - since Jack is the only other person who lives in New York like Joe.
Generally, queries that refer to the same table can be greatly simplified by re-writing the queries as self joins,
	and there is a performance benefit for this as well.

The self join above creats two aliases from the table:
__________________________________________________________________________________________________________
		e1												e2
__________________________________________		___________________________________________

	name		location							name		location
__________________________________________		___________________________________________
	Joe			New York								Joe			New York
	Sunil		India								Sunil		India
	Alex		Russia								Alex		Russia
	Albert		Canada								Albert		Canada
	Jack		New York							Jack		New York
__________________________________________		___________________________________________
__________________________________________________________________________________________________________
Notice they're the same table.  So they're both instances of the employee table from above (first example)

and the final result of running the self join query from above - the actual joined table - looks like this:
____________________________________________________________________________________________________________
e1.employee_name	e1.employee_location		e2.employee_name	e2.employee_location	
____________________________________________________________________________________________________________
	Joe				New York						Joe			New York
	Jack			New York						Joe			New York
____________________________________________________________________________________________________________
This is where you would actually call the columns off of it.
The reason we get two instances of joe here is because the self join query used the AND statement that said
	AND e2.employee_name = 'Joe';. 

Examples of Self Joins:  Using customer table

-- Example: "Use a self join to retrieve all customers whose last name matched the first name of another customer"

SELECT a.first_name, a.last_name,b.first_name,b.last_name
FROM customer AS a, customer AS b
WHERE a.first_name = b.last_name;  
-- result is the 4 columns in the order of SELECT statement, and the rows are all the matches
--	of the first name to a last name, i.e., | Rose | Howard | Darlene | Rose |  


-- Example: Doing the same as above, but using a JOIN statement

SELECT a.customer_id, a.first_name, a.last_name, b.customer_id, b.first_name, b.last_name
FROM customer AS a
JOIN customer AS b		-- INNER JOIN after first alias in FROM statement, instead of 2 aliases with comma.
ON a.first_name = b.last_name  -- have to use ON clause with the JOIN, and not the WHERE statement in the self join.
ORDER BY a.customer_id;


-- Example: can also use a left join to provide all records from the left table regardless if there is a match.

SELECT a.customer_id, a.first_name, a.last_name, b.customer_id, b.first_name, b.last_name
FROM customer AS a
LEFT JOIN customer AS b		-- LEFT OUTER JOIN shows all of left table, and the overlap (matches) of right table.
ON a.first_name = b.last_name
ORDER BY a.customer_id;		-- results show entire right table, regardless of match, and null values in right table unless matched.

