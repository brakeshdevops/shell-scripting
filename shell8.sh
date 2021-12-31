read -p "Enter the number" n
sum=0
while [ $n -ne 0 ]; do
  sum=$( $sum+$n )
  n=$( $n-1 )
done
echo sum $sum
