namespace :expectedbehavior do
  namespace :db do
    desc "Backup your MySQL database to shared_path+/db_backups with one insert on a line"
    task :dump_with_many_inserts, :roles => :db, :only => {:primary => true} do
      top.db.backup_name
      run("cat #{shared_path}/config/database.yml") { |channel, stream, data| @environment_info = YAML.load(data)[rails_env] }
      if @environment_info['adapter'] == 'mysql'
        dbhost = @environment_info['host']
        # this breaks ey flex
#         dbhost = environment_dbhost.sub('-master', '') + '-replica' if dbhost != 'localhost' # added for Solo offering, which uses localhost
        run "mysqldump --skip-extended-insert --add-drop-table -u #{dbuser} -h #{dbhost} -p #{environment_database} | bzip2 -c > #{backup_file}.bz2" do |ch, stream, out |
          ch.send_data "#{dbpass}\n" if out=~ /^Enter password:/
        end
      else 
        puts "OMGZ not mysql"
      end
    end

    desc "Sync your production database to your local workstation"
    task :dump_to_local, :roles => :db, :only => {:primary => true} do
      top.db.backup_name
      dump_with_many_inserts
      get "#{backup_file}.bz2", "tmp/#{File.basename(backup_file)}.bz2" # "/tmp/#{application}.sql.gz"
    end 

    
    desc "Clone Production Database to Staging Database."
    task :clone_prod_to_staging_with_filtering, :roles => :db, :only => { :primary => true } do

      # This task currently runs only on traditional EY offerings.
      # You need to have both a production and staging environment defined in 
      # your deploy.rb file.  

      top.db.backup_name
      #     our_backup_file = "#{current_path}/tmp/#{File.basename(backup_file)}.bz2"
      filtered_file = "#{current_path}/tmp/#{File.basename(backup_file)}-filtered.sql"
      
      on_rollback { run "rm -f #{backup_file}" }
      run("cat #{shared_path}/config/database.yml") { |channel, stream, data| @environment_info = YAML.load(data)[rails_env] }  

      if @environment_info['adapter'] == 'mysql'
        dbhost = @environment_info['host']
        dbhost = environment_dbhost.sub('-master', '') + '-replica' if dbhost != 'localhost' # added for Solo offering, which uses localhost
        run "mysqldump --skip-extended-insert --add-drop-table -u #{dbuser} -h #{dbhost} -p #{environment_database} | bzip2 -c > #{backup_file}.bz2" do |ch, stream, out |
          ch.send_data "#{dbpass}\n" if out=~ /^Enter password:/
        end
        run "cd #{current_path} && rake print_filtered_dump_to_file DB_BACKUP_FILE='#{backup_file}.bz2' FILE='#{filtered_file}'"
        #       puts "cat #{filtered_file} | mysql -u #{dbuser} -p -h #{staging_dbhost} #{staging_database}"
        run "cat #{filtered_file} | mysql -u #{dbuser} -p -h #{staging_dbhost} #{staging_database}" do |ch, stream, out|
          ch.send_data "#{dbpass}\n" if out=~ /^Enter password:/
        end
      else
        puts "OMGZ not mysql"
      end
      #     run "rm -f #{backup_file}"
    end
  end
end
