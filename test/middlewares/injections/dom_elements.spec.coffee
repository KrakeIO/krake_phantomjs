describe "KrakeDomElements", ->
  beforeEach ->
    @kde = require '../../../middlewares/injections/dom_elements'

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