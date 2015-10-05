Template.lists.events
  'click #showadd': ->
    $('#addModal').modal 'show'

  'click .showEditList': (event) ->
    id = $(event.target).data('id')

    if Lists.findOne(_id:id)?.author == Meteor.userId()
      Meteor.call 'getList', id, (err, res) ->
        if not err?
          $('#listname').val res.name
          $('#listitems').val _.reduce res.items, (memo, item) ->
            return memo + '\n' + item
          $('#listpublic').prop 'checked', res.public
          $('#addModal').modal 'show'
          Session.set 'activeList', {id: res._id, author: res.author}
    else
      $('#forkModal').modal 'show'
      Session.set 'activeList', {id: id}

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
  latestLists: ->
    return Lists.find({author: Meteor.userId()},
                      {sort: {updatedAt: -1}, limit: 15})

  listAuthor: ->
    if @author == 'RANDY'
      return 'Randy'
    else
      return Meteor.users.findOne(_id: @author)?.profile?.name

  isFavorite: ->
    return Favorites.findOne(lists: @_id)?
