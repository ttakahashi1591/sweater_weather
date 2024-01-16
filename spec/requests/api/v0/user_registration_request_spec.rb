require "rails_helper"

RSpec.describe "User Registration Endpoint" do
  it "supports in registering a user" do
    user_params = {
        "email": "whatever@example.com",
        "password": "password",
        "password_confirmation": "password"
      }

    post "/api/v0/users", params: user_params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

    expect(response).to be_successful
    expect(response.status).to eq(201)

    response = JSON.parse(response.body, symbolize_names: true)[:response]

    expect(response[:type]).to eq("user")
    expect(response[:id]).to be_an(String)
    expect(response[:attributes][:email]).to eq("whatever@example.com")
    expect(response[:attributes][:api_key]).to be_a(String)

    user = User.last

    expect(user.email).to eq("whatever@example.com")
    expect(user.id).to eq(response[:id])
    expect(user.api_key).to eq(response[:attributes][:api_key])
  end
end