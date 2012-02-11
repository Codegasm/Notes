class JqController extends Spine.Controller

  constructor: ->
    super
    @el.attr('id', this.pageId) if this.pageId
    @el.live('pageAnimationEnd', this.animationEnd)
    $(window).bind('resize', this.resize)
    $(window).bind('orientationchange', this.resize)

  jqsubmit: ->
    $(@el).find('form').submit()
    
  initScroll: =>
    if !this.iscroll
      this.iscroll = new iScroll(@el.find('.wrapper').get(0), {
        hScroll: false, checkDOMChanges: false,
        onBeforeScrollStart: (event) =>
          event.preventDefault()
          this.iscroll.refresh()
      })
    else
      this.iscroll.refresh()
  
  resize: =>
    $('#jqt').attr('style', '')
    if this.iscroll
      this.iscroll.refresh()

  animationEnd: (event, info) =>
    if info.direction == 'in'
      this.initScroll()
    
window.JqController = JqController