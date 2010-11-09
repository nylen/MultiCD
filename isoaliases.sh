#!/bin/sh
isoaliases () {
true > $TAGS/linklist
for i in $MCDDIR/plugins/*;do
	TOPRINT=$($i links)
	if [ $? = 0 ];then
		echo $TOPRINT >> $TAGS/linklist
	fi
done
cat $TAGS/linklist|while read i;do
	IM1=$(echo $i|awk '{print $1}')
	IM2=$(echo $i|awk '{print $2}')
	if [ -e $IM1 ] && [ ! -e $IM2 ];then
		if ln -s $IM1 $IM2;then
			ISOBASENAME=$(echo $IM2|sed -e 's/\.iso//g')
			touch $TAGS/madelinks #This is to make multicd.sh pause for 1 second so the notifications are readable
			if [ -n "$(echo $i|awk '{print $3}')" ];then
				echo $i|awk '{print $3}'|sed -e 's/^/ /g'>$ISOBASENAME.defaultname #The third field of the row will be the default name when multicd.sh asks the user to enter a name. This should also be used by the plugin script if $TAGS/whatever.name is not present
			fi
			CUTOUT1=$(echo "$i"|awk 'BEGIN {FS = "*"} ; {print $1}') #The parts of the ISO name before the asterisk
			CUTOUT2=$(echo "$i"|awk '{print $1}'|awk 'BEGIN {FS = "*"} ; {print $2}') #The parts after the asterisk
			VERSION=$(echo "$IM1"|awk '{sub(/'"$CUTOUT1"'/,"");sub(/'"$CUTOUT2"'/,"");print}') #Cuts out whatever the asterisk represents (which will be the version number)
			if [ "$VERSION" != "*" ] && [ "$VERSION" != "$IM1" ];then
				echo $VERSION > $ISOBASENAME.version
				#The SystemRescueCD plugin does not use this, but I figure it won't do any harm to have an extra file sitting there.
				echo "Made a link named $IM2 pointing to $IM1 (version $VERSION)"
			else	
				echo "Made a link named $IM2 pointing to $IM1"
			fi
		fi
	fi
done
if [ -f $TAGS/madelinks ];then
	rm $TAGS/madelinks
	sleep 1
fi
}
