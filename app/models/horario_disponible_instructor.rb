#creada por db2models
class HorarioDisponibleInstructor < ActiveRecord::Base

  #autogenerado por db2models
  set_primary_keys :instructor_ci, :idioma_id, :bloque_horario_id

  #autogenerado por db2models
  belongs_to :instructor,
    :class_name => 'Instructor',
    :foreign_key => ['instructor_ci']

  belongs_to :idioma,
    :class_name => 'Idioma',
    :foreign_key => ['idioma_id']

  belongs_to :bloque_horario,
    :class_name => 'BloqueHorario',
    :foreign_key => ['bloque_horario_id']
  
  def instructor_nombre
    return instructor_ci unless instructor
    return instructor.descripcion
  end

end


