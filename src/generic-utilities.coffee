{ OdseConfigs } = require './odse-configs.coffee'

class GenericUtilities

  @objectString : 'object'
  @undefinedString : 'undefined'

  ## Checks if a particular property of the "obj" parameter is null or not
  # obj = the object to whom the property belongs to
  # propertyName = name of the property to be checked for
  @isNotNull : ( obj , propertyName ) ->
    if propertyName is null || ( typeof propertyName ) is GenericUtilities.undefinedString
      if obj is null || ( typeof obj ) is GenericUtilities.undefinedString
        return false
      return true
    if obj[ propertyName ] is null || ( typeof obj[ propertyName ] ) is GenericUtilities.undefinedString
      return false
    return true

  @cloneObj : ( obj ) ->
    if not obj? or typeof obj isnt 'object'
      return obj

    if ( obj instanceof Date )
      res = ( new Date obj.getTime() )
      return res

    if ( obj instanceof RegExp )
      flags = ''
      flags += 'g' if obj.global?
      flags += 'i' if obj.ignoreCase?
      flags += 'm' if obj.multiline?
      flags += 'y' if obj.sticky?
      return new RegExp(obj.source, flags)

    newInstance = new obj.constructor()

    for key of obj
      newInstance[key] = @cloneObj obj[key]

    return newInstance

  @htmlEscape : ( stringData ) ->
    return String( stringData )
            .replace( /&/g , '&amp;' )
            .replace( /"/g , '&quot;' )
            .replace( /'/g , '&#39;' )
            .replace( /</g , '&lt;' )
            .replace( />/g , '&gt;' )

  @htmlUnescape : ( stringData ) ->
    return String( stringData )
        .replace( /&quot;/g , '"' )
        .replace( /&#39;/g , "'" )
        .replace( /&lt;/g , '<' )
        .replace( /&gt;/g , '>' )
        .replace( /&amp;/g , '&' )

  @onlyContainsDigits : ( stringData ) ->
    len = stringData.length
    res = true
    for i in [ 0 .. len - 1 ]
      if ! ( stringData.charCodeAt( i ) >= '0'.charCodeAt( 0 ) && stringData.charCodeAt( i ) <= '9'.charCodeAt( 0 ) )
        return false
    return true

  @generateRandomAlphaNumericString : ( len ) ->
    res = ''
    values = []
    for i in [ 0 ... 26 ]
      values.push ( String.fromCharCode ( ( 'a'.charCodeAt 0 ) + i ) )
    for i in [ 0 ... 26 ]
      values.push ( String.fromCharCode ( ( 'A'.charCodeAt 0 ) + i ) )
    for i in [ 0 ... 10 ]
      values.push ( String.fromCharCode ( ( '0'.charCodeAt 0 ) + i ) )
    size = values.length
    for i in [ 0 ... len ]
      idx = Math.floor( Math.random() * 1e9 ) % size
      res += values[ idx ]
    return res

  @generateRandomAlphaNumericStringWithPrefix : ( prefix , len ) ->
    res = prefix
    res += GenericUtilities.generateRandomAlphaNumericString len
    return res

  @isRunningOnServer : () ->
    try
      if window isnt null and ( typeof window ) isnt 'undefined'
        return false
    catch ex
      return true
    return true

  @generateNodeId : () ->
    nodeId = null
    if GenericUtilities.isRunningOnServer() is true
      nodeId = ( GenericUtilities.generateRandomAlphaNumericStringWithPrefix OdseConfigs.serverIdPrefix , ( OdseConfigs.nodeIdLength - OdseConfigs.serverIdPrefix.length ) )
    else
      nodeId = ( GenericUtilities.generateRandomAlphaNumericStringWithPrefix OdseConfigs.clientIdPrefix , ( OdseConfigs.nodeIdLength - OdseConfigs.clientIdPrefix.length ) )
    return nodeId

  @generateDataBlobId : () ->
    blobId = null
    if GenericUtilities.isRunningOnServer() is true
      blobId = ( GenericUtilities.generateRandomAlphaNumericStringWithPrefix OdseConfigs.serverIdPrefix , ( OdseConfigs.dataBlobIdLength - OdseConfigs.serverIdPrefix.length ) )
    else
      blobId = ( GenericUtilities.generateRandomAlphaNumericStringWithPrefix OdseConfigs.clientIdPrefix , ( OdseConfigs.dataBlobIdLength - OdseConfigs.clientIdPrefix.length ) )
    return blobId

@GenericUtilities = GenericUtilities
