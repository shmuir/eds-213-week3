--HW 5

-- Protect yourself --
-- To protect myself from UPDATEs and DELETEs with unintended concequences, I will use a SELECT query first to see if the results are what I expect, and then perform the UPDATE or DELETE if everything is functioning correctly.
-- If it is not, I can modify the SELECT until the desired outcome, and then perform the UPDATE/DELETE, knowing that I am getting my expected results. 

-- Create a Trigger --
-- Part 1
CREATE TRIGGER egg_filler
AFTER INSERT ON Bird_eggs
FOR EACH ROW
BEGIN
    UPDATE Bird_eggs
    SET Egg_num = (
        SELECT CASE
            WHEN MAX(Egg_num) IS NULL THEN 1
            ELSE MAX(Egg_num) + 1
        END
        FROM Bird_eggs
        WHERE Nest_ID = NEW.Nest_ID
    )
    WHERE rowid = NEW.rowid;
END;

-- testing the trigger
INSERT INTO Bird_eggs (Book_page, Year, Site, Nest_ID, Length, Width)
VALUES ('b14.6', 2014, 'eaba', '14eabaage01', 53.99, 14.99);

SELECT * FROM Bird_eggs WHERE Nest_ID = '14eabaage01';

DROP TRIGGER egg_filler;

-- part 2
CREATE TRIGGER egg_filler
AFTER INSERT ON Bird_eggs
FOR EACH ROW
BEGIN
    UPDATE Bird_eggs
    SET Egg_num = (
        SELECT CASE
            WHEN MAX(Egg_num) IS NULL THEN 1
            ELSE MAX(Egg_num) + 1
        END
        FROM Bird_eggs
        WHERE Nest_ID = NEW.Nest_ID),
    Book_page = (
        SELECT Book_page
        FROM Bird_eggs
        WHERE Nest_ID=NEW.Nest_ID
    ),
    Year = (
        SELECT Year
        FROM Bird_eggs
        WHERE Nest_ID = NEW.Nest_ID),
    Site = (
        SELECT Site
        FROM Bird_eggs
        WHERE Nest_ID = NEW.Nest_ID
    )
    WHERE rowid = NEW.rowid;
END;

-- testing trigger
INSERT INTO Bird_eggs
    (Nest_ID, Length, Width)
    VALUES ('14eabaage01', 12.34, 56.78);

SELECT * FROM Bird_eggs WHERE Nest_ID = '14eabaage01';




--Bash Essentials--
-- 1. The output of all of these are the same. ls lists everything in the current directory. ls . does the same thing, we are just specifying that we are selecting all.  ls "$(pwd)/../week3" prints everthing in the directory that you specify. In this case, we started at the working directory, went out one level, and selected the week 3 folder, so we get the same output as the other two. 

-- 2. The first command returns the word cout (lines) in each .csv, as well as the total for all of them. The second one returns just the total since it concatonates all of the lines of all of csvs, and pipes into a wc to get the wordcount to get the total. Once the csvs are concatonated, there is no file name, so there is no file names to return.

-- 3. This returns the word count from just species.csv since we concatonated all of the .csvs, but then piped and specified only the word count from species.csv.

-- 4. echo $name"_Howard"

-- 5. The $1 is indicating an arguement that we will give when we run the script. In this case is it "*.csv" is selecting all the .csv files, so this is not actually one argument; it is many csv files and each one is being given as an argument. The $# is the total number of arguments given. 

-- 6. $3 is the third argument. In this case there is no third argument given.

-- 7. There is nothing returned since that command removed all of the text from the file. sort junk_file.txt > junk_file2.txt. This puts the sorted text of junk_file.txt into a new text file with the sorted text. 

-- 8. It will delete everything in the directory, not just the .csv files. 



-- except
bash query_timer.sh except 100 'SELECT Code FROM Species
EXCEPT
SELECT DISTINCT Species FROM Bird_nests;' \
    database.db timings.csv

--join
bash query_timer.sh join 100 'SELECT Code
    FROM Bird_nests RIGHT JOIN Species
    ON Species = Code
    WHERE Nest_ID IS NULL;' \
    database.db timings.csv

--not in
bash query_timer.sh not 100 'SELECT Code
    FROM Species
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);' \
    database.db timings.csv
