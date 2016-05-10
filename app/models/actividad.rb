# encoding: utf-8

class Actividad < ActiveRecord::Base
	# ATRIBUTOS ACCESIBLES
	attr_accessible :id, :instrucciones, :tipo_actividad_id, :curso_idioma_id, :curso_tipo_categoria_id, :curso_tipo_nivel_id, :cantidad_preguntas

	# ASOCIACIONES

	# Tipo_Segmento
	belongs_to :tipo_actividad,
		:foreign_key => :tipo_actividad_id

	# Cursos
	belongs_to :curso,
		:foreign_key => [:idioma_id,:tipo_categoria_id, :tipo_nivel_id]

	has_many :preguntas, :dependent => :destroy
	accepts_nested_attributes_for :preguntas

	# Textos
	has_many :textos, :dependent => :destroy
	accepts_nested_attributes_for :textos

	# Adjuntos
	has_many :adjuntos, :dependent => :destroy
	accepts_nested_attributes_for :adjuntos


	# Actividades_tiene_bloques_exmamens
	has_many :tiene_bloques_examenes,
	:class_name => 'BloqueExamenTieneActividad',
	:id => [:actividad_id, :bloque_examen_tipo_bloque_examen_id, :bloque_examen_examen_id]
	:foreign_key => :actividad_id

	accepts_nested_attributes_for :tiene_bloques_examenes

	# bloques_examenes
	has_many :bloques_examenes, 
	:class_name => 'BloqueExamen',
	:through => :tiene_bloques_examenes

	accepts_nested_attributes_for :bloques_examenes


	# VALIDACION
	validates :instrucciones, :presence => true
	validates :tipo_actividad_id, :presence => true
	validates :curso_idioma_id, :presence => true
	validates :curso_tipo_categoria_id, :presence => true
	validates :curso_tipo_nivel_id, :presence => true
	validates :curso_tipo_nivel_id, :presence => true


	def descripcion
		"#{tipo_segmento.nombre} - #{titulo}. #{cantidad_preguntas} preguntas de #{valor_preguntas} c/u. (Total= #{cantidad_preguntas*valor_preguntas if (cantidad_preguntas and valor_preguntas) } Pts.)"
	end

	def descripcion_con_if
		"#{tipo_segmento.id} #{tipo_segmento.nombre} - #{titulo}. #{cantidad_preguntas} preguntas de #{valor_preguntas} c/u. (Total= #{cantidad_preguntas*valor_preguntas if (cantidad_preguntas and valor_preguntas) } Pts.)"
	end

	# belongs_to :examen
	# Examnes
	# QUEDA PENDIENTE
	# has_many :segmento_examenes,
	# 	:class_name => 'ExamenTieneSegmento'

	# accepts_nested_attributes_for :segmento_examenes

	# has_many :examenes, :through => :segmento_examenes, :source => :examen

	# # Preguntas
	# has_many :segmento_preguntas,
	# 	:class_name => 'SegmentoTienePregunta'

	# accepts_nested_attributes_for :segmento_preguntas

	# has_many :preguntas, :through => :segmento_preguntas, :source => :pregunta

end
