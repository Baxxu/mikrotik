#/log info ("Starting video script");

:foreach i in=[/ip dns cache all find where ((name~"video" or name~".hls.ttvnw.net") and type="A")] do={
    :local tmpAddress [/ip dns cache get $i data];
           
    :if ([/ip firewall address-list find where address=$tmpAddress] = "") do={ 
        :local cacheName [/ip dns cache get $i name];
        #/log info ("added entry: $cacheName $tmpAddress");
        /ip firewall address-list add address=$tmpAddress comment=$cacheName list=video timeout=30d; 
    }
}