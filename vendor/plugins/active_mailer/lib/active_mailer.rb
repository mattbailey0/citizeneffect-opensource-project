module ActiveMailer #:nodoc:
  class Base < ActiveRecord::Base
    self.abstract_class = true
    
    has_many    :email_user_associations, :as => :emailable
    has_many    :recipients, :through => :email_user_associations, :source => "email_user"
    belongs_to  :sender, :class_name => "EmailUser", :foreign_key => "sender_id"
    attr_accessor :body     # leave this as an accessor for now since it's complicated
    attr_accessor :rendered_contents # contains the actual sent email after `send!` is called
    
    validates_presence_of :sender
    validates_length_of   :subject,    :minimum => 1
    
    validate :must_have_at_least_one_recipient_of_some_kind
    
    def must_have_at_least_one_recipient_of_some_kind
      if self.recipients.blank? and self.cc.blank? and self.bcc.blank?
        self.errors.add_to_base("You have to have at least one recipient in the to, cc, or bcc fields")
      end
    end
    
    cattr_accessor :before_send_actions
    cattr_accessor :after_send_actions

    alias :ar_sender= :sender=
    def sender=(email)
      if email.is_a?(String)
        self.ar_sender = EmailUser.find_or_create_by_email_address(email)
      else
        self.ar_sender = email
      end 
    end

    alias :ar_recipients= :recipients=
    def recipients=(emails)
      emails = [emails] unless emails.is_a?(Array)
      self.ar_recipients = emails.map! do |email|
        if email.is_a?(String)
          EmailUser.find_or_create_by_email_address(email)
        else
          email
        end
      end 
    end
    
    def render(*args)
      ActionMailer::Base.send(:new).send(:render, *args)
    end


    before_save :do_before_send
    after_save  :do_after_send
    
    def do_before_send
      self.before_send_actions.each do |m|
        self.send(m)
      end unless self.before_send_actions.blank?
    end

    def do_after_send
      self.after_send_actions.each do |m|
        self.send(m)
      end unless self.after_send_actions.blank?
    end
    
    def self.before_send(action)
      self.before_send_actions ||= []
      self.before_send_actions << action
    end

    def self.after_send(action)
      self.after_send_actions ||= []
      self.after_send_actions << action
    end

#     cattr_accessor :delegate_to_action_mailer
#     def self.delegate_to_action_mailer(variable_name)
#       self.delegate_to_action_mailer ||= []
#       self.delegate_to_action_mailer << variable_name
#       self.delegate_to_action_mailer.flatten!
#       create_delegator
#     end
    
    
    cattr_accessor :template_variables
    def self.template_variable(variable_name)
      debugger
      self.template_variables ||= []
      self.template_variables << variable_name
      self.template_variables.flatten!
      attr_accessor variable_name
    end
        
    def mailer_variables
      mvars = {}

      vars_to_include = self.class.read_mailer_variables + self.class.content_columns.map(&:name) + self.class.reflect_on_all_associations.map(&:name)
      
      vars_to_include.each do |var|
        mvars[var] = self.send(var.to_sym)
      end
            
      # TODO: this should be less ghetto
      mvars[:from] = self.sender.email_address unless mvars[:from]
      mvars[:recipients] = self.recipients.map(&:email_address) unless mvars[:recipients].all? {|r| r.is_a? String }
      
      mvars
    end
    
    # All the mailer methods will be defined on this ActionMailer class
    class DefaultActionMailer < ActionMailer::Base
#       def self.create_method(name, &block) # syntactically convenient
#         self.send(:define_method, name, &block)
#       end      
    end
        
    def send! # should take false to avoid validations i.e. sending it again
      if self.save!
        logger.info "sending email to #{self.recipients.join(", ")}"
        self.class.define_action_mailer_method
        sent_mail = DefaultActionMailer.send("deliver_#{self.class.default_email_method_name}".to_sym, self.mailer_variables)
        self.rendered_contents = sent_mail.body # in case someone wants to save it
        logger.info "email #{self.class.default_email_method_name} sent to #{self.recipients.map(&:email_address).join(", ")} from #{self.sender.email_address}"
        self.update_attribute("sent_at", Time.now)
      end
    end
    
    def self.mailer_variable(*variable_name)
      write_inheritable_attribute(:mailer_variable, Set.new(variable_name.map(&:to_s)) + (read_mailer_variables || []))
      attr_accessor *variable_name
    end

    def self.read_mailer_variables
      read_inheritable_attribute(:mailer_variable)
    end
    mailer_variable :template
    mailer_variable :bcc
    mailer_variable :cc
    mailer_variable :body
    mailer_variable :content_type
    mailer_variable :attachments

    
    
    class << self # Class methods
      def define_action_mailer_method
        method_name = default_email_method_name
        return true if DefaultActionMailer.respond_to?(method_name)

        DefaultActionMailer.instance_eval do
          define_method(method_name) do |*args|
            options = args[0]
            attachments_to_set = (options[:attachments] || [])
            options.keys.each do |k|
              self.instance_eval("@#{k.to_s} = options[k]") if options[k]
#              instance_variable_set(k.to_s, options[k])
            end
            
            attachments_to_set.each do |att|              
              attachment(
                         :content_type => (att[:content_type]  || att.content_type), 
                         :body         => File.read(att[:path] || att.path), 
                         :filename    => (att[:file_name]     || att.file_name)
                         )
            end
          end
        end
      end
      
      def default_email_method_name
        "#{self.name.underscore}"
      end
      
    end
  end
end
