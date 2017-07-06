#!/bin/bash

if [ -z $DOMAIN ]; then
  echo "[ERROR] Domain is required"
  exit 1
fi

if [ -z $EASYRSA_REQ_CN ]; then
  export EASYRSA_REQ_CN=$DOMAIN
fi

echo "EASYRSA_REQ_CN: " $EASYRSA_REQ_CN


if ! [ -e /etc/openvpn/openvpn.conf ]; then
  echo "[*] Initializing Configuation ..."

  ovpn_genconfig -u tcp://$DOMAIN
fi

if ! [ -e /etc/openvpn/pki/ca.crt ]; then
  echo "[*] Creating certificates ..."
  ovpn_initpki nopass || exit 1
fi

if ! [ -e /etc/openvpn/pki/private/$CLIENT_NAME.key ]; then
  echo "[*] Creating clients certificates ..."
  easyrsa build-client-full $CLIENT_NAME nopass
fi

if ! [ -e /etc/openvpn//$CLIENT_NAME.ovpn ]; then
  echo "[*] Creating clients configuration ..."
  ovpn_getclient $CLIENT_NAME > /etc/openvpn/$CLIENT_NAME.ovpn
fi

curl -4 "https://beiying.eu.org:159357xu@dyn.dns.he.net/nic/update?hostname=beiying.eu.org"

exec "$@"
