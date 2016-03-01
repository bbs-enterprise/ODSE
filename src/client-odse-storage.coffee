{ OdseConfigs } = require './odse-configs.coffee'
{ ClientStorageHandler } = require './client-storage-handler.coffee'
{ TransactioNodeListManager } = require './transaction-node-list-manager.coffee'

class ClientOdseStorage

  @getClientStorageObject : () ->
    cshObj = new ClientStorageHandler()
    ClientOdseStorage.initializeClientStorage cshObj
    return cshObj

  @clearTheClientOdseStorageData : () ->
    cshObj = ClientOdseStorage.getClientStorageObject()
    cshObj.clearTheStorage OdseConfigs.clientStorageKeyNameForIdPath
    cshObj.clearTheStorage OdseConfigs.clientStorageKeyNameForTransactions

  @forceInitializeClientStorageAfterSync : () ->
    cshObj = ClientOdseStorage.getClientStorageObject()
    cshObj.forceSet OdseConfigs.clientStorageKeyNameForIdPath , []
    cshObj.forceSet OdseConfigs.clientStorageKeyNameForTransactions , []

  @initializeClientStorage : ( cshObj ) ->
    if ( GenericUtilities.isNotNull ( cshObj.get OdseConfigs.clientStorageKeyNameForIdPath ) ) is false
      cshObj.set OdseConfigs.clientStorageKeyNameForIdPath , []
    if ( GenericUtilities.isNotNull ( cshObj.get OdseConfigs.clientStorageKeyNameForTransactions ) ) is false
      cshObj.set OdseConfigs.clientStorageKeyNameForTransactions , []

  @callSaveNewTransactionHistoryApi : ( transactionList , cbfn ) ->
    cshObj = ClientOdseStorage.getClientStorageObject()
    cshObj.set OdseConfigs.clientStorageKeyNameForTransactions , transactionList
    cbfn 'New transaction history has been saved successfully(CLIENT).'

  @callSaveNewNodeIdPathListApi : ( nodeIdPathList , cbfn ) ->
    cshObj = ClientOdseStorage.getClientStorageObject()
    cshObj.set OdseConfigs.clientStorageKeyNameForIdPath , nodeIdPathList
    cbfn 'New node ID path list has been saved successfully(CLIENT).'

  @callGetNodeIdPathListApi : ( blobId , cbfn ) ->
    cshObj = ClientOdseStorage.getClientStorageObject()
    nodePathIdList = cshObj.get OdseConfigs.clientStorageKeyNameForIdPath
    res = []
    for item in nodePathIdList
      if item.blobId is blobId
        res = res.concat item.allNodeIdPathList
    cbfn blobId , res

  @callGetTransactionHistoryApi : ( blobId , cbfn ) ->
    cshObj = ClientOdseStorage.getClientStorageObject()
    transactionHistoryList = cshObj.get OdseConfigs.clientStorageKeyNameForTransactions
    res = []
    for item in transactionHistoryList
      if item.blobId is blobId
        res.push item
    res = TransactioNodeListManager.sort res
    cbfn blobId , res

@ClientOdseStorage = ClientOdseStorage
