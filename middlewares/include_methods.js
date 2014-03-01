var includeMethods = function(page, krakeQueryObject, next) {
  page.injectJs("./middlewares/injections/dom_elements.js") && 
    console.log('  included extractAttributeFromDom');

  page.injectJs("./middlewares/injections/permute.js") && 
    console.log('  included krake_permute object');
    
  next();
}
var exports = module.exports = includeMethods;