#!/bin/bash

#Генерацию надо поднять. Генерацияяяя
StartGen() {
    nameLen=${#foldersName}
    offset=$nameLen

    # Если длина имени меньше 5 символов, дополняем её до 5 символов
    if [[ nameLen -lt 5 ]]; then
        offset=$((5 - $nameLen))
    fi

    absolutePath=$(sudo find / -maxdepth 2 -type d -writable 2>/dev/null | sort -R | tail -1 | grep -v -e "bin" -e "sbin") #Генерируем путь к директории
    foldersNumber=$((1 + $RANDOM % 100)) #Генерируем количество папок
    numberFiles=$((1 + $RANDOM % 100)) #Генерируем колво файлов

    # Генерация директорий и файлов

    for (( i=$offset; i<($foldersNumber+$offset); i++ ))
    do
        dirPath=$(makeDir $absolutePath $i)    # dlinna imeni kajdoi papki
        absolutePath=$dirPath


        for (( j=0; j<$numberFiles; j++ ))
        do
            if [[ $(isOverMemory) == "true" ]]; then
                echo "ERROR! Памяти на жестком диске меньше 1GB"
                exit
            else
                isDigit='^[0-9]+$'
                if [[ $j =~ $isDigit ]]; then
                    makeFile $dirPath $j
                fi
            fi
        done
    done
}

makeDir() {
    path=$absolutePath/$(FolderNameGen $2)_$(GetDate)
    sudo mkdir -p $path
    # пишем лог, пьем сок
    AddLogLine $path $(GetDate)
    echo $path
}

# Создаем файлик
makeFile() {
    FolderPath=$1

    baseCharset=${fileNames%%.*}
    baselen=${#baseCharset}
    nameLen=$(($baselen))
    if [[ $nameLen -lt 5 ]]
    then
        let "nameLen+=(5-nameLen)"
    fi
    let "nameLen+=j"

    FileName=$(FileNameGen $nameLen)

    # fallocate создает нам файлик и заодно определяет место на жестком диске под него
    sudo fallocate -l ${filesize^} $FolderPath/$FileName 2>/dev/null
    # пишем лог, пьем сок
    AddLogLine $FolderPath/$FileName $(GetDate) $filesize 

}

# Получаем дату
GetDate() {
    echo $(date +%d%m%y)
}

# Генерим имя для директории
FolderNameGen() {
    str=$foldersName
    maxLen=$1
    charsNumber=${#str}

    strlen=${#str}
    lastChar=${str:strlen-1}
    firstChar=${str:0:1}

    for (( i=$strlen; i<$maxLen; i++ ))
    do
        str="${str:0:1}${str}" # добавляем символ в строку
        let "strlen+=1"
    done

    echo $str
}

#генерим имя для файла
FileNameGen() {
    strFile=$fileNames

    extCharset=${strFile#*.} # получить расширение
    baseCharset=${strFile%%.*} # получить имя файла
    baselen=${#baseCharset}
    base=$baseCharset
    baseMaxLen=$1

    for (( i=$baselen; i<$baseMaxLen; i++ ))
    do
        base="${base:0:1}${base}" # добавляем символ в строку
        let "strlen+=1"
    done

    strlenExt=${#extCharset}
    maxLenExt=3
    ext=$extCharset
    if [[ $maxLenExt -lt 3 ]]
    then
        maxLenExt=3
    fi

    for (( i=$strlenExt; i<$maxLenExt; i++ ))
    do
        ext="${ext:0:1}${ext}" # добавляем символ в строку
        let "strlen+=1"
    done

    echo "$base.$ext"_"$(GetDate)"
}

# Получаем свободное место на диске
GetFreeSize() {
    echo $(df / -BM | awk '{print $4}' | tail -n 1 | cut -d 'M' -f1)
}

# Проверяем, что осталось не менее 1 гигабайта
isOverMemory() {
    if [[ $(GetFreeSize) -lt 1024 ]]; then
        echo "true"
    else
        echo "false"
    fi
}

# Пишем лог, пьем сок
AddLogLine() {
    fullPath=$1
    date=$2
    size=$3
    time=$(date +%H:%M:%S)

    line="$fullPath $date $time $size"

    sudo echo $line >> log.txt
}

FinalLog() {
    timeCompletedIn=$(date +%H:%M:%S)
    END_TIME=$(date +%s)
    executionTime=$(( $END_TIME - $START_TIME ))

    echo "Время начала работы скрипта = $(date '+%Y-%m-%d') $timeRunIn"
    echo "Время окончания = $(date '+%Y-%m-%d') $timeCompletedIn"
    echo "Общее время его работы (секунды) = $executionTime"

    echo "Время начала работы скрипта = $(date '+%Y-%m-%d') $timeRunIn" >> log.txt
    echo "Время окончания = $(date '+%Y-%m-%d') $timeCompletedIn" >> log.txt
    echo "Общее время его работы (секунды) = $executionTime" >> log.txt
}
