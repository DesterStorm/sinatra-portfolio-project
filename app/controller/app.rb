require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "Tester_secret"
  end

  get '/' do
    erb :index
  end

  get '/company' do
    erb :'company/index'
  end

  get '/apply' do
    erb :'applicant/index'
  end



  helpers do
    def logged_in?
      !!session[:email] # is it not, not logged in? true or false
    end

    def login(email)
      session[:email] = params[:email]
    end

    def logout!
      session.clear
      redirect '/tests'
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end
  end
end