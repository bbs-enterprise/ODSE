{ GenericUtilities } = require './generic-utilities.coffee'
{ ServerOdseApiCall } = require './server-odse-api-call.coffee'

class StorageDecider

  @clearServerStorage : ( cbfn ) ->
    ServerOdseApiCall.clearAllOdseDataApi cbfn

  @clearClientStorage : ( cbfn ) ->
    #to-do

  @saveNewTransactionHistory : ( transactionList , cbfn ) ->
    if GenericUtilities.isRunningOnServer() is true
      ServerOdseApiCall.callSaveNewTransactionHistoryApi transactionList , cbfn

  @saveNewNodeIdPathList : ( nodeIdPathList , cbfn ) ->
    if GenericUtilities.isRunningOnServer() is true
      ServerOdseApiCall.callSaveNewNodeIdPathListApi nodeIdPathList , cbfn

  @saveBothTransactionHistoryAndNewNodeIdPathList : ( transactionList , nodeIdPathList , cbfn ) ->
    if GenericUtilities.isRunningOnServer() is true
      ServerOdseApiCall.callSaveNewTransactionHistoryApi transactionList , ( saveNewTransactionHistoryResponse ) =>
        ServerOdseApiCall.callSaveNewNodeIdPathListApi nodeIdPathList , ( saveNewNodeIdPathListResponse ) =>
          cbfn saveNewTransactionHistoryResponse , saveNewNodeIdPathListResponse

  @getNodeIdPathList : ( blobId , cbfn ) ->
    if GenericUtilities.isRunningOnServer() is true
      ServerOdseApiCall.callGetNodeIdPathListApi blobId , cbfn

  @getTransactionHistory : ( blobId , cbfn ) ->
    if GenericUtilities.isRunningOnServer() is true
      ServerOdseApiCall.callGetTransactionHistoryApi blobId , cbfn

@StorageDecider = StorageDecider
