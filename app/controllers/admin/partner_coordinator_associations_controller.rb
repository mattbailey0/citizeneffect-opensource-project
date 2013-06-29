class Admin::PartnerCoordinatorAssociationsController < AdminController
  # GET /partner_coordinator_associations
  # GET /partner_coordinator_associations.xml
  def index
    @partner_coordinator_associations = PartnerCoordinatorAssociation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @partner_coordinator_associations }
    end
  end

  # GET /partner_coordinator_associations/1
  # GET /partner_coordinator_associations/1.xml
  def show
    @partner_coordinator_association = PartnerCoordinatorAssociation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @partner_coordinator_association }
    end
  end

  # GET /partner_coordinator_associations/new
  # GET /partner_coordinator_associations/new.xml
  def new
    @partner_coordinator_association = PartnerCoordinatorAssociation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @partner_coordinator_association }
    end
  end

  # GET /partner_coordinator_associations/1/edit
  def edit
    @partner_coordinator_association = PartnerCoordinatorAssociation.find(params[:id])
  end

  # POST /partner_coordinator_associations
  # POST /partner_coordinator_associations.xml
  def create
    @partner_coordinator_association = PartnerCoordinatorAssociation.new(params[:partner_coordinator_association])

    respond_to do |format|
      if @partner_coordinator_association.save
        flash[:notice] = 'PartnerCoordinatorAssociation was successfully created.'
        format.html { redirect_to([:admin, @partner_coordinator_association]) }
        format.xml  { render :xml => @partner_coordinator_association, :status => :created, :location => @partner_coordinator_association }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @partner_coordinator_association.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /partner_coordinator_associations/1
  # PUT /partner_coordinator_associations/1.xml
  def update
    @partner_coordinator_association = PartnerCoordinatorAssociation.find(params[:id])

    respond_to do |format|
      if @partner_coordinator_association.update_attributes(params[:partner_coordinator_association])
        flash[:notice] = 'PartnerCoordinatorAssociation was successfully updated.'
        format.html { redirect_to([:admin, @partner_coordinator_association]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @partner_coordinator_association.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /partner_coordinator_associations/1
  # DELETE /partner_coordinator_associations/1.xml
  def destroy
    @partner_coordinator_association = PartnerCoordinatorAssociation.find(params[:id])
    @partner_coordinator_association.destroy

    respond_to do |format|
      format.html { redirect_to(admin_partner_coordinator_associations_url) }
      format.xml  { head :ok }
    end
  end
end
