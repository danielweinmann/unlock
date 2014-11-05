$(document).ready ->
  # TODO use the Gateway's path
  $('.contribution_actions a').on "click", (event) ->
    event.preventDefault()
    event.stopPropagation()
    if confirm "Você está certo disso?"
      parent = $(@).parent()
      status = parent.find('h5')
      initiative = parent.data('initiative')
      contribution = parent.data('contribution')
      action = $(@).attr('id')
      url = "/initiatives/#{initiative}/contributions/#{contribution}/#{action}"
      parent.find('a').hide()
      status.html('Enviando solicitação...')
      status.show()
      $.ajax
        url: url,
        type: 'PUT',
        dataType: 'json',
        success: (response) ->
          parent.find('a').hide()
          status.html('Operação realizada com sucesso!')
          status.addClass('success')
          status.show()
        error: (response) ->
          status.html('Ocorreu um erro ao realizar sua operação')
          status.addClass('failure')

