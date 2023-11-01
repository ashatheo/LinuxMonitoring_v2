#!/bin/bash

source check_input.sh
source clean.sh
logfile="./log.txt"

check_arg "$@"

case $clearMode in
    1)log_clean;;
    2)timedate_clean;;
    3)mask_clean;;
esac

check_freespace