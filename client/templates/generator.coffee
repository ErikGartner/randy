Template.generator.helpers
  selectors: ->
    return _.map Session.get('selectors'), (val, index) ->
      val.index = index
      return val

  listname: ->
    return Lists.findOne(_id:@id)?.name

  results: ->
    return Session.get('results')

Template.generator.events
  'click #randomize': ->
    selectors = _.map Session.get('selectors'), (val) -> return val.id
    Meteor.call 'sampleLists', selectors, 5, (err, res) ->
      console.log res
      
    #Session.set('results', results)

  'click .remove-selector': (event) ->
    selector = $(event.target).data('id')
    selectors = Session.get('selectors')
    selectors.splice(selector, 1)
    Session.set('selectors', selectors)
