// Clicks on the elements on the page
var getCookies = function(page, krakeQueryObject, next) {
  console.log('[PHANTOM_SERVER] extracting COOKIES set by page');
  krakeQueryObject.jobResults || {};
  krakeQueryObject.jobResults.cookies = page.cookies;
  next();
}

var exports = module.exports = getCookies;