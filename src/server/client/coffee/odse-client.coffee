window.odse = {} ;

class TransactioNodeListManager

  @sort : ( transactionNodeList ) ->
    sortedTransactionNodeList = transactionNodeList.sort ( left , right ) ->
      return left.createdTimeStamp - right.createdTimeStamp
    return sortedTransactionNodeList

window.odse.TransactioNodeListManager =TransactioNodeListManager
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


window.odse.OdseConfigs =OdseConfigs

class GenericUtilities

  @objectString : 'object'
  @undefinedString : 'undefined'

  ## Checks if a particular property of the "obj" parameter is null or not
  # obj = the object to whom the property belongs to
  # propertyName = name of the property to be checked for
  @isNotNull : ( obj , propertyName ) ->
    if propertyName is null || ( typeof propertyName ) is window.odse.GenericUtilities.undefinedString
      if obj is null || ( typeof obj ) is window.odse.GenericUtilities.undefinedString
        return false
      return true
    if obj[ propertyName ] is null || ( typeof obj[ propertyName ] ) is window.odse.GenericUtilities.undefinedString
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
    res += window.odse.GenericUtilities.generateRandomAlphaNumericString len
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
    if window.odse.GenericUtilities.isRunningOnServer() is true
      nodeId = ( window.odse.GenericUtilities.generateRandomAlphaNumericStringWithPrefix window.odse.OdseConfigs.serverIdPrefix , ( window.odse.OdseConfigs.nodeIdLength - window.odse.OdseConfigs.serverIdPrefix.length ) )
    else
      nodeId = ( window.odse.GenericUtilities.generateRandomAlphaNumericStringWithPrefix window.odse.OdseConfigs.clientIdPrefix , ( window.odse.OdseConfigs.nodeIdLength - window.odse.OdseConfigs.clientIdPrefix.length ) )
    return nodeId

  @generateDataBlobId : () ->
    blobId = null
    if window.odse.GenericUtilities.isRunningOnServer() is true
      blobId = ( window.odse.GenericUtilities.generateRandomAlphaNumericStringWithPrefix window.odse.OdseConfigs.serverIdPrefix , ( window.odse.OdseConfigs.dataBlobIdLength - window.odse.OdseConfigs.serverIdPrefix.length ) )
    else
      blobId = ( window.odse.GenericUtilities.generateRandomAlphaNumericStringWithPrefix window.odse.OdseConfigs.clientIdPrefix , ( window.odse.OdseConfigs.dataBlobIdLength - window.odse.OdseConfigs.clientIdPrefix.length ) )
    return blobId

window.odse.GenericUtilities =GenericUtilities

class TransactioNode

  transactionId : null
  createdTimeStamp : null
  userId : null
  blobId : null
  nodeId : null
  type : null
  val : null
  propertyName : null

  constructor : ( userIdParam , blobIdParam , nodeIdParam , typeParam , valParam , propertyNameParam ) ->
    @transactionId = ( window.odse.GenericUtilities.generateRandomAlphaNumericStringWithPrefix window.odse.OdseConfigs.clientIdPrefix , ( window.odse.OdseConfigs.transactionIdLength - window.odse.OdseConfigs.clientIdPrefix.length ) )
    @createdTimeStamp = Date.now()
    @userId = userIdParam
    @blobId = blobIdParam
    @nodeId = nodeIdParam
    @type = typeParam
    if ( window.odse.GenericUtilities.isNotNull valParam ) is true
      @val = valParam
    if ( window.odse.GenericUtilities.isNotNull propertyNameParam ) is true
      @propertyName = propertyNameParam

window.odse.TransactioNode =TransactioNode


class Iterator

  constructor: (@list, @forEachFn)->
    @index = 0
    @hasIterationEnded = false
    @next()

  next: ()=>
    if @index == @list.length
      @hasIterationEnded = true
      if @finalFn and @hasIterationEnded
        cb = @finalFn
        @finalFn = null
        cb()
    else
      oldIndex = @index
      @index++
      @forEachFn @next, oldIndex, @list[oldIndex]

  then: (@finalFn)=>
    if @finalFn and @hasIterationEnded
      cb = @finalFn
      @finalFn = null
      cb()

window.odse.Iterator =Iterator


iterate = (list, forEachFn) ->
  new window.odse.Iterator list, forEachFn

window.odse.iterate =iterate




class EventEmitter

  constructor: ()->
    @_EventClassMap = {}
    @register window.odse.ErrorEvent, 'error'

  __getProperEventName: (eventArg)->
    if typeof eventArg is 'object' and eventArg.prototype instanceof window.odse.Event
      return eventArg.prototype.name
    else if typeof eventArg is 'string'
      return eventArg
    else
      throw new Error 'Type Mismatch. Expected <Event> or <string>'

  isRegistered: (name)-> name of @_EventClassMap

  register: (EventClass, name = null)->
    name = EventClass.prototype.name unless name
    throw new Error "Event <#{name}> is already registered" if @isRegistered name
    @_EventClassMap[name] = {
      earlyHandlerList: []
      lateHandlerList: []
      handlerList: []
      EventClass
    }
    return @

  addEventHandler: (args...)->

    if args.length is 2
      [eventArg, handlerFn] = args
      modifier = null
    else if args.length is 3
      [eventArg, modifier, handlerFn] = args
    else if args.length is 4
      [eventArg, modifier, executionContext, handlerFn] = args

    if executionContext
      handlerFn = handlerFn.bind executionContext
    else
      handlerFn = handlerFn.bind @

    throw new Error 'Type Mismatch. Expected <function>' unless typeof handlerFn is 'function'

    name = @__getProperEventName eventArg

    unless @isRegistered name
      throw new Error "Event <#{name}> is not registered and so can not be listened to."

    if modifier is null
      @_EventClassMap[name].handlerList.push handlerFn
    else if modifier is 'late'
      @_EventClassMap[name].lateHandlerList.push handlerFn
    else if modifier is 'early'
      @_EventClassMap[name].earlyHandlerList.push handlerFn
    else
      throw new Error 'Unknown Modifier'

    return @

  on: @::addEventHandler

  removeEventHandler: (eventArg, handlerFn = null)->

    name = @__getProperEventName eventArg

    unless @isRegistered name
      throw new Error "Event <#{name}> is not registered and so nothing to remove listener from"

    if handlerFn is null
      @_EventClassMap[name].handlerList = {}
    else
      throw new Error 'Type Mismatch. Expected <function>' unless typeof handlerFn is 'function'
      if (pos=@_EventClassMap[name].handlerList.indexOf handlerFn) > -1
        @_EventClassMap[name].handlerList.splice pos, 1
      else
        throw new Error 'handler does not exist and so can not be removed'

  off: @::removeEventHandler

  # TODO: Improve Performance. I mostly suppressed the call. We need to remove the call instead.
  once: (eventArg, handlerFn)->
    called = false
    fn = (args...)=>
      if called
        args[0].next()
      else
        handlerFn.apply @, args
      called = true
    @on eventArg, fn

  getEventHandlerList: (eventArg)->

    name = @__getProperEventName eventArg

    unless @isRegistered name
      throw new Error "Event <#{name}> is not registered and so can not be emitted."

    return [].concat @_EventClassMap[name].earlyHandlerList, @_EventClassMap[name].handlerList, @_EventClassMap[name].lateHandlerList


  emit: (eventArg, data = null, completionHandler = null)->

    name = @__getProperEventName eventArg

    unless @isRegistered name
      throw new Error "Event <#{name}> is not registered and so can not be emitted."

    eventObject = new (@_EventClassMap[name].EventClass) origin: @, target: @, data: data, name:name
    eventObject.setCompletionCallback completionHandler if completionHandler
    eventObject.dispatch()

    return @

window.odse.EventEmitter =EventEmitter


class Event extends window.odse.EventEmitter

  @isSequencial: true
  @isAsync: true

  @fallbackHandler: null

  name: 'Event'

  constructor: ({@origin, @target, data, handlerList, name} = {})->

    super

    unless ((@origin is null) or (typeof @origin is 'object' and @origin instanceof window.odse.EventEmitter))
      throw new Error 'Type Mismatch. Expected origin to be <null> or <EventEmitter>'

    unless ((@target is null) or (typeof @target is 'object' and @target instanceof window.odse.EventEmitter))
      throw new Error 'Type Mismatch. Expected target to be <null> or <EventEmitter>'

    @target = @origin if @origin and not @target
    @origin = @target if @target and not @origin

    @storedData = data
    @storedData or = {}

    if typeof name is 'string'
      @name = name
    else
      try
        if @name is 'Event' and @constructor.name isnt 'Event'
          @name = @constructor.name
      catch ex

    if typeof handlerList is 'object' and Array.isArray handlerList
      @_handlerList = handlerList
    else
      throw new Error 'Insufficient Information to trigger event' unless @target
      @_handlerList = @target.getEventHandlerList @name

    if @_handlerList.length is 0 and @constructor.fallbackHandler isnt null
      @_handlerList = [@constructor.fallbackHandler]

    throw new Error 'Type Mismatch. Expected <array>' unless typeof @_handlerList is 'object' and Array.isArray @_handlerList

    throw new Error 'Type Mismatch. Expected <object>' unless typeof @storedData is 'object'

    @_handlerIndex = 0
    @_completionCallback = null

    @hasPropagationStopped = false
    @isDispatched = false

    @path = [ @target ]

  setCompletionCallback: (fn)->
    throw new Error 'Type Mismatch. Expected <function>' unless typeof fn is 'function'
    @_completionCallback = fn
    return @

  _invokeCompletionCallback: ->
    return false unless @_completionCallback
    cbfn = @_completionCallback
    @_completionCallback = null
    cbfn @

  stopPropagation: ()=>
    @hasPropagationStopped = true
    return @

  dispatch: ()=>
    throw new Error 'Event is already dispatched' if @isDispatched
    @isDispatched = true
    if @constructor.isSequencial and @constructor.isAsync
      @next()
    else
      for handlerFn in @_handlerList
        handlerFn @
      @_invokeCompletionCallback()

  next: ()=>
    throw new Error 'next() is available only during Async Events' unless @constructor.isAsync
    throw new Error 'next() can only be called after the event is dispatched' unless @isDispatched
    return false unless @constructor.isSequencial ## NOTE: silently avoid this error because this error has practically no effect

    if @_handlerList.length == @_handlerIndex or @hasPropagationStopped
      @_invokeCompletionCallback()
      return

    handlerFn = @_handlerList[@_handlerIndex++]
    handlerFn @
    return

  reset: =>
    @_handlerIndex = 0
    return @

  delegate: ({target, name, handlerList} = {}, postDelegationHandler = null)->

    unless typeof handlerList is 'object' and Array.isAarry handlerList
      throw new Error 'Insufficient Information to delegate event' unless target
      name = @name unless name
      handlerList = target.getEventHandlerList name

    target = @target unless target

    # @path = [] unless 'path' of @
    @path.push target

    replacementCompletionHandler = ()=>
      postDelegationHandler @ if postDelegationHandler

    @target = target
    @isDispatched = false
    @_handlerList = handlerList
    @_handlerIndex = 0
    @_completionCallback = replacementCompletionHandler
    @dispatch()


  # delegate: ({target, name, handlerList} = {}, postDelegationHandler = null)->
  #
  #   unless typeof handlerList is 'object' and Array.isAarry handlerList
  #     throw new Error 'Insufficient Information to delegate event' unless target
  #     name = @name unless name
  #     handlerList = target.getEventHandlerList name
  #
  #   target = @target unless target
  #
  #   backup =
  #     _handlerList:@_handlerList
  #     _handlerIndex:@_handlerIndex
  #     _completionCallback:@_completionCallback
  #     ## hasPropagationStopped:@hasPropagationStopped
  #     isDispatched:@isDispatched
  #     target:@target
  #   replacementCompletionHandler = ()=>
  #     {
  #       @_handlerList
  #       @_handlerIndex
  #       @_completionCallback
  #       ## @hasPropagationStopped
  #       @isDispatched
  #       @target
  #     } = backup
  #     if postDelegationHandler
  #       postDelegationHandler @
  #     else
  #       @next() ## NOTE: unsure. may need other conditionals
  #
  #   ## @hasPropagationStopped = false
  #   @isDispatched = false
  #   @_handlerList = handlerList
  #   @_handlerIndex = 0
  #   @_completionCallback = replacementCompletionHandler
  #   @dispatch()

window.odse.Event =Event

class ErrorEvent extends window.odse.Event

  @isAsync: true
  @isSequencial: false

  @fallbackHandler: (e)->
    console.log 'Unmonitored Error'
    console.log "  Code: #{e.code}"
    console.log "  Details: #{e.details}"
    console.log "  Is Resolved: #{e.isResolved}"
    console.log "  Resolution: #{e.resolution}"

  constructor: (options)->
    super options
    @code = options.data.code
    @details = options.data.details
    @isResolved = options.data.isResolved
    @isResolved or= false
    @resolution = options.data.resolution
    @resolution or= null


window.odse.ErrorEvent =ErrorEvent





class OdseEvent extends window.odse.Event

  @isSequencial: true
  @isAsync: true
  constructor: ->
    super
    @detail = @storedData

window.odse.OdseEvent =OdseEvent

class BubbleableOdseEvent extends window.odse.OdseEvent

  constructor: ->
    super
    @isBubblingStopped = false
    @setCompletionCallback @_nodeCompletionHandler

  stopBubbling: ->
    @isBubblingStopped = true
    return @

  bubbleUp: =>
    return false if @isBubblingStopped
    return false unless @target.parentList and typeof @target.parentList is 'object' and Array.isArray @target.parentList
    return false if @target.parentList.length is 0
    if @target.parentList.length > 1
      throw new window.odse.VendorError "Still unable to handle multiple parents"
    parent = @target.parentList[0]
    @delegate { target:parent }, @_nodeCompletionHandler
    return @

  _nodeCompletionHandler: (e)=>
    @bubbleUp()

window.odse.BubbleableOdseEvent =BubbleableOdseEvent





class OdseNode extends window.odse.EventEmitter

  @seed: 0
  nodeId : null
  createdTimeStamp : null
  lastUpdateTimeStamp : null

  constructor: ->
    super
    @register window.odse.BubbleableOdseEvent, 'create'
    @register window.odse.BubbleableOdseEvent, 'attach'
    @register window.odse.BubbleableOdseEvent, 'detach'
    @register window.odse.BubbleableOdseEvent, 'remove'
    @serial = window.odse.OdseNode.seed++
    @parentList = []
    setImmediate => @emit 'create', { node: @ }

    @nodeId = window.odse.GenericUtilities.generateNodeId()
    @createdTimeStamp = Date.now()
    @lastUpdateTimeStamp = @createdTimeStamp

  _attachTo: (parentNode)->
    throw new Error "Expected <ContainerNode>" unless parentNode instanceof window.odse.ContainerNode
    @parentList.push parentNode
    setImmediate => @emit 'attach', { node: @, to: parentNode }

  _detachFrom: (parentNode)->
    throw new Error "Expected <ContainerNode>" unless parentNode instanceof window.odse.ContainerNode
    throw new Error "Node is not attached." unless (index = @parentList.indexOf parentNode) > -1
    @parentList.splice index, 1
    setImmediate => @emit 'detach', { node: @, from: parentNode }

  remove: ->
    for parentNode in @parentList
      parentNode.forceRemoveChild @
    setImmediate => @emit 'remove', { node: @ }

window.odse.OdseNode =OdseNode

class ValueNode extends window.odse.OdseNode

  constructor: ->
    super
    @register window.odse.BubbleableOdseEvent, 'set'
    @__value = null

  __setValue: (newValue)->
    @__value = newValue
    # NOTE: This method is meant to be overriden by any child

  setValue: (newValue)->
    oldValue = @__value
    @__setValue newValue
    setImmediate => @emit 'set', { node: @, oldValue, newValue }

window.odse.ValueNode =ValueNode

class PrimitiveNode extends window.odse.ValueNode

  constructor: (value = null)->
    super
    @__setValue value

  getValue: ->
    return @__value

window.odse.PrimitiveNode =PrimitiveNode

class ContainerNode extends window.odse.ValueNode
  constructor: ->
    super
    @register window.odse.BubbleableOdseEvent, 'update'

window.odse.ContainerNode =ContainerNode

class ObjectNode extends window.odse.ContainerNode

  constructor: (map = null)->
    super
    @childrenMap = {}
    @__setValue map

  __setValue: (newValue)->
    super
    unless newValue is null or (typeof newValue is 'object' and not Array.isArray newValue)
      throw new window.odse.ExtendedError "E_EXP_OBJECT", "Expected <object>", newValue
    @__resetMap()
    return unless newValue
    for key, value of newValue
      @childrenMap[key] = window.odse.ObjectDataStorageEngine.parse value
      @childrenMap[key]._attachTo @

  __resetMap: ->
    for key, node of @childrenMap
      node._detachFrom @
    @childrenMap = {}

  addNode: (key, node)->
    throw new Error "Missing key/node" unless key and node
    detail = {
      node: @
      childNode: node
      operation: 'child-add'
      key: key
    }
    if key of @childrenMap
      oldNode = @childrenMap[key]
      oldNode._detachFrom @
      detail.operation = 'child-replace'
      detail.replacedChildNode = oldNode
    @childrenMap[key] = node
    node._attachTo @
    setImmediate => @emit 'update', detail

  removeNode: (key)->
    throw new Error "Unknown Key" unless key of @childrenMap
    node = @childrenMap[key]
    detail = {
      node: @
      childNode: node
      operation: 'child-remove'
      key: key
    }
    node._detachFrom @
    delete @childrenMap[key]
    setImmediate => @emit 'update', detail

  remove: ->
    for key, node of @childrenMap
      node._detachFrom @
    @childrenMap = {}
    super

  forceRemoveChild: (nodeToRemove)->
    for key, node of @childrenMap
      if node is nodeToRemove
        @removeNode key

  forEach: (fn)->
    throw new Error "Expected <function>" unless typeof fn is 'function'
    for key, node of @childrenMap
      fn key, node

  forEachAsync: (fn)->
    throw new Error "Expected <function>" unless typeof fn is 'function'
    return window.odse.iterate Object.keys(@childrenMap), (next, index, key)=>
      # NOTE: fn will receive callback as (next, key, node)
      fn next, key, @getNode key

  getKeyList: ->
    return Object.keys(@childrenMap)

  getNode: (key)->
    throw new Error "Unknown Key" unless key of @childrenMap
    return @childrenMap[key]

  hasNode: (key)->
    return (key of @childrenMap)

window.odse.ObjectNode =ObjectNode

class ArrayNode extends window.odse.ContainerNode

  constructor: (array = [])->
    super
    @childrenList = []
    @__setValue array

  __setValue: (newValue)->
    super
    unless (typeof newValue is 'object' and Array.isArray newValue)
      throw new Error "Expected <object>"
    @__resetList()
    return unless newValue and newValue.length > 0
    for value, index in newValue
      @childrenList.push window.odse.ObjectDataStorageEngine.parse value
      @childrenList[ @childrenList.length-1 ]._attachTo @

  __resetList: ->
    for node, index in @childrenList
      node._detachFrom @
    @childrenList = []

  removeNode: (index)->
    throw new Error "index out of bound" unless 0 <= index < @childrenList.length
    node = @childrenList[index]
    detail = {
      node: @
      childNode: node
      operation: 'child-remove'
      index: index
    }
    node._detachFrom @
    @childrenList.splice index, 1
    setImmediate => @emit 'update', detail

  __pushNode: (node, op, atTheEnd)->
    detail = {
      node: @
      childNode: node
      operation: op
      index: null
    }
    detail.index = if atTheEnd then @childrenList.push node else @childrenList.unshift node
    node._attachTo @
    setImmediate => @emit 'update', detail

  pushNode: (node)->
    return @__pushNode node, 'child-push', true

  unshiftNode: (node)->
    return @__pushNode node, 'child-unshift', false

  __popNode: (op, atTheEnd)->
    return false if @childrenList.length is 0
    detail = {
      node: @
      childNode: @childrenList[@childrenList.length-1]
      operation: op
      index: @childrenList.length - 1
    }
    (if atTheEnd then @childrenList.pop() else @childrenList.shift())._detachFrom @
    setImmediate => @emit 'update', detail

  popNode: ->
    return @__popNode 'child-pop', true

  shiftNode: ->
    return @__popNode 'child-shift', false

  remove: ->
    for node, index in @childrenList
      node._detachFrom @
    @childrenList = {}
    super

  forceRemoveChild: (nodeToRemove)->
    for node, index in @childrenList
      if node is nodeToRemove
        @removeNode index

  forEach: (fn)->
    throw new Error "Expected <function>" unless typeof fn is 'function'
    for node, index in @childrenList
      fn node, index

  forEachAsync: (fn)->
    throw new Error "Expected <function>" unless typeof fn is 'function'
    # NOTE: fn will receive callback as (next, index, node)
    return window.odse.iterate @childrenList, fn

  getLength: ->
    return @childrenList.length

  getNode: (index)->
    throw new Error "index out of bound" unless 0 <= index < @childrenList.length
    return @childrenList[index]

  indexOf: (node)->
    return @childrenList.indexOf node

  lastIndexOf: (node)->
    return @childrenList.lastIndexOf node

window.odse.ArrayNode =ArrayNode

class ObjectDataStorageEngine

  @parse: (json, doForEachFn = null)->
    type = typeof json
    if type is 'object' and json isnt null
      if Array.isArray json
        node = new window.odse.ArrayNode json
      else
        node = new window.odse.ObjectNode json
    else
      node = new window.odse.PrimitiveNode json
    doForEachFn node if doForEachFn
    return node

window.odse.ObjectDataStorageEngine =ObjectDataStorageEngine


class TransactioNodeManager

  transactionList : null

  constructor : () ->
    @transactionList = []

  processAndAddTransactionToList : ( transactioNodeObj ) ->
    if @transactionList.length > 0
      if @transactionList[ @transactionList.length - 1 ].createdTimeStamp >= transactioNodeObj.createdTimeStamp
        transactioNodeObj.createdTimeStamp = @transactionList[ @transactionList.length - 1 ].createdTimeStamp + 1
    if ( window.odse.GenericUtilities.isNotNull transactioNodeObj , 'val' ) is false
      delete transactioNodeObj.val
    @transactionList.push transactioNodeObj

  addNewArrayNodeTransaction : ( userId , blobId , nodeId ) ->
    transactioNodeObj = new window.odse.TransactioNode userId , blobId , nodeId , window.odse.OdseConfigs.newArrayStringConstant , null , null
    @processAndAddTransactionToList transactioNodeObj

  addNewObjectNodeTransaction : ( userId , blobId , nodeId ) ->
    transactioNodeObj = new window.odse.TransactioNode userId , blobId , nodeId , window.odse.OdseConfigs.newObjectStringConstant , null , null
    @processAndAddTransactionToList transactioNodeObj

  addNewPrimitiveNodeTransaction : ( userId , blobId , nodeId , val ) ->
    transactioNodeObj = new window.odse.TransactioNode userId , blobId , nodeId , window.odse.OdseConfigs.newPrimitiveStringConstant , val , null
    @processAndAddTransactionToList transactioNodeObj

  arrayNodePushTransaction : ( userId , blobId , nodeId ) ->
    transactioNodeObj = new window.odse.TransactioNode userId , blobId , nodeId , window.odse.OdseConfigs.arrayPushStringConstant , null , null
    @processAndAddTransactionToList transactioNodeObj

  objectAddTransaction : ( userId , blobId , nodeId , propertyName ) ->
    transactioNodeObj = new window.odse.TransactioNode userId , blobId , nodeId , window.odse.OdseConfigs.objectAddStringConstant , null , propertyName
    @processAndAddTransactionToList transactioNodeObj

  arrayRemoveTransaction : ( userId , blobId , nodeId ) ->
    transactioNodeObj = new window.odse.TransactioNode userId , blobId , nodeId , window.odse.OdseConfigs.arrayRemoveStringConstant , null , null
    @processAndAddTransactionToList transactioNodeObj

  objectRemoveTransaction : ( userId , blobId , nodeId ) ->
    transactioNodeObj = new window.odse.TransactioNode userId , blobId , nodeId , window.odse.OdseConfigs.objectRemoveStringConstant , null , null
    @processAndAddTransactionToList transactioNodeObj

  primitiveRemoveTransaction : ( userId , blobId , nodeId ) ->
    transactioNodeObj = new window.odse.TransactioNode userId , blobId , nodeId , window.odse.OdseConfigs.primitiveRemoveStringConstant , null , null
    @processAndAddTransactionToList transactioNodeObj

  primitiveUpdateTransaction : ( userId , blobId , nodeId ) ->
    transactioNodeObj = new window.odse.TransactioNode userId , blobId , nodeId , window.odse.OdseConfigs.primitiveRemoveStringConstant , null , null
    @processAndAddTransactionToList transactioNodeObj

window.odse.TransactioNodeManager =TransactioNodeManager
class ClientXhrClient

  xhrObj = null
  localCbfnRefernence = null

  constructor : () ->
    _init()

  _init = () ->
    xhrObj = new XMLHttpRequest()

  _onReadyStateChange = () ->
    if xhrObj.readyState is 0
      result = '{"hasError":true,"error":"Failed to connect to the internet."}'
      localCbfnRefernence ( JSON.parse result )
    if xhrObj.readyState is 4 and xhrObj.status is 200
      result = xhrObj.responseText
      localCbfnRefernence ( JSON.parse result )

  _onRequestError = () ->
    result = '{"hasError":true,"error":"An error occurred while transferring the data to server."}'
    localCbfnRefernence ( JSON.parse result )

  postRequest : ( url , data , cbfn ) =>
    localCbfnRefernence = cbfn
    xhrObj.open "POST" , url , true
    xhrObj.setRequestHeader 'Content-type' , 'application/json'
    xhrObj.onreadystatechange = _onReadyStateChange
    xhrObj.addEventListener 'error' , _onRequestError
    xhrObj.send data

window.odse.ClientXhrClient =ClientXhrClient

class ServerOdseApiCall

  @genericServerApiCall : ( partialUrl , data , cbfn ) ->
    if ( typeof data ) is 'object'
      data = JSON.stringify data
    options = {}
    options.host = window.odse.OdseConfigs.hostName
    options.port = window.odse.OdseConfigs.hostPort
    options.path = '/' + window.odse.OdseConfigs.serverApiPathSignature + partialUrl
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
    cxcObj = new window.odse.ClientXhrClient()
    url = window.odse.OdseConfigs.webProtocol + window.odse.OdseConfigs.hostName + ':' + window.odse.OdseConfigs.hostPort + '/' + window.odse.OdseConfigs.serverApiPathSignature + partialUrl
    cxcObj.postRequest url , data , cbfn

  @getWebRequestObject : () ->
    if window.odse.GenericUtilities.isRunningOnServer() is true
      return window.odse.ServerOdseApiCall.genericServerApiCall
    else
      return window.odse.ServerOdseApiCall.genericClientApiCall

  @clearAllOdseDataApi : ( cbfn ) ->
    webRequestMethod = window.odse.ServerOdseApiCall.getWebRequestObject()
    webRequestMethod 'clear-all-odse-data' , {} , ( response ) =>
      if ( window.odse.GenericUtilities.isNotNull cbfn ) is true
        cbfn response.data

  @callSaveNewTransactionHistoryApi : ( transactionList , cbfn ) ->
    webRequestMethod = window.odse.ServerOdseApiCall.getWebRequestObject()
    webRequestMethod 'save-new-transaction-history' , transactionList , ( response ) =>
      if ( window.odse.GenericUtilities.isNotNull cbfn ) is true
        cbfn response.data

  @callGetTransactionHistoryApi : ( blobId , cbfn ) ->
    webRequestMethod = window.odse.ServerOdseApiCall.getWebRequestObject()
    webRequestMethod 'get-transaction-history' , { blobId : blobId } , ( response ) =>
      if ( window.odse.GenericUtilities.isNotNull cbfn ) is true
        response.data = window.odse.TransactioNodeListManager.sort response.data
        cbfn blobId , response.data

  @callSaveNewNodeIdPathListApi : ( nodeIdPathList , cbfn ) ->
    webRequestMethod = window.odse.ServerOdseApiCall.getWebRequestObject()
    webRequestMethod 'save-new-node-id-path-list' , nodeIdPathList , ( response ) =>
      if ( window.odse.GenericUtilities.isNotNull cbfn ) is true
        cbfn response.data

  @callGetNodeIdPathListApi : ( blobId , cbfn ) ->
    webRequestMethod = window.odse.ServerOdseApiCall.getWebRequestObject()
    webRequestMethod 'get-node-id-path-list' , { blobId : blobId } , ( response ) =>
      if ( window.odse.GenericUtilities.isNotNull cbfn ) is true
        cbfn blobId , response.data

window.odse.ServerOdseApiCall =ServerOdseApiCall

class StorageDecider

  @clearServerStorage : ( cbfn ) ->
    window.odse.ServerOdseApiCall.clearAllOdseDataApi cbfn

  @clearClientStorage : ( cbfn ) ->
    #to-do

  @saveNewTransactionHistory : ( transactionList , cbfn ) ->
    if window.odse.GenericUtilities.isRunningOnServer() is true
      window.odse.ServerOdseApiCall.callSaveNewTransactionHistoryApi transactionList , cbfn

  @saveNewNodeIdPathList : ( nodeIdPathList , cbfn ) ->
    if window.odse.GenericUtilities.isRunningOnServer() is true
      window.odse.ServerOdseApiCall.callSaveNewNodeIdPathListApi nodeIdPathList , cbfn

  @saveBothTransactionHistoryAndNewNodeIdPathList : ( transactionList , nodeIdPathList , cbfn ) ->
    if window.odse.GenericUtilities.isRunningOnServer() is true
      window.odse.ServerOdseApiCall.callSaveNewTransactionHistoryApi transactionList , ( saveNewTransactionHistoryResponse ) =>
        window.odse.ServerOdseApiCall.callSaveNewNodeIdPathListApi nodeIdPathList , ( saveNewNodeIdPathListResponse ) =>
          cbfn saveNewTransactionHistoryResponse , saveNewNodeIdPathListResponse

  @getNodeIdPathList : ( blobId , cbfn ) ->
    if window.odse.GenericUtilities.isRunningOnServer() is true
      window.odse.ServerOdseApiCall.callGetNodeIdPathListApi blobId , cbfn

  @getTransactionHistory : ( blobId , cbfn ) ->
    if window.odse.GenericUtilities.isRunningOnServer() is true
      window.odse.ServerOdseApiCall.callGetTransactionHistoryApi blobId , cbfn

window.odse.StorageDecider =StorageDecider

class ConstructOdseTree

  nodeIdPathObj = null
  transactionList = null
  data = null
  tree = null
  transactioNodeManagerObj = null

  constructor : ( blobId , cbfn ) ->
    if ( window.odse.GenericUtilities.isNotNull blobId ) is false
      throw new Error 'Blob ID is required for ODSE node tree generation.'
    nodeIdPathObj = {}
    transactionList = []
    window.odse.StorageDecider.getNodeIdPathList blobId , ( blobIdParam , nodeIdPathList ) =>
      for item in nodeIdPathList
        for key , value of item
          nodeIdPathObj[ key ] = value
      window.odse.StorageDecider.getTransactionHistory blobId , ( blobIdParam , transactionListParam ) =>
        transactionList = transactionListParam
        _buildTree cbfn

  _buildTree = ( cbfn ) =>
    referenceArray = []
    data = {}
    tree = {}
    idx = -1
    #console.log transactionList
    for item in transactionList
      if item.type is window.odse.OdseConfigs.newArrayStringConstant
        referenceArray.push []
        idx++
      else if item.type is window.odse.OdseConfigs.newObjectStringConstant
        referenceArray.push {}
        idx++
      else if item.type is window.odse.OdseConfigs.newPrimitiveStringConstant
        referenceArray.push item.val
        idx++
      else if item.type is window.odse.OdseConfigs.objectAddStringConstant
        referenceArray[ idx - 1 ][ item.propertyName ] = referenceArray[ idx ]
        referenceArray.pop()
        idx--
      else if item.type is window.odse.OdseConfigs.arrayPushStringConstant
        referenceArray[ idx - 1 ].push referenceArray[ idx ]
        referenceArray.pop()
        idx--
    data = referenceArray[ 0 ]
    cbfn true

  extractValue : () =>
    return data

  getTree : () =>
    return tree

window.odse.ConstructOdseTree =ConstructOdseTree

class ClientStorageHandler

  storageObj = null

  constructor : () ->
    try
      storageObj = localStorage
    catch ex
      storageObj = null

  initializeStorage : ( key ) ->
    a = 1
    #if window.odse.GenericUtilities.isNotNull

  set : ( key , value ) =>
    if ( window.odse.GenericUtilities.isNotNull ( @get key ) ) is false
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

window.odse.ClientStorageHandler =ClientStorageHandler

class ClientPendingSyncHandler

  isClient = null
  lsObj = null

  constructor : () ->
    isClient = ( ! window.odse.GenericUtilities.isRunningOnServer() )
    lsObj = new window.odse.ClientStorageHandler()

window.odse.ClientPendingSyncHandler =new ClientPendingSyncHandler()

class InitialDataDissection

  blobId = null
  userId = null
  allNodeIdPathList = null
  transactioNodeManagerObj = null

  run : ( jsonString , userIdParam , cbfn ) =>
    transactioNodeManagerObj = new window.odse.TransactioNodeManager()
    blobId = window.odse.GenericUtilities.generateDataBlobId()
    userId = userIdParam
    allNodeIdPathList = []
    _recursiveDataBuild [] , ( JSON.parse jsonString )

    window.odse.StorageDecider.saveBothTransactionHistoryAndNewNodeIdPathList transactioNodeManagerObj.transactionList , { blobId : blobId , allNodeIdPathList : allNodeIdPathList } , cbfn

    return blobId

  _addNodePathViaNodeIdList = ( nodePath ) ->
    childNodeId = nodePath[ nodePath.length - 1 ]
    newPath = {}
    newPath[ childNodeId ] = nodePath
    allNodeIdPathList.push newPath

  _recursiveDataBuild = ( nodeIdPathList , data ) ->
    newNodeIdPathList = []
    for id in nodeIdPathList
      newNodeIdPathList.push id
    currentNodeObj = null
    if data is null or ( typeof data ).toLowerCase() is 'undefined'
      currentNodeObj = new window.odse.PrimitiveNode()
      newNodeIdPathList.push currentNodeObj.nodeId
      _addNodePathViaNodeIdList newNodeIdPathList
      transactioNodeManagerObj.addNewPrimitiveNodeTransaction userId , blobId , currentNodeObj.nodeId , null
    else if ( typeof data ).toLowerCase() is 'object' and ( Array.isArray data )
      currentNodeObj = new window.odse.ArrayNode()
      newNodeIdPathList.push currentNodeObj.nodeId
      transactioNodeManagerObj.addNewArrayNodeTransaction userId , blobId , currentNodeObj.nodeId
      for item in data
        currentNodeObj.pushNode ( _recursiveDataBuild newNodeIdPathList , item )
        transactioNodeManagerObj.arrayNodePushTransaction userId , blobId , currentNodeObj.nodeId
      _addNodePathViaNodeIdList newNodeIdPathList
    else if ( typeof data ).toLowerCase() is 'object'
      currentNodeObj = new window.odse.ObjectNode()
      newNodeIdPathList.push currentNodeObj.nodeId
      transactioNodeManagerObj.addNewObjectNodeTransaction userId , blobId , currentNodeObj.nodeId
      for key , value of data
        currentNodeObj.addNode key , ( _recursiveDataBuild newNodeIdPathList , value )
        transactioNodeManagerObj.objectAddTransaction userId , blobId , currentNodeObj.nodeId , key
      _addNodePathViaNodeIdList newNodeIdPathList
    else if ( typeof data ).toLowerCase() is 'number' or ( typeof data ).toLowerCase() is 'string' or ( typeof data ).toLowerCase() is 'symbol' or ( typeof data ).toLowerCase() is 'boolean'
      if Object.prototype.toString.call( data ) is '[object Date]'
        data = data.getTime()
      currentNodeObj = new window.odse.PrimitiveNode data
      newNodeIdPathList.push currentNodeObj.nodeId
      _addNodePathViaNodeIdList newNodeIdPathList
      transactioNodeManagerObj.addNewPrimitiveNodeTransaction userId , blobId , currentNodeObj.nodeId , data
    return currentNodeObj

window.odse.InitialDataDissectionObj =( new InitialDataDissection() )

class TreeMerger

  constructor : () ->
    jsonString = '[{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"button-up","classList":{"0":"button-up"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"body","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"header","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"lang-chooser","classList":{"0":"lang-chooser"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox menu-box","classList":{"0":"roundbox","1":"menu-box"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-lt","classList":{"0":"roundbox-lt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-rt","classList":{"0":"roundbox-rt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-lb","classList":{"0":"roundbox-lb"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-rb","classList":{"0":"roundbox-rb"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"menu-list-container","classList":{"0":"menu-list-container"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"sidebar","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox sidebox","classList":{"0":"roundbox","1":"sidebox"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-lt","classList":{"0":"roundbox-lt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-rt","classList":{"0":"roundbox-rt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"caption titled","classList":{"0":"caption","1":"titled"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"top-links","classList":{"0":"top-links"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"socials","classList":{"0":"socials"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"fb-root","className":" fb_reset","classList":{"0":"fb_reset"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"fb-like fb_iframe_widget","classList":{"0":"fb-like","1":"fb_iframe_widget"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox sidebox","classList":{"0":"roundbox","1":"sidebox"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-lt","classList":{"0":"roundbox-lt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-rt","classList":{"0":"roundbox-rt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"caption titled","classList":{"0":"caption","1":"titled"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"top-links","classList":{"0":"top-links"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"personal-sidebar","classList":{"0":"personal-sidebar"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"for-avatar","classList":{"0":"for-avatar"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"avatar","classList":{"0":"avatar"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox sidebox top-contributed","classList":{"0":"roundbox","1":"sidebox","2":"top-contributed"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-lt","classList":{"0":"roundbox-lt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-rt","classList":{"0":"roundbox-rt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"caption titled","classList":{"0":"caption","1":"titled"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"top-links","classList":{"0":"top-links"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"bottom-links","classList":{"0":"bottom-links"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox sidebox top-contributed","classList":{"0":"roundbox","1":"sidebox","2":"top-contributed"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-lt","classList":{"0":"roundbox-lt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-rt","classList":{"0":"roundbox-rt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"caption titled","classList":{"0":"caption","1":"titled"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"top-links","classList":{"0":"top-links"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"bottom-links","classList":{"0":"bottom-links"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox sidebox","classList":{"0":"roundbox","1":"sidebox"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-lt","classList":{"0":"roundbox-lt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-rt","classList":{"0":"roundbox-rt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"caption titled","classList":{"0":"caption","1":"titled"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"top-links","classList":{"0":"top-links"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox sidebox","classList":{"0":"roundbox","1":"sidebox"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-lt","classList":{"0":"roundbox-lt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-rt","classList":{"0":"roundbox-rt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"caption titled","classList":{"0":"caption","1":"titled"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"top-links","classList":{"0":"top-links"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"recent-actions","classList":{"0":"recent-actions"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"bottom-links","classList":{"0":"bottom-links"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"pageContent","className":"content-with-sidebar","classList":{"0":"content-with-sidebar"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"second-level-menu","classList":{"0":"second-level-menu"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"leftLava","classList":{"0":"leftLava"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"bottomLava","classList":{"0":"bottomLava"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"cornerLava","classList":{"0":"cornerLava"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"datatable ratingsDatatable","classList":{"0":"datatable","1":"ratingsDatatable"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"lt","classList":{"0":"lt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"rt","classList":{"0":"rt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"lb","classList":{"0":"lb"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"rb","classList":{"0":"rb"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"ilt","classList":{"0":"ilt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"irt","classList":{"0":"irt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"pagination","classList":{"0":"pagination"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"footer","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"userListsFacebox","classList":{"0":"userListsFacebox"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"datatable","classList":{"0":"datatable"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"lt","classList":{"0":"lt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"rt","classList":{"0":"rt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"lb","classList":{"0":"lb"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"rb","classList":{"0":"rb"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"ilt","classList":{"0":"ilt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"irt","classList":{"0":"irt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"datepick-div","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxOverlay","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"colorbox","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxWrapper","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxTopLeft","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxTopCenter","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxTopRight","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxMiddleLeft","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxContent","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxLoadedContent","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxLoadingOverlay","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxLoadingGraphic","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxTitle","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxCurrent","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxNext","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxPrevious","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxSlideshow","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxClose","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxMiddleRight","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxBottomLeft","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxBottomCenter","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxBottomRight","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1}]'
    jsonString = '[{"val":1,"name":"test"},{"val":2,"name":"ron"}]'
    jsonString = '{"val":1}'
    window.odse.ServerOdseApiCall.clearAllOdseDataApi ( response1 ) =>
      console.log response1

new TreeMerger()

## NOTE
