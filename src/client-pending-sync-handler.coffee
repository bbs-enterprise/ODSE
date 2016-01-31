{ GenericUtilities } = require './generic-utilities.coffee'

class ClientPendingSyncHandler

  isClient = null
  lsObj = null

  constructor : () ->
    isClient = ( ! GenericUtilities.isRunningOnServer() )

@ClientPendingSyncHandler = new ClientPendingSyncHandler()
