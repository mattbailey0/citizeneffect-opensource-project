module ContactManagement
  
  def import_contacts!(username, password, options = {})
    default_options = { 
      :service => :guess
    }
    options = options.dup.symbolize_keys
    options.reverse_merge!(default_options)

    contacts_to_import = []
    if options[:service] == :guess
      contacts_to_import = Contacts.guess(username, password)
    else
      begin
        contacts_to_import = Contacts::new(options[:service], username, password).contacts
      rescue Contacts::AuthenticationError
        self.errors.add_to_base("Invalid username/password combination")
      end
    end
    
    contacts_to_import.each do |contact|
      name  = contact[0]
      email = contact[1]
      self.imported_contacts << ImportedContact.new(:name => name, :email => email)
    end
  end
end
