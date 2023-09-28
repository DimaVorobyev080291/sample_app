require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should get new" do # тест на посещения строницы user
    get signup_path
    assert_response :success
  end

  test "should redirect index when not logged in" do # тест что защищено дейсвия index
    get users_path
    assert_redirected_to login_url
  end

  test "should redirect edit when not logged in" do # тест что защищено дейсвия edit 
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do # тест что защищено действия update 
    patch user_path(@user), params: {user: { name: @user.name, email: @user.email }}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do # тест что защищено дейсвие edit 
    log_in_as(@other_user)                                    # от другова пользователя 
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do  # тест что защищено дейсвие update
    log_in_as(@other_user)                                       # от другова пользователя
    patch user_path(@user), params: {user: { name: @user.name, email: @user.email }}
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do # тест попытки удаления 
    assert_no_difference 'User.count' do               # не вошедшем пользователем 
      delete user_path (@user)
    end
    assert_response :see_other
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do # тест попытки удаления 
    log_in_as(@other_user)                                        # вошедшем пользователем 
    assert_no_difference 'User.count' do                          # не админестратором
      delete user_path (@user)
    end
    assert_response :see_other
    assert_redirected_to root_url
  end

end