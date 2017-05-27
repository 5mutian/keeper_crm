class Order < ActiveRecord::Base

	# CGJ serial_number
	# 介绍人 完成订单生成介绍人，执行策略

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

	has_one :introducer, foreign_key: "introducer_id", class_name: 'User'

	delegate :province, :city, :area, :street, :tel, :name, to: :customer

	after_create :sync_cgj
	after_update :execute_strategy

	before_create :init_attrs

	def init_attrs
		workflow_state = :new
	end

	def sync_cgj
		res = Cgj.create_order(cgj_hash)
		_hash = JSON res.body
		if _hash["code"] == 200
			self.update_attributes({
				uuid: 										_hash["order"]["uuid"],
				width: 										_hash["order"]["width"],
				height:         					_hash["order"]["height"],
				rate:  										_hash["order"]["rate"],
				total: 										_hash["order"]["total"],
				remark: 									_hash["order"]["remark"],
				state:  									_hash["order"]["state"],
				courier_number: 					_hash["order"]["courier_number"],
				install_date:   					Time.at(_hash["order"]["install_date"].to_i),
				cgj_company_id: 					_hash["order"]["company_id"],
				cgj_facilitator_id: 			_hash["order"]["facilitator_id"],
				cgj_customer_service_id: 	_hash["order"]["customer_service_id"],
				material: 								_hash["order"]["material"],
				material_id: 							_hash["order"]["material_id"],
				workflow_state: 					_hash["order"]["workflow_state"],
				public_order: 						_hash["order"]["public_order"],
				square: 									_hash["order"]["square"],
				mount_order:  						_hash["order"]["mount_order"],
				serial_number: 						_hash["order"]["serial_number"],
				is_company: 							_hash["order"]["is_company"],
				measure_amount: 					_hash["order"]["measure_amount"],
				install_amount:     			_hash["order"]["install_amount"],
				manager_confirm: 					_hash["order"]["manager_confirm"],
				terminal_count: 					_hash["order"]["terminal_count"],
				amount_total_count: 			_hash["order"]["amount_total_count"],
				basic_order_tax: 					_hash["order"]["basic_order_tax"],
				measure_amount_after_comment: 	_hash["order"]["measure_amount_after_comment"],
				installed_amount_after_comment: _hash["order"]["installed_amount_after_comment"],
				measure_comment: 								_hash["order"]["measure_comment"],
				measure_raty: 									_hash["order"]["measure_raty"],
				install_raty: 									_hash["order"]["install_raty"],
				service_measure_amount: 				_hash["order"]["service_measure_amount"],
				service_installed_amount: 			_hash["order"]["service_installed_amount"],
				basic_tax: 											_hash["order"]["basic_tax"],
				deduct_installed_cost: 					_hash["order"]["deduct_installed_cost"],
				deduct_measure_cost: 						_hash["order"]["deduct_measure_cost"],
				sale_commission: 								_hash["order"]["sale_commission"],
				intro_commission: 							_hash["order"]["intro_commission"],
			})

			self.customer.update_attributes({
				longitude: 	_hash["order"]["longitude"],
				latitude: 	_hash["order"]["latitude"],
				address: 		_hash["order"]["address"],
				tel:        _hash["order"]["tel"],
				province:   _hash["order"]["province"],
				city:       _hash["order"]["city"],
				area:       _hash["order"]["area"],
				street:  		_hash["order"]["street"]
			})
		end
	end

	def execute_strategy
		if completed?
			# 介绍人生成，执行介绍人反利，销售提成
			if introducer_tel
				introducer = User.get_or_gen_introducer(introducer_tel, introducer_name, account_id)
				self.update_attributes(introducer_id: introducer.id)
			end

		end
	end

	def completed?
		workflow_state == 'completed'
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
