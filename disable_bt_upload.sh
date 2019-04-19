#!/bin/sh

function req(){
arg="$*"
curl -s --unix-socket /tmp/synodl_transmission_socket_server.sock -A 'libtransmissionsomainsocket/1.0 (Synology)' -d $arg -x POST http:/localhost/domainsocket
}

# test if transmission is running (requires root)
[ -e /tmp/synodl_transmissiond.pid ] || exit
kill -0 `cat /tmp/synodl_transmissiond.pid` 2> /dev/null || exit

# check current upload limits
actual=$(req '{"method":"session-get","tag":0}' | sed 's/,/\n/g' | grep speed-limit)
if echo $actual | grep -q '"speed-limit-up":0 "speed-limit-up-enabled":true'; then
 echo all OK > /dev/null
else
 # adjust upload limit
 req '{"arguments":{"speed-limit-down-enabled":false,"speed-limit-up":0,"speed-limit-up-enabled":true},"method":"session-set"}' > /dev/null
 # check if worked
 after=$(req '{"method":"session-get","tag":0}' | sed 's/,/\n/g' | grep speed-limit)
 if echo $after | grep '"speed-limit-up":0 "speed-limit-up-enabled":true' >&2; then
    echo Transmissiond adjusted OK >&2;
 else # this also requires to be run as root
   echo "Transmission-BT could not adjust limit!!! killing transmissiond" >&2;
   kill `cat /tmp/synodl_transmissiond.pid`
 fi
fi
