Meteor.publish 'lists', ->
  return Lists.find {$or: [{author: @userId}, {public: true}]}, {fields: {items: 0}}
