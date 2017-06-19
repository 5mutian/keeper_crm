class Strategy < ActiveRecord::Base

	# discount 折扣 客户
	# rebate   返利 介绍人
	# rate     提成 客服

	# 基数  1, 订单总价税前； 2, 订单总价税后，3, 客服提成

	belongs_to :account

	scope :valid, lambda {where("state=true and start_at<? and end_at>?", Time.now, Time.now)}
end
