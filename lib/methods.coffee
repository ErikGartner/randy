Meteor.methods
  addList: (name, items) ->
    uid = Meteor.userId
    if !uid
      throw new Meteor.Error('not-authorized')

    check name, String
    check items, String
    items = items.split('\n')
    _.each items, (val) ->
      check val, String

    Lists.insert({author: uid, name: name, items: items})
