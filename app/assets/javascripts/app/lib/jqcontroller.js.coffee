class JqController extends Spine.Controller
  activate: ->
    @el.addClass("current")

  deactivate: ->
    @el.removeClass("current")
  
  jqsubmit: ->
    $(@el).find('form').submit()

window.JqController = JqController