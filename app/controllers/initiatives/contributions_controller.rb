class Initiatives::ContributionsController < ApplicationController

  before_action :set_initiative
  before_action :set_contribution, only: %i[update show]

  respond_to :html, except: [:update]
  respond_to :json, only: [:index, :update, :show]

  after_action :verify_authorized, except: %i[index]
  after_action :verify_policy_scoped, only: %i[index]
  before_action :authenticate_user!, only: %i[new]

  def index
    @contributions = policy_scope(Contribution).where(initiative: @initiative).visible
    # This will instantiate UserDecorator for the users
    @users = @contributions.map &:user
    respond_with @contributions
  end
  
  def new    
    @contribution = @initiative.contributions.new
    @gateways = @initiative.gateways.without_state(:draft).ordered
    @contribution.gateway = @gateways.first
    @contribution.user = current_user
    authorize @contribution
    respond_with @contribution
  end
  
  def update
    authorize @contribution
    @contribution.update(contribution_params)
    respond_with @contribution, location: -> { initiative_path(@initiative.id) }
  end

  def show
    authorize @contribution
    @user = @contribution.user
    respond_with @contribution
  end

  private

  def set_initiative
    @initiative = Initiative.find(params[:initiative_id])
  end

  def set_contribution
    @contribution = @initiative.contributions.find(params[:id])
  end

  def contribution_params
    params.require(:contribution).permit(*policy(@contribution || Contribution.new).permitted_attributes)
  end

end
