describe "KrakeDomElements", ->
  beforeEach ->
    @kde = require '../../../middlewares/injections/dom_elements'
    @kde.init 
      "origin_url": "http://localhost:9999/open_post_page"
      "columns": [{
        "col_name": "col1"
        "dom_query": "#fun"
      },{
        "col_name": "col2"
        "dom_query": "#not-fun"
      }],
      "sudden_death": {
        "dom_query": "#captcha"
      }    

  describe "getDomNodesValues", ->
    beforeEach ->
      spyOn(@kde, "toSimulate")
      spyOn(@kde, "getDomNodes").andReturn []

    it "should call toSimulate if simulate is present", (done)->
      col_obj = 
        col_name: "my col"
        dom_query: ".some-col"
        simulate:
          dom_query: ".some-col"
          action: "click"

      @kde.getDomNodesValues col_obj, ()=>
        expect(@kde.toSimulate).toHaveBeenCalled()
        done()