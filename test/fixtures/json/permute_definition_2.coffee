krake_definition = {
  "origin_url" : "http://item.taobao.com/item.htm?id=2198023897",
  "permuted_columns" : {
    "handles": [{
      "col_name" : "measurement",
      "dom_query" : ".tb-prop:nth-child(1) a",
      "selected_checksum" : ".tb-selected"
    },{
      "col_name" : "color",
      "dom_query" : ".tb-prop:nth-child(2) a",
      "selected_checksum" : ".tb-selected"
    }],
    "responses": [{
      "col_name" : "enlarged_image",
      "dom_query" : ".tb-gallery img#J_ImgBooth",
      "required_attribute" : "src"
    },{
      "col_name" : "stock",
      "dom_query" : "#J_SpanStock"
    }]      
  }
}

module.exports = krake_definition