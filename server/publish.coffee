Meteor.publishComposite 'lists',
  find: ->
    return Lists.find({$or: [{author: @userId}, {public: true}]},
                      {fields: {items: 0}})

  children: [
    find: (topDoc) ->
      Meteor.users.find({_id: topDoc.author},
                          {fields: {'profile.name': 1, _id: 1}})
  ]

Meteor.publishComposite 'favorites',
  find: ->
    return Favorites.find {user: @userId}

  children: [
    find: (topDoc) ->
      return Lists.find {_id: $in: topDoc.lists}, {fields: {items: 0}}

    children: [
      find: (topDoc, scndDoc) ->
        Meteor.users.find({_id: scndDoc.author},
                            {fields: {'profile.name': 1, _id: 1}})
    ]
  ]
