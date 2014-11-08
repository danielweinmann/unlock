$(document).ready ->
  $(".open").on "click", (event) ->
    event.preventDefault()
    event.stopPropagation()
    $(@).parent().find("nav").toggle()
  $("input").click (event) ->
    event.stopPropagation()
  setTimeout (->
    $('#flash').slideDown('slow')
  ), 100
  setTimeout (->
    $('#flash').slideUp('slow')
  ), 16000
  $(window).on "click", ->
    $('#flash').slideUp('slow')
    $('.open').parent().find("nav").hide()
  $('.accordion h4').on "click", (event) ->
    event.preventDefault()
    event.stopPropagation()
    accordion = $(@).parent().parent()
    item = $(@).parent()
    wasSelected = item.hasClass('visible')
    accordion.children('li').removeClass 'visible'
    item.addClass('visible') unless wasSelected
