{ GenericUtilities } = require './generic-utilities.coffee'
{ OdseConfigs } = require './odse-configs.coffee'

class TransactioNode

  transactionId : null
  createdTimeStamp : null
  userId : null
  blobId : null
  nodeId : null
  type : null
  val : null

  constructor : ( userIdParam , blobIdParam , nodeIdParam , typeParam , valParam ) ->
    @transactionId = ( GenericUtilities.generateRandomAlphaNumericStringWithPrefix OdseConfigs.clientIdPrefix , ( OdseConfigs.transactionIdLength - OdseConfigs.clientIdPrefix.length ) )
    @createdTimeStamp = Date.now()
    @userId = userIdParam
    @blobId = blobIdParam
    @nodeId = nodeIdParam
    @type = typeParam
    if GenericUtilities.isNotNull valParam
      @val = valParam

@TransactioNode = TransactioNode
