Template.listeditor.onRendered ->
  $('#addModal').modal
    onHidden: ->
      $('#listname').val ''
      $('#listitems').val ''
      $('#listpublic').prop 'checked', false
      Session.set 'activeList', undefined

  $('#forkModal').modal
    onHidden: ->
      Session.set 'activeList', undefined

Template.body.events
  'click #addlist': ->
    name = $('#listname').val()
    items = $('#listitems').val()
    setPublic =  $('#listpublic').prop 'checked'
    if name == '' or items == ''
      return

    activeList = Session.get 'activeList'
    if activeList?
      id = activeList.id
      Meteor.call 'editList', id, name, items, setPublic
    else
      Meteor.call 'addList', name, items, setPublic
    return false

  'click #deleteListButton': ->
    activeList = Session.get 'activeList'
    if activeList?
      id = activeList.id
      Meteor.call 'deleteList', id
      selectors = Session.get 'selectors'
      Session.set 'selectors', _.reject selectors, (val) -> return val.id == id
    return false

  'click #forkButton': ->
    activeList = Session.get 'activeList'
    if activeList?
      Meteor.call 'forkList', activeList.id
    $('#forkModal').modal 'hide'
    return false

  'click #favoriteButton': (event) ->
    activeList = Session.get 'activeList'
    if activeList?
      if Favorites.findOne(lists: activeList.id)?
        Meteor.call 'removeFavorite', activeList.id
      else
        Meteor.call 'addFavorite', activeList.id
    $('#forkModal').modal 'hide'
    return false

Template.listeditor.helpers
  activeList: ->
    return Session.get('activeList')

  isMyList: ->
    return (not Session.get('activeList')? or
            Session.get('activeList')?.author == Meteor.userId())

  isFavorite: ->
    activeList = Session.get 'activeList'
    if activeList?
      return Favorites.findOne(lists: activeList.id)?
    else
      return false
