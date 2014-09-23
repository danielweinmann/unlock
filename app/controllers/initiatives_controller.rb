#coding: utf-8

class InitiativesController < ApplicationController
  
  inherit_resources
  respond_to :html, :json, :xml
  custom_actions collection: %i[sitemap]

  after_action :verify_authorized, except: %i[index sitemap]
  after_action :verify_policy_scoped, only: %i[index sitemap]
  before_action :authenticate_user!, only: %i[new]

  def index
    @initiatives = policy_scope(Initiative)
    index!
  end

  def show
    show! { authorize @initiative }
  end

  def new
    new! { authorize @initiative }
  end

  def create
    @initiative = Initiative.new(initiative_params)
    @initiative.user = current_user
    authorize @initiative
    create!(notice: "Iniciativa criada com sucesso! Agora é só compartilhar :D")
  end

  def update
    authorize resource
    update!(notice: "Iniciativa atualizada com sucesso :D")
  end

  def destroy
    authorize resource
    destroy!(notice: "Iniciativa excluída com sucesso :D") { root_path }
  end

  def sitemap
    @initiatives = policy_scope(Event)
    sitemap!
  end

  private

  def permitted_params
    params.permit(initiative: [:name])
  end

  def event_params
    params.require(:event).permit(:name)
  end

end
