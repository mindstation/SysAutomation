# cat /home/user/RRD_mon/UPS/update.sh

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
