class Api::V1::DrainsController < Api::V1::BaseController

  def index
    # check for the type of drains to query
    # TODO update all where_custom domain method to use
    # base where with select as Domain.where(conditions).select('columns')
    if params.has_key?(:type)
      if params[:type] == 'all'
        @drains = Drain.find_all(10000)
      else
        if params[:type] == 'cleaned'
          @drains = Drain.where_custom(:cleared => true)
        elsif params[:type] == 'uncleaned'
          @drains = Drain.where_custom(:cleared => false)
        elsif params[:type] == 'need_help'
          @drains = Drain.where_custom(:need_help => true)
        elsif params[:type] == 'unknown'
          @drains = Drain.where(:cleared => nil, :need_help => nil).
              select('*, ST_AsKML(the_geom) AS "kml"')
        elsif params[:type] == 'adopted'
          @drains = Drain.where_custom_conditions(:claims_count, "> 0")
        elsif params[:type] == 'not_adopted'
          @drains = Drain.where_custom_conditions(:claims_count, "= 0")
        elsif params[:type].include? "address"
          values = params[:type].split('=')
          value = values[1]
          @drains = Drain.where_custom(:gid => value)
        end
      end

      unless @drains.blank?
        render(
            json: ActiveModel::ArraySerializer.new(
                @drains,
                each_serializer: Api::V1::DrainSerializer,
                root: 'drains',
            )
        )
      else
        render :json => {:errors => {:address => [t("errors.not_found", :thing => t("defaults.thing"))]}}, :status => 404
      end
    else
      @drains = Drain.find_closest(params[:lat], params[:lng], params[:limit] || 10000)
      #puts "#{@drains.size} drains found for [#{params[:lat]}, #{params[:lng]}]"
      unless @drains.blank?
        respond_with(@drains) do |format|
          format.kml {render}
        end
      else
        render :json => {:errors => {:address => [t("errors.not_found", :thing => t("defaults.thing"))]}}, :status => 404
      end
    end
  end

  def street_drains
    drains = Drain.includes(:claims).find_all(params[:id])
    render :json => drains

  end

end