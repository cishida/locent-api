class Dashboard::V1::CampaignsController < DashboardController
  before_action :authenticate_user!


  def alert
    param! :feature, String, required: true
    param! :message, String, required: true

    feature = Feature.find_by_name(params[:feature].downcase)
    @organization = current_user.organization
    @customers = Customer.joins(:opt_ins).where(
        organization_id: @organization.id,
        opt_ins: {
            feature_id: feature.id
        }
    )

    @customers.each { |customer| Resque.enqueue(MessageSender, @organization.from, customer.phone, params[:message], nil) }
  end

  def import
    param! :customers, Array, required: true do |customer|
      customer.param! :phone_number, String, required: true
    end

    count = 0
    params[:customers].each do |customer|
      if Customer.exists?(phone: customer[:phone_number], organization_id: current_user.organization.id)
        Resque.enqueue(MessageSender, current_user.organization.from, customer.phone, params[:message], nil)
      else
        count+=1
      end
      render json: {failed: count}, status: 204
    end
  end

end