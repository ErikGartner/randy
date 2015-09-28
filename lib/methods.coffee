Meteor.methods
  addList: (name, items) ->
    uid = Meteor.userId()
    if !uid
      throw new Meteor.Error('not-authorized')

    check name, String
    check items, String
    items = items.trim().split('\n')
    _.map items, (val) ->
      check val, String
      return val.trim()
    _.filter items, (val) ->
      return val != ''
    name = name.trim()

    Lists.insert author: uid, name: name, items: items
