KSON = require 'kson'
testClient = require '../fixtures/test_client'
app = require '../fixtures/test_server'

describe "open_page", ()->

  beforeEach ()=>  
    app.listen 9999
  
  afterEach ()=>
    app.close()
  
  it "should check page for sudden death with jquery and return true", (done)->

    post_data = KSON.stringify(
      "origin_url": "http://localhost:9999/sudden_death"
      "columns": [{
        "col_name": "col1"
        "dom_query": "#fun"
      },{
        "col_name": "col2"
        "dom_query": "#not-fun"
      }],
      "sudden_death": {
        "dom_query": "#captcha"
      }
    )
    
    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toBe "object"
      expect(typeof response_obj.message.result_rows).toBe "object"
      expect(typeof response_obj.message.result_rows[0]).toBe "object"
      expect(response_obj.message.result_rows[0]['col1']).toEqual "col 1"
      expect(response_obj.message.result_rows[0]['col2']).toEqual "col 2"
      expect(response_obj.message.sudden_death).toEqual true
      done()

  it "should check page for sudden death and return false", (done)->

    post_data = KSON.stringify(
      "origin_url": "http://localhost:9999/success"
      "columns": [{
        "col_name": "col1"
        "dom_query": "#fun"
      },{
        "col_name": "col2"
        "dom_query": "#not-fun"
      }],
      "sudden_death": {
        "dom_query": "#captcha_not"
      }
    )
    
    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toBe "object"
      expect(typeof response_obj.message.result_rows).toBe "object"
      expect(response_obj.message.result_rows.length).toEqual 0      
      expect(response_obj.message.sudden_death).toEqual false
      done()

 
  it "should check page for sudden death with xpath and return true", (done)->

    post_data = KSON.stringify(
      "origin_url": "http://localhost:9999/sudden_death"
      "columns": [{
        "col_name": "col1"
        "dom_query": "#fun"
      },{
        "col_name": "col2"
        "dom_query": "#not-fun"
      }],
      "sudden_death": {
        "xpath": "//img[@id='captcha']"
      }
    )
    
    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toBe "object"
      expect(typeof response_obj.message.result_rows).toBe "object"
      expect(typeof response_obj.message.result_rows[0]).toBe "object"
      expect(response_obj.message.result_rows[0]['col1']).toEqual "col 1"
      expect(response_obj.message.result_rows[0]['col2']).toEqual "col 2"
      expect(response_obj.message.sudden_death).toEqual true
      done()

  it "should return results when sudden death is not defined", (done)->

    post_data = KSON.stringify(
      "origin_url": "http://localhost:9999/sudden_death"
      "columns": [{
        "col_name": "col1"
        "dom_query": "#fun"
      },{
        "col_name": "col2"
        "dom_query": "#not-fun"
      }]
    )
    
    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toBe "object"
      expect(typeof response_obj.message.result_rows).toBe "object"
      expect(typeof response_obj.message.result_rows[0]).toBe "object"
      expect(response_obj.message.result_rows[0]['col1']).toEqual "col 1"
      expect(response_obj.message.result_rows[0]['col2']).toEqual "col 2"
      done()