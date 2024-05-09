#!/bin/bash

label=$1
num_reps=$2
query=$3
db_file=$4
csv_file=$5

start="$(date +%s)" # get start datetime
for i in $(seq "$num_reps"); do
    duckdb "$db_file" -c "$query" 
done
current="$(date +%s)" # get current time at end
elapsed=$((current-start)) # get the elapsed time using start and current
time_rep=$(bc -l <<< "$elapsed / $num_reps")

echo "$label,$time_rep" >> "$csv_file" # append to csv



