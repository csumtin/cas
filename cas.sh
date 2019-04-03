#!/bin/bash
# CAS functions
set -eu

# make sure we are in cas directory
cd "$(dirname "$0")"

print_algo_details() {
    echo "gpg --batch --armor --cipher-algo AES256 --s2k-mode 3 --s2k-digest-algo SHA512 --s2k-count 65011712 --symmetric --passphrase"
    echo "gpg --batch --decrypt --passphrase"
}

gpg_encrypt() {
    gpg --batch --armor --cipher-algo AES256 --s2k-mode 3 --s2k-digest-algo SHA512 --s2k-count 65011712 --symmetric "$1"
}

gpg_encrypt_with_passphrase() {
    gpg --batch --armor --cipher-algo AES256 --s2k-mode 3 --s2k-digest-algo SHA512 --s2k-count 65011712 --passphrase "$2" --symmetric "$1"
}

gpg_encrypt_replace_with_passphrase() {
    gpg --batch --armor --cipher-algo AES256 --s2k-mode 3 --s2k-digest-algo SHA512 --s2k-count 65011712 --passphrase "$2" --yes --symmetric "$1"
}

gpg_decrypt() {
    gpg --batch --output "${1:: -4}" --decrypt "$1"
}

gpg_decrypt_with_passphrase() {
    gpg --batch --output "${1:: -4}" --passphrase "$2" --decrypt "$1"
}

gpg_decrypt_no_output() {
    gpg --batch --decrypt "$1"
}

gpg_decrypt_no_output_quiet() {
    gpg --quiet --batch --decrypt "$1"
}

gpg_decrypt_no_output_with_passphrase() {
    gpg --batch --passphrase "$2" --decrypt "$1"
}

gpg_decrypt_no_output_quiet_with_passphrase() {
    gpg --quiet --batch --passphrase "$2" --decrypt "$1"
}

sanitize_input() {
    if [[ "$1" == "0" ]]; then
        echo "0/"
    elif [[ "$1" == "1" ]]; then
        echo "1/"
    elif [[ "$1" == "2" ]]; then
        echo "2/"
    elif [[ "$1" == "3" ]]; then
        echo "3/"
    else
        echo $1
    fi
}

get_top_level_directory() {
    local top_level_directory="none"
    if [[ "$1" == "0/"* ]]; then
        top_level_directory="0"
    fi
    if [[ "$1" == "1/"* ]]; then
        top_level_directory="1"
    fi
    if [[ "$1" == "2/"* ]]; then
        top_level_directory="2"
    fi
    if [[ "$1" == "3/"* ]]; then
        top_level_directory="3"
    fi
    echo $top_level_directory
}

check_top_level_directory() {
    local top_level_directory=$(get_top_level_directory $1)
    if [[ "$top_level_directory" == "none" ]]; then
        echo "Error: secrets must be in one of these folders: 0/ 1/ 2/ 3/"
        exit 1
    fi
}

check_file() {
    if [[ ! -f "$1" ]]; then
        echo "Error: $1 is not a file"
        exit 1
    fi
}

check_unencrypted_file() {
    if [[ "${1: -4}" == ".asc" ]]; then
        echo "Error: $1 is an asc(encrypted armor) file"
        exit 1
    fi
}

check_encrypted_file() {
    if [[ "${1: -4}" != ".asc" ]]; then
        echo "Error: $1 is not an asc(encrypted armor) file"
        exit 1
    fi
}

check_validate() {
    # decrypt validate.asc so we are sure we are using same passphrase for whole folder
    gpg_decrypt_no_output_with_passphrase "$1/validate.asc" "$2"
}

check_not_validate_file() {
    if [[ "$1" == *"/validate" || "$1" == *"validate.asc" ]]; then
        echo "Trying to use validate file"
        exit 1
    fi
}

get_all_unencrypted_files() {
    find * -type f ! -name "*.asc" ! -name "backup.sh" ! -name "cas.sh" ! -name "copy_to_clipboard.sh" ! -name "decrypt.sh" ! -name "edit.sh" ! -name "embed.sh" ! -name "encrypt.sh" ! -name "extract.sh" ! -name "generate.sh" ! -name "list_all_unencrypted_files.sh" ! -name "pseudonym.sh" ! -name "README.md" ! -name "show.sh" ! -name "space.jpg"
}

get_all_encrypted_files_and_dump_contents() {
    find */ -type f -name "*.asc" -exec echo {} \; -exec cat {} \;
}

add_generated_pass_to_encrypted_file() {
    gpg_decrypt_with_passphrase "$1" "$2"
    rm "$1"

    echo -n -e "\n$3" >> "${1:: -4}"

    gpg_encrypt_replace_with_passphrase "${1:: -4}" "$2" 
    rm "${1:: -4}"
}
