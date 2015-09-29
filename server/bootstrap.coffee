Meteor.startup ->

  loadNameLists = (path) ->
    config = JSON.parse(Assets.getText(path + 'config.json'))
    if not config?
      console.log 'Error while loading ', configfile
      return

    for item in config
      filepath = path + item.file
      res = Assets.getText filepath
      if not res?
        console.log 'Error while loading ', err
        return

      names = res.trim().split('\n')
      names = _.map names, (val) ->
        return val.trim()
      names = _.filter names, (val) ->
        return val != ''
      Lists.insert
        author: 'RANDY'
        public: true
        name: item.name
        items: names

      console.log 'Loaded namefile', item.file

  if Lists.find(author:'RANDY').count() == 0
    loadNameLists('lists/behindthename/')
    loadNameLists('lists/uscensus/')
