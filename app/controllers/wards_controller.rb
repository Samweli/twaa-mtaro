class WardsController < ApplicationController
  # GET /wards
  # GET /wards.json
  def index
    @wards = Ward.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @wards }
    end
  end

  # GET /wards/1
  # GET /wards/1.json
  def show
    @ward = Ward.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ward }
    end
  end

  # GET /wards/new
  # GET /wards/new.json
  def new
    @ward = Ward.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ward }
    end
  end

  # GET /wards/1/edit
  def edit
    @ward = Ward.find(params[:id])
  end

  # POST /wards
  # POST /wards.json
  def create
    @ward = Ward.new(params[:ward])

    respond_to do |format|
      if @ward.save
        format.html { redirect_to @ward, notice: 'Ward was successfully created.' }
        format.json { render json: @ward, status: :created, location: @ward }
      else
        format.html { render action: "new" }
        format.json { render json: @ward.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /wards/1
  # PUT /wards/1.json
  def update
    @ward = Ward.find(params[:id])

    respond_to do |format|
      if @ward.update_attributes(params[:ward])
        format.html { redirect_to @ward, notice: 'Ward was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ward.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wards/1
  # DELETE /wards/1.json
  def destroy
    @ward = Ward.find(params[:id])
    @ward.destroy

    respond_to do |format|
      format.html { redirect_to wards_url }
      format.json { head :no_content }
    end
  end
end
