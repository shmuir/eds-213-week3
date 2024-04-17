-- Monday 15 April 2024

-- get out of duckDB
    -- .exit
    -- control D
-- navigate in to folder where database is
duckdb database.db
.tables

-- control C to get back to "D" prompt in duckdb; abandons command you're typing

-- https://sqlite.org/docs.html

SELECT * FROM Species; -- can also say select * from Species;

-- limiting rows
SELECT * FROM Species LIMIT 5;
SELECT * FROM Species OFFSET 5;

-- How many rows?
SELECT COUNT(*) FROM Species;
-- How many non-NULL values in a column?
SELECT COUNT(Scientific_name) FROM Species;
-- How many distinct values occur?
SELECT DISTINCT Species FROM Bird_nests;
SELECT Code, Common_name FROM Species;
SELECT DISTINCT Species FROM Bird_nests;
-- Get unique combinations
SELECT DISTINCT Species, Observer FROM Bird_nests;
-- ordering of results
SELECT DISTINCT Species FROM Bird_nests ORDER BY Species;

-- Exercise
-- what distinct location occur in the Site table?
-- Order them and limit to 3 results
SELECT DISTINCT Location FROM Site ORDER BY Location LIMIT 3;

SELECT Location FROM Site;
SELECT * FROM Site WHERE Area < 200;
SELECT * FROM Site WHERE Area < 200 AND Location LIKE '%USA';
SELECT * FROM Site WHERE Area < 200 AND Location ILIKE '%usa'; -- ILIKE makes it not case sensitive

-- Expressions
SELECT Site_name, Area FROM Site;
SELECT Site_name, Area*2.47 FROM Site;
SELECT Site_name, Area*2.47 AS Area_acres FROM Site; -- rename col as Area_acres
SELECT Site_name || 'foo' FROM Site;

-- Aggregation functions
SELECT COUNT(*) FROM Site; -- how many rows are there?
SELECT COUNT(*) AS num_rows FROM Site; -- rename as num_rows
SELECT COUNT(Scientific_name) FROM Species;
SELECT DISTINCT Relevance FROM Species;
SELECT COUNT(DISTINCT Relevance) FROM Species;

-- MIN, MAX, AVG
SELECT AVG(Area) AS avg_area FROM Site;

-- grouping
SELECT * FROM Site;
SELECT Location, MAX(Area) FROM Site GROUP BY Location;
SELECT Location, COUNT(*) FROM Site GROUP BY Location;
SELECT Relevance, COUNT(Scientific_name) FROM Species GROUP BY Relevance;  -- how many non-null scientific names in each group

-- adding WHERE clause
SELECT Location, MAX(Area) 
    FROM Site 
    GROUP BY Location;

SELECT Location, MAX(Area) 
    FROM Site
    WHERE Location 
    LIKE '%Canada' 
    GROUP BY Location;

SELECT Location, MAX(Area) AS Max_area
    FROM Site
    WHERE Location LIKE '%Canada'
    GROUP BY Location
    HAVING Max_area > 200; -- use new name to filter to just have max_area greater than 200

-- Relational algebra 
SELECT COUNT(*) FROM Site; -- this is a baby table
SELECT COUNT(*) FROM (SELECT COUNT(*) FROM Site); -- tells us there's 1 row in the baby table
SELECT * FROM Bird_nests LIMIT 3;
SELECT COUNT(*) FROM Species;
SELECT * FROM Species 
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests); -- 80 rows where species does not have nests

-- Saving queries
CREATE TEMP TABLE t AS  -- table will vanish when we exit duckdb
    SELECT * FROM Species 
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);
SELECT * FROM t;

CREATE TABLE t_perm AS -- now this is a permanent table in duckdb; only in the database
    SELECT * FROM Species 
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests); 
SELECT * FROM t_perm;
DROP TABLE t_perm; -- remove the table from duckdb

-- NULL processing
SELECT COUNT(*) FROM Bird_nests 
     WHERE floatAge > 5;   -- 70
SELECT COUNT(*) FROM Bird_nests 
     WHERE floatAge <= 5; -- 97
SELECT COUNT(*) FROM Bird_nests; -- 1547
-- we're missing a lot of rows; there are many NULL values
SELECT COUNT(*) FROM Bird_nests WHERE floatAge IS NULL; -- 1380 NULL values

-- Joins
SELECT * FROM Camp_assignment;
SELECT * FROM Personnel;
SELECT * FROM Camp_assignment 
    JOIN Personnel -- join to Personnel table
    ON Observer = Abbreviation; -- how to join them 

SELECT * FROM Camp_assignment JOIN Personnel
    ON Camp_assignment.Observer = Personnel.Abbreviation; -- can be more explicit about where the columns are coming from
SELECT * FROM Camp_assignment AS ca JOIN Personnel p -- even more abbreviated for the table names
    ON ca.Observer = p.Abbreviation
    JOIN Site s
    ON ca.Site = s.Code
    WHERE ca.Observer = 'lmckinnon'
    LIMIT 3;

-- order by; usually the last step
SELECT * FROM Camp_assignment AS ca JOIN (
        SELECT * FROM Personnel ORDER BY Abbreviation) p
    ON ca.Observer = p.Abbreviation
    JOIN Site s
    ON ca.Site = s.Code
    WHERE ca.Observer = 'lmckinnon'
    LIMIT 3;

-- How many bird eggs are in each nest
SELECT COUNT(*), Nest_ID FROM Bird_eggs GROUP BY (Nest_ID);
