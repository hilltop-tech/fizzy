require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "destroy" do
    sign_in_as :kevin

    delete session_path

    assert_redirected_to Launchpad.logout_url
    assert_not cookies[:session_token].present?
  end

  test "new" do
    get new_session_path

    assert_response :forbidden
  end

  test "create" do
    post session_path, params: { email_address: "david@37signals.com", password: "secret123456" }

    assert_response :forbidden
  end
end
