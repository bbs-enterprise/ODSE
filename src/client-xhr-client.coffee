class ClientXhrClient

  xhrObj = null
  localCbfnRefernence = null

  constructor : () ->
    _init()

  _init = () ->
    xhrObj = new XMLHttpRequest()

  _onReadyStateChange = () ->
    if xhrObj.readyState is 0
      result = '{"hasError":true,"error":"Failed to connect to the internet."}'
      localCbfnRefernence ( JSON.parse result )
    if xhrObj.readyState is 4 and xhrObj.status is 200
      result = xhrObj.responseText
      localCbfnRefernence ( JSON.parse result )

  _onRequestError = () ->
    result = '{"hasError":true,"error":"An error occurred while transferring the data to server."}'
    localCbfnRefernence ( JSON.parse result )

  postRequest : ( url , data , cbfn ) =>
    localCbfnRefernence = cbfn
    xhrObj.open "POST" , url , true
    xhrObj.setRequestHeader 'Content-type' , 'application/json'
    xhrObj.onreadystatechange = _onReadyStateChange
    xhrObj.addEventListener 'error' , _onRequestError
    xhrObj.send data

@ClientXhrClient = ClientXhrClient
