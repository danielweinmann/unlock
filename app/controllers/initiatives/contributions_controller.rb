class Initiatives::ContributionsController < ApplicationController

  inherit_resources
  actions :index, :new, :create
  custom_actions member: %i[pay checkout]
  belongs_to :initiative, parent_class: Initiative

  after_action :verify_authorized, except: %i[index]
  after_action :verify_policy_scoped, only: %i[index]
  before_action :authenticate_user!, only: %i[new]

  def new    
    new! do
      @contribution.user = current_user
      authorize @contribution
    end
  end
  
  def create
    
    # Getting the date from Pickadate
    if params[:pickadate_birthdate_submit]
      params[:contribution][:user_attributes][:birthdate] = params[:pickadate_birthdate_submit]
    end
    
    # Creating the contribution
    @initiative = Initiative.find(params[:initiative_id])
    @contribution = @initiative.contributions.new(contribution_params)
    authorize @contribution
    if @contribution.save
      flash[:success] = "Apoio criado com sucesso! Agora é só realizar o pagamento :D"
      redirect_to pay_initiative_contribution_path(@initiative.id, @contribution)
    else
      render action: 'new'
    end
    
  end

  def pay
    authorize resource
  end
  
  def checkout
    # 
    # # Setting credit card
    # credit_card = params[:contribution][:credit_card]
    # 
    # # Configuring MoIP
    # Moip::Assinaturas.config do |config|
    #   config.sandbox = false
    #   config.token = @initiative.moip_token
    #   config.key = @initiative.moip_key
    # end
    # 
    # # Creating the plan, if needed
    # plan_code = "unlock#{@contribution.value.to_i}"
    # request = Moip::Assinaturas::Plan.details(plan_code)
    # unless request[:success]
    #   plan = {
    #     code: plan_code,
    #     name: "Unlock #{@contribution.value.to_i}",
    #     amount: (@contribution.value * 100).to_i
    #   }
    #   request = Moip::Assinaturas::Plan.create(plan)
    #   unless request[:success]
    #     flash[:failure] = "Ooops. Houve um erro ao criar o plano no MoIP Assinaturas."
    #     return redirect_to initiative_by_permalink_path(@initiative)
    #   end
    # end
    # 
    # # Creating the client, if needed
    # customer_code = "unlock#{current_user.id}"
    # request = Moip::Assinaturas::Customer.details(customer_code)
    # unless request[:success]
    #   customer = {
    #     code: customer_code,
    #     email: current_user.email,
    #     fullname: current_user.full_name,
    #     cpf: current_user.document,
    #     phone_area_code: current_user.phone_area_code,
    #     phone_number: current_user.phone_number,
    #     birthdate_day: current_user.birthdate.strftime('%d'),
    #     birthdate_month: current_user.birthdate.strftime('%m'),
    #     birthdate_year: current_user.birthdate.strftime('%Y'),
    #     address: {
    #       street: current_user.address_street,
    #       number: current_user.address_number,
    #       complement: current_user.address_complement,
    #       district: current_user.address_district,
    #       city: current_user.address_city,
    #       state: current_user.address_state,
    #       country: "BRA",
    #       zipcode: current_user.address_zipcode
    #     },
    #     billing_info: {
    #       credit_card: {
    #         holder_name: credit_card[:holder_name],
    #         number: credit_card[:number],
    #         expiration_month: credit_card[:expiration_month],
    #         expiration_year: credit_card[:expiration_year]
    #       }
    #     }
    #   }
    #   request = Moip::Assinaturas::Customer.create(customer, new_valt = true)
    #   unless request[:success]
    #     flash[:failure] = "Ooops. Houve um erro ao criar o plano no MoIP Assinaturas."
    #     return redirect_to initiative_by_permalink_path(@initiative)
    #   end
    # end
  end
  
  private

  def permitted_params
    params.permit(contribution: [:value, :user_id, user_attributes: [ :id, :full_name, :document, :phone_area_code, :phone_number, :birthdate, :address_street, :address_number, :address_complement, :address_district, :address_city, :address_state, :address_zipcode ]])
  end

  def contribution_params
    params.require(:contribution).permit(:value, :user_id, user_attributes: [ :id, :full_name, :document, :phone_area_code, :phone_number, :birthdate, :address_street, :address_number, :address_complement, :address_district, :address_city, :address_state, :address_zipcode ])
  end

end
