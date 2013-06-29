#!/usr/bin/env ruby
require "yaml"
require 'erb'
require 'zlib'

require RAILS_ROOT + "/lib/production_data_helpers.rb"
include ProductionDataHelpers

EMAIL_FILTER_EXCLUSIONS = [
                        
                          ]#.map {|s| "'#{s}'"} # wrap in single quotes to match sql

#                               |-| gobble escaped quotes so we don't end up removing the '\' that was escaping it
EMAIL_REGEXP = /[^ ']+@[^ ']+\.(\\'|[^ '])+/i

$LAST_GET_PRODUCTION_DATA_TIME_FILE = "#{RAILS_ROOT}/tmp/re_last_get_production_data_time.tmp"
$GET_PRODUCTION_DATA_EVERY = 60 * 60 * 12 # once every 12 hours

desc "grabs recent production data and loads it into your development db"
task :get_production_data do
  if $GET_PRODUCTION_DATA_EVERY < (last_time = Time.now.to_f - (File.open($LAST_GET_PRODUCTION_DATA_TIME_FILE) {|f| f.read} rescue "0").chomp.to_i)
#     system "STAGE='production' cap get_production_data" or fail "Error getting production data. #{$?.inspect}"
    system "cap production expectedbehavior:db:dump_to_local" or fail "Error getting production data. #{$?.inspect}"
    File.open($LAST_GET_PRODUCTION_DATA_TIME_FILE, "w") {|f| f.write(Time.now.to_f.to_s)}
  else
    puts
    puts "Got production data #{(last_time / 60).round} minutes ago (~#{(last_time / 60 / 60).round} hours), so we'll use it instead of getting fresh"
#     puts "run \"STAGE='production' cap get_production_data\" if you really need the good stuff"
    puts "run \"cap production expectedbehavior:db:dump_to_local\" if you really need the good stuff"
    puts
  end
end

desc "imports tmp/apple<whatever>.sql.gz into dev DB"
task :import_production_data do
  to_db_config = destination_db_config
  from_db_config = source_db_config
  
  db_file_path = newest_db_file_path(from_db_config)
  catter = case db_file_path
             when /\.gz$/  : "zcat"
             when /\.bz2$/ : "bzcat"
             else            "cat"
           end
  
  to_username = to_db_config[RAILS_ENV]['username']
  to_password = to_db_config[RAILS_ENV]['password']
  to_database = to_db_config[RAILS_ENV]['database']
  
  initialize_db
  
  puts "importing #{db_file_path}..."
  IO.popen("mysql -u #{to_username} -p'#{to_password}' #{to_database}", "w") do |mysql|
    filter_lines_and_apply!(`#{catter} #{db_file_path}`, from_db_config, to_db_config) { |line| mysql.write line }
  end
end

desc "convenience task for getting and importing production data"
task :get_and_import_production_data => ['get_production_data', 'import_production_data']


desc "reads the latest db dump, filters, and writes it to a file"
task :print_filtered_dump_to_file do
  new_file = ENV["FILE"]
  unless new_file
    puts "must provide FILE arg"
    exit 1
  end
  
  db_config = YAML.load(ERB.new(File.open(File.join(RAILS_ROOT, "config", "database.yml")) {|f| f.read}).result(binding))
  
  db_file_path = newest_db_file_path(db_config)
  
  puts "dumping #{db_file_path} to #{new_file}..."
  File.open(new_file, "w") do |file|
    filter_lines_and_apply!(`bzcat #{db_file_path}`, db_config) { |line| file.write line }
  end
end
