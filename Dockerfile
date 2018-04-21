# Smallest base image
FROM alpine:3.5

MAINTAINER Qiang

# Testing: pamtester
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add --update curl openvpn iptables bash easy-rsa openvpn-auth-pam google-authenticator pamtester && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

# Needed by scripts
ENV OPENVPN /etc/openvpn
ENV EASYRSA /usr/share/easy-rsa
ENV EASYRSA_PKI $OPENVPN/pki
ENV EASYRSA_VARS_FILE $OPENVPN/vars
ENV EASYRSA_BATCH true
ENV CLIENT_NAME ClientForQiang
ENV DEBUG 0
ENV DOMAIN xzmc-bme.eu.org

# Prevents refused client connection because of an expired CRL
ENV EASYRSA_CRL_DAYS 3650

VOLUME ["/etc/openvpn"]

# Internally uses port 3389/tcp, remap using `docker run -p 443:1194/tcp`
EXPOSE 3389/tcp

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["ovpn_run"]


