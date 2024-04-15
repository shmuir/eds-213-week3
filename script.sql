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


