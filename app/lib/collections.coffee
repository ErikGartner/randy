@Lists = new Mongo.Collection('lists')

@Schemas = {}
Schemas.Lists = new SimpleSchema
  name:
    type: String
    label: 'Name'
    max: 40

  author:
    type: String
    label: 'Author ID'

  items:
    type: [String]
    label: 'Items'
    minCount: 1

  public:
    type: Boolean
    label: 'Public'

  updatedAt:
    type: Date
    label: 'Last updated'
    autoValue: ->
      if @isUpdate or @isInsert
        return new Date()

Lists.attachSchema Schemas.Lists
Lists.initEasySearch 'name',
  limit: 10
  use: 'mongo-db'
  returnFields: ['name', 'author', '_id', 'public', 'updatedAt']
  query: (searchString, opts) ->
    query = EasySearch.getSearcher(this.use).defaultQuery(this, searchString)
    query = $and: [
      query
      $or: [{author: opts.publishScope.userId}, {public: true}]
    ]
    return query