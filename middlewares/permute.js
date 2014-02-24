var permute = function(page, krakeQueryObject, next) {

  page.injectJs("./3p/jquery.simulate.js") && console.log('[PHANTOM_SERVER] included extractAttributeFromDom');
  page.injectJs("./middlewares/injections/permute.js") && console.log('[PHANTOM_SERVER] included krake_permute object');

  console.log('[PHANTOM_SERVER] extracting Permute elements');
  results = page.evaluate(function(krakeQueryObject) {
    var results = krakeQueryObject.jobResults || {};
    results.logs = results.logs || [];
    results.result_rows = results.result_rows || [];


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

var exports = module.exports = permute;