class Adjunto < ActiveRecord::Base

	# Atributos Accesibles
	attr_accessible :archivo, :actividad_id, :original_filename

	belongs_to :actividad
end