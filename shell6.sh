#!/bin/bash
function display1()
{
  echo "This is first function program"
  echo "This is second statement in function program"
  x={1}+{2}
  echo {x}
}
display()
{
  echo "This is a function without function keyword"
  echo "This is the second statement of the display program"
  y={1}+{2}
  echo {y}
}
display 45 56
display1 67 78