class Dashboard::V1::CustomersController < DashboardController
  def show
    param! :feature, String, required: true
    @organization = current_user.organization
    @feature = Feature.find_by_name(params[:feature].capitalize)
    @subscription = Subscription.find_by_organization_id_and_feature_id(@organization.id, @feature.id)
    @customers = Customer.joins(:opt_ins).where(
        opt_ins: {
            subscription_id: @subscription.id
        }
    )
    respond_with @customers
  end

end