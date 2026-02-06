#!/bin/bash
errorlog="errors.log"

# help 

show_help() {
cat <<EOF

Usage: $0 [OPTIONS]

OPTIONS:
  -d <dir>    Recursively search dir for key
  -k <key>      key to search for
  -f <file>         Search directly inside a file
  --help            Display this help menu

EOF
}

# ERROR HANDLING

logs() {
    echo "ERROR: $1"
    echo "$(date) ERROR: $1" >> "$errorlog"
}

# RECURSIVE dir SEARCH

rfunc() {
    local dir="$1"
    local key="$2"

    for i in "$dir"/*; do
        
        if [[ -d "$i" ]]; then
            rfunc "$i" "$key"

        elif [[ -f "$i" ]]; then
            if grep -q "$key" "$i"; then
                echo "[MATCHED] key:\"$key\" found in $i"
            fi
        fi

    done
}

# VALIDATION USING REGEX

validate_inputs() {

    if [[ -z "$key" || ! "$key" =~ ^[A-Za-z0-9_]+$ ]]; then
        logs "Invalid or empty key: '$key'"
        exit 1
    fi

    if [[ -n "$dir" && ! -d "$dir" ]]; then
        logs "dir not found: $dir"
        exit 1
    fi

# File validation

    if [[ -n "$file" && ! -f "$file" ]]; then
        logs "File not found: $file"
        file=""
    fi
}


# --help

if [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

while getopts ":d:k:f:" opt; do
    case "$opt" in
        d) dir="$OPTARG" ;;
        k) key="$OPTARG" ;;
        f) file="$OPTARG" ;;
        :)
            logs "Option -$OPTARG requires an argument"
            exit 1
            ;;
        \?)
            logs "Invalid option: -$OPTARG"
            exit 1
            ;;
    esac
done

echo "============================"
echo "FEEDBACK"
echo "============================"

echo "->>> Script Name: $0"
echo "->>> Argument Count: $#"
echo "->>> All Arguments: $@"

# check inputs

validate_inputs

# file search

if [[ -n "$file" ]]; then
    echo "-----------------------------------------"
    echo "->>> Searching inside file: $file"

    if grep -q "$key" <<< "$(cat "$file")"; then
        echo "[MATCHED] key: \"$key\" found in $file"
    else
        echo "No match found in $file"
    fi

    echo "->>> File search exit status: $?"
fi


# directory search

if [[ -n "$dir" ]]; then
    echo "-----------------------------------------"
    echo "->>> searching dir: $dir"

    rfunc "$dir" "$key"

    echo "->>> directory search exit status: $?"
fi


# If no action was given

if [[ -z "$file" && -z "$dir" ]]; then
    logs "No action specified. Use --help"
    exit 1
fi

