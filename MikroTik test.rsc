:local counter 0;

:foreach i in=[/ip dns cache find where ((name~"video" or name~".hls.ttvnw.net") and (type="A" or type="AAAA"))] do={
    :set counter ($counter + 1);
    :return false;
}

:log info ("Counter=$counter");



:set counter 0;

:foreach i in=[/ip dns cache all find where ((name~"video" or name~".hls.ttvnw.net") and (type="A" or type="AAAA"))] do={
    :set counter ($counter + 1);
    :return false;
}

:log info ("Counter=$counter");