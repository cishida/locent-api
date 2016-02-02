# @restful_api 1.0
#
# @property [Integer] id ID of the organization
# @property [String] email Contact email address of the organization
# @property [String] organization_name Name of the organization
# @property [User] primary_user Primary User of the organization
# @property [Array<Subscription>] subscriptions all of the organizations's subscriptions
#
# @example
#   ```json
#   {
#     "id": "1",
#     "email": "test@ordertolagos.com",
#     "organization_name": "Order To Lagos",
#     "primary_user": [User],
#     "subscriptions": [Array<Subscription>]
#   }
#   ```
class Organization < ActiveRecord::Base
  acts_as_paranoid

  before_create :set_auth_token
  has_many :users, dependent: :destroy
  has_one :primary_user, -> { where(is_primary: true) }, :class_name => "User"
  has_many :features, through: :subscriptions
  has_many :subscriptions, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :error_messages, dependent: :destroy
  has_many :campaigns, dependent: :destroy

  after_create :create_error_messages
  after_create :provision_number

  validates_presence_of :organization_name
  validates_uniqueness_of :organization_name

  def from
    if self.short_code.nil?
      return self.long_number
    else
      return self.short_code
    end
  end


  def create_error_messages
    Error.all.each do |error|
      ErrorMessage.create(
          error_id: error.id,
          message: error.default_message,
          organization_id: self.id
      )
    end
  end

  def provision_number
    @client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
    number = @client.account.incoming_phone_numbers.create(
        friendly_name: self.organization_name,
        sms_url: "http://locent-api.herokuapp.com/receive",
        sms_method: "POST",
        area_code: "709"
    )
    self.long_number = number.phone_number.to_s
    self.save
  end


  private
  def set_auth_token
    return if auth_token.present?
    self.auth_token = generate_auth_token
  end

  def generate_auth_token
    SecureRandom.uuid.gsub(/\-/, '')
  end

end
