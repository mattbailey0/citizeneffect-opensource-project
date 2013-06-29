class ImportedContactsController < ApplicationController
  ssl_required :new_from_import, :import
  
  filter_parameter_logging :contact_import_password
  before_filter :login_required

  def index
    @imported_contacts = current_user.imported_contacts
  end

  def new
    @imported_contact = current_user.imported_contacts.new
  end
  
  def new_from_import
 #       @imported_contact = ImportedContact.new
#    @imported_contact = current_user.imported_contacts.new
  end
  
  def import
    username = params[:contact_import_username]
    password = params[:contact_import_password]
    service  = params[:contact_service]
    imported_contacts = current_user.import_contacts!(username, password, :service => service)
    if current_user.errors.size > 0
      flash[:error] = current_user.errors.full_messages
      redirect_to new_from_import_imported_contact_url
    else
      flash[:notice] = "#{imported_contacts.size} Contact(s) Imported."
      redirect_to [:imported_contacts]
    end 
  end
  
  def new_invite
    @imported_contact_ids = params[:invited_contact_ids].blank? ? [] : params[:invited_contact_ids]
  end
  
  def share
  end
  
  def invite
    params[:email] ||= {}
    subject            = params[:email][:subject].blank? ? "You're invited to Citizen Effect" : params[:email][:subject]
    email_content      = params[:email][:mail_contents].blank? ? "Come make a difference through Citizen Effect!" : params[:email][:mail_contents]
    
    params[:email][:imported_contact_ids].andand.reject!(&:blank?)
    
    contacts_to_invite = []
    contacts_to_invite = ImportedContact.find(params[:email][:imported_contact_ids]) if params[:email][:imported_contact_ids]
    
    contacts_to_invite.each do |ic|
      ic.send_invite_email(:subject => subject, :personal_content => email_content)
    end
    
    if contacts_to_invite.size < 1
      flash[:error] = "No contacts were selected to invite."
    else
      flash[:notice] = "#{contacts_to_invite.size} contact(s) invited to Citizen Effect"      
    end 
    
    redirect_to [:imported_contacts]
  end
  
  def create
    @imported_contact = current_user.imported_contacts.build(params[:imported_contact])
    
    if @imported_contact.save
      flash[:notice] = "Contact Added"
      if params[:invite_contact]
        redirect_to(new_invite_imported_contacts_path(:invited_contact_ids => [@imported_contact.id]))
      else
        redirect_to(imported_contacts_path)
      end
    else
      render :action => "new"
    end
  end
  
  def destroy
    @imported_contact = current_user.imported_contacts.find(params[:id])
    ic_email = @imported_contact.email
    @imported_contact.destroy
    
    flash[:notice] = "Contact '#{CGI.escapeHTML ic_email}' removed"
    redirect_to(imported_contacts_path)
  end
end
