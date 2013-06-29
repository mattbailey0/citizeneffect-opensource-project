class Admin::FocusAreasController < AdminController
  # GET /focus_areas
  # GET /focus_areas.xml
  def index
    @focus_areas = FocusArea.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @focus_areas }
      format.xls { send_as_xls }
    end
  end

  # GET /focus_areas/1
  # GET /focus_areas/1.xml
  def show
    @focus_area = FocusArea.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @focus_area }
    end
  end

  # GET /focus_areas/new
  # GET /focus_areas/new.xml
  def new
    @focus_area = FocusArea.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @focus_area }
    end
  end

  # GET /focus_areas/1/edit
  def edit
    @focus_area = FocusArea.find(params[:id])
  end

  # POST /focus_areas
  # POST /focus_areas.xml
  def create
    @focus_area = FocusArea.new(params[:focus_area])

    respond_to do |format|
      if @focus_area.save
        flash[:notice] = 'FocusArea was successfully created.'
        format.html { redirect_to([:admin, @focus_area]) }
        format.xml  { render :xml => @focus_area, :status => :created, :location => @focus_area }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @focus_area.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /focus_areas/1
  # PUT /focus_areas/1.xml
  def update
    @focus_area = FocusArea.find(params[:id])

    respond_to do |format|
      if @focus_area.update_attributes(params[:focus_area])
        flash[:notice] = 'FocusArea was successfully updated.'
        format.html { redirect_to([:admin, @focus_area]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @focus_area.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /focus_areas/1
  # DELETE /focus_areas/1.xml
  def destroy
    @focus_area = FocusArea.find(params[:id])
    @focus_area.destroy

    respond_to do |format|
      format.html { redirect_to(admin_focus_areas_url) }
      format.xml  { head :ok }
    end
  end
end
