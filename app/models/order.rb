class Order < ActiveRecord::Base

	STATE = { 
		'new' 										=> '新订单',
		'appointed_measurement' 	=> '预约测量', 
		'measured' 								=> '已测量',
		'appointed_installation' 	=> '预约安装', 
		'installed' 							=> '已安装', 
		'completed' 							=> '完成交易', 
		'canceled'								=> '已取消', 
		'confirm_installed' 			=> '管理员确认安装(*品牌商才有)'
	}

	after_update :execute_strategy

	def execute_strategy
		if completed?
			# 执行策略，反利
		end
	end

	def completed?
	end

end
