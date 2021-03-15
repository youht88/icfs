a=`ps -ef |grep "icfs pubsub sub data"|grep -v grep|wc -l`
if [ $a -eq 0 ];then
  md5id=$(echo `icfs id -f "<id>"`|md5sum|cut -d " " -f 1) 
  icfs pubsub sub data_$md5id | xargs -d@ -I {} icfs pin add {};
else
   echo "receiver already running!";
fi

