class ApplicantsController < ApplicationController
# GET: /applicants asking the server for the data in applicants -- done
#   binding.pry
  get "/applicants" do
    # binding.pry
    # if the company is logged in?
    if logged_in?
      # then find the company who's session params = to company_id
      @company = Company.find(session[:company_id])
      # finally disply the applicant list where company_id = to current company

      @applicants = Applicant.where(company_id: current_company)
      # binding.pry
      erb :"applicant/index"
    else
      redirect "/companies/login"
    end
  end
  # binding.pry
  # GET: /applicants/new -- done
  get "/applicants/new" do
    if logged_in?
      @company = Company.find_by(id: session[:company_id])
      erb :"applicants/new.html"
    else
      redirect "/companies/login"
    end
  end
  # binding.pry
  # POST: /applicants --- done
  post "/applicants" do
    if logged_in?
      @company = Company.find(session[:company_id])
      # binding.pry

      if params[:position].empty?
        redirect "/applicants/new"
      else
        @company = Company.find_by(:id => session[:company_id])
        # create new instance of applicant
        @applicant = Applicant.new
        # set the name of position
        @applicant.position = params[:position]
        # finally save it
        @applicant.company_id = @company.id
        @applicant.save

        # applicant = Applicant.create(position: params[:position], company_id: @company.id)
        # redirect to the show page, HTTP is stateless means instance variable in one action
        # will ever never relates to instance variable in another action
        # ser the applicant id to the propeer one
        redirect "/applicants"
      end
    else
      redirect "/companies/login"
    end
  end

  # binding.pry
  get '/applicants/:id' do
    if logged_in?
      # @company = Company.find_by(id: session[:company_id])
      @applicant = Applicant.find(params[:id])
      if @applicant && @applicant.company == current_company
        # binding.pry
        erb :'/applicants/show.html'
      else
        redirect "/companies/login"
      end
    else
      redirect '/companies/login'
    end
  end

  # binding.pry
  # GET: /applicants/5
  get "/applicants/:id/edit" do
    @company = Company.find_by(id: session[:company_id])
    @applicant = Applicant.find(params[:id])
    if @applicant && @applicant.company == current_company

      # there is no relation between this line and line 37 it just bcz of redirecting due to design
      # those two values are the end up equals
      erb :"/applicants/edit.html"
    else
      redirect "/applicants"
    end
  end
  patch '/applicants/:id' do
    if logged_in?
      if params[:position].empty?
        redirect "/applicants/#{params[:id]}/edit"
      else
        @applicant = Applicant.find_by_id(params[:id])
        if @applicant && @applicant.company == current_company
          if @applicant.update(:position => params[:position])
            redirect to "/applicants/#{@applicant.id}"
          else
            redirect to "/applicants/#{@applicant.id}/edit"
          end
        else
          redirect to '/applicants'
        end
      end
    else
      redirect '/companies/login'
    end
  end

  # binding.pry

  delete '/applicants/:id/delete' do
    if logged_in?
      @company = Company.find_by(id: session[:company_id]) if session[:company_id]
      @applicant = Applicant.find_by_id(params[:id])
      # binding.pry
      if @applicant && @applicant.company == current_company
        @applicant.delete
        redirect '/applicants'
      end
    else
      redirect to '/login'
    end
  end
  # binding.pry
end