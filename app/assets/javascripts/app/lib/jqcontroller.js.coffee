class JqController extends Spine.Controller

  constructor: ->
    super
    @el.attr('id', this.pageId) if this.pageId
<<<<<<< HEAD
    @el.live('pageAnimationEnd', this.animationEnd)
=======
>>>>>>> feature/jqtouch

  jqsubmit: ->
    $(@el).find('form').submit()
    
  initScroll: =>
    if !this.iscroll
      this.iscroll = new iScroll(@el.find('.wrapper').get(0), {
        hScroll: false
      })
    else
      this.iscroll.refresh()

  animationEnd: (event, info) =>
    if info.direction == 'in'
      this.initScroll()
    
window.JqController = JqController