:global AddIpv4Func do={
	:onerror err in={
		:local IpVar [/ip dns cache get $i data];
	
		:local DnsNameVar [/ip dns cache get $i name];

        /ip firewall address-list add address=$IpVar comment=$DnsNameVar list=video timeout=30d;

        #:log info ("video script. Added entry: DnsName=$DnsNameVar Ip=$IpVar DnsType=A");

        :return true;
    } do={
        :return false;
    }
}

:global AddIpv6Func do={
    :onerror err in={
		:local IpVar [/ip dns cache get $i data];

		:local DnsNameVar [/ip dns cache get $i name];
	
        /ipv6 firewall address-list add address=$IpVar comment=$DnsNameVar list=video timeout=30d;

        #:log info ("video script. Added entry: DnsName=$DnsNameVar Ip=$IpVar DnsType=AAAA");

        :return true;
    } do={
        :return false;
    }
}

:global ResolveCNAMEtoAFunc do={
	:onerror err in={
		:foreach ii in=[/ip dns cache find where (name~$i and type="A")] do={
			:local IpVar [/ip dns cache get $ii data];
			:local DnsNameVar [/ip dns cache get $ii name];
			
			#:log info "$IpVar $DnsNameVar";
		
			/ip firewall address-list add address=$IpVar comment=$DnsNameVar list=video timeout=30d;
	
			#:log info ("video script. Added entry: DnsName=$DnsNameVar Ip=$IpVar DnsType=A");
	
			:return true;
		}
	} do={
		:return false;
	}
}

:global ResolveCNAMEtoAAAAFunc do={
	:onerror err in={
		:foreach ii in=[/ip dns cache find where (name~$i and type="AAAA")] do={
			:local IpVar [/ip dns cache get $ii data];
			:local DnsNameVar [/ip dns cache get $ii name];
			
			#:log info "$IpVar $DnsNameVar";
		
			/ipv6 firewall address-list add address=$IpVar comment=$DnsNameVar list=video timeout=30d;
	
			#:log info ("video script. Added entry: DnsName=$DnsNameVar Ip=$IpVar DnsType=AAAA");
	
			:return true;
		}
	} do={
		:return false;
	}
}

#IPv4
:foreach i in=[/ip dns cache find where ((name~"video" or name~".hls.ttvnw.net") and type="A")] do={
    $AddIpv4Func i=$i;
}

#IPv6
:foreach i in=[/ip dns cache find where ((name~"video" or name~".hls.ttvnw.net") and type="AAAA")] do={
    $AddIpv6Func i=$i;
}

#CNAME to IPv4 and IPv6
:foreach i in=[/ip dns cache find where ((name~"video" or name~".hls.ttvnw.net") and type="CNAME")] do={
    :local IpVar [/ip dns cache get $i data];
	:set IpVar [:pick $IpVar 0 ([:len $IpVar]-1)];
	#:log info "$IpVar";
	
	$ResolveCNAMEtoAFunc i=$IpVar
	
	$ResolveCNAMEtoAAAAFunc i=$IpVar
}