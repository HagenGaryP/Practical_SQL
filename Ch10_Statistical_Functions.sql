/*

--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros

-- Chapter 10 Code Examples
--------------------------------------------------------------

Typically, the software of choice would be full-featured statistics packages, 
such as SPSS or SAS, the programming languages R or Python, or even Excel.  
However, standard ANSI SQL offers a handful of powerful stats functions that 
reveal a lot about your data without having to export your data set to another program.

SPSS Statistics is a software package used for interactive, or batched, statistical analysis.  
The current versions (2015) are named IBM SPSS Statistics, but the software name originally 
stood for Statistical Package for the Social Sciences.  It is also used by market researchers, 
health researchers, survey companies, government, education researchers, marketing organizations, 
data miners, and others.

SAS (previously “Statistical Analysis System”) is a software suite for advanced analytics, 
multivariate analyses, business intelligence, data management, and predictive analytics.


-----------------       Creating a Census Stats Table       -----------------

Use the code in Listing 10-1 to create the table acs_2011_2015_stats and import 
    the CSV file acs_2011_2015_stats.csv.


-- Listing 10-1: Create Census 2011-2015 ACS 5-Year stats table and import data

CREATE TABLE acs_2011_2015_stats (
    geoid varchar(14) CONSTRAINT geoid_key PRIMARY KEY,
    county varchar(50) NOT NULL,
    st varchar(20) NOT NULL,
    pct_travel_60_min numeric(5,3) NOT NULL,
    pct_bachelors_higher numeric(5,3) NOT NULL,
    pct_masters_higher numeric(5,3) NOT NULL,
    median_hh_income integer,
    CHECK (pct_masters_higher <= pct_bachelors_higher)
);

-- Import the CSV file
COPY acs_2011_2015_stats
FROM 'C:\MyScripts\Databases\acs_2011_2015_stats.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');


-- View the table with newly imported data
SELECT * FROM acs_2011_2015_stats;  	-- 7 columns, 3142 rows.

The acs_2011_2015_stats table has seven columns.  The first three columns include a 
unique geoid that serves as the primary key, the name of the county, and the state name st.  
The next four columns display the following three percentages derived for each county from 
raw data in the ACS release, plus one more economic indicator:

Pct_travel_60_min -     The percentage of workers age 16 and older who commute more 
                            than 60 minutes to work.
Pct_bachelors_higher -  The percentage of people ages 25 and older whose level of 
                            education is a bachelor’s degree or higher.
Pct_masters_higher -    The percentage of people ages 25 and older whose education is 
                            a master’s degree or higher.
Median_hh_income -      County’s median household income in 2015 inflation-adjusted dollars.


------------        Measuring Correlation with corr(Y,X)        ---------------

Researchers often want to understand the relationships between variables, and one such measure 
of relationships is correlation.  

In this section, we’ll use the corr(Y, X) function to measure correlation and investigate what
 relationhships exist, if any, between the percentage of people in a county who’ve attained 
 a bachelor’s degree and the median household income in that county.

some background  

The Pearson correlation coefficient (generally denoted as r) is a measure for quantifying the 
strength of a linear relationship between two variables.  It shows the extent to which an 
increase or decrease in one variable correlates to a change in another variable.

The r values fall between -1 and 1.  Either end of the range indicates a perfect correlation, 
whereas values near zero indicate a random distribution with no correlation.

A positive r value indicates a direct relationship: as one variable increases, the other does too.  
When graphed on a scatterplot, the data points representing each pair of values in a 
direct relationship would slope upward from left to right.

A negative r value indicates an inverse relationship: as one variable increases, the other decreases.  
Dots representing an inverse relationship would slope downward from left to right on a scatterplot.

Table 10-1 provides general guidelines for interpreting positive and negative r values, 
although as always with statistics, different statisticians may offer different interpretations.

Table 10-1: Interpreting Correlation Coefficients
____________________________________________________________
Correlation coefficient (+/-)           Relationship
------------------------------------------------------------
        0                               No relationship
    0.01 to 0.29                        Weak Relationship
    0.3 to 0.59                         Moderate relationship
    0.6 to 0.99                         Strong to nearly perfect
        1                               Perfect relationship
______________________________________________________________

In standard ANSI SQL and PostgreSQL, we calculate the Pearson correlation coefficient 
using corr(Y, X).  It’s one of several binary aggregate functions in SQL and is so named 
because these functions accept two inputs.  In binary aggregate functions, the input Y is 
the dependent variable whose variation depends on the value of another variable, and X is 
the independent variable whose value doesn’t depend on another variable. 


-- Listing 10-2: Using corr(Y, X) to measure the relationship between 
-- education and income

SELECT corr(median_hh_income, pct_bachelors_higher)
    AS bachelors_income_r
FROM acs_2011_2015_stats;
-- Result shows "bachelors_income_r" 0.682185675451399

This positive r value indicates that as a county’s educational attainment increases, 
    household income tends to increase.

-- Listing 10-3: Using corr(Y, X) on additional variables

SELECT
    round(
      corr(median_hh_income, pct_bachelors_higher)::numeric, 2
      ) AS bachelors_income_r,
    round(
      corr(pct_travel_60_min, median_hh_income)::numeric, 2
      ) AS income_travel_r,
    round(
      corr(pct_travel_60_min, pct_bachelors_higher)::numeric, 2
      ) AS bachelors_travel_r
FROM acs_2011_2015_stats;

Wrapping the corr(Y, X) function inside SQL’s round() function, which takes two inputs: the numeric value to be rounded and an integer value indicating the number of decimal places to round the first value.  If the second parameter is omitted, the value is rounded to the nearest whole integer.

Because corr(Y, X) returns a floating-point value by default, we’ll change it to the numeric type using the :: notation (from chapter 3).

When testing for correlation, we need to note some caveats (a warning or proviso of specific stipulations, conditions, or limitations).  The first is that even a strong correlation does not imply causality.  We can’t say that a change in one variable causes a change in the other, only that the changes move together.
The second is that correlations should be subject to testing to determine whether they’re statistically significant.


--------------      Predicting Values with Regression Analysis      ------------


Researchers not only want to understand relationships between variables; they also want to predict values using available data.  For example, let’s say 30% of a county’s population has a bachelor’s degree or higher.  Given the trend in our data, what would we expect that county’s median household income to be?  Likewise, for each percent increase in education, how much increase, on average, would we expect in income?

We can answer both questions using linear regression.  

Simply put, the regression method finds the best linear equation, or straight line, that describes the relationship between an independent variable (such as education) and a dependent variable (such as income).

Standard ANSI SQL and PostgreSQL include functions that perform linear regression.

The straight line running through the middle of all the data points is called the least squares regression, which approximates the “best fit” for a straight line that best describes the relationship between variables.

The equation for the regression line is like the slope-intercept formula (Y = mX + b), but written using differently named variables:  Y = bX + a

Y is the predicted value, which is also the value on the y-axis, or dependent variable.

b is the slope of the line, which can be positive or negative.  It measures how many units the y-axis value will increase or decrease for each unit of the x-axis value.

X represents a value on the x-axis, or independent variable.

a is the y-intercept, the value at which the line crosses the y-axis when the X value is zero.


Earlier we questioned what the expected median household income in a county would be if the percentage of people with a bachelor’s degree or higher in the county was 30 percent.  In our scatterplot, the percentage with bachelor’s degrees fals along the x-axis, represented by X in the calculation.  Giving us the regression line formula of Y = b(30) + a.

To calculate Y, which representsa the predicted median household income, we need the line’s slope, b, and the y-intercept, a.  To get these values, we’ll use the SQL functions regr_slope(Y, X) and regr_intercept(Y, X).



-- Using the "regr_slope()" and "regr_intercept()" functions

-- Listing 10-4: Regression slope and intercept functions

SELECT
    round(
        regr_slope(median_hh_income, pct_bachelors_higher)::numeric, 2
        ) AS slope,
    round(
        regr_intercept(median_hh_income, pct_bachelors_higher)::numeric, 2
        ) AS y_intercept
FROM acs_2011_2015_stats;


Using the median_hh_income and pct_bachelors_higher variables as inputs for both functions, we’ll set the resulting value of the regr_slope(Y, X) function as slope and the output for regr_intercept(Y,X) function as y_intercept.

Slope = 926.95      y_intercept = 27,901.15
Plug both values into the equation to get the Y value:

    Y = 926.95 * (30) + 27,901.15

    Y = 55,709.65

Based on our calculation, in a county in which 30 percent of people age 25 and older have a bachelor’s degree or higher, we can expect a median household income in that county to be about $55,710.  


----------- Finding the Effect of an Independent Variable with r-squared        ------------


We already calculated the correlation coefficient, r, to determine the direction and strength of the relationship between two variables.

We can also calculate the extent that the variation in the x (independent) variable explains the variation in the y (dependent) variable by squaring the r value to find the coefficient of determination, better known as r-squared. 

An r-squared value is between zero and one and indicates the percentage of the variation that is explained by the independent variable.

For example, if r-squared equals 0.1, we would say that the independent variable explains 10 percent of the variation in the dependent variable, or not much at all.

To find r-squared, we use the regr_r2(X, Y) function in SQL.

Using the code in Listing 10-5, we will apply the regr_r2(X, Y) function to our Education and Income variables.



-- Listing 10-5: Calculating the coefficient of determination, or r-squared

-- Using "regr_r2()" function to find r-squared.
SELECT round(
        regr_r2(median_hh_income, pct_bachelors_higher)::numeric, 3
        ) AS r_squared
FROM acs_2011_2015_stats;  
-- Result:  r_squared = 0.465
-- 		this value indicates that about 47 percent of the variation in 
--		median househould income in a county can be explained by the 
--		percentage of people with a bachelor's degree or higher in that county.


-- Bonus: Additional stats functions.

-- Variance
SELECT var_pop(median_hh_income)
FROM acs_2011_2015_stats;
-- Result: var_pop = 150044362.59637066


-- Standard deviation of the entire population
SELECT stddev_pop(median_hh_income)
FROM acs_2011_2015_stats;
-- Result: stddev_pop = 12249.25967544


-- Covariance
SELECT covar_pop(median_hh_income, pct_bachelors_higher)
FROM acs_2011_2015_stats;
-- Result: covar_pop = 75330.0791116251



--------------      Creating Rankings with SQL      -------------------


Rankings are useful for data analysis in several ways, such as tracking changes over time if you have many years’ worth of data.  You can also simply use a ranking as a fact on its own in a report.


--- Ranking with rank() and dense_rank()B

Both are window functions, which perform calculations across sets of rows we specify using the OVER clause.  Unlike aggregate functions, which group rows while calculating results, window functions present results for each row in the table.

The difference between rank() and dense_rank() is the way they handle the next rank value after a tie:
rank() includes a gap in the rank order, but dense_rank() does not.

Example:  Consider a Wall Street analyst who covers the highly competitive widget manufacturing market.  The analyst wants to rank companies by their annual output.  
The SQL statements in Listing 10-6 create and fill a table with this data and then rank the companies by widget output:



-- Listing 10-6: The rank() and dense_rank() window functions

-- Create the table
CREATE TABLE widget_companies (
    id bigserial,
    company varchar(30) NOT NULL,
    widget_output integer NOT NULL
);


-- insert values
INSERT INTO widget_companies (company, widget_output)
VALUES
    ('Morse Widgets', 125000),
    ('Springfield Widget Masters', 143000),
    ('Best Widgets', 196000),
    ('Acme Inc.', 133000),
    ('District Widget Inc.', 201000),
    ('Clarke Amalgamated', 620000),
    ('Stavesacre Industries', 244000),
    ('Bowers Widget Emporium', 201000);

-- use the rank() and dense_rank() functions
SELECT
    company,
    widget_output,
    rank() OVER (ORDER BY widget_output DESC),
    dense_rank() OVER (ORDER BY widget_output DESC)
FROM widget_companies;


Notice the syntax in thee SELECT statement that includes rank() and dense_rank().  After the function names, we use the OVER clause and in parentheses place an expression that specifies the “window” of rows the function should operate on.  In this case, we want both functions to work on all rows of the widget_output column, sorted in descending order.


------  Ranking within subgroups with PARTITION BY

To produce ranks within groups of rows in a table.  

For example, you might want to rank government employees by salary within each department or rank movies by box office earnings within each genre.


To use window functions in this way, we’ll add PARTITION BY to the OVER clause.

A PARTITION BY clause divides table rows according to values in a column we specify.

Here’s an example using made-up data about grocery stores.  
Enter the code in Listing 10-7 to fill a table called store_sales:

-- Listing 10-7: Applying rank() within groups using PARTITION BY

CREATE TABLE store_sales (
    store varchar(30),
    category varchar(30) NOT NULL,
    unit_sales bigint NOT NULL,
    CONSTRAINT store_category_key PRIMARY KEY (store, category)
);

INSERT INTO store_sales (store, category, unit_sales)
VALUES
    ('Broders', 'Cereal', 1104),
    ('Wallace', 'Ice Cream', 1863),
    ('Broders', 'Ice Cream', 2517),
    ('Cramers', 'Ice Cream', 2112),
    ('Broders', 'Beer', 641),
    ('Cramers', 'Cereal', 1003),
    ('Cramers', 'Beer', 640),
    ('Wallace', 'Cereal', 980),
    ('Wallace', 'Beer', 988);

-- Select the category, store, and unit_sales columns, then create a
-- 	column that ranks them.
SELECT
    category,
    store,
    unit_sales,
    rank() OVER (PARTITION BY category ORDER BY unit_sales DESC)
FROM store_sales;

In the table, each row includes a store’s product category and sales for that category.   The final SELECT statement creates a result set showing how each store’s sales ranks within each category.  The new element is the addition of PARTITION BY in the OVER clause.  
In effect, the clause tells the program to create rankings one category at a time, using the store’s unit sales in descending order.

The category names are ordered and grouped in the category column as a result of PARTITION BY in the OVER clause.  Rows for each category are ordered by category unit sales with the rank column displaying the ranking.


---------       Calculating Rates for Meaningful Comparisons        ------------


Rankings based on raw counts aren’t always meaningful; in fact, they can actually be misleading.

Example:  NYC reported about 130,000 property crimes.  Chicago reported about 80,000 property crimes the same year.  This would imply to most people that you’re more likely to find trouble in NYC.  However, this isn’t necessarily true.  
In that year (2015), NYC had over 8 million residents, whereas Chicago had 2.7 million.  Given that context, just comparing the total numbers of property crimes in the two cities isn’t very meaningful.

A more accurate way to compare these numbers is to turn them into rates.  Analysts often calculate a rate per 1,000 people, or some multiple of that number, for “apples-to-apples” comparisons.

For the property crimes in this example, the math is simple: divide thee number of offenses by the population and then multiply that quotient by 1,000.  i.e., if a city has 80 vehicle thefts and a population of 15,000, you can calculate the rate of vehicle thefts per 1,000 people as follows:
    (80 / 15,000) * 1,000 = 5.3 vehicle thefts per thousand residents


-- Listing 10-8: Create and fill a 2015 FBI crime data table

CREATE TABLE fbi_crime_data_2015 (
    st varchar(20),
    city varchar(50),
    population integer,
    violent_crime integer,
    property_crime integer,
    burglary integer,
    larceny_theft integer,
    motor_vehicle_theft integer,
    CONSTRAINT st_city_key PRIMARY KEY (st, city)
);

-- Import the CSV file data

COPY fbi_crime_data_2015
FROM 'C:\MyScripts\Databases\fbi_crime_data_2015.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');
-- Query returned successfully: 9365 rows affected

-- View table.
SELECT * FROM fbi_crime_data_2015
ORDER BY population DESC;


To calculate property crimes per 1,000 people in cities with more than 500,000 people and order them
we'll use the code in Listing 10-9:

-- Listing 10-9: Find property crime rates per thousand in cities with 500,000
-- or more people

SELECT
    city,
    st,
    population,
    property_crime,
    round(
        (property_crime::numeric / population) * 1000, 1
        ) AS pc_per_1000
FROM fbi_crime_data_2015
WHERE population >= 500000
ORDER BY (property_crime::numeric / population) DESC;

In chapter 5, we learned that when dividing an integer by an integer, one of the values must be a numeric or decimal for the result to include decimal places.  We do that in the rate calculation with PostgreSQL’s double-colon shorthand (::).  
Since we don’t need to see many decimal places, we wrap the statement in the round() function to round off the output to the nearest tenth.  Then we give the calculated column an alias of pc_per-_1000 for easy reference.
