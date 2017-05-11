require 'roo'

namespace :products do
	
	task :suntek => :environment do
		xlsx = Roo::Spreadsheet.open('public/suntek.xlsx', extension: :xlsx)
		xlsx.each do |row|
			p row
		end
	end

end