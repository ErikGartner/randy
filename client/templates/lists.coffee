Template.lists.events
  'click #showadd': ->
    $('.small.modal').modal('show')

  'click .listitem': (event) ->
    selectors = Session.get('selectors')
    console.log event
    id = event.target.data('id')
    selectors.push(id)
    Session.set('selectors', selectors)

Template.lists.onRendered ->
  Session.set('selectors', [])

Template.lists.helpers
  lists: ->
    return Lists.find({})

  selectors: ->
    return Session.get('selectors')
