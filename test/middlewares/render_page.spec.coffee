fs = require 'fs'
express = require 'express'
http = require 'http'
KSON = require 'kson'
request = require 'request'
testClient = require '../fixtures/test_client'

# Running test server
app = app = require '../fixtures/test_server'

describe "render_page", ()->

  beforeEach ()->
    @test_folder = __dirname + '/../../temp/'
    fs.readdirSync(@test_folder).filter((file)=>
      file.indexOf("html") > -1 or file.indexOf("pdf") > -1
    ).forEach (file)=>
      fs.unlinkSync @test_folder + file

    app.listen 9999
  
  afterEach ()->
    app.close()

  it "should respond with render pdf and html outputs in the temp folder", (done)->

    expect(fs.readdirSync(@test_folder).length).toEqual 1
    post_data = KSON.stringify(
      "origin_url": "http://localhost:9999"
      "columns": [{
        "col_name": "res1"
        "dom_query": "#value1"
      },{
        "col_name": "res2"
        "dom_query": "#value2"
      }],
      "method" : "post"
      "post_data" :
        "param1" : "hello"
        "param2" : "world"
      "render": true
    )

    testClient post_data, (response_obj)=>
        expect(fs.readdirSync(@test_folder).length).toEqual 3
        expect(fs.existsSync @test_folder + "screen-shot.pdf").toBe true
        expect(fs.existsSync @test_folder + "screen-capture.html").toBe true
        done() 

