#!bin/bash

declare -a OPTIONS=(
    "Filename" "Directory" "Min size" "Max size" "Permision" "Content" "Find" "Exit"
)

declare -a VALUES=(
    "" "" "" "" "" ""
)

INPUT=""
EXIT="8"

function print_menu() {
    for ((i=0; i<${#OPTIONS[@]}; i++)) do
        echo -n "$((i + 1)). ${OPTIONS[i]}"
        [[ -n ${VALUES[i]} ]] && echo " - ${VALUES[i]}" || echo "";
    done;
};

function handle_menu() {
    index=$((INPUT - 1))
    echo -n "Enter ${OPTIONS[index]}: "
    read VALUES[index]
}

function find_files() {
    [[ -n "${VALUES[1]}" ]] && directory="${VALUES[1]}" || directory="$HOME"
    [[ -n "${VALUES[0]}" ]] && filename="-name ${VALUES[0]}" || filename=""
    [[ -n "${VALUES[2]}" ]] && min="-size +${VALUES[2]}c" || min=""
    [[ -n "${VALUES[3]}" ]] && max="-size -${VALUES[3]}c" || max=""
    [[ -n "${VALUES[4]}" ]] && perms="-perm ${VALUES[4]}" || perms=""
    [[ -n "${max}" && -n "${min}" ]] && max=" -a $max"

    output=`find "${directory}" -maxdepth 6 -type f ${filename} ${perms} ${min} ${max}`
    if [[ -n "${VALUES[5]}" ]]; then
        output=$(echo "$output" | xargs grep -l "${VALUES[5]}")
    fi
    echo "$output"
}

while [ "${INPUT:0:1}" != ${EXIT} ]; do
    print_menu
    echo -n "Choose an option: "
    read INPUT
    if [[ $INPUT =~ ^[1-6]$ ]]; then
        handle_menu
        clear
    elif [[ ${INPUT} =~ [7] ]]; then
        find_files
    else
        clear
    fi;
done;
