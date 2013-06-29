desc %Q{make a default image for unified uploads using IMAGE and FLAVOR. example: default_image FLAVOR="video_thumb" IMAGE="~/Downloads/cute-sad-kitten06.jpg"}
task :make_default_image => :environment do
  orig_path = File.expand_path ENV["IMAGE"]
  ext = File.extname orig_path
  new_path = File.join(RAILS_ROOT, "tmp", "image.#{ext}") # using image.ext will match up with the default_url specified on UnifiedUpload
  FileUtils.cp orig_path, new_path
  
  UnifiedUpload.transaction do
    uu = UnifiedUpload.new(:flavor => ENV["FLAVOR"], :content => File.open(new_path))
    uu.save
    
    default_uu = UnifiedUpload.new(:flavor => ENV["FLAVOR"])
    
    UnifiedUpload::IMAGE_SIZES.keys.each do |size_name|
      default_image_path = File.join(RAILS_ROOT, "public") + default_uu.url(size_name)
      FileUtils.mkdir_p File.dirname(default_image_path)
      FileUtils.cp uu.path(size_name), default_image_path
    end
    
    raise ActiveRecord::Rollback # we don't actually want to change the DB
  end
end

desc "Reprocess images"
task :reprocess_images => :environment do
  # TODO: should figure out how to recalculate default images as well.
  # perhaps store the large sources for them in some somewhere like public/default_image_sources/<flavor>/<image_name>
  # then iterating over them.  Will this result in them being on S3?  Is that ok?  I don't think this will reprocess s3 images.
  
  errors = []
  UnifiedUpload.all.each do |uu|
    begin
      uu.update_attributes!(:content => File.open(uu.content.path(:original)))
    rescue Exception => e
      errors << [uu.id, e.message]
    end
  end
  if errors.empty?
    puts "processed successfully"
  else
    require 'pp'
    puts "ERROR: Errors occurred while processing.  Everything that could be processed was, but the following exceptions were raised:"
    pp errors
  end
end
