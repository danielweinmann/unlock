class Initiatives::GatewaysController < ApplicationController

  inherit_resources
  actions :all, except: [:index, :show, :destroy]
  belongs_to :initiative, parent_class: Initiative
  respond_to :html

  after_action :verify_authorized, except: %i[]
  after_action :verify_policy_scoped, only: %i[]

end
