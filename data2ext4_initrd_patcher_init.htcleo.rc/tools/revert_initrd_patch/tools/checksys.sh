#!/sbin/sh

find=`grep -i "clk" /proc/cmdline`

if [ -n "$find" ]
then
  echo "clk=true" >> /tmp/nfo.prop
else
  echo "clk=null" >> /tmp/nfo.prop
fi
