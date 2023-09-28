module SessionsHelper

  def log_in(user)  # Осуществляет вход данного пользователя.
   session[:user_id] = user.id
   session[:session_token] = user.session_token
  end

  def remember(user) # Запоминает пользователя в постоянную сессию.
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user # Возвращает пользователя, соответствующего remember-токену в куки.
    if (user_id = session[:user_id])
       user = User.find_by(id: user_id)
      if user && session[:session_token] == user.session_token
        @current_user = user
      end
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
 
  def current_user?(user) # Возвращает значение true, если данный пользователь является текущим 
    user && user == current_user
  end

  def logged_in? # Возвращает true, если пользователь вошел, иначе false.
   !current_user.nil?
  end

  def forget(user) # Забывает постоянную сессии.
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out # Осуществляет выход текущего пользователя.
    forget(current_user)
    reset_session
    @current_user = nil
  end

  def store_location # Сохраняет запрошенный URL.
    session[:forwarding_url] = request.original_url if request.get?
  end

end
