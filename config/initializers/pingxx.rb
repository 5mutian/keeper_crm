require "#{Rails.root}/lib/pingxx_extend.rb"
Pingpp.api_key = ENV['pingpp_api_key']
Pingpp.private_key_path = File.dirname(__FILE__) + '/private_key.pem'