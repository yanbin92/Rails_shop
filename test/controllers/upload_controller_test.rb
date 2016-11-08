require 'test_helper'

class UploadControllerTest < ActionDispatch::IntegrationTest
  test "should get get" do
    get upload_get_url
    assert_response :success
  end

end
