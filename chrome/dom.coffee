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
  messages = $('#addGiftCardOrPromo_Unknown').parent().find('p').toArray()
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
  return unless cards[i]
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
