// @extracts the DOM elements from the page  
var domElements = function(page, krakeQueryObject, next) {
  
  if(!krakeQueryObject.columns || krakeQueryObject.columns.length == 0) {
    next();
    return;
  }

	console.log("  Extracting DOM elements:");
  krakeQueryObject.columns.forEach(function(column) {
    query = column.dom_query || column.xpath;
    console.log("      " + column.col_name + " : " + query);
  });

  page.onCallback = function(results) {
    console.log("    results:");
    results.result_rows.forEach(function(row) {
      console.log("      row:");
      Object.keys(row).forEach(function(col_name) {
        console.log("        " + col_name + " : " + row[col_name])
      });
    });

    console.log("    logs:");
    results.logs.forEach(function(log) {
      console.log("      " + log);
    });

    krakeQueryObject.jobResults = results;
    next();
  };

  page.evaluate(function(krakeQueryObject) {

    KrakeDomElements.init(krakeQueryObject);
    KrakeDomElements.processPageActions().then(function() {
      KrakeDomElements.processColumns(function(results){
         window.callPhantom(results);
      });      
    })

    
  }, krakeQueryObject); // eo evaluation

}

var exports = module.exports = domElements;