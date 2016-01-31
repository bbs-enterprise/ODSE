{ OdseNode , ArrayNode , ObjectNode , ContainerNode , PrimitiveNode , ValueNode , OdseNode } = require './odse'
{ TransactioNode } = require './transaction-node.coffee'

class TransactioNodeManager

  transactionList : null

  constructor : () ->
    @transactionList = []

  addNewArrayNodeTransaction : ( userId , blobId , nodeId ) ->
    transactioNodeObj = new TransactioNode userId , blobId , nodeId , 'new-array'
    @transactionList.push transactioNodeObj

  addNewObjectNodeTransaction : ( userId , blobId , nodeId ) ->
    transactioNodeObj = new TransactioNode userId , blobId , nodeId , 'new-object'
    @transactionList.push transactioNodeObj

  addNewPrimitiveNodeTransaction : ( userId , blobId , nodeId , val ) ->
    transactioNodeObj = new TransactioNode userId , blobId , nodeId , 'new-primitive' , val
    @transactionList.push transactioNodeObj

  arrayNodePushTransaction : ( userId , blobId , nodeId ) ->
    transactioNodeObj = new TransactioNode userId , blobId , nodeId , 'array-push'
    @transactionList.push transactioNodeObj

  objectAddTransaction : ( userId , blobId , nodeId ) ->
    transactioNodeObj = new TransactioNode userId , blobId , nodeId , 'object-add'
    @transactionList.push transactioNodeObj

  arrayRemoveTransaction : ( userId , blobId , nodeId ) ->
    transactioNodeObj = new TransactioNode userId , blobId , nodeId , 'array-remove'
    @transactionList.push transactioNodeObj

  objectRemoveTransaction : ( userId , blobId , nodeId ) ->
    transactioNodeObj = new TransactioNode userId , blobId , nodeId , 'object-remove'
    @transactionList.push transactioNodeObj

  primitiveRemoveTransaction : ( userId , blobId , nodeId ) ->
    transactioNodeObj = new TransactioNode userId , blobId , nodeId , 'primitive-remove'
    @transactionList.push transactioNodeObj

@TransactioNodeManager = TransactioNodeManager
