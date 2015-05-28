class Stock < ActiveRecord::Base
	has_many :watchings
	has_many :users, through: :watchings
	
	def watchlist
		request = []
		current_user.stocks.each do |s|
			request << s.symbol
		end
		response = YahooFinance.quotes(request, [:close, :change_and_percent_change])
		return response
	end
	

	def close
		return YahooFinance.quotes([self.symbol],[:close])[0].close
	end

	def change
		return YahooFinance.quotes([self.symbol],[:change_and_percent_change])[0].change_and_percent_change.split[0]
	end

	def percent_change
		return YahooFinance.quotes([self.symbol],[:change_and_percent_change])[0].change_and_percent_change.split[2]
	end

	def last_five
		tmp = YahooFinance.historical_quotes(self.symbol,{ start_date: Time::now-(24*60*60*10), end_date: Time::now }).first(5);
		rtn = []
		tmp.each do |t|
			rtn << [t.trade_date[5...t.trade_date.size], t.high.to_f, t.open.to_f, t.close.to_f, t.low.to_f]
		end
		return rtn
	end
end
