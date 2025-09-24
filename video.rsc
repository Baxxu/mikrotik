:global AddIpv4Func do={
    :local myRecord $record;

    :onerror err in={
		:local ip [/ip dns cache get $myRecord data];
		
		:local name [/ip dns cache get $myRecord name];

		/ip firewall address-list add address=$ip comment=$name list=video timeout=30d;

        #:log info ("AddIpv4Func. ip=$ip, name=$name");
    } do={}
}

:global AddIpv6Func do={
    :local myRecord $record;

    :onerror err in={
		:local ip [/ip dns cache get $myRecord data];

		:local name [/ip dns cache get $myRecord name];
		
		/ipv6 firewall address-list add address=$ip comment=$name list=video timeout=30d;
    } do={}
}

:global ResolveCNAMEtoAFunc do={
    :local myName $name;

    :global AddIpv4Func;

    :foreach rec in=[/ip dns cache find where (name=$myName and type="A")] do={
        $AddIpv4Func record=$rec;
    }
}

:global ResolveCNAMEtoAAAAFunc do={
    :local myName $name;

    :global AddIpv6Func;

    :foreach rec in=[/ip dns cache find where (name=$myName and type="AAAA")] do={
        $AddIpv6Func record=$rec;
    }
}

:global ProcessCNAMEFunc do={
    :local myRecord $record;

    :global ResolveCNAMEtoAFunc;
    :global ResolveCNAMEtoAAAAFunc;

    :local currentName;

    :local ok false;
    :onerror err in={
        :set currentName [/ip dns cache get $myRecord data];
        :set ok true;
    } do={
        :set ok false;
    }

    #:log info "ok $ok";

    if (!ok) do={
        :return false;
    }

    :local maxDepth 5;
    :local currentDepth 0;

    :while ($currentDepth < $maxDepth) do={
        :onerror err in={
			:if ([:len $currentName] > 0 and [:pick $currentName ([:len $currentName]-1)] = ".") do={
				:set currentName [:pick $currentName 0 ([:len $currentName]-1)];
			}

			#:log info ("ProcessCNAMEFunc. level=$currentDepth, name=$currentName");

			$ResolveCNAMEtoAFunc name=$currentName;
            # Turned off
			#$ResolveCNAMEtoAAAAFunc name=$currentName;

			:local nextCname [/ip dns cache find where (name=$currentName and type="CNAME")];
			:if ([:len $nextCname] = 0) do={
				:error;
			}

			:set currentName [/ip dns cache get [ :pick $nextCname 0 ] data];
			:set currentDepth ($currentDepth + 1);
        } do={
            :set currentDepth ($currentDepth + 1);
        }
    }
}

#IPv4
:foreach rec in=[/ip dns cache find where ((name~"video" or name~"hls") and type="A")] do={
    $AddIpv4Func record=$rec;
}

#IPv6
# Turned off
#:foreach rec in=[/ip dns cache find where ((name~"video" or name~"hls") and type="AAAA")] do={
    #$AddIpv6Func record=$rec;
#}

#CNAME to IPv4 and IPv6
:foreach rec in=[/ip dns cache find where ((name~"video" or name~"hls") and type="CNAME")] do={
    $ProcessCNAMEFunc record=$rec;
}