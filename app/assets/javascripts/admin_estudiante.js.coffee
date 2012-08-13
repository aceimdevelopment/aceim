# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  if aceim.es_accion("index") 
    $('#usuario_ci').autocomplete
      source: '/aceim/admin_estudiante/autocomplete'
  
