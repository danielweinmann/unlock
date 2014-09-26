$(document).ready ->
  $('.field#image input[type=file]').on "change", ->
    $(@).parent().submit()
  $('#pay_form [type=submit]').on "click", (event) ->
    event.preventDefault()
    event.stopPropagation()
    form = $('#pay_form')
    token = form.data('token')
    plan_code = form.data('plan')
    form.find('[type=submit]').hide()
    form.find('.status').show()
