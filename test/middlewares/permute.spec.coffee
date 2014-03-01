KSON = require 'kson'
testClient = require '../fixtures/test_client'
app = require '../fixtures/test_server'

describe "permutate", ->

  beforeEach ()->  
    app.listen 9999
    @krake_definition = {
      "origin_url" : "http://localhost:9999/form_simple",
      "permuted_columns" : {
        "handles": [{
          "col_name" : "radio value",
          "dom_query" : "input[type='radio']",
          "required_attribute" : "value"
        },{
          "col_name" : "option value",
          "dom_query" : "option",
          "required_attribute" : "value"
        },{
          "col_name" : "checkbox value",
          "dom_query" : "input[type='checkbox']",
          "required_attribute" : "value"
        },{
          "col_name" : "clickable div value",
          "dom_query" : ".div.clicklables",
          "selected_checksum" : ".selected"
        },{
          "col_name" : "clickable image value",
          "dom_query" : ".f_elements.clk_img",
          "selected_checksum" : ".selected_img",
          "required_attribute" : "src"
        }],
        "responses": [{
          "col_name" : "response1",
          "dom_query" : "#response1"
        },{
          "col_name" : "response2",
          "dom_query" : "#response2"
        }]
      }
    }

  
  afterEach ()->
    app.close()

  it "should click on each radio element and return rows of results equals to the number of elements in set", (done)->

    krake_definition =
      "origin_url" : "http://localhost:9999/form_simple"
      "permuted_columns" :
        "handles": [{
          "col_name" : "radio value"
          "dom_query" : "input[type='radio']"
          "required_attribute" : "value"
        }]

    testClient KSON.stringify(krake_definition), (response_obj)-> 
      expect(response_obj.message.result_rows.length).toEqual 3
      done()

  it "should show permute and return combination values from two sets of elements", (done)->

    krake_definition =
      "origin_url" : "http://localhost:9999/form_simple"
      "permuted_columns" :
        "handles": [{
          "col_name" : "radio value"
          "dom_query" : "input[type='radio']"
          "required_attribute" : "value"
        },{
          "col_name" : "option value"
          "dom_query" : "option"
        }]

    testClient KSON.stringify(krake_definition), (response_obj)-> 
      expect(response_obj.message.result_rows.length).toEqual 9      
      done()

  it "should click on each in item list and get the corresponding required_attribute of that item", (done)->

    krake_definition =
      "origin_url" : "http://localhost:9999/form_simple"
      "permuted_columns" :
        "handles": [{
          "col_name" : "radio value"
          "dom_query" : "input[type='radio']"
          "required_attribute" : "value"
        }]

    testClient KSON.stringify(krake_definition), (response_obj)-> 
      expect(response_obj.message.result_rows[0]["radio value"]).toEqual "radio1"
      done()

  it "should permute across all option items", (done)->
    krake_definition =
      "origin_url" : "http://localhost:9999/form_simple"
      "permuted_columns" :
        "handles": [{
          "col_name" : "option value",
          "dom_query" : "option",
          "required_attribute" : "value"
        }]

    testClient KSON.stringify(krake_definition), (response_obj)-> 
      expect(response_obj.message.result_rows.length).toEqual 3
      done()

  it "should permute across all option items with  combined with div items", (done)->
    krake_definition =
      "origin_url" : "http://localhost:9999/form_simple"
      "permuted_columns" :
        "handles": [{
          "col_name" : "option value",
          "dom_query" : "option",
          "required_attribute" : "value"
        },{
          "col_name" : "clickable div value",
          "dom_query" : ".div.clicklables",
          "selected_checksum" : ".selected"          
        }]

    testClient KSON.stringify(krake_definition), (response_obj)-> 
      expect(response_obj.message.result_rows.length).toEqual 9
      done()

  it "should permute across all option items with combined with div items and get responding response cols", (done)->
    krake_definition =
      "origin_url" : "http://localhost:9999/form_simple"
      "permuted_columns" :
        "handles": [{
          "col_name" : "option value",
          "dom_query" : "option",
          "required_attribute" : "value"
        },{
          "col_name" : "clickable div value",
          "dom_query" : ".div.clicklables",
          "selected_checksum" : ".selected"          
        }]
        "responses": [{
          "col_name" : "response1",
          "dom_query" : "#response1"
        },{
          "col_name" : "response2",
          "dom_query" : "#response2"
        }]

    testClient KSON.stringify(krake_definition), (response_obj)-> 
      expect(response_obj.message.result_rows.length).toEqual 9
      done()

  it "should click on each in item list and get the corresponding required_attributes of all other observed items", (done)->

    krake_definition = 
      "origin_url" : "http://localhost:9999/form_simple"
      "permuted_columns" :
        "handles": [{
        #   "col_name" : "checkbox value",
        #   "dom_query" : "input[type='checkbox']",
        #   "required_attribute" : "value"
        # },{
          "col_name" : "clickable div value",
          "dom_query" : ".div.clicklables",
          "selected_checksum" : ".selected"          
        },{
          "col_name" : "option value",
          "dom_query" : "option",
          "required_attribute" : "value"
        },{          
          "col_name" : "radio value",
          "dom_query" : "input[type='radio']",
          "required_attribute" : "value"
        # },{
        #   "col_name" : "clickable image value",
        #   "dom_query" : ".f_elements.clk_img",
        #   "selected_checksum" : ".selected_img",
        #   "required_attribute" : "src"
        }]
        "responses": [{
          "col_name" : "response1",
          "dom_query" : "#response1"
        },{
          "col_name" : "response2",
          "dom_query" : "#response2"
        }]

    testClient KSON.stringify(krake_definition), (response_obj)-> 
      expect(response_obj.message.result_rows[0]['response1'].length).toBe > 1
      done()

  it "should click on each in item list and get the corresponding required_attributes of all other observed items", (done)->

    krake_definition = 
      "origin_url" : "http://localhost:9999/form_simple"
      "permuted_columns" :
        "handles": [{
        #   "col_name" : "checkbox value",
        #   "dom_query" : "input[type='checkbox']",
        #   "required_attribute" : "value"
        # },{
          "col_name" : "clickable div value",
          "dom_query" : ".div.clicklables",
          "selected_checksum" : ".selected"          
        },{
          "col_name" : "option value",
          "dom_query" : "option",
          "required_attribute" : "value"
        },{          
          "col_name" : "radio value",
          "dom_query" : "input[type='radio']",
          "required_attribute" : "value"
        # },{
        #   "col_name" : "clickable image value",
        #   "dom_query" : ".f_elements.clk_img",
        #   "selected_checksum" : ".selected_img",
        #   "required_attribute" : "src"
        }]
        "responses": [{
          "col_name" : "response1",
          "dom_query" : "#response1"
        },{
          "col_name" : "response2",
          "dom_query" : "#response2"
        }]

    testClient KSON.stringify(krake_definition), (response_obj)-> 
      expect(response_obj.message.result_rows.length).toEqual 27
      done()


  it "should finish generating all possible handles permutation", (done)->
    testClient KSON.stringify(@krake_definition), (response_obj)-> 
      expect(response_obj.message.result_rows.length).toEqual 243
      done()

  it "should change the selected index/option of a select object and get the corresponding required_attribute of that item", (done)->
    testClient KSON.stringify(@krake_definition), (response_obj)-> 
      options3_results = response_obj.message.result_rows.filter (row)->
        row["option value"] == "options3"
      expect((options3_results).length).toEqual == 81

      options2_results = response_obj.message.result_rows.filter (row)->
        row["option value"] == "options2"
      expect((options2_results).length).toEqual == 81

      options1_results = response_obj.message.result_rows.filter (row)->
        row["option value"] == "options1"
      expect((options1_results).length).toEqual == 81      
      done()
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