// Generated by CoffeeScript 1.7.1
(function() {
  var AMAZON_BITBUY_BUTTON, apply_cards_i, gift_card_loading, wait_for_gift_card;

  AMAZON_BITBUY_BUTTON = "<span class=\"a-button a-button-primary a-button-span12\" style=\"margin-left: 0;margin-top: 10px\">\n  <span class=\"a-button-inner a-button-span12\">\n    <input id='buy-with-bitbuy' title=\"Buy with ɃitBuy\" class=\"a-button-text place-your-order-button\" value=\"Buy with ɃitBuy\" type=\"submit\" data-testid=\"\">\n  </span>\n</span>";

  window.add_bitbuy_button = function() {
    return $('.place-order-button-link').after(AMAZON_BITBUY_BUTTON);
  };

  gift_card_loading = function() {
    var error_messages, m, messages, success_messages, _i, _len;
    error_messages = $('#addGiftCardOrPromo_Unknown').parent().find('p').toArray();
    success_messages = $('#gc-promo-success').find('p').toArray();
    messages = error_messages.concat(success_messages);
    for (_i = 0, _len = messages.length; _i < _len; _i++) {
      m = messages[_i];
      console.log(m.style.display);
      if (m.style.display !== "none") {
        return false;
      }
    }
    return true;
  };

  wait_for_gift_card = function(cards, i) {
    if (gift_card_loading()) {
      return setTimeout(function() {
        return wait_for_gift_card(cards, i);
      }, 200);
    } else {
      return setTimeout(function() {
        return apply_cards_i(cards, i);
      }, 200);
    }
  };

  apply_cards_i = function(cards, i) {
    var card;
    if (!cards[i]) {
      $('.loading-spinner').removeClass('force-display');
      $('.loading-spinner').css('display', 'none');
      place_order();
      return;
    }
    card = cards[i];
    console.log("applying card: " + card);
    $('#spc-gcpromoinput').val(card);
    $('.redeem-gc-right input[type=submit]').get(0).click();
    return setTimeout(function() {
      return wait_for_gift_card(cards, i + 1);
    }, 200);
  };

  window.apply_cards = function(cards) {
    if (!cards.length) {
      return;
    }
    $('.loading-spinner').addClass('force-display');
    $('.loading-spinner').css('display', 'block');
    return apply_cards_i(cards, 0);
  };

  window.place_order = function() {
    $('.place-your-order-button').get(0).click();
    return console.log("order placed");
  };

  window.get_amount = function() {
    var grand_total;
    grand_total = $('.grand-total-price').text();
    return grand_total.slice(1);
  };

  window.hide_gift_card_fields = function() {
    var style;
    $('strong:contains(Gift cards)').parent().parent().parent().parent().css('visibility', 'hidden');
    style = document.createElement('link');
    style.rel = 'stylesheet';
    style.type = 'text/css';
    style.href = chrome.extension.getURL('amazon.css');
    (document.head || document.documentElement).appendChild(style);
    return $('td:contains(Gift Card:)').text('Bitcoin:');
  };

}).call(this);
