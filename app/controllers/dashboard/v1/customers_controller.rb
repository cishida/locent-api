# @restful_api 1.0
#
# Customers
#
class Dashboard::V1::CustomersController < DashboardController
  before_action :authenticate_user!
  before_action :set_organization
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
    set_variables
    paginate json: @customers
  end


  def messages
    param! :uid, String, required: true
    param! :feature, String, required: true

    customer = Customer.find_by_uid(params[:uid])
    @messages = Message.where(organization: @organization, to: customer.phone).where(organization: @organization, from: customer.phone).select{ |message| message.purpose.feature == params[:feature]}.order("id DESC")
    render json: @messages
  end


  private

  def set_organization
    @organization = current_user.organization
  end

  def set_variables
    set_feature
    set_subscription
    set_customers
  end

  def set_feature
    @feature = Feature.find_by_name(params[:feature])
  end

  def set_subscription
    @subscription = Subscription.find_by_organization_id_and_feature_id(@organization.id, @feature.id)
  end

  def set_customers
    @customers = Customer.joins(:opt_ins).where(
        opt_ins: {
            subscription_id: @subscription.id
        }
    )
  end

end