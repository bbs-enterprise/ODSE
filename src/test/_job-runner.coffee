
class JobRunner

  constructor: (@min, @doneCb)->
    @count = 0

  done: ->
    # console.log @coun
    @count += 1
    if @count is @min
      @doneCb()
    else if @count > @min
      throw new Error "Something went wrong"

@JobRunner = JobRunner
