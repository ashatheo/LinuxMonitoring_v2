#!/bin/bash

ultracheckPROMAX() {
check_arg "$@"
check_absolutePath "$1"
check_number_subfolders "$2"
check_folders_name "$3"
check_number_files "$4"
check_file_name "$5"
check_file_size "$6"
}

# Проверяем количество параметров
check_arg() {
    if [ $# -ne 6 ]; then
        echo "Error: Введите 6 аргументов для запуска!"
        exit 1
    fi
}

# Проверяем корректный ввод пути
check_absolutePath() {
    if [ -d "$1" ]; then
        absolutePath="$1"
    else
        echo "Error: Директории не существует!"
        read -p "Создать "$1" директорию? (y/n) " answer
        if [ "$answer" == "${answer#[Yy]}" ]; then
            exit 1
        else
            sudo mkdir -p "$1"
            if [ -d "$1" ]; then
                absolutePath="$1"
            else
                echo "Не удалось создать директорию! Пожалуйста, укажите абсолютный путь в первом параметре при запуске скрипта."
                exit 1
            fi
        fi
    fi
}


# Проверяем количество вложенных папок.
check_number_subfolders () {   
    if  [[ "$1" =~ ^[0-9]+$ ]];then
    foldersNumber="$1"
    else
        echo "ERROR: Введите вторым аргументом количество вложенных папок"
        exit 1
    fi
}

# Проверяем список букв английского алфавита, используемый в названии папок (не более 7 знаков).
check_folders_name () {
    if [[ ${#1} -le 7 && "$1" =~ ^[a-zA-Z_]+$ ]]; then
        foldersName="$1"
    else
        echo "ERROR: Введите 3 аргументом список букв (не более 7 знаков) и только из букв английского алфавита"
        exit 1
    fi
}

# Проверяем количество файлов в каждой созданной папке. 

check_number_files () {
    if  [[ "$1" =~ ^[0-9]+$ ]];then
    numberFiles="$1"
    else
        echo "ERROR: Введите 4 аргументом количество файлов в каждой созданной папке"
        exit 1
    fi
}

check_file_name () {
    if  [[ "$1" =~ ^[a-zA-Z_]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
    fileNames="$1"
    else
        echo "ERROR: Введите 5 аргументом имя файлов и расширение в формате name.ext (не более 7 символов для имени, не более 3 символов для расширения, только буквы английского алфавита)"
        exit 1       
    fi
}


# Проверяем размер файлов (в килобайтах, но не более 100)
check_file_size() {
    if [[ "${1:(-2)}" == "kb" && "${1:0:(-2)}" =~ ^[0-9]+$ && "${1:0:(-2)}" -ge 1 && "${1:0:(-2)}" -le 100 ]]; then
        filesize="$1"
    else
        echo "ERROR: Введите размер файла в kb (от 1 до 100)"
        exit 1
    fi
}

