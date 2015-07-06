
// @Description : determines if jQuery is to be included dynamically during run time
var includePromise = function(page, krakeQueryObject, next) {
  
  page.injectJs("./3p/q.js") &&
    console.log('  Included Q Promise');

  next();  
}  

var exports = module.exports = includePromise;