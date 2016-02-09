class ReadUserUseCase
  def initialize(id)
    @id = id
  end

  def execute
    UserRecord.get(@id)
  end
end

class LoginUseCase
  def initialize(username, password, receiver)
    @username = username
    @password = password
    @receiver = receiver
  end

  def execute
    user = UserRecord.find(username: @username).first
    if user.password == @password
      @receiver.logged_in_successfully(user.id)
    else
      @receiver.login_failed
    end
  end
end

class RegisterUseCase
  def initialize(username, password, receiver)
    @username = username
    @password = password
    @receiver = receiver
  end

  def execute
    user = UserRecord.new
    user.username = @username
    user.password = @password
    if user.save
      @receiver.registered_successfully(user.id)
    else
      @receiver.registration_failed
    end
    self
  end
end