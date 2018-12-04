/* CREATE TABLE - create a account table 

CREATE TABLE account (			-- table name is "account"
user_id serial PRIMARY KEY, 		-- "user_id" column is primary key, and serial allows incrementation for data type
username VARCHAR(50) UNIQUE NOT NULL,	-- "username" variable character data type, must be unique and not left empty.
password VARCHAR(50) NOT NULL,
email VARCHAR(355) UNIQUE NOT NULL,
created_on TIMESTAMP NOT NULL,
last_login TIMESTAMP);

-- Create a table called "roll" that consists of two columns, role_id and role_name.

CREATE TABLE role(
role_id serial PRIMARY KEY,
role_name VARCHAR(250) UNIQUE NOT NULL);


-- Create a table called "account_roll" 

CREATE TABLE account_role(
user_id integer NOT NULL,
role_id integer NOT NULL,
grant_date timestamp without time zone,
PRIMARY KEY (user_id,role_id),
	-- the next block of code is just pasted in from a future lecture, so "CONSTRAINT" isn't explained yet.
CONSTRAINT account_role_role_id_fkey FOREIGN KEY (role_id)
		REFERENCES role (role_id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION,
		
	CONSTRAINT account_role_user_id_fkey FOREIGN KEY (user_id)
		REFERENCES account (user_id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Set the CONSTRAINT of the FOREIGN KEY and we base it off the column that we defined earlier here.
-- and then we give it the REFERENCE which references the table name "role" and the column from that table.
-- then we have some possibilities for actions.
*/

/*
Challenge: Create Table
Section 11, Lecture 72

Create a table to organize our potential leads! We will have the following information:

A customer's first name, last name,email,sign-up date, and number of minutes spent on the dvd rental site. 
You should also have some sort of id tracker for them. You have free reign on how you want to create this table, 
the next lecture will show one possible implementation of this.

Remember, we're just focused on the basics of creating a table right now!



CREATE TABLE potential_leads(
user_id serial PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(250) UNIQUE NOT NULL,
sign_up_date TIMESTAMP NOT NULL,
minutes integer NOT NULL
);

*/

/* Lecture 73
************************		INSERT		****************************	

When you create a new table, it doesn't have any data inside it yet.

The first thing you often do is insert new rows into the table.

SQL provides the INSERT statement that allows you to insert one or more rows into a table at a time.

First, you specify the name of the table that you want to insert a new row after
the INSERT INTO clause, followed by a comma-separated column list.

Second, you list a comma-separated value list after the VALUES clause. 
The value list must be in the same order as the columns list specified after table name.

	Typical syntax is as followed:

INSERT INTO table(column1,column2,...)
VALUES(value1, value2, ...);

To add multiple rows into a table at a time, you use the following syntax:

INSERT INTO table (column1, column2,...)
VALUES (value1, value2,...), 
	(value1, value2,...), ... ;

To insert data that comes from another table, you use the INSERT INTO SELECT statement as follows:

INSERT INTO table
SELECT column1, column2,...
FROM another_table
WHERE condition;

-- create a table called link

CREATE TABLE link (
ID serial PRIMARY KEY,
url VARCHAR(255) NOT NULL,
name VARCHAR(255) NOT NULL,
description VARCHAR(255),
rel VARCHAR(50)
);

-- To make sure everything worked, in creating a table, do the following.

SELECT * FROM link;  -- should show all 5 columns from above code.

-- INSERT INTO table link

INSERT INTO link (url,name)
VALUES
('www.google.com', 'Google');

-- to make sure the INSERT INTO code from above worked, do the following.

SELECT * FROM link;	-- results show "id" (integer) column with value 1
			-- "url" (character varying(255)) column with 'www.google.com'
			-- "name" (character varying(255)) column with 'Google'
			-- rest of columns are null

-- INSERT INTO link again.

INSERT INTO link (url,name)
VALUES
('www.yahoo.com', 'Yahoo');

-- seeing what changed in the table

SELECT * FROM link; 	-- results in the same structure as previous insert, only new values.

-- INSERT TABLE multiple rows into link

INSERT INTO link (url,name)
VALUES
('www.bing.com', 'Bing'),
('www.amazon.com', 'Amazon'); -- this was executed (with F5) twice, so it shows bing and amazon twice.


-- seeing what changed in the table

SELECT * FROM link; 	-- results in the same structure as previous insert, only new values and duplicates of above


-- INSERTing data from another table; to do this we have to create another table that is the link table.

CREATE TABLE link_copy(LIKE link);  -- shortcut to making this new table with the same structure as another table (link).
-- if you pass in parentheses like, with table name, (LIKE table_name), 
	-- it will automatically create the table with the same structures as the table LIKE clause.
	-- CREATE TABLE new_table LIKE (old_table);  -- which copies the same schema from old table, into new.

SELECT * FROM link_copy;  -- shows exact same structure as link table, but no data is in it.. just same columns.

-- how to INSERT rows from antoher table.

INSERT INTO link_copy
SELECT * FROM link
WHERE name = 'Bing';  -- Query returned successfully: 2 rows affected, since 'bing' previously executed twice.

-- checking if the above INSER worked correctly
SELECT * FROM link_copy;
*/

/*
	Lecture 73
*******************		UPDATE 		*********************

How to use the UPDATE statement to update existing data in a table.

To change the values of the columns in a table, you use the UPDATE statement, with following syntax:

UPDATE table
SET 	column1 = value1,
	column2 = value2,
	column3 = value3,...
WHERE condition;


For example:
UPDATE link
SET 	name = 'my_name' -- this would update all the rows/values of name column to equal that string ('my_name')
WHERE condition;  -- add a condition to specifically update only certain rows


First, you specify the table name wher eyou want to update the data after the UPDATE clause.
Second, list the columns whose values you want to change in the SET clause.
Third, (if you want) determine which rows you want to update in tthe condtion of the WHERE clause.


-- view the table "link"
SELECT * FROM link;
-- Query returned successfully:
     | id |  	url      |   name      | description	|	rel	|
	1;"www.google.com";"Google"
	2;"www.yahoo.com";"Yahoo"
	3;"www.bing.com";"Bing"
	4;"www.amazon.com";"Amazon"
	5;"www.bing.com";"Bing"
	6;"www.amazon.com";"Amazon"
-- End of Query.


-- UPDATE everything in link table to show description column as the string "Empty Description"
UPDATE link
SET description = 'Empty Description'; -- Query returned successfully: 6 rows affected, 14 msec execution time.

-- This is obviously usefull  to update data, like name implies.

-- check what the update did to the table.
SELECT * FROM link;
-- Query returned successfully:
     | id |  		url     	|   name      | description		|	rel	|
	1;	"www.google.com";	"Google";	"Empty Description"
	2;	"www.yahoo.com";	"Yahoo";	"Empty Description"
	3;	"www.bing.com";		"Bing";		"Empty Description"
	4;	"www.amazon.com";	"Amazon";	"Empty Description"
	5;	"www.bing.com";		"Bing";		"Empty Description"
	6;	"www.amazon.com";	"Amazon";	"Empty Description"
-- End of Query.

-- UPDATE using a WHERE statement, in order to specifically update only certain rows of a column.

UPDATE link
SET 	description = 'Name starts with an A'
WHERE name LIKE 'A%';  -- Query returned successfully: 2 rows affected, 14 msec execution time.


SELECT * FROM link;
-- Query returned successfully:
     | id |  		url     	|   name      | description		|	rel	|
	1;	"www.google.com";	"Google";	"Empty Description"
	2;	"www.yahoo.com";	"Yahoo";	"Empty Description"
	3;	"www.bing.com";		"Bing";		"Empty Description"
	5;	"www.bing.com";		"Bing";		"Empty Description"
	4;	"www.amazon.com";	"Amazon";	"Name starts with an A"
	6;	"www.amazon.com";	"Amazon";	"Name starts with an A"
-- End of Query.


-- How to update the data of a column from another column within the same table.
-- 	This will be really similar, except we'll just pass in the name of a table.

UPDATE link
SET description = name;		-- description column = name column
--  These two data types must match up; They're both varying character strings. So, no errors.
--		Query returned successfully: 6 rows affected, 14 msec execution time.


SELECT * FROM link;
-- Query returned successfully:
     | id |  		url     	|   name      | description		|	rel	|
	1;	"www.google.com";	"Google";	"Google"
	2;	"www.yahoo.com";	"Yahoo";	"Yahoo"
	3;	"www.bing.com";		"Bing";		"Bing"
	5;	"www.bing.com";		"Bing";		"Bing"
	4;	"www.amazon.com";	"Amazon";	"Amazon"
	6;	"www.amazon.com";	"Amazon";	"Amazon"
-- End of Query.

*/

/*
-- Finding Duplicate Rows --
-- To find duplicate rows in tables with a very large dataset, use the following:
SELECT column_name1, COUNT (column_name1)
FROM table_name
GROUP BY column_name1
HAVING COUNT (column_name1) > 1
ORDER BY column_name1;

SELECT name, COUNT (name)
FROM link
GROUP BY name
HAVING COUNT (name) > 1
ORDER BY name; 		-- Query results show Amazon and Bing with count of 2.  meaning duplicates.

-- Deleting duplicate rows using DELETE USING statement
-- The following statement uses the DELETE USING statement to remove duplicate rows:

DELETE
FROM 
	link a
		USING link b
WHERE
	a.id < b.id
	AND a.name = b.name; -- Query returned successfully: 2 rows affected, 14 msec execution time.


-- In this example, we joined the link table to itself and checked if two different rows (a.id < b.id) have 
--		the same value in the name column.

-- Let’s query the link table again to verify whether the duplicate rows were deleted:

SELECT * FROM link;
-- Query returned successfully:
     | id |  		url     	|   name      | description		|	rel	|
	1;	"www.google.com";	"Google";	"Google"
	2;	"www.yahoo.com";	"Yahoo";	"Yahoo"
	5;	"www.bing.com";		"Bing";		"Bing"
	6;	"www.amazon.com";	"Amazon";	"Amazon"
-- End of Query.

-- As you can see, the statement removed the duplicate rows with lowest ids and keep the one with the highest id.

-- To undo an update with PostgreSQL, called a rollback.


UPDATE link 
SET id = 4
WHERE name = 'Amazon';  -- also did this for "Bing" to correct the id numbers.

SELECT * FROM link
ORDER BY id;


-- Deleting duplicate rows using subquery

The following statement uses a suquery to delete duplicate rows and keep the row with the lowest id.

DELETE FROM basket
WHERE id IN
    (SELECT id
    FROM 
        (SELECT id,
         ROW_NUMBER() OVER( PARTITION BY fruit
        ORDER BY  id ) AS row_num
        FROM basket ) t
        WHERE t.row_num > 1 );
In this example, the subquery returned the duplicate rows except for the first row in the duplicate group. And the outer DELETE statement deleted the duplicate rows returned by the subquery.

-- If you want to keep the duplicate row with highest id, just change the order in the subquery:

DELETE FROM basket
WHERE id IN
    (SELECT id
    FROM 
        (SELECT id,
         ROW_NUMBER() OVER( PARTITION BY fruit
        ORDER BY  id DESC ) AS row_num
        FROM basket ) t
        WHERE t.row_num > 1 );
-- In case you want to delete duplicate based on values of multiple columns, here is the query template:

DELETE FROM table_name
WHERE id IN
    (SELECT id
    FROM 
        (SELECT id,
         ROW_NUMBER() OVER( PARTITION BY column_1,
         column_2
        ORDER BY  id ) AS row_num
        FROM table_name ) t
        WHERE t.row_num > 1 );
In this case, the statement will delete all rows with duplicate values in the column_1 and column_2 columns.

-- Deleting duplicate rows using an immediate table

To delete rows using an immediate table, you use the following steps:

Create a new table with the same structure as the one whose duplicate rows should be removed.
Insert distinct rows from the source table to the immediate table.
Drop the source table.
Rename the immediate table to the name of the source table.

The following illustrates the steps of removing duplicate rows from the basket table:
**************************************************************************************
					-- step 1
CREATE TABLE basket_temp (LIKE basket);
 
					-- step 2
INSERT INTO basket_temp(fruit, id)
SELECT 
    DISTINCT ON (fruit) fruit,
    id
FROM basket; 
 
					-- step 3
DROP TABLE basket;
 
					-- step 4
ALTER TABLE basket_temp 
RENAME TO basket;  
*****************************************************************************************
               
In this tutorial, you have learned how to delete duplicate rows in PostgreSQL 
using the DELETE USING statement, subquery, and the immediate table techniques.




--


UPDATE link
SET description = 'New Description'
WHERE id = 1;  -- Query returned successfully: one row affected, 15 msec execution time.

-- to actually get the results of updated entries, can add another keyword, RETURNING.

UPDATE link
SET description = 'New Description'
WHERE id = 1
RETURNING id,url,name,description; -- Returns the resulting row that was updated.

-- another way of returning 

SELECT * FROM link;  -- scroll to google, and see its description is now "New Description"
*/

/*
Lecture 76
**********************		DELETE 		*************************

To delete rows in a table, you use the DELETE statement as follows:

DELETE FROM table
WHERE condition

First, specify the table where you want to delete in the DELETE FROM clause.
Second, specify which row to delete by using the condition in the WHERE clause.
	If you omit the WHERE clause, all rows in the table are deleted.


The DELETE statement returns the number of rows deleted.
If no rows are deleted, the DELETE statement returns zero.

-- Try to delete everything that starts with "B"

DELETE FROM link
WHERE name LIKE 'B%';  -- Query returned successfully: one row affected, 15 msec execution time.
-- told us the number of rows affected.


SELECT * FROM link;  -- shows that "Bing" was deleted, since it starts with a "B".

-- Query returned successfully:
     | id |  		url     	|   name      | description		|	rel	|
	2;	"www.yahoo.com";	"Yahoo";	"Yahoo"
	4;	"www.amazon.com";	"Amazon";	"Amazon"
	1;	"www.google.com";	"Google";	"New Description"
-- End of Query.


-- INSERT INTO table "link" a row with "www.a.com" and name "A"; just so we can delete it after.
INSERT INTO link (url,name, description)
VALUES
('www.a.com', 'A', 'A'); -- Query returned successfully: one row affected, 13 msec execution time.


SELECT * FROM link;
-- Query returned successfully:
     | id |  		url     	|   name      | description		|	rel	|
	2;	"www.yahoo.com";	"Yahoo";	"Yahoo"
	4;	"www.amazon.com";	"Amazon";	"Amazon"
	1;	"www.google.com";	"Google";	"New Description"
	7;	"www.a.com";		"A";		"A"
-- End of Query.


-- delete everything that starts with "A" and use RETURNING statement.

DELETE FROM link
WHERE name LIKE 'A'
RETURNING *;  -- RETURNING * returns all. Or can specify which row, i.e., RETURNING id, url, name.....

-- Query returned successfully:
     | id |  		url     	|   name      | description		|	rel	|
	7;	"www.a.com";		"A";		"A"

-- End of Query.
*/

SELECT * FROM link;
-- Query returned successfully:
     | id |  		url     	|   name      | description		|	rel	|
	2;	"www.yahoo.com";	"Yahoo";	"Yahoo"
	4;	"www.amazon.com";	"Amazon";	"Amazon"
	1;	"www.google.com";	"Google";	"New Description"
-- End of Query.


	