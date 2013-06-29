class Admin::PartnerUserDetailsController < AdminController
  # GET /partner_user_details
  # GET /partner_user_details.xml
  def index
    @partner_user_details = PartnerUserDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @partner_user_details }
    end
  end

  # GET /partner_user_details/1
  # GET /partner_user_details/1.xml
  def show
    @partner_user_detail = PartnerUserDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @partner_user_detail }
    end
  end

  # GET /partner_user_details/new
  # GET /partner_user_details/new.xml
  def new
    @partner_user_detail = PartnerUserDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @partner_user_detail }
    end
  end

  # GET /partner_user_details/1/edit
  def edit
    @partner_user_detail = PartnerUserDetail.find(params[:id])
  end

  # POST /partner_user_details
  # POST /partner_user_details.xml
  def create
    @partner_user_detail = PartnerUserDetail.new(params[:partner_user_detail])

    respond_to do |format|
      if @partner_user_detail.save
        flash[:notice] = 'PartnerUserDetail was successfully created.'
        format.html { redirect_to([:admin, @partner_user_detail]) }
        format.xml  { render :xml => @partner_user_detail, :status => :created, :location => @partner_user_detail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @partner_user_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /partner_user_details/1
  # PUT /partner_user_details/1.xml
  def update
    @partner_user_detail = PartnerUserDetail.find(params[:id])

    respond_to do |format|
      if @partner_user_detail.update_attributes(params[:partner_user_detail])
        flash[:notice] = 'PartnerUserDetail was successfully updated.'
        format.html { redirect_to([:admin, @partner_user_detail]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @partner_user_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /partner_user_details/1
  # DELETE /partner_user_details/1.xml
  def destroy
    @partner_user_detail = PartnerUserDetail.find(params[:id])
    @partner_user_detail.destroy

    respond_to do |format|
      format.html { redirect_to(admin_partner_user_details_url) }
      format.xml  { head :ok }
    end
  end
end
