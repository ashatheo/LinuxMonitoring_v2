#!/bin/bash

path="../04"
for (( i=1; i < 6; i++))
do
    if [[ -f "${path}/log_day$i.log" ]]
    then
        output=1
    else
        output=0
        echo "ERROR: ${path}/log_day$i.log файла не существует!" >&2
        break
    fi
done

if [[ $output -eq 1 ]]
then
    sudo apt install -y goaccess

    goaccess ${path}/*.log --log-format=COMBINED --time-format=%T -o report.html
fi