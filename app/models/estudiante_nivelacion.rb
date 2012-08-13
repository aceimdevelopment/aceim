#creada por db2models
class EstudianteNivelacion < ActiveRecord::Base

  #autogenerado por db2models
  set_primary_keys :usuario_ci,:periodo_id,:idioma_id,:tipo_categoria_id  

  #autogenerado por db2models
  belongs_to :usuario,
    :class_name => 'Usuario',
    :foreign_key => ['usuario_ci']

  #autogenerado por db2models
  belongs_to :periodo,
    :class_name => 'Periodo',
    :foreign_key => ['periodo_id']
    
  
  belongs_to :tipo_curso,
    :class_name => 'TipoCurso',
    :foreign_key => ['idioma_id','tipo_categoria_id']
    
    
  def inscrito?
    !!HistorialAcademico.where(:usuario_ci => usuario_ci,
      :periodo_id => periodo_id,
      :idioma_id => idioma_id,
      :tipo_categoria_id => tipo_categoria_id).first
  end          
  
  def estado
    return "Inscrito" if inscrito?
    return "No inscrito"
  end


end
