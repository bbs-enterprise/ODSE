class OdseConfigs

  @dataBlobIdLength : 20
  @nodeIdLength : 20
  @transactionIdLength : 20
  @userIdLength : 128

  @serverIdPrefix : 'wFS'
  @clientIdPrefix : 'ri0'

  @webProtocol : 'http://'
  @hostName : 'localhost'
  @hostPort : '8671'
  @serverRootUrl : @webProtocol + @hostName + ':' + @hostPort + '/'
  @serverApiPathSignature : 'api/1/'
  @serverApiRootUrl : @serverRootUrl + @serverApiPathSignature
  @serverAddNodeIdPathApiUrl : @serverApiRootUrl + 'add-node-id-path'

  @clientStorageKeyNameForIdPath : 'odse-id-path'
  @clientStorageKeyNameForTransactions : 'odse-transactions'

  @newArrayStringConstant : 'new-array'
  @newObjectStringConstant : 'new-object'
  @newPrimitiveStringConstant : 'new-primitive'
  @arrayPushStringConstant : 'array-push'
  @objectAddStringConstant : 'object-add'
  @arrayRemoveStringConstant : 'array-remove'
  @objectRemoveStringConstant : 'object-remove'
  @primitiveRemoveStringConstant : 'primitive-remove'
  @primitiveRemoveStringConstant : 'primitive-update'


@OdseConfigs = OdseConfigs
