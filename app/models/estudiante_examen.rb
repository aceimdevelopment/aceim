class EstudianteExamen < ActiveRecord::Base

	# ATRIBUTOS ACCESIBLES
	attr_accessible :estudiante_ci, :examen_id, :tiempo, :puntaje_total, :tipo_estado_estudiante_examen_id

	# CLAVE PRIMARIA COMPUESTA
	set_primary_keys [:estudiante_ci, :examen_id]

	# ASOCIACIONES
	belongs_to :examen

	belongs_to :estudiante

	belongs_to :tipo_estado_estudiante_examen


	has_many :estudiante_examen_respuestas, :dependent => :destroy, 
	# :class_name => 'ParteExamenActividad',
	# :primary_key => [:parte_id, :examen_id, :actividad_id],
	:foreign_key => [:estudiante_ci, :examen_id]

	accepts_nested_attributes_for :estudiante_examen_respuestas

	has_many :respuestas, :through => :estudiante_examen_respuestas, :source => :respuesta

	accepts_nested_attributes_for :respuestas

	# VALIDACIONES
	validates :estudiante_ci, :presence => true
	validates :examen_id, :presence => true

	def total_puntos_correctos
		total = 0
		estudiante_examen_respuestas.each do |eer|
			total += eer.respuesta.puntaje if eer.es_correcta?
		end 
		return total
	end

	def total_respuestas_correctas
		total = 0
		estudiante_examen_respuestas.each do |eer|
			total += 1 if eer.es_correcta?
		end
		return total
	end

end