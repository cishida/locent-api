# @restful_api 1.0
#
# Customers
#
class Dashboard::V1::CustomersController < DashboardController
  # @url /customers/:feature
  # @action GET
  #
  # Get a paginated list of all of an organization's customers subscribed to a feature
  #
  # @required [String] feature The feature e.g 'keyword'
  #
  # @response_field [Array<Customer>] customers List of customers on this page
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

    paginate json: @customers
  end


  def messages
    param! :uid, String, required: true
    customer = Customer.find_by_uid(params[:uids])

  end

end