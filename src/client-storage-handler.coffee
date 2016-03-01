{ GenericUtilities } = require './generic-utilities.coffee'

class ClientStorageHandler

  storageObj = null

  constructor : () ->
    try
      storageObj = localStorage
      #Change this localStorage variable to the desired storage system. Also change the method calls for the storage object in the below three functions(_getItem, _setItem, clearTheWholeStorage).
    catch ex
      storageObj = null

  _getItem = ( key ) ->
    value = storageObj.getItem key
    return value

  _setItem = ( key , value ) ->
    storageObj.setItem key , value

  clearTheStorage : ( key ) =>
    storageObj.removeItem key

  forceSet : ( key , value ) =>
    value = JSON.stringify value
    _setItem key , value

  set : ( key , value ) =>
    if ( GenericUtilities.isNotNull ( @get key ) ) is false
      value = JSON.stringify value
      _setItem key , value
    else
      storedValue = @get key
      if ( typeof storedValue ).toLowerCase() is 'object' and Array.isArray storedValue
        for item in value
          storedValue.push item
      else if ( typeof storedValue ).toLowerCase() is 'object'
        for key , item of value
          storedValue[ key ] = item
      else
        throw new Error 'Invalid approach to store data on client side.'
      value = JSON.stringify storedValue
      _setItem key , value

  get : ( key ) =>
    value = ( _getItem key )
    value = JSON.parse value
    return value

@ClientStorageHandler = ClientStorageHandler
