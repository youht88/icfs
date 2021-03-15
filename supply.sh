a=`ps -ef |grep "icfs pubsub sub apply"|grep -v grep|wc -l`
if [ $a -eq 0 ];then
  md5id=$(echo `icfs id -f "<id>"`|md5sum|cut -d " " -f 1)
  icfs pubsub sub apply |xargs -d @ -I {} bash -c "
  case {} in  
    "hello") 
        icfs pubsub pub supply_hello ${md5id}@ 
	;;
    *)
        icfs pubsub pub supply_{} ${md5id}@
	;;
  esac"
else
  echo "sub apply already running!"
fi
