require 'test_helper'

class DnsCheckerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dns_checker_index_url
    assert_response :success
  end

  test "should get check" do
    get dns_checker_check_url
    assert_response :success
  end

end
