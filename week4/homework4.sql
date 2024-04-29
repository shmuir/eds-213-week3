--

--- Missing Data ---
-- NOT IN
SELECT Code FROM Site 
    WHERE Code NOT IN (SELECT DISTINCT Site FROM Bird_eggs);
-- JOIN
SELECT Code FROM Site 
    LEFT JOIN Bird_eggs ON Site = Code
    WHERE Egg_num IS NULL
    ORDER BY Code;
-- EXCEPT
SELECT Code FROM Site
    EXCEPT SELECT DISTINCT Site FROM Bird_eggs
    ORDER BY Code;

--- Who worked with whom ---
SELECT A.Site, p1.Name AS Name_1, p2.Name AS Name_2 FROM Camp_assignment A 
    JOIN Camp_assignment B
    JOIN Personnel AS p1 ON A.Observer = p1.Abbreviation
    JOIN Personnel AS p2 ON B.Observer = p2.Abbreviation
    ON A.Site = B.Site WHERE A.End >= B.Start AND A.Start <= B.End 
    AND A.Site = 'lkri' 
    AND A.Observer < B.Observer
    ORDER BY Name_2;

--- Who's the Culprit --
SELECT Name, COUNT(ageMethod) AS Num_floated_nests FROM Bird_nests
    JOIN Personnel ON Abbreviation = Observer
    WHERE Site = 'nome'
    AND ageMethod = 'float'
    AND Year >= 1998
    AND Year <= 2008
    GROUP BY Name
    LIMIT 1;
