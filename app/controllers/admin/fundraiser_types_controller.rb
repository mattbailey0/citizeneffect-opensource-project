class Admin::FundraiserTypesController < AdminController
  # GET /fundraiser_types
  # GET /fundraiser_types.xml
  def index
    @fundraiser_types = FundraiserType.all(:order=>"active DESC, name ASC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @fundraiser_types }
      format.xls { send_as_xls }
    end
  end

  # GET /fundraiser_types/1
  # GET /fundraiser_types/1.xml
  def show
    @fundraiser_type = FundraiserType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @fundraiser_type }
    end
  end

  # GET /fundraiser_types/new
  # GET /fundraiser_types/new.xml
  def new
    @fundraiser_type = FundraiserType.new
    @fundraiser_type.build_picture unless @fundraiser_type.picture

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @fundraiser_type }
    end
  end

  # GET /fundraiser_types/1/edit
  def edit
    @fundraiser_type = FundraiserType.find(params[:id])
    @fundraiser_type.build_picture unless @fundraiser_type.picture

  end

  # POST /fundraiser_types
  # POST /fundraiser_types.xml
  def create
    @fundraiser_type = FundraiserType.new(params[:fundraiser_type])
    @fundraiser_type.build_picture unless @fundraiser_type.picture

    respond_to do |format|
      if @fundraiser_type.save
        flash[:notice] = 'Fundraiser Type was successfully added.'
        format.html { redirect_to([:admin, @fundraiser_type]) }
        format.xml  { render :xml => @fundraiser_type, :status => :created, :location => @fundraiser_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @fundraiser_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /fundraiser_types/1
  # PUT /fundraiser_types/1.xml
  def update
    @fundraiser_type = FundraiserType.find(params[:id])
    @fundraiser_type.build_picture unless @fundraiser_type.picture

    respond_to do |format|
      if @fundraiser_type.update_attributes(params[:fundraiser_type])
        flash[:notice] = 'Fundraiser Type was successfully updated.'
        format.html { redirect_to([:admin, @fundraiser_type]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @fundraiser_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /fundraiser_types/1
  # DELETE /fundraiser_types/1.xml
  def destroy
    @fundraiser_type = FundraiserType.find(params[:id])
    @fundraiser_type.destroy
    flash[:notice] = 'Fundraiser Type was successfully removed.'
    respond_to do |format|
      format.html { redirect_to(admin_fundraiser_types_path) }
      format.xml  { head :ok }
    end
  end
end

