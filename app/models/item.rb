class Item < ApplicationRecord
  include EncodingHelpers

  before_create :check_for_password_and_encrypt_values, if: :encrypted_value_changed?
  attr_accessor :encrypt_password

  ENCRYPTABLE_ATTRIBUTES = [
    "description",
  ]

  private

  def check_for_password_and_encrypt_values
    if encrypt_password.present? && self.changes.present?
      ENCRYPTABLE_ATTRIBUTES.intersection(self.changes.keys).each do |attribute_changed|
        encrypted = encrypt_values(attribute_changed)
        self.send("#{attribute_changed}=", encrypted)
      end
    else
      throw :abort
    end
  end

  def encrypted_value_changed?
    ENCRYPTABLE_ATTRIBUTES.each do |value|
      return true if self.send("#{value}_changed?")
    end
    return false
  end
end
