#!/bin/bash
# Generate a random password and add it to the end of input file. If input is a folder,
# add a random password to all the files inside. Don't generate for whole folders 2/ or 3/
set -eu

source cas.sh

input=$(sanitize_input $1)
top_level_directory=$(get_top_level_directory $input)
check_top_level_directory $input

generated_pass=$( pwgen -c -n -1 20 )

if [[ -f "$input" ]]; then
    check_not_validate_file $input

    if [[ "${input: -4}" == ".asc" ]]; then
        read -s -p "Enter passphrase: " passphrase
        check_validate $top_level_directory $passphrase
        add_generated_pass_to_encrypted_file $input $passphrase $generated_pass
        passphrase=""
    else
        echo -n -e "\n$generated_pass" >> "$input"
        ./encrypt.sh "$input"
    fi

elif [[ -d "$input" ]]; then

    if [[ "$input" == "2/" || "$input" == "3/" ]]; then
        echo "Don't generate for whole folders 2/ or 3/"
        exit 1
    fi

    echo "Will generate new passwords for all items in directory $input"
    read -s -p "Enter passphrase: " passphrase
    check_validate $top_level_directory $passphrase

    find $input -maxdepth 1 -type f -name "*" |
        while read file; do
            if [[ "${file: -4}" == ".asc" && "$file" != *"validate.asc" ]]; then
                generated_pass=$( pwgen -c -n -1 20 )
                add_generated_pass_to_encrypted_file $file $passphrase $generated_pass
            fi
        done
    passphrase=""
else
    touch "$input"
    nano "$input"
    echo -n -e "\n$generated_pass" >> "$input"
    ./encrypt.sh "$input"
fi

(echo -n "$generated_pass" | xclip -selection c && sleep 30 && echo | xclip -selection c) &
generated_pass=""
