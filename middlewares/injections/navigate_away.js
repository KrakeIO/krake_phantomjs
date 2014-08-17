// Hijacking the XMLHttpRequest prototype
XMLHttpRequest.prototype._open = XMLHttpRequest.prototype.open
XMLHttpRequest.prototype.open = function() { console.log(arguments)
  XMLHttpRequest.prototype._open.apply(this, arguments)
  window.callPhantom({ event: "xml_http_req", method: arguments[0], url: arguments[1], args: arguments });
};

// Listening in on the page unload event
window.addEventListener('pagehide', function() {
  window.callPhantom({ event: "page_load" });
}, false);

// Hijacking all form submits on the page
for(var x = 0; x < window.document.forms.length; x++) {
  var curr_form = window.document.forms[x];
  curr_form._submit = curr_form.submit
  curr_form.submit = function() {
    var self = this;
    var form_data = {};
    $(self).serializeArray().forEach( function(form_input_obj) {
      form_data[form_input_obj.name] = form_input_obj.value
    });

    window.callPhantom({ event: "form_post", url: self.action, method: self.method.toLowerCase(), form_data: form_data  });
    self._submit()
  }
}