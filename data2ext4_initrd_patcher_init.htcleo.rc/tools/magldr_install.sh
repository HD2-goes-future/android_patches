#!/sbin/sh

#1 Get ext type if any
	mmcblk0p2=`ls /dev/block/mmcblk0p2`
	if [ $mmcblk0p2 == "/dev/block/mmcblk0p2" ]
	then
		busybox mkdir /sd-ext
		busybox mount -t auto /dev/block/mmcblk0p2 /sd-ext
		ext_type=`busybox mount | busybox grep "ext" | busybox cut -d ' ' -f 5`
	else
		exit 1
	fi
# 

#2 Copy initrd.gz from /boot
	mkdir /tmp/tools/boot.img-ramdisk
	cp /boot/initrd.gz /tmp/tools/boot.img-ramdisk/boot.img-ramdisk.gz
	
#3 Extract boot.img-ramdisk
cd /tmp/tools/boot.img-ramdisk
	gzip -d -c boot.img-ramdisk.gz | cpio -i -d
	rm -f boot.img-ramdisk.gz
	
#4 Replace line with /data mounting in init.rc
	sed -i '
		/mtd@userdata/ {
		i\
		chmod 0750 /sbin/extprep
		i\
		exec /sbin/extprep
		c\
		mount '${ext_type}' /dev/block/mmcblk0p2 /data wait nosuid nodev noatime nodiratime
		}
	' init.rc
	
#5 Copy extprep to sbin
	cp /tmp/tools/extprep /tmp/tools/boot.img-ramdisk/sbin/extprep
	chmod 0750 /tmp/tools/boot.img-ramdisk/sbin/extprep

#6 Rebuild initrd.gz
	find . | cpio -o -H newc | gzip -9 > /tmp/tools/boot.img-ramdisk.gz
	
#7 Replace old one
	cp /tmp/tools/boot.img-ramdisk.gz /boot/initrd.gz
	chmod 0777 /boot/initrd.gz
	
#8 Clean up
	rm -fr /tmp/tools/boot.img*

exit 0
