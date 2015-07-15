// @Description : the process that holds up the loading of pages
var waitFor = function(page, krakeQueryObject, next) {
  
  if( krakeQueryObject.wait_for && krakeQueryObject.wait_for.dom_query ) {
    console.log('  waiting for element to showup');
    console.log('    element waited for: ' + krakeQueryObject.wait_for.dom_query );

    monitorForElement(

      function() {
        console.log('      checking element has been loaded');
        return page.evaluate( function(krakeQueryObject) {
          return document.querySelectorAll( krakeQueryObject.wait_for.dom_query ).length > 0;

        }, krakeQueryObject);

      }, function() {
        console.log('      element has finally be loaded');
        next();

      }, function() {
        console.log('      timeout but element was not loaded yet');
        next();

      },
      krakeQueryObject.wait_for.wait

    );

  } else {
    console.log('  no elements to wait for');
    next();
  }
}

function monitorForElement(testIt, onReady, onTimeOut, timeOutMillis) {
  var maxtimeOutMillis = timeOutMillis ? timeOutMillis : 3000;
  var start = new Date().getTime();
  var condition = false;

  var interval = setInterval(function() {
    var has_timed_out = (new Date().getTime() - start > maxtimeOutMillis);

    if( has_timed_out ) {
      console.log("    'waitFor()' timeout");
      clearInterval(interval);
      onTimeOut && onTimeOut();

    } else if( !testIt ) {
      console.log("    test condition was not provided");
      clearInterval(interval);
      onReady && onReady();

    } else if( testIt ) {
      console.log("    test condition was provided");
      condition = testIt();

      if( condition ) {
        console.log("    'waitFor()' finished in " + (new Date().getTime() - start) + "ms.");
        clearInterval(interval);
        onReady && onReady();

      }

    }

  }, 250); //< repeat check every 250ms

};

var exports = module.exports = waitFor;