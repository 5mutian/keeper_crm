class Company < Account
	has_one :admin
	has_many :salers
	has_many :customer_servicers
	has_many :accts
end