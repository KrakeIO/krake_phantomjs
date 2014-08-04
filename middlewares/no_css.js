var noCSS = function(page, krakeQueryObject, next) {

  page.onResourceRequested = function(requestData, request) {
    if ((/http:\/\/.+?\.css$/gi).test(requestData['url'])) {
        console.log('  Skipping', requestData['url']);
        request.abort();
    }
  };
  next();
}

var exports = module.exports = noCSS;