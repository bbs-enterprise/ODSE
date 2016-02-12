{ TopologicalSort } = require './utility/topological-sort.coffee'
{ exec } = require 'child_process'

pathObj = require 'path'
fsObj = require 'fs'

class ClientOdseScriptGenerator

  relativeOdseScriptFolderPath = './../'
  relativeClientCoffeeFilePath = './client/odse.coffee'
  relativeClientJsFolderPath = './client/'
  requireStringPattern = 'require '
  exportStringPattern = '@' # Has to be the first character
  clientBindingPrefix = 'window.app.odse.'
  coffeeFilePatternSuffix = '.coffee'
  omittedFileNameList = [ 'html-div-extraction.coffee' ]
  omittedRequireNames = [ 'http' , 'client-odse-script-generator.coffee' ]

  unorderedFileNameList = null
  declarationsThatNeedsToBeReplaced = null

  constructor : () ->
    _generate()

  _getFileNameList = ( relativeOdseScriptFolderPathParam ) ->
    res = []
    folderPath = pathObj.join __dirname , relativeOdseScriptFolderPathParam
    fileList = fsObj.readdirSync folderPath
    for item in fileList
      flag = false
      for fileName in omittedFileNameList
        if fileName is item
          flag = true
          break
      if flag is true
        continue
      if ( item.search coffeeFilePatternSuffix ) isnt -1
        res.push item
    return res

  _getFileContentList = ( relativeOdseScriptFolderPathParam ) ->
    res = []
    folderPath = pathObj.join __dirname , relativeOdseScriptFolderPathParam
    fileList = fsObj.readdirSync folderPath
    for item in fileList
      flag = false
      for fileName in omittedFileNameList
        if fileName is item
          flag = true
          break
      if flag is true
        continue
      if ( item.search coffeeFilePatternSuffix ) isnt -1
        fileData = fsObj.readFileSync( folderPath + item ).toString()
        res.push fileData
    return res

  _breakStringDataToLines = ( stringData ) ->
    res = []
    len = stringData.length
    subString = ''
    idx = 0
    while ( idx + 1 < len )
      if ( stringData.charCodeAt idx ) is 10
        res.push subString
        subString = ''
        idx += 1
      else
        subString += ( stringData.charAt idx )
        idx++
    res.push subString
    return res

  _getRequireFileNameList = ( dataList ) ->
    res = []
    for item in dataList
      idx = ( item.search requireStringPattern )
      if idx isnt -1 and ( item.search '=' ) isnt -1
        partialFilePath = item.substr ( idx + requireStringPattern.length + 1 ) , ( item.length - ( idx + requireStringPattern.length ) - 1 )
        while ( partialFilePath.search '\'' ) isnt -1
          partialFilePath = partialFilePath.replace '\'' , ''
        while ( partialFilePath.search '"' ) isnt -1
          partialFilePath = partialFilePath.replace '"' , ''
        while ( partialFilePath.search '\r' ) isnt -1
          partialFilePath = partialFilePath.replace '\r' , ''
        len = partialFilePath.length
        i = len - 1
        j = 0
        while i >= 0
          if ( partialFilePath.charCodeAt i ) is ( '/'.charCodeAt 0 )
            j = i + 1
            break
          i--
        fileName = ''
        for i in [ j ... len ]
          fileName += ( partialFilePath.charAt i )
        flag = false
        for secondItem in omittedRequireNames
          if fileName is secondItem
            flag = true
            break
        if flag is false
          if ( fileName.search coffeeFilePatternSuffix ) is -1
            fileName += coffeeFilePatternSuffix
          res.push fileName
    return res

  _removeRequireLines = ( dataList ) ->
    res = []
    for item in dataList
      if ( item.search requireStringPattern ) isnt -1
        continue
      res.push item
    return res

  _removeExportLines = ( dataList ) ->
    res = []
    for item in dataList
      if ( item.search exportStringPattern ) is 0
        len = item.length
        exportName = ''
        for i in [ 1 ... len ]
          if ( item.charCodeAt i ) is ( '='.charCodeAt 0 ) or ( item.charCodeAt i ) is ( ' '.charCodeAt 0 )
            break
          exportName += ( item.charAt i )
        declarationsThatNeedsToBeReplaced.push exportName
        item = item.replace exportStringPattern , clientBindingPrefix
      res.push item
    return res

  _replaceGlobalReferences = ( dataList , replaceKeywordList ) ->
    res = []
    for file in dataList
      res.push []
      for line in file
        for keyword in replaceKeywordList
          len1 = line.length
          len2 = keyword.length
          i = 0
          newLine = ''
          while i < len1
            len3 = Math.min len1 , ( i + len2 )
            subString = ''
            for j in [ i ... len3 ]
              subString += ( line.charAt j )
            if subString is keyword and ( i - 1 ) >= 0 and ( ( line.charCodeAt ( i - 1 ) ) isnt ( '.'.charCodeAt 0 ) )
              newLine += ( clientBindingPrefix + keyword )
              i += len2
            else
              newLine += ( line.charAt i )
              i++
          line = newLine
        res[ res.length - 1 ].push newLine
    return res

  _writeOnFile = ( fileContentList ) ->
    dataString = ''
    for file in fileContentList
      for line in file
        dataString += line + '\n'
      break
    filePath = pathObj.join __dirname , relativeClientCoffeeFilePath
    fsObj.writeFileSync filePath , dataString , 'utf8'

  _compileToJsCallback = () ->
    console.log 'Successfully generated client ODSE script.'

  _compileToJs = () ->
    sourceFilePath = pathObj.join __dirname , relativeClientCoffeeFilePath
    destinationFolderPath = pathObj.join __dirname , relativeClientJsFolderPath
    console.log sourceFilePath , destinationFolderPath
    cmd = 'coffee --compile ' + sourceFilePath
    #exec cmd , _compileToJsCallback

  _generate = () ->
    topoSortObj = new TopologicalSort()
    declarationsThatNeedsToBeReplaced = []
    unorderedFileNameList = []
    fileContentList = _getFileContentList relativeOdseScriptFolderPath
    unorderedFileNameList = _getFileNameList relativeOdseScriptFolderPath
    nameDependencyMap = {}
    idx = 0
    fileDataInMap = {}
    for item in fileContentList
      fileDataLineList = _breakStringDataToLines item
      requiredFileList = _getRequireFileNameList fileDataLineList
      nameDependencyMap[ unorderedFileNameList[ idx ] ] = requiredFileList
      fileDataLineList = _removeRequireLines fileDataLineList
      fileDataLineList = _removeExportLines fileDataLineList
      fileDataInMap[ unorderedFileNameList[ idx ] ] = fileDataLineList
      idx++
    topoSortObj.createMapFromNames unorderedFileNameList
    topoSortObj.addEdgeFromNameDependencies nameDependencyMap
    orderedRequireList = topoSortObj.runTopoSort()
    orderedFileContentList = []
    for item in orderedRequireList
      orderedFileContentList.push fileDataInMap[ item ]
    orderedFileContentList = _replaceGlobalReferences orderedFileContentList , declarationsThatNeedsToBeReplaced
    _writeOnFile orderedFileContentList
    _compileToJs()
    #console.log declarationsThatNeedsToBeReplaced

@ClientOdseScriptGenerator = ClientOdseScriptGenerator