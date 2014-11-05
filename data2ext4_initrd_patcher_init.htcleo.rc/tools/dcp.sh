#!/sbin/sh

#1 Copy current /data to /sd-ext to avoid setting up from scratch
	busybox cp -a /data/* /sd-ext/

#2 Save a list with everything we copied
	ls /data > /tmp/tools/revert_initrd_patch/tools/dtrecord

#3 Unmount sd-ext
	busybox umount /sd-ext

#4 Create the revert_initrd_patch.zip
cd /tmp/tools/revert_initrd_patch
	/tmp/tools/zip -r revert_initrd_patch *

# Mount sdcard
	busybox mkdir /sdcard
	busybox mount -t auto /dev/block/mmcblk0p1 /sdcard
	
#6 Save it to the root of the sdcard
	cp /tmp/tools/revert_initrd_patch/revert_initrd_patch.zip /sdcard/revert_initrd_patch.zip
	
#7 Unmount sdcard
	busybox umount /sdcard
	
exit 0