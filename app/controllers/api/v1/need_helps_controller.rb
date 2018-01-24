class Api::V1::NeedHelpsController < Api::V1::BaseController
  layout 'info_window'
  # GET /need_helps
  # GET /need_helps.json
  def index
    @need_helps = NeedHelp.all

    respond_to do |format|
      format.json { render :json => @need_helps.to_json(:include => [:need_help_category,
                                                                     :user =>{:include => :street}]) }
    end
  end

  def search

    if(params[:status])
      if(params[:municipal_name] or params[:ward_name] or params[:street_name])
        results = NeedHelp.joins({user: [street: [{ward: :municipal}]]}, :need_help_category)
                      .where( ['municipal_name = ? OR ward_name = ? OR street_name = ? AND status = ?',
                               "#{params[:municipal_name]}","#{params[:ward_name]}","#{params[:street_name]}","#{params[:status]}"])
      else
        results = NeedHelp.joins({user: [street: [{ward: :municipal}]]}, :need_help_category)
                      .where( ['municipal_name = ? OR ward_name = ? OR street_name = ? OR status = ?',
                               "#{params[:municipal_name]}","#{params[:ward_name]}","#{params[:street_name]}","#{params[:status]}"])
      end
    else
      results = NeedHelp.joins({user: [street: [{ward: :municipal}]]}, :need_help_category)
                    .where( ['municipal_name = ? OR ward_name = ? OR street_name = ? OR status = ?',
                             "#{params[:municipal_name]}","#{params[:ward_name]}","#{params[:street_name]}","#{params[:status]}"])
    end

    render :json => results.to_json(:include => [:need_help_category,
                                                :user =>{:include => :street}])
  end

  # GET /need_helps/1
  # GET /need_helps/1.json
  def show
    @need_help = NeedHelp.find(params[:id])

    respond_to do |format|
      format.json { render json: @need_help }
    end
  end

  def update_status
    NeedHelp.status(params[:need_help_id], params[:status], params[:description])
    render :json => {:success => true}
  end


  # POST /need_helps
  # POST /need_helps.json
  def create
    @need_help = NeedHelp.new(params[:need_help])

    respond_to do |format|
      if @need_help.save
        format.json { render json: @need_help, status: :created, location: @need_help }
      else
        format.json { render json: @need_help.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /need_helps/1
  # PUT /need_helps/1.json
  def update
    @need_help = NeedHelp.find(params[:id])

    respond_to do |format|
      if @need_help.update_attributes(params[:need_help])
        format.json { head :no_content }
      else
        format.json { render json: @need_help.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /need_helps/1
  # DELETE /need_helps/1.json
  def destroy
    @need_help = NeedHelp.find(params[:id])
    @need_help.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
