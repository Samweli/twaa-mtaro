class Api::V1::DrainsController < Api::V1::BaseController

  def index
    @drains = Drain.find_all_by_drain_type(params[:type], params[:page], params[:count])
    if !@drains.blank?
      render :json => {:drains => ActiveModel::ArraySerializer.new(
          @drains,
          each_serializer: Api::V1::DrainSerializer
      ), total: @drains.total_count}
    else
      render :json => {:errors => {:address => [t("errors.not_found", :thing => t("defaults.thing"))]}}, :status => 404
    end
  end


  def show
    drain = Drain.find_by_gid(params[:id])
    render(json: Api::V1::DrainSerializer.new(drain).to_json)
  end


  def street_drains

    if params.has_key?(:type)
      if params[:type] == 'adopted'
        drains = Street.joins(users: [{drain_claims: :drain}]).where('streets.id' => params[:id]).select('mitaro_dar.*')
      else
        if params[:type] == 'cleaned'
          drains = Street.joins(users: [{drain_claims: :drain}]).where('streets.id' => params[:id], 'mitaro_dar.cleared' => true).select('mitaro_dar.*')
        elsif params[:type] == 'uncleaned'
          drains = Street.joins(users: [{drain_claims: :drain}]).where('streets.id' => params[:id], 'mitaro_dar.cleared' => false).select('mitaro_dar.*')
        elsif params[:type] == 'need_help'
          drains = Street.joins(users: [{drain_claims: :drain}]).where('streets.id' => params[:id], 'mitaro_dar.need_help' => true).select('mitaro_dar.*')
        end
      end

      unless drains.blank?
        render(
            json: ActiveModel::ArraySerializer.new(
                drains,
                each_serializer: Api::V1::DrainSerializer,
                root: 'drains',
            )
        )
      else
        render :json => {:errors => {:address => [t("errors.not_found", :thing => t("defaults.thing"))]}}, :status => 404
      end
    end

  end


  def data
    all_drains = Drain.count
    cleaned_drains = Drain.where(:cleared => true).size
    uncleaned_drains = Drain.where(:cleared => false).size
    need_help_drains = Drain.where(:need_help => true).size
    unknown_drains = Drain.where(:cleared => nil, :need_help => nil).size
    adopted_drains = Drain.where("claims_count > '0'").size
    notadopted_drains = Drain.where("claims_count = '0'").size


    render :json => {
        :all => all_drains,
        :uncleaned => uncleaned_drains,
        :cleaned => cleaned_drains,
        :need_help => need_help_drains,
        :unknown => unknown_drains,
        :adopted => adopted_drains,
        :not_adopted => notadopted_drains
    }
  end

  def ranking
    streets = Street.all
    ranking_data = []


    streets.each_with_index do |s, index|
      ranking_data[index] = street_drain_data(s.id)
    end

    render :json => {:ranking => ranking_data}
  end

  private

  def street_drain_data(id)
    drains_street = Street.find(id)
    drains_adopted = Street.joins(users: [{drain_claims: :drain}]).where('streets.id' => id).size
    drains_cleaned = Street.joins(users: [{drain_claims: :drain}]).where('streets.id' => id, 'mitaro_dar.cleared' => true).size
    drains_uncleaned = Street.joins(users: [{drain_claims: :drain}]).where('streets.id' => id, 'mitaro_dar.cleared' => false).size
    drains_need_help = Street.joins(users: [{drain_claims: :drain}]).where('streets.id' => id, 'mitaro_dar.need_help' => true).size

    return {
        street: drains_street,
        details: {:adopted => drains_adopted,
                  :cleaned => drains_cleaned,
                  :uncleaned => drains_uncleaned,
                  :need_help => drains_need_help}
    }
  end
end