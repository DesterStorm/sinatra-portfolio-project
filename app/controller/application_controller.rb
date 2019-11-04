require './config/environment'

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "demo_lv"
  end

  get '/' do
    erb :index
  end

  helpers do
    def logged_in?
      !!session[:email] # is it not, not logged in? true or false
    end

    def companies_login(email)
      session[:email] = params[:email]
    end

    def companies_logout!
      session.clear
      redirect "/companies/login"
    end

    def current_user
      @current_user ||= Company.find_by(id: session[:company_id]) if session[:company_id]
    end
  end
end