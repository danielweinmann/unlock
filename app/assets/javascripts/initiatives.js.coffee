$(document).ready ->
  $('.field#image input[type=file]').on "change", ->
    $(@).parent().submit()
  $('#pay_form [type=submit]').on "click", (event) ->
    event.preventDefault()
    event.stopPropagation()
    form = $('#pay_form')
    submit = form.find('[type=submit]')
    status = form.find('.status')
    status.removeClass 'success'
    status.removeClass 'failure'
    status.html("<h4>Enviando dados de pagamento para o Moip...</h4>")
    token = form.data('token')
    plan_code = form.data('plan')
    submit.hide()
    status.show()
    if MoipAssinaturas?
      moip = new MoipAssinaturas(token)
      moip.callback (response) ->
        console.log response
        status.find('h4').html(response.message)
        unless response.has_errors()
          status.addClass 'success'
        else
          status.addClass 'failure'
          status.append('<ul>')
          for error in response.errors
            console.log error
            status.find('ul').append("<li>#{error.description}</li>")
        submit.show()
      customer = new Customer()
      customer.code = form.data('customer')
      subscription = new Subscription()
      subscription.with_code(form.data('subscription'))
      subscription.with_customer(customer)
      subscription.with_plan_code(plan_code)
      moip.subscribe(subscription)
    else
      status.addClass 'failure'
      status.find('h4').html("Erro ao carregar o Moip Assinaturas. Por favor, recarregue a página e tente novamente.")
      submit.show()
