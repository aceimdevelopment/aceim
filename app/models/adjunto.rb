class Adjunto < ActiveRecord::Base

	# Atributos Accesibles
	attr_accessible :archivo, :actividad_id

	belongs_to :actividad
end