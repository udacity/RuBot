class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :status]

  # GET /users
  # GET /users.json
  def index
    @users = User.all.order(:user_name)
  end

  def index2
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  def status
    @user.check_enrollment_status(@user)
    redirect_to @user
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:user_name, :real_name, :slack_id, :email, :pic)
    end
end
