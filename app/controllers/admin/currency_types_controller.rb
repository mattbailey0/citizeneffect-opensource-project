class Admin::CurrencyTypesController < AdminController
  # GET /currency_types
  # GET /currency_types.xml
  def index
    @currency_types = CurrencyType.find(:all, :order => 'currency_code ASC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @currency_types }
      format.xls { send_as_xls }
    end
  end

  # GET /currency_types/1
  # GET /currency_types/1.xml
  def show
    @currency_type = CurrencyType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @currency_type }
    end
  end

  # GET /currency_types/new
  # GET /currency_types/new.xml
  def new
    @currency_type = CurrencyType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @currency_type }
    end
  end

  # GET /currency_types/1/edit
  def edit
    @currency_type = CurrencyType.find(params[:id])
  end

  # POST /currency_types
  # POST /currency_types.xml
  def create
    @currency_type = CurrencyType.new(params[:currency_type])

    respond_to do |format|
      if @currency_type.save
        flash[:notice] = 'CurrencyType was successfully created.'
        format.html { redirect_to([:admin, @currency_type]) }
        format.xml  { render :xml => @currency_type, :status => :created, :location => @currency_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @currency_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /currency_types/1
  # PUT /currency_types/1.xml
  def update
    @currency_type = CurrencyType.find(params[:id])

    respond_to do |format|
      if @currency_type.update_attributes(params[:currency_type])
        flash[:notice] = 'CurrencyType was successfully updated.'
        format.html { redirect_to([:admin, @currency_type]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @currency_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /currency_types/1
  # DELETE /currency_types/1.xml
  def destroy
    @currency_type = CurrencyType.find(params[:id])
    @currency_type.destroy

    respond_to do |format|
      format.html { redirect_to(admin_currency_types_url) }
      format.xml  { head :ok }
    end
  end
end
