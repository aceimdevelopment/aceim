class EstudianteExamenRespuesta < ActiveRecord::Base
	# ATRIBUTOS ACCESIBLES
	attr_accessible :estudiante_ci, :examen_id, :respuesta_id, :valor

	# CLAVE PRIMARIA COMPUESTA
	set_primary_keys [:estudiante_ci, :examen_id, :respuesta_id]

	# ASOCIACIONES
	# belongs_to :actividad

	belongs_to :estudiante_examen,
	:primary_key =>  [:estudiante_ci, :examen_id],
	:foreign_key => [:estudiante_ci, :examen_id]

	belongs_to :respuesta


	#VALIDACIONES
	validates :estudiante_ci, :presence => true
	validates :examen_id, :presence => true
	validates :respuesta_id, :presence => true

	def es_correcta?
		correcta = false
		correcta = true if valor and respuesta.valor and valor.casecmp(respuesta.valor).zero?
		correcta = true if valor and respuesta.valor_alternativa1 and valor.casecmp(respuesta.valor_alternativa1).zero?				
		correcta = true if valor and respuesta.valor_alternativa2 and valor.casecmp(respuesta.valor_alternativa2).zero?
		return correcta
	end

end