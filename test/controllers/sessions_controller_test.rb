require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  if Rails.application.config.x.local_authentication
    test "destroy" do
      sign_in_as :kevin

      delete session_path

      assert_redirected_to new_session_path
      assert_not cookies[:session_token].present?
    end

    test "new" do
      get new_session_path

      assert_response :success
    end

    test "create with valid credentials" do
      post session_path, params: { email_address: "david@37signals.com", password: "secret123456" }

      assert_redirected_to root_path
      assert cookies[:session_token].present?
    end

    test "create with invalid credentials" do
      post session_path, params: { email_address: "david@37signals.com", password: "wrong" }

      assert_redirected_to new_session_path
      assert_not cookies[:session_token].present?
    end
  end
end
