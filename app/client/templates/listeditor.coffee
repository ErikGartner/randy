Template.listeditor.onRendered ->
  $('#addModal').modal
    onHidden: ->
      $('#listname').val ''
      $('#listitems').val ''
      $('#listpublic').prop 'checked', false
      Session.set 'editListId', undefined

Template.body.events
  'click #addlist': ->
    name = $('#listname').val()
    items = $('#listitems').val()
    setPublic =  $('#listpublic').prop 'checked'
    if name == '' or items == ''
      return

    id = Session.get 'editListId'
    if id?
      Meteor.call 'editList', id, name, items, setPublic
    else
      Meteor.call 'addList', name, items, setPublic
    return false

  'click #deleteListButton': ->
    id = Session.get 'editListId'
    if id?
      Meteor.call 'deleteList', id
      Session.set 'editListId', undefined
      selectors = Session.get 'selectors'
      Session.set 'selectors', _.reject selectors, (val) -> return val.id == id
    return false

Template.listeditor.helpers
  editListId: ->
    return Session.get('editListId')
