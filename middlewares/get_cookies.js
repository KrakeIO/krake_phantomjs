// Clicks on the elements on the page
var getCookies = function(page, krakeQueryObject, next) {
  console.log('  COOKIES Extraction');
  krakeQueryObject.jobResults || {};
 
  if(!krakeQueryObject.disable_cookies) {
    console.log('    getting those set by page');
    krakeQueryObject.jobResults.cookies = page.cookies;
  } else {
    console.log('    disabled');
    krakeQueryObject.jobResults.cookies = [];
  }

  next();
}

var exports = module.exports = getCookies;