
{ expect } = require 'chai'

{ ObjectDataStorageEngine, ObjectNode, BubbleableOdseEvent, PrimitiveNode } = require './../odse'

{ JobRunner } = require './_job-runner'

describe 'ObjectNode' , ->

  it 'new', (done)->
    job = new JobRunner 1, done

    try
      node = new ObjectNode 'Example Value'
    catch ex
      expect(ex).to.be.a.instanceof(Error)
      expect(ex).to.have.property('code').that.equals('E_EXP_OBJECT')
      job.done()


  it 'new 2', (done)->
    job = new JobRunner 1, done

    f = {}
    node = new ObjectNode f

    node.on 'create', (e)->
      expect(e).to.be.a.instanceof(BubbleableOdseEvent)
      expect(e).to.have.property('name').that.equals('create')
      expect(e).to.have.property('detail').that.has.a.property('node').that.is.a.instanceof(ObjectNode)
      expect(e.detail.node).to.equal(node)
      expect(node.__value).to.equal(f)
      job.done()
      e.next()

  it 'new 3', (done)->
    job = new JobRunner 1, done

    sampleObject = {
      name: 'John Doe'
      age: 23
    }
    node = new ObjectNode sampleObject

    node.on 'create', (e)->
      expect(e).to.be.a.instanceof(BubbleableOdseEvent)
      expect(e).to.have.property('name').that.equals('create')
      expect(e).to.have.property('detail').that.has.a.property('node').that.is.a.instanceof(ObjectNode)
      expect(e.detail.node).to.equal(node)
      expect(node.__value).to.equal(sampleObject)
      expect(node.childrenMap).to.have.property('name').that.is.a.instanceof(PrimitiveNode)
      expect(node.childrenMap).to.have.property('age').that.is.a.instanceof(PrimitiveNode)
      job.done()
      e.next()

  it '#setValue', (done)->
    job = new JobRunner 1, done

    sampleObject = {
      name: 'John Doe'
      age: 23
    }
    node = new ObjectNode
    node.setValue sampleObject

    node.on 'set', (e)->
      expect(e).to.be.a.instanceof(BubbleableOdseEvent)
      expect(e).to.have.property('name').that.equals('set')
      expect(e).to.have.property('detail').that.has.a.property('node').that.is.a.instanceof(ObjectNode)
      expect(e.detail.node).to.equal(node)
      expect(node.__value).to.equal(sampleObject)
      expect(node.childrenMap).to.have.property('name').that.is.a.instanceof(PrimitiveNode)
      expect(node.childrenMap).to.have.property('age').that.is.a.instanceof(PrimitiveNode)
      job.done()
      e.next()

  it '#setValue + detach', (done)->
    job = new JobRunner 2, done

    sampleObject = {
      name: 'John Doe'
      age: 23
    }
    node = new ObjectNode

    sub = new PrimitiveNode 'SomeValue'

    node.addNode 'aa', sub

    node.setValue sampleObject

    node.on 'set', (e)->
      expect(e).to.be.a.instanceof(BubbleableOdseEvent)
      expect(e).to.have.property('name').that.equals('set')
      expect(e).to.have.property('detail').that.has.a.property('node').that.is.a.instanceof(ObjectNode)
      expect(e.detail.node).to.equal(node)
      expect(node.__value).to.equal(sampleObject)
      expect(node.childrenMap).to.have.property('name').that.is.a.instanceof(PrimitiveNode)
      expect(node.childrenMap).to.have.property('age').that.is.a.instanceof(PrimitiveNode)
      job.done()
      e.next()

    sub.on 'detach', (e)->
      expect(e).to.be.a.instanceof(BubbleableOdseEvent)
      expect(e).to.have.property('name').that.equals('detach')
      expect(e).to.have.property('detail').that.has.a.property('node').that.is.a.instanceof(PrimitiveNode)
      expect(e).to.have.property('detail').that.has.a.property('from').that.equals(node)
      job.done()
      e.next()


  # FIXME: This test fails because the 'detach' event bubbles up AFTER the element has actually been detahced and thus
  # no longer is pointing to the parent where it was supposed to bubble up to!
  # There are many similar test cases which are often denoted by '-' sign to indicate that that part is commented out
  #
  it.skip '#setValue + detach + detach(bubble)', (done)->

    job = new JobRunner 3, done

    sampleObject = {
      name: 'John Doe'
      age: 23
    }
    node = new ObjectNode

    sub = new PrimitiveNode 'SomeValue'

    node.addNode 'aa', sub

    node.setValue sampleObject

    node.on 'set', (e)->
      expect(e).to.be.a.instanceof(BubbleableOdseEvent)
      expect(e).to.have.property('name').that.equals('set')
      expect(e).to.have.property('detail').that.has.a.property('node').that.is.a.instanceof(ObjectNode)
      expect(e.detail.node).to.equal(node)
      expect(node.__value).to.equal(sampleObject)
      expect(node.childrenMap).to.have.property('name').that.is.a.instanceof(PrimitiveNode)
      expect(node.childrenMap).to.have.property('age').that.is.a.instanceof(PrimitiveNode)
      job.done()
      e.next()

    node.on 'detach', (e)->
      console.log 'a'
      expect(e).to.be.a.instanceof(BubbleableOdseEvent)
      expect(e).to.have.property('name').that.equals('detach')
      expect(e).to.have.property('detail').that.has.a.property('node').that.is.a.instanceof(PrimitiveNode)
      expect(e).to.have.property('detail').that.has.a.property('from').that.equals(node)
      job.done()
      e.next()

    sub.on 'detach', (e)->
      expect(e).to.be.a.instanceof(BubbleableOdseEvent)
      expect(e).to.have.property('name').that.equals('detach')
      expect(e).to.have.property('detail').that.has.a.property('node').that.is.a.instanceof(PrimitiveNode)
      expect(e).to.have.property('detail').that.has.a.property('from').that.equals(node)
      job.done()
      e.next()

  it '#addNode + update + attach + attach(bubble)', (done)->
    job = new JobRunner 3, done

    node = new ObjectNode

    subNode = new PrimitiveNode 'SomeValue'

    node.addNode 'someKey', subNode

    node.on 'update', (e)->
      expect(e).to.be.a.instanceof(BubbleableOdseEvent)
      expect(e).to.have.property('name').that.equals('update')
      expect(e).to.have.property('detail').that.has.a.property('node').that.is.a.instanceof(ObjectNode)
      expect(e.detail).to.have.property('operation').that.equals('child-add')
      expect(e.detail).to.have.property('key').that.equals('someKey')
      job.done()
      e.next()

    node.on 'attach', (e)->
      expect(e).to.be.a.instanceof(BubbleableOdseEvent)
      expect(e).to.have.property('name').that.equals('attach')
      expect(e).to.have.property('detail').that.has.a.property('node').that.is.a.instanceof(PrimitiveNode)
      expect(e).to.have.property('detail').that.has.a.property('to').that.is.a.instanceof(ObjectNode)
      expect(e.target).to.equal(node).to.not.equal(e.origin).to.equal(subNode)
      job.done()
      e.next()

    subNode.on 'attach', (e)->
      expect(e).to.be.a.instanceof(BubbleableOdseEvent)
      expect(e).to.have.property('name').that.equals('attach')
      expect(e).to.have.property('detail').that.has.a.property('node').that.is.a.instanceof(PrimitiveNode)
      expect(e).to.have.property('detail').that.has.a.property('to').that.is.a.instanceof(ObjectNode)
      expect(e.target).to.equal(e.origin).to.equal(subNode)
      job.done()
      e.next()

  it '#removeNode + update + detach - detach(bubble)', (done)->
    job = new JobRunner 2, done

    node = new ObjectNode

    subNode = new PrimitiveNode 'SomeValue'

    node.addNode 'someKey', subNode

    node.removeNode 'someKey'

    node.on 'update', (e)->
      return e.next() if e.detail.operation is 'child-add'
      expect(e).to.be.a.instanceof(BubbleableOdseEvent)
      expect(e).to.have.property('name').that.equals('update')
      expect(e).to.have.property('detail').that.has.a.property('node').that.is.a.instanceof(ObjectNode)
      expect(e.detail).to.have.property('operation').that.equals('child-remove')
      expect(e.detail).to.have.property('key').that.equals('someKey')
      job.done()
      e.next()

    # node.on 'detach', (e)->
    #   expect(e).to.be.a.instanceof(BubbleableOdseEvent)
    #   expect(e).to.have.property('name').that.equals('detach')
    #   expect(e).to.have.property('detail').that.has.a.property('node').that.is.a.instanceof(PrimitiveNode)
    #   expect(e).to.have.property('detail').that.has.a.property('from').that.is.a.instanceof(ObjectNode)
    #   expect(e.target).to.equal(node).to.not.equal(e.origin).to.equal(subNode)
    #   job.done()
    #   e.next()

    subNode.on 'detach', (e)->
      expect(e).to.be.a.instanceof(BubbleableOdseEvent)
      expect(e).to.have.property('name').that.equals('detach')
      expect(e).to.have.property('detail').that.has.a.property('node').that.is.a.instanceof(PrimitiveNode)
      expect(e).to.have.property('detail').that.has.a.property('from').that.is.a.instanceof(ObjectNode)
      expect(e.target).to.equal(e.origin).to.equal(subNode)
      job.done()
      e.next()


  it '#addNode(operation:replace-child) + update + detach - detach(bubble) + attach + attach', (done)->
    job = new JobRunner 4, done

    node = new ObjectNode

    subNode = new PrimitiveNode 'SomeValue'

    subNode2 = new PrimitiveNode 'SomeValueAnother'

    node.addNode 'someKey', subNode

    node.addNode 'someKey', subNode2

    node.on 'update', (e)->
      return e.next() if e.detail.operation is 'child-add'
      expect(e).to.be.a.instanceof(BubbleableOdseEvent)
      expect(e).to.have.property('name').that.equals('update')
      expect(e).to.have.property('detail').that.has.a.property('node').that.is.a.instanceof(ObjectNode)
      expect(e.detail).to.have.property('operation').that.equals('child-replace')
      expect(e.detail).to.have.property('childNode').that.equals(subNode2)
      expect(e.detail).to.have.property('replacedChildNode').that.equals(subNode)
      expect(e.detail).to.have.property('key').that.equals('someKey')
      job.done()
      e.next()

    # node.on 'detach', (e)->
    #   expect(e).to.be.a.instanceof(BubbleableOdseEvent)
    #   expect(e).to.have.property('name').that.equals('detach')
    #   expect(e).to.have.property('detail').that.has.a.property('node').that.is.a.instanceof(PrimitiveNode)
    #   expect(e).to.have.property('detail').that.has.a.property('from').that.is.a.instanceof(ObjectNode)
    #   expect(e.target).to.equal(node).to.not.equal(e.origin).to.equal(subNode)
    #   job.done()
    #   e.next()

    subNode.on 'attach', (e)->
      expect(e).to.be.a.instanceof(BubbleableOdseEvent)
      expect(e).to.have.property('name').that.equals('attach')
      expect(e).to.have.property('detail').that.has.a.property('node').that.is.a.instanceof(PrimitiveNode)
      expect(e).to.have.property('detail').that.has.a.property('to').that.is.a.instanceof(ObjectNode)
      expect(e.target).to.equal(e.origin).to.equal(subNode)
      job.done()
      e.next()

    subNode2.on 'attach', (e)->
      expect(e).to.be.a.instanceof(BubbleableOdseEvent)
      expect(e).to.have.property('name').that.equals('attach')
      expect(e).to.have.property('detail').that.has.a.property('node').that.is.a.instanceof(PrimitiveNode)
      expect(e).to.have.property('detail').that.has.a.property('to').that.is.a.instanceof(ObjectNode)
      expect(e.target).to.equal(e.origin).to.equal(subNode2)
      job.done()
      e.next()

    subNode.on 'detach', (e)->
      expect(e).to.be.a.instanceof(BubbleableOdseEvent)
      expect(e).to.have.property('name').that.equals('detach')
      expect(e).to.have.property('detail').that.has.a.property('node').that.is.a.instanceof(PrimitiveNode)
      expect(e).to.have.property('detail').that.has.a.property('from').that.is.a.instanceof(ObjectNode)
      expect(e.target).to.equal(e.origin).to.equal(subNode)
      job.done()
      e.next()
