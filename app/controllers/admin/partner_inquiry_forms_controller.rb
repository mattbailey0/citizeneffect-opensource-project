class Admin::PartnerInquiryFormsController < AdminController
  # GET /partner_inquiry_forms
  # GET /partner_inquiry_forms.xml
  def index
    @partner_inquiry_forms = PartnerInquiryForm.all
    @partner_inquiry_forms_paginated = PartnerInquiryForm.all.paginate :page => params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @partner_inquiry_forms }
      format.xls { send_as_xls }
    end
  end
end

