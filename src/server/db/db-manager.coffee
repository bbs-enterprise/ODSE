Datastore = require 'nedb'
pathObj = require 'path'

class DbManager

  databaseFileName = './../db/data-dump.db'
  db : null

  constructor : () ->
    dbFilePath = pathObj.join __dirname , databaseFileName
    @db = new Datastore { filename : dbFilePath , autoload : true }

@DbManager = new DbManager()
