require 'net/http'
require 'uri'
require 'openssl'
require 'json'
require 'mail'

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
    puts one
    puts two
  end
end
