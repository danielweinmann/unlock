class Initiatives::GatewaysController < StateController

  inherit_resources
  actions :all, except: [:index, :show, :destroy]
  custom_actions member: %i[use_sandbox use_production revert_to_draft]
  belongs_to :initiative, parent_class: Initiative
  respond_to :html

  after_action :verify_authorized, except: %i[]
  after_action :verify_policy_scoped, only: %i[]

  def use_production
    transition_state(:use_production)
  end

  def use_sandbox
    transition_state(:use_sandbox)
  end

  def revert_to_draft
    transition_state(:revert_to_draft)
  end

  private

  def transition_state(transition)
    super(transition, resource.initiative)
  end

end
