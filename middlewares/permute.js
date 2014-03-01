var permute = function(page, krakeQueryObject, next) {

  if(!krakeQueryObject.permuted_columns) {
    next();
    return;
  }

  console.log('  Extracting Permute elements');
  console.log('    handle cols:');
  krakeQueryObject.permuted_columns.handles && krakeQueryObject.permuted_columns.handles.forEach(function(handle_col){
    console.log('      ' + handle_col.col_name + ' : ' + (handle_col.xpath || handle_col.dom_query));
  });
  console.log('    response cols:');
  krakeQueryObject.permuted_columns.responses && krakeQueryObject.permuted_columns.responses.forEach(function(response_col){
    console.log('      ' + response_col.col_name + ' : ' + (response_col.xpath || response_col.dom_query));
  });
  

  page.evaluate(function(krakeQueryObject) {
    if(krakeQueryObject.permuted_columns) {
      KrakePermute.init(krakeQueryObject);
      KrakePermute.permute();
    }
  }, krakeQueryObject);

  permutation_results = page.evaluate( function() {
    return KrakePermute.results;
  });

  permutation_logs = page.evaluate( function() {
    return KrakePermute.logs;
  });

  console.log("    logs:");
  permutation_logs.forEach(function(log) {
    console.log("      " + log);
  })

  var results = krakeQueryObject.jobResults || {};
  results.logs = results.logs || [];
  results.result_rows = results.result_rows || [];  

  combined_results_rows = [];
  (permutation_results.length > 0) && console.log("    has permutation_results");
  (results.result_rows.length) && console.log("    has column query results");

  if(results.result_rows.length == 0 && permutation_results.length > 0)
    combined_results_rows = permutation_results

  else if(results.result_rows.length > 0 && permutation_results.length == 0)
    combined_results_rows = results.result_rows

  else if(results.result_rows.length > 0 &&  permutation_results.length > 0) {
    combined_results_rows = [];
    results.result_rows.forEach(function(curr_ex_result) {
      permutation_results.forEach(function(curr_pm_result) {
        combi_result = JSON.parse(JSON.stringify(curr_ex_result));
        Object.keys(curr_pm_result).forEach(function(pm_col_name) {
          combi_result[pm_col_name] = curr_pm_result[curr_pm_result];
        })
        combined_results_rows.push(combi_result);
      });
    });
  }

  console.log("    results:");
  console.log("        count:" + combined_results_rows.length);
  combined_results_rows.forEach(function(row) {
    // console.log("      row:");
    Object.keys(row).forEach(function(col_name) {
      // console.log("        " + col_name + " : " + row[col_name])
    });
  });

  krakeQueryObject.jobResults.result_rows = combined_results_rows

  next();
}

var exports = module.exports = permute;