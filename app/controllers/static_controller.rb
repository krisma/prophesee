class StaticController < ApplicationController
  before_action :authenticate_user!, only: [:change_nickname, :dashboard]
  def index
  	@posts = Post.all
  	@post = user_signed_in?? current_user.posts.new : Post.new
    @stocks = Stock.all
    @watching = Watching.new
  end
  def dashboard
  end

  def change_nickname
    @user = current_user
  end

  def show_sign
  end
  def switch_sign_in
  end
  def switch_sign_up
  end
  def market
    @popular = $redis.get("popular")
    if @popular.nil?
      @popular = (Stock.all.sort_by { |stock| stock.users.count }).first(10)

    else
      @popular = JSON.parse(@popular)
    end
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
