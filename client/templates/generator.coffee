Template.generator.helpers
  selectors: ->
    return Session.get('selectors')

  listname: ->
    return Lists.findOne(_id:@id)?.name

  results: ->
    return Session.get('results')

Template.generator.events
  'click #randomize': ->
    selectors = _.map Session.get('selectors'), (val) -> return val.id
    Meteor.call 'sampleLists', selectors, 5, (err, res) ->
      if err
        console.log 'Error while getting samples!'
        return
      res = _.map res, (val) ->
        return {items: _.map val, (v) -> return {item: v}}
      Session.set('results', res)

  'click .remove-selector': (event) ->
    selector = $(event.target).index()
    selectors = Session.get('selectors')
    selectors.splice(selector, 1)
    Session.set('selectors', selectors)
