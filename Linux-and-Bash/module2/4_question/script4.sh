echo "4 question"
echo "___________________________"
echo "the sorted information of the processes"
ps aux --sort=-%mem

echo "highest memory process"

ps aux --sort=-%mem | sed -n '2p'

kill $(ps aux | awk 'NR>1{if($4>max){max=$4;pid=$2;mem=$4}}END{print pid}') 

echo "killed the  process" 



