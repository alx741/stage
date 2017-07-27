#!/bin/sh

source "$(dirname "$0")/fancy.sh"

STAGE_DIR="/tmp"
STAGE_FILE="$STAGE_DIR/staged_files"

function print_stage
{
    if [ -f "$STAGE_FILE" ]; then
        cat "$STAGE_FILE"
    else
        displayWarning "The stage is empty"
        exit 2
    fi
}

function clear_stage
{
    rm -f "$STAGE_FILE"
}


if [ "$#" -eq 0 ]; then
    print_stage
fi

case $1 in
    clear|cl)
        clear_stage
        ;;
    list|ls)
        print_stage
        ;;
esac

shift
for arg in "$@"
do
    echo "$arg"
done
