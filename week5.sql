-- 29 April 2024
-- Data Management Statements
.nullvalue -NULL-
.maxrows 8

SELECT * FROM Species;
    INSERT INTO Species Values ('abcd', 'thing', 'scientific name', NULL);
SELECT * FROM Species;
-- can explicitly label cols
INSERT INTO Species (Common_name, Scientific_name, Code, Relevance)
    VALUES ('thing2', 'another scientific name', 'efgh', NULL);
-- take advantage of default values
INSERT INTO Species (Common_name, Code) VALUES ('thing3', 'ijkl');

-- UPDATE and DELETE
UPDATE Species SET Relevance = 'not sure yet' WHERE Relevance IS NULL;
SELECT * FROM Species; -- take a look at the updated values
DELETE FROM Species WHERE Relevance = 'not sure yet';
-- safe delete practice -- select first to confirm what you are getting rid of
SELECT * FROM Species WHERE Relevance = 'Study Species';

-- Write a table
COPY Species TO 'species_fixed.csv' (HEADER, DELIMITER ',');

-- Create table
CREATE TABLE Snow_cover2 (
    Site VARCHAR NOT NULL,
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1950 AND 2015),
    Date DATE NOT NULL,
    Plot VARCHAR, -- some Null in the data :/
    Location VARCHAR NOT NULL,
    Snow_cover INTEGER CHECK (Snow_cover > -1 AND Snow_cover < 101),
    Observer VARCHAR
);
.tables
SELECT * FROM Snow_cover2; -- no rows, but we can see the table structure and data types
-- add data to table
COPY Snow_cover2 FROM 'snow_cover_fixedman_JB.csv' (HEADER TRUE);
SELECT * FROM Snow_cover2; -- now we have a table with all the data from the csv

-- Triggers
-- this won't run; duckdb does not support trigger- need to do this in sqlite
CREATE TRIGGER Update_species
AFTER INSERT ON Species
FOR EACH ROW
BEGIN
    UPDATE Species
    SET Scientific_name = NULL
    WHERE Code = new.Code AND Scientific_name = '';
END;
