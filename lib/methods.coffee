Meteor.methods
  addList: (name, items, publicList) ->
    uid = Meteor.userId()
    if !uid
      throw new Meteor.Error('not-authorized')

    items = items.trim().split('\n')
    _.map items, (val) ->
      return val.trim()
    _.filter items, (val) ->
      return val != ''
    name = name.trim()

    Lists.insert author: uid, name: name, items: items, public: publicList

  deleteList: (id) ->
    uid = Meteor.userId()
    if !uid
      throw new Meteor.Error('not-authorized')

    Lists.remove _id:id

  editList: (id, name, items, publicList) ->
    uid = Meteor.userId()
    if !uid
      throw new Meteor.Error('not-authorized')

    Lists.update {_id:id}, $set: name:name, items:items, public: publicList

  sampleList: (id) ->
    return 'sadf'

  getList: (id) ->
    return Lists.findOne _id:id
