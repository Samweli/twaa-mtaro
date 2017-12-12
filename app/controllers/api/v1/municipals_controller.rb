class Api::V1::MunicipalsController < Api::V1::BaseController
  # GET /municipals
  # GET /municipals.json
  def index
    @municipals = Municipal.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @municipals }
    end
  end

  def wards
    wards = Ward.find_all_by_municipal_id(params[:id])
    render json: wards, root: 'wards'
  end


  # GET /municipals/1
  # GET /municipals/1.json
  def show
    @municipal = Municipal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @municipal }
    end
  end

  # GET /municipals/new
  # GET /municipals/new.json
  def new
    @municipal = Municipal.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @municipal }
    end
  end

  # GET /municipals/1/edit
  def edit
    @municipal = Municipal.find(params[:id])
  end

  # POST /municipals
  # POST /municipals.json
  def create
    @municipal = Municipal.new(params[:municipal])

    respond_to do |format|
      if @municipal.save
        format.html { redirect_to @municipal, notice: 'Municipal was successfully created.' }
        format.json { render json: @municipal, status: :created, location: @municipal }
      else
        format.html { render action: "new" }
        format.json { render json: @municipal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /municipals/1
  # PUT /municipals/1.json
  def update
    @municipal = Municipal.find(params[:id])

    respond_to do |format|
      if @municipal.update_attributes(params[:municipal])
        format.html { redirect_to @municipal, notice: 'Municipal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @municipal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /municipals/1
  # DELETE /municipals/1.json
  def destroy
    @municipal = Municipal.find(params[:id])
    @municipal.destroy

    respond_to do |format|
      format.html { redirect_to municipals_url }
      format.json { head :no_content }
    end
  end
end
