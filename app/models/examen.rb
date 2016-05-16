# encoding: utf-8

class Examen < ActiveRecord::Base
	# ATRIBUTOS ACCESIBLES 
	attr_accessible :id, :descripcion, :duracion, :orden, :inicio_aplicacion, :cierre_aplicacion, :periodo_id, :curso_idioma_id, :curso_tipo_categoria_id, :curso_tipo_nivel_id

	# ASOCIACIONES
	belongs_to :curso_periodo,
		:foreign_key => [:periodo_id, :curso_idioma_id,:curso_tipo_categoria_id, :curso_tipo_nivel_id]

	has_many :parte_examenes, :dependent => :destroy
	accepts_nested_attributes_for :parte_examenes

	has_many :partes, :through => :parte_examenes, :source => :parte
	accepts_nested_attributes_for :partes
	
# VALIDACIONES
	validates :curso_idioma_id, :presence => true
	validates :curso_tipo_categoria_id, :presence => true
	validates :curso_tipo_nivel_id, :presence => true
	validates :periodo_id, :presence => true
	validates :duracion, :presence => true
	validates :orden, :presence => true

	def descripcion_full
		"#{curso_periodo.descripcion}-#{orden}-#{descripcion}"
	end

	def titulo
		curso_periodo.descripcion

	end

end
