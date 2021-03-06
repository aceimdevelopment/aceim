#creada por db2models
class Curso < ActiveRecord::Base

  #autogenerado por db2models
  set_primary_keys :idioma_id,:tipo_categoria_id,:tipo_nivel_id

  #autogenerado por db2models
  belongs_to :tipo_nivel,
    :class_name => 'TipoNivel',
    :foreign_key => ['tipo_nivel_id']

  #autogenerado por db2models
  belongs_to :tipo_curso,
    :class_name => 'TipoCurso',
    :foreign_key => ['idioma_id','tipo_categoria_id']

  # has_many :segmentos,
  #   :class_name => 'Segmento',
  #   :foreign_key => [:curso_idioma_id,:curso_tipo_categoria_id, :curso_tipo_nivel_id]
  # accepts_nested_attributes_for :segmentos

  has_many :material_apoyo_cursos, :dependent => :destroy, :foreign_key => [:curso_idioma_id, :curso_tipo_categoria_id, :curso_tipo_nivel_id]
  accepts_nested_attributes_for :material_apoyo_cursos

  has_many :actividades,
    :foreign_key => [:curso_idioma_id,:curso_tipo_categoria_id, :curso_tipo_nivel_id]
  accepts_nested_attributes_for :actividades

  has_many :examenes,
    :class_name => 'Examen',
    :foreign_key => [:curso_idioma_id,:curso_tipo_categoria_id, :curso_tipo_nivel_id]
  accepts_nested_attributes_for :examenes

  has_many :historiales_academicos,
    :class_name => 'HistorialAcademico',
    :foreign_key => [:idioma_id,:tipo_categoria_id,:tipo_nivel_id]
  accepts_nested_attributes_for :historiales_academicos

  has_many :cursos_periodos,
    :class_name => 'CursoPeriodo',
    :foreign_key => [:idioma_id,:tipo_categoria_id, :tipo_nivel_id]
  accepts_nested_attributes_for :cursos_periodos

  def siguiente_nivel
    Curso.first(
    :conditions => ["idioma_id = ? AND tipo_categoria_id = ? \
      AND grado > ?",
      idioma_id, tipo_categoria_id, grado], :order => "grado")
  end


  def nivel_anterior
    Curso.first(
    :conditions => ["idioma_id = ? AND tipo_categoria_id = ? \
      AND grado = ?",
      idioma_id, tipo_categoria_id, grado-1], :order => "grado")
  end
  

  
  def descripcion
    "#{tipo_curso.descripcion} - #{tipo_nivel.descripcion}"
  end



end
