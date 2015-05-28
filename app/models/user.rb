class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  before_create :set_default
  has_many :posts
  has_many :watchings
  has_many :stocks, through: :watchings

  def set_default
  	self.total_count = 0
  	self.good_count = 0
  	self.quota = 3
  end

  def accuracy
  	if self.total_count == 0
  		return 0
  	else
  		return self.good_count / self.total_count
  	end
  end

  def watching?(symbol)
    return self.stocks.find_by_symbol(symbol)
  end


  def watchlist
    request = []
    self.stocks.each do |s|
      request << s.symbol
    end
    response = YahooFinance.quotes(request, [:symbol, :close, :change_and_percent_change])
    return response
  end
end
