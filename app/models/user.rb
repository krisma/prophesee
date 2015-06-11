class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  before_create :set_default
  has_many :posts
  has_many :watchings
  has_many :stocks, through: :watchings
  has_attached_file :avatar, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/


  def set_default
  	self.nickname = 'N/A'
    self.rating = ENV['USER_RATING_DEFAULT'].to_f
  	self.quota = 5
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


  def get_watchlist
    request = []
    self.stocks.each do |s|
      request << s.symbol
    end
    response = YahooFinance.quotes(request, [:symbol, :close, :change_and_percent_change, :stock_exchange])
    return response
  end
end
