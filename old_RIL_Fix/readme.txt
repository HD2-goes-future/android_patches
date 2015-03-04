fix signal and invalid AppType on legacy gsm
http://review.evervolv.com/#/c/8552/   and http://review.evervolv.com/#/c/8551/



Tytung was the first which found this patches. And checked that only this 2 patches needed to fix gsm.

http://androidforum.tytung.com/nexushd2-jellybean-cm10-2-t78-360.html#p2764

post: 377

Patch this file

frameworks/telephony/src/java/com/android/internal/telephony/RIL.java

Check this commit:

https://github.com/walter79/omnirom_android_frameworks_opt_telephony/commit/1c4514af8744d105bd769addd400d174853b3102
