var parseUri = require('../3p/parse_uri');

// @Description : checks the settings for current domain and determine if should set header
// @param : page:object
// @param : krakeQueryObject:Object
// @param : next:function()
var setHeaders = function(page, krakeQueryObject, next) {

  domain_info = parseUri(krakeQueryObject.origin_url);
  if(!domain_info.host.match(/facebook.com/)) {
    page.settings['userAgent'] = 
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.114 Safari/537.36';
  }

  if(krakeQueryObject.headers) {
    page.customHeaders = krakeQueryObject.headers
  }

  next();
}

var exports = module.exports = setHeaders;