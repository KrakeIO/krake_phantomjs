KSON = require 'kson'
testClient = require '../fixtures/test_client'
app = require '../fixtures/test_server'

describe "domElements", ()->

  beforeEach ()=>  
    app.listen 9999
  
  afterEach ()=>
    app.close()
  
  it "should return correct element value", (done)->
    post_data = KSON.stringify(
      origin_url : "http://localhost:9999/to_click",
      columns: [{
          col_name: "what is on your mind"
          dom_query: "#my_changing_mind"
          simulate:
            dom_query: "#my_changing_mind"
            action: "click"
      }]
    )

    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toBe "object"
      expect(typeof response_obj.message.result_rows).toBe "object"
      expect(response_obj.message.result_rows[0]["what is on your mind"]).toEqual "My mind has changed"
      done()

  it "should simulate mouseover action and return correct value", (done)->
    post_data = KSON.stringify(
      origin_url : "http://localhost:9999/to_mouseover"
      columns: [{
          col_name: "what is on your mind"
          dom_query: "#my_changing_mind"
          simulate:
            dom_query: "#my_changing_mind"
            action: "mouseover"
      }]
    )

    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toBe "object"
      expect(typeof response_obj.message.result_rows).toBe "object"
      expect(response_obj.message.result_rows[0]["what is on your mind"]).toEqual "My mind has been glossed over"
      done()

  it "should simulate mouseover action and return correct value slowly", (done)->
    post_data = KSON.stringify(
      origin_url : "http://localhost:9999/to_mouseover_slowly",
      columns: [{
          col_name: "what is on your mind"
          dom_query: "#my_changing_mind"
          simulate:
            wait: 120            
            dom_query: "#my_changing_mind"
            action: "mouseover"
      }]
    )

    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toBe "object"
      expect(typeof response_obj.message.result_rows).toBe "object"
      expect(response_obj.message.result_rows[0]["what is on your mind"]).toEqual "My mind has been glossed over slowly"
      done()

  it "should simulate mouseover action and return incorrect value since we did it too fast", (done)->
    post_data = KSON.stringify(
      origin_url : "http://localhost:9999/to_mouseover_slowly",
      columns: [{
          col_name: "what is on your mind"
          dom_query: "#my_changing_mind"
          simulate:
            dom_query: "#my_changing_mind"
            action: "mouseover"
      }]
    )

    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toBe "object"
      expect(typeof response_obj.message.result_rows).toBe "object"
      expect(response_obj.message.result_rows[0]["what is on your mind"]).toEqual "Still glossing over"
      done()