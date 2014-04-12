// Gets the value of a DOM attribute
var KrakeDomElements = {

  init: function(krakeQueryObject) {
    var self = this;
    self.columns = krakeQueryObject.columns;
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
    if(self.columns.length > 0) self.processNextColumn(0, callback);
  },

  processNextColumn: function(index, callback) {
    var self = this;
    var curr_column = self.columns[index];
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

      if(index < self.columns.length - 1) {
        self.processNextColumn(index + 1, callback);
      } else {
        callback && callback(self.results);
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
    dom_elements = [];

    if( (typeof jQuery == "function") && curr_column.dom_query) {
      jQuery(curr_column.dom_query).each(function(index, item) {
        dom_elements.push(item);
      });

    } else if( (typeof jQuery != "function") && curr_column.dom_query) {
      doc_els = document.querySelectorAll(curr_column.dom_query);
      for(var x = 0; x < doc_els.length; x++ ) {
        dom_elements.push(doc_els[x]);
      }

    } else if(curr_column.xpath) {
      var xPathResults = document.evaluate(curr_column.xpath, document);
      while(curr_item = xPathResults.iterateNext()) {
        dom_elements.push(curr_item);
      }
    }

    return dom_elements;
  },

  // Clicks on dom elements defined in the to_click object
  toSimulate : function(simulate) {
    var self = this;    
    dom_elements = self.getDomNodes(simulate);
    self.results.logs.push("simulating " +  simulate.action + " for " + dom_elements.length + " dom items");
    dom_elements.forEach(function(dom_node) {
      jQuery(dom_node).simulate(simulate.action);
    });
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