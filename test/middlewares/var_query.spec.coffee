KSON = require 'kson'
testClient = require '../fixtures/test_client'
app = require '../fixtures/test_server'

describe "var_query", ()->
  beforeEach ()->
    app.listen 9999
  
  afterEach ()->
    app.close()

  it "should not crash server when given a var_query object", (done)->
    post_data = KSON.stringify(
      "origin_url": "http://localhost:9999/var_query"
      "columns": [{
        "col_name": "variable in dom"
        "var_query": "something"
      }]
    )

    testClient post_data, (response_obj)=>
      done()

  it "should not destroy data previously harvested by dom_query", (done)->
    post_data = KSON.stringify(
      "origin_url": "http://localhost:9999/var_query"
      "columns": [{
          "col_name": "dom_variable"
          "var_query": "something"
        },{
          "col_name": "some html stuff"
          "dom_query": "div.something"
      }]
    )

    testClient post_data, (response_obj)=>
      expect(response_obj.message.result_rows[0]['some html stuff']).toEqual "somecontent1"
      expect(response_obj.message.result_rows[1]['some html stuff']).toEqual "somecontent2"
      done()

  it "should add string referenced by var_query to results", (done)->
    post_data = KSON.stringify(
      "origin_url": "http://localhost:9999/var_query"
      "columns": [{
        "col_name": "dom_variable"
        "var_query": "something"
      }]
    )

    testClient post_data, (response_obj)=>
      expect(response_obj.message.result_rows[0]['dom_variable']).toEqual "a simple variable"
      done()

  it "should mesh array of variables to existing results", (done)->
    post_data = KSON.stringify(
      "origin_url": "http://localhost:9999/var_query"
      "columns": [{
          "col_name": "dom_variable"
          "var_query": "array_in_dom"
        },{
          "col_name": "some html stuff"
          "dom_query": "div.something"
      }]
    )

    testClient post_data, (response_obj)=>
      expect(response_obj.message.result_rows[0]['some html stuff']).toEqual "somecontent1"
      expect(response_obj.message.result_rows[1]['some html stuff']).toEqual "somecontent2"
      expect(response_obj.message.result_rows[0]['dom_variable']).toEqual "array_value1"
      expect(response_obj.message.result_rows[1]['dom_variable']).toEqual "array_value2"
      done()

  it "should extract nested attributes in the variable JSON object", (done)->
    post_data = KSON.stringify(
      "origin_url": "http://localhost:9999/var_query"
      "columns": [{
          "col_name": "dom_variable"
          "var_query": "my_json_obj['my_attr1']"
      }]
    ) 
    testClient post_data, (response_obj)=>
      expect(response_obj.message.result_rows[0]['dom_variable']).toEqual "This is a JSON object"
      done()

  it "should not crash server when given a var_query object that extracts attributes from a non-existent JSON variable", (done)->
    post_data = KSON.stringify(
      "origin_url": "http://localhost:9999/var_query"
      "columns": [{
          "col_name": "variable in dom"
          "var_query": "no_valid"
        },{
          "col_name": "some html stuff"
          "dom_query": "div.something"        
      }]
    )
    testClient post_data, (response_obj)=>
      expect(response_obj.message.result_rows[0]['some html stuff']).toEqual "somecontent1"
      expect(response_obj.message.result_rows[0]['variable in dom']).toEqual "[PHANTOM_SERVER] variable not found"
      expect(response_obj.message.result_rows[1]['some html stuff']).toEqual "somecontent2"
      done()


