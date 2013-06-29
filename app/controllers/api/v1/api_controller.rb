class Api::V1::ApiController < ApplicationController
  def index
    respond_to do |format|
      format.json { render :json => {} }
      format.xml { render :xml => {} }
    end
  end
end
