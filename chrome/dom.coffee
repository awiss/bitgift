AMAZON_BITBUY_BUTTON = """
<span class="a-button a-button-primary a-button-span12" style="margin-left: 0;margin-top: 10px">
  <span class="a-button-inner a-button-span12">
    <input id='buy-with-bitbuy' title="Buy with BitBuy" class="a-button-text place-your-order-button" value="Buy with BitBuy" type="submit" data-testid="">
  </span>
</span>
"""

window.add_bitbuy_button = ->
  $('.place-order-button-link').after AMAZON_BITBUY_BUTTON

gift_card_loading = ->
  error_messages = $('#addGiftCardOrPromo_Unknown').parent().find('p').toArray()
  success_messages = $('#gc-promo-success').find('p').toArray()
  messages = error_messages.concat(success_messages)
  for m in messages
    console.log m.style.display
    unless m.style.display == "none"
      return false
  return true

wait_for_gift_card = (cards, i) ->
  if gift_card_loading()
    setTimeout ->
      wait_for_gift_card cards, i
    , 200
  else
    # even after it's done, wait a bit
    setTimeout ->
      apply_cards cards, i
    , 200

window.apply_cards = (cards, i) ->
  if not cards[i]
    $('.loading-spinner').removeClass 'force-display'
    return

  $('.loading-spinner').addClass 'force-display'
  card = cards[i]
  console.log "applying card: #{card}"
  $('#spc-gcpromoinput').val card
  $('.redeem-gc-right input[type=submit]').get(0).click()
  setTimeout ->
    wait_for_gift_card cards, i+1
  , 200

window.place_order = ->
  # $('.place-your-order-button').get(0).click()
  console.log "order placed"

window.get_amount = ->
  grand_total = $('.grand-total-price').text()
  return grand_total[1..]

window.hide_gift_card_fields = ->
  $('strong:contains(Gift cards)').parent().parent().parent().parent().css('visibility', 'hidden')
  # inject a style in amazon.css that hides that bitch
  style = document.createElement 'link'
  style.rel = 'stylesheet'
  style.type = 'text/css'
  style.href = chrome.extension.getURL 'amazon.css'
  (document.head||document.documentElement).appendChild style

  $('td:contains(Gift Card:)').text('Bitcoin:')
