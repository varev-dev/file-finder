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
    local menu=()
    for i in "${!OPTIONS[@]}"; do
        index=$((i + 1))
        option="${OPTIONS[$i]}"
        [[ -n ${VALUES[i]} ]] && option="${option} - ${VALUES[i]}"
        menu+=("$index" "$option")
    done

    INPUT=`dialog --stdout --nocancel --title "File finder" --menu "Choose option:" 0 60 ${#OPTIONS[@]} "${menu[@]}"`
};

function handle_menu() {
    index=$((INPUT - 1))
    VALUES[index]=`dialog --stdout --title "File finder" --inputbox "Enter ${OPTIONS[index]}: " 0 60 `
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
        
    if [ -n "$output" ]; then
        echo "$output" > raport.txt
        path=`pwd`
        path="$path/raport.txt"
        res=`dialog --stdout --title "File finder" --msgbox "Results saved in ${path}" 16 60`
    else
        res=`dialog --stdout --title "File finder" --msgbox "No files found." 16 60`
    fi
}

while [ "${INPUT:0:1}" != ${EXIT} ]; do
    print_menu
    if [[ $INPUT =~ ^[1-6]$ ]]; then
        handle_menu
    elif [[ ${INPUT} =~ [7] ]]; then
        find_files
    fi;
done;
