# @Build
FROM ubuntu:20.04 as build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        devscripts build-essential fakeroot debhelper \
        dh-autoreconf dh-apparmor cdbs libcppunit-dev libsasl2-dev libxml2-dev libkrb5-dev \
        libdb-dev libnetfilter-conntrack-dev libexpat1-dev libcap2-dev libldap2-dev libpam0g-dev \
        libgnutls28-dev libssl-dev libdbi-perl libecap3 libecap3-dev libssl1.1 libcppunit-dev \
        autotools-dev libltdl-dev nettle-dev && \
    rm -rf /var/lib/apt/lists/*

#ADD http://www.squid-cache.org/Versions/v4/squid-4.12.tar.gz /usr/src
ADD ./src /usr/src/squid
WORKDIR /usr/src/squid

RUN ./bootstrap.sh && \
    ./configure \
        --prefix=/app \
        --enable-inline \
        --enable-async-io=8 \
        --enable-storeio="ufs,aufs,diskd,rock" \
        --enable-removal-policies="lru,heap" \
        --enable-delay-pools \
        --enable-cache-digests \
        --enable-follow-x-forwarded-for \
        --enable-auth-basic="DB,fake,getpwnam,PAM" \
        --enable-auth-digest="file" \
        --enable-auto-negotiate="kerberos,wrapper" \
        --enable-auth-ntlm="fake" \
        --enable-external-acl-helpers="file_userip,kerberos_ldap_group,LDAP_group,session,SQL_session,time_quota,unix_group,wbinfo_group" \
        --enable-url-rewrite-helpers="fake" \
        --enable-silent-rules \
        --enable-dependency-tracking \
        --enable-delay-pools \
        --enable-useragent-log \
        --enable-esi \
        --enable-auth \
        --enable-icap-client \
        --enable-eui \
        --enable-esi \
        --enable-icmp \
        --enable-zph-qos \
        --enable-ecap \
        --enable-ssl \
        --enable-ssl-crtd \
        --with-openssl \
        --disable-translation && \
    make -j $(nproc) && \
    make -j $(nproc) install

# @App
FROM ubuntu:20.04 as app

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openssl libssl1.1 libecap3 libxml2 libexpat1 libgssapi-krb5-2 libcap2 libnetfilter-conntrack3 libltdl7 && \
    rm -rf /var/lib/apt/lists/*

ENV KEY_PATH='/app/etc/ssl_cert'
ENV KEY_FILE='squid-ca'
ENV KEY_FQDN='www.lloydie.com.au'
ENV KEY_DAYS=100
ENV KEY_COUNTRY=AU
ENV KEY_STATE=Victoria
ENV KEY_LOCALITY=Melbourne
ENV KEY_ORG='example'

ENV PATH=/app/bin:/app/sbin:/app/libexec:/bin:/sbin:/usr/bin:/usr/sbin
COPY --from=build /app /app

COPY provision.sh /app/provision.sh
COPY run.sh /app/run.sh
RUN chmod 770 /app/provision.sh /app/run.sh
COPY cfg/squid.conf /app/etc/squid.conf

RUN /app/provision.sh

VOLUME ./log:/app/var/logs
VOLUME ./cache:/var/cache
VOLUME ./cert:/app/etc/ssl_cert

EXPOSE 3128
EXPOSE 3129
WORKDIR /app

ENTRYPOINT ["/app/run.sh"]

# FROM scratch as cert
# COPY --from=app /app/etc/ssl_cert/* .

# FROM ubuntu:20.04 as test

# COPY --from=app /app /app
# COPY test.sh /app/test.sh

# ENTRYPOINT ["/app/test.sh"]
