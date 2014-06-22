#!/usr/bin/env ruby
require 'watir-webdriver'
require 'net/http'
require 'uri'
require 'openssl'
require 'json'
require 'mail'

@size = 0
ARGV.each do|a|
  @size += 1
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

@array = Array.new
sleep 6
uri = URI.parse("https://api.runscope.com")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE
request = Net::HTTP::Get.new("/buckets/1htmleryg16r/captures")
request.add_field('Authorization', "Bearer 6ce43f53-7e00-4da4-a63c-f54a90b1f4de")
response = http.request(request)
responses = JSON.parse(response.body)
responses['data'].each do |a|
  uuid = a["uuid"]
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Get.new("/buckets/1htmleryg16r/messages/" + uuid)
  request.add_field('Authorization', "Bearer 6ce43f53-7e00-4da4-a63c-f54a90b1f4de")
  response = http.request(request)
  response_body = JSON.parse(response.body)
  email_body = response_body['data']['response']['body']
  decoded = URI.unescape(email_body)
  if match_groups = decoded.match(/Amount\: \$(\d+\.\d+).*Claim code ([A-Z0-9]{4}-[A-Z0-9]{6}-[A-Z0-9]{4})/)
    one, two = match_groups.captures 
    test = {one => two}
    @array << test
  end
end
@array.each do |(a,b)|
  puts "Purchased a gift code with claim code #{a}."
end
