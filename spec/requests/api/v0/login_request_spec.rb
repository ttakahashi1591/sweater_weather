require "rails_helper"

RSpec.describe "User Login Endpoint" do
  before(:each) do
    @user = User.create(email: "whatever@example.com", password: "password", password_confirmation: "password", api_key: "t1h2i3s4_i5s6_l7e8g9i10t11")
  end

  describe "Happy Path" do
    it "supports with a user loggin in" do
      user_params = {
        "email": "whatever@example.com",
        "password": "password"
      }

      post "/api/v0/sessions", params: user_params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

      expect(response).to be_successful
      expect(response.status).to eq(200)

      data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(data).to have_key(:type)
      expect(data[:type]).to eq("user")
      expect(data).to have_key(:id)
      expect(data[:id].to_i).to eq(@user.id)
      expect(data).to have_key(:attributes)
      expect(data[:attributes]).to have_key(:email)
      expect(data[:attributes][:email]).to eq("whatever@example.com")
      expect(data[:attributes]).to have_key(:api_key)
      expect(data[:attributes][:api_key]).to eq("t1h2i3s4_i5s6_l7e8g9i10t11")
    end
  end

  describe "Sad Paths" do
    it "will return an error if credentials are invalid (incorrect password)" do
      user_params = {
        "email": "whatever@example.com",
        "password": "invalid_password"
      }

      post "/api/v0/sessions", params: user_params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

      expect(response.status).to eq(401)

      message = JSON.parse(response.body, symbolize_names: true)

      expect(message).to eq({message: "Your credentials are invalid"})
    end

    it "will return an error if credentials are invalid (incorrect email)" do
      user_params = {
        "email": "invalid_email",
        "password": "password"
      }

      post "/api/v0/sessions", params: user_params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

      expect(response.status).to eq(401)

      message = JSON.parse(response.body, symbolize_names: true)

      expect(message).to eq({message: "Your credentials are invalid"})
    end

    it "returns an error if fields left blank" do
      user_params = {
        "email": "",
        "password": ""
      }

      post "/api/v0/sessions", params: user_params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

      expect(response.status).to eq(401)

      message = JSON.parse(response.body, symbolize_names: true)

      expect(message).to eq({message: "Your credentials are invalid"})
    end
  end
end