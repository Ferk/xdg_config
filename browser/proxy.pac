// -*- js -*-
//
// Proxy-Auto-Configuration File
//


// Default proxy configuration to use
var normal = "DIRECT";

// where everything unwanted redirects to
var blackhole = "PROXY 0.0.0.0:3421";

var i2pproxy = "PROXY localhost:4444";



// matches several common URL paths for ad images:
// such as: /banner/ /..._banner/ /banner_...
// but matches several words and includes plurals
var re_banner = /\/(.*_){0,1}(ad|adverts?|adimage|adframe|adserver|adriver|yadro|admentor|adview|banner|popup|popunder)(s)?[_.\/]/i;

// matches host names staring with "ad" but not (admin|add|adsl)
// or any hostname starting with "pop", "clicks", and "cash"
// or any hostname containing "banner"
// ^(ad(s)?.{0,4}\.|pop|click|cash|[^.]*banner|[^.]*adserv)
// ^(ad(?!(min|sl|d\.))|pop|click|cash|[^.]*banner|[^.]*adserv)
// ^(ad(?!(min|sl|d\.))|pop|click|cash|[^.]*banner|[^.]*adserv|.*\.ads\.)
// http://ad.adriver.ru/cgi-bin/
var re_adhost = /^(www\.)?(ad(?!(ult|obe.*|min|sl|d|olly.*))|tology|pop|click|cash|[^.]*banner|[^.]*adserv|.+\.ads?\.)/i;




function FindProxyForURL(url, host)
{
    //alert("checking: url=" + url + ", host=" + host);

    if (dnsDomainIs(host, ".i2p"))
    {
        return i2pproxy;
    }
    else if (0
    	     // BLOCK
    	     // Block IE4/5 "favicon.ico" fetches
    	     // (to avoid being tracked as having bookmarked the site)
    	     || /favicon.ico([#\?].*)?$/i.test(url)

    	     // RE for common URL paths
    	     || re_banner.test(url)
    	     || re_adhost.test(host)
    	    )
    {
    	return blackhole;
    }
    else
    {
        return normal;
    }
}

