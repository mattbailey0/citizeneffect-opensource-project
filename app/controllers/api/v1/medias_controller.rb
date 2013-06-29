#class MediaItemTempHash < Struct.new(:id, :url, :title, :description, :type)
#  def valid?; true; end
#end

class Api::V1::MediasController < ApplicationController
  before_filter :login_required

  # GET /project_media.xml
  # GET /project_media.json
  def index
    @project = Project.find_by_id(params[:project_id])
    respond_to do |format|
      if params[:project_id].blank?
        format.json { render :json => { :error => "No Project ID provided" }, :status => 400 }
        format.xml { render :xml => "<error>No Project ID provided</error>", :status => 400 }
      elsif @project.blank?
        format.json { render :json => { :error => "Project with ID #{params[:project_id]} Not Found" }, :status => 404 }
        format.xml { render :xml => "<error>Project with ID #{params[:project_id]} Not Found</error>", :status => 404 }
      else
        @media = []
        @project.videos.each do |media|
          @media << Struct.new(:id, :url, :title, :description, :type, :project_id).new(media.id, media.url, media.title, media.description, 'video', @project.id)
        end
        @project.photos_including_primary_photo.each do |media|
          @media << Struct.new(:id, :url, :title, :description, :type, :project_id).new(media.id, media.url, media.title, media.description, 'photo', @project.id)
        end
        format.json { render :action => 'index' }
        format.xml  { render :action => "index" }
      end
    end
  end
end

