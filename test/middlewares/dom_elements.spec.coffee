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
      }]
      page_actions: [{
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
      }]
      page_actions: [{
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
      }]
      page_actions: [{
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
      }]
      page_actions: [{
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

  it "should simulate two click actions and get wrong value when didn't wait", (done)->
    post_data = KSON.stringify(
      origin_url : "http://localhost:9999/times_clicked",
      columns: [{
          col_name: "how many times"
          dom_query: "#times-clicked"
      }]
      page_actions: [{
        dom_query: "#press-it"
        action: "click"
      },{
        dom_query: "#press-it"
        action: "click"        
      }]
    )

    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toBe "object"
      expect(typeof response_obj.message.result_rows).toBe "object"
      expect(response_obj.message.result_rows[0]["how many times"]).toEqual "0"
      done()

  it "should simulate two click actions and get correct value when waited", (done)->
    post_data = KSON.stringify(
      origin_url : "http://localhost:9999/times_clicked",
      columns: [{
          col_name: "how many times"
          dom_query: "#times-clicked"
      }]
      page_actions: [{
        dom_query: "#press-it"
        action: "click"
        wait: 120
      },{
        dom_query: "#press-it"
        action: "click"        
        wait: 120
      }]
    )

    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toBe "object"
      expect(typeof response_obj.message.result_rows).toBe "object"
      expect(response_obj.message.result_rows[0]["how many times"]).toEqual "2"
      done()      

  it "should return empty result_rows even if no results were harvested", (done)->
    post_data = KSON.stringify(
      origin_url : "http://localhost:9999/sudden_death",
      columns: [{
          col_name: "what is on your mind"
          dom_query: "#my_changing_mind"
      }]
    )

    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toBe "object"
      expect(typeof response_obj.message.result_rows).toBe "object"
      expect(response_obj.message.result_rows.length).toEqual 0
      done()