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

upsget=$(upsc ippon_main@localhost 2>/dev/null)

if [ -f "$RRD_BASE" ]
then
	#в выводе upsc выбираю строку с "input.voltage:", разбиваю ее на две части, до ":" и после, из второй части убираю все пробелы
	ups_invol=$(echo "$upsget" | grep "input.voltage:" | awk -F : '{print $2}' | sed 's/ //')
	ups_outvol=$(echo "$upsget" | grep "output.voltage:" | awk -F : '{print $2}' | sed 's/ //')
	ups_load=$(echo "$upsget" | grep "ups.load:" | awk -F : '{print $2}' | sed 's/ //')
	ups_temp=$(echo "$upsget" | grep "ups.temperature:" | awk -F : '{print $2}' | sed 's/ //')
	ups_batt_vol=$(echo "$upsget" | grep "battery.voltage:" | awk -F : '{print $2}' | sed 's/ //')
	ups_batt_chrg=$(echo "$upsget" | grep "battery.charge:" | awk -F : '{print $2}' | sed 's/ //')

	rrdtool update "$RRD_BASE" N:$ups_invol:$ups_outvol:$ups_load:$ups_temp:$ups_batt_vol:$ups_batt_chrg
else
	echo "File $RRD_BASE not found!"
	exit 1
fi

exit 0
