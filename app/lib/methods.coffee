Meteor.methods
  addList: (name, items, publicList) ->
    uid = Meteor.userId()
    if !uid?
      throw new Meteor.Error('not-authorized')

    check name, String
    check items, String
    check publicList, Boolean

    items = items.trim().split('\n')
    items = _.map items, (val) ->
      return val.trim()
    items = _.filter items, (val) ->
      return val != ''
    items.sort()
    name = name.trim()

    Lists.insert author: uid, name: name, items: items, public: publicList
    return true

  deleteList: (id) ->
    uid = Meteor.userId()
    if !uid?
      throw new Meteor.Error('not-authorized')

    if Lists.findOne(_id:id)?.author != uid
      throw new Meteor.Error('not-authorized')

    check id, String

    Lists.remove _id:id
    return true

  editList: (id, name, items, publicList) ->
    uid = Meteor.userId()
    if !uid?
      throw new Meteor.Error('not-authorized')

    if Lists.findOne(_id:id)?.author != uid
      throw new Meteor.Error('not-authorized')

    check name, String
    check items, String
    check publicList, Boolean
    check id, String

    items = items.trim().split('\n')
    items = _.map items, (val) ->
      return val.trim()
    items = _.filter items, (val) ->
      return val != ''
    items.sort()
    name = name.trim()

    Lists.update {_id:id}, $set: name:name, items:items, public: publicList
    return true

  sampleLists: (ids, n) ->
    if Meteor.isClient
      return [[]]

    uid = Meteor.userId()
    if !uid?
      throw new Meteor.Error('not-authorized')

    check n, Number
    check ids, Array
    _.each ids, (val) ->
      check val, String
    randomLists = []
    for x in [1..n]
      items = []
      for id in ids
        list = Lists.findOne {_id: id}
        if list?.author != uid and not list?.public
          throw new Meteor.Error('not-authorized')

        items.push Random.choice(list.items)

      randomLists.push items
    return randomLists

  getList: (id) ->
    uid = Meteor.userId()
    if !uid?
      throw new Meteor.Error('not-authorized')

    check id, String
    list = Lists.findOne _id:id
    if not list?
      throw new Meteor.Error('invalid id')

    if list.author != uid and not list.public
      throw new Meteor.Error('not-authorized')

    return list

  forkList: (id) ->
    uid = Meteor.userId()
    if !uid?
      throw new Meteor.Error('not-authorized')

    check id, String
    list = Lists.findOne(_id:id)
    if not list?
      throw new Meteor.Error('invalid id')

    if not list.public
      throw new Meteor.Error('not-authorized')

    Lists.insert
      author: uid
      items: list.items
      public: false
      name: Meteor.user()?.profile?.first_name + "'s " + list.name
      ancestor: list._id
    return true
