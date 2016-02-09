class Session
  def initialize(application)
    @application = application
  end

  def refresh
    @user = ReadUserUseCase.new(@application.session[:user_id]).execute
  end

  def exists?
    @user != nil
  end

  def clear
    @application.session[:user_id] = nil
    @application.redirect('/')
  end

  def registered_successfully(id)
    @application.session[:user_id] = id
    @application.redirect('/')
  end

  def logged_in_successfully(id)
    @application.session[:user_id] = id
    @application.redirect('/')
  end

  def registration_failed
    @application.redirect('/register')
  end

  def login_failed
    @application.redirect('/login')
  end
end