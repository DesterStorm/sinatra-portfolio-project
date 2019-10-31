class CompanyController < ApplicationController



  get '/companies' do
    if signed_in?
      # then find the user who's session params = to company_id
      @company = Company.find(session[:company_id])
      # finally disply the applicant list where company_id == to current_user

      @applicant = Apllicant.where(company_id: current_user)
      # binding.pry
      erb :"applicant/index.html"
    else
      redirect "/login"
    end
  end



  get '/companies/:id' do
    if logged_in?
      @company = Company.find(params[:id])
      # binding.pry
      erb :'companies/show'
    else
      redirect "/login"
    end
  end

  get "/login" do
    if logged_in?
      redirect '/applicants'
    else
      erb :"/companies/login.html"
    end
  end

  get '/companies/new' do
    if logged_in?
      redirect '/applicants'
    else
      erb :'companies/new.html'
    end
  end

  post '/login' do
    @company = Company.find_by(:name => params[:name])
    if @company && @company.authenticate(params[:password])
      session[:company_id] = @company.id
      redirect '/applicants'
    else
      redirect '/login'
    end
  end

  get '/apply' do
    erb :'applicant/index'
  end


end