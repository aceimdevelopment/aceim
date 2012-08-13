class NotaEnEvaluacion < ActiveRecord::Base

  set_primary_keys :usuario_ci, :idioma_id, :tipo_categoria_id, :tipo_nivel_id, 
                   :periodo_id, :seccion_numero, :tipo_evaluacion_id

  belongs_to :historial_academico,
    :class_name => 'HistorialAcademico',
    :foreign_key => ['usuario_ci', 'idioma_id', 'tipo_categoria_id', 
                     'tipo_nivel_id', 'periodo_id', 'seccion_numero']
          
  belongs_to :tipo_evaluacion,
    :class_name => "TipoEvaluacion",
    :foreign_key => "tipo_evaluacion_id"

end
