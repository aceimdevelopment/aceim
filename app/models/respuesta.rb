# encoding: utf-8

class Respuesta < ActiveRecord::Base

	# ATRIBUTOS ACCESIBLES
	attr_accessible :id, :valor, :puntaje, :pregunta_id, :orden, :otra_respuesta_id

	# ASOCIACIONES
	belongs_to :pregunta

	has_many :otras_respuestas,
		:class_name => 'Respuesta',
		:foreign_key => :otra_respuesta_id

	accepts_nested_attributes_for :otras_respuestas

	#VALIDACIOENS
	validates :valor, :presence => true
	validates :puntaje, :presence => true
	validates :pregunta_id, :presence => true

end
