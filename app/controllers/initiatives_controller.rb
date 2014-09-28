#coding: utf-8

class InitiativesController < ApplicationController
  
  inherit_resources
  custom_actions collection: %i[sitemap]
  respond_to :html, except: [:sitemap]
  respond_to :xml, only: [:sitemap]

  after_action :verify_authorized, except: %i[index sitemap]
  after_action :verify_policy_scoped, only: %i[index sitemap]
  before_action :authenticate_user!, only: %i[new]

  def index
    @initiatives = policy_scope(Initiative).order("created_at DESC")
    index!
  end

  def show
    @initiative = Initiative.find_by_permalink(params[:id])
    @initiative = Initiative.find_by_id(params[:id]) unless @initiative
    authorize @initiative if @initiative
    show! do |format|
      format.html do
        return redirect_to initiative_by_permalink_path(params[:id]) unless request.path == "/#{params[:id]}"
      end
    end
  end

  def new
    @initiative = Initiative.new
    authorize @initiative
    @initiative.user = current_user
    @initiative.name = current_user.name
    if @initiative.save
      flash[:success] = "Unlock criado com sucesso! Agora, é só editar :D"
      redirect_to initiative_by_permalink_path(@initiative)
    else
      flash[:failure] = "Ooops. Ocorreu um erro."
      redirect_to :root
    end
  end

  def update
    authorize resource
    update!(notice: "Unlock atualizado com sucesso :D")
  end

  def destroy
    authorize resource
    destroy!(notice: "Unlock excluído com sucesso :D") { root_path }
  end

  def sitemap
    @initiatives = policy_scope(Initiative).order("created_at DESC")
    sitemap!
  end

  private

  def permitted_params
    params.permit(initiative: [:name, :first_text, :second_text, :moip_token, :moip_key, :image, :permalink, :sandbox])
  end

  def initiative_params
    params.require(:initiative).permit(:name, :first_text, :second_text, :moip_token, :moip_key, :image, :permalink, :sandbox)
  end

end
