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

register do
  def has_any_role?(*roles)
    condition do
      redirect '/login' unless has_session?
    end
  end
end

helpers do
  def display_view(template, model={})
    erb(template, locals: model)
  end

  def has_session?
    @user != nil
  end
end

before do
  @user = User.get(session[:user_id])
end

get('/') do
  ee = User.new
  ee.first_name = 'Michel'
  ee.last_name = 'Henrich'
  display_view(:index)
end

get('/protected', has_any_role?: [:user]) do
  display_view(:protected)
end

get('/login') do
  if has_session?
    redirect '/'
  else
    display_view(:login)
  end
end
post('/login') do
  user = User.first(username: params[:username])
  if user && user.password == params[:password]
    session[:user_id] = user.id
    redirect '/'
  else
    redirect '/login'
  end
end
get('/logout') {
  session[:user_id] = nil
  redirect '/'
}

DataMapper.finalize
DataMapper.auto_upgrade!