#!/bin/bash

cat Property_Tax_Roll.csv |
grep "MADISON SCHOOLS" |
cut -d ',' -f 7 |
{
    awk '{
        sum += $1
        count++
    }
    END {
        print "Sum:", sum
        if (count > 0)
            print "Average:", sum/count
    }'
}