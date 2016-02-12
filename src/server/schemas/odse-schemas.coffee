{ crypto } = require 'crypto'
{ StringHandler } = require './../utility/string-handler.coffee'

@saveNewTransactionHistory =
{
  allowNull : false
  type : 'array'
  validation :
    custom :
      message : 'Transaction list required.'
      params : [ '.' ]
      fn : ( transactionList ) ->
        if transactionList.length is 0
          return false
        return true
  def :
    transactionId :
      allowNull : false
      type : 'string'
      validation :
        message : 'Transaction ID required.'
        AND : [
          {
            minLength : 20
            maxLength : 20
          }
        ]
    createdTimeStamp :
      allowNull : false
      type : 'integer'
      validation :
        message : 'Created timestamp required.'
        AND : [
          {
            minLength : 13
            maxLength : 13
          }
        ]
    userId :
      allowNull : false
      type : 'string'
      validation :
        message : 'User ID required.'
        AND : [
          {
            minLength : 128
            maxLength : 128
          }
        ]
    blobId :
      allowNull : false
      type : 'string'
      validation :
        message : 'Blob ID required.'
        AND : [
          {
            minLength : 20
            maxLength : 20
          }
        ]
    nodeId :
      allowNull : false
      type : 'string'
      validation :
        message : 'Node ID required.'
        AND : [
          {
            minLength : 20
            maxLength : 20
          }
        ]
    type :
      allowNull : false
      type : 'string'
      validation :
        message : 'Transaction Type required.'
        AND : [
          {
            minLength : 1
            maxLength : 64
          }
        ]
    val :
      allowNull : true
      type : 'string'
      validation :
        message : 'Value required.'
        AND : [
          {
            minLength : 1
            maxLength : 100000
          }
        ]
    propertyName :
      allowNull : true
      type : 'string'
      validation :
        message : 'Value required.'
        AND : [
          {
            minLength : 1
            maxLength : 128
          }
        ]
}

@odseGetRequestForTransactionsAndNodeIdPaths =
{
  allowNull : false
  type : 'object'
  map :
    blobId :
      allowNull : false
      type : 'string'
      validation :
        message : 'Blob ID required.'
        AND : [
          {
            minLength : 20
            maxLength : 20
          }
        ]
}
