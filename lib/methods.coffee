Meteor.methods
  addList: (name, items, publicList) ->
    uid = Meteor.userId()
    if !uid
      throw new Meteor.Error('not-authorized')

    check name, String
    check items, String
    check publicList, Boolean

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

    if Lists.findOne(_id:id)?.author != uid
      throw new Meteor.Error('not-authorized')

    check id, String

    Lists.remove _id:id

  editList: (id, name, items, publicList) ->
    uid = Meteor.userId()
    if !uid
      throw new Meteor.Error('not-authorized')

    if Lists.findOne(_id:id)?.author != uid
      throw new Meteor.Error('not-authorized')

    check name, String
    check items, String
    check publicList, Boolean
    check id, String

    items = items.trim().split('\n')
    _.map items, (val) ->
      return val.trim()
    _.filter items, (val) ->
      return val != ''
    name = name.trim()

    Lists.update {_id:id}, $set: name:name, items:items, public: publicList

  sampleList: (id, n) ->
    uid = Meteor.userId()
    if !uid
      throw new Meteor.Error('not-authorized')

    check n, Number
    check id, String

    list = Lists.findOne(_id:id)
    if list?.author != uid and list?.public
      throw new Meteor.Error('not-authorized')

    return Random.choice(list.items)

  getList: (id) ->
    uid = Meteor.userId()
    if !uid
      throw new Meteor.Error('not-authorized')

    list = Lists.findOne(_id:id)
    if list?.author != uid and list?.public
      throw new Meteor.Error('not-authorized')

    check id, String

    return Lists.findOne _id:id
