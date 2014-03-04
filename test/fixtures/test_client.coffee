http = require 'http'

TestClient = (postData, callback)->
  post_options =
    host: 'localhost'
    port: 9701
    path: '/extract'
    method: 'POST'
    headers:
      'Content-Type': 'application/json'
      'Content-Length': postData.length
      
  post_req = http.request post_options, (res)=>
    res.setEncoding('utf8');
    resp_data = ''
    res.on 'data', (rawData)=>
      res.setEncoding 'utf8'
      resp_data += rawData

    res.on 'end', ()=>
      callback && callback JSON.parse resp_data
    

  # write parameters to post body
  post_req.write postData
  post_req.end()



exports = module.exports = TestClient