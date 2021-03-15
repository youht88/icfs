echo "Wait for find supplier..."
cat /dev/null >supplier.txt
md5id=$(echo `icfs id -f "<id>"`|md5sum|cut -d " " -f 1)
icfs pubsub pub apply $md5id@
sleep 3
if [ ! -e supplier.txt ];then
   echo "supplier.txt must exist first!"
   exit;
fi
if [ -z "$1" ];then
  echo "Usage:./send.sh <file or dir> "
  exit;
elif [ ! -e "$1" ];then
  echo "file or directory $1 not exist!"
  exit;
fi
echo "Wait for add file/directory..."
CID=$(icfs add -Q -r "$1")
echo "We now can send data..."
icfs pubsub pub cid $CID@;
COPY=2
if [ x"$2" != x ];then
 COPY=$2
fi
user_num=`cat supplier.txt|sort|uniq|wc -l`
if [ $COPY -gt $user_num ];then
  echo "copy num($COPY) must less then user num(${user_num})!"
  exit
fi
if [ `icfs ls $CID|wc -l` -eq 0 ];then
  for i in `head -n $COPY supplier.txt`;
  do
     echo data_$i ${CID}
     icfs pubsub pub data_$i ${CID}@ &
  done;
  exit
fi
cat supplier.txt|sort|uniq|awk '{print $1}'|split -n r/$COPY -d -e -a 4 - USER
icfs refs -r -u $CID > ALL

for i in $(ls USER*);
do
  buck_num=`cat $i|wc -l`
  rm FS* >/dev/null 2>&1
  cat ALL|shuf|split -n r/$buck_num -d -e -a 4 - FS
  unset user_id;n=0;while read a;do user_id[$n]=$a;((n++));done<$i
  k=0
  for j in "${user_id[@]}";
  do
    ((k++))
    echo $i:$j:`ls FS*|sed -n ${k}p`
    unset fs_id;n=0;while read a;do fs_id[$n]=$a;((n++));done<`ls FS*|sed -n ${k}p`
    for l in "${fs_id[@]}";
    do
      echo data_$j ${l}	
      icfs pubsub pub data_$j ${l}@ &
    done;
  done;
done;    

rm ALL FS* USER*
