class AdminController < ApplicationController
  before_filter :require_citizen_effect_admin_or_partner_admin

  layout "admin"

protected
  def set_field_error_proc
    ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
      "<div class=\"fieldWithErrors\">#{html_tag}</div>"
    end
  end

  def send_as_xls(file_name = nil)
    file_name ||= controller_name

    response = DocRaptor.create(:name => file_name,
                                :document_content => render_to_string,
                                :document_type => "xls",
                                :test => ! Rails.env.production? )
    if response.code == 200
      send_data response, :filename => "#{file_name}.xls", :type => :xls
    else
      render :inline => response.body
    end

  end

end

