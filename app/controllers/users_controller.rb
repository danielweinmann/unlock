#coding: utf-8

class UsersController < ApplicationController
  
  inherit_resources
  actions :none
  custom_actions member: %i[my_contributions my_initiatives]
  respond_to :html

  after_action :verify_authorized, except: %i[]
  after_action :verify_policy_scoped, only: %i[]
  before_action :authenticate_user!, only: %i[my_contributions]
  
  def my_contributions
    params[:id] = current_user.id
    authorize resource
  end

  def my_initiatives
    params[:id] = current_user.id
    authorize resource
  end

end
