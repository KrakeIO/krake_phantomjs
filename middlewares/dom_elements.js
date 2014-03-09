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
  results = page.evaluate(function(krakeQueryObject) {

    var results = krakeQueryObject.jobResults || {};
    results.logs = results.logs || [];
    results.result_rows = results.result_rows || [];

    // Goes through each columns
    for(var x = 0; x < krakeQueryObject.columns.length ; x++) {
      
      var curr_column = krakeQueryObject.columns[x];
      var harvested_values = KrakeDomElements.getDomNodesValues(curr_column);
      
      // Fetches the results into rows
      if(!curr_column.is_compound) {
        for (var y = 0; y < harvested_values.length ; y++ ) {
          var curr_result_row = results.result_rows[y] || {};
          curr_result_row[curr_column['col_name']] = harvested_values[y];
          results.result_rows[y] = curr_result_row;
        }
      
      // Joins all the values into a single row
      } else {
        var curr_result_row = results.result_rows[0] || {};
        curr_result_row[curr_column['col_name']] = harvested_values.join();
        results.result_rows[0] = curr_result_row;
        
      }

    } // eo iterating through krake columns
    
    return results;
      
  }, krakeQueryObject); // eo evaluation

  console.log("    results:");
  results.result_rows.forEach(function(row) {
    console.log("      row:");
    Object.keys(row).forEach(function(col_name) {
      console.log("        " + col_name + " : " + row[col_name])
    });
  });
  krakeQueryObject.jobResults = results
  
  next();
}

var exports = module.exports = domElements;