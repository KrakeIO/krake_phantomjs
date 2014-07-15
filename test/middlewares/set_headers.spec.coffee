setHeader = require '../../middlewares/set_headers'

describe "set_headers", ()->
  it "should not set header for facebook", (done)->  
    page =
      settings : []
    krakeQueryObject =
      origin_url : "https://www.google.com/#q=what+to+do"
      
    setHeader page, krakeQueryObject, ()->
      expect(page.settings['userAgent']).toEqual 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.114 Safari/537.36'
      done()