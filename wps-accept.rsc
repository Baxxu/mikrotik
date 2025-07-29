:foreach iface in=[/interface/wifi find where (default-name=wifi1)] do={
   :if ([/interface/wifi get $iface disabled]) do={
      /interface wifi set $iface disabled=no;
   } else={
      /interface wifi set $iface disabled=yes;
   }
}
