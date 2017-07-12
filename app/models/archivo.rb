class Archivo < ActiveRecord::Base
  belongs_to :periodo
  accepts_nested_attributes_for :periodo
  belongs_to :bloque_horario
  accepts_nested_attributes_for :bloque_horario
  belongs_to :idioma
  accepts_nested_attributes_for :idioma
  belongs_to :tipo_nivel
  accepts_nested_attributes_for :tipo_nivel
end
