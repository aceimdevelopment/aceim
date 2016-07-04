# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  if aceim.es_accion("index") 
    $('#usuario_ci').autocomplete
      source: '/aceim/admin_estudiante/autocomplete'
  
  $('.btn_editar').button icons: primary: 'ui-icon-pencil'

  $('.btn_previsualizar').button icons: primary: 'ui-icon-arrow-4-diag '

  $('.btn_eliminar').button icons: primary: 'ui-icon-trash'

  $('.btn_remover').button icons: primary: 'ui-icon-circle-minus'

  $('.btn_agregar').button icons: primary: 'ui-icon-plus'

  $('.btn_generar').button icons: primary: 'ui-icon-gear'

  $('.btn_atras').button icons: primary: 'ui-icon-carat-1-w'

  $('.btn_descargar').button icons: primary: 'ui-icon-circle-arrow-s'

  $('.btn_calendario').button icons: primary: 'ui-icon-calendar'

  $('.btn_actualizar').button icons: primary: 'ui-icon-refresh'

  $('.btn_reloj').button icons: primary: 'ui-icon-clock'

  $('.btn_bandera').button icons: primary: 'ui-icon-flag'

  $('.btn_check').button icons: primary: 'ui-icon-check'

  $('.btn_calculadora').button icons: primary: 'ui-icon-calculator'

  $('.btn_bloquear').button icons: primary: 'ui-icon-locked'

  $('.btn_desbloquear').button icons: primary: 'ui-icon-unlocked'

  $('.btn').button()

  $("#parte").tabs()