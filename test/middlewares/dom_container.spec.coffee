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
      origin_url : "http://localhost:9999/dom_container",
      columns: [{
          col_name: "attr_1"
          dom_query: ".must-exist"
          dom_container: ".the-container"
        },{
          col_name: "attr_2"
          dom_query: ".might-exist"
          dom_container: ".the-container"
      }]
    )

    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toBe "object"
      expect(response_obj.message.result_rows.length).toEqual 4

      expect(response_obj.message.result_rows).toEqual [
        { attr_1: "Record 1", attr_2: "This is cool" },
        { attr_1: "Record 2", attr_2: "This is more cool" },
        { attr_1: "Record 3", attr_2: ""},
        { attr_1: "Record 4", attr_2: "This is again cool" }        
      ]

      done()