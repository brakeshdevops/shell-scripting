#!/bin/bash
read -p "Enter the first no" a
read -p "Enter the second no" b
if [ ${a} -gt ${b} ]; then
  echo "A is the greatest no"
fi
