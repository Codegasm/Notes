class JqController extends Spine.Controller

  constructor: ->
    super
    @el.attr('id', this.pageId) if this.pageId

  jqsubmit: ->
    $(@el).find('form').submit()

window.JqController = JqController