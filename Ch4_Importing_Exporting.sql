/*

-- Listing 4-2: A CREATE TABLE statement for Census county data
-- Full data dictionary available at: http://www.census.gov/prod/cen2010/doc/pl94-171.pdf
-- Note: Some columns have been given more descriptive names

CREATE TABLE us_counties_2010 (
    geo_name varchar(90),                    -- Name of the geography
    state_us_abbreviation varchar(2),        -- State/U.S. abbreviation
    summary_level varchar(3),                -- Summary Level
    region smallint,                         -- Region
    division smallint,                       -- Division
    state_fips varchar(2),                   -- State FIPS code
    county_fips varchar(3),                  -- County code
    area_land bigint,                        -- Area (Land) in square meters
    area_water bigint,                        -- Area (Water) in square meters
    population_count_100_percent integer,    -- Population count (100%)
    housing_unit_count_100_percent integer,  -- Housing Unit count (100%)
    internal_point_lat numeric(10,7),        -- Internal point (latitude)
    internal_point_lon numeric(10,7),        -- Internal point (longitude)

    -- This section is referred to as P1. Race:
    p0010001 integer,   -- Total population
    p0010002 integer,   -- Population of one race:
    p0010003 integer,       -- White Alone
    p0010004 integer,       -- Black or African American alone
    p0010005 integer,       -- American Indian and Alaska Native alone
    p0010006 integer,       -- Asian alone
    p0010007 integer,       -- Native Hawaiian and Other Pacific Islander alone
    p0010008 integer,       -- Some Other Race alone
    p0010009 integer,   -- Population of two or more races
    p0010010 integer,   -- Population of two races:
    p0010011 integer,       -- White; Black or African American
    p0010012 integer,       -- White; American Indian and Alaska Native
    p0010013 integer,       -- White; Asian
    p0010014 integer,       -- White; Native Hawaiian and Other Pacific Islander
    p0010015 integer,       -- White; Some Other Race
    p0010016 integer,       -- Black or African American; American Indian and Alaska Native
    p0010017 integer,       -- Black or African American; Asian
    p0010018 integer,       -- Black or African American; Native Hawaiian and Other Pacific Islander
    p0010019 integer,       -- Black or African American; Some Other Race
    p0010020 integer,       -- American Indian and Alaska Native; Asian
    p0010021 integer,       -- American Indian and Alaska Native; Native Hawaiian and Other Pacific Islander
    p0010022 integer,       -- American Indian and Alaska Native; Some Other Race
    p0010023 integer,       -- Asian; Native Hawaiian and Other Pacific Islander
    p0010024 integer,       -- Asian; Some Other Race
    p0010025 integer,       -- Native Hawaiian and Other Pacific Islander; Some Other Race
    p0010026 integer,   -- Population of three races
    p0010047 integer,   -- Population of four races
    p0010063 integer,   -- Population of five races
    p0010070 integer,   -- Population of six races

    -- This section is referred to as P2. HISPANIC OR LATINO, AND NOT HISPANIC OR LATINO BY RACE
    p0020001 integer,   -- Total
    p0020002 integer,   -- Hispanic or Latino
    p0020003 integer,   -- Not Hispanic or Latino:
    p0020004 integer,   -- Population of one race:
    p0020005 integer,       -- White Alone
    p0020006 integer,       -- Black or African American alone
    p0020007 integer,       -- American Indian and Alaska Native alone
    p0020008 integer,       -- Asian alone
    p0020009 integer,       -- Native Hawaiian and Other Pacific Islander alone
    p0020010 integer,       -- Some Other Race alone
    p0020011 integer,   -- Two or More Races
    p0020012 integer,   -- Population of two races
    p0020028 integer,   -- Population of three races
    p0020049 integer,   -- Population of four races
    p0020065 integer,   -- Population of five races
    p0020072 integer,   -- Population of six races

    -- This section is referred to as P3. RACE FOR THE POPULATION 18 YEARS AND OVER
    p0030001 integer,   -- Total
    p0030002 integer,   -- Population of one race:
    p0030003 integer,       -- White alone
    p0030004 integer,       -- Black or African American alone
    p0030005 integer,       -- American Indian and Alaska Native alone
    p0030006 integer,       -- Asian alone
    p0030007 integer,       -- Native Hawaiian and Other Pacific Islander alone
    p0030008 integer,       -- Some Other Race alone
    p0030009 integer,   -- Two or More Races
    p0030010 integer,   -- Population of two races
    p0030026 integer,   -- Population of three races
    p0030047 integer,   -- Population of four races
    p0030063 integer,   -- Population of five races
    p0030070 integer,   -- Population of six races

    -- This section is referred to as P4. HISPANIC OR LATINO, AND NOT HISPANIC OR LATINO BY RACE
    -- FOR THE POPULATION 18 YEARS AND OVER
    p0040001 integer,   -- Total
    p0040002 integer,   -- Hispanic or Latino
    p0040003 integer,   -- Not Hispanic or Latino:
    p0040004 integer,   -- Population of one race:
    p0040005 integer,   -- White alone
    p0040006 integer,   -- Black or African American alone
    p0040007 integer,   -- American Indian and Alaska Native alone
    p0040008 integer,   -- Asian alone
    p0040009 integer,   -- Native Hawaiian and Other Pacific Islander alone
    p0040010 integer,   -- Some Other Race alone
    p0040011 integer,   -- Two or More Races
    p0040012 integer,   -- Population of two races
    p0040028 integer,   -- Population of three races
    p0040049 integer,   -- Population of four races
    p0040065 integer,   -- Population of five races
    p0040072 integer,   -- Population of six races

    -- This section is referred to as H1. OCCUPANCY STATUS
    h0010001 integer,   -- Total housing units
    h0010002 integer,   -- Occupied
    h0010003 integer    -- Vacant
);
Query returned successfully with no result in 24 msec.

SELECT * FROM us_counties_2010;
-- returned each column heading (91 columns)

--Copy the CSV file to the created table.

COPY us_counties_2010
FROM 'C:\MyScripts\Databases\us_counties_2010.csv'
WITH (FORMAT CSV, HEADER);
--Query returned successfully: 3143 rows affected, 78 msec execution time.


--Visually scan the data you just imported
SELECT * FROM us_counties_2010;


-- Run query top show counties with the largest area_land values. (use LIMIT clause)
SELECT geo_name, state_us_abbreviation, area_land
FROM us_counties_2010
ORDER BY area_land DESC
LIMIT 3;
-- Data Output
	geo_name		state_us_abbreviation		area_land
"Yukon-Koyukuk Census Area";	"AK";				376855656455
"North Slope Borough";		"AK";				229720054439
"Bethel Census Area";		"AK";				105075822708


-- Check the latitude and longitude columns of internal_point_lat
-- and internal_point_lon, which we defined with numeric(10,7)

SELECT geo_name, state_us_abbreviation, internal_point_lon
FROM us_counties_2010
ORDER BY internal_point_lon DESC
LIMIT 5;
-- Data Output
	geo_name		state_us_abbreviation		internal_point_lon
"Aleutians West Census Area";	"AK";				178.3388130
"Washington County";		"ME";				-67.6093542
"Hancock County";		"ME";				-68.3707034
"Aroostook County";		"ME";				-68.6494098
"Penobscot County";		"ME";				-68.6574869
*/

/*
********* importing a subset of columns with COPY	************

If a CSV file doesn't have data for all the columns in your target database table,
you can still import the data you have by specifying which columns are present.

Consider this scenario: you're researching the salaries of all town supervisors in
your state so you can analyze government spending trends by geography.


-- To get started, create a table called 'supervisor_salaries' 
-- Listing 4-4: Creating a table to track supervisor salaries

CREATE TABLE supervisor_salaries (
    town varchar(30),
    county varchar(30),
    supervisor varchar(30),
    start_date date,
    salary money,
    benefits money
);
Query returned successfully with no result in 16 msec.

-- copy the csv to the created table.
COPY supervisor_salaries
FROM 'C:\MyScripts\Databases\supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER);
-- Data Output
ERROR:  missing data for column "start_date"
CONTEXT:  COPY supervisor_salaries, line 2: "Anytown,Jones,27000"
********** Error **********
ERROR: missing data for column "start_date"
SQL state: 22P04
Context: COPY supervisor_salaries, line 2: "Anytown,Jones,27000"



--The workaround for this situation is to tell the database which columns
--in the table are present in the CSV, as shown.
-- Listing 4-5: Importing salaries data from CSV to three table columns

COPY supervisor_salaries (town, supervisor, salary)
FROM 'C:\MyScripts\Databases\supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER);
--Query returned successfully: 5 rows affected, 13 msec execution time.


SELECT * FROM supervisor_salaries LIMIT 2;


***** Adding a Default value to a column during import ***********

-- Listing 4-6 Use a temporary table to add a default value to a column during
-- import

What if you want to populate the county column during the import, even though
the value is missing from the CSF file?

You can do so by using a temporary table.
Temporary tables exist only until you end your database session.
They're handy for performing intermediary operations on data as part of
your processing pipeline; we'll use one to add a county name to the
supervisor_salaries table as we import the CSV.



-- Start by clearing the data you already imported into supervisor_salaries,
-- 	using a DELETE query: DELETE FROM supervisor_salaries;
DELETE FROM supervisor_salaries;
Query returned successfully: 5 rows affected, 14 msec execution time.


-- create a temporary table, import csv, insert, and drop table to erase temp table.

CREATE TEMPORARY TABLE supervisor_salaries_temp (LIKE supervisor_salaries);

COPY supervisor_salaries_temp (town, supervisor, salary)
FROM 'C:\MyScripts\Databases\supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER);

INSERT INTO supervisor_salaries (town, county, supervisor, salary)
SELECT town, 'Some County', supervisor, salary
FROM supervisor_salaries_temp;

DROP TABLE supervisor_salaries_temp;
--Query returned successfully with no result in 13 msec.


-- Check the data
SELECT * FROM supervisor_salaries LIMIT 2;

******* 	using COPY to export data	***********

The main difference between exporting and importing data with COPY is that
rather than using FROM to identify your source data, you use TO for the path
and name of the output file.  You control how much data to export - 
	an entire table, just a few columns, or to fine-tune it even more


-- Listing 4-7: Export an entire table with COPY

COPY us_counties_2010
TO 'C:\MyScripts\Databases\supervisor_salaries.txt'	-- saved as .txt file
WITH (FORMAT CSV, HEADER, DELIMITER '|');
--Query returned successfully: 3143 rows affected, 44 msec execution time.

***********  	Exporting Particular Columns		**********


-- Listing 4-8: Exporting selected columns from a table with COPY

COPY us_counties_2010 (geo_name, internal_point_lat, internal_point_lon)
TO 'C:\myscripts\databases\text_files\us_counties_latlon_export.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');


*/
-- Listing 4-9: Exporting query results with COPY

COPY (
    SELECT geo_name, state_us_abbreviation
    FROM us_counties_2010
    WHERE geo_name ILIKE '%mill%'
     )
TO 'C:\myscripts\databases\text_files\us_counties_mill_export.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');
--Query returned successfully: 9 rows affected, 12 msec execution time.
