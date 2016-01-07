class Dashboard::V1::SafetextController < DashboardController
  before_action :set_organization

  def customers
    @customers = Customer.joins(:opt_in).where(
        opt_ins: {
            subscription_id: @subscription.id
        }
    )
    respond_with @customers
  end


  private

  def set_organization
    @organization = current_user.organization
    @subscription = Subscription.find_by_organization_id_and_product_id(@organization.id, 3)
  end


end