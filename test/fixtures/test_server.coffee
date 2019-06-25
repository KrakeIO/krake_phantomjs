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

app.get '/next_page_get_bad_hashtag', (req, res)->
  res.render 'next_page_get_bad_hashtag'

app.get '/next_page_get_bad_no_href', (req, res)->
  res.render 'next_page_get_bad_no_href'  

app.get '/next_page_get_bad_same_url', (req, res)->
  res.render 'next_page_get_bad_same_url'  

app.get '/next_page_get_bad_same_url_absolute', (req, res)->
  res.render 'next_page_get_bad_same_url_absolute'  

app.get '/next_page_get_bad_params', (req, res)->
  res.render 'next_page_get_bad_params'  

app.get '/next_page_post', (req, res)->
  res.render 'next_page_post'

app.get '/next_page_get_form', (req, res)->
  res.render 'next_page_get_form'  

app.get '/next_page_post_form', (req, res)->
  res.render 'next_page_post_form'  

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

app.get '/times_clicked', (req, res)->
  res.render 'times_clicked'

app.get '/scroll_bottom', (req, res)->
  res.render 'scroll_bottom'

app.get '/sudden_death', (req, res)->
  res.render 'sudden_death'

app.get '/dom_container', (req, res)->
  res.render 'dom_container'

app.get '/read_headers', (req, res)->
  res.render 'read_headers', 
    data: req.headers

app.get '/wait_for', (req, res)->
  res.render 'wait_for'

app.post '/set_posted_cookie', (req, res)->
  res.render 'set_posted_cookie', { post_cookies: req.body.post_cookies }


# Sinatra Extensions
app.post '/post_cookie_jar', (req, res)->
  res.cookie 'my_cookie_1', 'my_cookie_value_1'
  res.cookie 'my_cookie_2', 'my_cookie_value_2'
  res.render 'post_method',
    param1: req.body.param1
    param2: req.body.param2

app.post '/post_cookie_setting', (req, res)->
  res.render 'display_cookie_method',
    cookie_name: 'something_to_eat'
    cookie_value: req.cookies['something_to_eat']

app.get '/get_cookie_setting', (req, res)->
  res.render 'display_cookie_method',
    cookie_name: 'something_to_eat'
    cookie_value: req.cookies['something_to_eat']

app.get '/simple', (req, res)->
  res.cookie 'get_cookie_2', 'get_cookie_value_2'
  res.render 'simple'

app.get '/required_attributes', (req, res)->
  res.render 'required_attributes'

app.post '/not_simple', (req, res)->
  res.cookie 'post_cookie_2', 'post_cookie_value_2'
  res.render 'simple'

app.post '/redirect_request', (req, res)->
  res.cookie 'post_cookie_1', 'post_cookie_value_1'
  res.redirect '/simple'

app.get '/redirect_request', (req, res)->
  res.cookie 'get_cookie_1', 'get_cookie_value_1'
  res.redirect '/simple'

app.get '/error', (req, res)->
  res.status 500
  res.send { error: "GET ERROR"  }

app.post '/error', (req, res)->
  res.status 500
  res.send { error: "POST ERROR" }

app.get '/raw_mds_collection', (req, res)->
  res.render 'raw_mds_collection'

app.get '/raw_amazon_detail', (req, res)->
  res.render 'raw_amazon_detail'

app.get '/raw_amazon_category', (req, res)->
  res.render 'raw_amazon_category'  

app.get '/raw_amazon_invalid_utf8', (req, res)->
  res.render 'raw_amazon_invalid_utf8'

app.get '/raw_zillow', (req, res)->
  res.render 'raw_zillow'

app.get '/doctor_with_many_specialities', (req, res)->
  res.render 'doctor_with_many_specialities'  

app.get '/outer_containers_with_missing_inner_values', (req, res)->
  res.render 'outer_containers_with_missing_inner_values'  

app.get '/sandbox', (req, res)->
  res.render 'sandbox'

app.get '/pagination_1', (req, res)->
  res.render 'pagination_1'  

app.get '/pagination_2', (req, res)->
  res.render 'pagination_2'    

app.get '/pagination_3', (req, res)->
  res.render 'pagination_3'

app.get '/pagination_same_page', (req, res)->
  res.render 'pagination_same_page'

exports = module.exports = app

if !module.parent
  console.log 'Testing server listening at port 9999'
  app.listen 9999