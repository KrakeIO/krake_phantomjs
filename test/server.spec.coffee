express = require 'express'
KSON = require 'kson'
request = require 'request'
testClient = require './fixtures/test_client'

jasmine.getEnv().defaultTimeoutInterval = 20000

describe "testing to make sure phantomjs server is running", ()->
  it "should respond with I am Krake", (done)->
    request "http://localhost:9701/", (error, response, body)->
      expect(body).toEqual "I Kraked"
      done()

describe "testing badly formed JSON", ()->
  it "should respond with error message", (done)->
    testClient '{what the fuck', (response_obj)-> 
      expect(response_obj.status).toEqual "error"
      expect(response_obj.message).toEqual "cannot render Krake query object, SyntaxError: KSON.parse"
      done()
    
describe "phantom server cookie testing", ()->

  app = false
  beforeEach ()=>
    # Running test server
    app = module.exports = express.createServer()
    app.configure ()->
      app.use(express.cookieParser())
      app.use(express.bodyParser())
      app.use(app.router)
    app.get '/', (req, res)->
      if req.cookies['x-li-idc'] == 'C1'
        res.send 'cookie header received'
      else
        res.send 'cookie header not received'
    app.listen 9999
  
  afterEach ()=>
    app.close()
  
  it "should respond with success as well as cookie received", (done)->
    post_data = KSON.stringify(
      "origin_url": "http://localhost:9999/"
      "columns": [{
        "col_name": "body"
        "dom_query" : "body"
      },{
        "col_name": "name"
        "xpath": "/html[1]/body[1]/div/div[1]/div[2]/div[1]/div[5]/div[3]/ol[1]/li[1]/div[1]/h3[1]/a[1]"
      }]
      "cookies": [{
        "domain": "localhost"
        "hostOnly": true
        "httpOnly": false
        "name": "X-LI-IDC"
        "path": "/cookie"
        "secure": false
        "session": true
        "storeId": "0"
        "value": "C1"
      }]
    )

    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toBe "object"
      expect(response_obj.message.result_rows[0].body).toEqual "cookie header received"
      done()

describe "test extraction of Geolocation from Google", ()->
  it "should respond with success and an object ", (done)->

    post_data = KSON.stringify(
      "exclude_jquery" : true,
      "origin_url": "http://maps.googleapis.com/maps/api/geocode/xml?sensor=false&address=29%20Club%20Street+Singapore",
      "columns": [{
          "col_name": "Latitude",
          "xpath": "//GeocodeResponse/result/geometry/location/lat",
          "required_attribute" : 'textContent'
        },{
          "col_name": "Longitude",
          "xpath": "//GeocodeResponse/result/geometry/location/lng",
          "required_attribute" : 'textContent'              
        },{
          "col_name": "Postal Code",
          "xpath": "//GeocodeResponse/result/address_component[5]/long_name",
          "required_attribute" : 'textContent'              
      }]
    )

    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toBe "object"
      expect(typeof response_obj.message.result_rows).toBe "object"
      expect(typeof response_obj.message.result_rows[0]).toBe "object"
      expect(typeof response_obj.message.result_rows[0].Latitude).toEqual "string"
      expect(typeof response_obj.message.result_rows[0].Longitude).toEqual "string"
      expect(response_obj.message.result_rows[0]['Postal Code']).toEqual "Singapore"
      done() 

describe "test extraction of Product Listing Info from MDScollections using Xpath", ()->
  it "should respond with success and an object ", (done)->
    post_data = KSON.stringify(
      origin_url : "http://www.mdscollections.com/cat-new-in-clothing.cfm"
      columns : [{
          col_name : 'product_name'
          xpath : '//a[@class="listing_product_name"]'
          is_index : true
        },{
          col_name : 'product_price'
          xpath : '//span[@class="listing_price"]'
      }]
    )

    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toBe "object"
      expect(typeof response_obj.message.result_rows).toBe "object"
      expect(typeof response_obj.message.result_rows[0]).toBe "object"
      expect(typeof response_obj.message.result_rows[0].product_name).toBe "string"        
      expect(typeof response_obj.message.result_rows[0].product_price).toBe "string"
      expect(response_obj.message.result_rows.length).toBeGreaterThan 5
      done()

describe "testing Krake definition with no origin url", ()->
  it "should respond with an error ", (done)->
    post_data = KSON.stringify(
      origin_url : 'http://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=iphone'      
      data :
        source : 'amazon'
    )

    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "error"
      expect(response_obj.message).toEqual "columns not defined"
      done() 
    
describe "testing Krake definition with no origin url", ()->
  it "should respond with an error ", (done)->
    post_data = KSON.stringify(
      columns: [{
          col_name: 'product_name'
          dom_query: '.lrg.bold'
        },{
          col_name: 'product_image'
          dom_query: '.image img'
          required_attribute : 'src'        
        },{        
          col_name : 'price'
          dom_query : 'span.bld.lrg.red' 
        }, {
          col_name: 'detailed_page'
          dom_query: '.newaps a'
          required_attribute : 'href'
          options :
            columns : [{
              col_name : 'product_description'
              dom_query : '#productDescription'
            }]
      }]
      data :
        source : 'amazon'
    )

    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "error"
      expect(response_obj.message).toEqual "origin_url not defined"
      done() 
    
describe "testing against non-existant url", ()->
  it "should respond with error and error an empty array for result_rows attribute in message object ", (done)->
    post_data = KSON.stringify(
      origin_url : 'http://somewhere_over_the_rainbow'
      columns: [{
          col_name: 'product_name'
          dom_query: '.lrg.bold'
        },{
          col_name: 'product_image'
          dom_query: '.image img'
          required_attribute : 'src'        
        },{        
          col_name : 'price'
          dom_query : 'span.bld.lrg.red' 
        }, {
          col_name: 'detailed_page'
          dom_query: '.newaps a'
          required_attribute : 'href'
          options :
            columns : [{
              col_name : 'product_description'
              dom_query : '#productDescription'
            }]
      }]
      data :
        source : 'amazon'
    )

    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "error"
      expect(response_obj.message.result_rows).toEqual []
      done() 
    
describe "test JSON parse UTF8 in phantomjs", ()->
  it "should respond with success", (done)->
    try
      payload = '{"dom_query":"li:contains(\'商店地址\')"}'
      payload_obj = JSON.parse payload
    catch e

    expect(typeof payload_obj).toBe "object"          
    expect(payload_obj["dom_query"]).toEqual "li:contains('商店地址')"
    done()
    
describe "testing well formed Krake definition", ()->
  it "should respond with success and an object ", (done)->
    post_data = KSON.stringify(
      "exclude_jquery" : true
      "origin_url": "http://maps.googleapis.com/maps/api/geocode/xml?sensor=false&address=29%20Club%20Street+Singapore"
      "columns": [{
        "col_name": "Latitude"
        "xpath": "//GeocodeResponse/result/geometry/location/lat"
        required_attribute : 'textContent'
      },{
        "col_name": "Longitude"
        "xpath": "//GeocodeResponse/result/geometry/location/lng"
        required_attribute : 'textContent'              
      },{
        "col_name": "Postal Code"
        "xpath": "//GeocodeResponse/result/address_component[5]/long_name"
        required_attribute : 'textContent'              
      }]
    )
    
    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toBe "object"
      done() 
    
describe "Test to ensure UTF8 encoding gets handled properly", ()->
  it "should respond with success and an object ", (done)->
    post_data = encodeURIComponent(KSON.stringify('全部商品'))
    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "error"
      done() 
    
describe "to ensure special Yalwa corner case gets handled properly", ()->
  it "should respond with success and an object ", (done)->
    post_data = KSON.stringify(
      origin_url : "http://www.yalwa.sg/",
      columns: [{
          col_name: "cat 1",
          dom_query: "#tabs a"
      }]
    )

    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toBe "object"
      done() 