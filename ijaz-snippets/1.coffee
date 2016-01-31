  ###
  objectNodeObj = new ObjectNode()

  primitiveNodeObj = new PrimitiveNode 'sample string'
  objectNodeObj.addNode 'a' , primitiveNodeObj
  primitiveNodeObj = new PrimitiveNode 0.11
  objectNodeObj.addNode 'b' , primitiveNodeObj
  primitiveNodeObj = new PrimitiveNode 123
  objectNodeObj.addNode 'c' , primitiveNodeObj

  arrayNodeObj = new ArrayNode()
  primitiveNodeObj = new PrimitiveNode 910
  arrayNodeObj.pushNode primitiveNodeObj
  primitiveNodeObj = new PrimitiveNode 912
  arrayNodeObj.pushNode primitiveNodeObj

  objectNodeObj.addNode 'd' , arrayNodeObj

  console.log objectNodeObj
  ###
