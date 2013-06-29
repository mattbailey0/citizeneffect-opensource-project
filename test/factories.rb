def mod(a, b)
  (a % b) rescue 0
end

Factory.define(:project) do |p|
  p.sequence(:name) { |n| "Project #{n}" }
  p.partner { Factory.create(:partner) }
  p.priority Project::HIGH_PRIORITY
  p.sequence(:primary_lives_impacted) { |n| 100 * (n+1) }
  p.sequence(:total_cost_in_us_cents) { |n| 10000 * (n+1) }
  p.sequence(:summary_for_website) { |n| "summary #{n} for website that has a fair amount of text in it so we can see what it looks like when it gets truncated at some point" }
  p.sequence(:community_name) { |n| "community name #{n}" }
  p.sequence(:country) { |n| Country.find_by_id(mod(n,Country.count)+1) }
  p.community_leader "A Leader"
  p.district_coordinator "A Coordinator"
  p.justification_for_project "Sooooooo justified"
  p.what_will_be_done "Everything and nothing ..... at the same time !!?!?!??!??!??"
  p.primary_objective "To objectify"
  p.desired_construction_start_date Time.now
  p.community_population 100
  p.community_state "A Place Somewhere"
  p.secondary_lives_impacted 20
  p.local_currency_type_id 1
  p.total_cost_in_local_currency 1000
  p.district_name "District 9"
  p.how_will_it_be_done "Very poorly"
end

Factory.define(:project_with_basic_data, :parent => :project) do |p|
  p.project_status { ProjectStatus.draft }
  p.approved_by_citizen_effect_at nil
end

Factory.define(:project_with_reports, :parent => :project) do |p|
  p.cp { Factory.create("cp") }
  p.after_create do |o|
    o.project_reports =
      [
       Factory.create(:partner_project_status_update, :project => o, :user => o.cp),
       Factory.create(:partner_project_impact_report, :project => o, :user => o.cp),
       Factory.create(:partner_project_final_report, :project => o, :user => o.cp),
       Factory.create(:partner_project_progress_report, :project => o, :user => o.cp)
      ]
    o.community_member_profiles = [Factory.build(:community_member_profile, :project => o)]
  end
end

Factory.define(:community_member_profile) do |cmp|
  cmp.project { Factory.create(:project) }
  cmp.sequence(:name) { |n| "Community Member Profile #{n}" }
  cmp.title "Title"
  cmp.biography "Biography"
  cmp.profile_picture { UnifiedUpload.new(:content => File.open("#{RAILS_ROOT}/public/images/people_jane_j.jpg")) }
  cmp.after_create do |o|
    o.messages = [Factory.build(:community_member_message)]
    o.videos = [Factory.build(:community_member_video)]
    o.pictures = [Factory.build(:community_member_picture)]
#     o.audios = [Factory.build(:community_member_audio)]
  end
end

Factory.define(:community_member_message) do |cmm|
  cmm.sequence(:content) { |n| "Message #{n}" }
end

Factory.define(:community_member_video) do |cmv|
  cmv.sequence(:caption) { |n| "Video Caption #{n}" }
  cmv.url "http://www.youtube.com/watch?v=uad17d5hR5s"
end

Factory.define(:community_member_picture) do |cmp|
  cmp.sequence(:caption) { |n| "Picture Caption #{n}" }
  cmp.picture { Factory.create("unified_upload") }
end

Factory.define(:community_member_audio) do |cma|
  cma.sequence(:caption) { |n| "Audio Caption #{n}" }
  cma.audio { Factory.create("unified_upload", :content => File.open("#{RAILS_ROOT}/features/upload-files/imPlenty.wav")) }
end

Factory.define(:country) do |c|
  c.sequence(:name) { |n| "Country #{n}" }
end

Factory.define(:news_item) do |ni|
  ni.news_item_type NewsItem::NEWS_ITEM_TYPES.first
  ni.sequence(:news_message) { |n| "news feed item #{n}" }
end

Factory.define(:partner) do |partner|
  partner.display_name "SEWA"
  partner.sequence(:permalink) { |n| "permalink#{n}" }
end

Factory.define :unactivated_user, :class => User do |u|
  u.sequence(:email) { |n| "unactivated_email#{n}@example.com" }
  u.password "password"
  u.password_confirmation "password"
  u.zip "46268"
  u.skype_username "skypey"
  u.phone_number "555-0123"
end

Factory.define(:user) do |u|
  u.sequence(:email) { |n| "email#{n}@example.com" }
  u.first_name { "John" }
  u.last_name { "Doe" }
  u.password "password"
  u.password_confirmation "password"
  u.zip "46268"
  u.activated_at 1.day.ago
  u.state "active"
  u.state_name "Indiana"
  u.state_code "IN"
  u.city_name "Indianapolis"
  u.skype_username "skypeybearsharkpigdogflower"
  u.phone_number "555-555-0123"
  User::FOLLOW_URL_TYPES.each do |type|
    u.sequence("#{type}_path") { |n| "#{type}-url-#{n}" }
  end
  u.picture { UnifiedUpload.new(:content => File.open("#{RAILS_ROOT}/public/images/people_jane_j.jpg")) }
end

Factory.define(:quentin, :parent => :user) do |u|
  u.first_name "Quentin"
  u.last_name "Davies"
  u.email "quentin@example.com"
  u.password "monkey"
  u.password_confirmation "monkey"
  u.remember_token_expires_at 1.day.from_now
  u.remember_token "77de68daecd823babbb58edb1c8e14d7106e83bb"
  u.activated_at 5.days.ago
  u.state "active"
end

Factory.define("partner_admin", :parent => :user) do |u|
  u.roles { [Role.find_by_name("partner_admin")]}
end

Factory.define("partner_admin_association") do |u|
  u.user    { Factory.create("basic_user") }
  u.partner { Factory.create("partner")    }
end

Factory.define("citizen_effect_admin", :parent => :user) do |u|
  u.roles { [Role.find_by_name("citizen_effect_admin")] }
end

Factory.define("basic_user", :parent => :user) do |u|
  u.roles { [Role.find_by_name("basic_user")] }
end

Factory.define("cp", :parent => :user) do |u|
  u.roles { [Role.find_by_name("cp")] }
  u.picture { UnifiedUpload.new(:content => File.open("#{RAILS_ROOT}/public/images/temp_thumb_02.jpg")) }
end

Factory.define(:cp_application) do |cpa|
  cpa.user { Factory.create("basic_user", :picture => UnifiedUpload.new(:content =>
  File.open("#{RAILS_ROOT}/public/images/temp_thumb_02.jpg"))) }
  cpa.comment "Test Comment"
  cpa.after_build do |o|
    o.address1 = "Test Address"
    o.phone_number = "8881232345"
  end
end

Factory.define(:approval) do |a|
end

Factory.define("approval_approved", :parent => :approval) do |a|
  a.next_step "It is approved"
end

Factory.define("approval_denied", :parent => :approval) do |a|
  a.denied_reason "It is denied"
end

Factory.define("approval_needs_more_information", :parent => :approval) do |a|
  a.whats_missing "Stuff is missing"
end

Factory.define("approved_cp_application", :parent => :cp_application) do |cpa|
  cpa.approval { Factory.create("approval_approved") }
  cpa.after_build do |o|
    o.address1 = "Test Address"
    o.phone_number = "8881232345"
  end
end

Factory.define("denied_cp_application", :parent => :cp_application) do |cpa|
  cpa.approval { Factory.create("approval_denied") }
  cpa.after_build do |o|
    o.address1 = "Test Address"
    o.phone_number = "8881232345"
  end
end

Factory.define(:fundraiser_tag) do |t|
  t.sequence(:name) { |n| "tag#{n}" }
end

Factory.define(:fundraiser_type) do |ft|
  ft.sequence(:name) { |n| "fundraiser_type#{n}" }
  ft.difficulty { FundraiserType::DIFFICULTIES.sort_by{ rand }.slice(0..0) }
  ft.sequence(:minimum_typical_amount_raised_in_cents) { |n| (10 * n)*100 }
  ft.sequence(:maximum_typical_amount_raised_in_cents) { |n| (15 * n)*100 }
  ft.description("I am an awesome fundraiser type!!")
  ft.picture { Factory.create("unified_upload", :flavor => "FundraiserType_picture") }
end

Factory.define(:fundraiser_type_experience) do |fte|
  fte.user { Factory.create(:user) }
  fte.fundraiser_type { Factory.create(:fundraiser_type) }
  fte.quote("This was really really awesome!!")
end

Factory.define(:featured_project) do |fp|
  fp.sequence(:title) { |n| "Featured Project #{n}" }
  fp.sequence(:caption) { |n| "caption for featured project #{n}" }
  fp.picture { Factory.create("unified_upload", :flavor => "FeaturedProject_picture") }
  fp.sequence(:url_identifier) { |n| "http://www.example.com/#{n}" }
  fp.picture_thumbnail { Factory.create("unified_upload", :content => File.open("#{RAILS_ROOT}/public/images/rails_thumb.png"),:flavor => "FeaturedProject_picture_thumbnail") }
end

Factory.define("featured_project_ashvin", :parent => :featured_project) do |fp|
  fp.title "Zejari Village, India"
  fp.caption "Ashvin is a 9 year old boy living in poverty because his family's farm is failing."
  fp.picture { Factory.create("unified_upload", :content => File.open("#{RAILS_ROOT}/public/images/fp_ashvin.jpg"), :flavor => "FeaturedProject_picture") }
  fp.picture_thumbnail { Factory.create("unified_upload", :content => File.open("#{RAILS_ROOT}/public/images/fp_ashvin_thumb.jpg"), :flavor => "FeaturedProject_picture_thumbnail") }
end

Factory.define("featured_project_sedla", :parent => :featured_project) do |fp|
  fp.title "Sedla, Gujarat, India - Success Story"
  fp.caption "25 Sedla farming families now have easy and immediate access to irrigation water."
  fp.picture { Factory.create("unified_upload", :content => File.open("#{RAILS_ROOT}/public/images/fp_sedla_check_dam.png"), :flavor => "FeaturedProject_picture") }
  fp.picture_thumbnail { Factory.create("unified_upload", :content => File.open("#{RAILS_ROOT}/public/images/fp_sedla_check_dam_thumb.png"), :flavor => "FeaturedProject_picture_thumbnail") }
end

Factory.define("unified_upload") do |uf|
  uf.content File.open("#{RAILS_ROOT}/public/images/rails.png")
  uf.flavor "stub_awesomelaser" #STUB - How do you do this in a reasonable way?
end

Factory.define(:project_event) do |pe|
  pe.project { Factory.create(:project) }
  pe.sequence(:host) { |n| "event host #{n}" }
  pe.sequence(:name) { |n| "event name #{n}" }
  pe.sequence(:short_description) { |n| "event short description #{n}" }
  pe.sequence(:long_description) { |n| "event long description #{n}" }
  pe.sequence(:event_start_time) { |n| 1.hour.ago + ((n - 1) * 15).hours }
  pe.sequence(:event_end_time) { |n| 1.hour.from_now + ((n - 1) * 15).hours }
  pe.address1 "1234 someplace way"
  pe.city "Indianapolis"
  pe.state "IN"
  pe.zip "46268"
  pe.country "US"
  pe.fundraiser_type { Factory.create(:fundraiser_type) }
end

Factory.define(:donation) do |d|
  d.sequence(:amount_in_cents) { |n| 100 * (n+1) }
  d.first_name "First Name"
  d.last_name "Last Name"
  d.address1 "Address 1"
  d.city "City"
  d.state "State"
  d.country "Country"
  d.zip "11223"
  d.email "first@example.com"
  d.tip_percentage 0
  d.agree_tos "1"
  d.after_create do |o|
    unless o.offline
      o.send(:generate_order_id)
      o.send(:set_actual_amount)
      o.authorization_code = "whee" 
      o.save!
    end

  end
end

Factory.define(:imported_contact) do |c|
  c.sequence(:email) { |n| "an#{n}@email.com" }
  c.name "This is a name"
end

Factory.define(:blog) do |b|
  b.sequence(:title) { |n| "blog title #{n}" }
  b.sequence(:subtitle) { |n| "blog subtitle #{n}" }
  b.sequence(:url_identifier) { |n| "blog-url-#{n}" }
end

Factory.define(:blog_post) do |bp|
  bp.sequence(:title) { |n| "blog post title #{n}" }
  bp.sequence(:excerpt) { |n| "blog post excerpt #{n}" }
  bp.sequence(:body) { |n| "blog post body #{n}" }
  bp.sequence(:url_identifier) { |n| "blog-post-url-#{n}" }
  bp.sequence(:category) { |n| BlogCategory.find(mod(n, BlogCategory.count) + 1) }
  bp.is_complete true
  bp.posted_by { Factory.create(:user) }
  bp.blog { Factory.create(:blog) }
end

Factory.define(:partner_project_impact_report) do |r|
  r.project { Factory.create(:project) }
  r.lives_directly_impacted(10)
  r.lives_indirectly_impacted(12)
  r.primary_benefits_summary("Summary 1")
  r.extended_benefits_summary("Summary 2")
  r.education_and_nutrition("Nutritious!")
  r.improved_health("Healthy!")
  r.agriculture_and_food("Foody!")
  r.clean_energy("Energetic!")
  r.productive_time_created("Lots!")
  r.number_of_jobs_created(20)
  r.job_breakdown("All mine!")
  r.wages_increased("To 0!")
  r.small_businesses_created(222)
  r.business_breakdown("Wheee!")
  r.other("Other stuff")
  r.community_changed_summary("It has changed")
  r.approval { Factory.create("approval_denied") }
end

Factory.define(:partner_project_final_report) do |r|
  r.project { Factory.create(:project) }
  r.start_date Time.now
  r.expected_completion_date Time.now + 10.years
  r.what_has_been_purchased "Stuff to make the other stuff"
  r.construction_job_breakdown "People to build things"        
  r.number_of_construction_jobs_created 22
  r.completion_summary "Whee completion"
  r.local_currency_type_id 1
  r.final_cost_in_local_currency 100000
  r.final_cost_in_usd 2
  r.lives_directly_impacted 3
  r.lives_indirectly_impacted 4          
  r.primary_benefits_summary "Many primary"        
  r.extended_benefits_summary "Extended action"
  r.education_and_nutrition "Woo education"
  r.improved_health "So healthy!"
  r.agriculture_and_food "Food food food"       
  r.clean_energy "Very clean"
  r.productive_time_created  "lots"
  r.number_of_jobs_created 1     
  r.job_breakdown "breakdown"           
  r.wages_increased "upward"           
  r.small_businesses_created 5
  r.business_breakdown "break it down!"         
  r.other "More other stuff" 
  r.approval { Factory.create("approval_approved") }
end

Factory.define(:partner_project_progress_report) do |r|
  r.project { Factory.create(:project) }
  r.start_date Time.now
  r.expected_completion_date Time.now + 10.years
  r.what_has_been_constructed "Some stuff"
  r.what_has_been_purchased "Stuff to make the other stuff"
  r.construction_job_breakdown "People to build things"        
  r.number_of_construction_jobs_created 22
  r.lives_directly_impacted 3
  r.lives_indirectly_impacted 4          
  r.primary_benefits_summary "Many primary"        
  r.extended_benefits_summary "Extended action"
  r.approval { Factory.create(:approval) }
end

Factory.define(:partner_project_status_update) do |r|
  r.sequence(:title) { |n| "Status Report Title #{n}" }
  r.field_updates "Some updates from the field"
  r.project { Factory.create(:project) }
end

Factory.define(:media_album_video) do |v|
  v.sequence(:title){ |n| "The #{n} video!" }
  v.url "http://www.youtube.com/watch?v=edaJP3Lp0Gg&feature=fvst"
end

Factory.define(:media_album_photo) do |p|
  p.sequence(:title){ |n| "The #{n} photo!" }
  p.photo File.open("#{RAILS_ROOT}/public/images/people_jane_j.jpg")
end

Factory.define(:media_album) do |a|
  a.sequence(:title){ |n| "My #{n} album!" }
  a.user { Factory.create(:cp) }
  a.after_create do |o|
    5.times do
      o.medias << Factory.create(:media_album_photo)
      o.medias << Factory.create(:media_album_video)
    end
    o.album_cover = o.medias.first
  end
end

Factory.define(:focus_area) do |fa|
  fa.sequence(:name) {|n| "focus area #{n}"}
end

Factory.define(:referral_source) do |rs|
  rs.sequence(:name) {|n| "Referral Source #{n}"}
end

Factory.define(:currency_type) do |ct|
  ct.sequence(:currency_code) { |n| "CT#{n}"}
end

Factory.define(:mailing_list) do |ml|
  ml.created_at { Time.now }
end
