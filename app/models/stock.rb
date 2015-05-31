class Stock < ActiveRecord::Base
	has_many :watchings
	has_many :users, through: :watchings
	before_create :set_random_default



	def set_default
		self.up = 0
		self.down = 0
		self.neutral = 0
	end

	def set_random_default
		self.up = Random.rand(100)
		self.neutral = Random.rand(100)
		self.down = Random.rand(100)
	end

	def total
		return self.up + self.neutral + self.down
	end

	def uppercent
		return self.total == 0? 0 : self.up.to_f / self.total * 100
	end

	def neutralpercent
		return self.total == 0? 0 : self.neutral.to_f / self.total * 100
	end

	def downpercent
		return self.total == 0? 0 : self.down.to_f / self.total * 100
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
			rtn.insert(0, [t.trade_date[5...t.trade_date.size], t.high.to_f, t.open.to_f, t.close.to_f, t.low.to_f])
		end
		return rtn
	end

	def get_detail
		return YahooFinance.quotes([self.symbol], [:days_range, :weeks_range_52, :open, :volume, :market_capitalization, :pe_ratio, :dividend_yield, :eps_estimate_current_year , :shares_owned, :name])[0]
	end
end
