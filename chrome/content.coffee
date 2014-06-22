console.log "loaded"

COINBASE_URL = "https://coinbase.com/oauth/authorize?response_type=code&client_id=2af562103350eca06528b58789d77955ec9c7d3b8d794b16827bea600e7817c3&redirect_uri=http://localhost:2000/coinbase"

buy_with_bitbuy = (opts, cb) ->
  $.post 'http://localhost:2000/buy', opts, (data) ->
    tokens = data.tokens
    store("tokens", tokens)

    codes = data.codes
    cb codes

$ ->
  window.onmessage = (e) ->
    data = JSON.parse(e.data)
    console.log data
    if data.access_token and data.refresh_token and data.code
      store('tokens', data);
      buy()
    else
      console.log "this ain't me."

  # add the button
  add_bitbuy_button()

  # hide gift card fields
  hide_gift_card_fields()

  buy = ->
    amount = parseFloat(get_amount(), 10) * 100
    tokens = store("tokens")
    buy_with_bitbuy {tokens, amount, site: "amazon"}, (cards) ->
      apply_cards cards, 0
      place_order()

  $('#buy-with-bitbuy').on 'click', (e) ->
    e.preventDefault()
    if store("tokens")
      buy()
    else
      window.open COINBASE_URL, '', 'width=900,height=600'
