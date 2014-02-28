
// @Description : determines if jQuery is to be included dynamically during run time
var includeJquery = function(page, krakeQueryObject, next) {
  
  if(krakeQueryObject.exclude_jquery) {
    console.log('  jQuery was excluded');
    
  } else {
    console.log('  Checking jQuery status');    
    // checks if jQuery is already included
    var jquery_exist = page.evaluate(function() {
      return (typeof jQuery == "function");
    });
   
    jquery_exist && console.log("    jQuery library already exist");
    !jquery_exist && page.injectJs("./3p/jquery.js") &&
      console.log('    jQuery was injected');

  }    

  next();  
}  

var exports = module.exports = includeJquery;