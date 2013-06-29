module CommonNamedScopes
  
  def self.included(klass)
    (1..15).each { |n| klass.named_scope "top_#{n}", :limit => n }
    klass.named_scope :random, :order => "RAND()"
  end

end
