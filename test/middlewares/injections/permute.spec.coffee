krake_definition = require '../../fixtures/json/permute_definition'

describe "KrakePermute", ->
  beforeEach ->
    @value_chain = {"input1" : "value 1", "input2": "value 2"}
    @col_element = [{
          id: "div1"
          nodeName: "div"
        },{
          id: "div2"
          nodeName: "div"
        },{
          id: "div3"
          nodeName: "div"
      }]

    @kp = require '../../../middlewares/injections/permute'
    @kp.init krake_definition
    @parent_value_chain = {}

    spyOn(@kp, "getColumnElements").andReturn @col_element
    spyOn(@kp, "makeElementSelected")
    spyOn(@kp, "getExtendedValueChain").andReturn @value_chain
    spyOn(@kp, "extractDomAttributes").andReturn "stubbed col_value"    

  it "should have set handles", ->
    expect(@kp.handles?).toBe true
    expect(@kp.responses?).toBe true

  describe "permuteStep", ->
    beforeEach ->
      spyOn(@kp, "goDeep")
      spyOn(@kp, "goWide")

    it "should go deeper when there is still more depth to be covered", (done)->
      @kp.permuteStep 0, 0, @parent_value_chain
      expect(@kp.goDeep).toHaveBeenCalled()
      done()

    it "should not go deeper when there is no more depth to be covered", (done)->
      @kp.permuteStep @kp.handles.length - 1, 0, @parent_value_chain
      expect(@kp.goDeep).not.toHaveBeenCalled()
      done()

    it "should go wider when there is more breadth to be covered", (done)->
      @kp.permuteStep @kp.handles.length - 1, 0, @parent_value_chain
      expect(@kp.goWide).toHaveBeenCalled()
      done()

    it "should not go wider when there is no more breadth to be covered", (done)->
      @kp.permuteStep @kp.handles.length - 1, @col_element.length - 1, @parent_value_chain
      expect(@kp.goWide).not.toHaveBeenCalled()
      done()

    it "should call makeElementSelected with selected_checksum if indicated", (done)->
      @kp.permuteStep 0, 0, @parent_value_chain
      expect(@kp.makeElementSelected).toHaveBeenCalled()
      args = @kp.makeElementSelected.mostRecentCall.args
      expect(args[1]).toEqual ".tb-selected"
      done()      

    it "should call makeElementSelected with selected_checksum false if not indicated", (done)->
      @kp.permuteStep 1, 0, @parent_value_chain
      expect(@kp.makeElementSelected).toHaveBeenCalled()
      args = @kp.makeElementSelected.mostRecentCall.args
      expect(args[1]).toEqual false
      done()      

  describe "goDeep", ->
    beforeEach ->
      spyOn(@kp, "permuteStep")

    it "should call permuteStep with incremented handle index", ->
      finish_callback = ()=>

      @kp.goDeep 1, 0, {attr: '111'}, finish_callback
      args = @kp.permuteStep.mostRecentCall.args
      expect(args[0]).toEqual 2
      expect(args[1]).toEqual 0
      expect(typeof args[2]).toBe "object"
      expect(args[2].attr).toEqual '111'
      expect(typeof args[3]).toBe 'function'

    it "should pass on finish_callback function to goWide function", (done)->
      finish_callback = ()=>
        done()

      @kp.goDeep 1, 0, {attr: '111'}, {}, finish_callback
      go_deep_args = @kp.permuteStep.mostRecentCall.args
      expect(go_deep_args[0]).toEqual 2
      expect(go_deep_args[1]).toEqual 0
      expect(typeof go_deep_args[2]).toBe "object"
      expect(go_deep_args[2].attr).toEqual '111'


      expect(typeof go_deep_args[3]).toBe 'function'
      spyOn(@kp, "goWide")
      go_deep_args[3]()
      expect(@kp.goWide).toHaveBeenCalled()
      go_wide_args = @kp.goWide.mostRecentCall.args

      expect(go_wide_args[0]).toEqual 1
      expect(go_wide_args[1]).toEqual 0
      expect(typeof go_wide_args[2]).toBe "object"
      expect(go_wide_args[2].attr).toBe undefined
      expect(typeof go_wide_args[3]).toBe 'function'      
      expect(go_wide_args[3]).toEqual finish_callback
      go_wide_args[3]()

    it "should not go wide if it is the last element in the level", ->
      finish_callback = ()=>

      @kp.goDeep 1, 3, {attr: '111'}, {}, finish_callback
      go_deep_args = @kp.permuteStep.mostRecentCall.args
      expect(go_deep_args[0]).toEqual 2
      expect(go_deep_args[1]).toEqual 0
      expect(typeof go_deep_args[2]).toBe "object"
      expect(go_deep_args[2].attr).toEqual '111'


      expect(typeof go_deep_args[3]).toBe 'function'
      spyOn(@kp, "goWide")
      go_deep_args[3]()
      expect(@kp.goWide).not.toHaveBeenCalled()

    it "should make parent callback if it is the last element in the level and its sub tree has been traversed ", (done)->
      finish_callback = ()=>
        done()

      @kp.goDeep 1, 3, {attr: '111'}, {}, finish_callback
      go_deep_args = @kp.permuteStep.mostRecentCall.args
      expect(go_deep_args[0]).toEqual 2
      expect(go_deep_args[1]).toEqual 0
      expect(typeof go_deep_args[2]).toBe "object"
      expect(go_deep_args[2].attr).toEqual '111'

      expect(typeof go_deep_args[3]).toBe 'function'
      spyOn(@kp, "goWide")
      go_deep_args[3]()
      expect(@kp.goWide).not.toHaveBeenCalled()      

  describe "goWide", ->
    beforeEach ->
      spyOn(@kp, "permuteStep").andCallThrough()
      spyOn(@kp, "goDeep")

    it "should call permuteStep with incremented item_index", ->
      callback = false
      @kp.goWide 1, 0, {attr: '111'}, callback
      args = @kp.permuteStep.mostRecentCall.args
      expect(args[0]).toEqual 1
      expect(args[1]).toEqual 1
      expect(typeof args[2]).toBe "object"
      expect(args[2].attr).toEqual '111'
      expect(args[3]).toBe false

    it "should call goDeep with incremented handle_index", ->
      finish_callback = ()=>
      @kp.goWide 1, 0, {input1: 'value 1'}, finish_callback
      expect(@kp.goDeep).toHaveBeenCalled()
      args = @kp.goDeep.mostRecentCall.args
      expect(args[0]).toEqual 1
      expect(args[1]).toEqual 1

  describe "getFullValueChains", ->
    it "should generate results from responses columns", ->
      results = @kp.getFullValueChains {}
      expect(results.length).toEqual @col_element.length

    it "should return array with one empty object as if responses array is empty and value_chain has no attributes", ->
      krake_definition_nr = require '../../fixtures/json/permute_definition_no_responses'
      kp1 = require '../../../middlewares/injections/permute'
      kp1.init krake_definition_nr
      results = kp1.getFullValueChains {}
      expect(results.length).toEqual 1

    it "should return result generated from columns defined in handles in an array if responses array is empty", ->
      krake_definition_nr = require '../../fixtures/json/permute_definition_no_responses'
      kp1 = require '../../../middlewares/injections/permute'
      kp1.init krake_definition_nr
      results = kp1.getFullValueChains 
        existing_val_1: "this is val 1"
        existing_val_2: "this is val 2"
      expect(results.length).toEqual 1
      expect(results[0]["existing_val_1"]).toEqual "this is val 1"
      expect(results[0]["existing_val_2"]).toEqual "this is val 2"
