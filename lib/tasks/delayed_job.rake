desc %Q{Make sure that DJ is started to avoid chef}
task :ensure_dj_is_started => :environment do
  Delayed::Job.work_off(100000)
end 
