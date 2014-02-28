var domElements = function(page, krakeQueryObject, next) {

  if(!krakeQueryObject.columns || krakeQueryObject.columns.length == 0) {
    next();
    return;
  }

  var_cols = krakeQueryObject.columns.filter(function(col) { return col.var_query; });
  if(var_cols.length == 0) {
    next();
    return;
  }

  console.log("  Extracting VAR elements:");
  var_cols.forEach(function(col) {
    console.log("      " + col.col_name + " : " + col.var_query);
  });

  results = page.evaluate(function(krakeQueryObject) {  
    var results = krakeQueryObject.jobResults || {};
    results.logs = results.logs || [];
    results.result_rows = results.result_rows || [];

    if(!krakeQueryObject.columns)
      return results;

    var_cols = krakeQueryObject.columns.filter(function(col) {
      return col.var_query;
    }).forEach(function(col) {
      try {
        selected_val = eval(col.var_query);

      } catch(error) {
        selected_val = "[PHANTOM_SERVER] variable not found";
        
      }

      if(typeof selected_val == "string") {
        results.result_rows[0] = results.result_rows[0] || {};
        results.result_rows[0][col.col_name] = selected_val;

      } else if(selected_val instanceof Array) {
        for(var x = 0; x < selected_val.length ; x++) {
          results.result_rows[x] = results.result_rows[x] || {};
          results.result_rows[x][col.col_name] = selected_val[x];
        }
      } else if(typeof selected_val == 'object') {
        results.result_rows[0] = results.result_rows[0] || {};
        results.result_rows[0][col.col_name] = selected_val;        
      }

    })

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