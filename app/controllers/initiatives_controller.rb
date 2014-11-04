#coding: utf-8

class InitiativesController < StateController
  
  inherit_resources
  actions :all, except: [:create, :edit]
  custom_actions collection: %i[sitemap]
  respond_to :html, except: [:sitemap]
  respond_to :xml, only: [:sitemap]
  respond_to :json, only: [:update, :show]

  after_action :verify_authorized, except: %i[index sitemap]
  after_action :verify_policy_scoped, only: %i[index sitemap]
  before_action :authenticate_user!, only: %i[new]

  def index
    @initiatives = policy_scope(Initiative).home_page
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
    if @initiative.save
      flash[:success] = "Unlock criado com sucesso! Agora, é só editar :D"
      redirect_to initiative_by_permalink_path(@initiative)
    else
      flash[:failure] = "Ooops. Ocorreu um erro ao criar seu Unlock."
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
    @initiatives = policy_scope(Initiative).home_page
    sitemap!
  end

  def publish
    transition_state(:publish)
  end

  def revert_to_draft
    transition_state(:revert_to_draft)
  end

  private

  def permitted_params
    params.permit(initiative: policy(@initiative || Initiative.new).permitted_attributes)
  end

  def initiative_params
    params.require(:initiative).permit(*policy(@initiative || Initiative.new).permitted_attributes)
  end

end
