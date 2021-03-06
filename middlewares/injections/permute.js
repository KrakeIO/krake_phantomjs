// To be injected on the fly into the loaded page

// Interacts with form elements defined in explanatory to get all possible permutations of these elements 
// and extract corresponding values in both themselves and their responses
// permuted_columns : {
//   handles: [{
//     col_name : "radio 1",
//     dom_query : "input#input1"
//   },{
//     col_name : "select 2",
//     dom_query : "select#select1"
//   },{
//     col_name : "checkbox 3",
//     dom_query : "input#checkbox3"
//   },{
//     col_name : "images 4",
//     dom_query : "input#checkbox3",
//     require_attribute : "href"
//   },{
//     col_name : "div 5",
//     xpath : "//*[@class='variant_names']"
//   },{    
//   ...
//   }],
//   responses: [{
//     col_name : "response 1",
//     dom_query : "div#response1"
//   },{
//     col_name : "response 2",
//     dom_query : "span#response2"
//   }]
// }

var KrakePermute = {

  init: function(krake_definition) {
    var self = KrakePermute;
    permuted_columns = krake_definition && krake_definition.permuted_columns || {}
    self.handles =  permuted_columns.handles || [];
    self.responses = permuted_columns.responses || [];
    self.results = [];
    self.logs = [];
  },

  permute : function(callback){
    var self = KrakePermute;    
    self.permuteStep(0, 0, {}, function(){
      self.logs.push("all permutations has been completed");
      callback && callback();
    });
  },

  permuteStep: function(curr_hdl_index, curr_hdl_items_index, parent_value_chain, callback) {
    var self = KrakePermute;
    curr_hdl_index = curr_hdl_index || 0;
    curr_hdl_items_index = curr_hdl_items_index || 0;
    parent_value_chain = parent_value_chain || {};

    curr_col_els = self.getLevelColumnElements(curr_hdl_index);

    if(!curr_col_els[curr_hdl_items_index]) {
      self.skipLevel(curr_hdl_index, parent_value_chain, callback);
      return;
    }

    curr_el = curr_col_els[curr_hdl_items_index];

    self.logs.push("permutation step: ");
    self.logs.push("  col_name: " + self.getLevelName(curr_hdl_index));
    self.logs.push("  current handles column item: " + self.extractDomAttributes(curr_el, self.getLevelAttribute(curr_hdl_index)));

    self.makeElementSelected(curr_el, self.getLevelChecksum(curr_hdl_index));
    curr_value_chain = self.getExtendedValueChain(parent_value_chain, curr_el, col_query);

    // Go to next level
    if(curr_hdl_index < self.handles.length -1) {
      self.goDeep(curr_hdl_index, curr_hdl_items_index, curr_value_chain, parent_value_chain, callback);

    // When at the deepest level
    } else {
      self.results = self.results.concat(self.getFullValueChains(curr_value_chain));

      // Go to next sibiling
      if (curr_hdl_items_index < curr_col_els.length -1) {
        self.goWide(curr_hdl_index, curr_hdl_items_index, parent_value_chain, callback);        
      }
      // no more sibiling
      else {
        self.logs.push("last tree sibilig callback: ");
        self.logs.push("  col_name: " + self.getLevelName(curr_hdl_index));
        self.logs.push("  current handles column item: " + self.extractDomAttributes(curr_el, self.getLevelAttribute(curr_hdl_index)));
        if(callback) {
          self.logs.push("  has parent callback");
          callback && callback();
        } else {
          self.logs.push("  has no parent callback");
        }

      }
        
    }
  },

  getExtendedValueChain: function(parent_value_chain, dom_node, column_query) {
    var self = KrakePermute;    
    parent_value_chain = parent_value_chain || {};
    value_chain = JSON.parse(JSON.stringify(parent_value_chain));
    value_chain = value_chain || {};
    value_chain[column_query.col_name] = self.extractDomAttributes( dom_node, column_query['required_attribute']);

    return value_chain;
  },

  getFullValueChains: function(value_chain) {
    var self = KrakePermute;
    if(!self.responses || self.responses.length == 0) return [value_chain];

    value_chain = value_chain || {}
    results = []
    self.responses.forEach(function(response_col) {
      self.getColumnElements(response_col).forEach(function(dom_node, index) {
        results[index] = curr_result = results[index] || JSON.parse(JSON.stringify(value_chain));
        curr_result[response_col.col_name] = self.extractDomAttributes( dom_node, response_col['required_attribute']);
      });
    });
    return results;
  },

  extractDomAttributes: function(dom_node, required_attribute) {
    return KrakeDomElements.extractDomAttributes( dom_node,  required_attribute);
  },

  skipLevel: function(curr_hdl_index, parent_value_chain, callback) {
    var self = KrakePermute;
    if(curr_hdl_index < self.handles.length -1) {    
      self.logs.push("skipping empty level");
      self.permuteStep(curr_hdl_index + 1, 0, parent_value_chain, callback);

    } else {
      self.logs.push("no more level to skip to");      
      self.results = self.results.concat(self.getFullValueChains(parent_value_chain));      
      callback && callback();

    }
  },

  goDeep: function(curr_hdl_index, curr_hdl_items_index, curr_value_chain, parent_value_chain, callback) {
    var self = KrakePermute;
    self.permuteStep(curr_hdl_index + 1, 0, curr_value_chain, function() {

      self.logs.push("finished sub-tree: ");
      self.logs.push("  col_name: " + self.getLevelName(curr_hdl_index));
      self.logs.push("  current handle column item: " + self.extractDomAttributes(
        self.getLevelColumnElements(curr_hdl_index)[curr_hdl_items_index], 
        self.getLevelAttribute(curr_hdl_index)
      ));

      if(curr_hdl_items_index < self.getLevelColumnElements(curr_hdl_index).length - 1) {
        self.goWide(curr_hdl_index, curr_hdl_items_index, parent_value_chain, callback);

      } else {
        if(callback) {
          self.logs.push("  no more sibiling");
          self.logs.push("  has parent callback");
          callback && callback();
        } else {
          self.logs.push("  has no parent callback");
        }
      }

    });
  },

  goWide: function(curr_hdl_index, curr_hdl_items_index, parent_value_chain, callback) {
    var self = KrakePermute;
    self.permuteStep(curr_hdl_index, curr_hdl_items_index + 1, parent_value_chain, callback);
  },

  getLevelName: function(curr_hdl_index) {
    var self = KrakePermute;
    return self.handles[curr_hdl_index]['col_name'] || false;
  },

  getLevelAttribute: function(curr_hdl_index) {
    var self = KrakePermute;
    return self.handles[curr_hdl_index]['required_attribute'];
  },

  getLevelChecksum: function(curr_hdl_index) {
    var self = KrakePermute;
    return self.handles[curr_hdl_index]['selected_checksum'] || false;
  },

  getLevelColumnElements: function(curr_hdl_index) {
    var self = KrakePermute;
    col_query = self.handles[curr_hdl_index];
    return self.getColumnElements(col_query);
  },

  getColumnElements: function(column_obj) {
    var self = KrakePermute;
    column_obj.dom_query && (curr_col_elements = self.getDomListJquery(column_obj.dom_query));
    column_obj.xpath && (curr_col_elements = self.getDomListXpath(column_obj.xpath));
    curr_col_elements = curr_col_elements || [];
    return curr_col_elements;
  },

  getDomListXpath: function(xpath) {
    col_elements = []
    xpath_iterator = document.evaluate(xpath, document)
    while(el = xpath_iterator.iterateNext()) {
      col_elements.push(el);
    }
    return col_elements;
  },

  getDomListJquery: function(dom_query) {
    col_elements = []
    jQuery(dom_query).each(function(index, item){
      col_elements.push(item);
    });
    return col_elements;
  },

  makeElementSelected: function(dom_node, class_checksum) {
    var self = KrakePermute;
    switch(dom_node.nodeName) {
      case "OPTION" :
        self.changeSelectIndex(dom_node);
        break;

      default :
        self.toggleClickableElementActive(dom_node, class_checksum);
        break;

    }
  },

  changeSelectIndex: function(option_node) {
    var self = KrakePermute;
    self.logs.push("  selecting option:");
    self.logs.push("    " + jQuery(option_node).html());

    jQuery(option_node).attr("selected", "selected");
    var select_parent = jQuery('select').has(option_node)[0];
    jQuery(select_parent).trigger('change');
    self.logs.push("    new select value: " + jQuery(select_parent).val());
  }, 

  toggleClickableElementActive: function(dom_node, active_class_checksum) {
    var self = KrakePermute;

    self.clickElement(dom_node);
    if(active_class_checksum && !(
        jQuery(dom_node).hasClass(active_class_checksum) || 
        jQuery(dom_node).parent(active_class_checksum).length > 0
      )) {
        self.clickElement(dom_node);
    }

  },

  clickElement: function(dom_node) {
    jQuery(dom_node).simulate('click');
  }
}

try { module && (module.exports = KrakePermute); } catch(e){}