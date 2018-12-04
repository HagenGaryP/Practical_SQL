/*  CHAPTER 9
********************************************************************************
			INSPECTING AND MODIFYING DATA
********************************************************************************
--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros

-- Chapter 9 Code Examples
--------------------------------------------------------

-- Listing 9-1: Importing the FSIS Meat, Poultry, and Egg Inspection Directory
-- https://catalog.data.gov/dataset/meat-poultry-and-egg-inspection-directory-by-establishment-name

-- Create the table with each of the 10 columns from the csv file.
-- Add a natural primary key constraint to the est_number column.

CREATE TABLE meat_poultry_egg_inspect (
    est_number varchar(50) CONSTRAINT est_number_key PRIMARY KEY,
    company varchar(100),
    street varchar(100),
    city varchar(30),
    st varchar(2),
    zip varchar(5),
    phone varchar(14),
    grant_date date,
    activities text,
    dbas text			-- text data type allows up to 1GB
);


-- Import the CSV file
COPY meat_poultry_egg_inspect
FROM 'C:\MyScripts\Databases\MPI_Directory_by_Establishment_Name.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

-- Create an index on the "company" column to speed up searches.
CREATE INDEX company_idx ON meat_poultry_egg_inspect (company);


-- Count the rows imported:
SELECT count(*) FROM meat_poultry_egg_inspect;
-- Returns count of 6,287


----------------	Interviewing the Data Set	--------------------


The aggregate queries from Chapter 8 are a useful "interviewing" tool because
they often expose the limitations of a data set or raise questions you may
want to ask before drawing conclusions in your analysis and assuming the
validity of your findings.

For example, the "meat_poultry_egg_inspect" table's rows describe food producers.
At first glance, we might assume that each company in each row operates at a 
distinct address.  But it's never safe to assume in data analysis, so perform
a query to support assumptions.

-- Listing 9-2: Finding multiple companies at the same address

-- Group companies by unique combinations of the "company", "street", "city",
-- and "st" columns.  Then use count(*) AS "address_count" to see duplicates.
SELECT company,
       street,
       city,
       st,
       count(*) AS address_count	-- aggregate fn; req. HAVING clause.
FROM meat_poultry_egg_inspect
GROUP BY company, street, city, st
HAVING count(*) > 1			-- returns all rows with duplicates
ORDER BY company, street, city, st;
-- results show all the companies with duplicate addresses.


------------		Checking for Missing Values		---------------


-- Listing 9-3: Grouping and counting states

Use the aggregate function "count()" along with GROUP BY to determine whether
there are values from all states and whether any rows are missing a state code.

-- Count the number of times each state postal code (st) appears in the table.
-- Group by the state postal code in the column "st"
SELECT st, 
       count(*) AS st_count
FROM meat_poultry_egg_inspect
GROUP BY st
ORDER BY st;			-- order by the state postal code
-- There are 57 rows returned due to U.S. territories.

The row at the bottom of the list has a count of 3 and a NULL value 
in the "st_count" column.  To find out what this means, let's query the
rows where the st column has NULL values.

NOTE:  Depending on the database implementation, NULL values will either appear
	first or last in a sorted column.  PostgreSQL defaults NULL to appear last.

In listing 9-4, we use the technique covered in "using NULL to Find Rows with Missing
	Values" on page 83, adding a WHERE clause with the "st" column and the
	IS NULL keywords to find which rows are missing a state code:

-- Listing 9-4: Using IS NULL to find missing values in the st column

SELECT est_number,
       company,
       city,
       st,
       zip
FROM meat_poultry_egg_inspect
WHERE st IS NULL;

This query returns three rows that don't have a value in the "st" column

These missing values would lead to an incorect count of establishments
per state.  To find the source of this dirty data, it's worth making a 
quick visual check of the original file downloaded.

Unless you're working with files in the gigabyte range, you can usually
open a CSV file in a text editor and search for the row.

If you're working with larger files, you may be able to examine the 
source data by using utilities such as "grep" (on Linux and macOS)
or "findstr" (on Windows).


---------	Checking for Inconsistent Data Values		------------


We can check for inconsistently entered data within a column by using 
GROUP BY with COUNT().

-- Listing 9-5: Using GROUP BY and count() to find inconsistent company names

SELECT company,
       count(*) AS company_count
FROM meat_poultry_egg_inspect
GROUP BY company
ORDER BY company ASC;

Scrolling through the results reveals a number of cases in which a company's
name is spelled several different ways.

For example, look at "Armour-Eckrich brand". 
There are at least 4 different spellings shown for 7 establishments
that are likely owened by the same company; since they all are some variation 
of "Armour-Eckrich brand"

If we later perform any aggregation by company, it would help to standardize
the names so all of the items counted or summed are grouped properly.


---------	Checking for Malformed Values Using length()	-------------


Check for unexpected values in a column that should be consistently formatted.

Solely for the purpose of this example, I replicated an error I've committed
before.  When I converted the original Excel file to a CSV, I stored the 
ZIP Code in the "General" number format in the spreadsheet instead of as
a text value.  By doing so, any ZIP Code that begins with a zero, such
as 07502 for Paterson, NJ, lost the leading zero because an integer
can't start with a zero.
As a result, 07502 appears in the table as 7502.  

You can make this error in a variety of ways, including by copying and
pasting data into Excel columns set to "General."  This is why you should
take causion with numbers that should be formatted as text.

We can see the previously mentioned error when we run the code in Listing 9-6.

The example introduces length(), a "string function" that counts the number of
characters in a string.  
We combine length() with count() and GROUP BY to determine how many rows have 
five characters in the "zip" field and how many have a value other than five.

To make it easy to scan the results, we use length() in the ORDER BY clause.

-- Listing 9-6: Using length() and count() to test the zip column

SELECT length(zip),
       count(*) AS length_count
FROM meat_poultry_egg_inspect
GROUP BY length(zip)
ORDER BY length(zip) ASC;

The results confirm the formatting error.  496 of the ZIP codes are
only four characters long, and 86 are three characters long, which
means these numbers originally had two leading zeros that the
conversion erroneously eliminated.

Using the WHERE clause, we can check the details of the results to see which
states these shortened ZIP Codes correspond to, as shown in Listing 9-7:

-- Listing 9-7: Filtering with length() to find short zip values

SELECT st,
       count(*) AS st_count
FROM meat_poultry_egg_inspect
WHERE length(zip) < 5
GROUP BY st
ORDER BY st ASC;

The length() function inside the WHERE clause returns a count of rows where
the ZIP Code is less than 5 characters for each state code.

Obviously, we don't want this error to persist, so we'll add it to our list
of items to correct.  so far, we need to correct the following issues in
our data set:
1.  Missing values for three rows in the "st" column.
2.  Inconsistent spelling of at least one company's name.
3.  Inaccurate ZIP Codes due to file conversion.


-----------		Modifying Tables, Columns, and Data		------------


As your needs change, you can add columns to a table, change data types on existing
columns, and edit values.

You can use SQL to modify, delete, or add to existing data and structures.

To make changes to our database, we'll use two SQL commands: 

The first command, ALTER TABLE, is part of the ANSI SQL standard and provides 
options to ADD COLUMN, ALTER COLUMN, and DROP COLUMN, among others.

The second command, UPDATE, allows you to change values in a table's columns.
You can supply criteria using the WHERE clause to choose which rows to update.


---------		Modifying Tables with ALTER TABLE		------------

We can use the ALTER TABLE statement to modify the structure of tables.

The code for adding a column to a table looks like this:

-- Add column
ALTER TABLE table_name ADD COLUMN column_name data_type;

-- Remove column with DROP

ALTER TABLE table_name DROP column_name;

-- To change the data type of a column, use ALTER COLUMN

ALTER TABLE table_name ALTER COLUMN column_name data_type;

-- Adding a NOT NULL constraint to a column, using ALTER COLUMN and SET

ALTER TABLE table_name ALTER COLUMN column_name SET NOT NULL;

-- Removing a NOT NULL constraint from a column, using ALTER COLUMN and DROP

ALTER TABLE table_name ALTER COLUMN column_name DROP NOT NULL;



----------		Modifying Values with UPDATE		---------------


The UPDATE statement modifies the data in a column in all rows or in a subset
of rows that meet a condition.  Its basic syntax (to update every row in column):

UPDATE table_name
SET column_name = value;

We first pass UPDATE the name of the table to update, then pass the SET clause 
the column that contains the values to change.  The new "value" to place in the
column can be a string, number, the name of another column, or even a query
or expression that generates a value.

-- Updating values in multiple columns at once by adding columns separated by commas.

UPDATE table_name
SET column_a = value,
	column_b = value;

To restrict the update to particular rows, we add a WHERE clause with some criteria
that must be met before the update can happen:

UPDATE table_name
SET column_name = value
WHERE conditional_criteria;

We can also update one table with values from another table.  Standard ANSI SQL 
requires the use of a "Subquery," which is a query inside a query, to specify
which values and rows to update:

UPDATE table_name
SET column_name = (SELECT column_name			-- start of subquery
		FROM table_b
		WHERE table.column_name = table_b.column_name)	-- end subquery
WHERE EXISTS (SELECT column_name		
		FROM table_b
		WHERE table.column_name = table_b.column_name);

The value portion of the SET clause is a subquery, which is a SELECT statement
insdie parentheses that generates the values for the update.  Similarly, 
the WHERE EXISTS clause uses a SELECT statement to generate values that
serve as the filter for the update.  If we did not use the WHERE EXISTS clause,
we might inadvertently set some values to NULL without intending to.

-- Updating across tables using a FROM clause.

UPDATE table_name
SET column_name = table_b.column_name
FROM table_b
WHERE table_name.column_name = table_b.column;



----------		Creating Backup Tables		----------------------


Listing 9-8 shows how to use a variation of the CREATE TABLE statement to make 
a new table based on the existing data and structure of the table to duplicate:

CREATE TABLE meat_poultry_egg_inspect_backup AS
SELECT * FROM meat_poultry_egg_inspect;

-- Check number of records:
SELECT 
    (SELECT count(*) FROM meat_poultry_egg_inspect) AS original,
    (SELECT count(*) FROM meat_poultry_egg_inspect_backup) AS


Use ALTER TABLE to make copies of column data within the table we're updating.

NOTE:  Indexes are not copies when creating a table backup using CREATE TABLE.



---------------		Restoring Missing Column Values		----------------


Use an UPDATE statement to fill the missing values from Listing 9-4.

Take extra caution by making a copy of the "st" column within the table,
so we still have the original data if we make an error.

-- Listing 9-9: Creating and filling the st_copy column with ALTER TABLE and UPDATE

ALTER TABLE meat_poultry_egg_inspect ADD COLUMN st_copy varchar(2);

UPDATE meat_poultry_egg_inspect
SET st_copy = st;

The ALTER TABLE statement adds a column called "st_copy" using the same varchar 
data type as the original "st" column.  Next, the UPDATE statement's SET clause
fills our newly created "st_copy" column with the values in the column "st."

Because we don't specify any criteria using a WHERE clause, values in every 
row are updated.

-- Listing 9-10: Checking values in the st and st_copy columns

SELECT st,
       st_copy
FROM meat_poultry_egg_inspect
ORDER BY st;

-- Updating Rows Where Values Are Missing

To update those rows missing values, we first find the values we need with
a quick online search: Atlas Inspection is located in Minnesota; Hall-Namie
Packing is in Alabama; and Jones Dairy is in Wisconsin.  Add those states to 
the appropriate rows using the code in Listing 9-11:

-- Listing 9-11: Updating the st column for three establishments

UPDATE meat_poultry_egg_inspect
SET st = 'MN'
WHERE est_number = 'V18677A';

UPDATE meat_poultry_egg_inspect
SET st = 'AL'
WHERE est_number = 'M45319+P45319';

UPDATE meat_poultry_egg_inspect
SET st = 'WI'
WHERE est_number = 'M263A+P263A+V263A';

Since we want each UPDATE statement to affect a single row, we include
a WHERE clause for each that identifies the company's unique "est_number,"
which is the table's primary key.

-- Restoring Original Values

-- Listing 9-12: Restoring original st column values

-- Restoring from the column backup
UPDATE meat_poultry_egg_inspect
SET st = st_copy;

-- Restoring from the table backup
UPDATE meat_poultry_egg_inspect original
SET st = backup.st
FROM meat_poultry_egg_inspect_backup backup
WHERE original.est_number = backup.est_number; 

To resotre the values from the backup column in "meat_poultry_egg_inspect"
you created in Listing 9-9, run an UPDATE query that sets "st" to the values
in "st_copy".  Both columns should again have the identical orignal values.

Alternatively, you can create an UPDATE that sets "st" to values in the "st"
columns from the "meat_poultry_egg_inspect_backup" table that you made
in Listing 9-8.


--------		Updating Values for Consistency		-------------


In Listing 9-5 we discovered several cases where a single company's name was 
entered inconsistently.  If we want to aggregate data by company name, such
inconsistencies will hinder us from doing so.
Recall the example with the various spellings of "Armour-Eckrich Meats"

We can standardize the spelling of this company's name by usiing an UPDATE statement.

To protect our data, we'll create a new column for the standarized spellings, 
copy the names in "company" into the new column, and work int he new column
to avoid tampering with the original data.

-- Listing 9-13: Creating and filling the company_standard column

ALTER TABLE meat_poultry_egg_inspect ADD COLUMN company_standard varchar(100);

UPDATE meat_poultry_egg_inspect
SET company_standard = company;


Now, let's say we want any name in "company" that contains the string 
"Armour" to appear in "company_standard" as "Armour-Eckrich Meats."
(This assumes we've checked all entries containing Armour and want to
standardize them.)

We can update all the rows matching the string "Armour" by using 
a WHERE clause.

-- Listing 9-14: Use UPDATE to modify field values that match a string

UPDATE meat_poultry_egg_inspect
SET company_standard = 'Armour-Eckrich Meats'
WHERE company LIKE 'Armour%';

SELECT company, company_standard
FROM meat_poultry_egg_inspect
WHERE company LIKE 'Armour%';

The important piece of this query is the WHERE clause that uses the LIKE
keyword.  Including the wildcard syntax % at the end of the string "Armor" updates
all those characters regardless of what comes after them.
The SELECT statement in listing 9-14 returns the results of the updated
"company_standard" column next to the orignal "company" column.

If we want to standardize other company names in the table, we would create
an UPDATE statement for each case.  We would also keep the original
"company" column for reference.


-----------	Repairing ZIP Codes Using Concatenation		-----------


Concatenation combines two or more string or non-string values into one.

We use the UPDATE statement in conjunction with the double-pipe (||) 
"string operator," which performs concatenation.

For example, inserting || between the strings "abc" and "123" results 
in "abc123."

You can use  ||  (concatenation) in many contexts, such as UPDATE queries
and SELECT, to provide custom output from existing as well as new data.

First, listing 9-15 makes a backup copy of the zip column in the same way
we made a backup of the st column earlier:

-- Listing 9-15: Creating and filling the zip_copy column

ALTER TABLE meat_poultry_egg_inspect ADD COLUMN zip_copy varchar(5);

UPDATE meat_poultry_egg_inspect
SET zip_copy = zip;


Next, we use the code in listing 9-16 to perform the first update:

-- Listing 9-16: Modify codes in the zip column missing two leading zeros

UPDATE meat_poultry_egg_inspect
SET zip = '00' || zip
WHERE st IN('PR','VI') AND length(zip) = 3;


We use SET to set the sip column to a value that is the result of the 
concatenation of the string 00 and the existing content of the zip column.
We limit the UPDATE to only those rows where the st column has the state 
codes "PR" and "VI" using the IN comparison operator and add a test for
rows where the length of "zip" is 3.


Now, let's repair the remaining zip codes using a simlar query.

-- Listing 9-17: Modify codes in the zip column missing one leading zero

UPDATE meat_poultry_egg_inspect
SET zip = '0' || zip
WHERE st IN('CT','MA','ME','NH','NJ','RI','VT') AND length(zip) = 4;


In this example we used concatenation, but you can employ additional SQL
string functions to modify data with UPDATE by changing words from
uppercase to lowercase, trimming unwated spaces, replacing characters
in a string, and more.  String functions will be discussed in chapter 13.



--------		Updating Values Across Tables		-----------


When data in one table is necessary context for updating values in another.

For example, let's say we're setting an inspection date for each of the 
companies in our table.  We want to do this by U.S. regions, such as
Northeast, Pacific, and so on, but those regional designations don't exist
in our table.
However, they do exist in a data set we can add to our database that also 
contains matching "st" state codes.
This means we can use that other data as part of our UPDATE statement to 
provide the necessary information.

first, create a table and fill it with data
-- Listing 9-18: Creating and filling a state_regions table

CREATE TABLE state_regions (
    st varchar(2) CONSTRAINT st_key PRIMARY KEY,
    region varchar(20) NOT NULL
);

COPY state_regions
FROM 'C:\YourDirectory\state_regions.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

We create two columns in a "state_regions" table: one containing the 
two-character state code "st" and the other containing the "region" name.
We set the primary key constraint to the "st" column, which holds a unique
"st_key" value to identify each state.  

In the data you're importing, each state is present and assigned to a U.S. 
Census region, and territories outside the U.S. are labeled as such.

Update the table one region at a time.

-- Listing 9-19: Adding and updating an inspection_date column

ALTER TABLE meat_poultry_egg_inspect ADD COLUMN inspection_date date;

UPDATE meat_poultry_egg_inspect inspect
SET inspection_date = '2019-12-01'
WHERE EXISTS (SELECT state_regions.region
              FROM state_regions
              WHERE inspect.st = state_regions.st 
                    AND state_regions.region = 'New England');

The ALTER TABLE statement creates the "inspection_date" column in the
"meat_poultry_egg_inspect" table.  In the UPDATE statement, we start
by naming the table using an alias of "inspect" to make the code easier
to read.

Next, the SET clause assigns a date value of "2019-12-01" to the new
"inspection_date" column.

Finally, the WHERE EXISTS clause includes a subquery that connects the 
"meat_poultry_egg_inspect" table to the "state_regions" table and 
specifies which rows to update.  The subquery (in parentheses, beginning
with SELECT) looks for a row in the "state_regions" table where the 
region column matches the string "New England."  
At the same time, it joins the "meat_poultry_egg_inspect" table with the
"state_regions" table using the "st" column from both tables.  

In effect, the query is telling the database to find all the "st" codes that 
correspond to the New England region and use those codes to filter the update.

-- Listing 9-20: Viewing updated inspection_date values

SELECT st, inspection_date
FROM meat_poultry_egg_inspect
GROUP BY st, inspection_date
ORDER BY st;


To fill in dates for additional regions, substitute a different region for
"New England" in listing 9-19 and rerun the query.



--------------		Deleting Unnecessary Data		--------------


The most irrevocable way to modify data is to remove it entirely.  SQL includes
opotions to remove rows and columns from a table along with options to delete
an entire table or database.  We want to perform these operations with caution,
removing only data or tables we don't need. 

Without a backup, the removed data can not be accessed again.

NOTE:  It's easy to exclude unwanted data in queries using a WHERE clause,
	so decide whether you truly need to delete the data or can just
	filter it out.  Cases where deleting may be the best solution
	include data with errors or data imported incorrectly.

-- Deleting Rows from a Table

Using a DELETE  FROM statement, we can remove all rows from a table, or we
can use a WHERE clause to delete only the portion that matches an expression
we supply.

-- To delete all rows from a table
DELETE FROM table_name;

To erase the table, use the DROP TABLE command.

To remove only selected rows, add a WHERE clause along with the matching
value or pattern to speify which ones you want to delte:

DELETE FROM table_name WHERE expression;

For example, we can remove the companies in Puerto Rico and the Virgin Islands
from the table using
-- Listing 9-21: Delete rows matching an expression

DELETE FROM meat_poultry_egg_inspect
WHERE st IN('PR','VI');


-- Deleting a Column from a Table

We can remove the backup column, called "zip_copy" since we no longer need it,
including all the data within the column.  Use the DROP keyword in the 
ALTER TABLE statement to delete the backup column.

The syntax for removing a column is similar to other ALTER TABLE statements:
ALTER TABLE table_name DROP COLUMN column_name;

-- Listing 9-22: Remove a column from a table using DROP

ALTER TABLE meat_poultry_egg_inspect DROP COLUMN zip_copy;

-- Deleting a Table from a Database

The DROP TABLE statement is a standard ANSI SQL feature that deletes a table
from the database.  Used for cases where you have a collection of backups,
or "working tables," that have outlived their usefulness; or when you need to
change the structure of a table significantly, in which case, rather than using
too many ALTER TABLE statements you can just remove the table and create another
one by running a new CREATE TABLE statement.

DROP TABLE table_name;

-- Listing 9-23: Remove a table from a database using DROP

DROP TABLE meat_poultry_egg_inspect_backup;



-------		Using Transaction Blocks to Save / Revert Changes	-------


After running a DELETE or UPDATE query (or any other query that alters your data
or database structure), the only way to undo the change is to restore from
a backup.

However, you can check your changes before finalizing them and cancel the change
if it's not what you intended.

You do this by wrapping the SQL statement within a 
"transaction block", which is a group of statements you define using the
following keywords at the beginning and end of the query:

START TRANSACTION signals the start of the transaction block.  In PostgreSQL,
			you can also use the non-ANSI SQL "BEGIN" keyword.

COMMIT signals the end of the block and saves all changes.

ROLLBACK signals the end of the block and reverts all changes.


We can apply this transaction block technique to review changes a query makes
and then decide whether to keep or discard them.

For example,
	We want the name to be consistent, so we'll remove the comma from company
	values using an UPDATE query, as we did earlier.  But this time we'll check
	the result of our update before we make it final (and we'll purposely make 
	a mistake to discard). 

-- Listing 9-24: Demonstrating a transaction block

-- Start transaction and perform update
START TRANSACTION;

UPDATE meat_poultry_egg_inspect
SET company = 'AGRO Merchantss Oakland LLC'
WHERE company = 'AGRO Merchants Oakland, LLC';

-- view changes
SELECT company
FROM meat_poultry_egg_inspect
WHERE company LIKE 'AGRO%'
ORDER BY company;

-- Revert changes
ROLLBACK;
-- query result with 3 rows discarded.

Run each statement separately, beginning with START TRANSACTION;.
the database responds with the message "start transaction," letting you
know that any succeeding changes you make to data will not be made permanent
unless you issue a COMMIT command.
Next, the UPDATE statement changes the company name in the row where it has
an extra comma.  An extra 's' was intentionally added in the name used in the
SET clause above to introduce a mistake.

When viewing the names of companies starting with the letters AGRO using the 
SELECT statement, you can see one company is misspelled.
Instead of rerunning the UPDATE statement to fix the typo, we can simply
discard the change by running the ROLLBACK; command.  

When we rerun the SELECT statement to view thee company names, we're back to 
where we started.  From here you could correct your UPDATE statement by 
removing the extra 's' and rerunning it, beginning with the START TRANSACTION
statement again.  Once you're satisfied with the changs, run COMMIT; to 
make them permanent.

NOTE:  When you start a transaction, any changes you make to the data aren't
	visible to other database users until you execute COMMIT.

--Listing 9-24 continued...
-- See restored state
SELECT company
FROM meat_poultry_egg_inspect
WHERE company LIKE 'AGRO%'
ORDER BY company;

-- Alternately, commit changes at the end:
START TRANSACTION;

UPDATE meat_poultry_egg_inspect
SET company = 'AGRO Merchants Oakland LLC'
WHERE company = 'AGRO Merchants Oakland, LLC';

COMMIT;



-------		Improving Performance When Updating Large Tables	--------


Because of how PostgreSQL works internally, adding a column to a table and filling
it with values can quickly inflate the table's size.  The reson is that the database
creates a new version of the existing row each time a value is updated, but it
doesn't delete the old row version.  Database maintenance cleans these old rows
by using VACUUM which is discussed on page 314 of the text.

Instead of adding a column and filling it with values, we can save disk space
by copying the entire table and adding a populated column during the operation.
The we rename the tables so the copy replaces the original, and the original
now becomes a backup.

-- Listing 9-25: Backing up a table while adding and filling a new column

CREATE TABLE meat_poultry_egg_inspect_backup AS
SELECT *,
       '2018-02-07'::date AS reviewed_date
FROM meat_poultry_egg_inspect;

In addition to selecting all the columns using the asterisk wildcard, we also
add a column called "reviewed_date" by providing a value cast as a
date data type and the AS keyword.


-- Listing 9-26: Swapping table names using ALTER TABLE

ALTER TABLE meat_poultry_egg_inspect RENAME TO meat_poultry_egg_inspect_temp;
ALTER TABLE meat_poultry_egg_inspect_backup RENAME TO meat_poultry_egg_inspect;
ALTER TABLE meat_poultry_egg_inspect_temp RENAME TO meat_poultry_egg_inspect_backup;

Here we use ALTER TABLE with a RENAME TO clause to change a table name.