namespace :init do
	
	task :new => :environment do
		ac = Company.create(name: '百安居', code: 'BAJ')
	
		admin = User.create(name: 'admin', mobile: '15802162343', password: '123456', role: 'admin', account_id: ac.id)

		saler_director = User.create(name: 'cs_director',  mobile: '15802162349', password: '123456', role: 'saler_director', account_id: ac.id)
		zx = User.create(name: '张晓',    mobile: '15802162347', password: '123456', role: 'saler_director', account_id: ac.id)
		zm = User.create(name: '张明',    mobile: '15802162348', password: '123456', role: 'saler_director', account_id: ac.id)

		saler = User.create(name: 'saler', mobile: '15802162344', password: '123456', role: 'saler', account_id: ac.id, saler_director_id: zx.id)
		acct  = User.create(name: 'acct',  mobile: '15802162345', password: '123456', role: 'acct',  account_id: ac.id)
		cs    = User.create(name: 'cs',    mobile: '15802162346', password: '123456', role: 'cs',    account_id: ac.id)
	end

	task :saler => :environment do
		sd_1 = User.create(name: '主管_1',  mobile: '15802162301', password: '123456', role: 'saler_director', account_id: Account.first.id)
		User.create(name: '1_1',  mobile: '15802162302', password: '123456', role: 'saler', account_id: Account.first.id, saler_director_id: sd_1.id)
		sd_11 = User.create(name: '主管_11',  mobile: '15802162301', password: '123456', role: 'saler_director', account_id: Account.first.id, saler_director_id: sd_1.id)
		User.create(name: '11_1',  mobile: '15802162303', password: '123456', role: 'saler', account_id: Account.first.id, saler_director_id: sd_11.id)
	end

end