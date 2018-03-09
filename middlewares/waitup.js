// @Description : the process that holds up the loading of pages
var waitUp = function(page, krakeQueryObject, next) {

  if( Array.isArray(krakeQueryObject.wait) && krakeQueryObject.wait[0] > 0  && krakeQueryObject.wait[1] > krakeQueryObject.wait[0]) { 
    console.log("wait up line 5")
    wait_time = Math.floor(Math.random() * (krakeQueryObject.wait[1] - krakeQueryObject.wait[0] ) ) + krakeQueryObject.wait[0]
    
    console.log('[PHANTOM_SERVER] : waiting for ' + wait_time + ' milliseconds')

    setTimeout(function() {
      next();
    }, wait_time);

  } else if(krakeQueryObject.wait && krakeQueryObject.wait > 0 ) {
    console.log("wait up line 13")
    console.log('[PHANTOM_SERVER] : waiting for ' + krakeQueryObject.wait + ' milliseconds')
    setTimeout(function() {
      //extractDomElements();
      next();
    }, krakeQueryObject.wait);
  } else {
    console.log("wait up line 20")
    //extractDomElements();
    next();
  }
}

var exports = module.exports = waitUp;