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

function stage
{
    for file in "$@"
    do
        if [ ! -e "$file" ];then
            displayError "$file does not exist"
            exit 3
        fi

        file_path=$(readlink -f "$file")
        echo "$file_path" >> "$STAGE_FILE"
    done
}

function cp_stage
{
    destination="$1"
    if [ ! -d "$destination" ]; then
        displayError "$destination is not a directory"
        exit 4
    fi

    if [ -f "$STAGE_FILE" ]; then
        while read file; do
            cp -rfv "$file" "$destination"
        done < "$STAGE_FILE"
    else
        displayWarning "The stage is empty"
        exit 2
    fi
}

function mv_stage
{
    destination="$1"
    if [ ! -d "$destination" ]; then
        displayError "$destination is not a directory"
        exit 4
    fi

    if [ -f "$STAGE_FILE" ]; then
        while read file; do
            mv -fv "$file" "$destination"
        done < "$STAGE_FILE"
    else
        displayWarning "The stage is empty"
        exit 2
    fi
}



if [ "$#" -eq 0 ]; then
    print_stage

elif [ "$#" -eq 1 ]; then
    case $1 in
        clear|cl)
            clear_stage
            ;;
        list|ls)
            print_stage
            ;;
        *)
            stage $@
            ;;
    esac

elif [ "$#" -eq 2 ]; then
    case $1 in
        cp)
            cp_stage $2
            ;;
        mv)
            mv_stage $2
            ;;
        *)
            stage $@
            ;;
    esac

else
    stage $@
fi
