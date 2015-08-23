setPostedCookies = require '../../middlewares/set_posted_cookies'

describe "set_posted_cookies", ()->

  it "should open page with post method when method is defined", (done)->

    global.phantom = {}
    page = {}
    phantom.addCookie = ()->
    spyOn(phantom, 'addCookie').andCallThrough()
    
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
      "post_cookies": [
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
      expect(phantom.addCookie).toHaveBeenCalled()
      done()