class UsersController < ApplicationController
  
  before_action :set_user

  respond_to :html

  after_action :verify_policy_scoped, only: %i[]
  before_action :authenticate_user!
  
  def my_contributions
    authorize @user
    respond_with @user
  end

  def my_initiatives
    authorize @user
    respond_with @user
  end

  def set_locale(new_locale)
    if self.locale != new_locale
      self.update locale: new_locale
    end
  end

  private

  def set_user
    @user = current_user
  end

end
