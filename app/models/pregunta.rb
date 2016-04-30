class Pregunta < ActiveRecord::Base
	# Pendiente Por ampliar
	# has_many :pregunta_segmentos,
	# 	:class_name => 'SegmentoTienePregunta'

	# accepts_nested_attributes_for :pregunta_segmentos

	# has_many :segmentos, :through => :pregunta_segmentos, :source => :segmento

	belongs_to :segmento

	has_one :siguiente_pregunta,
		:class_name => 'Pregunta',
		:foreign_key => :siguiente_pregunta_id

	accepts_nested_attributes_for :siguiente_pregunta

end
