// @Description : Given a page object sets the cookies for this object
// @param : page:object
// @param : cookies:array[]
var setCookies = function(page, krakeQueryObject, next) {
  console.log('  COOKIES Setting');  
  if(krakeQueryObject.disable_cookies) {
    console.log('    disabled');
    phantom.cookiesEnabled = false;
  }
  
  if(!krakeQueryObject.disable_cookies && krakeQueryObject.cookies) {
    console.log('    setting cookies provided');
    for( x = 0; x < krakeQueryObject.cookies.length; x++) {
      console.log('      ' + krakeQueryObject.cookies[x].domain + ' : '+ krakeQueryObject.cookies[x].name + ' : ' + krakeQueryObject.cookies[x].value );
      add_results = phantom.addCookie({
        name : krakeQueryObject.cookies[x].name, 
        value : krakeQueryObject.cookies[x].value, 
        domain : krakeQueryObject.cookies[x].domain 
      });      
    };    
  }
  next();
  
};

var exports = module.exports = setCookies;