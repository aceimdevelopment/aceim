class Examen < ActiveRecord::Base
	# ATRIBUTOS ACCESIBLES 
	attr_accessible :id, :descripcion, :duracion, :curso_idioma_id, :curso_tipo_categoria_id, :curso_tipo_nivel_id, :orden

	# Asociaciones
	belongs_to :curso,
		:foreign_key => [:curso_idioma_id,:curso_tipo_categoria_id, :curso_tipo_nivel_id]

	# Pendiente para incluir esto

		# has_many :examen_segementos,
		# 	:class_name => 'ExamenTieneSegmento'

		# accepts_nested_attributes_for :examen_segementos

		# has_many :segmentos, :through => :examen_segementos, :source => :segmento 

	has_many :segmentos, :dependent => :destroy
	accepts_nested_attributes_for :segmentos
	
# Validaciones
	validates :curso_idioma_id, :presence => true
	validates :curso_tipo_categoria_id, :presence => true
	validates :curso_tipo_nivel_id, :presence => true
	validates :duracion, :presence => true
	validates :orden, :presence => true

	def descripcion_full
		"#{id}.- #{descripcion}"
		
	end

end
