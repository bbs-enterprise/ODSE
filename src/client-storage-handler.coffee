{ GenericUtilities } = require './generic-utilities.coffee'

class ClientStorageHandler

  storageObj = null

  constructor : () ->
    try
      storageObj = localStorage
    catch ex
      storageObj = null

  initializeStorage : ( key ) ->
    a = 1
    #if GenericUtilities.isNotNull

  set : ( key , value ) =>
    if ( GenericUtilities.isNotNull ( @get key ) ) is false
      value = JSON.stringify value
      storageObj.setItem key , value
    else
      storedValue = @get key
      storedValue = JSON.parse storedValue
      if ( typeof storedValue ).toLowerCase() is 'object' and Array.isArray storedValue
        for item in value
          storedValue.push item
      else if ( typeof storedValue ).toLowerCase() is 'object'
        for key , item of value
          storedValue[ key ] = item
      else
        throw new Error 'Invalid approach to store data on client side.'
      value = JSON.stringify storedValue
      storageObj.setItem key , value

  get : ( key ) =>
    value = ( storageObj.getItem key )
    value = JSON.parse value
    return value

@ClientStorageHandler = ClientStorageHandler
