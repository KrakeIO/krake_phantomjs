KSON = require 'kson'
testClient = require '../fixtures/test_client'
app = require '../fixtures/test_server'

describe "permutate", ->

  beforeEach ()->  
    app.listen 9999
    @krake_definition =
      "origin_url" : "http://item.taobao.com/item.htm?id=2198023897"
      "permuted_columns" :
        "handles": [{
          "col_name" : "radio value"
          "dom_query" : "input[type='radio']"
          "required_attribute" : "value"
        },{
          "col_name" : "option value"
          "dom_query" : "option"
        },{
          "col_name" : "checkbox value"
          "dom_query" : "input[type='checkbox']"
        },{
          "col_name" : "clickable div value"
          "dom_query" : ".div.clicklables"
          "selected_checksum" : ".selected"          
        },{
          "col_name" : "clickable image value"
          "dom_query" : ".f_elements.clk_img"
          "selected_checksum" : ".selected_img"
        }],
        "responses": [{
          "col_name" : "response1"
          "dom_query" : "#response1"
        },{
          "col_name" : "response2"
          "dom_query" : "#response2"
        }]
  
  afterEach ()->
    app.close()

  it "should return radio values", (done)->
    krake_definition =
      "origin_url" : "http://localhost:9999/form_simple"
      "columns" :[{
          "col_name" : "radio value"
          "dom_query" : "input[type='radio']"
          "required_attribute" : "value"
        }]


    testClient KSON.stringify(krake_definition), (response_obj)-> 
      console.log response_obj.message.result_rows
      done()

  it "should click on each radio element and return the value of the radio button", (done)->

    krake_definition =
      "origin_url" : "http://localhost:9999/form_simple"
      "permuted_columns" :
        "handles": [{
          "col_name" : "radio value"
          "dom_query" : "input[type='radio']"
          "required_attribute" : "value"
        }]

    testClient KSON.stringify(krake_definition), (response_obj)-> 
      console.log response_obj.message
      done()        

  it "should click on each in item list and get the corresponding required_attribute of that item"
    # var evt = document.createEvent("MouseEvent");
    # evt.initMouseEvent("click", true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
    # ee = document.querySelectorAll("dl.tb-prop a")[5]
    # ee.dispatchEvent(evt)

  it "should click on each in item list and get the corresponding required_attributes of all other observed items"
    # var evt = document.createEvent("MouseEvent");
    # evt.initMouseEvent("click", true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
    # ee = document.querySelectorAll("dl.tb-prop a")[5]
    # jQuery(ee).click(function() {  
    #   get the value
    # })
    # ee.dispatchEvent(evt)

  it "should change the selected index/option of a select object and get the corresponding required_attribute of that item"  
    # dd.selectedIndex = 5;
    # jQuery(dd).trigger('change')
    # jQuery(dd).change(function(){  console.log("I was changed")})

  it "should map to parent select item if option child was given"

  it "should change the selected index/option of a select object and get the corresponding required_attributes of all other observed items"

  it "should change the selected radio object and get the corresponding required_attribute of that item"  
    # dd.selectedIndex = 5;
    # jQuery(dd).trigger('change')
    # jQuery(dd).change(function(){  console.log("I was changed")})

  it "should change the selected radio object and get the corresponding required_attributes of all other observed items"  

  it "should create multiple entries of the same record that has already been priorly harvested by the dom_elements operator"