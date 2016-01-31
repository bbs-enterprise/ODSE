class OdseConfigs

  @dataBlobIdLength : 20
  @nodeIdLength : 20
  @transactionIdLength : 20

  @serverIdPrefix : 'wFS'
  @clientIdPrefix : 'ri0'

  @serverRootUrl : 'http://localhost:1777/'
  @serverApiRootUrl : @serverRootUrl + 'api/1/'
  @serverAddNodeIdPathApiUrl : @serverApiRootUrl + 'add-node-id-path'

  @clientStorageKeyNameForIdPath : 'odse-id-path'
  @clientStorageKeyNameForTransactions : 'odse-transactions'


@OdseConfigs = OdseConfigs
