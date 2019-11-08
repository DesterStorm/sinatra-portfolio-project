require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "applicant_secret"
  end

  get "/" do
    erb :index
  end

  helpers do
    def signed_in?
      !!current_company
    end

    def current_company
      @current_company ||= Company.find_by(id: session[:company_id]) if session[:company_id]
    end
  end
end