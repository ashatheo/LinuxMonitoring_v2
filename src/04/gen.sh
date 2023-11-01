#!/bin/bash

# Массивы с возможными значениями для каждого поля
response_codes=("200" "201" "400" "401" "403" "404" "500" "501" "502" "503")
methods=("GET" "POST" "PUT" "PATCH" "DELETE")
user_agents=("Mozilla" "Google Chrome" "Opera" "Safari" "Internet Explorer" "Microsoft Edge" "Crawler and bot" "Library and net tool")
name_month=( "" "Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec" )

gen_ip() {
    printf "%d.%d.%d.%d\n" "$((RANDOM % 256))" "$((RANDOM % 256))" "$((RANDOM % 256))" "$((RANDOM % 256))"
}

# Генерируем случайную дату
get_date() {
    output=0
    while [[ $output -eq 0 ]]
    do
        day=$((RANDOM % 31 + 1 ))
        month=$((RANDOM % 12 + 1 ))
        year=$((RANDOM %  24 + 2 ))
    output=1
    done    
    echo "$( printf "%02d" "$day" )/${name_month[$month]}/$(( 2000 + $year ))"
}
# Генерируем время
get_time () {
    hour=$((RANDOM % 24))
    min=$((RANDOM % 60))
    sec=$((RANDOM % 60))
    echo "$(printf "%02d" "$hour"):$(printf "%02d" "$min"):$(printf "%02d" "$sec")"
}


# Генерации случайный URL

gen_url() {
    local url=
    amount_count=$((RANDOM % 1 + 3))
    for (( i=0; i < amount_count; i++ ))
    do
        url+="$( head -c 100 /dev/urandom | base64 | sed 's/[+=/A-Z]//g' | tail -c $((RANDOM % 4 + 8)) )"
        if [[ i -eq 0 ]]
        then
            url+=".ru"
        fi
        if [[ i -ne $(( $amount_count - 1 )) ]]
        then
            url+="/"
        fi
    done
    echo "https://$url.ru"
}

# Генерации случайный лог
gen_log() {
    local day=$1
    local ip=$(gen_ip)
    local code=${response_codes[$((RANDOM % 10))]}
    local method=${methods[$((RANDOM % 5))]}
    local time=$(get_time)
    local url=$(gen_url)
    local agent=${user_agents[$((RANDOM % 8))]}
    echo "$ip - - ["$date":"$time" +0200] \"$method $url\" $code \"-\" \"$agent\""
}
