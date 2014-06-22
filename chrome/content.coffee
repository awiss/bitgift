console.log "loaded"

COINBASE_URL = "https://coinbase.com/oauth/authorize?response_type=code&client_id=2af562103350eca06528b58789d77955ec9c7d3b8d794b16827bea600e7817c3&redirect_uri=http://localhost:2000/coinbase"

$ ->
  window.onmessage = (e) ->
    console.log "this is me"
    console.log e.data
    # store('accessToken', e.data.accessToken);

  add_bitbuy_button()

  $('#buy-with-bitbuy').on 'click', (e) ->
    e.preventDefault()
    if store("accessToken")
      console.log "PAY LIKE A BITCH"
    else
      window.open COINBASE_URL, '', 'width=900,height=600'
