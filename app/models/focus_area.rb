class FocusArea < ActiveRecord::Base
  named_scope :alphabetical, :order => "name"
  
  ICON_CSS = { 
    1 => "food",
    2 => "water",
    3 => "education",
    4 => "wind",
    5 => "medical"
  }
  
  def icon_css_class
    ICON_CSS[self.id] || "water"
  end
  
  def icon_file
    "icon_#{self.icon_css_class}.gif"
  end
end
