$(document).ready ->
  $('.field#image input[type=file]').on "change", ->
    $(@).parent().submit()
