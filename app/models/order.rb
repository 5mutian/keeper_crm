class Order < ActiveRecord::Base

	# CGJ serial_number

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

	belongs_to :user
	belongs_to :account
	belongs_to :customer

	delegate :province, :city, :area, :street, :tel, :name, to: :customer

	after_create :sync_cgj
	after_update :execute_strategy

	def sync_cgj
		res = Cgj.create_order(cgj_order_hash)
		# save cgj order id
	end

	def execute_strategy
		if completed?
			# 执行策略，反利
		end
	end

	def completed?
	end

	def cgj_order_hash
		{
			square: 				expected_square,
			province: 			customer_province,
			city: 					customer_city,
			area: 					customer_area,
			street: 				customer_street,
			tel: 						customer_tel,
			name: 					customer_name,
			booking_date: 	booking_date,
			mount_order: 		mount_order,
			total: 					total,
			measure_amount: measure_amount,
			company_id: 		company_id,
			material: 			material,
			material_id: 		material_id,
			order_no: 			order_no,
			customer: 			user_id,
			region: 				'CRM'
		}
	end

end
