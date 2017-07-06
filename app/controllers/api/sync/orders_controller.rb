# 订单同步
class Api::Sync::OrdersController < Api::Sync::BaseController
	
	# 同步更新 host: http://192.168.0.164:7200/
	# Params
	# Return
	# Error
	def update_cgj
		_user = params["results"].delete("customer_info")

		user  	= User.find_or_initialize_by(mobile: _user["tel"])
		company = Company.find_by_cgj_id(_user["company_id"])

		if user.type != 'Dealer'
			unless company
				company 					= Company.find_or_initialize_by(name: _user["company_name"])
				company.cgj_id 		= _user["company_id"]
				company.save
			end
		end


		if user
			user.update(account_id: company.id) unless user.account
			user.update(cgj_user_id: params["results"]["customer_id"]) unless user.cgj_user_id
		else
			user.name   			= _user["real_name"]
			user.password 		= 'CRM123'
			user.role 				= 'admin'
			user.account_id 	= company.id
			user.cgj_user_id 	= params["results"]["customer_id"]
			user.save
		end

		customer = Customer.find_or_initialize_by(tel: params["results"]["tel"])

		if customer.new_record?

			%w(name province city area street address longitude latitude).each do |ele|
				customer.send("#{ele}=", params["results"][ele])
			end

			customer.user_id 		= user.id
			customer.account_id = user.account_id
			customer.save
		end


		order = Order.find_or_initialize_by(serial_number: params["results"]["serial_number"])

		Rails.logger.info "*" * 100
		Rails.logger.info order.attributes
		Rails.logger.info "*" * 100

		_order = params["results"].except("id", "created_at", "updated_at", "customer_id")

		(order.attributes.keys & _order.keys).each do |ele|
			order.send("#{ele}=", _order[ele]) 
		end
		order.booking_date 						= Time.at(_order["booking_date"].to_i)
		order.install_date 						= Time.at(_order["install_date"].to_i)
		order.cgj_company_id 					= _order["company_id"]
		order.cgj_facilitator_id 			= _order["facilitator_id"]
		order.cgj_customer_service_id = _order["customer_service_id"]

		order.user_id 		= user.id
		order.account_id 	= user.account_id
		order.customer_id = customer.id

		order.save

		render json: {status: :success, msg: 'updated successfully'}
		# rescue => e
		# 	render json: {status: :failed, msg: e.message}
	end

end