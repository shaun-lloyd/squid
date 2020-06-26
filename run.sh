#!/usr/bin/env bash

# squid [-cdzCFNRVYX] [-n name] [-s | -l facility] [-f config-file] [-[au] port] [-k signal]

# 	-a port		Specify HTTP port number (default: 3128).
# 	-d level	Write debugging to stderr also.
# 	-f file		Use given config-file instead of
# 				/app/etc/squid.conf
# 	-k reconfigure|rotate|shutdown|restart|interrupt|kill|debug|check|parse
# 				Parse configuration file, then send signal to running copy (except -k parse) and exit.
# 	-n name 	Specify service name to use for service operations default is: squid.
# 	-s | -l facility
# 				Enable logging to syslog.
# 	-u port   	Specify ICP port number (default: 3130), disable with 0.
# 	-z        	Create missing swap directories and then exit.
# 	-C        	Do not catch fatal signals.
# 	-D        	OBSOLETE. Scheduled for removal.
# 	-F        	Dont serve any requests until store is rebuilt.
# 	-N        	Master process runs in foreground and is a worker. No kids.
# 	--foreground
# 				Master process runs in foreground and creates worker kids.
# 	--kid role-ID
# 				Play a given SMP kid process role, with a given ID. Do not use
# 				this option. It is meant for the master process use only.
# 	-R        	Do not set REUSEADDR on port.
# 	-S        	Double-check swap during rebuild.
# 	-X        	Force full debugging.
# 	-Y        	Only return UDP_HIT or UDP_MISS_NOFETCH during fast reload.

function squid_config_test() {
    squid -k parse
}

function squid_start() {
    squid -NYCd 1 "$@"
}

squid_config_test && squid_start
