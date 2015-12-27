
###
  NOTE: The following is extracted from the official 'evolvenode' module. Try not to modify anything here
  since on later releases, these classes will be loaded from evolvenode module directly.
  Everything is classically written, so you can just subclass and hook if you need to.
###

###
  @class Iterator
  @purpose Asynchronous iterator for a list with flow control.
###

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

@Iterator = Iterator

###
  @iterate
###

iterate = (list, forEachFn) ->
  new Iterator list, forEachFn

@iterate = iterate
