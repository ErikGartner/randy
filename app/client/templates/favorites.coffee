Template.favorites.helpers
  favorites: ->
    favorites = Favorites.findOne(user: Meteor.userId())
    if not favorites?
      return undefined
    return Lists.find(_id: $in: favorites.lists)

Template.favorites.events
  'click .favoriteIcon': (event) ->
    id = $(event.target).data('id')
    Meteor.call 'removeFavorite', id

  'click .listitem': (event) ->
    selectors = Session.get('selectors')
    id = $(event.target).data('id')
    if not id?
      return
    selectors.push({id: id})
    Session.set('selectors', selectors)
