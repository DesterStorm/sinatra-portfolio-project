class CompaniesController < ApplicationController

  get '/companies' do
    if signed_in?
      # then find the companies who's session params = company_id
      @company = Company.find(session[:company_id])
      # finally display the applicants list where company_id = to current companies

      # @companies = Company.where(company_id: current_company)
      # binding.pry
      erb :"companies/show.html"
    else
      redirect "/signin"
    end
  end
  get '/companies/:id' do
    if signed_in?
      @company = Company.find(params[:id])
      # binding.pry
      erb :'/companies/show.html'
    else
      redirect '/signin'
    end
  end
  # GET: /let the companies to go for the sign-in page --done
  get "/signin" do
    if signed_in?
      redirect '/applicants'
    else
      erb :"/companies/signin.html"
    end
  end

  # GET: /let the companies go for the sign-up page --done
  get "/signup" do
    if signed_in?
      redirect '/applicants'
    else
      erb :"/companies/new.html"
    end
  end

  # POST: /send the sign-in info to the server and let the companies to login
  post "/signin" do
    @company = Company.find_by(:name => params[:name])
    if @company && @company.authenticate(params[:password])
      session[:company_id] = @company.id
      redirect '/applicants'
    else
      redirect "/signup"
    end
  end
  #POST:/send the signup form to the server and let the companies create an account
  post "/signup" do
    # if one of the entry field is empty direct to the signup page
    if params[:name].empty? || params[:email].empty? || params[:password].empty?
      redirect "/signup"
    else
      #else create a new instance of companies using params
      # set session[:company_id] to newly created companies id
      #finally redirect the companies to the applicants list page
      # binding.pry
      @company = Company.create(:name => params[:name], :email => params[:email], :password => params[:password])
      # @companies.save
      session[:company_id] = @company.id
      redirect "/applicants"
    end
  end
  get "/signout" do
    #if the companies is logged in then clear the session and redirect to the /signin page
    #else redirect to the /index page
    if signed_in?
      session.destroy
      redirect "/signin"
    else
      redirect "/index"
    end
  end

  # GET: /companies/5 show a companies with specific id
  get "/companies/:id/edit" do
    @company = Company.find_by(id: session[:company_id])
    if @company
      erb :"/companies/edit.html"
    else
      redirect "/signin"
    end
  end
  patch '/companies/:id' do
    # binding.pry
    if signed_in?
      if params[:name].empty?
        redirect "/companies/#{params[:id]}/edit"
      else
        @company = Company.find_by_id(params[:id])
        if @company == current_company
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
      redirect '/signin'
    end
  end
end