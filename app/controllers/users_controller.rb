# frozen_string_literal: true

# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def new
  end

  def create
    @new_user = User.create(user_params)

    if @new_user.valid?
      if @new_user.save
        redirect_to user_path(@new_user.id)
        flash[:success] = 'User Created'
      end
    else
      redirect_to register_path
      flash[:errors] = @new_user.errors.full_messages.join(', ')
    end
  end

  def show
    @user = User.find(params[:id])
   end

  private

  def user_params
    params.permit(
      :name,
      :email
    )
  end
end
