var suddenDeath = function(page, krakeQueryObject, next) {

  if(!krakeQueryObject.sudden_death) {
    next();
    return
  }

  console.log('  checking for sudden death elements on page');
  results = page.evaluate(function(krakeQueryObject) {
    var results = krakeQueryObject.jobResults || {};
    results.logs = results.logs || [];
    results.result_rows = results.result_rows || [];

    if(krakeQueryObject.sudden_death && krakeQueryObject.sudden_death.xpath) {
      results.logs.push("  Extracting sudden_death using Xpath" + 
          "\r\n\t\txpath : " + krakeQueryObject.sudden_death.xpath);
      var xPathResults = document.evaluate(krakeQueryObject.sudden_death.xpath, document);
      while(xPathResults.iterateNext()) {
         results.sudden_death = true;
      }       

    } else if( (typeof jQuery == "function") && krakeQueryObject.sudden_death && krakeQueryObject.sudden_death.dom_query) {
      results.logs.push("  Extracting sudden_death using jQuery" + 
          "\r\n\t\tdom_query : " + krakeQueryObject.sudden_death.dom_query);
      results.sudden_death = jQuery(krakeQueryObject.sudden_death.dom_query).length > 0;

    } else if(  (typeof jQuery != "function") && krakeQueryObject.sudden_death && krakeQueryObject.sudden_death.dom_query) {
      results.logs.push("  Extracting sudden_death using querySelectorAll" + 
          "\r\n\t\tdom_query : " + krakeQueryObject.next_page.dom_query);
      results.sudden_death = document.querySelectorAll(krakeQueryObject.next_page.dom_query).length > 0;

    }

    return results;

  }, krakeQueryObject);

  console.log("    result:" + results.sudden_death);
  krakeQueryObject.jobResults = results
  next();
}

var exports = module.exports = suddenDeath;