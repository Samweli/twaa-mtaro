
class StreetsController < ApplicationController
  def add_drain
    @drain = Drain.find_by_gid(params[:gid])
    @street = Street.find(params[:street_id])
    @street.drains << @drain

    render :json => {:success => true}
  end

  def index

    @streets = Street.all
    if params[:search]
      @streets = Street.search(params[:search])
    else
      @streets = Street.all
    end
    render :json => { :streets => @streets}
  end

  def search
    @drain_results = Drain.ransack(address_cont: params[:q]).result(distinct: true).limit(5)
    @street_results = Street.ransack(street_name_cont: params[:q]).result(distinct: true).limit(5)
    render json: { streets: ActiveModel::ArraySerializer.new(
        @street_results,
        each_serializer: Api::V1::StreetSerializer
    ), drains: ActiveModel::ArraySerializer.new(
        @drain_results,
        each_serializer: Api::V1::DrainSerializer
    ) }
  end
end