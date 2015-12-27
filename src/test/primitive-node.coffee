
{ expect } = require 'chai'

{ ObjectDataStorageEngine, PrimitiveNode, BubbleableOdseEvent } = require './../odse'

{ JobRunner } = require './_job-runner'

describe 'PrimitiveNode' , ->

  it 'new', (done)->
    job = new JobRunner 1, done

    node = new PrimitiveNode 'Example Value'

    node.on 'create', (e)->
      expect(e).to.be.a.instanceof(BubbleableOdseEvent)
      expect(e).to.have.property('name').that.equals('create')
      expect(e).to.have.property('detail').that.has.a.property('node').that.is.a.instanceof(PrimitiveNode)
      expect(e.detail.node).to.equal(node)
      expect(node.__value).to.equal('Example Value')
      job.done()


  it '#setValue', (done)->
    job = new JobRunner 1, done

    node = new PrimitiveNode 'Example Value'
    node.setValue 'New Value'
    node.on 'set', (e)->
      expect(e).to.be.a.instanceof(BubbleableOdseEvent)
      expect(e).to.have.property('name').that.equals('set')
      expect(e).to.have.property('detail').that.has.a.property('node').that.is.a.instanceof(PrimitiveNode)
      expect(e.detail.node).to.equal(node)
      expect(e).to.have.property('detail').that.has.a.property('oldValue').that.equals('Example Value')
      expect(e).to.have.property('detail').that.has.a.property('newValue').that.equals('New Value')
      expect(node).to.have.property('__value').that.equals('New Value')
      job.done()

  it '#getValue', (done)->
    job = new JobRunner 1, done

    node = new PrimitiveNode 'Example Value'
    node.setValue 'New Value'
    node.on 'set', (e)->
      expect(node.getValue()).to.equal('New Value')
      job.done()
