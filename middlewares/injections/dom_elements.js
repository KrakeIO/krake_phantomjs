// Gets the value of a DOM attribute
var KrakeDomElements = {
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

  },

  // Returns an array of dom elements values given a Column
  getDomNodesValues : function(curr_column) {
    var self = this;

    if(curr_column.simulate) {
      self.toClick(curr_column.simulate);
    }

    dom_elements = self.getDomNodes(curr_column);

    return dom_elements.map(function(item) {
      return self.extractDomAttributes(item, curr_column['required_attribute']);
    });

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
  toClick : function(simulate) {
    var self = this;
    dom_elements = self.getDomNodes(simulate);
    dom_elements.forEach(function(dom_node) {
      jQuery(dom_node).simulate(simulate.action);
    });
  }

}


try { module && (module.exports = KrakeDomElements); } catch(e){}