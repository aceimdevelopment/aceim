# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/ 
$ ->
  if aceim.es_accion("paso1") or aceim.es_accion("paso1_guardar") or aceim.es_accion("actualizar_datos_personales") or aceim.es_accion("guardar_datos_personales")
    $('.datepicker_nac').datepicker
      changeYear: true,
      changeMonth: true,
      yearRange: '-90Y:-3Y',
      defaultDate: '-20Y',
      showOn: 'both',
      dateFormat: 'yy-mm-dd'
  
