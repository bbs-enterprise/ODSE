{ StorageDecider } = require './storage-decider.coffee'
{ GenericUtilities } = require './generic-utilities.coffee'
{ TransactioNodeManager } = require './transaction-node-manager.coffee'
{ OdseConfigs } = require './odse-configs.coffee'

class ConstructOdseTree

  nodeIdPathObj = null
  transactionList = null
  data = null
  tree = null
  transactioNodeManagerObj = null

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
        _buildTree cbfn

  _buildTree = ( cbfn ) =>
    referenceArray = []
    data = {}
    tree = {}
    idx = -1
    console.log transactionList
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
    cbfn true

  extractValue : () =>
    return data

  getTree : () =>
    return tree

@ConstructOdseTree = ConstructOdseTree
