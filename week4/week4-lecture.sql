.nullvalue -NULL-

SELECT Species, COUNT(*) AS Nest_count
    FROM Bird_nests
    WHERE Site = 'nome'
    GROUP BY Species
    ORDER BY Species
    LIMIT 2;

-- can nest queries to join and get scientific name
SELECT Scientific_name, Nest_count FROM
    (SELECT Species, COUNT(*) AS Nest_count
    FROM Bird_nests
    WHERE Site = 'nome'
    GROUP BY Species
    ORDER BY Species
    LIMIT 2) JOIN Species ON Species = Code;

--- outer joins ---
CREATE TEMP TABLE a (cola INTEGER, common INTEGER);
INSERT INTO a VALUES (1,1), (2,2), (3,3);
SELECT * FROM a;
CREATE TEMP TABLE b (common INTEGER, colb INTEGER);
INSERT INTO b VALUES (2,2), (3,3), (4,4), (5,5);
SELECT * FROM b;
-- left outer join
SELECT * FROM a LEFT JOIN b using (common);
-- right outer join
SELECT * FROM a RIGHT JOIN b USING (common);

--- inner join ---
SELECT * FROM a INNER JOIN b USING (common);

--- what species do not have nest data ---
SELECT * FROM Species 
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);
    -- do the same using an outer join
SELECT Code
    FROM Species LEFT JOIN Bird_nests ON Code = Species;

SELECT COUNT (*) FROM Bird_nests WHERE Species = 'ruff';
SELECT Code, Scientific_name, Nest_ID, Species, Year
    FROM Species LEFT JOIN Bird_nests ON Code = Species
    WHERE Nest_ID IS NULL;

-- grouping
SELECT * FROM Bird_eggs LIMIT 3;
SELECT Nest_ID, COUNT(*)
    FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    WHERE Nest_ID = '14eabaage01'
    GROUP BY Nest_ID;
-- what if we want to preserve another column?
SELECT Nest_ID, ANY_VALUE(Species), COUNT(*)
    FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    WHERE Nest_ID = '14eabaage01'
    GROUP BY Nest_ID;

-- views
-- looks like a table, but is not stored at all - it runs the query when executed everytime
SELECT * FROM Camp_assignment;
SELECT Year, Site, Name, Start, "End"
 ON Observer = Abbreviation;

CREATE VIEW v AS
    SELECT Year, Site, Name, Start, "End"
    FROM Camp_assignment JOIN Personnel
    ON Observer = Abbreviation;
SELECT * FROM v;

CREATE VIEW v2 AS SELECT COUNT(*) FROM Species;
SELECT * FROM v2;

-- union, intersect, except
    -- not runnable example
SELECT Book_page, Nest_ID, Egg_num, Length, Width FROM Bird_eggs;
SELECT Book_page, Nest_ID, Egg_num, Length*25.4, Width*25.4 FROM Bird_eggs
    WHERE Book_page 'b14.6'
    UNION
SELECT Book_page, Nest_ID, Egg_num, Length, Width FROM Bird_eggs
    WHERE Book_page != 'b14.6'; 

-- third way to answer the question
SELECT Code FROM Species
    EXCEPT SELECT DISTINCT Species FROM Bird_nests;