require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    # get 方法发起请求，并把结果传入响应中。这个方法可接受 6 个参数：

    # 所请求控制器的动作，可使用字符串或符号。

    # params：一个选项散列，指定传入动作的请求参数（例如，查询字符串参数或文章变量）。

    # headers：设定随请求发送的首部。

    # env：按需定制请求环境。

    # xhr：指明是不是 Ajax 请求；设为 true 表示是 Ajax 请求。

    # as：使用其他内容类型编码请求；默认支持 :json。

    # 所有关键字参数都是可选的。
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: { name: "adele", password: 'secret', password_confirmation: 'secret' } }
    end

    assert_redirected_to users_url
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { name: @user.name, password: 'secret', password_confirmation: 'secret' } }
    assert_redirected_to users_url
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
end
