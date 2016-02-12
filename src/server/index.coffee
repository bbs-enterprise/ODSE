http = require 'http'
pathObj = require 'path'
fsObj = require 'fs'
{ DbManager } = require './db/db-manager.coffee'

class ServerRoot

  port = 8671
  serverObj = null
  apiPathPrefix = '/api/1/'
  apiObjectList = null
  apiFolderPartialPath = './apis'
  rootApiClassFileName = 'api.coffee'

  constructor : () ->
    server = http.createServer @requestEntry
    server.listen port , @serverEntry
    @getPossibleApiObjects()

  getPossibleApiObjects : () =>
    apiObjectList = []
    apiFolderPath = pathObj.join __dirname , apiFolderPartialPath
    directoryFileList = fsObj.readdirSync apiFolderPath
    for item in directoryFileList
      if item is rootApiClassFileName
        continue
      filePath = apiFolderPath + '/' + item
      data = require filePath
      for key , value of data
        apiObjectList.push ( new value() )

  processApiRequests : ( requestObj , responseObj ) =>
    if requestObj.method isnt 'POST'
      responseObj.end 'Invalid api request method.'
      return null
    requestBody = ''
    requestObj.on 'data' , ( chunk ) =>
      requestBody += chunk
    requestObj.on 'end' , () =>
      requestBody = JSON.parse requestBody
      partialUrl = requestObj.url
      apiName = requestObj.url.replace apiPathPrefix , ''
      flag = false
      for item in apiObjectList
        item.init( DbManager.db )
        if item.path is apiName
          item.responseObj = responseObj
          item.handle { body : requestBody }
          flag = true
          break
      if flag is false
        responseObj.end 'Invalid api path.'
        return null

  requestEntry : ( requestObj , responseObj ) =>
    if ( requestObj.url.search apiPathPrefix ) is 0
      @processApiRequests requestObj , responseObj
      return null
    responseObj.end 'Dummy response to url: ' + requestObj.url

  serverEntry : () =>
    console.log ( "Server started on: http://localhost:" + port + '/' )

new ServerRoot()
