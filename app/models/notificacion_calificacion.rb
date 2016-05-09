# encoding: utf-8

#creada por db2models
class NotificacionCalificacion < ActiveRecord::Base

  #autogenerado por db2models
  set_primary_keys :periodo_id,:usuario_ci
  #autogenerado por db2models
  belongs_to :usuario,
    :class_name => 'Usuario',
    :foreign_key => ['usuario_ci']
  
  belongs_to :periodo,
    :class_name => 'Periodo',
    :foreign_key => ['periodo_id']
    
  
end
