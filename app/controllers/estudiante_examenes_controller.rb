class EstudianteExamenesController < ApplicationController
	before_filter :filtro_administrador
	HOST = "/aceim/assets/examenes/"
	def show
		@estudiante_examen = EstudianteExamen.find params[:id].to_s
		@examen = @estudiante_examen.examen
		@host = "#{request.protocol}#{request.host_with_port}"+HOST

		@total_actividades = @examen.total_actividades
		@total_preguntas = @examen.total_preguntas
		@total_puntos = @examen.puntaje_total

		@total_puntos_correctos = @estudiante_examen.total_puntos_correctos
		@total_respuestas_correctas = @estudiante_examen.total_respuestas_correctas
		@total_respuestas_incorrectas = @total_preguntas - @total_respuestas_correctas

	end

end