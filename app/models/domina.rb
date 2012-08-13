#creada por db2models
class Domina < ActiveRecord::Base

  #autogenerado por db2models
  set_primary_keys :idioma_id,:instructor_usuario_ci

  #autogenerado por db2models
  belongs_to :idioma,
    :class_name => 'Idioma',
    :foreign_key => ['idioma_id']

  #autogenerado por db2models
  belongs_to :instructor_usuario,
    :class_name => 'Instructor',
    :foreign_key => ['instructor_usuario_ci']

end
