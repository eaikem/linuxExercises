#!/bin/bash

if [[ $# -lt 1 || $# -gt 2 || ! $1 =~ ^[1-9][0-9]*$ ]]; then
    echo "usage: $0 <column> [file.csv]" >&2
    exit 1
fi

column=$1
file=${2:-/dev/stdin}

if [[ ! -r "$file" ]]; then
    echo "$0: cannot read $file" >&2
    exit 1
fi

set -o pipefail

cut -d ',' -f "$column" "$file" |
    tail -n +2 |
    {
        sum=0
        count=0

        while IFS= read -r value || [[ -n "$value" ]]; do
            value=${value%$'\r'}
            sum=$(awk -v a="$sum" -v b="$value" \
                'BEGIN { printf "%.15g", a + b }')
            count=$((count + 1))
        done

        if [[ $count -eq 0 ]]; then
            echo "$0: no data rows" >&2
            exit 1
        fi

        awk -v sum="$sum" -v count="$count" \
            'BEGIN { print sum / count }'
    }
