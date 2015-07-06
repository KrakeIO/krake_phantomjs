// Gets the value of a DOM attribute
var KrakeDomElements = {

  init: function(krakeQueryObject) {
    var self = this;
    self.columns = krakeQueryObject.columns;
    self.page_actions = krakeQueryObject.page_actions || [];
    self.results = krakeQueryObject.jobResults || {};
    self.results.logs = self.results.logs || [];
    self.results.result_rows = self.results.result_rows || [];
  },

  getResults: function() {
    var self = this;
    return self.results;
  },

  processColumns: function(callback) {
    var self = this;
    var deferred = Q.defer();

    if(self.columns.length > 0) {
      self.processNextColumn( deferred);

    } else {
      deferred.resolve( self.results );
    }
    return deferred.promise;

    
  },

  processNextColumn: function( deferred ) {
    var self = this;
    var curr_column = self.columns.shift();
    self.getDomNodesValues(curr_column, function(harvested_values) {

      // Fetches the results into rows
      if(!curr_column.is_compound) {
        for (var y = 0; y < harvested_values.length ; y++ ) {
          var curr_result_row = self.results.result_rows[y] || {};
          curr_result_row[curr_column['col_name']] = harvested_values[y];
          self.results.result_rows[y] = curr_result_row;
        }
      
      // Joins all the values into a single row
      } else {
        var curr_result_row = self.results.result_rows[0] || {};
        curr_result_row[curr_column['col_name']] = harvested_values.join();
        self.results.result_rows[0] = curr_result_row;
        
      }

      if( self.columns.length > 0 ) {
        self.processNextColumn( deferred );

      } else {
        deferred && deferred.resolve( self.results );
      }

    });
    
  },

  // Returns an array of dom elements values given a Column
  getDomNodesValues : function(curr_column, callback) {
    var self = this;

    if(curr_column.simulate) {
      self.results.logs.push("simulation for " + curr_column.col_name);
      self.toSimulate(curr_column.simulate);
    }

    if(curr_column.simulate && curr_column.simulate.wait) {
      self.results.logs.push("waiting for " + curr_column.wait + " milliseconds after simulation");
      setTimeout(function() {
        var dnv_rs = self.getDomNodes(curr_column).map(function(item) {
          return self.extractDomAttributes(item, curr_column['required_attribute']);
        });
        callback && callback(dnv_rs);
      }, curr_column.simulate.wait);

    } else {
      var dnv_rs = self.getDomNodes(curr_column).map(function(item) {
        return self.extractDomAttributes(item, curr_column['required_attribute']);
      });
      callback && callback(dnv_rs);
    }

  },

  // Returns an array of dom elements nodes given a Column
  getDomNodes : function(curr_column) {
    var self = this;

    dom_elements = [];

    // When using jQuery to get dom within a dom_container 
    if( (typeof jQuery == "function") && curr_column.dom_container && curr_column.dom_query) {
      jQuery(curr_column.dom_container).each(function(index, curr_container) {
        item = jQuery(curr_container).find(curr_column.dom_query)[0] || self.dummyDomPlaceHolder();
        dom_elements.push(item);
      });

    // When using jQuery to get dom
    } else if( (typeof jQuery == "function") && curr_column.dom_query) {
      jQuery(curr_column.dom_query).each(function(index, item) {
        dom_elements.push(item);
      });

    // When using document.querySelectAll to get dom
    } else if( (typeof jQuery != "function") && curr_column.dom_query) {
      doc_els = document.querySelectorAll(curr_column.dom_query);
      for(var x = 0; x < doc_els.length; x++ ) {
        dom_elements.push(doc_els[x]);
      }

    // When using xPath to get dom
    } else if(curr_column.xpath) {
      var xPathResults = document.evaluate(curr_column.xpath, document);
      while(curr_item = xPathResults.iterateNext()) {
        dom_elements.push(curr_item);
      }
    }

    return dom_elements;
  },

  // Returns a dummy place holder that behaves like a dom element but returns only empty values
  dummyDomPlaceHolder : function() {
    return {
      getAttribute: function() {
        return "";
      }
    }
  },

  // Returns Deferred Promise
  processPageActions: function() {
    var self = this;
    var deferred = Q.defer();
    self.processNextPageAction( deferred );
    return deferred.promise;
  },  

  // Performs the next action in the page
  processNextPageAction: function(deferred_obj) {
    var self = this;

    // When there is still some more page action
    if( self.page_actions.length > 0 ) {
      var current_simulation = self.page_actions.shift();  

      self.toSimulate(current_simulation).then(function() {
        self.processNextPageAction(deferred_obj);

      });

    } else {
      deferred_obj && deferred_obj.resolve();

    }

  },

  /** 
  Interacts with dom elements on Page before proceeding to extract the data in the page

  Params:
    simulate: Object        
      dom_query: String
      wait: Integer
      action: String
        click
        mouseover
        scroll_bottom
  **/
  toSimulate : function(simulate) {
    var self = this;    
    var deferred = Q.defer();
    var time_to_wait = simulate.wait || 0;

    switch( simulate.action) {

      case "scroll_bottom":
        window.scrollTo(0,document.body.scrollHeight);
        break;

      default: 
        dom_elements = self.getDomNodes(simulate);
        self.results.logs.push("simulating " +  simulate.action + " for " + dom_elements.length + " dom items");
        dom_elements.forEach(function(dom_node) {
          jQuery(dom_node).simulate(simulate.action);
        });      
    }

    setTimeout(function() {
      deferred.resolve();

    }, time_to_wait);    

    return deferred.promise;
  },

  toWait :function() {

  },

  extractDomAttributes : function(dom_obj, required_attribute) {
    var self = this;
    var return_val = '';

    switch(required_attribute) {
      case 'href'       :
      case 'src'        :
        return_val = dom_obj[required_attribute];
        break;

      case 'innerHTML'  : 
        return_val = dom_obj.innerHTML;
        break;

      case 'innerText'  :
      case 'textContent':
      case 'address'    :
      case 'email'      :
      case 'phone'      :
        return_val = dom_obj.textContent || dom_obj.innerText;
        break;

      default : 
        return_val = required_attribute && dom_obj.getAttribute(required_attribute)
        !return_val && (return_val = dom_obj.textContent)
    }

    return return_val && return_val.trim() || ''

  }  

}


try { module && (module.exports = KrakeDomElements); } catch(e){}