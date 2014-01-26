# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ -> 
  tabla = $('table.tablefilter')
  $("#ubicacion_id").change ->
    $.uiTableFilter(tabla, this.value);
$ ->
  $(".ubicaciones").change ->
    aulas = document.getElementsByClassName(this.id)
    if (this.checked)
      for i in [0..aulas.length-1] 
        aulas[i].style.display = "table-row"
    else
      for i in [0..aulas.length-1]
        aulas[i].style.display = "none"
