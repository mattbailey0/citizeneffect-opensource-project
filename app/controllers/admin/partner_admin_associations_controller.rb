class Admin::PartnerAdminAssociationsController < AdminController
  
  before_filter :find_partner
  
  # GET /partner_admin_associations
  # GET /partner_admin_associations.xml
  def index
    @partner_admin_associations = @partner.partner_admin_associations

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @partner_admin_associations }
    end
  end

  # GET /partner_admin_associations/1
  # GET /partner_admin_associations/1.xml
  def show
    @partner_admin_association = @partner.partner_admin_associations.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @partner_admin_association }
    end
  end

  # GET /partner_admin_associations/new
  # GET /partner_admin_associations/new.xml
  def new
    @partner_admin_association = @partner.partner_admin_associations.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @partner_admin_association }
    end
  end

  # GET /partner_admin_associations/1/edit
  def edit
    @partner_admin_association = @partner.partner_admin_associations.find(params[:id])
  end

  # POST /partner_admin_associations
  # POST /partner_admin_associations.xml
  def create
    @partner_admin_association = @partner.partner_admin_associations.build(params[:partner_admin_association])

    
    respond_to do |format|
      if @partner_admin_association.save
        flash[:notice] = 'PartnerAdminAssociation was successfully created.'
        format.html { redirect_to([:admin, @partner, @partner_admin_association]) }
        format.xml  { render :xml => @partner_admin_association, :status => :created, :location => @partner_admin_association }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @partner_admin_association.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /partner_admin_associations/1
  # PUT /partner_admin_associations/1.xml
  def update
    @partner_admin_association = @partner.partner_admin_associations.find(params[:id])

    respond_to do |format|
      if @partner_admin_association.update_attributes(params[:partner_admin_association])
        flash[:notice] = 'PartnerAdminAssociation was successfully updated.'
        format.html { redirect_to([:admin, @partner, @partner_admin_association]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @partner_admin_association.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /partner_admin_associations/1
  # DELETE /partner_admin_associations/1.xml
  def destroy
    @partner_admin_association = @partner.partner_admin_associations.find(params[:id])
    @partner_admin_association.destroy

    respond_to do |format|
      format.html { redirect_to([:admin, @partner, :partner_admin_associations]) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def find_partner
    @partner = Partner.find(params[:partner_id])
  end
end
