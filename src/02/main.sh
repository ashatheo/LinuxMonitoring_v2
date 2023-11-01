#!/bin/bash

source check_input.sh
source gen.sh

START_TIME=$(date +%s)
timeRunIn=`date +%H:%M:%S`

ultracheckPROMAX "$@"
StartGen
FinalLog

cp ./log.txt ../03/
