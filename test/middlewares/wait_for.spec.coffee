fs = require 'fs'
express = require 'express'
http = require 'http'
KSON = require 'kson'
request = require 'request'
testClient = require '../fixtures/test_client'

# Running test server
app = require '../fixtures/test_server'

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

  it "should respond with no html", (done)->

    post_data = KSON.stringify(
      "origin_url": "http://localhost:9999/wait_for"
      "columns": [{
        "col_name": "long_awaited"
        "dom_query": "#iam"
      }],
      "wait_for" :
        "dom_query": "#iam"
        "wait": 1000
    )

    testClient post_data, (response_obj)=>
      expect( response_obj.message.result_rows.length ).toEqual 0
      done() 

  it "should respond with loaded html", (done)->

    post_data = KSON.stringify(
      "origin_url": "http://localhost:9999/wait_for"
      "columns": [{
        "col_name": "long_awaited"
        "dom_query": "#iam"
      }],
      "wait_for" :
        "dom_query": "#iam"
        "wait": 4000
    )

    testClient post_data, (response_obj)=>
      expect(typeof response_obj.message.result_rows[0]).toBe "object"
      expect(response_obj.message.result_rows[0]['long_awaited']).toEqual "I am loaded"
      done() 

