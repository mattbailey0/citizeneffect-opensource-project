ActionController::Routing::Routes.draw do |map|
  map.resources :oauth_clients

  map.test_request '/oauth/test_request', :controller => 'oauth', :action => 'test_request'
  map.access_token '/oauth/access_token', :controller => 'oauth', :action => 'access_token'
  map.request_token '/oauth/request_token', :controller => 'oauth', :action => 'request_token'
  map.authorize '/oauth/authorize', :controller => 'oauth', :action => 'authorize'
  map.oauth '/oauth', :controller => 'oauth', :action => 'index'

  map.namespace :api do |api|
    api.namespace :v1 do |v1|
      v1.root :controller => :api, :action => :index
      v1.resources :projects, :only => [:index, :show], :collection => {:search => :get}
      v1.resources :project_events, :only => [:index]
      v1.resources :fundraiser_types, :only => [:index]
      v1.resources :featured_projects, :only => [:index]
      v1.resources :mailing_list_users, :only => [:create]
      v1.resources :general_forms, :only => [:create]
      v1.resources :donors, :only => [:index]
      v1.resources :donations, :only => [:create]   #, :index]  ##### add back in once ready
      v1.resources :users, :only => [:create, :index, :show]
      v1.resources :medias, :only => [:index]
      v1.resources :partners, :only => [:index, :show]
      v1.resources :campaigns, :only => [:index, :show], :has_many => [:projects, :partners]
    end
  end

  map.holiday_harvest_cards  'holidayharvest-cards', :controller => "home", :action => "holiday_harvest_cards"
  map.holiday_harvest_cards2 'HolidayHarvest-cards', :controller => "home", :action => "holiday_harvest_cards"
  map.holiday_harvest        'holidayharvest',       :controller => "home", :action => "holiday_harvest"
  map.holiday_harvest2       'HolidayHarvest',       :controller => "home", :action => "holiday_harvest"

  map.yoga4good '/yoga4good', :controller => 'home', :action => 'yoga4good'
  map.yoga_challenge '/yogachallenge', :controller => 'home', :action => 'yoga_challenge'
  map.yoga_challenge1 '/yogachallenge1', :controller => 'home', :action => 'yoga_challenge'
  map.yoga_challenge2 '/yogachallenge2', :controller => 'home', :action => 'yoga_challenge'
  map.yoga_challenge_studios '/yogachallenge/studios', :controller => 'home', :action => 'yoga_challenge_studios'
  map.yoga_challenge_about  '/yogachallenge/about', :controller => 'home', :action => 'yoga_challenge_about'
  map.yoga_donations '/yogachallenge/signup', :controller => 'donations', :action => 'new', :campaign_code => Donation::YOGA

  map.dc4dc '/dc4dc', :controller => 'home', :action => 'dc4dc'
  map.dc4dc_about '/dc4dc/about', :controller => 'home', :action => 'dc4dc_about'
  map.dc4dc_causes '/dc4dc/causes', :controller => 'home', :action => 'dc4dc_causes'
  map.dc4dc_join_us '/dc4dc/join_us', :controller => 'home', :action => 'dc4dc_join_us'
  map.dc4dc_participants '/dc4dc/participants', :controller => 'home', :action => 'dc4dc_participants'
  map.dc4dc_schwag '/dc4dc/schwag', :controller => 'home', :action => 'dc4dc_schwag'
  map.dc4dc_form '/dc4dc/form', :controller => 'home', :action => 'dc4dc_form'
  map.dc4dc_thankyou '/dc4dc/thankyou', :controller => 'home', :action => 'dc4dc_thankyou', :method => :post

  map.detroit "/detroit", :controller => 'home', :action => 'detroit'
  map.detroit4detroit '/detroit4detroit', :controller => 'home', :action => 'detroit4detroit'
  map.detroit4detroit_thankyou '/detroit4detroit/thankyou', :controller => 'home', :action => 'detroit4detroit_thankyou', :method => :post
  map.detroit4detroit_about '/detroit4detroit/about', :controller => 'home', :action => 'detroit4detroit_about'
  map.detroit4detroit_partners '/detroit4detroit/partners', :controller => 'home', :action => 'detroit4detroit_partners'
  map.detroit4detroit_partners_thankyou '/detroit4detroit/partners_thankyou', :controller => 'home', :action => 'detroit4detroit_partners_thankyou'

  map.tourney 'tourney', :controller => 'home', :action => 'tourney'
  map.tourney_more 'tourney/more', :controller => 'home', :action => 'tourney_more'
  map.tourney_office 'tourney/office', :controller => 'home', :action => 'bwb'
  map.tourney_donations 'tourney/donations/new', :controller => 'home', :action => 'bwb'
  map.bwb 'bracketswithbenefits', :controller => 'home', :action => 'bwb'
  map.bwb2 'BracketsWithBenefits', :controller => 'home', :action => 'bwb'
  map.bwb3 '/projects/brackets-with-benefits-2011', :controller => 'home', :action => 'bwb'

  map.japan "Japan", :controller => 'home', :action => 'japan'
  map.japan2 "japan", :controller => 'home', :action => 'japan'
  map.japan3 '/projects/japan', :controller => 'home', :action => 'japan'
  map.japan4 '/projects/Japan', :controller => 'home', :action => 'japan'

  map.resources :media_album_medias
  map.resources :fundraiser_types, :collection => { :find_your_perfect_fundraiser => :get, :most_successful => :get, :most_popular => :get }
  map.resources :cp_applications
  map.resources :donations

  map.namespace :admin do |admin|
    admin.resources :unified_uploads
    admin.resources :fundraiser_types, :has_many => [:fundraiser_type_experiences]
    admin.resources :subscribers
    admin.resources :all_users
    admin.resources :general_forms
    admin.resources :partner_inquiry_forms
    admin.resources :network_impacts, :member => { :recalculate => :get }
    admin.resources :approvable_associations
    admin.resources :cp_applications, :has_many => [:cp_application_approval_association]
    admin.resources :featured_projects, :member => { :move_higher => :put, :move_lower => :put}
    admin.resources :regular_pages
    admin.resources :project_events
    admin.all_donations 'all_donations', :controller => :donations, :action => :index
    admin.resources :donations, :except => [:show], :has_many => [:refunds]
    admin.resources :refunds, :except => [:index]
    admin.resources :community_member_audios
    admin.resources :community_member_videos
    admin.resources :community_member_pictures
    admin.resources :currency_types
    admin.resources :community_member_messages
    admin.resources :community_member_profiles, :has_many => [:community_member_messages, :community_member_pictures, :community_member_videos, :community_member_audios]
    admin.resources :partner_coordinator_associations
    admin.resources :project_type_associations
    admin.resources :project_types
    admin.resources :project_focus_area_associations
    admin.project_management 'project_management', :controller => :project_management, :action => :index

    admin.resources :projects do |project|
      project.resources :media_albums, :has_many => [:media_album_photos, :media_album_videos]
    end

    admin.resources :projects, :has_many => [:project_type_associations, :project_focus_area_associations, :community_member_profiles, :project_pictures, :project_videos, :project_audios, :donations, :partner_project_status_updates, :partner_project_impact_reports, :partner_project_final_reports, :partner_project_progress_reports], :member => { :partner_view => :get, :clone => :put }
    admin.resources :partner_focus_area_associations
    admin.resources :focus_areas
    admin.resources :campaigns
    admin.resources :partner_country_associations
    admin.resources :countries
    admin.resources :partners, :has_many => [:partner_admin_associations, :partner_country_associations, :partner_focus_area_associations]
    admin.resources :partner_admin_associations
    admin.resources :basic_user_details
    admin.resources :partner_user_details
    admin.resources :roles, :has_many => [:user_role_associations]

    admin.resources :users, :member => {
      :change_password => [:get, :put],
      :activate => :put
    }

    admin.root :controller => "projects"
  end

  map.project_status_update '/projects/:project_id/status_updates/:id', :controller => 'partner_project_status_updates', :action => "show"
  map.project_impact_report '/projects/:project_id/impact_reports/:id', :controller => 'partner_project_impact_reports', :action => "show"
  map.project_final_report '/projects/:project_id/final_reports/:id', :controller => 'partner_project_final_reports', :action => "show"
  map.project_progress_report '/projects/:project_id/progress_reports/:id', :controller => 'partner_project_progress_reports', :action => "show"
  map.resources :projects, :collection => { :search => :get, :needing_donations => :get, :needing_a_cp => :get, :carousel => :get }, :member => { :news_items => :get, :events => :get, :donors => :get, :snapfish_card => :get } do |projects|
    projects.resources :donations
    projects.resources :offline_donations
    projects.resources :cp_applications
    projects.resources :media_albums, :member => { :sort => :post }
    projects.resources :project_events, :member => { :share => :get }
    projects.resources :featured_media_associations, :collection => { :sort => :post }
  end

  map.resources :project_events, :has_many => [:event_attendance_responses, :project_event_invitation_emails]

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.forgot_password '/forgot_password', :controller => 'users', :action => 'forgot_password'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.facebook_callback '/users/facebook_callback', :controller => 'users', :action => 'facebook_callback'

  map.how_it_works 'how_it_works', :controller => 'home', :action => 'how_it_works'
  #map.media 'media', :controller => 'home', :action => 'media'
  map.about_us 'about_us', :controller => 'home', :action => 'about_us'
  map.contact_us 'contact_us', :controller => 'home', :action => 'contact_us'
  map.terms_of_service 'terms_of_service', :controller => 'home', :action => 'terms_of_service'

  map.resources :users,  :member => {
    :link_to_twitter  => :get,
    :twitter_callback => :get,
    :link_to_facebook => :get,
    :link_to_myspace  => :get,
    :myspace_callback => :get,
    :message          => :get,
    :push_status      => :post,
    :generate_api_key => :put
  }

  map.new_from_import_imported_contact "/imported_contacts/new_from_import", :controller => "imported_contacts", :action => "new_from_import"
  map.share_imported_contacts "/imported_contacts/share", :controller => "imported_contacts", :action => "share"
  map.import_imported_contacts "/imported_contacts/import", :controller => "imported_contacts", :action => "import", :method => :post
  map.resources :imported_contacts, :collection => { :new_invite => [:get, :post] }
  map.invite_imported_contacts "/imported_contacts/invite", :controller => "imported_contacts", :action => "invite", :method => :post

  map.resources :users, :member => {
    :active_projects            => :get,
    :active_projects_news_items => :get,
    :show_projects              => :get,
    :show_donations             => :get,
    :projects_news_items        => :get,
    :cps_supported              => :get,
    :projects_donated_to        => :get } do |users|
    users.resources :messages
    users.resources :watched_project_associations
  end

  map.resources :mailing_lists, :has_many => {:mailing_list_users => {:member => {:unsubscribe => :get}}, :mailing_list_emails => {}}
  map.resources :mailing_list_users, {:member => {:unsubscribe => :get}, :collection => { :thanks => :get }}

  map.resource :session

  map.home_news_items "/home/news_items", :controller => "home", :action => "news_items"
  map.home_top_cps "/home/top_cps", :controller => "home", :action => "top_cps"
  map.home_top_networkers "/home/top_networkers", :controller => "home", :action => "top_networkers"
  map.home_index "/index", :controller => "home", :action => "index"

  map.search "/search", :controller => "home", :action => "search"

  map.regular_pages_public '/p/:permalink', :controller => 'regular_pages', :action => 'regular_page_public'



  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "home"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

  map.bonusround_donations '/secret_bonus_round/donate', :controller => 'donations', :action => 'new'

end

