{
  services.blocky = {
    enable = true;
    settings = {
      ports = {
        dns = 53;
        tls = 853;
        http = 4000;
        https = 443;
      };
      upstreams = {
        userAgent = ''Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.9357.1659 Safari/537.36'';
        groups.default = [
          "https://one.one.one.one/dns-query" # Using Cloudflare's DNS over HTTPS server for resolving queries.
        ];
      };
      # For initially solving DoH/DoT Requests when no system Resolver is available.
      bootstrapDns = {
        upstream = "https://one.one.one.one/dns-query";
        ips = ["1.1.1.1" "1.0.0.1"];
      };
      # customDns = {
      #   
      # };
      #Enable Blocking of certian domains.
      blocking = {
        blackLists = {
          #Adblocking
          ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
        };
        #Configure what block categories are used
        clientGroupsBlock = {
          default = ["ads"];
        };
      };
    };
  };
}
