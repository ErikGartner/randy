Meteor.publish 'lists', ->
  return Lists.find({author: @userId})
