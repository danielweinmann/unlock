class Initiatives::GatewaysController < StateController

  inherit_resources
  actions :all, except: [:index, :show, :destroy]
  custom_actions resource: %i[use_sandbox use_production revert_to_draft]
  belongs_to :initiative, parent_class: Initiative
  respond_to :html

  after_action :verify_policy_scoped, only: %i[]

  def new
    new! do
      authorize resource
      module_names = @initiative.gateways.map(&:module_name)
      @gateways = @initiative.available_gateways
    end
  end

  def create
    @initiative = Initiative.find(params[:initiative_id])
    @gateway = @initiative.gateways.new(gateway_params)
    @gateways = @initiative.available_gateways
    authorize @gateway
    create!(notice: "Meio de pagamento adicionado com sucesso!") { @initiative }
  end

  def edit
    edit! { authorize resource }
  end

  def update
    authorize resource
    update!(notice: "Configurações atualizadas com sucesso!") { @initiative }
  end

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

  def permitted_params
    params.permit(gateway: policy(@gateway || Gateway.new).permitted_attributes)
  end

  def gateway_params
    params.require(:gateway).permit(*policy(@gateway || Gateway.new).permitted_attributes)
  end

  def transition_state(transition)
    super(transition, resource.initiative)
  end

end
