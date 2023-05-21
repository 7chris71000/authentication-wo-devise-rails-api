require "rails_helper"

RSpec.describe Item do
  describe "valid data" do
    it "should be valid with valid data" do
      expect(build(:item)).to be_valid
    end
  end 
end