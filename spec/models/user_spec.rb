require "rails_helper"

RSpec.describe User do
  describe "validations" do
    it { should validate_presence_of(:email)}
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password)}
    it { should have_secure_password }
    it { should validate_presence_of(:api_key) }

    it "encrypts passwords" do
      user = User.create(email: "whatever@example.com", password: "password", password_confirmation: "password", api_key: "t1h2i3s4_i5s6_l7e8g9i10t11")

      expect(user).to_not have_attribute(:password)
      expect(user).to_not have_attribute(:password_confirmation)
      expect(user.password_digest).to_not eq("password")
    end
  end

  describe "instance methods" do
    it "generates an api key" do
      user = User.new(email: "whatever@example.com", password: "password", password_confirmation: "password")

      user.generate_key
      
      user.save

      expect(user.api_key).to be_a(String)
      expect(user.api_key.length).to eq(32)
    end
  end
end