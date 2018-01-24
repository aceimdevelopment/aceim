# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/  

$ ->       
  if aceim.es_accion("ver_secciones")

    $("select").change ->
      curso = $("#tipo_curso_id").val()
      ubicacion = $("#ubicacion_id").val()
      horario = $("#horario_id2").val()
      nivel = $("#tipo_nivel_id").val()
      tipo_inscripcion = $("#tipo_inscripcion").val()
      window.location.href = "/aceim/estado_inscripcion/ver_secciones?filtrar=#{curso}&filtrar2=#{ubicacion}&filtrar3=#{horario}&filtrar4=#{nivel}&filtrar5=#{tipo_inscripcion}";

      
  if aceim.es_accion("ver_estado_envio")
      #setInterval aceim.refrescar("actualizar_estado"), 1000
      aceim.refrescar("actualizar_estado")
