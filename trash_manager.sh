#!/usr/bin/env bash

set -euo pipefail

TRASH="$HOME/.local/share/Trash"
cd "$TRASH"
declare -A trash_info
sum_files=0

count_files() {
    for dir in *; do
        local number=$(find $dir -mindepth 1 | wc -l)
        trash_info["$dir"]=$number
        sum_files=$(($sum_files + $number))
    done
}

clean_trash() {
    echo "----------- Clean Trash ------------"
    for key in "${!trash_info[@]}"; do
        if [[ ${trash_info[$key]} -eq 0 ]]; then
            continue
        fi
        rm ./$key/*
        trash_info[$key]=0
        sum_files=0
    done
}

show_trash() {
    echo "----------- Show Trash -------------"
    for key in $(printf "%s\n" "${!trash_info[@]}" | sort); do
        printf "In Trash/%s -> %d file(s)\n" "$key" "${trash_info[$key]}"
    done

    local total_dirs=$((${#trash_info[@]}))
    printf "\nNumber of dirs in Trash: $total_dirs\n"
    printf "Total of files in Trash: $sum_files\n"
    echo "------------------------------------"
}

main() {
    count_files
    show_trash
    echo
    clean_trash
    echo
    show_trash
}
main
