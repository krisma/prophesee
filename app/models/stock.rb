class Stock < ActiveRecord::Base
	has_many :watchings
	has_many :users, through: :watchings
	
	def close
		return YahooFinance.quotes([self.symbol],[:close])[0].close
	end

	def change
		return YahooFinance.quotes([self.symbol],[:change_and_percent_change])[0].change_and_percent_change.split[0]
	end

	def percent_change
		return YahooFinance.quotes([self.symbol],[:change_and_percent_change])[0].change_and_percent_change.split[2]
	end
end
