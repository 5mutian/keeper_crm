class Apply < ActiveRecord::Base

	belongs_to :user

	STATE = {
						0  => '新请求',
						1  => '通过',
						-1 => '拒绝'
					}

	# _action: 合作 cooperate

	def target_user
		User.find target_user_id
	end


	def cooperate_hash
		{
			id: id,
			dealer_name: user.account.name,
			dealer_admin: user.name,
			dealer_mobile: user.mobile,
			state: STATE[state]
		}
	end
end
