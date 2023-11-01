#!/bin/bash
source check_input.sh

check "$@"

parameter="$1"

case "$parameter" in
    1)
        # Все записи, отсортированные по коду ответа
        for log_file in "${log_files[@]}"; do
            echo "Log file: $log_file"
            rm -f code_sort.log
            awk '{print $0}' "$log_file" | sort -k 7 >> code_sort.log
        done
        ;;
    2)
        # Все уникальные IP, встречающиеся в записях
        for log_file in "${log_files[@]}"; do
            echo "Log file: $log_file"
            rm -f uniq_ip.log
            awk '{print $1}' "$log_file" | sort | uniq >> uniq_ip.log
        done
        ;;
    3)
        # Все запросы с ошибками (код ответа - 4xx или 5xx)
        for log_file in "${log_files[@]}"; do
            echo "Log file: $log_file"
            rm -f error_sort.log
            awk '{ if ($7 >= 400 && $4 < 600) print $5,$6,$7 }' "$log_file" | sort -k 3 >> error_sort.log
        done
        ;;
    4)
        # Все уникальные IP, которые встречаются среди ошибочных запросов
        for log_file in "${log_files[@]}"; do
            echo "Log file: $log_file"
            rm -f error_uniq_ip.log
            awk '{ if ($7 >= 400 && $4 < 600)) print $1 }' "$log_file" | sort | uniq >> error_uniq_ip.log
        done
        ;;
    *)
        echo "Error. Введен неверный параметр." 
        exit 1
        ;;
esac

exit 0
