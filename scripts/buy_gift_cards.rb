#!/usr/bin/env ruby
require 'watir-webdriver'

ARGV.each do|a|
  browser = Watir::Browser.new :firefox
  browser.goto "https://www.amazon.com/gp/product/B004LLIKVU/gcrnsts?ie=UTF8&qid=1403408127&ref_=sr_1_1&s=gift-cards&sr=1-1"
  browser.text_field(:name => 'amount').set("#{a}")
  browser.text_field(:name => 'email').set("9a7de7db07336f4805dccf42464e3663@inbound.postmarkapp.com")
  browser.form(:id,'egcForm-EmailDesigns').submit
  puts browser.url
  browser.text_field(:id => 'ap_email').set("scwu@seas.upenn.edu")
  browser.text_field(:id => 'ap_password').set("bbsquared")
  browser.form(:id, 'ap_signin_form').submit
  browser.radio(:value => 'creditCard.jhronwoqlm').set
  browser.button(:id, "continue-bottom").click
  sleep 2
  browser.button(:class, "place-your-order-button").click
  browser.close
end
