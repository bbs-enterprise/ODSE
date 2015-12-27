
{ expect } = require 'chai'

{ ObjectDataStorageEngine } = require './../odse'

describe 'Active Temporary Test Cases' , ->

  it.only 'Small Data Set', (doneCbfn)->

    demoUserData =
      name:
        honorifics: 'Mr'
        first: 'John'
        middle: 'Winston'
        last: 'Lennon'
      password: 'Working Class Hero Is Something To Be'
      repeatedPassword: 'Working Class Hero Is Something To Be'
      registrationDateTime: 1437721697343

    tree = ObjectDataStorageEngine.parse demoUserData
    console.log tree

    expect(tree).to.equal('TODO')




###
  @testing
###
# possibleEvents = ['create', 'attach', 'set', 'remove', 'detach', 'update']
# monitorAllEvents = (name, node)->
#   for ev in possibleEvents
#     do (ev)->
#       try
#         node.once ev, (e)->
#           # console.log (if e.origin is @ then e.origin.serial + '   ' else e.origin.serial + '->' + e.target.serial),'\t', name, e.name, (if e.detail.operation then e.detail.operation else '') #, # [e.detail]
#           # console.log e.pathList.length
#           str = ''
#           for target, index in e.path
#             str += (if index is 0 then '' else '->') + target.serial
#
#           console.log e.name, e.detail.node.serial, '\t', str
#
#           e.next()
#       catch error
#


# demoUserData =
#   name:
#     honorifics: 'Mr'
#     first: 'John'
#     middle: 'Winston'
#     last: 'Lennon'
#   password: 'Working Class Hero Is Something To Be'
#   repeatedPassword: 'Working Class Hero Is Something To Be'
#   registrationDateTime: 1437721697343
#
# useNode = ObjectDataStorageEngine.parse demoUserData, (node)->
#   monitorAllEvents '', node
#



#
# m1 = new ObjectNode
# monitorAllEvents 'm1', m1
#
# v1 = new ValueNode 'v1v1'
# monitorAllEvents 'v1', v1
# m1.addNode 'cn1', v1
#
# v2 = new ValueNode 'v2v1'
# monitorAllEvents 'v2', v2
# m1.addNode 'cn2', v2
#
#
# m1.forEach (key, node)->
#   console.log key, node.serial
#
# m1.forEachAsync (next, key, node)->
#   console.log key, node.serial
#   next()
# .then ->
#   console.log 'finished'
#
#
#



#
# v3 = new ValueNode 'v3v1'
# monitorAllEvents 'v3', v3
# m1.addNode 'cn1', v3
#
# v2.setValue 'v2v2'
#
# m2 = new ObjectNode
# monitorAllEvents 'm2', m2
# m1.addNode 'cn3', m2
#
# v4 = new ValueNode 'v4v1'
# monitorAllEvents 'v4', v4
# m2.addNode 'cn1', v4
#
# v4.setValue 'v4v2'
#
# m3 = new ObjectNode
# monitorAllEvents 'm3', m3
# m2.addNode 'cn2', m3
#
# v5 = new ValueNode 'v5v1'
# monitorAllEvents 'v5', v5
# m3.addNode 'cn1', v5
#
# v5.setValue 'v5v2'
# #
# # setTimeout =>
# #   console.log 'gonna remove'
# #   m3.remove()
# # , 300
#
# a1 = new ArrayNode
# monitorAllEvents 'a1', a1
# m3.addNode 'cnx', a1
#
# p1 = new PrimitiveNode 'v'
# monitorAllEvents 'p1', p1
# a1.pushNode p1
#
# p2 = new PrimitiveNode 'v'
# monitorAllEvents 'p2', p2
# a1.pushNode p2
#
# p3 = new PrimitiveNode 'v'
# monitorAllEvents 'p3', p3
# a1.pushNode p3
#
# a1.popNode()
# a1.popNode()
#
# p4 = new PrimitiveNode 'vv'
# monitorAllEvents 'p4', p4
# a1.pushNode p4
#


#
# master = new ObjectNode
# monitorAllEvents 'master', master
# master.addNode 'IN', ObjectDataStorageEngine.parse demoUserData
