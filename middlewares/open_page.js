var openPage = function(page, krakeQueryObject, next) {
  console.log("  Opening page");
  // @Description : throws up the error
  page.onError = function (msg, trace) {
    console.log(msg);
    trace.forEach(function(item) {
      console.log('  ', item.file, ':', item.line);
    })
  };

  page.onResourceError = function(resourceError) {
    console.error('    ',resourceError.url + ': ' + resourceError.errorString);
  };  
  
  // the callback that is triggered after the page is open
  callback = function(status) {

    krakeQueryObject.jobResults = { result_rows: [], logs: [] };
    // When opening page failed
  	if(status !== 'success') {
  	  console.log('    failed to open page.');
  	  krakeQueryObject.jobStatus = 'error'
      page.close();
  	} 
    next();  	
  }  
  
  // POST method
  if(krakeQueryObject.method && krakeQueryObject.method == 'post') {
      console.log("    method: POST");
      postData = krakeQueryObject.post_data || []
      console.log("    form:");
      queryString = Object.keys(krakeQueryObject.post_data).map(function(key){ 
      console.log("     " + key + ": " + krakeQueryObject.post_data[key]);
        return key + "=" + krakeQueryObject.post_data[key]
      }).join("&");
      page.open(krakeQueryObject.origin_url, 'post', queryString, callback);        
  
  // GET method
  } else {
    page.open(krakeQueryObject.origin_url, callback);
    
  }
  
}

var exports = module.exports = openPage;