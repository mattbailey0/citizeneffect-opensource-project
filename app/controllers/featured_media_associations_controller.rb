class FeaturedMediaAssociationsController < ApplicationController
  
  before_filter :find_project
  before_filter :require_cp_for_project
  
  # GET /featured_media_associations
  def index
    @featured_media_associations = @project.featured_media_associations.all
  end

  # POST /featured_media_associations
  def create
    @featured_media_association = @project.featured_media_associations.build(params[:featured_media_association])

    if @featured_media_association.save
      flash[:notice] = 'Featured Media was successfully created.'
    else
      flash[:error]  = 'Failed to save featured media.'
    end
    
    redirect_to [@project, :featured_media_associations] 
  end

  # PUT /featured_media_associations/1
  def update
    @featured_media_association = @project.featured_media_associations.find(params[:id])

    if @featured_media_association.update_attributes(params[:featured_media_association])
      flash[:notice] = 'Featured Media was successfully updated.'
    else
      flash[:error]  = 'Failed to save featured media.'
    end
    
    redirect_to [@project, :featured_media_associations]
  end
  
  def sort
    @featured_media_associations = @project.featured_media_associations.all
    @featured_media_associations.each do |fma|
      fma.position = params['featured_media_associations'].index(fma.id.to_s) + 1
      fma.save
    end
    
    render :nothing => true
  end

  # DELETE /featured_media_associations/1
  def destroy
    @featured_media_association = @project.featured_media_associations.find(params[:id])
    @featured_media_association.destroy

    flash[:notice] = 'Featured Media was successfully removed.'
    redirect_to [@project, :featured_media_associations]
  end
  
  private
  
  def find_project
    @project = Project.find(params[:project_id])
  end
  
end
