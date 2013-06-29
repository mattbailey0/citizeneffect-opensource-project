class Admin::RegularPagesController < AdminController
  cache_sweeper :regular_page_sweeper, :only => [:update, :destroy]
  
  # GET /regular_pages
  # GET /regular_pages.xml
  def index
    @regular_pages = RegularPage.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @regular_pages }
      format.xls { send_as_xls }
    end
  end

  # GET /regular_pages/1
  # GET /regular_pages/1.xml
  def show
    @regular_page = RegularPage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @regular_page }
    end
  end

  # GET /regular_pages/new
  # GET /regular_pages/new.xml
  def new
    @regular_page = RegularPage.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @regular_page }
    end
  end

  # GET /regular_pages/1/edit
  def edit
    @regular_page = RegularPage.find(params[:id])
  end

  # POST /regular_pages
  # POST /regular_pages.xml
  def create
    @regular_page = RegularPage.new(params[:regular_page])

    case params[:commit]
    when "Save as Draft" 
      @regular_page.draft
    when "Save & Publish" 
      @regular_page.publish
    end
    
    respond_to do |format|
      if @regular_page.save
        flash[:notice] = @regular_page.published? ? 'regular page published' : 'regular page added as draft'
        format.html { redirect_to(admin_regular_pages_path) }
        format.xml  { render :xml => @regular_page, :status => :created, :location => @regular_page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @regular_page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /regular_pages/1
  # PUT /regular_pages/1.xml
  def update
    @regular_page = RegularPage.find(params[:id])

    case params[:commit]
    when "Save as Draft" 
      @regular_page.draft
    when "Save & Publish" 
      @regular_page.publish
    end

    
    respond_to do |format|
      if @regular_page.update_attributes(params[:regular_page])
        flash[:notice] = @regular_page.published? ? 'regular page updated and published' : 'regular page draft updated'
        format.html { redirect_to(admin_regular_pages_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @regular_page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /regular_pages/1
  # DELETE /regular_pages/1.xml
  def destroy
    @regular_page = RegularPage.find(params[:id])
    @regular_page.destroy

    respond_to do |format|
      format.html { redirect_to(admin_regular_pages_path) }
      format.xml  { head :ok }
    end
  end
end
