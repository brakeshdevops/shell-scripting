#!/usr/bin/env bash
a=100
echo $a
echo ${a} USD
echo "Todays date is $(date +%F)"
a=(10 20 30 40 50)
sum=${a[0]}+${a[1]}
echo "${a[0]}"
echo ${sum}