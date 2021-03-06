class StocksController < ApplicationController
  before_action :authenticate_user!, except: [:search, :show, :draw_days, :draw_month, :draw_months, :draw_year, :draw_all]
  protect_from_forgery :except => :show

  layout :runtime_layout

  def runtime_layout
    if user_signed_in?
      'only_dashboard'
    else
      'except_dashboard'
    end
  end

  def index
  end
  def search
    @stock = Stock.search_brief(params[:search])

  end

  # def search
  #   @stock = Stock.find_by_symbol(params[:search])
  #   if @stock
  #   else
  #     @stock = Stock.find_by_name(params[:search])
  #     if @stock
  #     else
  #       if Stock.search_online(params[:search]) == "N/A"
  #         flash[:error] = params[:search].to_s + " not found."
  #       else
  #         @stock = Stock.init(params[:search])
  #       end
  #     end
  #   end
  # end

  def watchdepre
  	@stock = Stock.find_by_symbol(params[:symbol].to_s.upcase)
  	if @stock
  		if current_user.watching?(@stock.symbol)
  			flash[:error] = @stock.symbol + " is on watchlist."
  		else
       @watching = Watching.new
       @watching.changeable = true
       @watching.attitude = 0
       @watching.save
       @stock.watchings << @watching
       current_user.watchings << @watching
       flash[:notice] = @stock.symbol + " added."
     end
   else
    flash[:error] = params[:symbol].to_s + " not found."
  end
  redirect_to dashboard_path
end

def watch
  @stock = Stock.find(params[:id])
  if @stock
    if current_user.watching?(@stock.symbol)
      flash[:error] = @stock.symbol + " is on watchlist."
    else
     @watching = Watching.new
     @watching.changeable = true
     @watching.attitude = 0
     @watching.save
     @stock.watchings << @watching
     current_user.watchings << @watching
     flash[:notice] = @stock.symbol + " added."
   end
 else
  flash[:error] = params[:symbol].to_s + " not found."
end
redirect_to dashboard_path
end

def unwatch
  @stock = Stock.find(params[:id])
  if @stock
    if current_user.watching?(@stock.symbol)
      @watching = Watching.find_by(user_id: current_user.id, stock_id: @stock)
      @watching.delete
      flash[:notice] = @stock.symbol + " is removed from watchlist."
    else
       flash[:error] = @stock.symbol + " is not on watchlist."
   end
  else
    flash[:error] = params[:symbol].to_s + " not found."
end
redirect_to dashboard_path
end

def show
  @stock = Stock.find(params[:id])

end

def up
	@w = Watching.find_by(id: params[:id])
	@w.attitude = 1
	@w.save
	redirect_to dashboard_path
end
def down
  @w = Watching.find_by(id: params[:id])
  @w.attitude = -1
  @w.save
  redirect_to dashboard_path
end
def neutral
  @w = Watching.find_by(id: params[:id])
  @w.attitude = 0
  @w.save
  redirect_to dashboard_path
end

def draw_month
  @stock = Stock.find(params[:id])
  respond_to do |format|
    format.js
  end
end
def draw_months
  @stock = Stock.find(params[:id])
  respond_to do |format|
    format.js
  end
end
def draw_days
  @stock = Stock.find(params[:id])
  respond_to do |format|
    format.js
  end
end
def draw_year
  @stock = Stock.find(params[:id])
  respond_to do |format|
    format.js
  end
end
def draw_all
  @stock = Stock.find(params[:id])
  respond_to do |format|
    format.js
  end
end
end
