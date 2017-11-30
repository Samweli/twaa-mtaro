
class StreetsController < ApplicationController
  def add_drain
    @drain = Drain.find_by_gid(params[:gid])
    @street = Street.find(params[:street_id])
    @street.drains << @drain

    render :json => {:success => "let look at the db"}
  end

  def index
    puts "index called inside streets controller"
    @streets = Street.all
    if params[:search]
      @streets = Street.search(params[:search])
    else
      @streets = Street.all
    end
    render :json => { :streets => @streets}
  end
end