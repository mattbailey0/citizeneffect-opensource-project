class Admin::BasicUserDetailsController < AdminController
  # GET /basic_user_details
  # GET /basic_user_details.xml
  def index
    @basic_user_details = BasicUserDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @basic_user_details }
    end
  end

  # GET /basic_user_details/1
  # GET /basic_user_details/1.xml
  def show
    @basic_user_detail = BasicUserDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @basic_user_detail }
    end
  end

  # GET /basic_user_details/new
  # GET /basic_user_details/new.xml
  def new
    @basic_user_detail = BasicUserDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @basic_user_detail }
    end
  end

  # GET /basic_user_details/1/edit
  def edit
    @basic_user_detail = BasicUserDetail.find(params[:id])
  end

  # POST /basic_user_details
  # POST /basic_user_details.xml
  def create
    @basic_user_detail = BasicUserDetail.new(params[:basic_user_detail])

    respond_to do |format|
      if @basic_user_detail.save
        flash[:notice] = 'BasicUserDetail was successfully created.'
        format.html { redirect_to([:admin, @basic_user_detail]) }
        format.xml  { render :xml => @basic_user_detail, :status => :created, :location => @basic_user_detail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @basic_user_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /basic_user_details/1
  # PUT /basic_user_details/1.xml
  def update
    @basic_user_detail = BasicUserDetail.find(params[:id])

    respond_to do |format|
      if @basic_user_detail.update_attributes(params[:basic_user_detail])
        flash[:notice] = 'BasicUserDetail was successfully updated.'
        format.html { redirect_to([:admin, @basic_user_detail]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @basic_user_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /basic_user_details/1
  # DELETE /basic_user_details/1.xml
  def destroy
    @basic_user_detail = BasicUserDetail.find(params[:id])
    @basic_user_detail.destroy

    respond_to do |format|
      format.html { redirect_to(admin_basic_user_details_url) }
      format.xml  { head :ok }
    end
  end
end
