class Stock < ActiveRecord::Base
	has_many :watchings
	has_many :users, through: :watchings

end
