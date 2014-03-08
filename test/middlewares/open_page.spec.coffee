KSON = require 'kson'
testClient = require '../fixtures/test_client'
app = require '../fixtures/test_server'

describe "open_page", ()->

  beforeEach ()=>  
    app.listen 9999
  
  afterEach ()=>
    app.close()
  
  it "should open page with POST method when method is defined", (done)->

    post_data = KSON.stringify(
      "origin_url": "http://localhost:9999/open_post_page"
      "method" : "post"
      "columns": [{
        "col_name": "res1"
        "dom_query": "#value1"
      },{
        "col_name": "res2"
        "dom_query": "#value2"
      }],
      "post_data" :
        "param1" : "hello"
        "param2" : "world"
    )
    
    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toBe "object"
      expect(typeof response_obj.message.result_rows).toBe "object"
      expect(typeof response_obj.message.result_rows[0]).toBe "object"
      expect(response_obj.message.result_rows[0]['res1']).toEqual "hello"
      expect(response_obj.message.result_rows[0]['res2']).toEqual "world"
      done()