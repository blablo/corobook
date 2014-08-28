# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  update_position()           
  $('#sortable').sortable(
    axis: 'y'
    items: '.fields'
    update: (e, ui) ->
      update_position()

  )
  $('.song select').selectize()
  $.fn.datepicker.defaults.format = "yyyy-mm-dd";
  $( "#presentation_fecha" ).datepicker();

@content_type = "song"

@update_position = update_position = ()->
  $("li.list-group-item").each (index) ->
    $(this).find(".order").val(index+1)
    return
  return

$(document).on "nested:fieldAdded", (event) ->
  update_position()  
  field = event.field
  if content_type is 'song'
    field.find('.diapo').hide()
    field.find('li').addClass('song-row')
    field.find('.song').show()
    field.find('select').selectize()
  else
    field.find('.song').hide()
    field.find('li').removeClass('song-row')
    field.find('.diapo').show()
  return
