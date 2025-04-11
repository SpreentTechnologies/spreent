require "test_helper"

class InvitationCodesControllerTest < ActionDispatch::IntegrationTest
  test "should validate code" do
    post invitation_codes, params: { code: 'BRUNY2025' }
  end
end
