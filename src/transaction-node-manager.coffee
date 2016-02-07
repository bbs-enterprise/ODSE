{ OdseNode , ArrayNode , ObjectNode , ContainerNode , PrimitiveNode , ValueNode , OdseNode } = require './odse'
{ TransactioNode } = require './transaction-node.coffee'
{ OdseConfigs } = require './odse-configs.coffee'
{ GenericUtilities } = require './generic-utilities.coffee'

class TransactioNodeManager

  transactionList : null

  constructor : () ->
    @transactionList = []

  processAndAddTransactionToList : ( transactioNodeObj ) ->
    if @transactionList.length > 0
      if @transactionList[ @transactionList.length - 1 ].createdTimeStamp >= transactioNodeObj.createdTimeStamp
        transactioNodeObj.createdTimeStamp = @transactionList[ @transactionList.length - 1 ].createdTimeStamp + 1
    if ( GenericUtilities.isNotNull transactioNodeObj , 'val' ) is false
      delete transactioNodeObj.val
    @transactionList.push transactioNodeObj

  addNewArrayNodeTransaction : ( userId , blobId , nodeId ) ->
    transactioNodeObj = new TransactioNode userId , blobId , nodeId , OdseConfigs.newArrayStringConstant , null , null
    @processAndAddTransactionToList transactioNodeObj

  addNewObjectNodeTransaction : ( userId , blobId , nodeId ) ->
    transactioNodeObj = new TransactioNode userId , blobId , nodeId , OdseConfigs.newObjectStringConstant , null , null
    @processAndAddTransactionToList transactioNodeObj

  addNewPrimitiveNodeTransaction : ( userId , blobId , nodeId , val ) ->
    transactioNodeObj = new TransactioNode userId , blobId , nodeId , OdseConfigs.newPrimitiveStringConstant , val , null
    @processAndAddTransactionToList transactioNodeObj

  arrayNodePushTransaction : ( userId , blobId , nodeId ) ->
    transactioNodeObj = new TransactioNode userId , blobId , nodeId , OdseConfigs.arrayPushStringConstant , null , null
    @processAndAddTransactionToList transactioNodeObj

  objectAddTransaction : ( userId , blobId , nodeId , propertyName ) ->
    transactioNodeObj = new TransactioNode userId , blobId , nodeId , OdseConfigs.objectAddStringConstant , null , propertyName
    @processAndAddTransactionToList transactioNodeObj

  arrayRemoveTransaction : ( userId , blobId , nodeId ) ->
    transactioNodeObj = new TransactioNode userId , blobId , nodeId , OdseConfigs.arrayRemoveStringConstant , null , null
    @processAndAddTransactionToList transactioNodeObj

  objectRemoveTransaction : ( userId , blobId , nodeId ) ->
    transactioNodeObj = new TransactioNode userId , blobId , nodeId , OdseConfigs.objectRemoveStringConstant , null , null
    @processAndAddTransactionToList transactioNodeObj

  primitiveRemoveTransaction : ( userId , blobId , nodeId ) ->
    transactioNodeObj = new TransactioNode userId , blobId , nodeId , OdseConfigs.primitiveRemoveStringConstant , null , null
    @processAndAddTransactionToList transactioNodeObj

  primitiveUpdateTransaction : ( userId , blobId , nodeId ) ->
    transactioNodeObj = new TransactioNode userId , blobId , nodeId , OdseConfigs.primitiveRemoveStringConstant , null , null
    @processAndAddTransactionToList transactioNodeObj

@TransactioNodeManager = TransactioNodeManager
