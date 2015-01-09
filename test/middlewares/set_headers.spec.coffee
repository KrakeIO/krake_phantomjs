KSON = require 'kson'
testClient = require '../fixtures/test_client'
app = require '../fixtures/test_server'
setHeader = require '../../middlewares/set_headers'

describe "set_headers", ()->

  beforeEach ()=>  
    app.listen 9999
  
  afterEach ()=>
    app.close() 

  it "should set header if page does not belong to facebook.com", (done)->  
    page =
      settings : []
    krakeQueryObject =
      origin_url : "https://www.google.com/#q=what+to+do"
      
    setHeader page, krakeQueryObject, ()->
      expect(page.settings['userAgent']).toEqual 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.114 Safari/537.36'
      done()

  it "should not set header if page belongs to facebook.com", (done)->  
    page =
      settings : []
    krakeQueryObject =
      origin_url : "https://www.facebook.com/#q=what+to+do"
      
    setHeader page, krakeQueryObject, ()->
      expect(page.settings['userAgent']).toBe undefined
      done()      

  it "should set custom header if it was provided", (done)->
    page =
      settings : []
    krakeQueryObject =
      origin_url : "https://www.google.com/#q=what+to+do"
      headers: 
        "Accept-Language": "en-DE,en;q=0.5"
      
    setHeader page, krakeQueryObject, ()->
      expect(page.customHeaders).toEqual 
        "Accept-Language": "en-DE,en;q=0.5"      
      done()    

  it "should returns default Accept-Language", (done)->
    post_data = KSON.stringify(
      origin_url : "http://localhost:9999/read_headers"
      columns: [{
          col_name: "language"
          dom_query: "#accept-language"
      }]
    )

    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toBe "object"
      expect(response_obj.message.result_rows.length).toEqual 1

      expect(response_obj.message.result_rows).toEqual [
        { language: "en-SG,*"}
      ]

      done()

  it "should returns custom Accept-Language", (done)->
    post_data = KSON.stringify(
      origin_url : "http://localhost:9999/read_headers"
      columns: [{
          col_name: "language"
          dom_query: "#accept-language"
      }]
      headers:
        "Accept-Language": "en-DE,en;q=0.5"
    )

    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toBe "object"
      expect(response_obj.message.result_rows.length).toEqual 1

      expect(response_obj.message.result_rows).toEqual [
        { language: "en-DE,en;q=0.5"}
      ]

      done()

  it "should returns custom Accept-Language case insentively", (done)->
    post_data = KSON.stringify(
      origin_url : "http://localhost:9999/read_headers"
      columns: [{
          col_name: "language"
          dom_query: "#accept-language"
      }]
      headers:
        "accept-language": "en-DE,en;q=0.5"
    )

    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toBe "object"
      expect(response_obj.message.result_rows.length).toEqual 1

      expect(response_obj.message.result_rows).toEqual [
        { language: "en-DE,en;q=0.5"}
      ]

      done()