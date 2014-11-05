class Initiatives::ContributionsController < ApplicationController

  inherit_resources
  actions :all, except: [:edit, :create, :destroy]
  belongs_to :initiative, parent_class: Initiative
  respond_to :html, except: [:update]
  respond_to :json, only: [:index, :update, :show]

  after_action :verify_authorized, except: %i[index]
  after_action :verify_policy_scoped, only: %i[index]
  before_action :authenticate_user!, only: %i[new]

  def index
    @initiative = Initiative.find(params[:initiative_id])
    @contributions = policy_scope(Contribution).where(initiative: parent).visible
    # This will instantiate UserDecorator for the users
    @users = @contributions.map &:user
  end
  
  def new    
    new! do
      @gateways = @initiative.gateways.without_state(:draft).order(:ordering)
      @contribution.gateway = @gateways.first
      @contribution.user = current_user
      authorize @contribution
    end
  end
  
  def update
    authorize resource
    update!
  end

  def show
    authorize resource
    @user = @contribution.user
    show!
  end

  private

  def permitted_params
    params.permit(contribution: policy(@contribution || Contribution.new).permitted_attributes)
  end

end
