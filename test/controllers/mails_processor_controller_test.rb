require 'test_helper'

class MailsProcessorControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get mails_processor_home_url
    assert_response :success
  end

  test "should get import" do
    get mails_processor_import_url
    assert_response :success
  end

  test "should get exclude" do
    get mails_processor_exclude_url
    assert_response :success
  end

  test "should get download" do
    get mails_processor_download_url
    assert_response :success
  end

end
