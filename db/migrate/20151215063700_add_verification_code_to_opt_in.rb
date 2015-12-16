class AddVerificationCodeToOptIn < ActiveRecord::Migration
  def change
    add_column :opt_ins, :verification_code, :string
  end
end
