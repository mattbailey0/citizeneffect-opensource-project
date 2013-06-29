class HomeController < ApplicationController
  MOBILE_REGEXP_1 = /android|avantgo|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i
  MOBILE_REGEXP_2 = /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|e\-|e\/|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(di|rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|xda(\-|2|g)|yas\-|your|zeto|zte\-/i

	before_filter :load_blog_post, :only => [:index, :search, :news_items, :top_cps, :contact_us,
                                           :top_networkers, :how_it_works, :media, :about_us]

  def index
    @blog_posts = recent_posts({})
  end

  def search
    @projects = []
    params[:with] ||= {}
    params[:q]    ||= ""
    do_cp_search = false
    do_all_search = false

    params[:with].delete(:country_id) if params[:with][:country_id].blank?
    params[:with].delete(:project_status_id) if params[:with][:project_status_id].blank?
    params[:with].delete(:fundraiser_tag_id) if params[:with][:fundraiser_tag_id].blank?
    params[:with].delete(:focus_area_ids) if params[:with][:focus_area_ids].blank?

    if params[:with][:project_status_id]
      ids = params[:with][:project_status_id]
      ids = [ids] unless ids.is_a? Array
      if ids.delete("All")
        do_all_search = true
        params[:with].delete(:project_status_id)
      else
        do_cp_search = true if ids.delete("Users")
        ids += ProjectStatus.statuses_that_count_as_completed.map(&:id).map(&:to_s) if ids.delete("Completed")
        params[:with][:project_status_id] = ids
      end
    end

    #fundraiser tag ids to fundraising goal ranges
    if params[:with][:fundraiser_tag_id]
      ranges = FundraiserTag.determine_fundraising_goal_ranges(params[:with].delete(:fundraiser_tag_id))
      params[:fundraising_goal_range_id] = ranges.map(&:id)
    end

    if do_cp_search
      conditions = params[:q].blank? ? {} : { :cp_name => params[:q] }
      @projects = Project.sphinx_user_visible.search(:conditions => conditions, :with => params[:with], :page => params[:page])
    else
      @projects = Project.sphinx_user_visible.search(params[:q], :with => params[:with], :page => params[:page])
    end

    @result_count = @projects.total_entries
    @projects.compact! #get rid of any nils caused by out of date indicies

    @project = @projects.first || Project.user_visible_projects.first #for "others you might like"

    respond_to do |format|
      format.html
      format.json { render :json => @projects }
      format.xml { render :xml => @projects }
    end
  end

  def news_items
    @news_items = NewsItem.paginate(:page => params[:page], :order => "created_at DESC", :per_page => 10)
    render :update do |page|
      page << "$('#home_news_items .last').removeClass('last')" unless @news_items.empty?
      page.insert_html :bottom, "home_news_items", :partial => "shared/news_item", :collection => @news_items, :locals => { :last => @news_items.last}
    end
  end

  def top_cps
    @top_cps = User.top_cps.paginate(:page => params[:page], :order => "created_at DESC", :per_page => 5)
    render :update do |page|
      page << "$('#home_top_cps .last').removeClass('last')" unless @top_cps.empty?
      page.insert_html :bottom, "home_top_cps", :partial => "cp", :collection => @top_cps, :locals => { :last => @top_cps.last}
    end
  end

  def top_networkers
    @top_networkers = User.top_networkers.paginate(:page => params[:page], :order => "created_at DESC", :per_page => 5)
    render :update do |page|
      page << "$('#home_top_networkers .last').removeClass('last')" unless @top_networkers.empty?
      page.insert_html :bottom, "home_top_networkers", :partial => "cp", :collection => @top_networkers, :locals => { :last => @top_networkers.last}
    end
  end

  # 'static' page with some carousel action
  def how_it_works
  end

  # 'static' page with some carousel action
  def media
    @albums = Project.user_visible_projects.all.map(&:primary_photo).compact
    @videos = Project.user_visible_projects.all.map(&:videos).map(&:first).compact
  end

  # 'static' page with some carousel action
  def about_us
  end

  def terms_of_service
    redirect_to RegularPage.terms_of_service.path
  end

  # 'static' page with some carousel action
  def contact_us
  end

  def holiday_harvest
    render :layout => false
  end

  def holiday_harvest_cards
    render :layout => false
  end

  def yoga_challenge
      render :layout => false
  end

  def yoga_challenge_studios
    render :layout => false
  end

  def yoga_challenge_about
    render :layout => false
  end

  # dc4dc
  def dc4dc
    render :layout => false
  end

  def dc4dc_about
    render :layout => false
  end

  def dc4dc_causes
    render :layout => false
  end

  def dc4dc_join_us
    render :layout => false
  end

  def dc4dc_participants
    render :layout => false
  end

  def dc4dc_schwag
    render :layout => false
  end

  def dc4dc_form
    @general_form = GeneralForm.new(:campaign_code => params[:campaign_code], :source => 'DC4DC-2011')
    render :layout => false
  end

  def dc4dc_thankyou
    @general_form = GeneralForm.new(params[:general_form])
    @general_form.source = 'DC4DC-2011'

    if @general_form.save
      render :layout => false
    else
      render :action => "dc4dc_form", :layout => false
    end
  end

  # detroit

  def detroit
    #redirect_to "/detroit4detroit"
    redirect_to "http://www.detroit4detroit.org"
  end

  def detroit4detroit
    #@general_form = GeneralForm.new(:campaign_code => params[:campaign_code], :source => 'DETROIT4DETROIT-2011')
    #render :layout => false
    redirect_to "http://www.detroit4detroit.org"
  end

  def detroit4detroit_thankyou
    #@general_form = GeneralForm.new(params[:general_form])
    #@general_form.source = 'DETROIT4DETROIT-2011'

    #if @general_form.save
    #  render :layout => false
    #else
    #  render :action => "detroit4detroit", :layout => false
    #end
    redirect_to "http://www.detroit4detroit.org"
  end

  def detroit4detroit_about
    #render :layout => false
    redirect_to "http://www.detroit4detroit.org"
  end

  def detroit4detroit_partners
    #@partner_inquiry_form = PartnerInquiryForm.new(:source => 'DETROIT4DETROIT-2011')
    #render :layout => false
    redirect_to "http://www.detroit4detroit.org"
  end

  def detroit4detroit_partners_thankyou
    #@partner_inquiry_form = PartnerInquiryForm.new(params[:partner_inquiry_form])
    #@partner_inquiry_form.source = 'DETROIT4DETROIT-2011'

    #if @partner_inquiry_form.save
    #  render :layout => false
    #else
    #  render :action => "detroit4detroit_partners", :layout => false
    #end
    redirect_to "http://www.detroit4detroit.org"
  end

  # tourney
  def tourney
    render :layout => false
  end

  def tourney_office
    redirect_to tourney_path
    #render :layout => false
  end

  def tourney_more
    redirect_to tourney_path
    #render :layout => false
  end

  def yoga4good
    redirect_to "https://www.facebook.com/pages/Show-Us-Your-Yoga4Good-Pose/210689845641747"
  end

  def bwb
    redirect_to tourney_path, :status => :moved_permanently
  end

  def japan
    redirect_to "/projects/japan-earthquake-relief-fund"
  end

  private

	def load_blog_post
		load_blog
		@blog_post = BlogPost.find(:first, :conditions => ["blog_id = ? AND (id = ? OR url_identifier = ?)", @blog_id, params[:id], params[:id]]) if params[:id]
	end

	def recent_posts(blog_show_params)
		BlogPost.paginate(:all, :select => "DISTINCT blog_posts.*", :conditions => ["blog_id = ? AND is_complete = ?", @blog_id, true], :order => "blog_posts.created_at DESC", :page => blog_show_params[:page] || 1, :per_page => 3)
	end

end

