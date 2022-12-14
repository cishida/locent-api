class Api::V1::OptInsController < ApiController

  def create
    ActiveRecord::Base.transaction do
      validate_create_params
      set_subscription
      get_or_create_customers
      create_opt_ins
      send_back_opt_in_verification_code
      send_opt_in_code_request_to_customer
      head status: 204
    end
  end

  def opt_out
    ActiveRecord::Base.transaction do
      validate_opt_out_params
      set_subscription
      customers_array = params[:customers]
      customers_array.each do |customer|
        customer = Customer.find_by_organization_id_and_phone(@organization.id, customer[:phone_number], customer[:uid])
        opt_in = OptIn.find_by(subscription_id: @subscription.id, feature_id: params[:feature_id], customer_id: customer.id)
        opt_in.update(active: false)
      end
      head status: 204
    end
  end

  private

  def validate_create_params
    param! :feature_id, Integer, required: true
    param! :customers, Array, required: true do |customer|
      customer.param! :uid, String, required: true
      customer.param! :phone_number, String, required: true
      customer.param! :first_name, String
      customer.param! :last_name, String
    end
  end

  def validate_opt_out_params
    param! :feature_id, Integer, required: true
    param! :customers, Array, required: true do |customer|
      customer.param! :uid, String, required: true
      customer.param! :phone_number, String, required: true
    end
  end

  def set_subscription
    @subscription = Subscription.find_by_feature_id_and_organization_id(params[:feature_id], @organization.id)
  end

  def get_or_create_customers
    @customers = []
    customers_array = params[:customers]
    customers_array.each do |customer|
      if Customer.exists?(organization_id: @organization.id, phone: customer[:phone_number])
        @customer = Customer.find_by_organization_id_and_phone(@organization.id, customer[:phone_number])
      else
        create_new_customer(customer)
      end
      @customers << @customer
    end
  end

  def create_new_customer(customer)
    @customer = Customer.create(
        organization_id: @organization.id,
        uid: customer[:uid],
        phone: customer[:phone_number],
        first_name: customer[:first_name],
        last_name: customer[:last_name]
    )
  end

  def create_opt_ins
    @opt_ins = []
    @customers.each do |customer|
      opt_in = OptIn.create(
          subscription_id: @subscription.id,
          customer_id: customer.id,
          feature_id: @subscription.feature_id,
          completed: false
      )
      @opt_ins << opt_in
    end
  end

  def send_back_opt_in_verification_code
    construct_verification_codes_array
    post_array_to_custom_webhook_url
  end

  def construct_verification_codes_array
    @verification_codes_array = []
    @opt_ins.each do |opt_in|
      new_codes_hash = {
          customer_uid: opt_in.customer.uid,
          verification_code: opt_in.verification_code
      }
      @verification_codes_array << new_codes_hash
    end
  end

  def post_array_to_custom_webhook_url
    opt_in_verification_url = @subscription.options.opt_in_verification_url
    RestClient.post(opt_in_verification_url, @verification_codes_array.to_json) { |response, request, result, &block|
      case response.code
        when 200
          # TODO
        else
          # TODO
      end
    }
  end

  def send_opt_in_code_request_to_customer
    @opt_ins.each do |opt_in|
      puts opt_in.id
      if @organization.has_shortcode?
        Resque.enqueue(CriticalPriorityMessageSenderWithShortcode, @organization.from, opt_in.customer.phone, @subscription.options.opt_in_message, opt_in.to_descriptor_hash, @organization.id)
      else
        Resque.enqueue(CriticalPriorityMessageSender, @organization.from, opt_in.customer.phone, @subscription.options.opt_in_message, opt_in.to_descriptor_hash, @organization.id)
      end
    end
  end

end

