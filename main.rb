require 'bcrypt'
require 'bundler'
Bundler.require(:default, ENV['RACK_ENV'])

DataMapper.setup(:default, ENV['DATABASE_URL'])

class User
  include(DataMapper::Resource)
  include(BCrypt)

  property(:id, Serial, key: true)
  property(:username, String, length: 3..50)
  property(:first_name, String)
  property(:last_name, String)
  property(:password, BCryptHash)

  def name
    "#{first_name} #{last_name}"
  end
end

set :sessions => true

register {
  def has_any_role?(*roles)
    condition do
      redirect '/login' unless has_session?
    end
  end
}

helpers {
  def display_view(template, model={})
    erb(template, locals: model)
  end

  def has_session?
    @user != nil
  end
}

before {
  @user = User.get(session[:user_id])
}

get('/') {
  display_view(:index)
}

get('/protected', has_any_role?: [:user]) {
  display_view(:protected)
}

get('/login') {
  if has_session?
    redirect '/'
  else
    display_view(:login)
  end
}
post('/login') {
  user = User.first(username: params[:username])
  if user && user.password == params[:password]
    session[:user_id] = user.id
    redirect '/'
  else
    redirect '/login'
  end
}

get('/register') {
  display_view(:register)
}
post('/register') {
  user = User.new
  user.username = params[:username]
  user.password = params[:password]
  user.save
  
  user = User.first(username: params[:username])
  if user
    session[:user_id] = user.id
    redirect '/'
  else
    redirect '/register'
  end
}

get('/logout') {
  session[:user_id] = nil
  redirect '/'
}

DataMapper.finalize
DataMapper.auto_upgrade!