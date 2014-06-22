console.log "loaded"

COINBASE_URL = "https://coinbase.com/oauth/authorize?response_type=code&client_id=2af562103350eca06528b58789d77955ec9c7d3b8d794b16827bea600e7817c3&redirect_uri=http://localhost:2000/coinbase"

buy_with_bitbuy = (opts, cb) ->
  $.post 'http://localhost:2000/buy', opts, (data) ->
    data = JSON.parse(data)
    tokens = data.tokens
    store("tokens", tokens)

    codes = data.codes
    cb codes

$ ->
  window.onmessage = (e) ->
    console.log e.data
    store('tokens', e.data);
    buy_with_bitbuy()

  add_bitbuy_button()

  buy_with_bitbuy = ->
    amount = parseFloat(get_amount(), 10) * 100
    tokens = store("tokens")
    buy_with_bitbuy {tokens, amount, site: "amazon"}, (cards) ->
      apply_cards cards, 0
      place_order()

  $('#buy-with-bitbuy').on 'click', (e) ->
    e.preventDefault()
    if store("tokens")
      buy_with_bitbuy()
    else
      window.open COINBASE_URL, '', 'width=900,height=600'
