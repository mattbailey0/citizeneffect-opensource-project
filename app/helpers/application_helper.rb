# -*- coding: utf-8 -*-
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def association_confirm_text
    "Navigating away will lose any usaved changes.  If you've made changes you want to save click 'cancel', then save, then edit again."
  end
  
  def news_item_href(news_item)
    case newsable = news_item.newsable
      when Project
        polymorphic_path newsable
      else
        polymorphic_path projects_path
    end
  end
  
  def news_item_link(news_item)
    case newsable = news_item.newsable
      when Project
        link_to "visit the project", newsable
      else
        link_to "check out our newest projects here", projects_path
    end
  end
  
  def events_nearby
    ProjectEvent.near(:user => current_user, :ip => request.ip)
  end
  
  def format_dollars(dollars)
    number_to_currency(dollars, :precision => 0)
  end
  
  def render_with_last(options)
    options[:locals] ||= {}
    options[:locals][:last] ||= options[:collection].last if options[:collection]
    render options
  end
  
  def last_class(object1, object2)
    object1 == object2 ? " last" : ""
  end
  
  def watch_list_news_item_icon(news_item)
    image_path("watch_list_news_item_#{h news_item.news_item_type}.png")
  end
  
  def blog_post_icon(blog_post)
    "blog_icon_#{blog_post.category.andand.id}.gif"
  end
  
  def menu_link_to(link_text, path)
    link_to link_text.upcase, (p=path), :class => current_page?(p) ? "on" : ""
  end
  
  def photo_media?(media)
    MediaAlbumPhoto === media
  end
  
  def sized_image_tag(object, method, size_name, options = {})
    width, height = UnifiedUpload::IMAGE_SIZES[size_name].split("x")
    defaults = {
      :width => width,
      :height => height
    }
    options = options.dup.symbolize_keys.reverse_merge(defaults)
    image_tag object.send(method, size_name), options
  end
  
  def share_info_array(shareable = nil)
    title, url = title_and_url_for_shareable(shareable)
    bitlyurl = UrlShortener.shorten(url) unless url.blank?
    
    title    = u(title)    unless title.blank?
    url      = u(url)      unless url.blank?
    bitlyurl = u(bitlyurl) unless bitlyurl.blank?
    
    share_info = ShareHelper::SHARE_TYPES.dup
    share_info.each do |value|
      value[:url] = value[:url_proc].call(title, url, bitlyurl)
    end
  end
  
  def default_share_box_text(shareable)
    title, url = title_and_url_for_shareable(shareable)
    bitlyurl = UrlShortener.shorten(url) unless url.blank?
    
    "#{title} - #{bitlyurl}"
  end
  
  def share_box_id(shareable = nil)
    "share_box_#{shareable.class.name}_#{shareable.andand.id}"
  end
  
  def title_and_url_for_shareable(shareable = nil)
    if shareable == :donation_bracket
      return ["I just joined Citizen Effect's Yoga Challenge to build a foster home in South Africa!",
              yoga_challenge_url]
    end
    
    case shareable.class.to_s
      when Project.to_s      then [shareable.name, project_url(shareable)]
      when ProjectEvent.to_s then [shareable.name, project_project_event_url(shareable.project, shareable)]
      when BlogPost.to_s     then [shareable.title, "#{root_url}blog/#{shareable.blog.url_identifier}/#{shareable.url_identifier}" ]      
      else ["Citizen Effect", root_url]
    end
  end
  
  def share_box_title(shareable = nil)
    return "SHARE THIS DONATION" if shareable == :donation_bracket
    shareable ? "SHARE THIS #{shareable.class.to_s.humanize.upcase}" : 'SHARE CITIZEN EFFECT'
  end
  
  def header_text(text, options={})
    return "" if text.blank?
    
    options[:length] ||= -1

    text_to_truncate = text.upcase

    return h(text_to_truncate) if options[:length] == -1
    return truncate(h(text_to_truncate), :length  => options[:length], :omission => "…")
  end
  
  def first_sentence_of(text)
    "#{text.split('.')[0]}."
  end
  
  def image_tag(*args, &block)
    if request.ssl?
      super.gsub(/https?:\/\/[^\/]*(\/#{PAPERCLIP_OPTIONS[:bucket]})?\//, "https://s3.amazonaws.com/#{PAPERCLIP_OPTIONS[:bucket]}/")
    else
      super
    end
  end
  
end
