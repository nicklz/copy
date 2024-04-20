#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 [OPTION]... SOURCE DEST"
    echo "Copy SOURCE to DEST."
    echo ""
    echo "Options:"
    echo "  -a, --archive       same as -dR --preserve=all"
    echo "  -b                  like --backup but does not accept an argument"
    echo "  -f, --force         if an existing destination file cannot be opened, remove it and try again"
    echo "  -i, --interactive   prompt before overwrite"
    echo "  -p                  same as --preserve=mode,ownership,timestamps"
    echo "  -r, --recursive     copy directories recursively"
    echo "  -v, --verbose       explain what is being done"
    echo "  -u, --update        copy only when the SOURCE file is newer than the destination file or when the destination file is missing"
    echo "  -h, --help          display this help and exit"
    exit 1
}

progress_bar() {
    local duration=${1}
    local width=120 # Width of the progress bar
    local progress_char=" " # Solid block character for progress
    local background_char=" " # Empty block character for background
    local background_color="\e[48;5;34m" # Light gray background color
    local progress_color="\e[48;5;238m"    # Green progress color
    local progress=""
    local percent=0
    local i

    for ((i = 0; i < width; i++)); do
        progress+=" "
    done

    while [ ${percent} -lt 100 ]; do
        for ((i = 0; i < width; i++)); do
            percent=$(( (i * 100) / width ))
            if [ ${percent} -le 100 ]; then
                echo -ne "${background_color}${progress:0:i}${progress_color}${progress_char}${progress:((i+1)):width}${background_color} (${percent}%)\r"
            fi
            sleep ${duration}
        done
        if [ ${percent} -le 100 ]; then
            exit
        fi
    done

    echo -ne "\n" # Advance to the next line
}


# Check if no arguments are passed, or if the help option is passed
if [[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    usage
fi

# Parse options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -a|--archive|-f|--force|-i|--interactive|-p|-r|--recursive|-v|--verbose|-u|--update)
            OPTIONS+=("$1")
            shift
            ;;
        --)
            shift
            break
            ;;
        -*)
            echo "$0: invalid option '$1'"
            usage
            ;;
        *)
            break
            ;;
    esac
done

# Check if there are enough arguments
if [[ $# -lt 2 ]]; then
    echo "$0: missing file operand"
    usage
fi

# Source and destination files
SOURCE="$1"
DEST="$2"

# Check if source file exists
if [[ ! -f "$SOURCE" ]]; then
    echo "$0: '$SOURCE' does not exist"
    exit 1
fi

# Get source file size
SOURCE_SIZE=$(stat -c %s "$SOURCE")

# Copy file
cp "${OPTIONS[@]}" "$SOURCE" "$DEST" &

# Display progress bar
progress_bar 0.1

# Get destination file size
DEST_SIZE=$(stat -c %s "$DEST")

# Calculate percentage copied
PERCENTAGE=$((DEST_SIZE * 100 / SOURCE_SIZE))

# Display completion percentage
echo " Copy completed: ${PERCENTAGE}%"

exit 0
