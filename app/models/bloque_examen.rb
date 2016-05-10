# encoding: utf-8

class BloqueExamen < ActiveRecord::Base

	# CLAVE PRIMARIA COMPUESTA
  	set_primary_keys [:tipo_bloque_examen_id, :examen_id]

	# ATRIBUTOS ACCESIBLES
	attr_accessible :tipo_bloque_examen_id, :examen_id

	# ASOCIACIONES
  	belongs_to :examen

	belongs_to :tipo_bloque_examen,
	:class_name => 'TipoBloqueExamen',
	:id => [:tipo_bloque_examen_id, :examen_id],
	:foreign_key => :tipo_bloque_examen_id


	has_many :tiene_actividades,
	:class_name => 'BloqueExamenTieneActividad',
	:id => [:actividad_id, :bloque_examen_tipo_bloque_examen_id, :bloque_examen_examen_id]
	:foreign_key => [:bloque_examen_tipo_bloque_examen_id, :bloque_examen_examen_id]

	accepts_nested_attributes_for :tiene_actividades

	has_many :actividades, 
	:class_name => 'Actividad',
	:through => :tiene_actividades

	accepts_nested_attributes_for :actividades

	# VALIDACIONES
	validates :tipo_bloque_examen_id, :presence => true
	validates :examen_id, :presence => true


end