require 'test_helper'

class BillingControllerTest < ActionDispatch::IntegrationTest
  test "should get billing_page" do
    get billing_billing_page_url
    assert_response :success
  end

end
