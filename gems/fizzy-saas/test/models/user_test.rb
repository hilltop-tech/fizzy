require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "deactivate clears signal user" do
    users(:jz).deactivate

    assert_nil users(:jz).reload.signal_user
  end
end
