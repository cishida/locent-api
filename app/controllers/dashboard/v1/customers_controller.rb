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
  # @response_field [Array<Customer>] customers List of customers on this page that have opted in to this feature
  def show
    param! :feature, String, required: true
    set_variables
    paginate json: @customers
  end

  # @url /customers/:uid/messages/:feature
  # @action GET
  #
  # Get a list of all the messages that have been sent and received to/from this customer
  #
  # @required [String] feature The feature e.g 'keyword'
  # @required [String] uid The customer's unique identifier
  #
  # @response_field [Array<Message>] messages List of messages that have been sent and received to/from this customer
  def messages
    param! :uid, String, required: true
    param! :feature, String, required: true

    @customer = Customer.find_by_uid(params[:uid])
    find_and_set_messages
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

  def find_and_set_messages
    find_all_feature_order_messages_with_customer
    find_all_feature_opt_in_messages_with_customer
    combine_the_above_messages
  end

  def find_all_feature_order_messages_with_customer
    @messages = Message.where(organization_id: @organization.id, to: @customer.phone, purpose_type: "Order").union(Message.where(organization_id: @organization.id, from: @customer.phone, purpose_type: "Order")).select { |message| message.purpose.feature == params[:feature] }
  end

  def find_all_feature_opt_in_messages_with_customer
    @opt_in_messages = Message.where(organization_id: @organization.id, to: @customer.phone, purpose_type: "OptIn").union(Message.where(organization_id: @organization.id, from: @customer.phone, purpose_type: "OptIn")).select { |message| message.purpose.feature_id == Feature.find_by_name(params[:feature]).id }
  end

  def combine_the_above_messages
    @messages = @messages + @opt_in_messages
  end

end

