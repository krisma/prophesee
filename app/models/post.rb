class Post < ActiveRecord::Base
  belongs_to :user
  validates :content, presence: true
  validates :date_publish, presence: true
end
