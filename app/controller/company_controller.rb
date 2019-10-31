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

  # GET: /let the company go to the login page
  get "/login" do
    if logged_in?
      redirect '/applicants'
    else
      erb :"/companies/login.html"
    end
  end

  # GET: /let the company go to the company profile creation page
  get '/companies/new' do
    if logged_in?
      redirect '/applicants'
    else
      erb :'companies/new.html'
    end
  end

  # POST /send the login info to the server and let the company login
  post '/login' do
    @company = Company.find_by(:name => params[:name])
    if @company && @company.authenticate(params[:password])
      session[:company_id] = @company.id
      redirect '/applicants'
    else
      redirect '/companies/new'
    end
  end

  #POST:/send the /companies/new info to the server + let the company create an account
  post "/companies/new" do
    # if even one field is empty direct to the companies/new page
    if params[:name].empty? || params[:email].empty? || params[:password].empty?
      redirect "/companies/new"
    else
      #else create a new instance of company using params
      # set session[:company_id] to newly created company id
      #finally redirect the user to the applicant list page
      # binding.pry
      @company = Company.create(:name => params[:name], :email => params[:email], :password => params[:password])
      # @company.save
      session[:company_id] = @company.id
      redirect "/applicants"
    end
  end

  get "/logout" do
    #if the company is logged in then clear the session and redirect to the /login page
    #else redirect to the /index page
    if logged_in?
      session.destroy
      redirect "/login"
    else
      redirect "/index"
    end
  end

  # GET: /companies/# show a user with specific id
  get "/users/:id/edit" do
    @company = Company.find_by(id: session[:company_id])
    if @company
      erb :"/companies/edit.html"
    else
      redirect "/login"
    end
  end

  patch '/companies/:id' do
    # binding.pry
    if logged_in?
      if params[:name].empty?
        redirect "/companies/#{params[:id]}/edit"
      else
        @company = Company.find_by_id(params[:id])
        if @company == current_user
          if @company.update(:name => params[:name], :email => params[:email])
            redirect to "/companies/#{@company.id}"
          else
            redirect to "/companies/#{@company.id}/edit"
          end
        else
          redirect to '/companies'
        end
      end
    else
      redirect '/login'
    end
  end


end