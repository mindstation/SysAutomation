#!/bin/bash
#auto xl2tpd beeline redial
iface=$(/sbin/ifconfig ppp0)
if [[ "$iface" = ""  ]]
then
sleep 60s
echo "c beelinel2tp" > /var/run/xl2tpd/l2tp-control
fi

exit 0
