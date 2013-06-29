class Admin::PartnerCountryAssociationsController < AdminController
  
  before_filter :find_partner
  
  # GET /partner_country_associations
  # GET /partner_country_associations.xml
  def index
    @partner_country_associations = @partner.partner_country_associations

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @partner_country_associations }
    end
  end

  # GET /partner_country_associations/1
  # GET /partner_country_associations/1.xml
  def show
    @partner_country_association = @partner.partner_country_associations.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @partner_country_association }
    end
  end

  # GET /partner_country_associations/new
  # GET /partner_country_associations/new.xml
  def new
    @partner_country_association = @partner.partner_country_associations.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @partner_country_association }
    end
  end

  # GET /partner_country_associations/1/edit
  def edit
    @partner_country_association = @partner.partner_country_associations.find(params[:id])
  end

  # POST /partner_country_associations
  # POST /partner_country_associations.xml
  def create
    @partner_country_association = @partner.partner_country_associations.build(params[:partner_country_association])

    respond_to do |format|
      if @partner_country_association.save
        flash[:notice] = 'PartnerCountryAssociation was successfully created.'
        format.html { redirect_to([:admin, @partner, @partner_country_association]) }
        format.xml  { render :xml => @partner_country_association, :status => :created, :location => @partner_country_association }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @partner_country_association.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /partner_country_associations/1
  # PUT /partner_country_associations/1.xml
  def update
    @partner_country_association = @partner.partner_country_associations.find(params[:id])

    respond_to do |format|
      if @partner_country_association.update_attributes(params[:partner_country_association])
        flash[:notice] = 'PartnerCountryAssociation was successfully updated.'
        format.html { redirect_to([:admin, @partner, @partner_country_association]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @partner_country_association.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /partner_country_associations/1
  # DELETE /partner_country_associations/1.xml
  def destroy
    @partner_country_association = @partner.partner_country_associations.find(params[:id])
    @partner_country_association.destroy

    respond_to do |format|
      format.html { redirect_to([:admin, @partner, :partner_country_associations]) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def find_partner
    @partner = Partner.find(params[:partner_id])
  end
end
