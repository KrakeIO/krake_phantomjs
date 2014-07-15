express = require 'express'

app = express.createServer()
app.configure ()->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'ejs'
  app.use express.cookieParser()
  app.use express.bodyParser()
  app.use(express["static"](__dirname + "/public"))
  app.use(app.router)

app.post '/', (req, res)->
  res.render 'post_method', { param1: req.body.param1, param2: req.body.param2}

app.get '/', (req, res)->
  res.render 'post_method', { param1: req.query.param1, param2: req.query.param2}  

app.post '/success', (req, res)->
  res.render 'success'

app.get '/success', (req, res)->
  res.render 'success'

app.get '/next_page_js', (req, res)->
  res.render 'next_page_js'

app.get '/next_page_get', (req, res)->
  res.render 'next_page_get'

app.get '/next_page_post', (req, res)->
  res.render 'next_page_post'

app.get '/next_page_empty', (req, res)->
  res.render 'next_page_empty'

app.get '/next_page_ajax', (req, res)->
  res.render 'next_page_ajax'

app.get '/next_page_ajax_double', (req, res)->
  res.render 'next_page_ajax_double'

app.get '/next_page_non_html', (req, res)->
  res.render 'next_page_non_html'

app.get '/var_query', (req, res)->
  res.render 'var_query'

app.get '/success_delayed', (req, res)->
  setTimeout ()=>
    res.render 'success'
  , 500

app.post '/open_post_page', (req, res)->
  res.render 'post_method',
    param1: req.body.param1
    param2: req.body.param2

app.get '/open_cookie_jar', (req, res)->
  res.cookie 'my_cookie', 'my_cookie_value'
  res.render 'open_cookie_jar'

app.get '/json-obj', (req, res)->
  res.send { payload: "some text"}

app.get '/timeout', (req, res)->

app.get '/form_simple', (req, res)->
  res.render 'form_simple'

app.get '/to_click', (req, res)->
  res.render 'to_click'

app.get '/to_mouseover', (req, res)->
  res.render 'to_mouseover'  

app.get '/to_mouseover_slowly', (req, res)->
  res.render 'to_mouseover_slowly'

app.get '/sudden_death', (req, res)->
  res.render 'sudden_death'

exports = module.exports = app

if !module.parent
  console.log 'Testing server listening at port 9999'
  app.listen 9999