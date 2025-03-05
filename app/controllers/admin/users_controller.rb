class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource 
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /admin/users or /admin/users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html 
      format.json { render json: @users } 
    end
  end

  # GET /admin/users/:id or /admin/users/:id.json
  def show
    respond_to do |format|
      format.html 
      format.json { render json: @user } 
    end
  end

  # GET /admin/users/new
  def new
    @user = User.new 
  end

  # GET /admin/users/:id/edit
  def edit
  end

  # POST /admin/users or /admin/users.json
  def create
    @user = User.new(user_params) 

    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_user_path(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/users/:id or /admin/users/:id.json
  def update
    respond_to do |format|
      if @user.update(user_params) 
        format.html { redirect_to admin_user_path(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/users/:id or /admin/users/:id.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to admin_users_path, notice: "User was successfully destroyed." } 
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.find(params[:id]) 
  end

  def user_params 
    params.require(:user).permit(:email, :password, :password_confirmation, :admin) 
  end
end