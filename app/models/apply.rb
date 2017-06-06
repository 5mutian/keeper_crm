class Apply < ActiveRecord::Base

	STATE = {
						0  => '新请求',
						1  => '接受',
						-1 => '拒绝'
					}

	# _action: 合作 cooperate
end
