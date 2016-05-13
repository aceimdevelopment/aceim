# encoding: utf-8

class ParteExamenActividad < ActiveRecord::Base
	# ATRIBUTOS ACCESIBLES
	attr_accessible :parte_id, :examen_id, :actividad_id

	# CLAVE PRIMARIA COMPUESTA
  	set_primary_keys [:parte_id, :examen_id, :actividad_id]

  	# ASOCIACIONES
	belongs_to :actividad

	belongs_to :parte_examen,
	:primary_key =>  [:parte_id, :examen_id],
	:foreign_key => [:parte_id, :examen_id]

	#VALIDACIONES
	validates :parte_id, :presence => true
	validates :examen_id, :presence => true
	validates :actividad_id, :presence => true

end