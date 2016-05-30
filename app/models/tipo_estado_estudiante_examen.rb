class TipoEstadoEstudianteExamen < ActiveRecord::Base

	# ATRIBUTOS ACCESIBLES
	attr_accessible :id, :nombre

	# ASOCIACIONES
	has_many :estudiante_examenes
	accepts_nested_attributes_for :estudiante_examenes

	# VALIDACIONES
	validates :id, :presence => true
	validates :nombre, :presence => true

end