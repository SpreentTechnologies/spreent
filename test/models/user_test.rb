require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should save a new user" do
    
  end

  test "should not save without an email" do
    @user = User.new(email: "test@example.com")
    assert_not @user.valid?
  end

  test "name should be present" do
  end

  test "password should be present" do
  end
  
  test "password should be at least 6 characters" do
  end
end
