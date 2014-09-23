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

RestInPlaceEditor.forms.timestamp =
  activateForm : ->
    if @elementHTML() == @placeholder
      @$element.data('value', '')
      [date, time] = [null, null]
    else
      @$element.data('value', @elementHTML())
      [date, time] = $.trim(@elementHTML()).split(' ')
    @$element.html("""<form action="javascript:void(0)" style="display:inline;">
      <input type="text" class="date rest-in-place-#{@attributeName}" placeholder="Data">
      <input type="text" class="time rest-in-place-#{@attributeName}" placeholder="Hora">
      <input type="submit" value="Clique para salvar"><span class="cancel"> ou <a href="#">cancelar</a></span>
      </form>""")
    @$element.find('input.date').val(date)
    @$element.find('input.time').val(time)
    @$element.find("input.date").pickadate
      format: 'dd/mm/yyyy'
    @$element.find("input.time").pickatime
      format: 'HH:i'
      formatSubmit: 'HH:i'
    @$element.find(".cancel a").click (event) =>
      event.preventDefault()
      event.stopPropagation()
      @updateDisplayValue(@oldValue)
      @$element.removeClass('rip-active')
      @$element.trigger('abort.rest-in-place')
      @$element.click(@clickHandler)
    @$element.find("form").submit =>
      @update()
      false
    @$element.find("form").keyup (e) =>
      @abort() if e.keyCode == ESC_KEY

  getValue : ->
    @$element.data('value', "#{@$element.find("input.date").val()} #{@$element.find("input.time").val()}")
    "#{$(@$element.find("[type=hidden]")[0]).val()} #{$(@$element.find("[type=hidden]")[1]).val()}"

$(document).ready ->
  $('textarea').autosize()
  $(".editable").restInPlace()
  $('.editable').bind 'ready.rest-in-place', ->
    $('textarea').autosize()
  $('.editable').bind 'update.rest-in-place', ->
    $(@).hide()
    if $(@).attr('type') == 'checkbox'
      $(@).next().hide()
    $(@).after('<span class="saving">salvando...</span><div class="saving_break">&nbsp;</div>')
  $('.editable').bind 'success.rest-in-place failure.rest-in-place abort.rest-in-place', ->
    $('.saving').remove()
    $('.saving_break').remove()
    $(@).show()
    if $(@).attr('type') == 'checkbox'
      $(@).next().show()
  $('.editable[data-formtype=timestamp]').on 'success.rest-in-place abort.rest-in-place', ->
    if $(@).data('value').trim() == ""
      $(@).html("""<span class="rest-in-placeholder">#{$(@).data('placeholder')}</span>""")
    else
      $(@).html($(@).data('value').trim())
