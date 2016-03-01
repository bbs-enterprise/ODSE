{ StorageDecider } = require './storage-decider.coffee'
{ GenericUtilities } = require './generic-utilities.coffee'
{ TransactioNodeManager } = require './transaction-node-manager.coffee'
{ OdseConfigs } = require './odse-configs.coffee'
{ OdseNode , ArrayNode , ObjectNode , ContainerNode , PrimitiveNode , ValueNode , OdseNode } = require './odse.coffee'

class ConstructOdseTree

  nodeIdPathObj = null
  transactionList = null
  data = null
  tree = null
  transactioNodeManagerObj = null
  nodeIdPropertyNameMap = null

  constructor : ( blobId , cbfn ) ->
    if ( GenericUtilities.isNotNull blobId ) is false
      throw new Error 'Blob ID is required for ODSE node tree generation.'
    nodeIdPathObj = {}
    transactionList = []
    StorageDecider.getNodeIdPathList blobId , ( blobIdParam , nodeIdPathList ) =>
      for item in nodeIdPathList
        for key , value of item
          nodeIdPathObj[ key ] = value
      StorageDecider.getTransactionHistory blobId , ( blobIdParam , transactionListParam ) =>
        transactionList = transactionListParam
        _buildTree()
        data = _buildData tree
        cbfn data , tree

  _buildData = ( currentNodeObj ) =>
    res = null
    if ( currentNodeObj instanceof ObjectNode ) is true
      res = {}
      currentNodeObj.forEach ( key , node ) =>
        res[ nodeIdPropertyNameMap[ key ] ] = _buildData node
    else if ( currentNodeObj instanceof ArrayNode ) is true
      res = []
      currentNodeObj.forEach ( node , index ) =>
        res.push ( _buildData node )
    else if ( currentNodeObj instanceof PrimitiveNode ) is true
      res = currentNodeObj.getValue()
    return res
    ###
    referenceArray = []
    data = {}
    idx = -1
    for item in transactionList
      if item.type is OdseConfigs.newArrayStringConstant
        referenceArray.push []
        idx++
      else if item.type is OdseConfigs.newObjectStringConstant
        referenceArray.push {}
        idx++
      else if item.type is OdseConfigs.newPrimitiveStringConstant
        referenceArray.push item.val
        idx++
      else if item.type is OdseConfigs.objectAddStringConstant
        referenceArray[ idx - 1 ][ item.propertyName ] = referenceArray[ idx ]
        referenceArray.pop()
        idx--
      else if item.type is OdseConfigs.arrayPushStringConstant
        referenceArray[ idx - 1 ].push referenceArray[ idx ]
        referenceArray.pop()
        idx--
    data = referenceArray[ 0 ]
    ###

  _getNewNode = ( nodeTypeName , transactionObj ) =>
    currentNodeObj = null
    if nodeTypeName is OdseConfigs.newArrayStringConstant
      currentNodeObj = new ArrayNode()
    else if nodeTypeName is OdseConfigs.newObjectStringConstant
      currentNodeObj = new ObjectNode()
    else if nodeTypeName is OdseConfigs.newPrimitiveStringConstant
      currentNodeObj = new PrimitiveNode transactionObj.val
    currentNodeObj.nodeId = transactionObj.nodeId
    currentNodeObj.createdTimeStamp = transactionObj.createdTimeStamp
    currentNodeObj.lastUpdateTimeStamp = transactionObj.createdTimeStamp
    return currentNodeObj

  _buildTree = () =>
    nodeIdPropertyNameMap = {}
    referenceStack = []
    tree = {}
    cn = 0
    for item in transactionList
      if item.type is OdseConfigs.newArrayStringConstant
        referenceStack.push ( _getNewNode item.type , item )
      else if item.type is OdseConfigs.newObjectStringConstant
        referenceStack.push ( _getNewNode item.type , item )
      else if item.type is OdseConfigs.newPrimitiveStringConstant
        referenceStack.push ( _getNewNode item.type , item )
      else if item.type is OdseConfigs.objectAddStringConstant
        elementToBeAdded = referenceStack[ referenceStack.length - 1 ]
        nodeIdPropertyNameMap[ elementToBeAdded.nodeId ] = item.propertyName
        for reference in referenceStack
          if reference.nodeId is item.nodeId
            reference.addNode elementToBeAdded.nodeId , elementToBeAdded
            referenceStack.pop()
            break
        #console.log item , cn , nodeIdPathObj[ item.nodeId ]
      else if item.type is OdseConfigs.arrayPushStringConstant
        elementToBeAdded = referenceStack[ referenceStack.length - 1 ]
        nodeIdPropertyNameMap[ elementToBeAdded.nodeId ] = item.propertyName
        for reference in referenceStack
          if reference.nodeId is item.nodeId
            reference.pushNode elementToBeAdded
            referenceStack.pop()
            break
      cn++
    #console.log transactionList , nodeIdPathObj , nodeIdPropertyNameMap
    tree = referenceStack[ 0 ]

  extractValue : () =>
    return data

  getTree : () =>
    return tree

@ConstructOdseTree = ConstructOdseTree
