class RegularPageSweeper < ActionController::Caching::Sweeper
  observe RegularPage
  def after_update(regular_page)
    expire_cache_for(regular_page)
  end

  def after_destroy(regular_page)
    expire_cache_for(regular_page)
  end

  private
  def expire_cache_for(regular_page)
    expire_page(regular_pages_public_path(:permalink => regular_page.permalink_text))
  end
end
