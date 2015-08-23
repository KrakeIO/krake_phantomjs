KSON = require 'kson'
testClient = require '../fixtures/test_client'
app = require '../fixtures/test_server'

setPostedCookies = require '../../middlewares/set_posted_cookies'

describe "set_posted_cookies", ()->

  beforeEach ()=>  
    app.listen 9999
  
  afterEach ()=>
    app.close()

  it "should open attach stringified cookies as post params ", (done)->

    global.phantom = {}
    page = {}
    
    krakeQueryObject =      
      "origin_url": "http://localhost:9999/",
      "columns": [
        {
            "col_name": "body",
            "dom_query" : "body"
        },
        {
            "col_name": "name",
            "xpath": "/html[1]/body[1]/div/div[1]/div[2]/div[1]/div[5]/div[3]/ol[1]/li[1]/div[1]/h3[1]/a[1]"
        }
      ],
      "set_post_cookies": true,
      "cookies": [
          {
              "domain": "localhost",
              "hostOnly": true,
              "httpOnly": false,
              "name": "X-LI-IDC",
              "path": "/cookie",
              "secure": false,
              "session": true,
              "storeId": "0",
              "value": "C1"
          }
      ]
      
    setPostedCookies page, krakeQueryObject, ()->
      expect(typeof krakeQueryObject.post_data).toBe "object"
      expect(typeof krakeQueryObject.post_data.post_cookies).toBe "string"
      done()

  it "should send stringified cookies as post params to test server", (done)->
    cookies = [
          {
              "domain": "localhost",
              "hostOnly": true,
              "httpOnly": false,
              "name": "X-LI-IDC",
              "path": "/cookie",
              "secure": false,
              "session": true,
              "storeId": "0",
              "value": "C1"
          }
      ]
    post_data = KSON.stringify(
      "origin_url": "http://localhost:9999/set_posted_cookie"
      "method" : "post"
      "columns": [{
        "col_name": "res1"
        "dom_query": "#post_cookies"
      }],
      "set_post_cookies": true,
      "cookies": cookies
    )
    
    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toBe "object"
      expect(typeof response_obj.message.result_rows).toBe "object"
      expect(typeof response_obj.message.result_rows[0]).toBe "object"
      expect( JSON.parse( response_obj.message.result_rows[0]['res1'] ) ).toEqual cookies
      done()