#creada por db2models
class Aula < ActiveRecord::Base
  include ActiveModel::Validations 
  #autogenerado por db2models
  belongs_to :tipo_ubicacion,
    :class_name => 'TipoUbicacion',
    :foreign_key => ['tipo_ubicacion_id']

  has_many :bloque_aula_disponible,
    :class_name => 'BloqueAulaDisponible',
    :foreign_key => ['aula_id']
  
    validates :id, :presence => true
    validates :tipo_ubicacion_id, :presence => true
    validates :descripcion, :presence => true
    validates :conjunto_disponible, :presence => true

  def descripcion_completa
    "(#{id}) #{tipo_ubicacion.descripcion} - #{descripcion}"
  end
  
  def descripcion_pareja
    "#{descripcion}"
  end

   def descripcion_ubicaciones_aula

      "#{tipo_ubicacion.descripcion}"

   end

  def horario_seccion_aula (dia_id, hora_id, periodo_id)
		  HorarioSeccion.where(:aula_id=>id, :tipo_hora_id=>hora_id,:tipo_dia_id=>dia_id,:periodo_id => periodo_id).delete_if{|x| !x.seccion.esta_abierta}

  end

end
