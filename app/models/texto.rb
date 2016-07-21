class Texto < ActiveRecord::Base
	
	# ATRIBUTOS ACCESIBLES
	attr_accessible :contenido, :segmento_id

	# ASOCIACIONES

	belongs_to :segmento
end