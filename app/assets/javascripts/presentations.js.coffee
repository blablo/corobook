# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  update_position()           
  $('#sortable').sortable(
    axis: 'y'
    items: '.content'
    update: (e, ui) ->
      update_position()

  )

@update_position = update_position = ()->
  $("li.list-group-item").each (index) ->
    $(this).find(".order").val(index)
    return
  return

$(document).on "nested:fieldAdded", (event) ->
  update_position()  

  return