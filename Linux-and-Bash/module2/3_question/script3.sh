echo  " 3 question "
echo "___________________________"
echo
cat log.txt 
echo
echo "updated "
echo 
awk '/ERROR/ {print $0}' log.txt | sed '/DEBUG/d' > filtered_log.txt
cat filtered_log.txt

