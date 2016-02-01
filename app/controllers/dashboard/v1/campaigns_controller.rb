class Dashboard::V1::CampaignsController < DashboardController

  def alert
    param! :feature, String, required: true
    param! :message, String, required: true

    feature = Feature.find_by_name(params[:feature].downcase.capitalize)
    @organization = current_user.organization
    @customers = Customer.joins(:opt_ins).where(
        organization_id: @organization.id,
        opt_ins: {
            feature: feature.id
        }
    )

    @customers.each { |customer| Resque.enqueue(MessageSender, @organization.from, customer.phone, params[:message], nil) }
  end

end