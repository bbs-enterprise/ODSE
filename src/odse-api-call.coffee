http = require 'http'
{ OdseConfigs } = require './odse-configs.coffee'
{ GenericUtilities } = require './generic-utilities.coffee'
{ TransactioNodeListManager } = require './transaction-node-list-manager.coffee'
{ ClientXhrClient } = require './client-xhr-client.coffee'

class OdseApiCall

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

  @genericClientApiCall : ( partialUrl , data , cbfn ) ->
    if ( typeof data ) is 'object'
      data = JSON.stringify data
    cxcObj = new ClientXhrClient()
    url = OdseConfigs.webProtocol + OdseConfigs.hostName + ':' + OdseConfigs.hostPort + '/' + OdseConfigs.serverApiPathSignature + partialUrl
    cxcObj.postRequest url , data , cbfn

  @getWebRequestObject : () ->
    if GenericUtilities.isRunningOnServer() is true
      return OdseApiCall.genericServerApiCall
    else
      return OdseApiCall.genericClientApiCall

  @clearAllOdseDataApi : ( cbfn ) ->
    webRequestMethod = OdseApiCall.getWebRequestObject()
    webRequestMethod 'clear-all-odse-data' , {} , ( response ) =>
      if ( GenericUtilities.isNotNull cbfn ) is true
        cbfn response.data

  @callSaveNewTransactionHistoryApi : ( transactionList , cbfn ) ->
    webRequestMethod = OdseApiCall.getWebRequestObject()
    webRequestMethod 'save-new-transaction-history' , transactionList , ( response ) =>
      if ( GenericUtilities.isNotNull cbfn ) is true
        cbfn response.data

  @callGetTransactionHistoryApi : ( blobId , cbfn ) ->
    webRequestMethod = OdseApiCall.getWebRequestObject()
    webRequestMethod 'get-transaction-history' , { blobId : blobId } , ( response ) =>
      if ( GenericUtilities.isNotNull cbfn ) is true
        response.data = TransactioNodeListManager.sort response.data
        cbfn blobId , response.data

  @callSaveNewNodeIdPathListApi : ( nodeIdPathList , cbfn ) ->
    webRequestMethod = OdseApiCall.getWebRequestObject()
    webRequestMethod 'save-new-node-id-path-list' , nodeIdPathList , ( response ) =>
      if ( GenericUtilities.isNotNull cbfn ) is true
        cbfn response.data

  @callGetNodeIdPathListApi : ( blobId , cbfn ) ->
    webRequestMethod = OdseApiCall.getWebRequestObject()
    webRequestMethod 'get-node-id-path-list' , { blobId : blobId } , ( response ) =>
      if ( GenericUtilities.isNotNull cbfn ) is true
        cbfn blobId , response.data

@OdseApiCall = OdseApiCall
