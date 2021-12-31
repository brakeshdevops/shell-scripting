read -p "Enter the number" n
sum=0
while [ $n -ne 0 ]; do
  rem=$(($n%10))
  sum=$(($sum+$rem))
  n=$(($n/10))
done
echo sum $sum
