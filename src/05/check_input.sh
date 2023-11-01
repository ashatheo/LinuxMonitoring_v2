#!/bin/bash

check() {

if [ $# -ne 1 ]; then
    echo "Error: Введите параметр запуска 1-4"
    exit 1
fi

log_dir="../04"
log_files=($(ls -1 "$log_dir/log_day"*.log))

# Проверяем наличие лог-файлов
if [ ${#log_files[@]} -eq 0 ]; then
    echo "Нету лог файлов: $log_dir"
    exit 1
fi
}