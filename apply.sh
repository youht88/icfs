a=`ps -ef |grep "icfs pubsub sub supply"|grep -v grep|wc -l`
md5id=`echo $(icfs id -f "<id>")|md5sum|cut -d " " -f 1`
if [ $a -eq 0 ];then
  icfs pubsub sub supply_$md5id|xargs -d@ -I {} bash -c "echo {}|grep -v $md5id>>supplier.txt"
else
  echo "sub supply already running!"
fi
