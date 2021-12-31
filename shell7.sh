read -p "Enter the option" v1
case $v1 in
  hello)
    echo "You have entered hello"
    ;;
  welocme)
    echo "you have entered welcome"
    ;;
  *)
    echo "You have entered the keyword not in the keywords"
    ;;
esac
