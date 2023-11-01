#!/bin/bas
source gen.sh

# Основной цикл для создания логов на протяжении 5 дней
for (( i=1; i < 6; i++ )); do
    log_file="log_day$i.log"
    num_entries=$((RANDOM % 901 + 100))  # Генерируем случайное количество записей от 100 до 1000
    date=$(get_date )
    for ((j = 0; j <= num_entries; j++)); do
        log=$(gen_log $i)
        echo "$log" >> $log_file
    done
done

echo "Логи сгенерированы"