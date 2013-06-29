class Admin::FundraiserTypeExperiencesController < AdminController
  before_filter :get_fundraiser_type
  
  def get_fundraiser_type
    @fundraiser_type = FundraiserType.find(params[:fundraiser_type_id])
  end
  
  def index
    @fundraiser_type_experiences = @fundraiser_type.fundraiser_type_experiences
  end
  
  def show
    @fundraiser_type_experience = @fundraiser_type.fundraiser_type_experiences.find(params[:id])
  end
  
  def new
    @fundraiser_type_experience = @fundraiser_type.fundraiser_type_experiences.build
  end
  
  def edit
    @fundraiser_type_experience = @fundraiser_type.fundraiser_type_experiences.find(params[:id])
  end
    
  def create
    @fundraiser_type_experience = @fundraiser_type.fundraiser_type_experiences.build(params[:fundraiser_type_experience])
    
    if @fundraiser_type_experience.save
      flash[:notice] = 'CP Experience was successfully added.'
      redirect_to([:admin, @fundraiser_type, @fundraiser_type_experience])
    else
      render :action => "new"
    end
  end
  
  def update
    @fundraiser_type_experience = @fundraiser_type.fundraiser_type_experiences.find(params[:id])
    
    if @fundraiser_type_experience.update_attributes(params[:fundraiser_type_experience])
      flash[:notice] = 'CP Experience was successfully updated.'
      redirect_to([:admin, @fundraiser_type, @fundraiser_type_experience])
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @fundraiser_type_experience = @fundraiser_type.fundraiser_type_experiences.find(params[:id])
    @fundraiser_type_experience.destroy
    flash[:notice] = 'Citizen Philanthropist Experience Removed'

    redirect_to(admin_fundraiser_type_fundraiser_type_experiences_path)
  end
end
