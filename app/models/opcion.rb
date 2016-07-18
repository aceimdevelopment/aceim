class Opcion < ActiveRecord::Base

	# ATRIBUTOS ACCESIBLES
	attr_accessible :id, :valor, :pregunta_id

	belongs_to :pregunta

	# VALIDACIONES	
	# validates :id, :presence => true
	validates :valor, :presence => true
	validates :pregunta_id, :presence => true

end
