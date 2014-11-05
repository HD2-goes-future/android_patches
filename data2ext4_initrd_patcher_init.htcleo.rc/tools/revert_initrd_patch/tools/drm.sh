#!/sbin/sh

#1 Delete according to the list of files&folders
#  copied from data to sd-ext before the patch
cd /sd-ext
	items=`sed 's/\n/ /g' /tmp/tools/dtrecord`
	for filenane in $items
	do
		rm -fr "$filenane"
	done;
	
#2 Unmount sd-ext
	busybox umount /sd-ext
	
#3 Unmount sdcard
	busybox umount /sdcard
	
exit 0