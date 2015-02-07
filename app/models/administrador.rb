#creada por db2models
# class Administrador < Usuario
class Administrador < ActiveRecord::Base
  attr_accessible :id, :usuario_ci, :tipo_rol_id
  #autogenerado por db2models
  set_primary_key :usuario_ci
  validates_presence_of :usuario_ci, :tipo_rol_id 
  validates :usuario_ci, :uniqueness => true
  #autogenerado por db2models
  belongs_to :usuario,
    :class_name => 'Usuario',
    :foreign_key => ['usuario_ci']

  belongs_to :tipo_rol
end
