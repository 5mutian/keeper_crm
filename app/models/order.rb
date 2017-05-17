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

	# after_create :sync_cgj
	after_update :execute_strategy

	def sync_cgj
		res = Cgj.create_order(cgj_hash)
		_hash = JSON res.body
		if _hash["code"] == 200
			self.update_attributes({
				uuid: 					_hash["order"]["uuid"],
				serial_number: 	_hash["order"]["serial_number"],
				workflow_state: _hash["order"]["workflow_state"],
				public_order: 	_hash["order"]["public_order"]
			})

			self.customer.update_attributes({
				longitude: 	_hash["order"]["longitude"],
				latitude: 	_hash["order"]["latitude"],
				address: 		_hash["order"]["address"]
			})
		else

		end
	end

	def execute_strategy
		if completed?
			# 执行策略，反利
		end
	end

	def completed?
	end

	def cgj_hash
		{
			square: 				expected_square,
			province: 			province,
			city: 					city,
			area: 					area,
			street: 				street,
			tel: 						tel,
			name: 					name,
			booking_date: 	booking_date.to_i,
			mount_order: 		mount_order,
			total: 					total,
			company_id: 		cgj_company_id,
			material: 			material,
			material_id: 		material_id,
			order_no: 			id,
			customer_id: 		user.cgj_user_id, # 窗管家用户ID
			region: 				region
		}
	end

	def to_hash
		{
			square: 				expected_square,
			province: 			province,
			city: 					city,
			area: 					area,
			street: 				street,
			tel: 						tel,
			name: 					name,
			booking_date: 	booking_date.strftime("%F %T"),
			mount_order: 		mount_order,
			total: 					total,
			company_id: 		cgj_company_id,
			material: 			material,
			material_id: 		material_id,
			id: 						id,
			customer: 			user_id,
			region: 				region
		}
	end

end
