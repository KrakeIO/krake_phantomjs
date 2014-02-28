var permute = function(page, krakeQueryObject, next) {

  if(!krakeQueryObject.permuted_columns) {
    next();
    return;
  }

  page.injectJs("./3p/jquery.simulate.js") && console.log('[PHANTOM_SERVER] included extractAttributeFromDom');
  page.injectJs("./middlewares/injections/permute.js") && console.log('[PHANTOM_SERVER] included krake_permute object');
  console.log('[PHANTOM_SERVER] extracting Permute elements');
  page.evaluate(function(krakeQueryObject) {
    if(krakeQueryObject.permuted_columns) {
      KrakePermute.init(krakeQueryObject);
      KrakePermute.permute();
    }
  }, krakeQueryObject);

  permutation_results = page.evaluate( function() {
    return KrakePermute.results;
  });

  var results = krakeQueryObject.jobResults || {};
  results.logs = results.logs || [];
  results.result_rows = results.result_rows || [];  

  combined_results_rows = [];
  if(results.result_rows.length == 0 && permutation_results.length > 0)
    combined_results_rows = permutation_results

  else if(results.result_rows.length > 0 && permutation_results.length == 0)
    combined_results_rows = results.result_rows

  else if(results.result_rows > 0 &&  permutation_results.length > 0) {

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

  krakeQueryObject.jobResults = combined_results_rows

  next();
}

var exports = module.exports = permute;