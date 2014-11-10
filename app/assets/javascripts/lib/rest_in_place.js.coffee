ESC_KEY = 27

RestInPlaceEditor.forms.checkbox =
  activateForm : ->
    @update()

  getValue : ->
    @$element.is(':checked')

RestInPlaceEditor.forms.input =
  activateForm : ->
    value = $.trim(@elementHTML())
    @$element.html("""<form action="javascript:void(0)" style="display:inline;">
      <input type="text" class="rest-in-place-#{@attributeName}" placeholder="#{@placeholder}">
      </form>""")
    @$element.find('input').val(value)
    @$element.find('input')[0].select()
    @$element.find("form").submit =>
      @update()
      false
    @$element.find("input").keyup (e) =>
      @abort() if e.keyCode == ESC_KEY
    @$element.find("input").blur => @update()

  getValue : ->
    @$element.find("input").val()

$(document).ready ->
  $('textarea').autosize()
  $(".editable").restInPlace()
  $('.editable').bind 'ready.rest-in-place', ->
    $('textarea').autosize()
  $('.editable').bind 'update.rest-in-place', ->
    $(@).hide()
    if $(@).attr('type') == 'checkbox'
      $(@).next().hide()
    $(@).after('<span class="saving">...</span><div class="saving_break">&nbsp;</div>')
  $('.editable').bind 'success.rest-in-place failure.rest-in-place abort.rest-in-place', ->
    $('.saving').remove()
    $('.saving_break').remove()
    $(@).show()
    if $(@).attr('type') == 'checkbox'
      $(@).next().show()
