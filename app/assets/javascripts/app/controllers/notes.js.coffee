$ = jQuery.sub()
Note = App.Note

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Note.find(elementID)

class Index extends JqController  
  className: 'current'
  
  events:
    'click [data-type=show]':    'show'
    'click [data-type=new]':     'new'

  constructor: ->
    super
    Note.bind 'refresh change', @render
    Note.fetch()
    
  render: =>
    notes = Note.all()
    toolbar = @view('notes/_toolbar')(pageTitle: 'Notes', noBack: true)
    @html @view('notes/index')(notes: notes, toolbar: toolbar)
    
  edit: (e) ->
    item = $(e.target).item()
    @navigate '/notes', item.id, 'edit'
    
  destroy: (e) ->
    item = $(e.target).item()
    item.destroy() if confirm('Sure?')
    
  show: (e) ->
    item = $(e.target).item()
    @navigate '/notes', item.id
    
  new: ->
    @navigate '/notes/new'
    
    
class Show extends JqController
  className: 'show'
  
  events:
    'click [data-type=edit]': 'edit'
    'click [data-type=destroy]': 'destroy'
    'click [data-type=back]': 'back'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)
    
  change: (id) ->
    @item = Note.find(id)
    @render()

  render: ->
    toolbar = @view('notes/_toolbar')(pageTitle: @item.title)
    @html @view('notes/show')(note: @item, toolbar: toolbar)

  edit: ->
    @navigate '/notes', @item.id, 'edit'
  
  destroy: ->
    if confirm('Sure?')
      @navigate '/notes'
      @item.destroy()

  back: ->
    @navigate '/notes'

class New extends JqController
  events:
    'click [data-type=back]': 'back'
    'click [data-type=submit]': 'jqsubmit'
    'submit form': 'submit'
    
  constructor: ->
    super
    @active @render
    
  render: ->
    toolbar = @view('notes/_toolbar')(pageTitle: 'New note')
    @html @view('notes/new')(toolbar: toolbar)

  back: ->
    @navigate '/notes'

  submit: (e) ->
    e.preventDefault()
    note = Note.fromForm(e.target).save()
    @navigate '/notes', note.id if note
    
class Edit extends JqController
  events:
    'click [data-type=back]': 'back'
    'click [data-type=submit]': 'jqsubmit'
    'submit form': 'submit'
  
  constructor: ->
    super
    @active (params) ->
      @change(params.id)
      
  change: (id) ->
    @item = Note.find(id)
    @render()
    
  render: ->
    toolbar = @view('notes/_toolbar')(pageTitle: 'Edit note')
    @html @view('notes/edit')(note: @item, toolbar: toolbar)

  back: ->
    @navigate '/notes'

  submit: (e) ->
    e.preventDefault()
    @item.fromForm(e.target).save()
    @navigate '/notes'


class App.Notes extends Spine.Stack
  el: '#jqt'

  controllers:
    index: Index
    edit:  Edit
    show:  Show
    new:   New
    
  routes:
    '/notes/new':      'new'
    '/notes/:id/edit': 'edit'
    '/notes/:id':      'show'
    '/notes':          'index'

  default: 'index'
