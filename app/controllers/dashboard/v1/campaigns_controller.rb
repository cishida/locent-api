class Dashboard::V1::CampaignsController < DashboardController
  before_action :authenticate_user!
  before_action :set_organization


  def alert
    validate_alert_params
    set_alert_variables
    send_message_to_customers
  end

  def import
    validate_import_params
    @failed_count = 0
    @customers = []
    set_opted_in_customers
    send_message_to_customers
    render json: {failed: @failed_count}, status: 204
  end

  private

  def set_organization
    @organization = current_user.organization
  end


  def validate_alert_params
    param! :feature, String, required: true
    param! :message, String, required: true
  end

  def validate_import_params
    param! :message, String, required: true
    param! :customers, Array, required: true do |customer|
      customer.param! :phone_number, String, required: true
    end
  end

  def set_alert_variables
    set_feature
    set_customers_by_feature
  end

  def set_feature
    @feature = Feature.find_by_name(params[:feature].downcase)
  end

  def set_customers_by_feature
    @customers = Customer.joins(:opt_ins).where(
        organization_id: @organization.id,
        opt_ins: {
            feature_id: feature.id
        }
    )
  end

  def set_opted_in_customers
    params[:customers].each do |customer|
      if organization_can_message? customer
        @customers << customer
      else
        @failed_count+=1
      end
    end
  end

  def organization_can_message? customer
    Customer.exists?(phone: customer[:phone_number], organization_id: @organization.id)
  end

  def send_message_to_customers
    @customers.each { |customer| Resque.enqueue(MessageSender, @organization.from, customer.phone, params[:message], nil) }
  end

end