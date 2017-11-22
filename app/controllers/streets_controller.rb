
class StreetsController < ApplicationController
  def add_drain
    @drain = Drain.find_by_gid(params[:gid])
    @street = Street.find(params[:street_id])
    @street.drains << @drain

    render :json => {:success => "let look at the db"}
  end
end