# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/  

$ ->       
  if aceim.es_accion("ver_secciones")
    $('#filtro_particular').keyup ->
      valor = $(this).val()
      tabla = $('table.tablefilter')
      $.uiTableFilter(tabla, valor) 

    $("#tipo_curso_id").change ->
      valor = $(this).val()
      valor2 = $("#ubicacion_id").val()
      valor3 = $("#horario_id").val()
      window.location.href = "/aceim/estado_inscripcion/ver_secciones?filtrar=#{valor}&filtrar2=#{valor2}&filtrar3=#{valor3}";


    $("#ubicacion_id").change ->
      valor = $(this).val()
      valor2 = $("#tipo_curso_id").val()
      valor3 = $("#horario_id").val()
      window.location.href = "/aceim/estado_inscripcion/ver_secciones?filtrar=#{valor2}&filtrar2=#{valor}&filtrar3=#{valor3}";

    $("#horario_id").change ->
      valor = $(this).val()
      valor2 = $("#ubicacion_id").val()
      valor3 = $("#tipo_curso_id").val()
      window.location.href = "/aceim/estado_inscripcion/ver_secciones?filtrar=#{valor3}&filtrar2=#{valor2}&filtrar3=#{valor}";

      
  if aceim.es_accion("ver_estado_envio")
      #setInterval aceim.refrescar("actualizar_estado"), 1000
      aceim.refrescar("actualizar_estado")
