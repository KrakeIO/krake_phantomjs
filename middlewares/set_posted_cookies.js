var setPostedCookies = function(page, krakeQueryObject, next) {
  console.log('  Posted COOKIES Setting');  

  if(krakeQueryObject.set_post_cookies && krakeQueryObject.post_cookies) {
    console.log('    setting posted cookies provided');
    for( x = 0; x < krakeQueryObject.post_cookies.length; x++) {
      console.log('      ' + krakeQueryObject.post_cookies[x].domain + ' : '+ krakeQueryObject.post_cookies[x].name + ' : ' + krakeQueryObject.post_cookies[x].value );
      add_results = phantom.addCookie({
        name : krakeQueryObject.post_cookies[x].name, 
        value : krakeQueryObject.post_cookies[x].value, 
        domain : krakeQueryObject.post_cookies[x].domain 
      });      
    };
  }

  next();    
};

var exports = module.exports = setPostedCookies;