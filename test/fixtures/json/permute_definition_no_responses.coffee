krake_definition =
  "permuted_columns" :
    "handles": [{
      "col_name" : "radio 1",
      "dom_query" : "input#input1",
      "selected_checksum" : ".tb-selected"
    },{
      "col_name" : "select 2",
      "dom_query" : "select#select1"
    },{
      "col_name" : "checkbox 3",
      "dom_query" : "input#checkbox3"
    },{
      "col_name" : "images 4",
      "dom_query" : "input#checkbox3",
      "require_attribute" : "href"
    },{
      "col_name" : "div 5",
      "xpath" : "//*[@class='variant_names']"
    }]

module.exports = krake_definition