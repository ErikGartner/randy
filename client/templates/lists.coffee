Template.lists.events
  'click #showadd': ->
    $('.small.modal').modal('show')

  'click .listitem': (event) ->
    selectors = Session.get('selectors')
    id = $(event.target).data('id')
    if not id?
      return
    selectors.push({id: id})
    Session.set('selectors', selectors)

Template.lists.onRendered ->
  Session.set('selectors', [])

Template.lists.helpers
  lists: ->
    return Lists.find({})
