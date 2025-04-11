require "test_helper"

class InvitationCodeTest < ActiveSupport::TestCase
  test "should save an invitation code" do
    @invitation_code = InvitationCode.new(code: "test")
    assert @invitation_code.valid?
  end

  test "should not save without a code" do
    @invitation_code = InvitationCode.new
    assert_not @invitation_code.valid?
  end

  test "should be unique" do
    @invitation_code = InvitationCode.new(code: "BRUNY2025")
    assert_not @invitation_code.valid?
  end
end
