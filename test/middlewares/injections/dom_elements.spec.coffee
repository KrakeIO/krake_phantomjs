describe "KrakeDomElements", ->
  beforeEach ->
    @kde = require '../../../middlewares/injections/dom_elements'

  describe "getDomNodesValues", ->
    beforeEach ->
      spyOn(@kde, "toClick")
      spyOn(@kde, "getDomNodes").andReturn []

    it "should call toClick if to_click is present", ->
      col_obj = 
        col_name: "my col"
        dom_query: ".some-col"
        simulate:
          dom_query: ".some-col"
          action: "click"

      @kde.getDomNodesValues col_obj
      expect(@kde.toClick).toHaveBeenCalled()