AMAZON_BITBUY_BUTTON = """
<span class="a-button a-button-primary a-button-span12" style="margin-left: 0;margin-top: 10px">
  <span class="a-button-inner a-button-span12">
    <input id='buy-with-bitbuy' title="Buy with BitBuy" class="a-button-text place-your-order-button" value="Buy with BitBuy" type="submit" data-testid="">
  </span>
</span>
"""

window.add_bitbuy_button = ->
  console.log "adding bitbuy button"
  $('.place-order-button-link').after AMAZON_BITBUY_BUTTON
