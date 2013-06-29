class Admin::ProjectEventsController < AdminController
  # GET /project_events
  # GET /project_events.xml
  def index
    @project_events = ProjectEvent.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @project_events }
    end
  end

  # GET /project_events/1
  # GET /project_events/1.xml
  def show
    @project_event = ProjectEvent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project_event }
    end
  end

  # GET /project_events/new
  # GET /project_events/new.xml
  def new
    @project_event = ProjectEvent.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project_event }
    end
  end

  # GET /project_events/1/edit
  def edit
    @project_event = ProjectEvent.find(params[:id])
  end

  # POST /project_events
  # POST /project_events.xml
  def create
    @project_event = ProjectEvent.new(params[:project_event])

    respond_to do |format|
      if @project_event.save
        flash[:notice] = 'ProjectEvent was successfully created.'
        format.html { redirect_to([:admin, @project_event]) }
        format.xml  { render :xml => @project_event, :status => :created, :location => @project_event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project_event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /project_events/1
  # PUT /project_events/1.xml
  def update
    @project_event = ProjectEvent.find(params[:id])

    respond_to do |format|
      if @project_event.update_attributes(params[:project_event])
        flash[:notice] = 'ProjectEvent was successfully updated.'
        format.html { redirect_to([:admin, @project_event]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project_event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /project_events/1
  # DELETE /project_events/1.xml
  def destroy
    @project_event = ProjectEvent.find(params[:id])
    @project_event.destroy

    respond_to do |format|
      format.html { redirect_to(admin_project_events_url) }
      format.xml  { head :ok }
    end
  end
end
