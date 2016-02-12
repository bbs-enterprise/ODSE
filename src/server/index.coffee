http = require 'http'
pathObj = require 'path'
fsObj = require 'fs'
{ DbManager } = require './db/db-manager.coffee'
{ ConstantHelper } = require './utility/constant-helper.coffee'
{ ClientOdseScriptGenerator } = require './client-odse-script-generator.coffee'

class ServerRoot

  port = 8671
  serverObj = null
  apiPathPrefix = '/api/1/'
  apiObjectList = null
  apiFolderPartialPath = './apis'
  rootApiClassFileName = 'api.coffee'
  htmlFilePatternString = '.html'
  htmlFileRelativeFolder = './client/html/'
  jsFilePatternString = '.js'
  jsFileRelativeFolder = './client/js/'

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

  lookForParticularFile : ( fileName , folderPath ) ->
    res = null
    folderPath = pathObj.join __dirname , folderPath
    fileList = fsObj.readdirSync folderPath
    flag = false
    for item in fileList
      if item.toLowerCase() is fileName.toLowerCase()
        flag = true
        break
    if flag is true
      res = fsObj.readFileSync( folderPath + fileName ).toString()
    return res

  handleHtmlFiles : ( requestObj , responseObj , fileName ) ->
    fileData = @lookForParticularFile fileName , htmlFileRelativeFolder
    if fileData is null
      responseObj.end 'Invalid HTML file request: ' + fileName
    else
      responseObj.end fileData

  handleJsFiles : ( requestObj , responseObj, fileName  ) ->
    fileData = @lookForParticularFile fileName , jsFileRelativeFolder
    if fileData is null
      responseObj.end 'Invalid JS file request: ' + fileName
    else
      responseObj.end fileData

  requestEntry : ( requestObj , responseObj ) =>
    requestUrl = requestObj.url
    if ( requestUrl.search apiPathPrefix ) is 0
      @processApiRequests requestObj , responseObj
      return null
    requestPartsList = ( requestUrl.split '/' )
    fileName = requestPartsList[ requestPartsList.length - 1 ]
    if ( ConstantHelper.isNotNull fileName ) is false
      responseObj.end 'Invalid resource request: ' + requestUrl
      return null
    if fileName is ''
      fileName = 'index.html'
    if ( fileName.search htmlFilePatternString ) isnt -1
      @handleHtmlFiles requestObj , responseObj , fileName
      return null
    if ( fileName.search jsFilePatternString ) isnt -1
      @handleJsFiles requestObj , responseObj , fileName
      return null
    responseObj.end 'Dummy response to url: ' + requestUrl

  generateOdseClientScript : () ->
    new ClientOdseScriptGenerator()

  serverEntry : () =>
    @generateOdseClientScript()
    console.log ( "Server started on: http://localhost:" + port + '/' )

new ServerRoot()
