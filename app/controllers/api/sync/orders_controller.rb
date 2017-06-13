# 订单同步
class Api::Sync::OrdersController < Api::Sync::BaseController
	
	# 同步更新 host: http://192.168.0.164:7200/
	# Params
	# Return
	# Error
	def update_cgj
		_user = params["results"].delete("customer_info")
		user  = User.find_or_initialize_by(mobile: _user["tel"])

		unless user
			company = Company.find_by_cgj_id(_user["company_id"])

			unless company
				company 					= Company.find_or_initialize_by(name: _user["company_name"])
				company.parent_id = @account.id
				company.cgj_id 		= _user["company_id"]
				company.save
			end

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
			customer.account_id = @account.id
			customer.save
		end


		order = Order.find_or_initialize_by(serial_number: params["results"]["serial_number"])

		(order.attributes.keys & params["results"].keys).each do |ele|
			order.send("#{ele}=", params["results"][ele]) 
		end

		order.install_date 						= Time.at(params["results"]["install_date"].to_i)
		order.cgj_company_id 					= params["results"]["company_id"]
		order.cgj_facilitator_id 			= params["results"]["facilitator_id"]
		order.cgj_customer_service_id = params["results"]["customer_service_id"]

		order.user_id 		= user.id
		order.account_id 	= @account.id
		order.customer_id = customer.id

		order.save

		render json: {status: :success, msg: 'updated successfully'}
		# rescue => e
		# 	render json: {status: :failed, msg: e.message}
	end

end