// Clicks on the elements on the page
var clickElements = function(page, krakeQueryObject, next) {

  if(!krakeQueryObject.to_click) {
    next();
    return;
  }

  //page.render('facebook-phantom.pdf');
  console.log('  clicking elements on page');
  krakeQueryObject.to_click.forEach(function(click_el) {
    console.log("    " + click_el);
  })

  page.evaluate(function(krakeQueryObject) {
    if(krakeQueryObject && krakeQueryObject.to_click) {
      krakeQueryObject.to_click.forEach(function(value) { 
        jQuery(value).trigger('click');
      });
    }

  }, krakeQueryObject); // eo evaluation  

  setTimeout(function() {
    next();
  }, 500);

}

var exports = module.exports = clickElements;