var includeMethods = function(page, krakeQueryObject, next) {
  page.injectJs("./middlewares/injections/dom_elements.js") && console.log('  included extractAttributeFromDom');
  next();
}
var exports = module.exports = includeMethods;