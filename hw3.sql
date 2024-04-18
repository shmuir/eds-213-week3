-- SQL Problem 1 Part 1

--  Does SQL abort with some kind of error? 
-- Does it ignore NULL values? Do the NULL values somehow factor into the calculation, and if so, how?
    -- Construct an SQL experiment to determine the answer to the question above. 
    -- Does SQL abort with some kind of error? Does it ignore NULL values?
    -- Do the NULL values somehow factor into the calculation, and if so, how?

CREATE TEMP TABLE table_part1 (
    col1 real
);
INSERT INTO table_part1 (col1)
VALUES (2),
        (NULL),
        (6),
        (8);

SELECT * FROM table_part1;

SELECT AVG(col1) AS avg FROM table_part1;
-- the AVG() did not consider the NULL value
-- there was no errpr and it calculated (2+6+8)/3, so the NULL is not factored into the calculation since if it did, we would expect the return to be NULL

-- Part 2

SELECT SUM(col1)/COUNT(*) FROM table_part1;
SELECT SUM(col1)/COUNT(col1) FROM table_part1;

-- The second one is correct
-- In the first query, it is counting all of the rows, including the row with the NULL value, so the count is 4
-- In the second one it's counting how many values are in the column, and because there is a NULL, that count is 3
DROP TABLE table_part1;


-- SQL Problem 2 
-- Part 1

-- If we want to know which site has the largest area, it’s tempting to say

SELECT Site_name, MAX(Area) FROM Site;
-- Wouldn’t that be great? But DuckDB gives an error. And right it should! This query is conceptually flawed. Please describe what is wrong with this query. Don’t just quote DuckDB’s error message— explain why DuckDB is objecting to performing this query.

-- To help you answer this question, you may want to consider:

-- To the database, the above query is no different from

SELECT Site_name, AVG(Area) FROM Site;
SELECT Site_name, COUNT(*) FROM Site;
SELECT Site_name, SUM(Area) FROM Site;
--In all these examples, the database sees that it is being asked to apply an aggregate function to a table column.

-- When performing an aggregation, SQL wants to collapse the requested columns down to a single row. (For a table-level aggregation such as requested above, it wants to collapse the entire table down to a single row. For a GROUP BY, it wants to collapse each group down to a single row.)

-- This does not work since the query is selecting one column, but trying to find the MAX of a different column, so Site_name must be in a GROUP BY
-- We need to define groups for aggregating


-- Part 2

-- Time for plan B. Find the site name and area of the site having the largest area. 
-- Do so by ordering the rows in a particularly convenient order, and using LIMIT to select just the first row. 

SELECT Site_name, MAX(Area) as area_max
    FROM Site
    GROUP BY Site_name
    ORDER BY -area_max
    LIMIT 1;

-- Part 3
SELECT Site_name, Area FROM Site 
    WHERE Area = (
        SELECT MAX(Area) FROM Site
);


