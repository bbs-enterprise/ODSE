{ ConstantHelper } = require './constant-helper.coffee'

class TopologicalSort

  maxSize = 100
  nameMapObj = null
  reverseNodeNameObj = null
  adjList = null
  vis = null
  visitedNodeList = null
  orderedNodeList = null
  limit = null
  globalTime = null

  constructor : () ->
    _init()

  _init = () =>
    nameMapObj = {}
    reverseNodeNameObj = {}
    adjList = []
    vis = []
    visitedNodeList = []
    orderedNodeList = []
    limit = 0
    globalTime = 1
    _initVis()
    for i in [ 0 ... maxSize ]
      adjList.push []

  _initVis = () ->
    if vis.length is 0
      for i in [ 0 ... maxSize ]
        vis.push 0
    else
      for i in [ 0 ... maxSize ]
        vis[ i ] = 0

  createMapFromNames : ( nameList ) =>
    cn = 1
    for item in nameList
      nameMapObj[ '' + cn ] = item
      reverseNodeNameObj[ item ] = cn
      cn++

  addEdge : ( source , destination ) =>
    limit = Math.max limit , source
    limit = Math.max limit , destination
    adjList[ source ].push destination

  addEdgeFromNameDependencies : ( nameDependencyMap ) =>
    for key , value of nameDependencyMap
      destination = reverseNodeNameObj[ key ]
      for item in value
        source = reverseNodeNameObj[ item ]
        if ( ConstantHelper.isNotNull source ) and ( ConstantHelper.isNotNull destination )
          @addEdge source , destination
        else
          throw new Error 'No such require found in ' + key + ' file.'

  runTopoSort : () =>
    res = null
    for i in [ 1 ... limit ]
      if ( vis[ i ] is 0 )
        _runFirstDfs i
    visitedNodeList = visitedNodeList.sort ( left , right ) ->
      return right.time - left.time
    if ( JSON.stringify reverseNodeNameObj ) is '{}'
      res = []
      for item in visitedNodeList
        res.push item.node
    else
      res = []
      for item in visitedNodeList
        res.push nameMapObj[ '' + item.node ]
    return res

  _runFirstDfs = ( u ) ->
    vis[ u ] = 1
    sz = adjList[ u ].length
    for i in [ 0 ... sz ]
      v = adjList[ u ][ i ]
      if vis[ v ] is 0
        _runFirstDfs v
    node = {}
    node.node = u
    node.time = globalTime
    globalTime++
    visitedNodeList.push node

@TopologicalSort = TopologicalSort
