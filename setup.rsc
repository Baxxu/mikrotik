/interface wifi set [ find default-name=wifi2 ] channel.band=2ghz-ax .reselect-interval=1h..2h .width=20mhz configuration.tx-power=1 security.authentication-types=wpa3-psk .wps=disable;

/interface wifi set [ find default-name=wifi1 ] channel.band=5ghz-ax .reselect-interval=1h..2h .width=20/40/80mhz configuration.tx-power=1 security.authentication-types=wpa3-psk .wps=disable;

/ip service disable api,api-ssl,ftp,ssh,telnet,www,www-ssl;

/ip dns set servers=8.8.8.8,8.8.4.4,1.1.1.1,1.0.0.1;

/system ntp client set enabled=yes mode=unicast servers=time.google.com,time.cloudflare.com,0.ru.pool.ntp.org,1.ru.pool.ntp.org;

/system ntp server set enabled=yes manycast=yes;

/ip dhcp-client set ether1 use-peer-dns=no use-peer-ntp=no;

/ip dhcp-server network set [ find gateway=192.168.88.1 ] dns-server=192.168.88.1 ntp-server=192.168.88.1;

/queue type add kind=cake name=cake-download cake-overhead-scheme=ethernet,pppoe-ptm cake-diffserv=diffserv4;

/queue type add kind=cake name=cake-upload cake-overhead-scheme=ethernet,pppoe-ptm cake-diffserv=besteffort cake-nat=yes;

/queue tree add max-limit=54M name=queue-download packet-mark=no-mark parent=bridge queue=cake-download;

/queue tree add max-limit=40M name=queue-upload packet-mark=no-mark parent=ether1 queue=cake-upload;

/queue type add kind=cake name=cake-download-simple cake-diffserv=besteffort cake-flowmode=dsthost;

/queue type add kind=cake name=cake-upload-simple cake-diffserv=besteffort cake-flowmode=srchost;

/ip firewall filter set [ find comment="defconf: fasttrack" ] connection-mark=!notFastTrack;

/ip firewall mangle add action=mark-connection chain=prerouting connection-mark=!notFastTrack new-connection-mark=notFastTrack src-address-list=video;

/ip firewall mangle add action=change-dscp chain=prerouting new-dscp=24 passthrough=no src-address-list=video;

/ipv6 firewall filter set [ find comment="defconf: fasttrack6" ] connection-mark=!notFastTrack;

/ipv6 firewall mangle add action=mark-connection chain=prerouting connection-mark=!notFastTrack new-connection-mark=notFastTrack src-address-list=video;

/ipv6 firewall mangle add action=change-dscp chain=prerouting new-dscp=24 passthrough=no src-address-list=video;

/system script add dont-require-permissions=no name=video owner=admin policy=read,write source=[ /file get video.rsc contents ];

/system scheduler add interval=30s name=video on-event=video policy=read,write start-date=2025-01-01 start-time=00:00:00;
