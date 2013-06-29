# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120802162124) do

  create_table "achievements", :force => true do |t|
    t.integer  "achievement_type"
    t.integer  "reference_amount"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "approvable_associations", :force => true do |t|
    t.integer  "approvable_id"
    t.string   "approvable_type"
    t.integer  "approval_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "approvals", :force => true do |t|
    t.string   "whats_missing"
    t.datetime "sent_back_at"
    t.string   "next_step"
    t.date     "due_on"
    t.datetime "approved_at"
    t.text     "denied_reason"
    t.datetime "denied_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "basic_user_details", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "zip"
    t.string   "phone_number"
    t.string   "skype_username"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_assets", :force => true do |t|
    t.integer "blog_post_id"
    t.integer "parent_id"
    t.string  "content_type"
    t.string  "filename"
    t.string  "thumbnail"
    t.integer "size"
    t.integer "width"
    t.integer "height"
  end

  create_table "blog_categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "blog_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_categories", ["blog_id"], :name => "index_blog_categories_on_blog_id"
  add_index "blog_categories", ["parent_id"], :name => "index_blog_categories_on_parent_id"

  create_table "blog_comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "blog_post_id"
    t.text     "comment"
    t.boolean  "approved"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_comments", ["blog_post_id"], :name => "index_blog_comments_on_blog_post_id"

  create_table "blog_posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "tag_string"
    t.integer  "posted_by_id"
    t.boolean  "is_complete"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url_identifier"
    t.boolean  "comments_closed"
    t.integer  "category_id"
    t.integer  "blog_id",         :default => 1
    t.boolean  "fck_created"
    t.text     "excerpt"
  end

  add_index "blog_posts", ["blog_id"], :name => "index_blog_posts_on_blog_id"
  add_index "blog_posts", ["category_id"], :name => "index_blog_posts_on_category_id"
  add_index "blog_posts", ["url_identifier"], :name => "index_blog_posts_on_url_identifier"

  create_table "blog_tags", :force => true do |t|
    t.string   "name"
    t.integer  "blog_post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_tags", ["blog_post_id"], :name => "index_blog_tags_on_blog_post_id"

  create_table "blogs", :force => true do |t|
    t.string   "title"
    t.string   "subtitle"
    t.string   "url_identifier"
    t.string   "stylesheet"
    t.string   "feedburner_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  add_index "blogs", ["url_identifier"], :name => "index_blogs_on_url_identifier"

  create_table "campaigns", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "permalink"
    t.string   "logo_url"
  end

  create_table "client_applications", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "support_url"
    t.string   "callback_url"
    t.string   "key",          :limit => 20
    t.string   "secret",       :limit => 40
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_applications", ["key"], :name => "index_client_applications_on_key", :unique => true

  create_table "community_member_audios", :force => true do |t|
    t.integer  "community_member_profile_id"
    t.string   "caption"
    t.integer  "project_report_id"
    t.string   "project_report_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "community_member_messages", :force => true do |t|
    t.integer  "community_member_profile_id"
    t.string   "content"
    t.integer  "project_report_id"
    t.string   "project_report_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "community_member_pictures", :force => true do |t|
    t.integer  "community_member_profile_id"
    t.string   "caption"
    t.integer  "project_report_id"
    t.string   "project_report_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "community_member_profiles", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.string   "title"
    t.text     "biography"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "community_member_videos", :force => true do |t|
    t.integer  "community_member_profile_id"
    t.string   "caption"
    t.string   "url"
    t.integer  "project_report_id"
    t.string   "project_report_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cp_application_approved_emails", :force => true do |t|
    t.integer  "sender_id"
    t.datetime "sent_at"
    t.string   "subject"
    t.integer  "cp_application_id"
    t.text     "rendered_email_contents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cp_application_country_associations", :force => true do |t|
    t.integer  "cp_application_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cp_application_denied_emails", :force => true do |t|
    t.integer  "sender_id"
    t.datetime "sent_at"
    t.string   "subject"
    t.integer  "cp_application_id"
    t.text     "rendered_email_contents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cp_application_focus_area_associations", :force => true do |t|
    t.integer  "cp_application_id"
    t.integer  "focus_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cp_application_fundraising_goal_range_associations", :force => true do |t|
    t.integer  "cp_application_id"
    t.integer  "fundraising_goal_range_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cp_application_lives_impacted_range_associations", :force => true do |t|
    t.integer  "cp_application_id"
    t.integer  "lives_impacted_range_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cp_application_submitted_emails", :force => true do |t|
    t.integer  "sender_id"
    t.datetime "sent_at"
    t.string   "subject"
    t.integer  "cp_application_id"
    t.text     "rendered_email_contents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cp_applications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "referrer_id"
    t.integer  "referral_source_id"
  end

  create_table "cp_donation_made_emails", :force => true do |t|
    t.integer  "sender_id"
    t.datetime "sent_at"
    t.string   "subject"
    t.integer  "donation_id"
    t.text     "rendered_email_contents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "currency_types", :force => true do |t|
    t.string   "currency_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.string   "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "donation_receipt_emails", :force => true do |t|
    t.integer  "sender_id"
    t.datetime "sent_at"
    t.string   "subject"
    t.integer  "donation_id"
    t.text     "rendered_email_contents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "donations", :force => true do |t|
    t.integer  "donor_id"
    t.integer  "project_id"
    t.integer  "amount_in_cents"
    t.integer  "donation_attribution_id"
    t.datetime "donated_at"
    t.datetime "receipt_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "email"
    t.string   "phone_number"
    t.integer  "tip_percentage",                                            :default => 0
    t.boolean  "mailing_list",                                              :default => true
    t.boolean  "anonymous",                                                 :default => false
    t.string   "order_id"
    t.string   "authorization_code"
    t.integer  "actual_amount_in_cents"
    t.boolean  "offline",                                                   :default => false
    t.boolean  "field_partner_emails",                                      :default => true
    t.string   "country"
    t.string   "campaign_code"
    t.integer  "project_amount_in_cents",                                   :default => 0
    t.integer  "refunds_total_in_cents"
    t.integer  "net_project_amount_in_cents"
    t.integer  "net_amount_in_cents"
    t.integer  "net_actual_amount_in_cents"
    t.integer  "fee_amount_in_cents"
    t.decimal  "fee_percentage",              :precision => 3, :scale => 2
    t.integer  "revised_tip_percentage"
  end

  create_table "email_user_associations", :force => true do |t|
    t.integer  "email_user_id"
    t.string   "emailable_type"
    t.integer  "emailable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_users", :force => true do |t|
    t.string   "email_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_attendance_responses", :force => true do |t|
    t.integer  "imported_contact_id"
    t.integer  "user_id"
    t.integer  "project_event_id"
    t.integer  "project_event_invitation_email_id"
    t.string   "attendance_code"
    t.string   "email"
    t.integer  "response"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "external_text_columns", :force => true do |t|
    t.string   "column_owner_type"
    t.integer  "column_owner_id"
    t.string   "flavor"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "featured_media_associations", :force => true do |t|
    t.integer  "project_id"
    t.integer  "position"
    t.integer  "featured_media_id"
    t.string   "featured_media_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "featured_projects", :force => true do |t|
    t.string   "title"
    t.string   "caption"
    t.string   "url_identifier"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "focus_areas", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fundraiser_tag_associations", :force => true do |t|
    t.integer  "fundraiser_tag_id"
    t.integer  "fundraiser_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fundraiser_tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fundraiser_type_experiences", :force => true do |t|
    t.integer  "fundraiser_type_id"
    t.integer  "user_id"
    t.text     "quote"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fundraiser_types", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "minimum_typical_amount_raised_in_cents"
    t.integer  "maximum_typical_amount_raised_in_cents"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "difficulty"
    t.boolean  "active"
  end

  create_table "fundraising_goal_ranges", :force => true do |t|
    t.string   "display_name"
    t.integer  "min_value"
    t.integer  "max_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "general_form_emails", :force => true do |t|
    t.integer  "sender_id"
    t.datetime "sent_at"
    t.string   "subject"
    t.integer  "general_form_id"
    t.text     "rendered_email_contents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "general_forms", :force => true do |t|
    t.string   "source"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "location"
    t.string   "location_other"
    t.string   "cause"
    t.string   "referred_by"
    t.string   "campaign_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "comment"
    t.string   "request"
  end

  add_index "general_forms", ["created_at"], :name => "index_general_forms_on_created_at"
  add_index "general_forms", ["email"], :name => "index_general_forms_on_email"
  add_index "general_forms", ["last_name"], :name => "index_general_forms_on_last_name"

  create_table "imported_contact_emails", :force => true do |t|
    t.integer  "sender_id"
    t.datetime "sent_at"
    t.string   "subject"
    t.integer  "referrer_id"
    t.integer  "imported_contact_id"
    t.text     "rendered_email_contents"
    t.text     "personal_content"
    t.string   "referral_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "imported_contacts", :force => true do |t|
    t.integer  "referrer_id"
    t.integer  "user_id"
    t.string   "name"
    t.string   "email"
    t.string   "referral_code"
    t.boolean  "recruited",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lives_impacted_ranges", :force => true do |t|
    t.string   "display_name"
    t.integer  "min_value"
    t.integer  "max_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mailing_list_emails", :force => true do |t|
    t.integer  "mailing_list_id"
    t.integer  "sender_id"
    t.text     "mail_contents"
    t.string   "subject"
    t.string   "bcc"
    t.boolean  "draft",           :default => true
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mailing_list_sent_emails", :force => true do |t|
    t.integer  "sender_id"
    t.datetime "sent_at"
    t.string   "subject"
    t.integer  "mailing_list_email_id"
    t.text     "rendered_email_contents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mailing_list_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "mailing_list_id"
    t.string   "zip"
    t.string   "email"
    t.string   "unsubscribe_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "tracking_code"
  end

  create_table "mailing_lists", :force => true do |t|
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_album_displayers", :force => true do |t|
    t.integer  "media_album_id"
    t.integer  "displayer_id"
    t.string   "displayer_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_album_medias", :force => true do |t|
    t.integer  "media_album_id"
    t.integer  "position"
    t.integer  "media_id"
    t.string   "media_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_album_photos", :force => true do |t|
    t.string   "title",       :default => ""
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_album_videos", :force => true do |t|
    t.string   "title",       :default => ""
    t.text     "description"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_albums", :force => true do |t|
    t.string   "title"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "album_cover_id"
    t.integer  "user_id"
  end

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.boolean  "sender_deleted",    :default => false
    t.boolean  "recipient_deleted", :default => false
    t.string   "subject"
    t.text     "body"
    t.datetime "read_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "network_impacts", :force => true do |t|
    t.boolean  "use_on_homepage",               :default => false
    t.boolean  "automatically_calculated",      :default => false
    t.integer  "total_lives_impacted",          :default => 0
    t.integer  "total_unique_donors",           :default => 0
    t.integer  "total_citizen_philanthropists", :default => 0
    t.integer  "total_dollars_donated",         :default => 0
    t.integer  "total_completed_projects",      :default => 0
    t.integer  "total_projects_in_progress",    :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "new_cp_application_emails", :force => true do |t|
    t.integer  "sender_id"
    t.datetime "sent_at"
    t.string   "subject"
    t.integer  "cp_application_id"
    t.text     "rendered_email_contents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news_items", :force => true do |t|
    t.string   "newsable_type"
    t.integer  "newsable_id"
    t.string   "news_item_type"
    t.text     "news_message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oauth_nonces", :force => true do |t|
    t.string   "nonce"
    t.integer  "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_nonces", ["nonce", "timestamp"], :name => "index_oauth_nonces_on_nonce_and_timestamp", :unique => true

  create_table "oauth_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "type",                  :limit => 20
    t.integer  "client_application_id"
    t.string   "token",                 :limit => 20
    t.string   "secret",                :limit => 40
    t.string   "callback_url"
    t.string   "verifier",              :limit => 20
    t.datetime "authorized_at"
    t.datetime "invalidated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_tokens", ["token"], :name => "index_oauth_tokens_on_token", :unique => true

  create_table "partner_admin_associations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "partner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partner_campaign_associations", :force => true do |t|
    t.integer  "partner_id"
    t.integer  "campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partner_coordinator_associations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partner_country_associations", :force => true do |t|
    t.integer  "country_id"
    t.integer  "partner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partner_focus_area_associations", :force => true do |t|
    t.integer  "focus_area_id"
    t.integer  "partner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partner_inquiry_emails", :force => true do |t|
    t.integer  "sender_id"
    t.datetime "sent_at"
    t.string   "subject"
    t.integer  "partner_inquiry_form_id"
    t.text     "rendered_email_contents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partner_inquiry_forms", :force => true do |t|
    t.string   "source"
    t.string   "submitter_name"
    t.string   "submitter_email"
    t.string   "organization"
    t.string   "organization_phone_number"
    t.string   "organization_website"
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "partner_inquiry_forms", ["created_at"], :name => "index_partner_inquiry_forms_on_created_at"
  add_index "partner_inquiry_forms", ["organization"], :name => "index_partner_inquiry_forms_on_organization"
  add_index "partner_inquiry_forms", ["source"], :name => "index_partner_inquiry_forms_on_source"
  add_index "partner_inquiry_forms", ["submitter_email"], :name => "index_partner_inquiry_forms_on_submitter_email"
  add_index "partner_inquiry_forms", ["submitter_name"], :name => "index_partner_inquiry_forms_on_submitter_name"

  create_table "partner_project_final_reports", :force => true do |t|
    t.integer  "user_id"
    t.integer  "media_album_id"
    t.date     "start_date"
    t.date     "expected_completion_date"
    t.text     "what_has_been_purchased"
    t.text     "construction_job_breakdown"
    t.integer  "number_of_construction_jobs_created"
    t.text     "completion_summary"
    t.integer  "local_currency_type_id"
    t.integer  "final_cost_in_local_currency"
    t.integer  "final_cost_in_usd"
    t.integer  "lives_directly_impacted"
    t.integer  "lives_indirectly_impacted"
    t.text     "primary_benefits_summary"
    t.text     "extended_benefits_summary"
    t.text     "education_and_nutrition"
    t.text     "improved_health"
    t.text     "agriculture_and_food"
    t.text     "clean_energy"
    t.text     "productive_time_created"
    t.integer  "number_of_jobs_created"
    t.text     "job_breakdown"
    t.text     "wages_increased"
    t.integer  "small_businesses_created"
    t.text     "business_breakdown"
    t.text     "other"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partner_project_impact_reports", :force => true do |t|
    t.integer  "user_id"
    t.integer  "media_album_id"
    t.integer  "lives_directly_impacted"
    t.integer  "lives_indirectly_impacted"
    t.text     "primary_benefits_summary"
    t.text     "extended_benefits_summary"
    t.text     "education_and_nutrition"
    t.text     "improved_health"
    t.text     "agriculture_and_food"
    t.text     "clean_energy"
    t.text     "productive_time_created"
    t.integer  "number_of_jobs_created"
    t.text     "job_breakdown"
    t.text     "wages_increased"
    t.integer  "small_businesses_created"
    t.text     "business_breakdown"
    t.text     "other"
    t.text     "community_changed_summary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partner_project_progress_reports", :force => true do |t|
    t.integer  "user_id"
    t.integer  "media_album_id"
    t.date     "start_date"
    t.date     "expected_completion_date"
    t.text     "what_has_been_constructed"
    t.text     "what_has_been_purchased"
    t.text     "construction_job_breakdown"
    t.integer  "number_of_construction_jobs_created"
    t.integer  "lives_directly_impacted"
    t.integer  "lives_indirectly_impacted"
    t.text     "primary_benefits_summary"
    t.text     "extended_benefits_summary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partner_project_status_updates", :force => true do |t|
    t.integer  "user_id"
    t.integer  "media_album_id"
    t.string   "title"
    t.text     "field_updates"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partner_user_details", :force => true do |t|
    t.boolean  "necessary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partners", :force => true do |t|
    t.string   "display_name"
    t.string   "full_name"
    t.string   "permalink"
    t.string   "url"
    t.string   "public_email"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "phone_number"
    t.string   "fax_number"
    t.text     "details_for_website"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lat"
    t.float    "lng"
  end

  create_table "password_reset_emails", :force => true do |t|
    t.integer  "sender_id"
    t.datetime "sent_at"
    t.string   "subject"
    t.integer  "user_id"
    t.text     "rendered_email_contents"
    t.string   "reset_password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_campaign_associations", :force => true do |t|
    t.integer  "project_id"
    t.integer  "campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_event_invitation_emails", :force => true do |t|
    t.integer  "project_event_id"
    t.integer  "sender_id"
    t.text     "mail_contents"
    t.string   "subject"
    t.boolean  "draft",            :default => true
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_event_invitation_sent_emails", :force => true do |t|
    t.integer  "sender_id"
    t.datetime "sent_at"
    t.string   "subject"
    t.integer  "project_event_invitation_email_id"
    t.integer  "event_attendance_response_id"
    t.text     "rendered_email_contents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_events", :force => true do |t|
    t.integer  "project_id"
    t.string   "host"
    t.string   "name"
    t.string   "short_description"
    t.text     "long_description"
    t.datetime "event_start_time"
    t.datetime "event_end_time"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "fundraiser_type_id"
    t.boolean  "public"
  end

  create_table "project_focus_area_associations", :force => true do |t|
    t.integer  "project_id"
    t.integer  "focus_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_report_associations", :force => true do |t|
    t.integer  "project_id"
    t.integer  "project_report_id"
    t.string   "project_report_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_statuses", :force => true do |t|
    t.string   "display_name"
    t.string   "method_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_type_associations", :force => true do |t|
    t.integer  "project_type_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.integer  "partner_id"
    t.datetime "state_updated_at"
    t.string   "next_step"
    t.date     "due_on"
    t.string   "whats_missing"
    t.string   "why_denied"
    t.datetime "project_created_at"
    t.datetime "approved_by_citizen_effect_at"
    t.datetime "sent_back_to_partner_by_citizen_effect_at"
    t.datetime "denied_by_citizen_effect_at"
    t.string   "permalink"
    t.date     "estimated_construction_start_date"
    t.date     "actual_construction_start_date"
    t.date     "estimted_construction_completed_date"
    t.date     "actual_construction_completed_date"
    t.string   "name"
    t.string   "priority"
    t.date     "desired_construction_start_date"
    t.string   "district_coordinator"
    t.string   "community_leader"
    t.integer  "total_cost_in_local_currency"
    t.integer  "local_currency_type_id"
    t.integer  "total_cost_in_us_cents"
    t.string   "community_name"
    t.string   "district_name"
    t.string   "community_state"
    t.integer  "country_id"
    t.integer  "community_population"
    t.integer  "primary_lives_impacted"
    t.integer  "secondary_lives_impacted"
    t.integer  "average_income_per_household"
    t.integer  "families_living_below_poverty"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cp_id"
    t.integer  "project_status_id"
    t.integer  "lives_impacted_range_id"
    t.integer  "fundraising_goal_range_id"
    t.string   "twitter_path"
    t.string   "facebook_path"
    t.string   "youtube_path"
    t.string   "myspace_path"
    t.integer  "primary_photo_id"
    t.boolean  "no_credit_card_fee",                                     :default => false
    t.boolean  "no_tip_request",                                         :default => false
    t.boolean  "community_population_required",                          :default => true
    t.boolean  "enable_card_donation",                                   :default => false
    t.integer  "card_donation_cost_in_cents",                            :default => 0
    t.string   "card_image_url"
    t.text     "card_snapfish_url"
    t.integer  "email_exempt",                              :limit => 1
    t.date     "estimated_close_date"
    t.date     "actual_close_date"
    t.date     "fundraising_start_date"
    t.integer  "campaign_id"
    t.float    "lat"
    t.float    "lng"
  end

  create_table "referral_sources", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "refunds", :force => true do |t|
    t.integer  "amount_in_cents"
    t.string   "comment"
    t.integer  "donation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regular_pages", :force => true do |t|
    t.string   "title"
    t.string   "permalink_text"
    t.string   "meta_keywords"
    t.string   "meta_description"
    t.text     "content"
    t.datetime "published_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "role_permission_associations", :force => true do |t|
    t.integer  "role_id"
    t.integer  "permission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unified_uploads", :force => true do |t|
    t.string   "uploadable_type"
    t.integer  "uploadable_id"
    t.string   "flavor"
    t.string   "content_file_name"
    t.string   "content_content_type"
    t.string   "content_file_size"
    t.string   "content_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_achievement_associations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "achievement_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_activation_emails", :force => true do |t|
    t.integer  "sender_id"
    t.datetime "sent_at"
    t.string   "subject"
    t.integer  "user_id"
    t.text     "rendered_email_contents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_role_associations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_signup_notification_emails", :force => true do |t|
    t.integer  "sender_id"
    t.datetime "sent_at"
    t.string   "subject"
    t.integer  "user_id"
    t.text     "rendered_email_contents"
    t.string   "activation_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                    :default => "passive"
    t.string   "details_type"
    t.integer  "details_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "zip"
    t.string   "state_code"
    t.string   "phone_number"
    t.string   "skype_username"
    t.datetime "deleted_at"
    t.string   "twitter_access_key",        :limit => 50
    t.string   "twitter_secret_key",        :limit => 50
    t.string   "myspace_access_key"
    t.string   "myspace_secret_key"
    t.string   "facebook_auth_token",       :limit => 100
    t.string   "city_name"
    t.string   "state_name"
    t.float    "lat"
    t.float    "lng"
    t.string   "address1"
    t.string   "address2"
    t.string   "twitter_path"
    t.string   "linkedin_path"
    t.string   "facebook_path"
    t.string   "myspace_path"
    t.string   "youtube_path"
    t.string   "blog_url"
    t.text     "about_me"
    t.boolean  "display_facebook_todo",                    :default => true
    t.boolean  "display_twitter_todo",                     :default => true
    t.boolean  "display_myspace_todo",                     :default => true
    t.boolean  "display_contact_todo",                     :default => true
    t.boolean  "display_invite_todo",                      :default => true
    t.string   "api_key"
  end

  create_table "watched_project_associations", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
