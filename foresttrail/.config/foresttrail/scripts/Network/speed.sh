#!/bin/bash

INTERFACE="wlp0s20f3"
OUTFILE="/tmp/waybar_net_speed"

trap "rm -f $OUTFILE; exit" INT TERM

> "$OUTFILE"

while true; do
    RX1=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
    TX1=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
    sleep 1
    RX2=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
    TX2=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)

    RX_RATE=$((RX2 - RX1))
    TX_RATE=$((TX2 - TX1))
    RX_MB=$(echo "scale=2; $RX_RATE / 1048576" | bc)
    TX_MB=$(echo "scale=2; $TX_RATE / 1048576" | bc)

    echo "↓${RX_MB} MB/s,↑${TX_MB} MB/s" > "$OUTFILE"
done


