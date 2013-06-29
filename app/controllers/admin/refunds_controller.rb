class Admin::RefundsController < AdminController

  before_filter :find_donation

  def new
    #@donation = Donation.find(params[:donation_id])
    @project = @donation.project
    #@refund = (@donation ? @donation.refunds : Refund).new
    @refund = @donation.refunds.new
  end

  def edit
    @refund = Refund.find(params[:id])
  end

  def create
    @refund = @donation.refunds.new(params[:refund])
    
    #update refunded_amount_in_cents for @donation, @donation.save.
    if @refund.save
      flash[:notice] = "Refund was successfully created."
      redirect_to [:edit, :admin, @donation].compact
    else
      render :action => "new"
    end
  end

    
  def update
    @donation = Donation.find(params[:id])

    if @donation.update_attributes(params[:donation])
      flash[:notice] = 'Donation was successfully updated.'
      redirect_to [:edit, :admin, @project, @donation].compact
    else
      render :action => "edit"
    end
  end

  def destroy
    @donation = Donation.find(params[:id])
    @donation.andand.destroy

    redirect_to admin_donations_path(:project_id => @project.andand.id)
  end

  private
  def find_donation
    @donation = Donation.find(params[:donation_id]) if params[:donation_id]
  end
end

