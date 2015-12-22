class Api::V1::OptInsController < ApiController

  def create
    param! :product_id, Integer, required: true
    param! :customer_phone_number, String, required: true
    param! :customer_first_name, String, required: true
    param! :customer_last_name, String

    subscription = Subscription.find(product_id: params[:product_id], organization_id: @organization.id)
    get_or_create_customer

    @opt_in = OptIn.new
    @opt_in.subscription = subscription
    @opt_in.customer = @customer

    if @opt_in.save
      render json: @opt_in, status: 201, location: [:api, @opt_in]
      send_back_opt_in_verification_code
      send_opt_in_code_request_to_customer
    else
      render json: {errors: @opt_in.errors.full_messages}, status: 422
    end
  end

  def test_message
    Resque.enqueue(MessageSender, "+16015644274", "+2348028618180", "Holla at me")
  end


  private

  def get_or_create_customer
    if Customer.exists?(organization_id: @organization.id, phone: params[:customer_phone_number])
      @customer = Customer.find(organization_id: @organization.id, phone: params[:customer_phone_number])
    else
      create_new_customer
    end
  end

  def create_new_customer
    @customer = Customer.create(
        organization_id: @organization.id,
        phone: params[:customer_phone_number],
        first_name: params[:customer_first_name],
        last_name: params[:customer_last_name]
    )
  end

  def send_back_opt_in_verification_code
    opt_in_verification_url = @opt_in.subscription.options.opt_in_verification_url
    RestClient.post(opt_in_verification_url, :verification_code => @opt_in.verification_code){ |response, request, result, &block|
      case response.code
        when 200
          # TODO
        else
          # TODO
      end
    }
  end

  def send_opt_in_code_request_to_customer
    
  end

end