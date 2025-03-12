:global AddIpv4Func do={
    :local IpVar [/ip dns cache get $i data];

    :if ($IpVar = "0.0.0.0" or $IpVar = "" or $IpVar = 0.0.0.0) do={
        :return false;
    }
	
    :local DnsNameVar [/ip dns cache get $i name];

    :onerror err in={
        /ip firewall address-list add address=$IpVar comment=$DnsNameVar list=video timeout=30d;

        #:log info ("video script. Added entry: DnsName=$DnsNameVar Ip=$IpVar DnsType=$DnsTypeVar");

        :return true;
    } do={
        :return false;
    }
}

:global AddIpv6Func do={
    :local IpVar [/ip dns cache get $i data];

    :if ($IpVar = "") do={
        :return false;
    }

    :local DnsNameVar [/ip dns cache get $i name];

    :onerror err in={
        /ipv6 firewall address-list add address=$IpVar comment=$DnsNameVar list=video timeout=30d;

        #:log info ("video script. Added entry: DnsName=$DnsNameVar Ip=$IpVar DnsType=$DnsTypeVar");

        :return true;
    } do={
        :return false;
    }
}

:foreach i in=[/ip dns cache find where ((name~"video" or name~".hls.ttvnw.net") and type="A")] do={
    $AddIpv4Func i=$i;
}

:foreach i in=[/ip dns cache find where ((name~"video" or name~".hls.ttvnw.net") and type="AAAA")] do={
    $AddIpv6Func i=$i;
}