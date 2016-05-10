# encoding: utf-8

class TipoBloqueExamen < ActiveRecord::Base

	# ATRIBUTOS ACCESIBLES
	attr_accessible :id, :nombre

	# ASOCIACIONES
	has_many :bloques_examenes,
	:class_name => 'BloqueExamen',
	:foreign_key => :tipo_bloque_examen_id

	has_many :examenes, :through => :bloques_examenes

	# VALIDACIONES
	validates :id, :presence => true
	validates :nombre, :presence => true

end