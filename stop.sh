ps -ef |grep "icfs pubsub sub"|grep -v grep|awk '{print $2}'|xargs kill
