#!/bin/bash

CONF_FILE="/etc/nginx/conf.d/upstream.conf"
IFS=','

# Write generation info
printf "# Generated by 90-update-upstreams.sh\n" >$CONF_FILE

# Write upstream group
read -a upstream_servers <<<"$UPSTREAMS"
printf "upstream upstream_servers {\n" >>$CONF_FILE
printf "  zone upstream_servers 256k;\n" >>$CONF_FILE
for ((i = 0; i < ${#upstream_servers[*]}; i++)); do
  printf "  server ${upstream_servers[i]};\n" >>$CONF_FILE
done
printf "}\n" >>$CONF_FILE