class DonationsController < ApplicationController
  ssl_required :index, :new, :create
  filter_parameter_logging :credit_card_number, :expiration_year, :expiration_month, :credit_card_cvv
  before_filter :get_project


  # GET /donations
  def index
    redirect_to @project ? [:new, @project, :donation] : new_donation_path
  end

  # GET /donations/new
  def new
    if Time.now.year > 2012 && request.env['PATH_INFO'] != '/secret_bonus_round/donate'
      flash[:error] = "We're sorry, but Citizen Effect isn't accepting donations at this time."
      if @project   
        redirect_to @project
      else
        redirect_to root_path
      end
    else
      if @project && !@project.cp
          flash[:error] = "Cannot donate to a project that does not have a CP."
          redirect_to @project
        else
          @donation = Donation.new(:project => @project, :donor => current_user,
                                   :campaign_code => params[:campaign_code])
          if request.env['PATH_INFO'] == '/secret_bonus_round/donate'
            @donation.campaign_code = "secret_bonus_round"
          end
          @tip_value = Donation::TIP_DEFAULT
          if @donation.project.andand.enable_card_donation
            render(:action => "snapfish_card_new")
          elsif @donation.campaign_code == Donation::YOGA
            render(:action => "yoga_new", :layout => "bracket_donations")
          elsif @donation.campaign_code == Donation::BRACKETS
            render(:action => "bracket_new", :layout => "bracket_donations")
          else
            render(:action => "new")
          end

        end
    end
  end

  # POST /donations
  def create
    if Time.now.year > 2012 && params[:donation][:campaign_code] != "secret_bonus_round"
      flash[:error] = "We're sorry, but Citizen Effect isn't accepting donations at this time." 
      if @project   
        redirect_to @project
      else
        redirect_to root_path
      end
    else

      @donation = Donation.new(params[:donation])
      @project ||= @donation.project
      @donation.donor = current_user
      @donation.set_fee_percentage
      
      @donation.refunds_total_in_cents = 0
      
      if @donation.save_and_charge_with_rollback
        flash[:notice] = 'Donation was successfully charged!'
        @user = @donation.donor || User.new(@donation.attributes)
        session[:user_id] = @user.id if !current_user && @user.id
        case @donation.campaign_code
          when Donation::YOGA then render(:action => "yoga_donation_complete", :layout => "bracket_donations")
          when Donation::BRACKETS then render(:action => "bracket_donation_complete", :layout => "bracket_donations")
          when Donation::SNAPFISH_CARD then render(:action => "snapfish_card_complete")
          else render(:action => "donation_complete")
        end
      else
        @tip_value = @donation.tip_percentage;  #capture selected tip value from form for smart default
        if @donation.project.andand.enable_card_donation
          render(:action => "snapfish_card_new")
        elsif @donation.campaign_code == Donation::YOGA
          render(:action => "yoga_new", :layout => "bracket_donations")
        elsif @donation.campaign_code == Donation::BRACKETS
          render(:action => "bracket_new", :layout => "bracket_donations")
        else
          render(:action => "new")
        end
      end
    end
  end

  private

  def get_project
    @project = Project.find(params[:project_id]) if params[:project_id]
  end

end

