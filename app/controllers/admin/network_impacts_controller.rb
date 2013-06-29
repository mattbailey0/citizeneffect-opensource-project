class Admin::NetworkImpactsController < AdminController
  # GET /all_donations
  # GET /all_donations.xml
  def index
    @network_impacts = NetworkImpact.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @network_impacts }
      format.xls { send_as_xls }
    end
  end
  
  def edit
    @network_impact = NetworkImpact.find(params[:id])
  end
  
  def update
    @network_impact = NetworkImpact.find(params[:id])
    
    respond_to do |format|
      if @network_impact.update_attributes(params[:network_impact])
        flash[:notice] = 'Network Impact was successfully updated.'
        format.html { redirect_to(admin_network_impacts_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @network_impact.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def recalculate
    @network_impact = NetworkImpact.find(params[:id])
    
    respond_to do |format|
      if @network_impact.automatically_calculate_stats
        flash[:notice] = 'Network Impact was successfully recalculated.'
        format.html { redirect_to(admin_network_impacts_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @network_impact.errors, :status => :unprocessable_entity }
      end
    end
  end
end
