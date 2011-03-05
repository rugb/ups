module SessionHelper
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    @current_user = user
  end

  def sign_out
    cookies.delete(:remember_token)
    @current_user = nil
  end

  def set_session_language(lang)
    cookies.permanent.signed[:user_language] = lang
  end

  def get_session_language
    cookies.signed[:user_language]
  end

  def current_user
    @current_user ||= user_from_remember_token
    @current_user = User.find_by_role_id(Role.find_by_int_name(:guest).id) if @current_user.nil?

    @current_user
  end

  def signed_in?
    @current_user.present? && @current_user.id != 0
  end

  def permission_denied
    if signed_in?
      flash.now[:error] = "You aren't allowed to view this site."
      @title = "Permission denied"
      render 'errors/permission_denied'
    else
      store_location
      redirect_to session_login_path, :notice => "Please sign in to access this page."
    end
  end

  def redirect_back_or(default, options = {})
    redirect_to (session[:return_to] || default), options
    clear_return_to
  end

  private

    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end
end
