/*
--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros

-- Chapter 8 Code Examples
--------------------------------------------------------------

-- Listing 8-1: Creating and filling the 2014 Public Libraries Survey table

CREATE TABLE pls_fy2014_pupld14a (
    stabr varchar(2) NOT NULL,
    fscskey varchar(6) CONSTRAINT fscskey2014_key PRIMARY KEY,
    libid varchar(20) NOT NULL,
    libname varchar(100) NOT NULL,
    obereg varchar(2) NOT NULL,
    rstatus integer NOT NULL,
    statstru varchar(2) NOT NULL,
    statname varchar(2) NOT NULL,
    stataddr varchar(2) NOT NULL,
    longitud numeric(10,7) NOT NULL,
    latitude numeric(10,7) NOT NULL,
    fipsst varchar(2) NOT NULL,
    fipsco varchar(3) NOT NULL,
    address varchar(35) NOT NULL,
    city varchar(20) NOT NULL,
    zip varchar(5) NOT NULL,
    zip4 varchar(4) NOT NULL,
    cnty varchar(20) NOT NULL,
    phone varchar(10) NOT NULL,
    c_relatn varchar(2) NOT NULL,
    c_legbas varchar(2) NOT NULL,
    c_admin varchar(2) NOT NULL,
    geocode varchar(3) NOT NULL,
    lsabound varchar(1) NOT NULL,
    startdat varchar(10),
    enddate varchar(10),
    popu_lsa integer NOT NULL,
    centlib integer NOT NULL,
    branlib integer NOT NULL,
    bkmob integer NOT NULL,
    master numeric(8,2) NOT NULL,
    libraria numeric(8,2) NOT NULL,
    totstaff numeric(8,2) NOT NULL,
    locgvt integer NOT NULL,
    stgvt integer NOT NULL,
    fedgvt integer NOT NULL,
    totincm integer NOT NULL,
    salaries integer,
    benefit integer,
    staffexp integer,
    prmatexp integer NOT NULL,
    elmatexp integer NOT NULL,
    totexpco integer NOT NULL,
    totopexp integer NOT NULL,
    lcap_rev integer NOT NULL,
    scap_rev integer NOT NULL,
    fcap_rev integer NOT NULL,
    cap_rev integer NOT NULL,
    capital integer NOT NULL,
    bkvol integer NOT NULL,
    ebook integer NOT NULL,
    audio_ph integer NOT NULL,
    audio_dl float NOT NULL,
    video_ph integer NOT NULL,
    video_dl float NOT NULL,
    databases integer NOT NULL,
    subscrip integer NOT NULL,
    hrs_open integer NOT NULL,
    visits integer NOT NULL,
    referenc integer NOT NULL,
    regbor integer NOT NULL,
    totcir integer NOT NULL,
    kidcircl integer NOT NULL,
    elmatcir integer NOT NULL,
    loanto integer NOT NULL,
    loanfm integer NOT NULL,
    totpro integer NOT NULL,
    totatten integer NOT NULL,
    gpterms integer NOT NULL,
    pitusr integer NOT NULL,
    wifisess integer NOT NULL,
    yr_sub integer NOT NULL
);

CREATE INDEX libname2014_idx ON pls_fy2014_pupld14a (libname);
CREATE INDEX stabr2014_idx ON pls_fy2014_pupld14a (stabr);
CREATE INDEX city2014_idx ON pls_fy2014_pupld14a (city);
CREATE INDEX visits2014_idx ON pls_fy2014_pupld14a (visits);


COPY pls_fy2014_pupld14a
FROM 'C:\MyScripts\Databases\pls_fy2014_pupld14a.csv'
WITH (FORMAT CSV, HEADER);


-- Listing 8-2: Creating and filling the 2009 Public Libraries Survey table

CREATE TABLE pls_fy2009_pupld09a (
    stabr varchar(2) NOT NULL,
    fscskey varchar(6) CONSTRAINT fscskey2009_key PRIMARY KEY,
    libid varchar(20) NOT NULL,
    libname varchar(100) NOT NULL,
    address varchar(35) NOT NULL,
    city varchar(20) NOT NULL,
    zip varchar(5) NOT NULL,
    zip4 varchar(4) NOT NULL,
    cnty varchar(20) NOT NULL,
    phone varchar(10) NOT NULL,
    c_relatn varchar(2) NOT NULL,
    c_legbas varchar(2) NOT NULL,
    c_admin varchar(2) NOT NULL,
    geocode varchar(3) NOT NULL,
    lsabound varchar(1) NOT NULL,
    startdat varchar(10),
    enddate varchar(10),
    popu_lsa integer NOT NULL,
    centlib integer NOT NULL,
    branlib integer NOT NULL,
    bkmob integer NOT NULL,
    master numeric(8,2) NOT NULL,
    libraria numeric(8,2) NOT NULL,
    totstaff numeric(8,2) NOT NULL,
    locgvt integer NOT NULL,
    stgvt integer NOT NULL,
    fedgvt integer NOT NULL,
    totincm integer NOT NULL,
    salaries integer,
    benefit integer,
    staffexp integer,
    prmatexp integer NOT NULL,
    elmatexp integer NOT NULL,
    totexpco integer NOT NULL,
    totopexp integer NOT NULL,
    lcap_rev integer NOT NULL,
    scap_rev integer NOT NULL,
    fcap_rev integer NOT NULL,
    cap_rev integer NOT NULL,
    capital integer NOT NULL,
    bkvol integer NOT NULL,
    ebook integer NOT NULL,
    audio integer NOT NULL,
    video integer NOT NULL,
    databases integer NOT NULL,
    subscrip integer NOT NULL,
    hrs_open integer NOT NULL,
    visits integer NOT NULL,
    referenc integer NOT NULL,
    regbor integer NOT NULL,
    totcir integer NOT NULL,
    kidcircl integer NOT NULL,
    loanto integer NOT NULL,
    loanfm integer NOT NULL,
    totpro integer NOT NULL,
    totatten integer NOT NULL,
    gpterms integer NOT NULL,
    pitusr integer NOT NULL,
    yr_sub integer NOT NULL,
    obereg varchar(2) NOT NULL,
    rstatus integer NOT NULL,
    statstru varchar(2) NOT NULL,
    statname varchar(2) NOT NULL,
    stataddr varchar(2) NOT NULL,
    longitud numeric(10,7) NOT NULL,
    latitude numeric(10,7) NOT NULL,
    fipsst varchar(2) NOT NULL,
    fipsco varchar(3) NOT NULL
);
-- We use fsckey as the primary key again


-- now create an index on libname and other columns.

CREATE INDEX libname2009_idx ON pls_fy2009_pupld09a (libname);

CREATE INDEX stabr2009_idx ON pls_fy2009_pupld09a (stabr);

CREATE INDEX city2009_idx ON pls_fy2009_pupld09a (city);

CREATE INDEX visits2009_idx ON pls_fy2009_pupld09a (visits);


-- Copy (import) the csv file's data into the table we created.

COPY pls_fy2009_pupld09a
FROM 'C:\MyScripts\Databases\pls_fy2009_pupld09a.csv'
WITH (FORMAT CSV, HEADER);


-- Listing 8-3: Using count() for table row counts

-- Now, mine the two tables of library data from 2014 and 2009 to discover their stories

-- Count the number of table rows for pls_fy2014_pupld14a, make sure it is 9305 rows.
SELECT count(*)
FROM pls_fy2014_pupld14a;

-- Count the number of table rows for pls_fy2009_pupld09a, make sure it is 9299 rows.
SELECT count(*)
FROM pls_fy2009_pupld09a;


-- Listing 8-4: Using count() for the number of values in a column

SELECT count(salaries)
FROM pls_fy2014_pupld14a;
-- count: 5983

-- Listing 8-5: Using count() for the number of distinct values in a column

-- first count all the values in the libname column: 9305
SELECT count(libname)
FROM pls_fy2014_pupld14a;

-- Count only the distinct values in libname column: 8515
SELECT count(DISTINCT libname)
FROM pls_fy2014_pupld14a;

-- Bonus: find duplicate libnames
SELECT libname, count(libname)
FROM pls_fy2014_pupld14a
GROUP BY libname
ORDER BY count(libname) DESC;

-- Bonus: see location of every Oxford Public Library
SELECT libname, city, stabr
FROM pls_fy2014_pupld14a
WHERE libname = 'OXFORD PUBLIC LIBRARY';

-- MAX() and MIN() functions
-- Listing 8-6: Finding the most and fewest visits using max() and min()

SELECT max(visits), min(visits)
FROM pls_fy2014_pupld14a;
-- output: max = 17729020, min = -3

This minimum value of -3 seems like an error, but the creators of the 
library survery are actually employing a problematic yet common convention
in data collection: using a negative number or some artificially high value
as an indicator.

In this case, the survey creators used negative numbers to indicate the following:
	1.  A value of -1 indicates a "nonresponse" to that question.
	2.  A value of -3 indicates "not applicable" and is used when a library
		agency has closed either temporarily or permanently.

NOTE:  A better alternative for this negative value senario is to use NULL in rows
	in the visits column where response data is absent, and then create a separate
	"visits_flag" column to hold codes explaining why.  This technique separates
	number values from information about them.

************  		Aggregate Data Using GROUP BY		*************

When you use the GROUP BY clause with aggregate functions, you can group results
according to the values in one or more columns.  This allows us to perform operations
like sum() or count() for every state in our table or for every type of library agency.

On its own, GROUP BY eliminates duplicate values from the results, similar to DISTINCT.

-- Listing 8-7: Using GROUP BY on the stabr column

-- There are 56 in 2014.
SELECT stabr
FROM pls_fy2014_pupld14a
GROUP BY stabr
ORDER BY stabr;

-- there are 55 in 2009.
SELECT stabr
FROM pls_fy2009_pupld09a
GROUP BY stabr
ORDER BY stabr;

The GROUP BY clause follows the FROM clause and includes the column name to group.
In this case, we're selecting "stabr", which contains the state abbreviation,
and then we are grouping by that same column.  We then use "ORDER BY stabr" so
	that the grouped results are in aplhabetacal order.

-- Listing 8-8: Using GROUP BY on the city and stabr columns

-- this is an example of grouping by more than one column.
-- 	The results get sorted by city and then by state.
SELECT city, stabr
FROM pls_fy2014_pupld14a
GROUP BY city, stabr
ORDER BY city, stabr;

-- Bonus: We can count some of the combos
SELECT city, stabr, count(*)
FROM pls_fy2014_pupld14a
GROUP BY city, stabr
ORDER BY count(*) DESC;

---------		Combining GROUP BY with COUNT()		---------

If we combine GROUP BY with an aggregate function, such as COUNT(), we can
pull more descriptive information from our data.

-- Listing 8-9: GROUP BY with count() on the stabr column

-- Get a count of agencies by state and sort them to see which states have the most.
SELECT stabr, COUNT(*)
FROM pls_fy2014_pupld14a
GROUP BY stabr
ORDER BY COUNT(*) DESC;

The asterisk causes count() to include NULL values.  Also, when we select individual
columns along with an aggregate function, we must include the columns in a GROUP BY clause.
If we don't, the database will return an error, since you can't group values by
	aggregating and have ungrouped column values in the same query.
To sort the results and have the state with the largest number of agencies at the top,
	we can ORDER BY the COUNT() function in descending order using DESC.


-------		Using GROUP BY on Multiple Columns with COUNT()		----------

Listing 8-10 shows the code for counting the number of agencies in each state that
moved, had a minor address change, or had no change using GROUP BY with "stabr"
and "stataddr" and then adding COUNT():

the "stataddr" column in both tables contains a code indicating whether the agency's
address changed in the last year using the following values:
	Value		Meaning
	00 		No change from last year
	07		Moved to a new location
	15		Minor address change

-- Listing 8-10: GROUP BY with count() on the stabr and stataddr columns

SELECT stabr, stataddr, count(*)
FROM pls_fy2014_pupld14a
GROUP BY stabr, stataddr
ORDER BY stabr ASC, count(*) DESC;

The first few rows of the results show that code 00 (no change in address)
is the most common value for each state.  The result helps assure us that
we're analyzing the data in a sound way.  If code 07 (moved to a new location)
was the most frequent in each state, that would raise a question about whether
we've written the query correctly or had an issue with the data.


-----		Revisiting SUM() to Examine Library Visits		---------


Our goal is to identify trends in library visits spanning that five-year period
by calculating totals using the SUM() aggregate function.
-- Listing 8-11: Using the sum() aggregate function to total visits to
-- libraries in 2014 and 2009

Include grouping and aggregating across joined tables using the 2014 and 2009
	libraries data.

First, address the issue of using the values -3 and -1 to indicate "not applicable" 
and "nonresponse".  

To prevent these negative numbers with no true quantity meaning from affecting 
	the analysis, we filter them out using a WHERE clause to limit the queries
	to rows where values in "visits" are zero or greater.

-- 2014
SELECT sum(visits) AS visits_2014
FROM pls_fy2014_pupld14a
WHERE visits >= 0;
-- visits_2014 = 1425930900

-- 2009
SELECT sum(visits) AS visits_2009
FROM pls_fy2009_pupld09a
WHERE visits >= 0;
-- visits_2009 = 1591799201

These queries sum overall visits; but from the row counts we ran earlier in the 
chapter, we know each table contains a different number of library agencies:
9,305 in 2014 and 9,299 in 2009 due to agencies opening, closing, or merging.
So, let's determine how the sum of visits will differ if we limit the analysis 
to library agencies that exist in both tables.

We can do that by joining the tables, as shown in listing 8-12:

-- Listing 8-12: Using sum() to total visits on joined 2014 and 2009 library tables

SELECT sum(pls14.visits) AS visits_2014,	-- using AS to assing alias
       sum(pls09.visits) AS visits_2009
FROM pls_fy2014_pupld14a pls14 
JOIN pls_fy2009_pupld09a pls09
	ON pls14.fscskey = pls09.fscskey
WHERE pls14.visits >= 0 AND pls09.visits >= 0;

We use a standard JOIN, also known as an INNER JOIN.  That means the 
query results will only include rows where the primary key values of both
tables match.  (the column "fscskey")

NOTE: Although we joined the tables on "fscskey", it's entirely possible that 
	some library agencies that appear in both tables merged or split
	between 2009 and 2014.  A call to the IMLS asking about caveats for
	working with this data is a good idea.


-------		Grouping Visit Sums by State		---------------

-- Listing 8-13: Using GROUP BY to track percent change in library visits by state

SELECT pls14.stabr,
       sum(pls14.visits) AS visits_2014,
       sum(pls09.visits) AS visits_2009,
       round( (CAST(sum(pls14.visits) AS decimal(10,1)) - sum(pls09.visits)) /
                    sum(pls09.visits) * 100, 2 ) AS pct_change
FROM pls_fy2014_pupld14a pls14 JOIN pls_fy2009_pupld09a pls09
ON pls14.fscskey = pls09.fscskey
WHERE pls14.visits >= 0 AND pls09.visits >= 0
GROUP BY pls14.stabr
ORDER BY pct_change DESC;


--------	Filtering an Aggregate Query Using HAVING	---------------

To filter the results of aggregate functions, we need to use the HAVING clause.

Aggregate functions, such as SUM(), can't be used within a WHERE clause because
	they operate at the row level, and aggregate functions work across rows.

The HAVING clause places conditions on groups created by aggregating.


-- Listing 8-14: Using HAVING to filter the results of an aggregate query

-- Include only rows with a sum of 50 million visits or more, in 2014.
SELECT pls14.stabr,
       sum(pls14.visits) AS visits_2014,
       sum(pls09.visits) AS visits_2009,
       round( (CAST(sum(pls14.visits) AS decimal(10,1)) - sum(pls09.visits)) /
                    sum(pls09.visits) * 100, 2 ) AS pct_change
FROM pls_fy2014_pupld14a pls14 JOIN pls_fy2009_pupld09a pls09
ON pls14.fscskey = pls09.fscskey
WHERE pls14.visits >= 0 AND pls09.visits >= 0
GROUP BY pls14.stabr
HAVING sum(pls14.visits) > 50000000
ORDER BY pct_change DESC;
