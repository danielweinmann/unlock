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

    # Setting contribution
    @initiative = Initiative.find(params[:initiative_id])
    @contribution = @initiative.contributions.new(contribution_params)
    @contribution.user = current_user
    authorize @contribution

    # Setting user information
    current_user.update(params[:contribution][:user])
    current_user.reload
    raise current_user.inspect
    
    # Setting credit card
    credit_card = params[:contribution][:credit_card]
    
    # Configuring MoIP
    Moip::Assinaturas.config do |config|
      config.sandbox = false
      config.token = @initiative.moip_token
      config.key = @initiative.moip_key
    end

    # Creating the plan, if needed
    plan_code = "unlock#{@contribution.value.to_i}"
    request = Moip::Assinaturas::Plan.details(plan_code)
    unless request[:success]
      plan = {
        code: plan_code,
        name: "Unlock #{@contribution.value.to_i}",
        amount: (@contribution.value * 100).to_i
      }
      request = Moip::Assinaturas::Plan.create(plan)
      unless request[:success]
        flash[:failure] = "Ooops. Houve um erro ao criar o plano no MoIP Assinaturas."
        return redirect_to initiative_by_permalink_path(@initiative)
      end
    end
    
    # Creating the client, if needed
    customer_code = "unlock#{current_user.id}"
    request = Moip::Assinaturas::Customer.details(customer_code)
    unless request[:success]
      customer = {
        code: customer_code,
        email: current_user.email,
        fullname: current_user.full_name,
        cpf: current_user.document,
        phone_area_code: current_user.phone_area_code,
        phone_number: current_user.phone_number,
        birthdate_day: current_user.birthdate.strftime('%d'),
        birthdate_month: current_user.birthdate.strftime('%m'),
        birthdate_year: current_user.birthdate.strftime('%Y'),
        address: {
          street: current_user.address_street,
          number: current_user.address_number,
          complement: current_user.address_complement,
          district: current_user.address_district,
          city: current_user.address_city,
          state: current_user.address_state,
          country: "BRA",
          zipcode: current_user.address_zipcode
        },
        billing_info: {
          credit_card: {
            holder_name: credit_card[:holder_name],
            number: credit_card[:number],
            expiration_month: credit_card[:expiration_month],
            expiration_year: credit_card[:expiration_year]
          }
        }
      }
      request = Moip::Assinaturas::Customer.create(customer, new_valt = true)
      unless request[:success]
        flash[:failure] = "Ooops. Houve um erro ao criar o plano no MoIP Assinaturas."
        return redirect_to initiative_by_permalink_path(@initiative)
      end
    end
    
    create!(notice: "Contribuição realizada com sucesso! :D") { @initiative }
  end

  private

  def permitted_params
    params.permit(contribution: [:value])
  end

  def contribution_params
    params.require(:contribution).permit(:value)
  end

end
