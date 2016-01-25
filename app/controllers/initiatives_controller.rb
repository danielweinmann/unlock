class InitiativesController < StateController
  
  before_action :set_initiative, except: %i[index new sitemap home]

  respond_to :html, except: [:sitemap]
  respond_to :xml, only: [:sitemap]
  respond_to :json, only: [:update, :show]

  after_action :verify_authorized, except: %i[home index sitemap]
  after_action :verify_policy_scoped, only: %i[home index sitemap]
  before_action :authenticate_user!, only: %i[new]

  has_scope :most_funded, type: :boolean
  has_scope :more_contributions, type: :boolean
  has_scope :recently_updated, type: :boolean
  before_action :set_scope, only: %i[index]

  def home
    @initiatives = policy_scope(Initiative).with_state(:published)
    @most_funded = @initiatives.most_funded.limit(3)
    @more_contributions = @initiatives.more_contributions.not_in(@most_funded).limit(3)
    @recently_updated = @initiatives.recently_updated.not_in(@most_funded, @more_contributions).limit(3)
    respond_with @initiatives
  end

  def index
    @initiatives = apply_scopes(policy_scope(Initiative).with_state(:published))
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

  def update_states_from_gateways
    authorize @initiative
    @initiative.update_states_from_gateways!
    flash[:notice] = t('flash.actions.update.notice', resource_name: @initiative.class.model_name.human)
    respond_with @initiative
  end

  private

  def initiative_params
    params.require(:initiative).permit(*policy(@initiative || Initiative.new).permitted_attributes)
  end

  def set_initiative
    @initiative ||= Initiative.find_by_permalink(params[:id])
    @initiative ||= Initiative.find(params[:id])
  end

  def set_scope
    return unless params[:scope]
    params[params[:scope].to_sym] = true
  end

  def allow_default_locales?
    return false unless params[:id]
    set_initiative
    policy(@initiative).update?
  end

end
