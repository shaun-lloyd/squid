# Squid with explicit ssl/tls termination

## What is Squid?

[Squid](http://www.squid-cache.org/) is a proxy for the Web supporting HTTP, HTTPS, FTP, and more.It reduces bandwidth and improves response times by caching and reusing frequently-requested web pages. Squid has extensive access controls and makes a great server accelerator.

## Quick Start

## Configuration

# Environment
CERT_FILE   File name
CERT_ORG    Organisation
CERT_FQDN   Fully Qualified Domain Name
CERT_DAYS   Exiration Days
CERT_C      Country

# File
etc/squid.conf
etc/openssl.cnf

## Legal Warning

SSLBump is an SSL/HTTPS interception feature of squid.
HTTPS interception has ethical and legal issues which you need to be aware of which are follows;

* Some countries do not limit what can be done within the home environment,
* Some countries permit employment or contract law to overrule privacy,
* Some countries require government registration for all decryption services,
* Some countries it is an outright capital offense with severe penalties
* DO SEEK legal advice before using SSLBump feature, even at home.


[squid configuration](http://www.squid-cache.org/Versions/v4/cfgman/).


## SSLBump Root Certificate

The volume ssl_cert contains the certificate, if one is not provided it will be generated. Clients require CA.der.
