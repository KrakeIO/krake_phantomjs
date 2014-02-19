var domElements = function(page, krakeQueryObject, next) {

  //page.render('facebook-phantom.pdf');
  console.log('[PHANTOM_SERVER] extracting VAR elements');
  results = page.evaluate(function(krakeQueryObject) {  
    var results = krakeQueryObject.jobResults || {};
    results.logs = results.logs || [];
    results.result_rows = results.result_rows || [];

    var_cols = krakeQueryObject.columns.filter(function(col) {
      return col.var_query;

    }).forEach(function(col) {
      selected_val = eval(col.var_query);

      if(typeof selected_val == "string"){
        results.result_rows[0] = results.result_rows[0] || {};
        results.result_rows[0][col.col_name] = selected_val;

      } else if (selected_val instanceof Array) {
        for(var x = 0; x < selected_val.length ; x++) {
          results.result_rows[x] = results.result_rows[x] || {};
          results.result_rows[x][col.col_name] = selected_val[x];
        }
      } 

    })

    return results;
  }, krakeQueryObject); // eo evaluation

  console.log('[PHANTOM_SERVER] Extraction finished.');
  console.log('[PHANTOM_SERVER] Processing Query');    
  console.log(JSON.stringify(krakeQueryObject) + '\r\n\r\n');
  console.log('[PHANTOM_SERVER] Retrieved Results');        
  console.log(JSON.stringify(results) + '\r\n\r\n');
  krakeQueryObject.jobResults = results

  next();
}

var exports = module.exports = domElements;