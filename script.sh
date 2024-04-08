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
        if [[ -n ${VALUES[i]} ]]; then
            echo "$((i + 1)). ${OPTIONS[i]} - ${VALUES[i]}"
        else
            echo "$((i + 1)). ${OPTIONS[i]}"
        fi
    done;
};

function handle_menu() {
    index=$((INPUT - 1))
    echo -n "Enter ${OPTIONS[index]}: "
    read VALUES[index]
}

function find() {
    [[ -n "${VALUES[1]}" ]] && directory="${VALUES[1]}" || directory="~/"
    [[ -n "${VALUES[0]}" ]] && filename="-name ${VALUES[0]}" || filename=""
    [[ -n "${VALUES[2]}" ]] && min="-size +${VALUES[2]}c" || min=""
    [[ -n "${VALUES[3]}" ]] && max="-size -${VALUES[3]}c" || max=""
    [[ -n "${VALUES[4]}" ]] && perms="-perm ${VALUES[4]}" || perms=""
    echo "find ${directory} -type f ${filename} ${min} ${max} ${perms}";
    output=$(find "${directory}" -type f ${filename} ${min} ${max} ${perms})
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
        find
    fi;
done;
