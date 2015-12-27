

###
  NOTE: The following is extracted from the official 'evolvenode' module. Try not to modify anything here
  since on later releases, these classes will be loaded from evolvenode module directly.
  Everything is classically written, so you can just subclass and hook if you need to.
###

###
  @class EventEmitter
###

class EventEmitter

  constructor: ()->
    @_EventClassMap = {}
    @register ErrorEvent, 'error'

  __getProperEventName: (eventArg)->
    if typeof eventArg is 'object' and eventArg.prototype instanceof Event
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

###
  @class Event
###

class Event extends EventEmitter

  @isSequencial: true
  @isAsync: true

  @fallbackHandler: null

  name: 'Event'

  constructor: ({@origin, @target, data, handlerList, name} = {})->

    super

    unless ((@origin is null) or (typeof @origin is 'object' and @origin instanceof EventEmitter))
      throw new Error 'Type Mismatch. Expected origin to be <null> or <EventEmitter>'

    unless ((@target is null) or (typeof @target is 'object' and @target instanceof EventEmitter))
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


###
  @class ErrorEvent
###
class ErrorEvent extends Event

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



@Event = Event
@EventEmitter = EventEmitter
@ErrorEvent = ErrorEvent
