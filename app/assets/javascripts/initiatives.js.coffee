$(document).ready ->
  if action() == "show" and controller() == "initiatives" and namespace() == null
    $('.field#image input[type=file]').on "change", ->
      $(@).parent().submit()
