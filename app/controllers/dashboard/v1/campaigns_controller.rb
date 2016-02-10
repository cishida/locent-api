# @restful_api 1.0
#
# Campaigns
#
class Dashboard::V1::CampaignsController < DashboardController
  before_action :authenticate_user!
  before_action :set_organization


  # @url /dashboard/campaigns/alert/:feature
  # @action POST
  #
  # Sends a message to all customers opt-ed in to a feature
  #
  # @required [String] feature The feature e.g 'keyword'
  # @required [String] message The message to be sent
  # @required [String] campaign_name The name of the campaign
  #
  # @response_field [Campaign] campaign Newly created campaign
  def alert
    ActiveRecord::Base.transaction do
      validate_alert_params
      set_alert_variables
      send_message_to_customers("alert")
      render json: @campaign, status: 201
    end
  end

  # @url /dashboard/campaigns/import
  # @action POST
  #
  # Sends a message to all imported customers that are opted-in to any of the organization's features
  #
  # @required [Array<Customer>] customers The customers to be texted
  # @required [String] message The message to be sent
  # @required [String] campaign_name The name of the campaign
  #
  # @response_field [Campaign] campaign Newly created campaign
  # @response_field [failed_count] failed_count The amount of customers that couldn't be sent to because they're not opted-in to any of the organization's features
  #
  def import
    ActiveRecord::Base.transaction do
      validate_import_params
      @failed_count = 0
      @customers = []
      set_opted_in_customers
      send_message_to_customers("import")
      render json: {failed: @failed_count, campaign: @campaign}, status: 201
    end
  end

  # @url /dashboard/campaigns
  # @action GET
  #
  # Get a paginated list of organization's campaigns
  #
  # @response_field [Array<Campaigns>] campaigns All organizations campaigns
  #
  def index
    @campaigns = Campaign.where(organization_id: @organization.id)
    paginate json: @campaigns
  end

  private

  def set_organization
    @organization = current_user.organization
  end


  def validate_alert_params
    param! :feature, String, required: true
    validate_campaign_params
  end

  def validate_import_params
    validate_campaign_params
    param! :customers, Array, required: true
  end

  def validate_campaign_params
    param! :message, String, required: true
    param! :campaign_name, String, required: true
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
            feature_id: @feature.id
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
    Customer.exists?(phone: customer, organization_id: @organization.id)
  end

  def send_message_to_customers(kind)
    create_new_campaign(kind)
    @customers.each do |customer|
      if @organization.has_shortcode?
        Resque.enqueue(MessageSenderWithShortcode, @organization.from, customer.phone, params[:message], @campaign.to_descriptor_hash, @organization.id)
      else
        Resque.enqueue(MessageSender, @organization.from, customer.phone, params[:message], @campaign.to_descriptor_hash, @organization.id)
      end
    end
  end

  def create_new_campaign(kind)
    @campaign = Campaign.create(kind: kind, number_of_targets: @customers.count, name: params[:campaign_name], organization_id: @organization.id, message: params[:message])
  end

end