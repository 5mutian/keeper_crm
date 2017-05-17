namespace :permissions do
	
	task :init => :environment do
		_hash = {
			'api/clues' 		=> {index: '查看线索', create: '创建线索', update: '更新线索', destroy: '删除线索'},
			'api/orders' 		=> {index: '查看订单', create: '创建订单', update: '更新订单', destroy: '删除订单'},
			'api/customers' => {index: '查看客户', create: '创建客户', update: '更新客户'},
			'api/stores' 		=> {index: '查看门店', create: '创建门店', update: '更新门店', destroy: '删除门店'},
			'api/users' 		=> {index: '查看用户', create: '创建用户', update: '更新用户', destroy: '删除用户'},
		}

		_hash.each do |k, v|
			v.each do |k1, v1|
				Permission.create(name: v1, _controller_action: "#{k}/#{k1}")
			end
		end
	end

	task :sets => :environment do
		roles = {
			admin: %w(customers clues orders stores users),
			saler: %w(clues orders customers),
			cs: %w(orders customers stores),
			acct: %w(orders)
		}

		User.all.each do |u|
			_actions = roles[u.role.to_sym].map {|val| "%#{val}%"}
			p _actions
			u.permissions = Permission.where("_controller_action ILIKE ANY ( array[?] )", _actions)
			u.save
		end
	end


end