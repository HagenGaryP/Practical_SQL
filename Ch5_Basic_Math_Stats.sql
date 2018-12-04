/* Chapter 5
*****************************************************************************
******************	Basic Math and Stats with SQL		*************
*****************************************************************************


-- Adding
SELECT 2+2;

-- Subtracting
SELECT 9 - 1;

-- Multiplying
SELECT 3 * 4;

-- Division and Modulo
SELECT 11 / 6;

-- Modulo
SELECT 11 % 6;

-- decimal division
SELECT 11.0 / 6;

-- using CAST
SELECT CAST(11 AS numeric(3,1)) / 6;

-- Exponents
SELECT 3^4;

-- square root
SELECT |/ 10;

-- square root (function)
SELECT sqrt(9.9);

-- cube root
SELECT ||/ 10;

-- factorial
SELECT 4!;

-- Order of operations

SELECT 7 + 8 * 9; 	-- answer: 79
SELECT (7 + 8) * 9;	-- answer: 135

SELECT 3 ^ 3 - 1;   -- answer: 26
SELECT 3 ^ (3 - 1); -- answer: 9


-- Listing 5-4: Selecting Census population columns by race with aliases

SELECT geo_name,
       state_us_abbreviation AS "st",
       p0010001 AS "Total Population",
       p0010003 AS "White Alone",
       p0010004 AS "Black or African American Alone",
       p0010005 AS "Am Indian/Alaska Native Alone",
       p0010006 AS "Asian Alone",
       p0010007 AS "Native Hawaiian and Other Pacific Islander Alone",
       p0010008 AS "Some Other Race Alone",
       p0010009 AS "Two or More Races"
FROM us_counties_2010;

-- Listing 5-5: Adding two columns in us_counties_2010

SELECT geo_name,
       state_us_abbreviation AS "st",
       p0010003 AS "White Alone",
       p0010004 AS "Black Alone",
       p0010003 + p0010004 AS "Total White and Black"
FROM us_counties_2010;

-- Listing 5-6: Checking Census data totals

SELECT geo_name,
       state_us_abbreviation AS "st",
       p0010001 AS "Total",
       p0010003 + p0010004 + p0010005 + p0010006 + p0010007
           + p0010008 + p0010009 AS "All Races",
       (p0010003 + p0010004 + p0010005 + p0010006 + p0010007
           + p0010008 + p0010009) - p0010001 AS "Difference"
FROM us_counties_2010
ORDER BY "Difference" DESC;



-- Listing 5-7: Calculating the percent of the population that is 
-- Asian by county (percent of the whole)

SELECT geo_name,
       state_us_abbreviation AS "st",
       (CAST(p0010006 AS numeric(8,1)) / p0010001) * 100 AS "pct_asian"
FROM us_counties_2010
ORDER BY "pct_asian" DESC;


-- Listing 5-8: Calculating percent change


-- First create a table to work with
CREATE TABLE percent_change (
    department varchar(20),
    spend_2014 numeric(10,2),
    spend_2017 numeric(10,2)
);

-- insert rows into table

INSERT INTO percent_change
VALUES
    ('Building', 250000, 289000),
    ('Assessor', 178556, 179500),
    ('Library', 87777, 90001),
    ('Clerk', 451980, 650000),
    ('Police', 250000, 223000),
    ('Recreation', 199000, 195000);

-- percent change formula subtracts spend_2014 from spend_2017 and then
-- 	divides by spend_2014.  Then multiply by 100 to express as percentage.

SELECT department,
       spend_2014,
       spend_2017,
       round( (spend_2017 - spend_2014) /
                    spend_2014 * 100, 1 ) AS "pct_change"
FROM percent_change;
-- Data Output	----------------------------------------------------------------
--------------------------------------------------------------------------------
Department		spend_2014	spend_2017		pct_change
--------------------------------------------------------------------------------
"Building";		250000.00;	289000.00;		15.6
"Assessor";		178556.00;	179500.00;		0.5
"Library";		87777.00;	90001.00;		2.5
"Clerk";		451980.00;	650000.00;		43.8
"Police";		250000.00;	223000.00;		-10.8
"Recreation";		199000.00;	195000.00;		-2.0
---------------------------------------------------------------------------------
*/

/*

*******		Aggregate Functions for Averages and Sums	*******

SQL lets you calculate a result from values within the same column using 
	aggregate functions.

Returning to the us_counties_2010 census table, it's reasonable to want to calculate
the total population of all counties plus the average population of all counties.
Using avg() and sum() on column p0010001 (the total population, from earlier)
makes it easy to calculate the average and total population.
Using the round() function we can remove numbers after the decimal point on
the average calculation.

-- Listing 5-9: Using sum() and avg() aggregate functions

SELECT sum(p0010001) AS "County Sum",
       round(avg(p0010001), 0) AS "County Average"
FROM us_counties_2010;
-- Data Output	----------------------------------------------------------------
--------------------------------------------------------------------------------
County Sum		County Average		
--------------------------------------------------------------------------------
308745538;		98233;			
---------------------------------------------------------------------------------


****************** 		Finding the Median		*******************


The Median value is the literal middle value in an ordered set of values,
and the average is the sum of all values divided by the number of values.

PostgreSQL (as with most relational databases) does not have a built-in 
median() function, similar to what you'd find in Excel or other spreadsheet apps.
It's also not included in the ANSI SQL standard.  Although, we can use an SQL
percentile function to find the median as well as other "quantiles" or "cut points",
which are the points that divide a group of numbers into equal sizes.

In statistics, percentiles indicate the point in an ordered set of data below 
which a certain peprcentage of the data is found.

The median is equivalent to the 50th percentile.

The SQL percentile functions used here are percentile_cont(n) and percentile_disc(n).

percentile_cont(n) function calculates percentiles as "continuous" values.  Meaning,
	the result does not have to be one of the numbers in the data set, but can be a 
	decimal value in between two of the numbers.  
	For instances where calculating the median on an even number of values, 
	where the median is the average of the two middle numbers.

percentile_disc(n) returns only "discrete" values.  That is, the result returned will
	rounded to one of the numbers in the set.


-- Listing 5-10: Testing SQL percentile functions

-- make a test table
CREATE TABLE percentile_test (
    numbers integer
);

-- fill six numbers into test table using INSERT INTO function
INSERT INTO percentile_test (numbers) VALUES
    (1), (2), (3), (4), (5), (6);
-- Data Output: Query returned successfully: 6 rows affected, 14 msec execution time.


-- SELECT the continuous and discrete percentiles of the numbers in test table,
--	using 0.5 to represent the 50th percentile, AKA median.
SELECT
    percentile_cont(.5)
    WITHIN GROUP (ORDER BY numbers),
    percentile_disc(.5)
    WITHIN GROUP (ORDER BY numbers)
FROM percentile_test;
-- Data Output: -------------------------------------------------------------------
-----------------------------------------------------------------------------------
	percentile_cont		percentile_disc
-----------------------------------------------------------------------------------
	3.5			3
-----------------------------------------------------------------------------------
The percentile_cont() function returned the true median, 3.5.  But since the discrete
function, percentile_disc(), literally only calculates discrete values, it reports 
the last value in the first half (50%) of the numbers: 1,2,3,4,5,6.  

*************		Median and Percentiles with Census Data 	*************

-- Listing 5-11: Using sum(), avg(), and percentile_cont() aggregate functions
SELECT sum(p0010001) AS "County Sum",
       round(avg(p0010001), 0) AS "County Average",
       percentile_cont(.5)
       WITHIN GROUP (ORDER BY p0010001) AS "County Median"
FROM us_counties_2010;
-- Data Output	----------------------------------------------------------------
--------------------------------------------------------------------------------
County Sum		County Average		County Median
--------------------------------------------------------------------------------
308745538;		98233;			25857
---------------------------------------------------------------------------------
From this we see that the median and average are far apart, which shows that using
averages can potentially mislead.  

For instance, if you gave a presentation on U.S. demographics and told the audience
that the "average county in America had 98,200 people," they'd walk away with a 
skewed picture of reality.
Nearly 40 counties had a million or more people as of the 2010 Decennial Census,
and Los Angeles County had close to 10 million.  That pushes the average much higher.

*********	Finding Other Quantiles with Percentile Functions	*************

You can also slice data into smaller equal groups.  Most common are:
	Quartiles - Four equal groups
	Quintiles - Five equal groups
	Deciles   - Ten equal groups

To find any individual value, you can just plug it into a percentile function.

For example, to find the value marking the first quartile, or the lowest 25% of data,
you'd use a value of 0.25:	percentile_cont(0.25) or percentile_cont(.25)

If you want to generate multiple cut points, pass values into percentile_cont() by
	using an array (an SQL data type that contains a list of items).


-- Listing 5-12: Passing an array of values to percentile_cont()

-- quartiles
SELECT percentile_cont(array[.25,.5,.75])
       WITHIN GROUP (ORDER BY p0010001) AS "quartiles"
FROM us_counties_2010;
-- Data Output: "{11104.5,25857,66699}"
In this example, we create an array of cut points by enclosing values in a 
"constructor" called array[].  Inside the square brackets, we provide 
	comma-separated values representing the three points at which to cut,
	which creates four quartiles.

-- quintiles
SELECT percentile_cont(array[.2,.4,.6,.8])		-- using fifths
       WITHIN GROUP (ORDER BY p0010001) AS "quintiles"
FROM us_counties_2010;
-- Data Output: "{9133,18781.2,36659,90157.2000000002}"


-- deciles
SELECT percentile_cont(array[.1,.2,.3,.4,.5,.6,.7,.8,.9])
       WITHIN GROUP (ORDER BY p0010001) AS "deciles"
FROM us_counties_2010;

-- Listing 5-13: Using unnest() to turn an array into rows

SELECT unnest(
            percentile_cont(array[.25,.5,.75])
            WITHIN GROUP (ORDER BY p0010001)
            ) AS "quartiles"
FROM us_counties_2010;
-- Data output:
		Quartiles
		11104.5
		25857
		66699


****************	Creating a median() Function		************

The PostgreSQL wiki, at http://wiki.postgresql.org/wiki/Aggregate_Median
provides a script to create a median() function.  Since there is no built-in one.

-- Listing 5-14: Creating a median() aggregate function in PostgreSQL
-- Source: https://wiki.postgresql.org/wiki/Aggregate_Median

CREATE OR REPLACE FUNCTION _final_median(anyarray)
   RETURNS float8 AS
$$
  WITH q AS
  (
     SELECT val
     FROM unnest($1) val
     WHERE VAL IS NOT NULL
     ORDER BY 1
  ),
  cnt AS
  (
    SELECT COUNT(*) AS c FROM q
  )
  SELECT AVG(val)::float8
  FROM
  (
    SELECT val FROM q
    LIMIT  2 - MOD((SELECT c FROM cnt), 2)
    OFFSET GREATEST(CEIL((SELECT c FROM cnt) / 2.0) - 1,0)
  ) q2;
$$
LANGUAGE sql IMMUTABLE;

CREATE AGGREGATE median(anyelement) (
  SFUNC=array_append,
  STYPE=anyarray,
  FINALFUNC=_final_median,
  INITCOND='{}'
);

--
-- Listing 5-15: Using a median() aggregate function
--

SELECT sum(p0010001) AS "County Sum",
       round(avg(p0010001), 0) AS "County Average",
       median(p0010001) AS "County Median",
       percentile_cont(.5)
       WITHIN GROUP (ORDER BY P0010001) AS "50th Percentile"
FROM us_counties_2010;


*********		Finding the Mode		*****************

We can find the mode, most often or frequent appearing value, by using
the postgreSQL mode() function.  The function is not part of standard SQL 
and has a syntax similar to the percentile functions.


-- Listing 5-16: Finding the most-frequent value with mode()

SELECT mode() WITHIN GROUP (ORDER BY p0010001)
FROM us_counties_2010;


*********************************************************************************
**********		Try It Yourself			*************************
*********************************************************************************

1. Write an SQL statement for calculating the area of a circle whose radius is 5 inches.

SELECT 3.14159265*(5^2);
--SELECT 3.14 * 25

2. Using the 2010 Census county data, find out which New York state county has the 
	highest percentage of the population that identified as "American Indian/
	Alaskan Native Alone."  What can you learn about that county from online research 
	that explains the relatively large population of American Indian population
	compared with other NY counties?
	American Indian and Alaska Native alone - Data dictionary reference "P0010005"

SELECT geo_name AS "county", state_us_abbreviation AS "state",
	ROUND((CAST (p0010005 AS numeric(8,1)) / p0010001) * 100,2) AS "pct_native" 
FROM us_counties_2010
WHERE state_us_abbreviation ILIKE '%NY%'
ORDER BY "pct_native" DESC
;
-- answer:  "Franklin County", which has 7.36% of its population identified as
-- 			American Indian / Alaska Native alone (p0010005).
--	The Bronx had a larger number of p0010005, but was only 1.32% 

3.  Was the 2010 median county population higher in California or New York?
*/
SELECT state_us_abbreviation AS "State", percentile_cont(.5)
	WITHIN GROUP ( ORDER BY p0010001) AS "County Median"
FROM us_counties_2010
GROUP BY state_us_abbreviation
HAVING state_us_abbreviation = 'NY' OR state_us_abbreviation = 'CA' 
;
-- CA median was higher than NY.