var noImages = function(page, krakeQueryObject, next) {

  page.onResourceRequested = function(requestData, request) {
    if ( /^https?:\/\/(?:[a-z\-]+\.)+[a-z]{2,6}(?:\/[^\/#?]+)+\.(?:jpe?g|gif|png|mpg|mpe?g|swf|avi|svg)$/.test(requestData['url'])) {
        console.log('  Skipping', requestData['url']);
        request.abort();
    }
  };
  next();
}

var exports = module.exports = noImages;