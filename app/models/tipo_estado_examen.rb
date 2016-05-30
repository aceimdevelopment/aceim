class TipoEstadoExamen < ActiveRecord::Base

	# ATRIBUTOS ACCESIBLES
	attr_accessible :id, :nombre

	# ASOCIACIONES
	has_many :examenes
	accepts_nested_attributes_for :examenes

	# VALIDACIONES
	validates :id, :presence => true
	validates :nombre, :presence => true

end