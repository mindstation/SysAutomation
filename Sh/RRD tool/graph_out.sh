# cat /home/user/RRD_mon/UPS/graph.sh

#!/bin/sh

######################################################################################
#MIT License
#
#Copyright (c) 2018 Alexander Kirichenko
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.
######################################################################################

RRD_BASE="/home/user/RRD_mon/UPS/ippon_main.rrd"

DAYS="10m 30m 1h 12h 1d 7d 30d 1y"

DATE="`date '+%d-%m-%Y %H\:%M\:%S'`"



for day in $DAYS; do


	# end - это представление времени в AT-STYLE. В нем end это конец эпохи UNIX на локальной системе, как я понял.
	# Чем это отличается от now тогда? Непонятно.
	#DEF:vname=rrd:ds-name:CF
	rrdtool graph "/home/user/RRD_mon/UPS/graph/output_vol/UPS_outvol_${day}.png" \
 --start end-${day} \
 --title "ИБП Ippon Smart Power Pro 1400" \
 --width 640 --height 360 \
 --imgformat PNG \
 DEF:ups_invol=$RRD_BASE:ups1:AVERAGE:step=1 \
 DEF:ups_inmax=$RRD_BASE:ups1:MAX:step=1 \
 DEF:ups_inmin=$RRD_BASE:ups1:MIN:step=1 \
 TEXTALIGN:left \
 COMMENT:"                      " \
 COMMENT:"Максимальное" \
 COMMENT:"Минимальное" \
 COMMENT:"Среднее\l" \
 LINE2:ups_invol#3366FF:"Выходное напряжение\:" \
 GPRINT:ups_inmax:MAX:"%10.2lf" \
 GPRINT:ups_inmin:MIN:"%11.2lf" \
 GPRINT:ups_invol:AVERAGE:"%9.2lf\l" \
 AREA:ups_invol#6699FF \
 COMMENT:"\s" \
 HRULE:242#FF6666:"Абсолютный максимум напряжения\: 242 В" \
 HRULE:232.2#EEEE00:"10-минутный максимум напряжения \: 232,2 В" \
 COMMENT:"\s" \
 COMMENT:"\s" \
 COMMENT:"Последнее обновление\: $DATE\r" \
 > /dev/null 2>&1



done



exit 0
