// @extracts the next page url from the page  
var nextPageGet = function(page, krakeQueryObject, next) {

  if(!krakeQueryObject.next_page || krakeQueryObject.next_page.click) {
    next();
    return;
  }
  // @Description : extracts value from page
  // @return: 
  //    results:Object
  //        result_rows:Array
  //          result_row:Object
  //            attribute1:String value1 - based on required_attribute
  //            attribute2:String value2 - based on required_attribute
  //            ...
  //        next_page:String — value to next page href
  //        logs:Array
  //          log_mesage1:String, ...
  
  // When is getting the next page url via just the href attribute
  console.log('  Next Page GET');
  console.log('    ' + (krakeQueryObject.next_page.dom_query || krakeQueryObject.next_page.xpath) );
  results = page.evaluate(function(krakeQueryObject) {

    var results = krakeQueryObject.jobResults || {};
    results.logs = results.logs || [];
    results.result_rows = results.result_rows || [];
    
    // gets the next page hyperlink if it exist and use Xpath
    if(krakeQueryObject.next_page && krakeQueryObject.next_page.xpath) { 
      results.logs.push("[PHANTOM_SERVER] extracting next page using Xpath" + 
          "\r\n\t\txpath : " + krakeQueryObject.next_page.xpath);
      var xPathResults = document.evaluate(krakeQueryObject.next_page.xpath, document);
      var xpath_np;
      while(xpath_np = xPathResults.iterateNext()) {
         results.next_page = KrakeDomElements.extractDomAttributes(xpath_np, 'href');
      } 
    
    // when jQuery selector is to be used             
    } else if( (typeof jQuery == "function") && krakeQueryObject.next_page && krakeQueryObject.next_page.dom_query) {
      results.logs.push("[PHANTOM_SERVER] extracting next page using jQuery" + 
          "\r\n\t\tdom_query : " + krakeQueryObject.next_page.dom_query);
      var jquery_np = jQuery(krakeQueryObject.next_page.dom_query);
      jquery_np.length && ( results.next_page = KrakeDomElements.extractDomAttributes(jquery_np[0], 'href') );
      
    // when jQuery has been explicitly excluded
    } else if(  (typeof jQuery != "function") && krakeQueryObject.next_page && krakeQueryObject.next_page.dom_query) {
      results.logs.push("[PHANTOM_SERVER] extracting next page using querySelectorAll" + 
          "\r\n\t\tdom_query : " + krakeQueryObject.next_page.dom_query);
      var jquery_np = document.querySelectorAll(krakeQueryObject.next_page.dom_query);
      jquery_np.length && ( results.next_page = KrakeDomElements.extractDomAttributes(jquery_np[0], 'href' ) );
    
    }      

    return results;
      
  }, krakeQueryObject); // eo evaluation

  console.log("    results:");
  console.log("      " + results.next_page);
  krakeQueryObject.jobResults = results
  next();
}

var exports = module.exports = nextPageGet;