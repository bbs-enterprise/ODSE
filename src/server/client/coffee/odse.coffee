class window.app.odse.TransactioNodeListManager

  @sort : ( transactionNodeList ) ->
    sortedTransactionNodeList = transactionNodeList.sort ( left , right ) ->
      return left.createdTimeStamp - right.createdTimeStamp
    return sortedTransactionNodeList

window.app.odse.TransactioNodeListManager = window.app.odse.TransactioNodeListManager
