class Admin::GeneralFormsController < AdminController
  # GET /general_forms
  # GET /general_forms.xml
  def index
    @general_forms = GeneralForm.all
    @general_forms_paginated = GeneralForm.all.paginate :page => params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @general_forms }
      format.xls { send_as_xls }
    end
  end
end

