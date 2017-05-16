# 订单同步
require 'rest-client'

module Cgj

	# CGJ_HOST = 'https://api.chuanggj.com'
	# AUTH_KEY = {Authorization: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiQ1JNIiwiYXBpX3R5cGUiOiIiLCJ0b2tlbiI6ImU1ZmE1YTIyNDMxNzQ0ZGFhZDhlNDljZjE4NzhlYzA2IiwiZXhwIjoyMTI1OTg0NDgwfQ.yEW0TPjRr6DaGerX-BDA7YmsEFR5HpuSIuPJjBIXBe4'}
	CGJ_HOST = 'http://192.168.0.164:8080'
	AUTH_KEY = {Authorization: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiQ1JNIiwiYXBpX3R5cGUiOiJDUk0iLCJ0b2tlbiI6ImZjZWQ2NjEzZGFmYjQ1NmI4ZDcwMDBlNzI0Yzc2NTU3IiwiZXhwIjoyMTI2MDU5MzEwfQ.NtvCE4BLQ1Ioyum_TIBSg4jyIMk-Y3GumPdlPYg9GuI'}
	TOKEN = 'e5fa5a22431744daad8e49cf1878ec06'

	# "id"=>10, "name"=>"阳毅门窗"

	# RestClient::Request.execute(url:'https://api.chuanggj.com/api/access_user', method: :get, headers: AUTH_KEY, payload: {tel: '15802162343'})
	def self.access_user(tel)
		RestClient::Request.execute(url: CGJ_HOST << '/api/access_user', method: :get, headers: AUTH_KEY, payload: {tel: tel})
	end

	# user_hash = {tel: '15802162343', real_name: 'evan.zhang', password: '123456', company_id: 11, region: 'CRM'}
	# RestClient::Request.execute(url:'https://api.chuanggj.com/api/create_user', method: :post, headers: AUTH_KEY, payload: user_hash)
	def self.create_user(user_hash={})
		RestClient::Request.execute(url: CGJ_HOST << '/api/create_user', method: :post, headers: AUTH_KEY, payload: user_hash)
	end

	# RestClient::Request.execute(url:'https://api.chuanggj.com/api/fetch_company', method: :get, headers: AUTH_KEY)
	def self.fetch_company
		RestClient::Request.execute(url: CGJ_HOST << '/api/fetch_company', method: :get, headers: AUTH_KEY)
	end

	def self.create_order(order_hash={})
		RestClient::Request.execute(url: CGJ_HOST << '/api/orders', method: :post, headers: AUTH_KEY, payload: order_hash)
	end

	# 将发送的参数转成Hash, 在根据键来字母排序, 在转成字符串, 将token放在字符串首尾进行SHA1加密
	def options_to_sha1(options={})
    string = options.sort.map{|k| k}.join
    params = "#{token}{#{string}#{token}"
    Digest::SHA1.hexdigest(params).upcase
  end

end