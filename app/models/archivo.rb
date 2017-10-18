# encoding: utf-8

class Archivo < ActiveRecord::Base
  #attr_accessible :nombre, :url, :periodo_id, :

#  belongs_to :periodo,
#    :class_name => 'Periodo',
#    :foreign_key => ['periodo_id']

#  accepts_nested_attributes_for :periodo

  belongs_to :bloque_horario
  accepts_nested_attributes_for :bloque_horario
  belongs_to :idioma
  accepts_nested_attributes_for :idioma
  belongs_to :tipo_nivel
  accepts_nested_attributes_for :tipo_nivel

  def descripcion
    "#{nombre} - #{url} - #{idioma_id}"
  end
end
