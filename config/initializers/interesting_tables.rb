interesting_tables = Module.new do 
  def interesting_tables
  	ActiveRecord::Base.connection.tables.sort.reject do |tbl|
			['schema_info'].include?(tbl)
		end
  end
end

ActiveRecord::Base.extend(interesting_tables)
