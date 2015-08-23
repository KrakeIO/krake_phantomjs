var setPostedCookies = function(page, krakeQueryObject, next) {
  console.log('  Posted COOKIES Setting');  

  if(krakeQueryObject.set_post_cookies) {
    krakeQueryObject.post_data = krakeQueryObject.post_data || {}
    krakeQueryObject.post_data["post_cookies"] = JSON.stringify( krakeQueryObject.cookies )
  }

  next();    
};

var exports = module.exports = setPostedCookies;