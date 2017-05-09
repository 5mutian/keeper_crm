namespace :init do
	
	task :new => :environment do
		ac = Company.create(name: '百安居', code: 'BAJ')
	
		admin = User.create(name: 'admin', mobile: '15802162343', password: '123456', role: 'admin', account_id: ac.id)
		saler = User.create(name: 'saler', mobile: '15802162344', password: '123456', role: 'saler', account_id: ac.id)
		acct  = User.create(name: 'acct',  mobile: '15802162345', password: '123456', role: 'acct',  account_id: ac.id)
		cs    = User.create(name: 'cs',    mobile: '15802162346', password: '123456', role: 'cs',    account_id: ac.id)
	end

end