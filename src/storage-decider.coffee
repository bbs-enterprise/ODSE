{ GenericUtilities } = require './generic-utilities.coffee'
{ OdseApiCall } = require './odse-api-call.coffee'
{ ClientOdseStorage } = require './client-odse-storage.coffee'
{ OdseConfigs } = require './odse-configs.coffee'

class StorageDecider

  @clearServerStorage : ( cbfn ) ->
    OdseApiCall.clearAllOdseDataApi cbfn

  @clearClientStorage : ( cbfn ) ->
    ClientOdseStorage.clearTheClientOdseStorageData()

  @initializeClientStorage : () ->
    ClientOdseStorage.initializeClientStorage()

  @saveNewTransactionHistory : ( transactionList , cbfn ) ->
    if GenericUtilities.isRunningOnServer() is true
      OdseApiCall.callSaveNewTransactionHistoryApi transactionList , cbfn

  @saveNewNodeIdPathList : ( nodeIdPathList , cbfn ) ->
    if GenericUtilities.isRunningOnServer() is true
      OdseApiCall.callSaveNewNodeIdPathListApi nodeIdPathList , cbfn

  @saveBothTransactionHistoryAndNewNodeIdPathList : ( transactionList , nodeIdPathList , blobId , cbfn ) ->
    nodeIdPathList = [ nodeIdPathList ]
    if GenericUtilities.isRunningOnServer() is true
      OdseApiCall.callSaveNewTransactionHistoryApi transactionList , ( saveNewTransactionHistoryResponse ) =>
        OdseApiCall.callSaveNewNodeIdPathListApi nodeIdPathList , ( saveNewNodeIdPathListResponse ) =>
          cbfn saveNewTransactionHistoryResponse , saveNewNodeIdPathListResponse , blobId
    else
      ClientOdseStorage.callSaveNewTransactionHistoryApi transactionList , ( saveNewTransactionHistoryResponse ) =>
        ClientOdseStorage.callSaveNewNodeIdPathListApi nodeIdPathList , ( saveNewNodeIdPathListResponse ) =>
          cbfn saveNewTransactionHistoryResponse , saveNewNodeIdPathListResponse , blobId

  @getNodeIdPathList : ( blobId , cbfn ) ->
    if GenericUtilities.isRunningOnServer() is true
      OdseApiCall.callGetNodeIdPathListApi blobId , cbfn
    else
      ClientOdseStorage.callGetNodeIdPathListApi blobId , cbfn

  @getTransactionHistory : ( blobId , cbfn ) ->
    if GenericUtilities.isRunningOnServer() is true
      OdseApiCall.callGetTransactionHistoryApi blobId , cbfn
    else
      ClientOdseStorage.callGetTransactionHistoryApi blobId , cbfn

@StorageDecider = StorageDecider
