class StaticController < ApplicationController
  def index
  	@posts = Post.all
  	@post = user_signed_in?? current_user.posts.new : Post.new
    @stocks = Stock.all
    @watching = Watching.new
  end
  def market
    @stocks = Stock.all
  end
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
