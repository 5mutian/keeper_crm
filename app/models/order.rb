class Order < ActiveRecord::Base

	# CGJ serial_number
	# 介绍人 完成订单生成介绍人，执行策略
	# 	terminal_count: 税前总价				
	# 	amount_total_count: 税后总价

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

	after_update :execute_strategy

	before_create :init_attrs

def init_attrs
		workflow_state = :new
	end

	def sync_cgj
		res = Cgj.create_order(cgj_hash)
		_hash = JSON res.body
		if _hash["code"] == 200
			_order = _hash["order"].except("id", "created_at", "updated_at", "customer_id")
			(attributes.keys & _order.keys).each do |ele|
				self.send("#{ele}=", _order[ele]) 
			end
			self.booking_date 						= Time.at(_order["booking_date"].to_i)
			self.install_date 						= Time.at(_order["install_date"].to_i)
			self.cgj_company_id 					= _order["company_id"]
			self.cgj_facilitator_id 			= _order["facilitator_id"]
			self.cgj_customer_service_id  = _order["customer_service_id"]
			self.save

			self.customer.update_attributes({
				longitude: 	_order["longitude"],
				latitude: 	_order["latitude"],
				address: 		_order["address"],
				tel:        _order["tel"],
				province:   _order["province"],
				city:       _order["city"],
				area:       _order["area"],
				street:  		_order["street"],
				user_id: 		self.user_id
			})
		end
	end

	def execute_strategy
		if completed?
			# 介绍人生成，执行介绍人反利，销售提成
			gen_introducer if introducer_tel
			# 获取策略
			strategy = account.get_valid_strategy(province, city, area)

			if strategy
				StrategyResult.create(
					saler_id: user_id,
					saler_rate_amount: terminal_count * rate,
					customer_id: customer_id,
					customer_discount_amount: terminal_count * discount,
					introducer_id: introducer_id,
					introducer_rebate_amount: terminal_count * rebate,
					order_id: id,
					strategy_id: strategy.id
				)
			end
		end
	end

	def gen_introducer
		introducer = User.get_or_gen_introducer(introducer_tel, introducer_name, account_id)
		self.update_attributes(introducer_id: introducer.id)
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
