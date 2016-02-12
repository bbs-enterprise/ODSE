{ InitialDataDissectionObj } = require './initial-data-dissection.coffee'
{ ServerOdseApiCall } = require './server-odse-api-call.coffee'
{ StorageDecider } = require './storage-decider.coffee'
{ ConstructOdseTree } = require './construct-odse-tree.coffee'
{ ClientOdseScriptGenerator } = require './temp/server/client-odse-script-generator.coffee'

class TreeMerger

  constructor : () ->
    new ClientOdseScriptGenerator()
    jsonString = '[{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"button-up","classList":{"0":"button-up"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"body","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"header","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"lang-chooser","classList":{"0":"lang-chooser"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox menu-box","classList":{"0":"roundbox","1":"menu-box"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-lt","classList":{"0":"roundbox-lt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-rt","classList":{"0":"roundbox-rt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-lb","classList":{"0":"roundbox-lb"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-rb","classList":{"0":"roundbox-rb"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"menu-list-container","classList":{"0":"menu-list-container"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"sidebar","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox sidebox","classList":{"0":"roundbox","1":"sidebox"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-lt","classList":{"0":"roundbox-lt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-rt","classList":{"0":"roundbox-rt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"caption titled","classList":{"0":"caption","1":"titled"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"top-links","classList":{"0":"top-links"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"socials","classList":{"0":"socials"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"fb-root","className":" fb_reset","classList":{"0":"fb_reset"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"fb-like fb_iframe_widget","classList":{"0":"fb-like","1":"fb_iframe_widget"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox sidebox","classList":{"0":"roundbox","1":"sidebox"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-lt","classList":{"0":"roundbox-lt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-rt","classList":{"0":"roundbox-rt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"caption titled","classList":{"0":"caption","1":"titled"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"top-links","classList":{"0":"top-links"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"personal-sidebar","classList":{"0":"personal-sidebar"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"for-avatar","classList":{"0":"for-avatar"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"avatar","classList":{"0":"avatar"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox sidebox top-contributed","classList":{"0":"roundbox","1":"sidebox","2":"top-contributed"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-lt","classList":{"0":"roundbox-lt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-rt","classList":{"0":"roundbox-rt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"caption titled","classList":{"0":"caption","1":"titled"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"top-links","classList":{"0":"top-links"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"bottom-links","classList":{"0":"bottom-links"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox sidebox top-contributed","classList":{"0":"roundbox","1":"sidebox","2":"top-contributed"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-lt","classList":{"0":"roundbox-lt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-rt","classList":{"0":"roundbox-rt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"caption titled","classList":{"0":"caption","1":"titled"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"top-links","classList":{"0":"top-links"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"bottom-links","classList":{"0":"bottom-links"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox sidebox","classList":{"0":"roundbox","1":"sidebox"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-lt","classList":{"0":"roundbox-lt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-rt","classList":{"0":"roundbox-rt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"caption titled","classList":{"0":"caption","1":"titled"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"top-links","classList":{"0":"top-links"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox sidebox","classList":{"0":"roundbox","1":"sidebox"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-lt","classList":{"0":"roundbox-lt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"roundbox-rt","classList":{"0":"roundbox-rt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"caption titled","classList":{"0":"caption","1":"titled"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"top-links","classList":{"0":"top-links"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"recent-actions","classList":{"0":"recent-actions"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"bottom-links","classList":{"0":"bottom-links"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"pageContent","className":"content-with-sidebar","classList":{"0":"content-with-sidebar"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"second-level-menu","classList":{"0":"second-level-menu"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"leftLava","classList":{"0":"leftLava"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"bottomLava","classList":{"0":"bottomLava"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"cornerLava","classList":{"0":"cornerLava"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"datatable ratingsDatatable","classList":{"0":"datatable","1":"ratingsDatatable"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"lt","classList":{"0":"lt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"rt","classList":{"0":"rt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"lb","classList":{"0":"lb"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"rb","classList":{"0":"rb"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"ilt","classList":{"0":"ilt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"irt","classList":{"0":"irt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"pagination","classList":{"0":"pagination"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"footer","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"userListsFacebox","classList":{"0":"userListsFacebox"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"datatable","classList":{"0":"datatable"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"lt","classList":{"0":"lt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"rt","classList":{"0":"rt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"lb","classList":{"0":"lb"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"rb","classList":{"0":"rb"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"ilt","classList":{"0":"ilt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"irt","classList":{"0":"irt"},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"datepick-div","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxOverlay","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"colorbox","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxWrapper","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxTopLeft","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxTopCenter","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxTopRight","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxMiddleLeft","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxContent","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxLoadedContent","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxLoadingOverlay","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxLoadingGraphic","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxTitle","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxCurrent","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxNext","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxPrevious","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxSlideshow","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxClose","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxMiddleRight","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxBottomLeft","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxBottomCenter","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"cboxBottomRight","className":"","classList":{},"nodeType":1},{"tabIndex":-1,"localName":"div","tagName":"DIV","id":"","className":"","classList":{},"nodeType":1}]'
    jsonString = '[{"val":1,"name":"test"},{"val":2,"name":"ron"}]'
    jsonString = '{"val":1}'
    ServerOdseApiCall.clearAllOdseDataApi ( response1 ) =>
      console.log response1
      blobId1 = InitialDataDissectionObj.run jsonString , 'ARSDP3vSx01QNiPGARSDP3vSx01QNiPGARSDP3vSx01QNiPGARSDP3vSx01QNiPGARSDP3vSx01QNiPGARSDP3vSx01QNiPGARSDP3vSx01QNiPGARSDP3vSx01QNiPG' , ( response2 , response3 ) =>
        console.log response2
        console.log response3
        constructOdseTreeObj = new ConstructOdseTree blobId1 , () =>
          console.log constructOdseTreeObj.extractValue()

new TreeMerger()

## NOTE