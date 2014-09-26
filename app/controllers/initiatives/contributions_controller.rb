class Initiatives::ContributionsController < ApplicationController

  inherit_resources
  actions :index, :new, :create
  custom_actions member: %i[pay]
  belongs_to :initiative, parent_class: Initiative

  after_action :verify_authorized, except: %i[index]
  after_action :verify_policy_scoped, only: %i[index]
  before_action :authenticate_user!, only: %i[new pay]

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

      # Configuring Moip
      Moip::Assinaturas.config do |config|
        config.sandbox = @initiative.sandbox?
        config.token = @initiative.moip_token
        config.key = @initiative.moip_key
      end

      # Creating the plan, if needed
      plan_code = "unlock#{@contribution.value.to_i}"
      begin
        response = Moip::Assinaturas::Plan.details(plan_code)
      rescue
        @contribution.errors.add(:base, "Ocorreu um erro de conexão ao verificar o plano de assinaturas no Moip. Por favor, tente novamente.")
        return render action: 'new'
      end
      unless response[:success]
        plan = {
          code: plan_code,
          name: "Unlock #{@contribution.value.to_i}",
          amount: (@contribution.value * 100).to_i
        }
        begin
          response = Moip::Assinaturas::Plan.create(plan)
        rescue
          @contribution.errors.add(:base, "Ocorreu um erro de conexão ao criar o plano de assinaturas no Moip. Por favor, tente novamente.")
          return render action: 'new'
        end
        unless response[:success]
          @contribution.errors.add(:base, "Ocorreu um erro ao criar o plano de assinaturas no Moip. Por favor, tente novamente.")
          return render action: 'new'
        end
      end

      # Creating the client, if needed
      customer_code = "unlock#{@contribution.user.id}"
      customer = {
        code: customer_code,
        email: @contribution.user.email,
        fullname: @contribution.user.full_name,
        cpf: @contribution.user.document,
        phone_area_code: @contribution.user.phone_area_code,
        phone_number: @contribution.user.phone_number,
        birthdate_day: @contribution.user.birthdate.strftime('%d'),
        birthdate_month: @contribution.user.birthdate.strftime('%m'),
        birthdate_year: @contribution.user.birthdate.strftime('%Y'),
        address: {
          street: @contribution.user.address_street,
          number: @contribution.user.address_number,
          complement: @contribution.user.address_complement,
          district: @contribution.user.address_district,
          city: @contribution.user.address_city,
          state: @contribution.user.address_state,
          country: "BRA",
          zipcode: @contribution.user.address_zipcode
        }
      }
      begin
        response = Moip::Assinaturas::Customer.details(customer_code)
      rescue
        @contribution.errors.add(:base, "Ocorreu um erro de conexão ao verificar o cadastro de cliente no Moip. Por favor, tente novamente.")
        return render action: 'new'
      end
      if response[:success]
        begin
          Moip::Assinaturas::Customer.update(customer_code, customer)
        rescue
          @contribution.errors.add(:base, "Ocorreu um erro de conexão ao atualizar o cadastro de cliente no Moip. Por favor, tente novamente.")
          return render action: 'new'
        end
      else
        begin
          response = Moip::Assinaturas::Customer.create(customer, new_vault = false)
        rescue
          @contribution.errors.add(:base, "Ocorreu um erro de conexão ao realizar o cadastro de cliente no Moip. Por favor, tente novamente.")
          return render action: 'new'
        end
        unless response[:success]
          if response[:errors] && response[:errors].kind_of?(Array)
            response[:errors].each do |error|
              @contribution.errors.add(:base, "#{response[:message]} (Moip). #{error[:description]}")
            end
          else
            @contribution.errors.add(:base, "Ocorreu um erro ao realizar o cadastro de cliente no Moip. Por favor, tente novamente.")
          end
          return render action: 'new'
        end
      end

      flash[:success] = "Apoio criado com sucesso! Agora é só realizar o pagamento :D"
      return redirect_to pay_initiative_contribution_path(@initiative.id, @contribution)

    else
      return render action: 'new'
    end
    
  end

  def pay
    authorize resource
  end
  
  private

  def permitted_params
    params.permit(contribution: [:value, :user_id, user_attributes: [ :id, :full_name, :document, :phone_area_code, :phone_number, :birthdate, :address_street, :address_number, :address_complement, :address_district, :address_city, :address_state, :address_zipcode ]])
  end

  def contribution_params
    params.require(:contribution).permit(:value, :user_id, user_attributes: [ :id, :full_name, :document, :phone_area_code, :phone_number, :birthdate, :address_street, :address_number, :address_complement, :address_district, :address_city, :address_state, :address_zipcode ])
  end

end
