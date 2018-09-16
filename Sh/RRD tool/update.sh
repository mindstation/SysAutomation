# cat /home/user/RRD_mon/UPS/update.sh

#!/bin/sh



RRD_BASE="/home/user/RRD_mon/UPS/ippon_main.rrd"


#upsget=`upsc ippon_main@localhost`

ups_invol=`upsc ippon_main@localhost input.voltage 2>/dev/null`

ups_outvol=`upsc ippon_main@localhost output.voltage 2>/dev/null`

ups_load=`upsc ippon_main@localhost ups.load 2>/dev/null`

ups_temp=`upsc ippon_main@localhost ups.temperature 2>/dev/null`

ups_batt_vol=`upsc ippon_main@localhost battery.voltage 2>/dev/null`

ups_batt_chrg=`upsc ippon_main@localhost battery.charge 2>/dev/null`

rrdtool update $RRD_BASE N:$ups_invol:$ups_outvol:$ups_load:$ups_temp:$ups_batt_vol:$ups_batt_chrg

# Подавляю сообщения о работе и ошибках программ вызываемых в скрипте
1>/dev/null 2>&1

exit 0
