Template.body.events
  'click #addlist': ->
    name = $('#listname').val()
    items = $('#listitems').val()
    if name == '' or items == ''
      return
    Meteor.call 'addList', name, items
    return false
    
