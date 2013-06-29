class Admin::PartnerFocusAreaAssociationsController < AdminController
  
  before_filter :find_partner
  
  # GET /partner_focus_area_associations
  # GET /partner_focus_area_associations.xml
  def index
    @partner_focus_area_associations = @partner.partner_focus_area_associations

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @partner_focus_area_associations }
    end
  end

  # GET /partner_focus_area_associations/1
  # GET /partner_focus_area_associations/1.xml
  def show
    @partner_focus_area_association = @partner.partner_focus_area_associations.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @partner_focus_area_association }
    end
  end

  # GET /partner_focus_area_associations/new
  # GET /partner_focus_area_associations/new.xml
  def new
    @partner_focus_area_association = @partner.partner_focus_area_associations.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @partner_focus_area_association }
    end
  end

  # GET /partner_focus_area_associations/1/edit
  def edit
    @partner_focus_area_association = @partner.partner_focus_area_associations.find(params[:id])
  end

  # POST /partner_focus_area_associations
  # POST /partner_focus_area_associations.xml
  def create
    @partner_focus_area_association = @partner.partner_focus_area_associations.build(params[:partner_focus_area_association])

    respond_to do |format|
      if @partner_focus_area_association.save
        flash[:notice] = 'PartnerFocusAreaAssociation was successfully created.'
        format.html { redirect_to([:admin, @partner, @partner_focus_area_association]) }
        format.xml  { render :xml => @partner_focus_area_association, :status => :created, :location => @partner_focus_area_association }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @partner_focus_area_association.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /partner_focus_area_associations/1
  # PUT /partner_focus_area_associations/1.xml
  def update
    @partner_focus_area_association = @partner.partner_focus_area_associations.find(params[:id])

    respond_to do |format|
      if @partner_focus_area_association.update_attributes(params[:partner_focus_area_association])
        flash[:notice] = 'PartnerFocusAreaAssociation was successfully updated.'
        format.html { redirect_to([:admin, @partner, @partner_focus_area_association]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @partner_focus_area_association.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /partner_focus_area_associations/1
  # DELETE /partner_focus_area_associations/1.xml
  def destroy
    @partner_focus_area_association = @partner.partner_focus_area_associations.find(params[:id])
    @partner_focus_area_association.destroy

    respond_to do |format|
      format.html { redirect_to([:admin, @partner, :partner_focus_area_associations]) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def find_partner
    @partner = Partner.find(params[:partner_id])
  end
end
