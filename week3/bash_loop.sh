#!/bin/bash

# making a for loop to get the row counts of all of te .csvs in the week3 folder
for file in *.csv; do
    echo "$file has $(wc -l < $file) lines"
done

# give the file name (echo $file)
# print the number of lines for each file $(wc -l < $file) [the < removes the file name from the end of the output]