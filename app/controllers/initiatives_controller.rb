#coding: utf-8

class InitiativesController < ApplicationController
  
  inherit_resources
  respond_to :html, :json, :xml
  custom_actions collection: %i[sitemap]

  after_action :verify_authorized, except: %i[index sitemap]
  after_action :verify_policy_scoped, only: %i[index sitemap]
  before_action :authenticate_user!, only: %i[new]

  def index
    @initiatives = policy_scope(Initiative).order("created_at DESC")
    index!
  end

  def show
    show! { authorize @initiative }
  end

  def new
    @initiative = Initiative.new
    authorize @initiative
    @initiative.user = current_user
    @initiative.name = current_user.name
    if @initiative.save
      flash[:success] = "Iniciativa criada com sucesso! Agora é só editar :D"
      redirect_to @initiative
    else
      flash[:failure] = "Ooops. Ocorreu um erro ao criar sua iniciativa."
      redirect_to :root
    end
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
    @initiatives = policy_scope(Initiative).order("created_at DESC")
    sitemap!
  end

  private

  def permitted_params
    params.permit(initiative: [:name, :first_text, :second_text])
  end

  def initiative_params
    params.require(:initiative).permit(:name, :first_text, :second_text)
  end

end
