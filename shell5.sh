#!/bin/bash
read -p "Enter the first no" a
read -p "Enter the second no" b
read -p "Enter the third no" c
if [ -z "$a" ]; then
  echo "A is empty"
  exit
fi
if [ ${a} -gt ${b} ]; then
  echo "A is the greatest no"
elif [ ${b} -gt ${c} ]; then
  echo "B is greatest no"
else
  echo "C is greatest no"
fi
