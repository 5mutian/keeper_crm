# 订单同步
class Api::Sync::OrdersController < Api::Sync::BaseController
	
	# 同步更新 host: http://192.168.0.164:7200/
	# Params
	# Return
	# Error
	def update_cgj
		order = Order.find_by_serial_number(params["order"]["serial_number"])

		if order
			order.update_attributes({
				uuid: 										params["order"]["uuid"],
				width: 										params["order"]["width"],
				height:         					params["order"]["height"],
				rate:  										params["order"]["rate"],
				total: 										params["order"]["total"],
				remark: 									params["order"]["remark"],
				state:  									params["order"]["state"],
				province:   							params["order"]["province"],
				city:       							params["order"]["city"],
				area:       							params["order"]["area"],
				courier_number: 					params["order"]["courier_number"],
				install_date:   					Time.at(params["order"]["install_date"].to_i),
				cgj_company_id: 					params["order"]["company_id"],
				cgj_facilitator_id: 			params["order"]["facilitator_id"],
				cgj_customer_service_id: 	params["order"]["customer_service_id"],
				material: 								params["order"]["material"],
				material_id: 							params["order"]["material_id"],
				workflow_state: 					params["order"]["workflow_state"],
				public_order: 						params["order"]["public_order"],
				square: 									params["order"]["square"],
				mount_order:  						params["order"]["mount_order"],
				serial_number: 						params["order"]["serial_number"],
				is_company: 							params["order"]["is_company"],
				measure_amount: 					params["order"]["measure_amount"],
				install_amount:     			params["order"]["install_amount"],
				manager_confirm: 					params["order"]["manager_confirm"],
				terminal_count: 					params["order"]["terminal_count"],
				amount_total_count: 			params["order"]["amount_total_count"],
				basic_order_tax: 					params["order"]["basic_order_tax"],
				measure_amount_after_comment: 	params["order"]["measure_amount_after_comment"],
				installed_amount_after_comment: params["order"]["installed_amount_after_comment"],
				measure_comment: 								params["order"]["measure_comment"],
				measure_raty: 									params["order"]["measure_raty"],
				installed_raty: 								params["order"]["installed_raty"],
				service_measure_amount: 				params["order"]["service_measure_amount"],
				service_installed_amount: 			params["order"]["service_installed_amount"],
				basic_tax: 											params["order"]["basic_tax"],
				deduct_installed_cost: 					params["order"]["deduct_installed_cost"],
				deduct_measure_cost: 						params["order"]["deduct_measure_cost"],
				sale_commission: 								params["order"]["sale_commission"],
				intro_commission: 							params["order"]["intro_commission"],
			})

			order.customer.update_attributes({
				longitude: 	params["order"]["longitude"],
				latitude: 	params["order"]["latitude"],
				address: 		params["order"]["address"],
				tel:        params["order"]["tel"],
				province:   params["order"]["province"],
				city:       params["order"]["city"],
				area:       params["order"]["area"],
				street:  		params["order"]["street"]
			})
			render json: {status: :success, msg: 'updated successfully'}
		else
			render json: {status: :failed, msg: 'not found'}
		end
		
	end

end