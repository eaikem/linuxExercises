#!/bin/bash

usage() {
    echo "Usage: $0 <dir> <n>" >&2
}

if [[ $# -ne 2 ]]; then
    usage
    exit 1
fi

directory="$1"
n="$2"

if [[ ! -d "$directory" ]]; then
    echo "Error: '$directory' is not a directory." >&2
    exit 1
fi

if [[ ! "$n" =~ ^[0-9]+$ ]]; then
    echo "Error: n must be a nonnegative integer." >&2
    exit 1
fi

find "$directory" -type f -size +"${n}c" -print -delete
