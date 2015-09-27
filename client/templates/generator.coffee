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
    selectors = Session.get('selectors')
    results = []
    for i in [1..5]
      result = ''
      for selector in selectors
        items = Lists.findOne(_id:selector.id).items
        result += ' ' + _.sample(items)

      results.push data:result
    Session.set('results', results)

  'click .remove-selector': (event) ->
    selector = $(event.target).data('id')
    selectors = Session.get('selectors')
    selectors.splice(selector, 1)
    Session.set('selectors', selectors)
