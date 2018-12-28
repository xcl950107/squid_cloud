#!/bin/bash
Exit()
{
    clear
    echo -e "$1"
    exit $2
}

#Delete squid files.
Dlete()
{
    /etc/init.d/squid stop &>/dev/null
    rm -rf /usr/local/squid /etc/init.d/squid squid $@
}

#Compile squid and install the compiled squid.
Compile()
{
    Delete
    [ -f squid_source.tar.gz ] || \
    curl -Ok https://raw.githubusercontent.com/mmmdbybyd/squid_cloud/master/squid_source.tar.gz || \
    Exit "\033[41;37mSquid source code download failed.\033[0m" 1
    tar -zxf squid_source.tar.gz
    rm -f squid_source.tar.gz
    chmod -R 777 squid_source
    cd squid_source
    sed -i "s/Meng/$proxy_hreader/" src/client_side.cc
    ./configure \
    --disable-eui \
    --disable-unlinkd \
    --disable-icap-client \
    --enable-gnuregex \
    --enable-underscore \
    --enable-async-io=240 \
    --enable-cache-digests \
    --enable-kill-parent-hack \
    --enable-large-cache-files \
    --enable-err-language="Simplify_Chinese" \
    --enable-default-err-languages="Simplify_Chinese" && \
    if ! make -j 2
    then
        Dlete ../squid_source
        Exit "\033[41;37mSquid compile failed.\033[0m" 1
    fi
    strip src/squid
    make install
    cp etc/init.d/squid /etc/init.d
    rm -rf ../squid_source
    echo "$conf_content" >/usr/local/squid/etc/squid.conf
    chmod -R 777 /usr/local/squid
    /usr/local/squid/sbin/squid -z &>/dev/null
    /etc/init.d/squid start|grep -q OK
}

#Set squid configuration file content.
Configure()
{
    clear
    while true
    do
        echo -n "Please input squid server port: "
        read server_port
        [ "$server_port" -gt "0" -a "$server_port" -lt "65536" ] && break
        echo "Please input 1-65535."
    done
    read -p "Please input proxy header(default is 'Meng'): " proxy_hreader
    conf_content="#My configuration.
    http_access allow all
    forwarded_for delete
    http_port 0.0.0.0:$server_port
    visible_hostname Mmmdbybyd
    cache_mem 64 MB
    maximum_object_size 1024 MB
    minimum_object_size 0 MB
    maximum_object_size_in_memory 32 MB
    cache_dir ufs /usr/local/squid/var/cache/squid 1024 128 512
    coredump_dir /usr/local/squid/var/cache/squid
    cache_swap_high 90
    cache_swap_low 30
    cache_mgr Mmmdbybyd
    acl dynamicPages urlpath_regex \.asp \.php \.jsp \.cgi
    acl noCache urlpath_regex ^(https|gopher)
    no_cache deny dynamicPages
    no_cache deny noCache
    refresh_pattern ^ftp: 1440 20% 10080
    refresh_pattern \.(je?pg|png|gif|mp[34]|xml|htm|css|js) 4320 50% 10080 ignore-reload
    refresh_pattern . 0 50% 4320"
}

#Change the working directory to script directory the parent directory.
Change_pwd()
{
    if [ -z "$(echo $0|grep /)" ]
    then
        if [ -f "$0" ]
        then
             script_dir="$PWD"
        else
            script_dir=`type "${0##*/}"`
            script_dir="${script_dir%/*}"
            script_dir="/${script_dir#*/}"
        fi
    else
        script_dir="${0%/*}"
        echo "$script_dir"|grep -Eq "\.\.?$" && script_dir=
        script_dir="${PWD}/${script_dir##*/}"
    fi
    cd "$script_dir"
}

Install()
{
    Configure
    apt-get -y update
    for package in curl tar lib\* perl build-essential gcc make automake autoconf openssl chkconfig
    do
        apt-get -y install $package
    done
    yum -y update
    for package in curl tar lib\* perl perl-devel gcc gcc-c++ make automake autoconf openssl openssl-devel chkconfig
    do
        yum -y install $package
    done
    Change_pwd
    Compile && \
    Exit "\033[44;37mSquid install success.\033[0;34m
    \r`/etc/init.d/squid status`
    \r`/etc/init.d/squid usage`
    \rsquid configuration file is /usr/local/squid/etc/squid.conf\033[0m"
    Dlete
    Exit "\033[41;37mSquid install failed.\033[0m"
}

Uninstall()
{
    clear
    echo -n "Uninstall squid?[y/n]: "
    read answer
    [ "$answer" == "N" -o "$answer" == "n" ] && Exit "Quit uninstall."
    echo "Uninstalling squid..."
    Dlete
    Exit "\033[44;37mSquid uninstall success.\n\033[0m"
}

echo $* | grep -qi uninstall && Uninstall
Install 2>/dev/null
