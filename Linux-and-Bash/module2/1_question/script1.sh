echo "1 question"
echo "information to be sorted"
echo
ls -lb /var/log
echo " sorted info"
echo
ls -lb /var/log | awk '{if ($5 > 1000000) print $0}' 
