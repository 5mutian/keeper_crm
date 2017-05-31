# 订单同步
require 'rest-client'

module Cgj
	# "id"=>10, "name"=>"阳毅门窗"

	# RestClient::Request.execute(url:'https://api.chuanggj.com/api/access_user', method: :get, headers: AUTH_KEY, payload: {tel: '15802162343'})
	def self.access_user(tel)
		RestClient::Request.execute(
			url: 			URI(APP_CONFIG['cgj_host'] + '/api/access_user').to_s,
			method: 	:get,
			headers: 	{Authorization: APP_CONFIG['cgj_auth_key']},
			payload: 	{tel: tel}
		)
	end

	# user_hash = {tel: '15802162343', real_name: 'evan.zhang', password: '123456', company_id: 11, region: 'CRM'}
	# RestClient::Request.execute(url:'https://api.chuanggj.com/api/create_user', method: :post, headers: AUTH_KEY, payload: user_hash)
	def self.create_user(user_hash={})
		RestClient::Request.execute(
			url: 			URI(APP_CONFIG['cgj_host'] + '/api/create_user').to_s,
			method: 	:post,
			headers: 	{Authorization: APP_CONFIG['cgj_auth_key']},
			payload: 	user_hash
		)
	end

	# RestClient::Request.execute(url:'https://api.chuanggj.com/api/fetch_company', method: :get, headers: AUTH_KEY)
	def self.fetch_company
		RestClient::Request.execute(
			url: 			URI(APP_CONFIG['cgj_host'] + '/api/fetch_company').to_s,
			method: 	:get,
			headers: 	{Authorization: APP_CONFIG['cgj_auth_key']}
		)
	end

	def self.fetch_material
		RestClient::Request.execute(
			url: 			URI(APP_CONFIG['cgj_host'] + '/api/fetch_material').to_s,
			method: 	:get,
			headers: 	{Authorization: APP_CONFIG['cgj_auth_key']}
		)
	end

	def self.create_order(order_hash={})
		RestClient::Request.execute(
			url: 			URI(APP_CONFIG['cgj_host'] + '/api/orders').to_s,
			method: 	:post,
			headers: 	{Authorization: APP_CONFIG['cgj_auth_key']},
			payload: 	{order: order_hash, sign: options_to_sha1(order_hash)}
		)
	end

	private
	# 将发送的参数转成Hash, 在根据键来字母排序, 在转成字符串, 将token放在字符串首尾进行SHA1加密
	def self.options_to_sha1(options={})
    string = options.sort.map{|k| k}.join
    params = "#{APP_CONFIG['cgj_token']}{#{string}#{APP_CONFIG['cgj_token']}"
    Digest::SHA1.hexdigest(params).upcase
  end

end