#!/usr/bin/env ruby
require 'watir-webdriver'
require 'net/http'
require 'url'

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
  #if browser.button(:id, "confirm-card").exists?
  #  browser.text_field(:id => 'addCreditCardNumber').set("4430400023463619")
  #  browser.button(:id, "confirm-card").click
  #  sleep 2
  #end
  browser.button(:id, "continue-bottom").click
  sleep 2
  browser.button(:class, "place-your-order-button").click
  browser.close
end

url=URI.parse("https://api.runscope.com/buckets/1htmleryg16r/captures")
req.NET::HTTP::Get.new(url.path)
req.add_field("Authorization", "Bearer 6ce43f53-7e00-4da4-a63c-f54a90b1f4de")
res = Net::HTTP.new(url.host, url.port).start do |http|
  http.request(req)
end
puts res.body
