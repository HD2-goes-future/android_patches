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
	
#2 Dump boot image
	/tmp/tools/dump_image boot /tmp/tools/boot.img
	
#3 Unpack boot.img => boot.img-zImage, boot.img-ramdisk.gz, etc.
	/tmp/tools/unpackbootimg /tmp/tools/boot.img /tmp/tools
	mkdir /tmp/tools/boot.img-ramdisk
	cp /tmp/tools/boot.img-ramdisk.gz /tmp/tools/boot.img-ramdisk/boot.img-ramdisk.gz

#4 Extract boot.img-ramdisk.gz
cd /tmp/tools/boot.img-ramdisk
	gzip -d -c boot.img-ramdisk.gz | cpio -i -d
	rm -f boot.img-ramdisk.gz
	
#5 Restore line with /data mounting in init.rc
	sed -i '
		/chmod 0750 \/sbin\/extprep/ {
		N
		d
		}
		/\/dev\/block\/mmcblk0p2 \/data/ {
		c\
		mount yaffs2 mtd@userdata /data nosuid nodev noatime nodiratime
		}
	' init.rc
	
#6 Delete extprep from sbin
	rm -f /tmp/tools/boot.img-ramdisk/sbin/extprep
	
#7 Rebuild initrd.gz
	find . | cpio -o -H newc | gzip -9 > /tmp/tools/boot.img-ramdisk.gz
	
#8 Set perm
	chmod 0777 /tmp/tools/boot.img-ramdisk.gz
	chmod 0777 /tmp/tools/boot.img-zImage

#9 Recompile boot.img
	/tmp/tools/mkbootimg 	--kernel /tmp/tools/boot.img-zImage \
							--ramdisk /tmp/tools/boot.img-ramdisk.gz \
							--cmdline "`cat /tmp/tools/boot.img-cmdline`" \
							--base 0x11800000 \
							--output /tmp/tools/boot.img

#10 Flash boot.img
	/tmp/tools/flash_image boot /tmp/tools/boot.img

#11 Clean up
	rm -fr /tmp/tools/boot.img*
	
exit 0
