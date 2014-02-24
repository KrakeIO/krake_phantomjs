var includeMethods = function(page, krakeQueryObject, next) {
  page.injectJs("./middlewares/injections/dom_elements.js") && console.log('[PHANTOM_SERVER] included extractAttributeFromDom');
  next();
}
var exports = module.exports = includeMethods;