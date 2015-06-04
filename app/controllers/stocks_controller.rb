class StocksController < ApplicationController
  before_action :authenticate_user!, except: [:search]
  protect_from_forgery :except => :show
  def index
  end
  def search
    @stock = Stock.find_by_symbol(params[:search])
    if @stock.nil?
      @stock = Stock.find_by_name(params[:search])
    end
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

  def watch
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
  	redirect_to root_path
  end
  

  def show
    @stock = Stock.find(params[:id])

  end

  def up
	@w = Watching.find_by(id: params[:id])
	@w.attitude = 1
	@w.save
	redirect_to root_path
  end
  def down
  	@w = Watching.find_by(id: params[:id])
	@w.attitude = -1
	@w.save
	redirect_to root_path
  end
  def neutral
  	@w = Watching.find_by(id: params[:id])
	@w.attitude = 0
	@w.save
	redirect_to root_path
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
