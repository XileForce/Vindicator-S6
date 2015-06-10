#!/system/bin/sh

# interactive governor
chown -R system:system /sys/devices/system/cpu/cpu0/cpufreq/interactive
chmod -R 0666 /sys/devices/system/cpu/cpu0/cpufreq/interactive
chmod 0755 /sys/devices/system/cpu/cpu0/cpufreq/interactive
chown -R system:system /sys/devices/system/cpu/cpu1/cpufreq/interactive
chmod -R 0666 /sys/devices/system/cpu/cpu1/cpufreq/interactive
chmod 0755 /sys/devices/system/cpu/cpu1/cpufreq/interactive
chown -R system:system /sys/devices/system/cpu/cpu2/cpufreq/interactive
chmod -R 0666 /sys/devices/system/cpu/cpu2/cpufreq/interactive
chmod 0755 /sys/devices/system/cpu/cpu2/cpufreq/interactive
chown -R system:system /sys/devices/system/cpu/cpu3/cpufreq/interactive
chmod -R 0666 /sys/devices/system/cpu/cpu3/cpufreq/interactive
chmod 0755 /sys/devices/system/cpu/cpu3/cpufreq/interactive
chown -R system:system /sys/devices/system/cpu/cpu4/cpufreq/interactive
chmod -R 0666 /sys/devices/system/cpu/cpu4/cpufreq/interactive
chmod 0755 /sys/devices/system/cpu/cpu4/cpufreq/interactive
chown -R system:system /sys/devices/system/cpu/cpu5/cpufreq/interactive
chmod -R 0666 /sys/devices/system/cpu/cpu5/cpufreq/interactive
chmod 0755 /sys/devices/system/cpu/cpu5/cpufreq/interactive
chown -R system:system /sys/devices/system/cpu/cpu6/cpufreq/interactive
chmod -R 0666 /sys/devices/system/cpu/cpu6/cpufreq/interactive
chmod 0755 /sys/devices/system/cpu/cpu6/cpufreq/interactive
chown -R system:system /sys/devices/system/cpu/cpu7/cpufreq/interactive
chmod -R 0666 /sys/devices/system/cpu/cpu7/cpufreq/interactive
chmod 0755 /sys/devices/system/cpu/cpu7/cpufreq/interactive

#Setup Mhz Min/Max Cluster 0
echo 400000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq;
echo 1500000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq;
echo 400000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq;
echo 1500000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq;
echo 400000 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq;
echo 1500000 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq;
echo 400000 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq;
echo 1500000 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq;

#Setup Mhz Min/Max Cluster 1
echo 800000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq;
echo 2100000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq;
echo 800000 > /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq;
echo 2100000 > /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq;
echo 800000 > /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq;
echo 2100000 > /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq;
echo 800000 > /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq;
echo 2100000 > /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq;

#e/frandom permissions
chmod 444 /dev/erandom
chmod 444 /dev/frandom

#Free Up More Ram For Apps
echo 200 > /proc/sys/vm/vfs_cache_pressure

#Fix GPS Wake Issues. From LSpeed Mod 
mount -o remount,rw /
mount -o remount,rw rootfs
mount -o remount,rw /system
busybox mount -o remount,rw /
busybox mount -o remount,rw rootfs
busybox mount -o remount,rw /system

busybox sleep 40
su -c "pm enable com.google.android.gms/.update.SystemUpdateActivity"
su -c "pm enable com.google.android.gms/.update.SystemUpdateService"
su -c "pm enable com.google.android.gms/.update.SystemUpdateService$ActiveReceiver"
su -c "pm enable com.google.android.gms/.update.SystemUpdateService$Receiver"
su -c "pm enable com.google.android.gms/.update.SystemUpdateService$SecretCodeReceiver"
su -c "pm enable com.google.android.gsf/.update.SystemUpdateActivity"
su -c "pm enable com.google.android.gsf/.update.SystemUpdatePanoActivity"
su -c "pm enable com.google.android.gsf/.update.SystemUpdateService"
su -c "pm enable com.google.android.gsf/.update.SystemUpdateService$Receiver"
su -c "pm enable com.google.android.gsf/.update.SystemUpdateService$SecretCodeReceiver"

#Setup vindicator file location if it doesn't exist already
[ ! -d "/data/data/vindicator" ] && mkdir /data/data/vindicator
chmod 755 /data/data/vindicator

# init.d support
/system/xbin/busybox run-parts /system/etc/init.d

# Apollo Minfreq
CFILE="/data/data/vindicator/APminfreq"
if [ -f $CFILE ]; then 
	FREQ=`cat $CFILE`
	echo $FREQ > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	echo $FREQ > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
	echo $FREQ > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
	echo $FREQ > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
fi

# Apollo Maxfreq
CFILE="/data/data/vindicator/APmaxfreq"
if [ -f $CFILE ]; then 
	FREQ=`cat $CFILE`
	echo $FREQ > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
	echo $FREQ > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
	echo $FREQ > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
	echo $FREQ > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
fi	
# Atlas Minfreq
CFILE="/data/data/vindicator/ATminfreq"
if [ -f $CFILE ]; then 
	FREQ=`cat $CFILE`
	echo $FREQ > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
	echo $FREQ > /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq
	echo $FREQ > /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq
	echo $FREQ > /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq
fi

# Atlas Maxfreq
CFILE="/data/data/vindicator/ATmaxfreq"
if [ -f $CFILE ]; then 
	FREQ=`cat $CFILE`
	echo $FREQ > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
	echo $FREQ > /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq
	echo $FREQ > /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq
	echo $FREQ > /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq
fi
	
#PEWQ's
CFILE="/data/data/vindicator/PEWQ"
SFILE="/sys/module/workqueue/parameters/power_efficient"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

#FSync
CFILE="/data/data/vindicator/FSync"
SFILE="/sys/module/sync/parameters/fsync_enabled"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE

#Task Packing
CFILE="/data/data/vindicator/packing"
SFILE="/sys/kernel/hmp/packing_enable"
[ -f $CFILE ] && echo `cat $CFILE` > $SFILE
