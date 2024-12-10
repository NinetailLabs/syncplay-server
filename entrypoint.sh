#!/bin/sh

args=""

if [ -n $SALT ]; then
  args="$args --salt=$SALT"
fi

if [ -n "$PORT" ]; then
  args="$args --port=$PORT"
fi

if [ -n "$ISOLATE" ]; then
  args="$args --isolate-rooms"
fi

if [ -n "$MOTD" ]; then
  echo "$MOTD" > /app/syncplay/motd
  args="$args --motd-file=/app/syncplay/motd"
fi

if [ -n "$PASSWORD" ]; then
  args="$args --password=$PASSWORD"
fi

if [ -n "$TLS" ]; then
  args="$args --tls=$TLS"
fi


PYTHONUNBUFFERED=1 exec syncplay-server $args $@
