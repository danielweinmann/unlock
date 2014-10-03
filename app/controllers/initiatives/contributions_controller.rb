class Initiatives::ContributionsController < ApplicationController

  inherit_resources
  actions :index, :new, :create
  custom_actions member: %i[pay activate suspend cancel]
  belongs_to :initiative, parent_class: Initiative
  respond_to :html, except: [:activate, :suspend, :cancel]
  respond_to :json, only: [:index, :activate, :suspend, :cancel]

  after_action :verify_authorized, except: %i[index]
  after_action :verify_policy_scoped, only: %i[index]
  before_action :authenticate_user!, only: %i[new pay]

  def index
    @contributions = policy_scope(Contribution).where(initiative: parent).visible
  end
  
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
    @contribution.sandbox = @initiative.sandbox
    authorize @contribution

    if @contribution.save

      # Creating the plan, if needed
      begin
        response = Moip::Assinaturas::Plan.details(@contribution.plan_code, moip_auth: @contribution.moip_auth)
      rescue Moip::Assinaturas::WebServerResponseError => e
        if @initiative.sandbox?
          @contribution.errors.add(:base, "Parece que este Unlock não está autorizado a utilizar o ambiente de Sandbox do Moip Assinaturas.#{ ' Você já solicitou acesso ao Moip Assinaturas? Verifique também se configurou o Token e a Chave de API.' if @initiative.user == current_user }")
        else
          @contribution.errors.add(:base, "Parece que este Unlock não está autorizado a utilizar o ambiente de produção do Moip Assinaturas.#{ ' Você já homologou sua conta para produção no Moip Assinaturas? Verifique também se configurou o Token e a Chave de API.' if @initiative.user == current_user }")
        end
        return render action: 'new'
      rescue => e
        @contribution.errors.add(:base, "Ocorreu um erro de conexão ao verificar o plano de assinaturas no Moip. Por favor, tente novamente.")
        return render action: 'new'
      end
      unless response[:success]
        plan = {
          code: @contribution.plan_code,
          name: "#{@initiative.name[0..29]} #{@contribution.value.to_i}#{' (Sandbox)' if @initiative.sandbox?}",
          amount: (@contribution.value * 100).to_i
        }
        begin
          response = Moip::Assinaturas::Plan.create(plan, moip_auth: @contribution.moip_auth)
        rescue
          @contribution.errors.add(:base, "Ocorreu um erro de conexão ao criar o plano de assinaturas no Moip. Por favor, tente novamente.")
          return render action: 'new'
        end
        unless response[:success]
          if response[:errors] && response[:errors].kind_of?(Array)
            response[:errors].each do |error|
              @contribution.errors.add(:base, "#{response[:message]} (Moip). #{error[:description]}")
            end
          else
            @contribution.errors.add(:base, "Ocorreu um erro ao criar o plano de assinaturas no Moip. Por favor, tente novamente.")
          end
          return render action: 'new'
        end
      end

      # Creating the client, if needed
      customer = {
        code: @contribution.customer_code,
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
        response = Moip::Assinaturas::Customer.details(@contribution.customer_code, moip_auth: @contribution.moip_auth)
      rescue
        @contribution.errors.add(:base, "Ocorreu um erro de conexão ao verificar o cadastro de cliente no Moip. Por favor, tente novamente.")
        return render action: 'new'
      end
      if response[:success]
        begin
          response = Moip::Assinaturas::Customer.update(@contribution.customer_code, customer, moip_auth: @contribution.moip_auth)
          unless response[:success]
            if response[:errors] && response[:errors].kind_of?(Array)
              response[:errors].each do |error|
                @contribution.errors.add(:base, "#{response[:message]} (Moip). #{error[:description]}")
              end
            else
              @contribution.errors.add(:base, "Ocorreu um erro ao atualizar o cadastro de cliente no Moip. Por favor, tente novamente.")
            end
            return render action: 'new'
          end
        rescue
          @contribution.errors.add(:base, "Ocorreu um erro de conexão ao atualizar o cadastro de cliente no Moip. Por favor, tente novamente.")
          return render action: 'new'
        end
      else
        begin
          response = Moip::Assinaturas::Customer.create(customer, new_vault = false, moip_auth: @contribution.moip_auth)
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

      flash[:success] = "Apoio iniciado com sucesso! Agora é só realizar o pagamento :D"
      return redirect_to pay_initiative_contribution_path(@initiative.id, @contribution)

    else
      return render action: 'new'
    end
    
  end

  def pay
    authorize resource
  end
  
  def activate
    authorize resource
    errors = []
    if @contribution.can_activate?
      begin
        response = Moip::Assinaturas::Subscription.activate(@contribution.subscription_code, moip_auth: @contribution.moip_auth)
        @contribution.activate! if response[:success]
      rescue
        errors << "Não foi possível ativar sua assinatura no Moip Assinaturas"
      end
    else
      errors << "Não é permitido ativar este apoio."
    end
    render(json: {success: (errors.size == 0), errors: errors}, status: ((errors.size == 0) ? 200 : 422))
  end
  
  def suspend
    authorize resource
    errors = []
    if @contribution.can_suspend?
      begin
        response = Moip::Assinaturas::Subscription.suspend(@contribution.subscription_code, moip_auth: @contribution.moip_auth)
        @contribution.suspend! if response[:success]
      rescue
        errors << "Não foi possível suspender sua assinatura no Moip Assinaturas"
      end
    else
      errors << "Não é permitido suspender este apoio."
    end
    render(json: {success: (errors.size == 0), errors: errors}, status: ((errors.size == 0) ? 200 : 422))
  end
  
  def cancel
    authorize resource
    errors = []
    if @contribution.can_cancel?
      begin
        response = Moip::Assinaturas::Subscription.cancel(@contribution.subscription_code, moip_auth: @contribution.moip_auth)
        @contribution.cancel! if response[:success]
      rescue
        errors << "Não foi possível cancelar sua assinatura no Moip Assinaturas"
      end
    else
      errors << "Não é permitido cancelar este apoio."
    end
    render(json: {success: (errors.size == 0), errors: errors}, status: ((errors.size == 0) ? 200 : 422))
  end
  
  private

  def permitted_params
    params.permit(contribution: [:value, :user_id, user_attributes: [ :id, :full_name, :document, :phone_area_code, :phone_number, :birthdate, :address_street, :address_number, :address_complement, :address_district, :address_city, :address_state, :address_zipcode ]])
  end

  def contribution_params
    params.require(:contribution).permit(:value, :user_id, user_attributes: [ :id, :full_name, :document, :phone_area_code, :phone_number, :birthdate, :address_street, :address_number, :address_complement, :address_district, :address_city, :address_state, :address_zipcode ])
  end

end
