require 'digest/md5'
module BloggityRequiredMethods
#   def self.included(klass)
#     klass.extend ClassMethods
#   end
  
  def display_name
    if self.last_name == "Admin"
      "#{self.first_name} #{self.last_name}"
    elsif self.last_name.blank?
       self.first_name
    else
      "#{self.first_name} #{self.last_name.andand.slice(0,1)}."
    end
  end
  alias :user_name :display_name
  
  # Whether a user can post to a given blog
  # Implement in your user model
  def can_blog?(blog_id = nil)
    blog_id = blog_id.to_i
    return true if self.is_a_citizen_effect_admin?
    return false unless self.is_a_cp?
    self.projects.map(&:blog).map(&:id).include?(blog_id)
  end
  
  # Whether a user can moderate the comments for a given blog
  def can_moderate_blog_comments?(blog_id = nil)
    blog_id = blog_id.to_i
    return true if self.is_a_citizen_effect_admin?
    return false unless self.is_a_cp?
    self.projects.map(&:blog).map(&:id).include?(blog_id)
  end
  
  # Whether the comments that a user makes within a given blog are automatically approved (as opposed to being queued until a moderator approves them)
  def blog_comment_auto_approved?(blog_id = nil)
    true
  end
  
  # Whether a user has access to create, edit and destroy blogs
  def can_modify_blogs?
    false
  end
  
  # Based on the fact that current_user is nil if you aren't logged in, the model will always be true
  def logged_in?
    true
  end
  
  # The path to your user's avatar.  Here we have sample code to fall back on a gravatar, if that's your bag.
  # Implement in your user model 
  def blog_avatar_url
    #downcased_email_address = self.email.downcase
    #hash = Digest::MD5.hexdigest(downcased_email_address)
    #"http://www.gravatar.com/avatar/#{hash}"
    self.picture_url_thumb
  end
end
