require('bundler')
Bundler.require(:default, ENV['RACK_ENV'])
require('./records')
require('./use_cases')
require('./session')

class Main < Sinatra::Application
  set(sessions: true)

  register {
    def has_any_role?(*roles)
      condition { redirect('/login') unless @session.exists? }
    end
  }

  helpers {
    def display_view(template, model={})
      erb(template, locals: model)
    end
  }

  before {
    @session ||= Session.new(self)
    @session.refresh
  }

  get('/') {
    display_view(:index)
  }

  get('/protected', has_any_role?: [:user]) {
    display_view(:protected)
  }

  get('/login') {
    redirect('/') if @session.exists?
    display_view(:login)
  }
  post('/login') {
    LoginUseCase.new(params[:username], params[:password], @session).execute
  }

  get('/register') {
    display_view(:register)
  }
  post('/register') {
    RegisterUseCase.new(params[:username], params[:password], @session).execute
  }

  get('/logout') {
    @session.clear
  }
end