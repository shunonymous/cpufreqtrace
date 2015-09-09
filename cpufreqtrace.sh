# CPU Freq Trace
# Author:Shun Terabayashi <shunonymous@gmail.com>
# License:Apache v2.0
#!/bin/sh

if [ ! -e $HOME/log ]
then
    mkdir $HOME/log
fi

INTERVAL=1

LOGDIR=$HOME/log
LOGFILE=$LOGDIR/cpufreq.log
       
if [ -e $LOGFILE ]
then
    COUNT=1
    while [ -e $LOGDIR/cpufreq.$COUNT.log ]
    do
	  COUNT=`expr $COUNT + 1`
    done	  
    OLDFILE=$LOGDIR/cpufreq.$COUNT.log
    mv $LOGFILE $OLDFILE
fi

uname -a >> $LOGFILE
date >> $LOGFILE

CPULIST=""
CPU=0

while [ -e /sys/devices/system/cpu/cpu${CPU} ]
do
    CPULIST="$CPULIST${CPU} "
    CPU=`expr ${CPU} + 1`
done

LINE="time"

for i in $CPULIST
do
    LINE="${LINE},cpu${i}"
done
	 
echo "${LINE}" >> $LOGFILE

LINE=""

while true
do
    LINE="`date +%H:%M:%S`"
    for i in $CPULIST
    do
	if [ -e /sys/devices/system/cpu/cpu${i}/cpufreq/scaling_cur_freq ]
	then
	   LINE="${LINE},`cat /sys/devices/system/cpu/cpu${i}/cpufreq/scaling_cur_freq`"
	else
	    LINE="${LINE},0"
	fi
    done
    echo $LINE >> $LOGFILE
    sleep $INTERVAL
done
