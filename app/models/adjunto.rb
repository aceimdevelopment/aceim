class Adjunto < ActiveRecord::Base

	# Atributos Accesibles
	attr_accessible :archivo, :segmento_id

	belongs_to :segmento
end