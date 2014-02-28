var closePage = function(page, krakeQueryObject, next) {
  console.log('  closed page');  
  page.close();
  next();  
}

var exports = module.exports = closePage;  