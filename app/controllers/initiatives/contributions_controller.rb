class Initiatives::ContributionsController < ApplicationController

  inherit_resources
  actions :index, :new, :create
  belongs_to :initiative, parent_class: Initiative

  after_action :verify_authorized, except: %i[index]
  after_action :verify_policy_scoped, only: %i[index]
  before_action :authenticate_user!, only: %i[new]

  def new
    new! { authorize @contribution }
  end
  
  def create
    @initiative = Initiative.find(params[:initiative_id])
    @contribution = @initiative.contributions.new(contribution_params)
    @contribution.user = current_user
    authorize @contribution
    create!(notice: "Contribuição realizada com sucesso! :D") { initiative_path(@initiative) }
  end

  private

  def permitted_params
    params.permit(contribution: [:value])
  end

  def contribution_params
    params.require(:contribution).permit(:value)
  end

end
