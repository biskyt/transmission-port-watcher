#!/bin/bash

transmission_url="http://${TRHOST:=localhost}:${TRPORT:=9091}/transmission"

update_port_forward() {
  echo "port.dat has been updated."
  maxloop=10
  sleeptime=15
  for i in $(seq 1 $maxloop); do
    PORT=$(cat "/portforward/${PORTFILENAME:=port.dat}" | sed 's/[[:space:]]//g')

    echo "Update port forward to: ${PORT} for ${transmission_url}"
    transmission-remote ${transmission_url} -n ${TRUSER}:${TRPASSWORD} -p ${PORT}

    if [ $? -eq 0 ]; then
      echo "Transmission-remote command was successful."
      echo "OK" > /result.txt
      break
    else
      echo "Transmission-remote command failed. Attempt $i of $maxloop Retrying in $sleeptime seconds..."
      echo "FAIL" > /result.txt
      if [ "$i" -eq $maxloop ]; then 
        echo "FAILED TOO MANY TIMES"
        echo "Waiting 1 minute, then terminatating container."
        echo "use restart-policy to restart.."
        sleep 60
        exit 1
      fi
      sleep 15
    fi
  done
}

## Actual script starts here

# Update port on first run
echo "Starting Up" > /result.txt
sleep 5 # give transmission time to start
echo "Starting up..."
update_port_forward

# Watch for changes to port.dat
inotifywait -q -m -e close_write /portforward/port.dat |
  while read -r filename event; do
    update_port_forward
  done
