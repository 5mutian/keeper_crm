class ValidCode < ActiveRecord::Base

	TYPES = {
		1 => '注册验证',
	}

	before_create :gen_code
	after_create :send_sms

	def gen_code
		self.code = rand(8999) + 1000
	end

	def sms_hash
		{
			to: 			mobile,
			project: 	ENV['submail_valid_code'],
			vars: 		{code: code}
		}
	end

	def send_sms
		Submail.send(sms_hash)
	end

end
