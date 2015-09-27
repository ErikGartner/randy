Template.lists.events
  'click #showadd': ->
    $('.small.modal').modal('show')

  'click .listitem': (event) ->
    selectors = Session.get('selectors')
    id = $(event.target).data('id')
    console.log id
    selectors.push({id: id})
    Session.set('selectors', selectors)

Template.lists.onRendered ->
  Session.set('selectors', [])

Template.lists.helpers
  lists: ->
    return Lists.find({})

Template.generator.helpers
  selectors: ->
    return Session.get('selectors')

  listname: ->
    return Lists.findOne(_id:@id)?.name
