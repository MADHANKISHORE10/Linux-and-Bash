echo " 2 question"
echo "the info of localhosts to be changed"
echo
cat /etc/hosts
cat /etc/hosts > config.txt
cat config.txt | sed 's/localhost/127.0.0.1/g' > updated_config.txt
echo
echo "updated successfully"
echo "___________________________"
cat updated_config.txt

