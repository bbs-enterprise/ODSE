{ Api } = require './api.coffee'
{ StringHandler } = require './../utility/string-handler.coffee'
{ ConstantHelper } = require './../utility/constant-helper.coffee'
{ Schema } = require 'schema-engine'

###
  class ClearAllOdseData
###

class @ClearAllOdseData extends Api

  path : 'clear-all-odse-data'
  version : 1
  isEnabled : true
  deserializeQuery : true
  aggregrateParameters : true

  handle : ( e ) ->
    odseCollectionList = [ 'odse-transactions' , 'odse-node-id-path' ]
    query = {}
    query.collection = { $in : odseCollectionList }

    @db.remove query , { multi : true } , ( err , numRemoved ) =>
      return setImmediate @respondToDatabaseError , e , err if err

      @success e , 'Deleted all the ODSE data successfully from the server. Deleted ' + numRemoved + ' documents.'

###
  class GetServerTimeStamp
###

class @GetServerTimeStamp extends Api

  path : 'get-server-time-stamp'
  version : 1
  isEnabled : true
  deserializeQuery : true
  aggregrateParameters : true

  handle : ( e ) ->
    @success e , ( '' + Date.now() )

###
  class SaveNewTransactionHistory
###

class @SaveNewTransactionHistory extends Api

  path : 'save-new-transaction-history'
  version : 1
  isEnabled : true
  deserializeQuery : true
  aggregrateParameters : true
  transactionIdLength : 20

  handle : ( e ) ->
    userDataFromApi = e.body

    for item in userDataFromApi
      if ( ConstantHelper.isNotNull item , 'val' ) is true
        item.val = '' + item.val

    saveNewTransactionHistorySchema = {}
    saveNewTransactionHistoryData = {}
    try
      saveNewTransactionHistorySchema = new Schema @schemas.saveNewTransactionHistory
      saveNewTransactionHistoryData = saveNewTransactionHistorySchema.extract userDataFromApi
    catch ex
      return setImmediate @respondToLogicalFailure , e , ex.errorDetails , 'Invalid data format for saving new transaction history.'

    for item in saveNewTransactionHistoryData
      item.collection = 'odse-transactions'
      if ( ConstantHelper.isNotNull item , 'val' ) is false
        delete item.val
      if ( ConstantHelper.isNotNull item , 'propertyName' ) is false
        delete item.propertyName

    @db.insert saveNewTransactionHistoryData , ( err , newDoc ) =>
      return setImmediate @respondToDatabaseError , e , err if err

      @success e , 'New transaction history has been saved successfully(SERVER).'

###
  class GetTransactionHistory
###

class @GetTransactionHistory extends Api

  path : 'get-transaction-history'
  version : 1
  isEnabled : true
  deserializeQuery : true
  aggregrateParameters : true

  handle : ( e ) ->
    userDataFromApi = e.body

    odseGetRequestForTransactionsAndNodeIdPathsSchema = {}
    odseGetRequestForTransactionsAndNodeIdPathsData = {}
    try
      odseGetRequestForTransactionsAndNodeIdPathsSchema = new Schema @schemas.odseGetRequestForTransactionsAndNodeIdPaths
      odseGetRequestForTransactionsAndNodeIdPathsData = odseGetRequestForTransactionsAndNodeIdPathsSchema.extract userDataFromApi
    catch ex
      return setImmediate @respondToLogicalFailure , e , ex.errorDetails , 'Invalid data format for getting transaction history.'

    query = {}
    query.collection = 'odse-transactions'
    query.blobId = odseGetRequestForTransactionsAndNodeIdPathsData.blobId

    @db.find query , ( err , docList ) =>
      return setImmediate @respondToDatabaseError , e , err if err

      for item in docList
        delete item._id
        delete item.collection

      @success e , docList

###
  class SaveNewNodeIdPathList
###

class @SaveNewNodeIdPathList extends Api

  path : 'save-new-node-id-path-list'
  version : 1
  isEnabled : true
  deserializeQuery : true
  aggregrateParameters : true

  handle : ( e ) ->
    userDataFromApi = e.body

    for item in userDataFromApi
      for secondItem in item.allNodeIdPathList
        query = {}
        query.collection = 'odse-node-id-path'
        query.blobId = item.blobId
        for key , value of secondItem
          query[ key ] = value

        @db.insert query , ( err , newDoc ) =>
          return setImmediate @respondToDatabaseError , e , err if err

    @success e , 'New node ID path list has been saved successfully(SERVER).'

###
  class GetNodeIdPathList
###

class @GetNodeIdPathList extends Api

  path : 'get-node-id-path-list'
  version : 1
  isEnabled : true
  deserializeQuery : true
  aggregrateParameters : true

  handle : ( e ) ->
    userDataFromApi = e.body

    odseGetRequestForTransactionsAndNodeIdPathsSchema = {}
    odseGetRequestForTransactionsAndNodeIdPathsData = {}
    try
      odseGetRequestForTransactionsAndNodeIdPathsSchema = new Schema @schemas.odseGetRequestForTransactionsAndNodeIdPaths
      odseGetRequestForTransactionsAndNodeIdPathsData = odseGetRequestForTransactionsAndNodeIdPathsSchema.extract userDataFromApi
    catch ex
      return setImmediate @respondToLogicalFailure , e , ex.errorDetails , 'Invalid data format for getting node id path list.'

    query = {}
    query.collection = 'odse-node-id-path'
    query.blobId = odseGetRequestForTransactionsAndNodeIdPathsData.blobId

    @db.find query , ( err , docList ) =>
      return setImmediate @respondToDatabaseError , e , err if err

      for item in docList
        delete item._id
        delete item.collection
        delete item.blobId

      @success e , docList
