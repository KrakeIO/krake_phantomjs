KSON = require 'kson'
testClient = require '../fixtures/test_client'
app = require '../fixtures/test_server'

describe "get_cookies", ()->

  beforeEach ()=>  
    app.listen 9999
  
  afterEach ()=>
    app.close()
  
  it "should return cookies set by page along with results", (done)->

    post_data = KSON.stringify(
      "origin_url": "http://localhost:9999/open_cookie_jar"
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
      expect(typeof response_obj.message.cookies).toBe "object"
      server_cookie = response_obj.message.cookies.filter (obj)->
        obj.name == 'my_cookie'
      expect(server_cookie.length).toEqual 1
      expect(server_cookie[0]['value']).toEqual "my_cookie_value"
      done()