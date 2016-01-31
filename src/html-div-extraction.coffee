class HtmlDivExtractions

  resultantNodeList = null
  tagName = 'div'
  nodePropertyFilterList = [ 'tabIndex' , 'id' , 'className' , 'tagName' , 'localName' , 'classList' , 'nodeType' ]

  constructor : () ->
    resultantNodeList = []
    _run()

  _run = () ->
    nodeList = window.document.getElementsByTagName tagName
    for node in nodeList
      newNode = {}
      for key , value of node
        if key in nodePropertyFilterList
          newNode[ key ] = value
      resultantNodeList.push newNode
     console.log ( JSON.stringify resultantNodeList )

new HtmlDivExtractions()
