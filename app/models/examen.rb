# encoding: utf-8

class Examen < ActiveRecord::Base
	# ATRIBUTOS ACCESIBLES 
	attr_accessible :id, :descripcion, :duracion, :orden, :inicio_aplicacion, :cierre_aplicacion, :periodo_id, :curso_idioma_id, :curso_tipo_categoria_id, :curso_tipo_nivel_id

	# ASOCIACIONES
	belongs_to :curso_periodo,
		:foreign_key => [:periodo_id, :curso_idioma_id,:curso_tipo_categoria_id, :curso_tipo_nivel_id]

	has_many :bloques_examenes,
	:class_name => 'BloqueExamen',
	:foreign_key => :tipo_bloque_examen_id

	accepts_nested_attributes_for :bloques_examenes

	has_many :tipo_bloques_examenes, 
	:class_name => 'TipoBloqueExamen',
	:through => :bloques_examenes
	
	accepts_nested_attributes_for :tipo_bloques_examenes


	# Pendiente para incluir esto

		# has_many :examen_segementos,
		# 	:class_name => 'ExamenTieneSegmento'

		# accepts_nested_attributes_for :examen_segementos

		# has_many :segmentos, :through => :examen_segementos, :source => :segmento 

	# has_many :segmentos, :dependent => :destroy
	# accepts_nested_attributes_for :segmentos
	
# VALIDACIONES
	validates :curso_idioma_id, :presence => true
	validates :curso_tipo_categoria_id, :presence => true
	validates :curso_tipo_nivel_id, :presence => true
	validates :periodo_id, :presence => true
	validates :duracion, :presence => true
	validates :orden, :presence => true

	def descripcion_full
		aux = periodo ? "#{periodo.ordenado}-#{orden}-" : "#{orden.capitalize}-"
		aux += "#{curso.descripcion}"
		aux += descripcion
	end

	def titulo
		aux = curso.descripcion
		aux += " - #{periodo.ordenado}" if periodo
		return aux
	end

end
