{ OdseNode , ArrayNode , ObjectNode , ContainerNode , PrimitiveNode , ValueNode , OdseNode } = require './odse'
{ GenericUtilities } = require './generic-utilities.coffee'
{ ClientPendingSyncHandler } = require './client-pending-sync-handler.coffee'
{ TransactioNodeManager } = require './transaction-node-manager.coffee'
{ StorageDecider } = require './storage-decider.coffee'

class InitialDataDissection

  blobId = null
  userId = null
  allNodeIdPathList = null
  transactioNodeManagerObj = null

  getBlobId : () =>
    return blobId

  run : ( jsonString , userIdParam , cbfn ) =>
    transactioNodeManagerObj = new TransactioNodeManager()
    blobId = GenericUtilities.generateDataBlobId()
    userId = userIdParam
    allNodeIdPathList = []

    _recursiveDataBuild [] , ( JSON.parse jsonString )

    StorageDecider.saveBothTransactionHistoryAndNewNodeIdPathList transactioNodeManagerObj.transactionList , { blobId : blobId , allNodeIdPathList : allNodeIdPathList } , blobId , cbfn

    return blobId

  _addNodePathViaNodeIdList = ( nodePath ) ->
    childNodeId = nodePath[ nodePath.length - 1 ]
    newPath = {}
    newPath[ childNodeId ] = nodePath
    allNodeIdPathList.push newPath

  _recursiveDataBuild = ( nodeIdPathList , data ) ->
    newNodeIdPathList = []

    for id in nodeIdPathList
      newNodeIdPathList.push id

    currentNodeObj = null

    if data is null or ( typeof data ).toLowerCase() is 'undefined'
      currentNodeObj = new PrimitiveNode()
      newNodeIdPathList.push currentNodeObj.nodeId
      _addNodePathViaNodeIdList newNodeIdPathList
      transactioNodeManagerObj.addNewPrimitiveNodeTransaction userId , blobId , currentNodeObj.nodeId , null

    else if ( typeof data ).toLowerCase() is 'object' and ( Array.isArray data )
      currentNodeObj = new ArrayNode()
      newNodeIdPathList.push currentNodeObj.nodeId
      transactioNodeManagerObj.addNewArrayNodeTransaction userId , blobId , currentNodeObj.nodeId
      for item in data
        currentNodeObj.pushNode ( _recursiveDataBuild newNodeIdPathList , item )
        transactioNodeManagerObj.arrayNodePushTransaction userId , blobId , currentNodeObj.nodeId
      _addNodePathViaNodeIdList newNodeIdPathList

    else if ( typeof data ).toLowerCase() is 'object'
      currentNodeObj = new ObjectNode()
      newNodeIdPathList.push currentNodeObj.nodeId
      transactioNodeManagerObj.addNewObjectNodeTransaction userId , blobId , currentNodeObj.nodeId
      for key , value of data
        currentNodeObj.addNode key , ( _recursiveDataBuild newNodeIdPathList , value )
        transactioNodeManagerObj.objectAddTransaction userId , blobId , currentNodeObj.nodeId , key
      _addNodePathViaNodeIdList newNodeIdPathList

    else if ( typeof data ).toLowerCase() is 'number' or ( typeof data ).toLowerCase() is 'string' or ( typeof data ).toLowerCase() is 'symbol' or ( typeof data ).toLowerCase() is 'boolean'
      if Object.prototype.toString.call( data ) is '[object Date]'
        data = data.getTime()
      currentNodeObj = new PrimitiveNode data
      newNodeIdPathList.push currentNodeObj.nodeId
      _addNodePathViaNodeIdList newNodeIdPathList
      transactioNodeManagerObj.addNewPrimitiveNodeTransaction userId , blobId , currentNodeObj.nodeId , data

    return currentNodeObj

@InitialDataDissectionObj = ( new InitialDataDissection() )
