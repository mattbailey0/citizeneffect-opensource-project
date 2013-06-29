namespace :s3 do
  desc "copy all the files in one s3 bucket to another bucket under the same account using FROM and TO bucket names"
  task :copy do
    
    require 'rubygems'
    require 'right_aws'
    require 'aws/s3'
    
    config = YAML.load_file(File.join(RAILS_ROOT, "config", "amazon_s3.yml"))[RAILS_ENV]
    aws_access_key_id = config["access_key_id"]
    aws_secret_access_key = config["secret_access_key"]
    target_bucket = ENV["FROM"]
    destination_bucket = ENV["TO"]

    AWS::S3::Base.establish_connection!(
                                        :access_key_id     => aws_access_key_id,
                                        :secret_access_key => aws_secret_access_key
                                        )

    s3 = RightAws::S3Interface.new(aws_access_key_id, aws_secret_access_key)

    copied_keys = Array.new
    s3.incrementally_list_bucket(destination_bucket) do |key_set| 
      copied_keys << key_set[:contents].map{|k| k[:key]}.flatten 
    end
    copied_keys.flatten!

    s3.incrementally_list_bucket(target_bucket) do |key_set|
      key_set[:contents].each do |key|
        key = key[:key]
        if copied_keys.include?(key)
          puts "#{destination_bucket} #{key} already exists. Skipping..."
        else
          puts "Copying #{target_bucket} #{key}"

          retries=0
          begin
            s3.copy(target_bucket, key, destination_bucket)
            
            # make it public read
            object = AWS::S3::S3Object.find key, destination_bucket
            object.acl.grants << AWS::S3::ACL::Grant.grant(:public_read)
            object.acl(object.acl)
          rescue Interrupt
            puts "Interrupt detected, exiting."
            exit 1
          rescue Exception => e
            puts "cannot copy key, #{e.inspect}\nretrying #{retries} out of 10 times..."
            retries += 1
            retry if retries <= 10
          end
        end
      end
    end 
    
  end
end
