#creada por db2models
class TipoCurso < ActiveRecord::Base

  #autogenerado por db2models
  set_primary_keys :idioma_id,:tipo_categoria_id

  #autogenerado por db2models
  belongs_to :idioma,
    :class_name => 'Idioma',
    :foreign_key => ['idioma_id']

  #autogenerado por db2models
  belongs_to :tipo_categoria,
    :class_name => 'TipoCategoria',
    :foreign_key => ['tipo_categoria_id']  

  has_many :cursos,
    :class_name => 'Curso',
    :foreign_key => ['idioma_id','tipo_categoria_id']

  accepts_nested_attributes_for :cursos
  
  has_many :estudiantes_nivelacion,
    :class_name => 'EstudianteNivelacion',
    :foreign_key => ['idioma_id','tipo_categoria_id']  

  accepts_nested_attributes_for :estudiantes_nivelacion

  def descripcion
    "#{idioma.descripcion} (#{tipo_categoria.descripcion})"
  end

end
