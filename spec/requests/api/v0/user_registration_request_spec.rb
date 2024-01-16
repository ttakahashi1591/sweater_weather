require "rails_helper"

RSpec.describe "User Registration Endpoint" do
  describe "happy path" do  
    it "supports in registering a user" do
      user_params = {
          "email": "whatever@example.com",
          "password": "password",
          "password_confirmation": "password"
        }

      post "/api/v0/users", params: user_params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

      expect(response).to be_successful
      expect(response.status).to eq(201)

      response_data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response_data[:type]).to eq("user")
      expect(response_data[:id]).to be_an(String)

      expect(response_data[:attributes][:email]).to eq("whatever@example.com")
      expect(response_data[:attributes][:api_key]).to be_a(String)

      user = User.last

      expect(user.email).to eq("whatever@example.com")
      expect(user.id).to eq(response_data[:id].to_i)
      expect(user.api_key).to eq(response_data[:attributes][:api_key])
    end
  end

  describe "Sad Paths" do
    it "will return an error message if any fields are missing" do
      user_params = {
        "email": "",
        "password": "",
        "password_confirmation": ""
      }
  
      post "/api/v0/users", params: user_params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
  
      expect(response.status).to eq(400)
  
      response_data = JSON.parse(response.body, symbolize_names: true)
  
      expect(response_data).to have_key(:errors)
      expect(response_data[:errors][0]).to have_key(:detail)
      expect(response_data[:errors][0][:detail]).to eq("Validation failed: Email can't be blank, Password can't be blank")
    end
  
    it "will return an error if password and password confirmation do not match" do
      user_params = {
          "email": "whatever2@example.com",
          "password": "password",
          "password_confirmation": "NotMatchingPassword"
      }
  
      post "/api/v0/users", params: user_params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
  
      expect(response.status).to eq(400)
  
      response_data = JSON.parse(response.body, symbolize_names: true)
  
      expect(response_data).to have_key(:errors)
      expect(response_data[:errors][0]).to have_key(:detail)
      expect(response_data[:errors][0][:detail]).to eq("Validation failed: Password confirmation doesn't match Password")
    end
  
    it "will return an error if the email entered is not unique" do
      User.create(email: "whatever@example.com", password: "password", password: "password", api_key: "t1h2i3s4_i5s6_l7e8g9i10t11")
  
      user_params = {
        "email": "whatever@example.com",
          "password": "password",
          "password_confirmation": "password"
      }
  
      post "/api/v0/users", params: user_params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
  
      expect(response.status).to eq(400)
  
      response_data = JSON.parse(response.body, symbolize_names: true)
  
      expect(response_data).to have_key(:errors)
      expect(response_data[:errors][0]).to have_key(:detail)
      expect(response_data[:errors][0][:detail]).to eq("Validation failed: Email has already been taken")
    end
  end
end