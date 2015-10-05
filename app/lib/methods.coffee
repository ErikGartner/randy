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
    items.sort (a, b) ->
      res = a.toLowerCase().localeCompare(b.toLowerCase())
      if res == 0
        return a.localeCompare(b)
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
    items.sort (a, b) ->
      res = a.toLowerCase().localeCompare(b.toLowerCase())
      if res == 0
        return a.localeCompare(b)
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

    if Meteor.user()?.services?.facebook?.first_name?
      listname = Meteor.user().services.facebook.first_name + "'s " + list.name
    else
      listname = Meteor.user().profile?.name + "'s " + list.name

    Lists.insert
      author: uid
      items: list.items
      public: false
      name: listname
      ancestor: list._id
    return true

  addFavorite: (id) ->
    uid = Meteor.userId()
    if !uid?
      throw new Meteor.Error('not-authorized')

    check id, String
    list = Lists.findOne(_id:id)
    if not list?
      throw new Meteor.Error('invalid id')

    favorites = Favorites.findOne(user:uid)
    if not favorites?
      favorites = {user: uid, lists: [id]}
    else if id not in favorites.lists
      favorites.lists.push(id)
    Favorites.upsert({user:uid}, {$set:favorites})
    return true

  removeFavorite: (id) ->
    uid = Meteor.userId()
    if !uid?
      throw new Meteor.Error('not-authorized')

    check id, String
    favorites = Favorites.findOne(user:uid)
    if favorites?
      favorites.lists = _.reject favorites.lists, (val)-> return val == id
      Favorites.update({_id:favorites._id}, {$set: favorites})
    return true
