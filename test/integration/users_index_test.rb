
require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end

    test "index as admin including pagination and delete links" do # список пользователей от имени
      log_in_as(@admin)                                            # администратора , пагинация и 
      get users_path                                               # ссылка на удаление 
      assert_template 'users/index'
      assert_select 'div.pagination'
      first_page_of_users = User.paginate(page: 1)
      first_page_of_users.each do |user|
        assert_select 'a[href=?]', user_path(user), text: user.name
        unless user == @admin
          assert_select 'a[href=?]', user_path(user), text: 'Удалить'
        end
      end
      assert_difference 'User.count', -1 do
        delete user_path(@non_admin)
        assert_response :see_other
        assert_redirected_to users_url
      end
    end

  test "index as non-admin" do # список пользователей без прав администратора
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

end