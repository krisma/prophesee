class Stock < ActiveRecord::Base
	has_many :watchings
	has_many :users, through: :watchings
	before_create :set_random_default

	def self.search_online(search)
		return YahooFinance.quote(search, [:name]).name
	end
	def self.init(search)
		name = YahooFinance.quote(search, [:name]).name
		@stock = Stock.create(symbol: search, name: name)
		return @stock
	end
	# def self.init(search)
	# 	tmp = YahooFinance.quote(search, [:close, :change_and_percent_change, :days_range, :weeks_range_52, :open, :volume, :market_capitalization, :pe_ratio, :dividend_yield, :eps_estimate_current_year , :shares_owned, :name, :stock_exchange, :name, :symbol])
	# 	symbol = tmp.symbol
	# 	name = tmp.name
	# 	close = tmp.close.to_f
	# 	change = tmp.change_and_percent_change.split[0].to_f
	# 	percent_change = tmp.change_and_percent_change.split[2].to_f
	# 	details = { days_range: tmp.days_range, weeks_range_52: tmp.weeks_range_52, open: tmp.open, volume: tmp.volume, market_capitalization: tmp.market_capitalization, pe_ratio: tmp.pe_ratio, dividend_yield: tmp.dividend_yield, eps_estimate_current_year: tmp.eps_estimate_current_year , shares_owned: tmp.shares_owned, stock_exchange: tmp.stock_exchange }
	# 	details_exp = Time.now.utc + 1.day
	# 	five_d = YahooFinance.historical_quotes(symbol,{ start_date: Time::now-(24*60*60*10), end_date: Time::now }).first(5)
	# 	five_d_exp = Time.now.utc + 1.day
	# 	one_m = YahooFinance.historical_quotes(symbol,{ start_date: Time::now-(24*60*60*50), end_date: Time::now }).first(30)
	# 	one_m_exp = Time.now.utc + 1.day
	# 	six_m = YahooFinance.historical_quotes(symbol, { start_date: Time::now-(24*60*60*200), end_date: Time::now, period: :monthly }).first(6)
	# 	six_m_exp = Time.now.utc + 1.day
	# 	one_y = YahooFinance.historical_quotes(symbol, { start_date: Time::now-(24*60*60*400), end_date: Time::now, period: :monthly }).first(12)
	# 	one_y_exp = Time.now.utc + 1.day
	# 	all = YahooFinance.historical_quotes(symbol, { period: :monthly })
	# 	all_exp = Time.now.utc + 1.day
	# 	Stock.openstruct_to_hash(five_d)
	# 	Stock.openstruct_to_hash(one_m)
	# 	Stock.openstruct_to_hash(six_m)
	# 	Stock.openstruct_to_hash(one_y)
	# 	Stock.openstruct_to_hash(all)
	# 	@stock = Stock.create(symbol: tmp.symbol, name: tmp.name, close: close, change: change, percent_change: percent_change, details: details, details_exp: details_exp, five_d: five_d, five_d_exp: five_d_exp, one_m: one_m, one_m_exp: one_m_exp, six_m: six_m, six_m_exp: six_m_exp, one_y: one_y, one_y_exp: one_y_exp, all: all, all_exp: all_exp)
	# 	@stock.save
	# 	return @stock
	# end

	# def self.openstruct_to_hash(array_of_openstruct)
	# 	(0...array_of_openstruct.size).each do |i|
	# 		array_of_openstruct[i] = array_of_openstruct[i].to_h
	# 	end
	# 	return array_of_openstruct
	# end

	def brief
		tmp = $redis.get(self.symbol)
		if tmp.nil?
			tmp = YahooFinance.quote(self.symbol, [:close, :change_and_percent_change, :stock_exchange])
			tmp[:up] = self.up
			tmp[:neutral] = self.neutral
			tmp[:down] = self.down
			tmp[:id] = self.id
			$redis.set(self.symbol, tmp.to_json)
			return tmp.to_h
		else
			return JSON.parse(tmp).to_h
		end
	end

	def self.search_brief(search)
		@stock = Stock.find_by_symbol(search)
		if @stock.nil?
			@stock = Stock.find_by_name(search)
			if @stock.nil?
				@stock = Stock.init(search)
			end
		end
		return @stock
	end


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

	def close
		return YahooFinance.quote(self.symbol, [:close]).close
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

	def market
		return YahooFinance.quotes([self.symbol],[ :stock_exchange])[0].stock_exchange
	end
	def change
		return YahooFinance.quotes([self.symbol],[:change_and_percent_change])[0].change_and_percent_change.split[0]
	end

	def percent_change
		return YahooFinance.quotes([self.symbol],[:change_and_percent_change])[0].change_and_percent_change.split[2]
	end

	def last_five
		tmp = YahooFinance.historical_quotes(self.symbol,{ start_date: Time::now-(24*60*60*10), end_date: Time::now }).first(5)
		rtn = []
		tmp.each do |t|
			rtn.insert(0, [t.trade_date[5...t.trade_date.size], t.high.to_f, t.open.to_f, t.close.to_f, t.low.to_f])
		end
		return rtn
	end

	def last_thirty
		tmp = YahooFinance.historical_quotes(self.symbol,{ start_date: Time::now-(24*60*60*50), end_date: Time::now }).first(30)
		rtn = []
		tmp.each do |t|
			rtn.insert(0, [t.trade_date[5...t.trade_date.size], t.low.to_f, t.open.to_f, t.close.to_f, t.high.to_f])
		end
		return rtn
	end

	def get_detail
		return YahooFinance.quotes([self.symbol], [:days_range, :weeks_range_52, :open, :volume, :market_capitalization, :pe_ratio, :dividend_yield, :eps_estimate_current_year , :shares_owned, :name, :stock_exchange])[0]
	end

	def last_six
		tmp = YahooFinance.historical_quotes(self.symbol, { start_date: Time::now-(24*60*60*200), end_date: Time::now, period: :monthly }).first(6)
		rtn = []
		tmp.each do |t|
			rtn.insert(0, [t.trade_date[5...t.trade_date.size], t.low.to_f, t.open.to_f, t.close.to_f, t.high.to_f])
		end
		return rtn
	end

	def last_twelve
		tmp = YahooFinance.historical_quotes(self.symbol, { start_date: Time::now-(24*60*60*400), end_date: Time::now, period: :monthly }).first(12)
		rtn = []
		tmp.each do |t|
			rtn.insert(0, [t.trade_date[5...t.trade_date.size], t.low.to_f, t.open.to_f, t.close.to_f, t.high.to_f])
		end
		return rtn
	end

	def last_all
		tmp = YahooFinance.historical_quotes(self.symbol, { period: :monthly })
		rtn = []
		tmp.each do |t|
			rtn.insert(0, [t.trade_date[5...t.trade_date.size], t.low.to_f, t.open.to_f, t.close.to_f, t.high.to_f])
		end
		return rtn
	end
end
