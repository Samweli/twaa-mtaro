class NeedHelpCategoriesController < ApplicationController
  # GET /need_help_categories
  # GET /need_help_categories.json
  def index
    @need_help_categories = NeedHelpCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @need_help_categories }
    end
  end

  # GET /need_help_categories/1
  # GET /need_help_categories/1.json
  def show
    @need_help_category = NeedHelpCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @need_help_category }
    end
  end

  # GET /need_help_categories/new
  # GET /need_help_categories/new.json
  def new
    @need_help_category = NeedHelpCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @need_help_category }
    end
  end

  # GET /need_help_categories/1/edit
  def edit
    @need_help_category = NeedHelpCategory.find(params[:id])
  end

  # POST /need_help_categories
  # POST /need_help_categories.json
  def create
    @need_help_category = NeedHelpCategory.new(params[:need_help_category])

    respond_to do |format|
      if @need_help_category.save
        format.html { redirect_to @need_help_category, notice: 'Need help category was successfully created.' }
        format.json { render json: @need_help_category, status: :created, location: @need_help_category }
      else
        format.html { render action: "new" }
        format.json { render json: @need_help_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /need_help_categories/1
  # PUT /need_help_categories/1.json
  def update
    @need_help_category = NeedHelpCategory.find(params[:id])

    respond_to do |format|
      if @need_help_category.update_attributes(params[:need_help_category])
        format.html { redirect_to @need_help_category, notice: 'Need help category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @need_help_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /need_help_categories/1
  # DELETE /need_help_categories/1.json
  def destroy
    @need_help_category = NeedHelpCategory.find(params[:id])
    @need_help_category.destroy

    respond_to do |format|
      format.html { redirect_to need_help_categories_url }
      format.json { head :no_content }
    end
  end
end
