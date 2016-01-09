class Dashboard::V1::DashboardSafetextController < DashboardController
  before_action :set_organization

  def customers
    a = Customer.joins(:opt_ins).where(
        opt_ins: {
            subscription_id: 3
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