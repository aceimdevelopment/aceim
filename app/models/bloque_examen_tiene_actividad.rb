# encoding: utf-8

class BloqueExamenTieneActividad < ActiveRecord::Base
	# ATRIBUTOS ACCESIBLES
	attr_accessible :bloque_examen_tipo_bloque_examen_id, :bloque_examen_examen_id, :actividad_id

	# CLAVE PRIMARIA COMPLEJA
  	set_primary_keys [:actividad_id, :bloque_examen_tipo_bloque_examen_id, :bloque_examen_examen_id]

  	# ASOCIACIONES
	belongs_to :actividad

	belongs_to :bloque_examen,
	:id =>  [:tipo_bloque_examen_id, :examen_id],
	:foreign_key => [:bloque_examen_tipo_bloque_examen_id, :bloque_examen_examen_id]

	#VALIDACIONES
	validates :bloque_examen_tipo_bloque_examen_id, :presence => true
	validates :bloque_examen_examen_id, :presence => true
	validates :actividad_id, :presence => true

end