@Lists = new Mongo.Collection('lists')

@Schemas = {}
Schemas.Lists = new SimpleSchema
  name:
    type: String
    label: 'Name'
    max: 200

  author:
    type: String
    label: 'Author ID'
    custom: ->
      if Meteor.isServer
        user = Meteor.users.findOne _id: @value
        if not user?
          return 'invalid-foreign-key'

  items:
    type: [String]
    label: 'Items'
    minCount: 1

  public:
    type: Boolean
    label: 'Public'
    autoValue: ->
      return false

  updatedAt:
    type: Date
    autoValue: ->
      if @isUpdate or @isInsert
        return new Date()
    denyInsert: true

Lists.initEasySearch 'name',
  limit: 10
  use: 'mongo-db'
  query: -> return $or: [{author: @userId}, {public: true}]
