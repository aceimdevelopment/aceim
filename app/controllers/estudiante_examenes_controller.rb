class EstudianteExamenesController < ApplicationController
	before_filter :filtro_administrador
	HOST = "/aceim/assets/examenes/"

	def index
		@examen = Examen.find params[:id]
		@estudiante_examenes = @examen.estudiante_examenes
		@titulo = @examen.descripcion_simple
		#@secciones = Seccion.where(:perido_id => @examen.perido_id, :idioma_id => @examen.curso_idioma_id, :tipo_categoria_id => @examen.curso_tipo_categoria_id, :tipo_nivel_id => @examen.curso_tipo_nivel_id)
	end

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

	def new
		
	end

	def create
		@estudiante_examen = EstudianteExamen.new 
		@estudiante_examen.id = params[:id]
		@estudiante_examen.tipo_estado_estudiante_examen_id = 'PREPARADO'
		begin @estudiante_examen.save
			info_bitacora("Agredado Examen #{@estudiante_examen.examen_id} al Estudiante: #{@estudiante_examen.estudiante_ci}")
			flash[:mensaje] = "Agregado Examen al Estudiante"

		rescue Exception => e
			flash[:mensaje] = "No se pudo agregar el Examen al Estudiante. Por favor verifique e intentelo nuevamente. Error Generado por el sistema:#{e}"	
		end 
		redirect_to  :back

	end


end