class Admin::ApprovableAssociationsController < AdminController
  before_filter :require_citizen_effect_admin

  # GET /approvable_associations
  # GET /approvable_associations.xml
  def index
    @approvable_associations = ApprovableAssociation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @approvable_associations }
    end
  end

  # GET /approvable_associations/1
  # GET /approvable_associations/1.xml
  def show
    @approvable_association = ApprovableAssociation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @approvable_association }
    end
  end

  # GET /approvable_associations/new
  # GET /approvable_associations/new.xml
  def new
    @approvable_association = ApprovableAssociation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @approvable_association }
    end
  end

  # GET /approvable_associations/1/edit
  def edit
    @approvable_association = ApprovableAssociation.find(params[:id])
  end

  # POST /approvable_associations
  def create
    @approvable_association = ApprovableAssociation.new(params[:approvable_association])

    # doing it this way because we want to throw away any params that come in that aren't relevant for the button that was actually pressed.  we could probably make it more elegant
    notice_msg = nil
    approval_attr = params[:approvable_association][:approval_attributes]

    case params[:commit]
    when "Deny"
      notice_msg = "Denial sent."
      @approvable_association.approval.andand.denied_reason = approval_attr[:denied_reason]
    when "Send Back to NGO"
      notice_msg = "Sent back to NGO"
      @approvable_association.approval.andand.whats_missing = approval_attr[:whats_missing]
    when "Approve Now"
      notice_msg = "Approval sent."
      @approvable_association.approval.andand.next_step = approval_attr[:next_step]
      unless approval_attr["due_on(1i)"].blank?
        @approvable_association.approval.andand.due_on = Date.civil(approval_attr[:"due_on(1i)"].to_i,approval_attr[:"due_on(2i)"].to_i,approval_attr[:"due_on(3i)"].to_i)
      end
    end

    if @approvable_association.save
      flash[:notice] = notice_msg
      if "CpApplication" == @approvable_association.approvable.class.name
        redirect_to([:admin, @approvable_association.approvable])
      else
        redirect_to([:admin, @approvable_association.approvable.project, @approvable_association.approvable])
      end
    else
      render :template => "admin/#{@approvable_association.approvable.andand.class.name.tableize}/show"
    end
  end

  # PUT /approvable_associations/1
  # PUT /approvable_associations/1.xml
  def update
    @approvable_association = ApprovableAssociation.find(params[:id])

    respond_to do |format|
      if @approvable_association.update_attributes(params[:approvable_association])
        flash[:notice] = 'ApprovableAssociation was successfully updated.'
        format.html { redirect_to([:admin, @approvable_association]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @approvable_association.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /approvable_associations/1
  # DELETE /approvable_associations/1.xml
  def destroy
    @approvable_association = ApprovableAssociation.find(params[:id])
    @approvable_association.destroy

    respond_to do |format|
      format.html { redirect_to(admin_approvable_associations_url) }
      format.xml  { head :ok }
    end
  end
end
