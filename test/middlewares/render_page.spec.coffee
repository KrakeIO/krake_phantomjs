fs = require 'fs'
express = require 'express'
http = require 'http'
KSON = require 'kson'
request = require 'request'

# Running test server
app = express.createServer()
app.configure ()->
  app.use(express.cookieParser())
  app.use(express.bodyParser())
  app.use(app.router)
app.post '/', (req, res)->
  pageBody = '<html><body><div id="value1">' + req.body.param1 + '</div>' +
    '<div id="value2">' + req.body.param2 + '</div></body></html>'
  res.send pageBody

describe "phantom server render testing", ()->

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

    post_options = 
      host: 'localhost'
      port: 9701
      path: '/extract'
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'Content-Length': post_data.length

    post_req = http.request post_options, (res)=>
      res.setEncoding('utf8');
      res.on 'data', (raw_data)=>
        response_obj = KSON.parse raw_data
        expect(fs.readdirSync(@test_folder).length).toEqual 3
        expect(fs.existsSync @test_folder + "screen-shot.pdf").toBe true
        expect(fs.existsSync @test_folder + "screen-capture.html").toBe true
        done() 


    # write parameters to post body
    post_req.write(post_data)
    post_req.end()

