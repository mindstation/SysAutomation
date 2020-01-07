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

RRD_BASE="$(dirname $0)/ippon_main.rrd"

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
