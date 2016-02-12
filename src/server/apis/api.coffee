pathObj = require 'path'
fsObj = require 'fs'

class Api

  db : null
  schemas : null
  responseObj : null

  init : ( dbObj ) =>
    @setupDb dbObj
    @getSchemas()

  setupDb : ( dbObj ) =>
    @db = dbObj

  getSchemas : () =>
    @schemas = {}
    schemasFolder = pathObj.join __dirname , './../schemas'
    directoryFileList = fsObj.readdirSync schemasFolder
    for item in directoryFileList
      filePath = schemasFolder + '/' + item
      data = require filePath
      for key , value of data
        @schemas[ key ] = value

  success : ( e , data ) =>
    @responseObj.end ( JSON.stringify { hasError : false , data : data } )

  respondToLogicalFailure : ( e , errorDetails , message ) =>
    console.log 'logical-error'
    res = {}
    #res.e = e
    res.errorDetails = errorDetails
    res.message = message
    res = JSON.stringify res
    @responseObj.end ( JSON.stringify { hasError : true , error : res } )

  respondToDatabaseError : ( e , errorObj ) =>
    console.log 'database-error'
    res = {}
    #res.e = e
    res.errorObj = errorObj
    res = JSON.stringify res
    @responseObj.end ( JSON.stringify { hasError : true , error : res } )

@Api = Api
