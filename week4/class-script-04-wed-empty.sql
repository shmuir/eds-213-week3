-- opening DuckDB with no database file , aka "in-memory"
> duckdb

-- opening an existing database with DuckDB
> duckdb database_filename.db

-- But Beware!! if you provide a filename that does not exist, DuckDB will create a new empty database with that name
> duckdb database_filename_with_tyop.db

-- Always good to check you have the right database using `.tables` after opening the database


-- Ask 1: What is the average snow cover at each site?
SELECT AVG(Snow_cover), Site FROM Snow_cover
    GROUP BY Site;

-- Ask 2: Order the result to get the top 3 snowy sites?
SELECT AVG(Snow_cover) AS avg_snow, Site FROM Snow_cover
    GROUP BY Site
    ORDER BY -avg_snow
    LIMIT 3;

-- Ask 3: Save your results into a temporary table named  Site_avg_snowcover
CREATE TEMP TABLE Site_avg_snowcover AS
SELECT AVG(Snow_cover) as avg_snow, Site FROM Snow_cover
    GROUP BY Site
    ORDER BY -avg_snow
    LIMIT 3;

-- Ask 4: How do I check the view was created?
SELECT * FROM Site_avg_snowcover;

-- Ask 5: Looking at the data, we have now a doubt about the meaning of the zero values... what if most of them where supposed to be NULL?! Does it matters? write a query that would check that?
-- if the zeors were not present, the avgerages change a lot
SELECT AVG(Snow_cover) AS avg_snow_no_zero, Site FROM Snow_cover
    WHERE Snow_cover > 0
    GROUP BY Site
    ORDER BY - avg_snow_no_zero;

-- Ask 6: Save your results into a **view** named Site_avg_snow_nozeros
CREATE VIEW Site_avg_snow_nozeros AS
SELECT AVG(Snow_cover) AS avg_snow_no_zero, Site FROM Snow_cover
    WHERE Snow_cover > 0
    GROUP BY Site
    ORDER BY - avg_snow_no_zero; 

-- Ask 7: Compute the difference between those two ways of computing average
SELECT Site, avg_snow_no_zero, avg_snow, avg_snow_no_zero - avg_snow AS snow_diff FROM Site_avg_snowcover
    JOIN Site_avg_snow_nozeros USING(Site)
    ORDER BY -snow_diff;

-- Ask 8: Which site would be the most impacted if zeros were not real zeros? Of Course we need a table for that :)
SELECT Site, avg_snow_no_zero, avg_snow, avg_snow_no_zero - avg_snow AS snow_diff FROM Site_avg_snowcover
    JOIN Site_avg_snow_nozeros USING(Site)
    ORDER BY -snow_diff
    LIMIT 1;

-- Ask 9: So? Would it be time well spent to further look into the meaning of zeros?


-- We found out that actually at the location `sno05` of the site eaba, 0 means NULL... let's update our Snow_cover table

CREATE TABLE Snow_cover_backup AS SELECT * FROM Snow_cover; -- Create a copy of the table to be safe (and not cry a lot)

-- For Recall
SELECT * FROM Site_avg_snowcover;
SELECT * FROM Site_avg_snowcover_nozeros;
-- update the 0 for that site
UPDATE Snow_cover SET Snow_cover = NULL WHERE Location = 'sno05' AND Snow_cover = 0; 
-- Check the update was succesful
SELECT * FROM Snow_cover WHERE Location = 'sno05';
-- We should probably recompute the avg, let's check
SELECT * FROM Site_avg_snowcover;
-- What just happened!?
CREATE VIEW Site_avg_snowcover_new AS SELECT Site, AVG(Snow_cover) AS avg_cover FROM Snow_cover
    GROUP BY Site
    ORDER BY -avg_cover
    LIMIT 3;

SELECT * FROM Site_avg_snowcover_new;

-- Ask 10: Let's move on to inspecting the nests and answering the following question: 
    -- Which shorebird species makes the most eggs? Oh and I need a table with the common names, just because :)

SELECT * FROM Bird_eggs;
SELECT * FROM Species;
SELECT * FROM Bird_nests;
SELECT SUM(Egg_num) AS Egg_sum, Bird_eggs.Nest_ID,  FROM Bird_eggs
    JOIN Bird_nests USING(Site)
    GROUP BY Bird_eggs.Nest_ID
    JOIN Species USING(Nest_ID);