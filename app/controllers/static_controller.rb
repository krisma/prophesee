class StaticController < ApplicationController
  before_action :authenticate_user!, only: [:change_nickname]
  def index
  	@posts = Post.all
  	@post = user_signed_in?? current_user.posts.new : Post.new
    @stocks = Stock.all
    @watching = Watching.new
  end


  def change_nickname
    @user = current_user
  end

  def market
    @upstocks = Stock.all.order('up desc')
    @neutralstocks = Stock.all.order('neutral desc')
    @downstocks = Stock.all.order('down desc')
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
