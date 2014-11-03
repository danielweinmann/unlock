class Initiatives::GatewaysController < ApplicationController

  inherit_resources
  actions :all, except: [:index, :show, :destroy]
  custom_actions member: %i[use_sandbox use_production revert_to_draft]
  belongs_to :initiative, parent_class: Initiative
  respond_to :html

  after_action :verify_authorized, except: %i[]
  after_action :verify_policy_scoped, only: %i[]

  # TODO implement use_production, use_sandbox and revert_to_draft

  # def use_production
  #   authorize resource
  #   if @gateway.can_use_production?
  #     @gateway.use_production!
  #   else
  #     flash[:failure] = "Ooops. Não foi possível utilizar o ambiente de produção deste"
  #   end
  #   redirect_to @initiative
  # end

end
