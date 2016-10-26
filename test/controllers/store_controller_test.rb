require 'test_helper'

class StoreControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
  	#一静态测试中的数据为准 
    get store_index_url
    assert_response :success
    assert_select '#columns #side a',minimun:4
    assert_select '#main .entry',3
    assert_select 'h3','Programming Ruby 1.9'
    assert_select '.price',/\$[,\d]+\.\d\d/
  end

end
