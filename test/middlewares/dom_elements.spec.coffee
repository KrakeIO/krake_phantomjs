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
          col_name: "what is on your mind",
          dom_query: "#my_changing_mind"
          simulate:
            dom_query: "#my_changing_mind",
            action: "click"
      }]
    )

    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toBe "object"
      expect(typeof response_obj.message.result_rows).toBe "object"
      expect(response_obj.message.result_rows[0]["what is on your mind"]).toEqual "My mind has changed"
      done() 