Given /^there is (a|an) ([^\"]*)$/ do |bogus, klass|
  var_name = klass.downcase.gsub(/\s/,'_')
  instance_variable_set "@recent_#{var_name}", Factory(var_name.to_sym)
end

# Given /^there is (a|an) ([^\"]*) named "([^\"]*)"$/ do |bogus, klass, name|
#   var_name = klass.downcase.gsub(/\s/,'_')
#   instance_variable_set "@recent_#{var_name}", create_object_with_name_using_factory(var_name, name)
# end

Given /^that ([^\"]*) has "([^\"]*)" set to "([^\"]*)"$/ do |klass, field_, value|
  var_ = instance_variable_get "@recent_#{klass.classify.gsub(/\s/,'_').downcase}"
  var_.send("#{field_}=", value)
  var_.save!
end

Given /^that ([^\"]*) belongs to the "([^\"]*)" ([^\"]*)$/ do |child_klass, parent_name, parent_klass|
  child = instance_variable_get "@recent_#{child_klass.classify.gsub(/\s/,'_').downcase}"
  parent = parent_klass.classify.constantize.find_by_name(parent_name)
  child.send("#{parent_klass.downsub}=", parent)
  child.save!
end

Given /^there are ([0-9]+) ([^\"]*) with name containing "([^\"]*)"$/ do |number, klass, name|
  var_name = klass.downcase.gsub(/\s/,'_').singularize
  number.to_i.times do |i|
    create_object_with_name_using_factory(var_name, "#{name} #{i}")
  end
end

Given /^there is (a|an) ([^\"]*) whose name contains "([^\"]*)"$/ do |bogus, klass, name|
  var_name = klass.downcase.gsub(/\s/,'_')
  instance_variable_set "@recent_#{var_name}", create_object_with_name_using_factory(var_name, "#{name} #{rand(500)}")
  
end

def create_object_with_name_using_factory(klass, name)
  Factory(klass.to_sym, :name => name )
end
