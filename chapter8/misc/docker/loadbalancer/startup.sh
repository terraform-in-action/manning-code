#!/bin/bash
servers=""
for address in ${ADDRESSES[@]}
do
    servers="$servers"$'\\n'"server $address;"
done
sed -i "s/\${SERVERS}/${servers}/" /etc/nginx/nginx.conf
service nginx restart
sleep infinity