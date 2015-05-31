class StocksController < ApplicationController
  before_action :authenticate_user!
  def index
  end
  def search
    @stock = Stock.find_by_symbol(params[:search])
    flash[:notice] = "success"
  end
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
  
  def change_state
  	@watching = Watching.find_by(user_id: current_user.id, stock_id: @stock.id)

  end
  def show
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
end
