class FundraiserTypesController < ApplicationController

  # GET /fundraiser_types
  def index
    @fundraiser_types = FundraiserType.all
  end

  # GET /fundraiser_types/1
  def show
    @fundraiser_type = FundraiserType.find(params[:id])
  end
  
  def find_your_perfect_fundraiser
    if @fundraiser_type = FundraiserType.determine_perfect_fundraisers(params[:find_your_perfect_fundraiser]).top_1.first
      redirect_to @fundraiser_type
    else
      flash[:error] = "We couldn't find a fundraiser matching your criterial.  Try broadening your search."
      redirect_to fundraiser_types_path
    end
  end
  
  def most_successful
    @fundraiser_types = FundraiserType.most_successful.paginate(:page => params[:page], :order => "created_at DESC", :per_page => 5)
    render :update do |page|
      page.insert_html :bottom, "most_successful_fundraiser_types", :partial => "fundraiser_type", :collection => @fundraiser_types
    end
  end
  
  def most_popular
    @fundraiser_types = FundraiserType.most_popular.paginate(:page => params[:page], :order => "created_at DESC", :per_page => 5)
    render :update do |page|
      page.insert_html :bottom, "most_popular_fundraiser_types", :partial => "fundraiser_type", :collection => @fundraiser_types
    end
  end

end
