{ GenericUtilities } = require './generic-utilities.coffee'
{ ClientStorageHandler } = require './client-storage-handler.coffee'

class ClientPendingSyncHandler

  isClient = null
  lsObj = null

  constructor : () ->
    isClient = ( ! GenericUtilities.isRunningOnServer() )
    lsObj = new ClientStorageHandler()

@ClientPendingSyncHandler = new ClientPendingSyncHandler()
