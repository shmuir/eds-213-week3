#!/bin/bash

label=$1
num_reps=$2
query=$3
db_file=$4
csv_file=$5

start="$(date +%s)"
for i in $(seq "$num_reps"); do
    duckdb "$db_file" -c "$query"
done
current="$(date +%s)"
elapsed=$((current-start))
time_rep=$(bc -l <<< "$elapsed / $num_reps")

echo "$label,$time_rep" >> "$csv_file"



