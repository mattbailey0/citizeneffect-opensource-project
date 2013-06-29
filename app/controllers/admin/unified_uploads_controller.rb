class Admin::UnifiedUploadsController < AdminController
  before_filter :get_uploadable_and_association_name, :except => [:create, :update]
  before_filter :get_uploadable_and_association_name_from_form, :only => [:create, :update]
  
  def get_uploadable_and_association_name
    @uploadable = Object.const_get(params[:uploadable_type]).find(params[:uploadable_id])
    @association_name = params[:association_name]
  end
  
  def get_uploadable_and_association_name_from_form
    @uploadable = Object.const_get(params[:uploadable][:type]).find(params[:uploadable][:id])
    @association_name = params[:association_name][:value]
  end
  
  def index
    @unified_uploads = @uploadable.send(@association_name)
  end
  
  def show
    @unified_upload = @uploadable.send(@association_name).find(params[:id])
  end
  
  def new
    @unified_upload = @uploadable.send(@association_name).build
  end
  
  def edit
    @unified_upload = @uploadable.send(@association_name).find(params[:id])
  end
    
  def create
    @unified_upload = @uploadable.send(@association_name).build(params[:unified_upload])
    
    if @unified_upload.save
      flash[:notice] = 'File was successfully added.'
      redirect_to admin_unified_upload_path(@unified_upload, :uploadable_id => @uploadable.id, :uploadable_type => @uploadable.class, :association_name => @association_name)
    else
      render :action => "new"
    end
  end
  
  def update
    @unified_upload = @uploadable.send(@association_name).find(params[:id])
    
    if @unified_upload.update_attributes(params[:unified_upload])
      flash[:notice] = 'File was successfully updated.'
      redirect_to admin_unified_upload_path(@unified_upload, :uploadable_id => @uploadable.id, :uploadable_type => @uploadable.class, :association_name => @association_name)
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @unified_upload = @uploadable.send(@association_name).find(params[:id])
    @unified_upload.destroy
    flash[:notice] = 'File Removed'
    redirect_to admin_unified_uploads_path(:uploadable_id => @uploadable.id, :uploadable_type => @uploadable.class, :association_name => @association_name)
  end
end
