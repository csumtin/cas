#!/bin/bash
# Show the contents of encypted input file. If input is a folder,
# show contents of all the files. Don't show 2/ or 3/
set -eu

source cas.sh

input=$(sanitize_input $1)
check_top_level_directory $input

if [[ -f "$1" ]]; then
    check_encrypted_file $input
    echo "$( gpg_decrypt_no_output "$input" )"
elif [[ -d "$input" ]]; then

    if [[ "$input" == "2/" || "$input" == "3/" ]]; then
        echo "Can't dump 2/ or 3/"
        exit 1
    fi

    read -s -p "Enter passphrase: " passphrase

    find $input* -type f -name "*" |
        while read file; do
            if [[ "${file: -4}" == ".asc" && "$file" != *"validate.asc" ]]; then
                echo -n -e "\n$file\n"
                gpg_decrypt_no_output_quiet_with_passphrase "$file" "$passphrase"
            fi
        done

    passphrase=""
fi
