#!/bin/bash

if [[ ! -e /etc/squid/squid.conf ]]; then
  echo "Genrating squid.conf..."
  # replace reference to customize.sh with versioned mount
  /etc/squid/customize.sh < /etc/squid/squid.conf.frontierdefault > /etc/squid/squid.conf
fi

chown -R squid:squid /var/cache/squid

if [[ -z ${1} ]]; then
  if [[ ! -d /var/cache/squid/00 ]]; then
    echo "Initializing cache..."
    /usr/sbin/squid -N -f /etc/squid/squid.conf -z
  fi
  echo "Starting squid..."
  # This should be fine to leave, since it is what's generated after the customize script runs
  exec /usr/sbin/squid -f /etc/squid/squid.conf -NYCd 1
else
  exec "$@"
fi
