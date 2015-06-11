class StaticController < ApplicationController
  before_action :authenticate_user!, only: [:change_nickname, :dashboard]
  # layout "except_dashboard", except: [:dashboard]
  layout :runtime_layout

  def runtime_layout
    if user_signed_in?
      'only_dashboard'
    else
      'except_dashboard'
    end
  end

  def index
    render layout: 'except_dashboard'
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
    tmp = $redis.get("cache-popular")
    if tmp.nil?
      @stocks = (Stock.all.sort_by { |stock| stock.users.count }).first(10)
      requests = []
      @stocks.each do |s|
        requests << s.id
      end
      $redis.set("cache-popular", requests.to_json)
      $redis.expire("cache-popular", 300)
    else
      data = JSON.parse(tmp)
      @stocks = []
      data.each do |d|
        @stocks << Stock.find(d)
      end
    end
  end

  def setting
 
  end
  
  def change_avatar
    current_user.avatar = params[:avatar]
    current_user.save
    redirect_to setting_path
  end

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
