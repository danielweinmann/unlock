class InitiativesController < StateController
  
  before_action :set_initiative, except: %i[index new sitemap]

  respond_to :html, except: [:sitemap]
  respond_to :xml, only: [:sitemap]
  respond_to :json, only: [:update, :show]

  after_action :verify_authorized, except: %i[index sitemap]
  after_action :verify_policy_scoped, only: %i[index sitemap]
  before_action :authenticate_user!, only: %i[new]

  def index
    @initiatives = policy_scope(Initiative).home_page
    return redirect_to :root unless request.path == "/#{params[:locale]}"
    respond_with @initiatives
  end

  def show
    authorize @initiative
    unless request.path.match(/\A\/#{params[:locale]}\/#{@initiative.to_param}(\.\w+)?\z/)
      format = request.format.symbol
      return redirect_to initiative_by_permalink_path("#{@initiative.to_param}#{".#{format}" unless format == :html}")
    end
    respond_with @initiative
  end

  def new
    @initiative = Initiative.new
    authorize @initiative
    @initiative.user = current_user
    resource_name = @initiative.class.model_name.human
    if @initiative.save
      flash[:notice] = t('flash.actions.create.notice', resource_name: resource_name)
      redirect_to initiative_by_permalink_path(@initiative)
    else
      flash[:alert] = t('flash.actions.create.alert', resource_name: resource_name)
      redirect_to :root
    end
  end

  def edit
    authorize @initiative
    @initiative.disable_fallback
  end

  def update
    authorize @initiative
    @initiative.update(initiative_params)
    respond_with @initiative
  end

  def destroy
    authorize @initiative
    @initiative.destroy
    respond_with @initiative
  end

  def sitemap
    @initiatives = policy_scope(Initiative).home_page
    respond_with @initiatives
  end

  def publish
    transition_state(@initiative, :publish)
  end

  def revert_to_draft
    transition_state(@initiative, :revert_to_draft)
  end

  private

  def initiative_params
    params.require(:initiative).permit(*policy(@initiative || Initiative.new).permitted_attributes)
  end

  def set_initiative
    @initiative ||= Initiative.find_by_permalink(params[:id])
    @initiative ||= Initiative.find(params[:id])
  end

  def allow_default_locales?
    return false unless params[:id]
    set_initiative
    policy(@initiative).update?
  end

end
