# 订单同步
require 'rest-client'

module Cgj
	CGJ_HOST = ''

	def sync(order_hash={})
		RestClient.post CGJ_HOST << "", order_hash
	end

	def auth(mobile)
		# auth cgj
	end

end