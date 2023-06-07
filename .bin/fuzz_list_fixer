#!/usr/bin/env bash

Usage() {
    printf "<------------------------------------------------------>\n"
    printf "fuzz_list_fixer\nA mini tool to add with-slash items to the list\n"
    printf "<------------------------------------------------------>\n"
    printf "Usage: $0 [OPTIONS] [ARGS]\n"
    printf "Options:\n"
    printf "\t-h, --help\t\t\tShow this help message and exit\n"
    printf "\t-l, --list\t\t\tList file to use, required\n"
    printf "\t--args\t\t\t\tPass remaining args to single_sub_fuzz\n"
    printf "Args:\n"
    printf "\tARGS\t\t\t\tArguments to pass to single_sub_fuzz\n"
    printf "Examples:\n"
    printf "\t$0 -l /path/to/list.txt\n"
    printf "\t$0 -l /path/to/list.txt --args -t 100 -f\n"
    printf "\t$0 -l /path/to/list.txt --args -o /path/to/output.txt\n"
    printf "<------------------------------------------------------>\n"
}

list_file=""
POSITIONAL=()

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -h|--help)
            Usage
            exit 0
            ;;
        -l|--list)
            list_file="$2"
            shift
            shift
            ;;
        --args)
            # Add remaining args to POSITIONAL until end of args or next flag(starting with -)
            while [[ $# -gt 0 ]]; do
                key="$1"
                if [[ $key == -* ]]; then
                    break
                fi
                POSITIONAL+=("$1")
                shift
            done
            ;;
        *)
            POSITIONAL+=("$1")
            shift
            ;;
    esac
done

set -- "${POSITIONAL[@]}" # restore positional parameters -what does this do? - it sets the positional parameters to the value of the array

if [[ -z "$list_file" ]]; then
    echo "No list file specified"
    Usage
    exit 1
fi

if [[ ! -f "$list_file" ]]; then
    echo "List file does not exist"
    Usage
    exit 1
fi

if [[ ! -r "$list_file" ]]; then
    echo "List file is not readable"
    Usage
    exit 1
fi

if [[ ! -s "$list_file" ]]; then
    echo "List file is empty"
    Usage
    exit 1
fi

# Get the directory of list file
list_dir=$(dirname "$list_file")

# Read lines of list file into array
readarray -t list_array < "$list_file"

# Iterate over array
for item in "${list_array[@]}"; do
    # If last character is not a slash and there is no "$item/" in the array, add it
    if [[ "${item: -1}" != "/" ]] && [[ ! " ${list_array[@]} " =~ " $item/ " ]]; then
        list_array+=("$item/")
    fi
done

# Sort -unique array, then write it to a file in the same directory as the list file but the name starts with fixed_ , replace new content if output file already exists
printf '%s\n' "${list_array[@]}" | sort -u > "$list_dir/fixed_$(basename "$list_file")"

echo "Done !"