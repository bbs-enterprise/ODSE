
###
  NOTE: Basic Utils. Add as needed.
###

__inspect = (val)->
  console.log (require 'util').inspect val, depth: 30, colors: true

@__inspect = __inspect

class CustomError extends Error
  constructor: (@message, @cause)->
    Error.captureStackTrace(@,@)

@CustomError = CustomError

class DeveloperError extends CustomError
  constructor: (message, cause = null)->
    super message, cause

@DeveloperError = DeveloperError

class VendorError extends CustomError
  constructor: (message, cause = null)->
    super message, cause

@VendorError = VendorError

class ExtendedError extends Error
  constructor: (code, details, where)->
    throw new VendorError 'UNEXPECTED CASE, SCENARIO 1' unless (code and details and where)
    @code = code
    @details = details
    @where = where
    detailsFormatted = JSON.stringify @details, null, 2
    @message = "\ncode   : #{@code}\nat     : #{@where}\ndetails: #{detailsFormatted}"
    Error.captureStackTrace(@,@)

@ExtendedError = ExtendedError
