require 'test_helper'

class SearchControllerTest < ActionDispatch::IntegrationTest
  test "should get email_search" do
    get search_email_search_url
    assert_response :success
  end

end
