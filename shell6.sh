#!/bin/bash
function display1()
{
  echo "This is first function program"
  echo "This is second statement in function program"
  echo $(($1+$2))
  b=45
  echo $(($a+96))
}
display()
{
  echo "This is a function without function keyword"
  echo "This is the second statement of the display program"
  echo $(($1+$2))
}
a=96
echo $(($b+77))
display 45 56
display1 67 78