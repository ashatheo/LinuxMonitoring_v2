check_arg() {

#Проверяем параметры запуска
if [[ $1 =~ ^[1-3]+$ ]];then
    clearMode=$1
else
    echo "Error: Введите только 1 аргумент для запуска! В диапазоне от 1 до 3 "
    exit 1
fi
}

#Проверяем наличие лог файла
check_log_file () {
    if ! [[ -f $logfile ]] ; then
    echo "Error: Нету файла с логами"
    exit 1
fi
}

#Проверяем корректность введеной даты для 2 параметра
check_datetime() {
    local datetime="$1"
    local pattern="^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}$"

    if ! [[  $datetime =~ $pattern ]]; then
        echo "Error:: Некорректный формат даты и времени. Используйте формат 'YYYY-MM-DD HH:MM'."
        exit 1
    fi
}

check_mask() {
    if ! [[ "$mask" =~ ^[a-zA-Z_]+\_[0-9]{6}$ || "$mask" =~ ^[a-zA-Z_]+\.[a-zA-Z]+\_[0-9]{6}$ ]]; then
         echo "Error:: Некорректный формат маски"
         exit 1
    fi
}

#Проверяем сколько места на жестком диске
check_freespace(){
    echo "Свободного места на жестком диске: `df -h / | awk 'NR==2 {print $4}'
`"
}