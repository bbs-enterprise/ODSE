http = require 'http'
{ OdseConfigs } = require './odse-configs.coffee'
{ GenericUtilities } = require './generic-utilities.coffee'
{ TransactioNodeListManager } = require './transaction-node-list-manager.coffee'

class ServerOdseApiCall

  @genericServerApiCall : ( partialUrl , data , cbfn ) ->
    if ( typeof data ) is 'object'
      data = JSON.stringify data
    options = {}
    options.host = OdseConfigs.hostName
    options.port = OdseConfigs.hostPort
    options.path = '/' + OdseConfigs.serverApiPathSignature + partialUrl
    options.method = 'POST'
    options.headers = {
      'Content-Type' : 'application/json' ,
      'Content-Length' : Buffer.byteLength( data )
    }
    result = ''
    requestObj = http.request options , ( responseObj ) =>
      responseObj.on 'data' , ( chunk ) =>
        result += chunk
      responseObj.on 'end' , () =>
        cbfn ( JSON.parse result )
    requestObj.write data
    requestObj.end()

  @clearAllOdseDataApi : ( cbfn ) ->
    ServerOdseApiCall.genericServerApiCall 'clear-all-odse-data' , {} , ( response ) =>
      if ( GenericUtilities.isNotNull cbfn ) is true
        cbfn response.data

  @callSaveNewTransactionHistoryApi : ( transactionList , cbfn ) ->
    ServerOdseApiCall.genericServerApiCall 'save-new-transaction-history' , transactionList , ( response ) =>
      if ( GenericUtilities.isNotNull cbfn ) is true
        cbfn response.data

  @callGetTransactionHistoryApi : ( blobId , cbfn ) ->
    ServerOdseApiCall.genericServerApiCall 'get-transaction-history' , { blobId : blobId } , ( response ) =>
      if ( GenericUtilities.isNotNull cbfn ) is true
        response.data = TransactioNodeListManager.sort response.data
        cbfn blobId , response.data

  @callSaveNewNodeIdPathListApi : ( nodeIdPathList , cbfn ) ->
    ServerOdseApiCall.genericServerApiCall 'save-new-node-id-path-list' , nodeIdPathList , ( response ) =>
      if ( GenericUtilities.isNotNull cbfn ) is true
        cbfn response.data

  @callGetNodeIdPathListApi : ( blobId , cbfn ) ->
    ServerOdseApiCall.genericServerApiCall 'get-node-id-path-list' , { blobId : blobId } , ( response ) =>
      if ( GenericUtilities.isNotNull cbfn ) is true
        cbfn blobId , response.data

@ServerOdseApiCall = ServerOdseApiCall
