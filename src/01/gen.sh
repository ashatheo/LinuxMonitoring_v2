#!/bin/bash

#Генерацию надо поднять. Генерацияяяя
startGen() {
    nameLen=${#foldersName}
    offset=$nameLen

    # Если длина имени меньше 4 символов, дополняем её до 4 символов
    if [[ nameLen -lt 4 ]]; then
        offset=$((4 - $nameLen))
    fi

    # Генерация директорий и файлов
    for (( i=$offset; i<($foldersNumber+$offset); i++ ))
    do
        dirPath=$(makeDir $absolutePath $i)
        absolutePath=$dirPath

        # Генерация файлов в текущей директории
        for (( j=0; j<$numberFiles; j++ ))
        do
            if [[ $(isOverMemory) == "true" ]]; then
                echo "ERROR! Памяти на жестком диске меньше 1GB"
                exit
            else
                makeFile $dirPath $j
            fi
        done
    done
}



#Создаем директорию
makeDir() {
    path=$absolutePath/$(FolderNameGen $2)_$('GetDate')
    sudo mkdir -p $path
# пишем лог пьем сок, пишем лог пьем сок
    AddLogLine $path $(GetDate)
    echo $path
}

#Создаем файлик
makeFile() {
    FolderPath=$1

    baseCharset=${fileNames%%.*}
    baselen=${#baseCharset}
    nameLen=$(($baselen))
    if [[ $nameLen -lt 4 ]]
    then
        let "nameLen+=(4-nameLen)"
    fi
    let "nameLen+=j"

    
    FileName=$(FileNameGen $nameLen)

    #fallocate создает нам файлик и заодно определяет место на жестком диске под него
    sudo fallocate -l ${filesize^} $FolderPath/$FileName
    # пишем лог пьем сок, пишем лог пьем сок
    AddLogLine $FolderPath/$FileName $(GetDate) $filesize


}

#получаем дату
GetDate() {
    echo `date +%d%m%y` 
}

#генерим имя для директории
FolderNameGen() {
    str=$foldersName
    maxLen=$1
    charsNumber=${#str}

    strlen=${#str}
    lastChar=${str:strlen-1}
    firstChar=${str:0:1}

    for (( i=$strlen; i<$maxLen; i++ ))
    do
        str="${str:0:1}${str}" #добавляем символ в строку
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

#узнаем свободное место на диске
GetFreeSize () {
    echo `df / -BM | awk '{print $4}' | tail -n 1 | cut -d 'M' -f1`
}

#проверяем что осталось не меньше 1 гига
isOverMemory() {
    if [[ $(GetFreeSize) -lt "1024" ]]; then
        echo "true"
    else
        echo "false"
    fi
}

#пишем лог, пьем сок
AddLogLine() {

    fullPath=$1
    date=$2
    size=$3
  
    line="$fullPath $date $size"

    sudo echo $line >> log.txt
    
}