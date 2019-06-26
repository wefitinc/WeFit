require 'test_helper'

class TermsOfUseControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get terms_of_use_index_url
    assert_response :success
  end

end
