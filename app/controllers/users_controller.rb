class UsersController < ApplicationController
  before_action :authorize, except: [:new, :login, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  def index
    if @current_user.admin?
      @users = User.regulars
    else
      render :welcome
    end
  end

  def login
    if request.post?
      email, pass = params[:email].strip, params[:pass].strip
      user = User.find_by_email email
      if user.nil?
        flash[:email] = true
      elsif user.check_password(pass)
        session[:UID] = user.id
        redirect_to action: :index
      else
        flash[:pass] = true
        redirect_to action: :login
      end
    end
  end

  def logout
    session[:UID] = nil
    redirect_to login_path
  end

  # GET /users/1
  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: 'report', layout: 'user_details.html.erb'
      end
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new user_params

    if @user.save
      redirect_to @user
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update user_params
      redirect_to @user
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_path
  end

  private
    def authorize
      @current_user = User.find_by_id session[:UID]
      redirect_to login_path unless @current_user.present?
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:email, :full_name, :birthday, :bio, :password, :password_confirmation, :logo)
    end
end
