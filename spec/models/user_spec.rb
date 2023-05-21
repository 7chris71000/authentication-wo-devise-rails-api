require 'rails_helper'

RSpec.describe User do
  describe "valid data" do
    it "should be valid with valid data" do
      expect(build(:user)).to be_valid
    end
  end
end