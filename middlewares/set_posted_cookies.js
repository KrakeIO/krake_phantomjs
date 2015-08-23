var KSON = require('../node_modules/kson/lib/kson');

var setPostedCookies = function(page, krakeQueryObject, next) {
  console.log('  Posted COOKIES Setting');  
  if(krakeQueryObject.set_post_cookies) {
    console.log('    cookie set to POST Body post_cookie');
    krakeQueryObject.post_data = krakeQueryObject.post_data || {}
    krakeQueryObject.post_data["post_cookies"] = encodeURIComponent ( JSON.stringify( krakeQueryObject.cookies ) )
  } else {
    console.log(JSON.stringify(krakeQueryObject))    
    console.log('    not set');
  }

  next();    
};

var exports = module.exports = setPostedCookies;