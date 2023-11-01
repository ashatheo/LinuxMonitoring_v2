#!/bin/bash

#Чистим по лог файлу
log_clean() {
    check_log_file
    check_freespace

    echo "Очистка по лог файлу..."
    while read line
    do
        path=$(echo $line | awk '{print $1}')
        sudo rm -rf $path 2>/dev/null
    done < log.txt
}

timedate_clean() {
    check_freespace
    log_file="logrm.txt"

    echo "Введите дату и время создания файлов в таком формате с точностью до минуты: $(date '+%Y-%m-%d %H:%M')"
    
    read -p "Введите время начала создания файлов: " start_time
    check_datetime "$start_time"    
    read -p "Введите время конца создания файлов: " end_time
    check_datetime "$end_time"
    
    
    sudo find / -newermt "$start_time" -not -newermt "$end_time" 2>/dev/null | while read -r file; do
        # Проверяем, что имя файла оканчивается на _ и 6 цифр
        if [[ $file =~ _[0-9]{6}$ ]]; then
            echo "Удален: $file" >> "$log_file" 
            sudo rm -r "$file" 2>/dev/null
        fi
    done


    echo "Удаление завершено." >> "$log_file"
}

mask_clean() {
    read -p "Введите маску в таком формате foldername_$(date '+%d%m%y') или filename.txt_$(date '+%d%m%y')): " mask
    check_mask
    
    check_freespace
    echo "Ищеи и удаляем файлы по маске $mask..."
    
    find / -type f -name "*$mask*" 2>/dev/null | xargs sudo rm -f
    find / -type d -name "*$mask*" 2>/dev/null | xargs sudo rm -rf
    
    echo "Удаление завершено."
}

