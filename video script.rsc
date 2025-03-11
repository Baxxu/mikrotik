# Добавляет IP адреса в список video, чтобы потом в firewall -> mangle можно было применять прявила к этому списку адресов.
# В списке video хранятся адреса, которым нужно повышать приоритеть пакетов до 24, чтобы они попадали в video очередь cake queue.

:global AddIpFunc do={
    :local IpVar [/ip dns cache get $i data];

    :if ($IpVar = "0.0.0.0" or $IpVar = "" or $IpVar = 0.0.0.0) do={
        :return false;
    }

    :local DnsTypeVar [/ip dns cache get $i type];

    :local DnsNameVar [/ip dns cache get $i name];

    :if ($DnsTypeVar = "A") do={
        :onerror err in={
            /ip firewall address-list add address=$IpVar comment=$DnsNameVar list=video timeout=30d;

            #:log info ("video script. Added entry: DnsName=$DnsNameVar Ip=$IpVar DnsType=$DnsTypeVar");

            :return true;
            } do={
                :return false;
            }
    }

    :if ($DnsTypeVar = "AAAA") do={
        :onerror err in={
            /ipv6 firewall address-list add address=$IpVar comment=$DnsNameVar list=video timeout=30d;

            #:log info ("video script. Added entry: DnsName=$DnsNameVar Ip=$IpVar DnsType=$DnsTypeVar");

            :return true;
            } do={
                :return false;
            }
    }
}

:foreach i in=[/ip dns cache find where ((name~"video" or name~".hls.ttvnw.net") and (type="A" or type="AAAA"))] do={
    $AddIpFunc i=$i;
}