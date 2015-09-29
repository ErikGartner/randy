Meteor.publish 'lists', ->
  return Lists.find {author: @userId}, {sort: {updatedAt: -1}, limit: 15, fields: {items: 0}}
