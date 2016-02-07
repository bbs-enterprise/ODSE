class TransactioNodeListManager

  @sort : ( transactionNodeList ) ->
    sortedTransactionNodeList = transactionNodeList.sort ( left , right ) ->
      return left.createdTimeStamp - right.createdTimeStamp
    return sortedTransactionNodeList

@TransactioNodeListManager = TransactioNodeListManager
