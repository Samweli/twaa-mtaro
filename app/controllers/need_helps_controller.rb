class NeedHelpsController < ApplicationController
  layout 'info_window'
  # GET /need_helps
  # GET /need_helps.json
  def index
    @need_helps = NeedHelp.find_all_by_gid(params[:gid])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @need_helps }
    end
  end

  # GET /need_helps/1
  # GET /need_helps/1.json
  def show
    @need_help = NeedHelp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @need_help }
    end
  end

  # GET /need_helps/new
  # GET /need_helps/new.json
  def new
    @need_help = NeedHelp.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @need_help }
    end
  end

  # GET /need_helps/1/edit
  def edit
    @need_help = NeedHelp.find(params[:id])
  end

  # POST /need_helps
  # POST /need_helps.json
  def create
    @need_help = NeedHelp.new(params[:need_help])

    respond_to do |format|
      if @need_help.save
        format.html { redirect_to @need_help, notice: 'Need help was successfully created.' }
        format.json { render json: @need_help, status: :created, location: @need_help }
      else
        format.html { render action: "new" }
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
        format.html { redirect_to @need_help, notice: 'Need help was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @need_help.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /need_helps/1
  # DELETE /need_helps/1.json
  def destroy
    refresh_layer = false
    @need_help = NeedHelp.find(params[:id])
    gid = @need_help.gid
    @need_help.destroy
    drain = Drain.find(gid)
    if (drain.need_helps.empty?)
      refresh_layer = true
      drain.update_attribute(:need_help, false)
    end

    render :json => {:refresh => refresh_layer}
  end
end
