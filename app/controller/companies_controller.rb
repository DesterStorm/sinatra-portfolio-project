class CompaniesController < ApplicationController

  # GET: /let the company go to the company profile creation page
  get '/companies/new' do
    if logged_in?
      redirect '/applicants'
    else
      erb :'company/new.html'
    end
  end

  #POST:/send the /companies/new info to the server + let the company create an account
  post '/companies/new' do
    # if even one field is empty direct to the companies/new page
    if params[:company_name].empty? || params[:email].empty? || params[:password].empty?
      redirect '/companies/new'
    else
      #else create a new instance of company using params
      # set session[:company_id] to newly created company id
      #finally redirect the user to the applicant list page
      # binding.pry
      @company = Company.create(:company_name => params[:company_name], :email => params[:email], :password => params[:password])
      # @company.save
      session[:company_id] = @company.id
      redirect '/applicants'
    end
  end

  # GET: /let the company go to the login page
  get '/companies/login' do
    if logged_in?
      redirect '/applicants'
    else
      erb :'company/login.html'
    end
  end

  # POST /send the login info to the server and let the company login
  post '/companies/login' do
    @company = Company.find_by(:name => params[:company_name])
    if @company && @company.authenticate(params[:password])
      session[:company_id] = @company.id
      redirect '/applicants'
    else
      redirect '/companies/new'
    end
  end

  get '/companies' do
    if logged_in?
      # then find the user who's session params = to company_id
      @company = Company.find(session[:company_id])
      # finally display the applicant list where company_id == to current_user
      @applicant = Apllicant.where(company_id: current_user)
      # binding.pry
      erb :'applicant/index'
    else
      redirect '/companies/login'
    end
  end

  get '/companies/:id' do
    if logged_in?
      @company = Company.find(params[:id])
      # binding.pry
      erb :'company/show'
    else
      redirect '/companies/login'
    end
  end


  get '/companies/logout' do
    #if the company is logged in then clear the session and redirect to the /companies/login page
    #else redirect to the /index page
    if logged_in?
      session.destroy
      redirect '/companies/login'
    else
      redirect '/companies/login'
    end
  end

  # GET: /companies/# show a user with specific id
  get '/companies/:id/edit' do
    @company = Company.find_by(id: session[:company_id])
    if @company
      erb :'company/edit'
    else
      redirect '/companies/login'
    end
  end

  patch '/companies/:id' do
    # binding.pry
    if logged_in?
      if params[:company_name].empty?
        redirect "/companies/#{params[:id]}/edit"
      else
        @company = Company.find_by_id(params[:id])
        if @company == current_user
          if @company.update(:company_name => params[:company_name], :email => params[:email])
            redirect to "/companies/#{@company.id}"
          else
            redirect to "/companies/#{@company.id}/edit"
          end
        else
          redirect to '/companies'
        end
      end
    else
      redirect '/companies/login'
    end
  end
end