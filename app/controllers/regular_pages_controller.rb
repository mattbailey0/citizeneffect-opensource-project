class RegularPagesController < ApplicationController

  def regular_page_public
    @regular_page = RegularPage.published.find_by_permalink_text(params[:permalink])
    unless @regular_page
      render_404(params[:permalink]) 
    else
      @title = @regular_page.title
      @meta_keywords = @regular_page.meta_keywords
      @meta_description = @regular_page.meta_description
      if params[:inner]
        render :action => "regular_pages/show_inner", :layout => false
      else
        render :action => "regular_pages/show", :layout => "application"
      end
    end
  end
end
