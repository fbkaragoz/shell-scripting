LOG_DIR=/var/log
ROOT_UID=0
LINES=50	#lines saved
E_XCD=66	#cant change dir
E_NOTROOT=67

if [ "$UID -ne "$ROOT_UID" ]
then
	echo "Must be root to run this script"
	exit $E_NOTROOT
fi

if [ -n "$1" ]
then
	lines=$1
else
	lines=$LIENS
fi

cd $LOG_DIR

if [ 'pwd' !="$LOG_DIR" ]
then
	echo "cant change to $LOG_DIR"
	exit $E_XCD
fi


tail -$lines messages > mesg.temp
mv mesg.temp messages

cat /dev/null > wtmp
echo "logs are cleaned up"


exit 0

