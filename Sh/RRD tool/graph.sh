# cat /home/user/RRD_mon/UPS/graph.sh

#!/bin/sh



RRD_BASE="/home/user/RRD_mon/UPS/ippon_main.rrd"

DAYS="10m 30m 1h 12h 1d 7d 30d 1y"

DATE="`date '+%d-%m-%Y %H\:%M\:%S'`"



for day in $DAYS; do


	# end - это представление времени в AT-STYLE. В нем end это конец эпохи UNIX на локальной системе, как я понял.
	# Чем это отличается от now тогда? Непонятно.
	#DEF:vname=rrd:ds-name:CF
	rrdtool graph "/home/user/RRD_mon/UPS/graph/input_vol/UPS_invol_${day}.png" \
 --start end-${day} \
 --title "За прошедшие(ий) ${day}" \
 --width 1024 --height 600 \
 --imgformat PNG \
 DEF:ups_invol=$RRD_BASE:ups0:AVERAGE:step=1 \
 DEF:ups_inmax=$RRD_BASE:ups0:MAX:step=1 \
 DEF:ups_inmin=$RRD_BASE:ups0:MIN:step=1 \
 TEXTALIGN:left \
 COMMENT:"                      " \
 COMMENT:"Максимальное" \
 COMMENT:"Минимальное" \
 COMMENT:"Среднее\l" \
 LINE2:ups_invol#3366FF:"Входное напряжение\:" \
 GPRINT:ups_inmax:MAX:"%10.2lf" \
 GPRINT:ups_inmin:MIN:"%11.2lf" \
 GPRINT:ups_invol:AVERAGE:"%9.2lf\l" \
 AREA:ups_invol#6699FF \
 COMMENT:"\s" \
 HRULE:242#FF6666:"Допустимый максимум 220 В + 10% \: 242 В" \
 HRULE:231#EEEE00:"Превышение 220 В + 5% \: 231 В" \
 COMMENT:"\s" \
 COMMENT:"ИБП Ippon Smart Power Pro 1400\r" \
 COMMENT:"Последнее обновление\: $DATE\r" \
 > /dev/null 2>&1



done



exit 0
