class Api::V1::OptInsController < ApiController

  def create
    validate_create_params
    set_subscription
    get_or_create_customers
    create_opt_ins
    send_back_opt_in_verification_code
    send_opt_in_code_request_to_customer
    head status: 201
  end

  # TODO remove this method
  def test_message
    Resque.enqueue(MessageSender, '+16015644274', '+2348028618180', 'Test Locent', 'Test')
    head status: 201
  end


  private

  def validate_create_params
    param! :product_id, Integer, required: true
    param! :customers, Array, required: true do |customer|
      customer.param! :uid, String, required: true
      customer.param! :phone_number, String, required: true
      customer.param! :first_name, String
      customer.param! :last_name, String
    end
  end

  def set_subscription
    @subscription = Subscription.find_by_product_id_and_organization_id(params[:product_id], @organization.id)
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
        subscription_id: @subscription.id,
        uid: customer[:uid],
        phone: customer[:phone_number],
        first_name: customer[:first_name],
        last_name: customer[:last_name]
    )
  end

  def create_opt_ins
    @opt_ins = []
    @customers.each do |customer|
      puts "LOL"
      opt_in = OptIn.create(subscription_id: @subscription.id, customer_id: customer.id, completed: false)
      puts opt_in.errors.full_messages
      @opt_ins << opt_in
    end
  end

  def send_back_opt_in_verification_code
    opt_in_verification_url = @subscription.options.opt_in_verification_url
    verification_codes_array = []
    @customers.each do |customer|
      customer_opt_in = OptIn.find_by_subscription_id_and_customer_id(@subscription.id, customer.id)

      new_codes_hash = {
          customer_uid: customer.uid,
          verification_code: customer_opt_in.verification_code
      }
      verification_codes_array << new_codes_hash
    end

    RestClient.post(opt_in_verification_url, verification_codes_array.to_json) { |response, request, result, &block|
      case response.code
        when 200
          # TODO
        else
          # TODO
      end
    }
  end

  def send_opt_in_code_request_to_customer
    @customers.each do |recipient|
      Resque.enqueue(MessageSender, '+16015644274', recipient.phone, @subscription.options.opt_in_message, 'OptIn')
    end
  end

end

