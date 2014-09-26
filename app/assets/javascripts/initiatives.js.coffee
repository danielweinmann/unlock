$(document).ready ->
  $('.field#image input[type=file]').on "change", ->
    $(@).parent().submit()
  $('#pay_form [type=submit]').on "click", (event) ->
    event.preventDefault()
    event.stopPropagation()
    billing_info_ok = false
    form = $('#pay_form')
    submit = form.find('[type=submit]')
    status = form.find('.status')
    status.removeClass 'success'
    status.removeClass 'failure'
    status.html("<h4>Enviando dados de pagamento para o Moip...</h4><ul></ul>")
    token = form.data('token')
    plan_code = form.data('plan')
    submit.hide()
    status.show()
    if MoipAssinaturas?
      moip = new MoipAssinaturas(token)
      moip.callback (response) ->
        status.find('h4').html("#{response.message} (Moip)")
        unless response.has_errors()
          unless billing_info_ok
            billing_info_ok = true
            subscription = new Subscription()
            subscription.with_code(form.data('subscription'))
            subscription.with_customer(customer)
            subscription.with_plan_code(plan_code)
            moip.subscribe(subscription)
          else
            status.addClass 'success'
            form.find('input, label').hide()
          end
        else
          status.addClass 'failure'
          for error in response.errors
            status.find('ul').append("<li>#{error.description}</li>")
          submit.show()
      billing_info =
        fullname: $("#holder_name").val(), 
        expiration_month: $("#expiration_month").val(),
        expiration_year: $("#expiration_year").val(),
        credit_card_number: $("#number").val()
      customer = new Customer()
      customer.code = form.data('customer')
      customer.billing_info = new BillingInfo(billing_info)
      moip.update_credit_card(customer)
    else
      status.addClass 'failure'
      status.find('h4').html("Erro ao carregar o Moip Assinaturas. Por favor, recarregue a página e tente novamente.")
      submit.show()
