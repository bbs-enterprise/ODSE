
{
  Event
  EventEmitter
} = require './en-events'

{
  __inspect
  CustomError
  DeveloperError
  VendorError
  ExtendedError
} = require './util'

{
  iterate
} = require './en-util'

###
  @note Events
  Events are 'materialistic' in evolvenode. That means they are actually objects that pushed thrown across
  one or more node's event handlers.
  This is different from how nodejs handles events. Nodejs events are merely conceptual with only one string
  representing 'which' event it is.
  evolvenode's events are objects that have many useful built in properties and are written classically, so
  the intended way to use them is by extending them.
  The most important this to note here is that whatever data passed by an 'emit' function of an EventEmitter
  can be found in the 'storedData' property of the event.
  Other important properties -
    * name
    * storedData
    * target (current node)
    * origin (first node)
    * path (list of nodes it has travered)
  Important method -
    * delegate() (changes the target for the event)
    * next() (go to the next event handler)
###

###
  @class OdseEvent
  The base Event for our system. It is both Sequencial and Async. I've mirrored the 'storedData' in the 'detail'
   property to make more sense in current context and to make events similar to W3C DOM Events.
###
class OdseEvent extends Event

  @isSequencial: true
  @isAsync: true
  constructor: ->
    super
    @detail = @storedData

###
  @class BubbleableOdseEvent
  This Event has bubbling support.
  TODO: Multiple Parent Traversal Support
  IMPROVE: 'Bubbleable' means a woman who is easy to get. Should we change this?
###
class BubbleableOdseEvent extends OdseEvent

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
      throw new VendorError "Still unable to handle multiple parents"
    parent = @target.parentList[0]
    @delegate { target:parent }, @_nodeCompletionHandler
    return @

  _nodeCompletionHandler: (e)=>
    @bubbleUp()





###
  @note Nodes
  Nodes are like the building blocks of the system. Since they need to emit events, they need to have EventEmitter in their
  prototype chain. That's why OdseNode extends EventEmitter.
  the following methods of EventEmitter is fundamentally important -
    * addEventHandler - adds a function as an event handler. the function's execution context will be set to the current node
      during execution. the handler must invoke the e.next() function in order to propagate to the next handler.
    * on - just a convenient alias for addEventHandler
    * register - registers an event. an event needs to be registered in order to be emitted
    * emit - emit an event. first parameter is the name of the event. second parameter is extra data
  NOTE: we are doing setImmediate before emit() to guarantee that the event will be triggered AFTER the action has finished happening
###

###
  @class @abstract OdseNode
  The base class for any of our nodes
  It adds a serial number for debugging purposes.
  NOTE: emits 'create', 'attach', 'detach', 'remove'
###
class OdseNode extends EventEmitter

  @seed: 0

  constructor: ->
    super
    @register BubbleableOdseEvent, 'create'
    @register BubbleableOdseEvent, 'attach'
    @register BubbleableOdseEvent, 'detach'
    @register BubbleableOdseEvent, 'remove'
    @serial = OdseNode.seed++
    @parentList = []
    setImmediate => @emit 'create', { node: @ }

  _attachTo: (parentNode)->
    throw new Error "Expected <ContainerNode>" unless parentNode instanceof ContainerNode
    @parentList.push parentNode
    setImmediate => @emit 'attach', { node: @, to: parentNode }

  _detachFrom: (parentNode)->
    throw new Error "Expected <ContainerNode>" unless parentNode instanceof ContainerNode
    throw new Error "Node is not attached." unless (index = @parentList.indexOf parentNode) > -1
    @parentList.splice index, 1
    setImmediate => @emit 'detach', { node: @, from: parentNode }

  remove: ->
    for parentNode in @parentList
      parentNode.forceRemoveChild @
    setImmediate => @emit 'remove', { node: @ }

###
  @class @abstract ValueNode
  Any Node that accepts a value inherits this one.
  NOTE: - null/undefined is a value too!
  Difference between __setValue and setValue -
    __setValue is desinged to be called internally without raising fuss about change of value
    setValue is meant to be public by nature.
###
class ValueNode extends OdseNode

  constructor: ->
    super
    @register BubbleableOdseEvent, 'set'
    @__value = null

  __setValue: (newValue)->
    @__value = newValue
    # NOTE: This method is meant to be overriden by any child

  setValue: (newValue)->
    oldValue = @__value
    @__setValue newValue
    setImmediate => @emit 'set', { node: @, oldValue, newValue }

###
  @class PrimitiveNode
  This node can contain any primitive value. Including -
  number, string, boolean, null, undefined, function.
  NOTE: I willingly didn't put any check against array or objects since there can be valid use cases for those.
  For example storing a Date object. etc
###
class PrimitiveNode extends ValueNode

  constructor: (value = null)->
    super
    @__setValue value

  getValue: ->
    return @__value

###
  @class @abstract
  This is the master class for container nodes. All container nodes emit an 'update' event which is registered
  here. All update events Should have a property called 'operation' denoting the type of the update.
###
class ContainerNode extends ValueNode
  constructor: ->
    super
    @register BubbleableOdseEvent, 'update'

###
  @class ObjectNode
  Can contain an object. Notifies on operation -
    * child-add
    * child-remove
    * child-replace
  NOTE: does not emit update with child-add and child-remove when performing 'child-replace'
###
class ObjectNode extends ContainerNode

  constructor: (map = null)->
    super
    @childrenMap = {}
    @__setValue map

  __setValue: (newValue)->
    super
    unless newValue is null or (typeof newValue is 'object' and not Array.isArray newValue)
      throw new ExtendedError "E_EXP_OBJECT", "Expected <object>", newValue
    @__resetMap()
    return unless newValue
    for key, value of newValue
      @childrenMap[key] = ObjectDataStorageEngine.parse value
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
    return iterate Object.keys(@childrenMap), (next, index, key)=>
      # NOTE: fn will receive callback as (next, key, node)
      fn next, key, @getNode key

  getKeyList: ->
    return Object.keys(@childrenMap)

  getNode: (key)->
    throw new Error "Unknown Key" unless key of @childrenMap
    return @childrenMap[key]

  hasNode: (key)->
    return (key of @childrenMap)


###
  @class ArrayNode
  Can contain an array. Notifies on operation -
    * child-push
    * child-remove
    * child-pop
###
class ArrayNode extends ContainerNode

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
      @childrenList.push ObjectDataStorageEngine.parse value
      @childrenList[ @childrenList.length-1 ]._attachTo @

  __resetList: ->
    for node, index in @childrenList
      node._detachFrom @
    @childrenList = {}

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
    return iterate @childrenList, fn

  getLength: ->
    return @childrenList.length

  getNode: (index)->
    throw new Error "index out of bound" unless 0 <= index < @childrenList.length
    return @childrenList[index]

  indexOf: (node)->
    return @childrenList.indexOf node

  lastIndexOf: (node)->
    return @childrenList.lastIndexOf node

###
  @class ObjectDataStorageEngine
  Object Data Storage Engine
###
class ObjectDataStorageEngine

  @parse: (json, doForEachFn = null)->
    type = typeof json
    if type is 'object' and json isnt null
      if Array.isArray json
        node = new ArrayNode json
      else
        node = new ObjectNode json
    else
      node = new PrimitiveNode json
    doForEachFn node if doForEachFn
    return node

###
  @exports
###
@OdseEvent = OdseEvent
@BubbleableOdseEvent = BubbleableOdseEvent

@ObjectDataStorageEngine = ObjectDataStorageEngine
@ArrayNode = ArrayNode
@ObjectNode = ObjectNode
@ContainerNode = ContainerNode
@PrimitiveNode = PrimitiveNode
@ValueNode = ValueNode
@OdseNode = OdseNode

@CustomError = CustomError
@VendorError = VendorError
@DeveloperError = DeveloperError
@ExtendedError = ExtendedError
