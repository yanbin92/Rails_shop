require 'test_helper'

class PayTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pay_type = pay_types(:one)
  end

  test "should get index" do
    get pay_types_url
    assert_response :success
  end

  test "should get new" do
    get new_pay_type_url
    assert_response :success
  end

  test "should create pay_type" do
    assert_difference('PayType.count') do
      post pay_types_url, params: { pay_type: { name: @pay_type.name } }
    end

    assert_redirected_to pay_type_url(PayType.last)
  end

  test "should show pay_type" do
    get pay_type_url(@pay_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_pay_type_url(@pay_type)
    assert_response :success
  end

  test "should update pay_type" do
    patch pay_type_url(@pay_type), params: { pay_type: { name: @pay_type.name } }
    assert_redirected_to pay_type_url(@pay_type)
  end

  test "should destroy pay_type" do
    assert_difference('PayType.count', -1) do
      delete pay_type_url(@pay_type)
    end

    assert_redirected_to pay_types_url
  end
end
