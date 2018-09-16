# cat /home/user/RRD_mon/UPS/graph.sh

#!/bin/sh



RRD_BASE="/home/user/RRD_mon/UPS/ippon_main.rrd"

# ups0 - напряжение на входе (В)
# ups1 - напряжение на выходе (В)
# ups2 - нагрузка на ИБП (%)
# ups3 - температура ИБП (С)
# ups4 - напряжение на батареях (В)
# ups5 - процент заряда батарей (%)

# Статистика хранится за год

# А так же хранится среднее за 15,30,60 минут



rrdtool create $RRD_BASE --step 60 \
 DS:ups0:GAUGE:120:0:380 \
 DS:ups1:GAUGE:120:0:380 \
 DS:ups2:GAUGE:120:0:100 \
 DS:ups3:GAUGE:120:0:240 \
 DS:ups4:GAUGE:120:0:30 \
 DS:ups5:GAUGE:120:0:100 \
 RRA:AVERAGE:0.5:1:525600 \
 RRA:AVERAGE:0.5:15:35040 \
 RRA:AVERAGE:0.5:30:17520 \
 RRA:AVERAGE:0.5:60:8760 \
 RRA:MIN:0.5:1:525600 \
 RRA:MIN:0.5:15:35040 \
 RRA:MIN:0.5:30:17520 \
 RRA:MIN:0.5:60:8760 \
 RRA:MAX:0.5:1:525600 \
 RRA:MAX:0.5:15:35040 \
 RRA:MAX:0.5:30:17520 \
 RRA:MAX:0.5:60:8760

#RRA:CF:xff:steps:rows

exit 0
