#creada por db2models
class BloqueAulaDisponible < ActiveRecord::Base

  #autogenerado por db2models
  set_primary_keys :tipo_hora_id,:tipo_dia_id,:aula_id

  #autogenerado por db2models
  belongs_to :tipo_bloque,
    :class_name => 'TipoBloque',
    :foreign_key => ['tipo_hora_id','tipo_dia_id']

  #autogenerado por db2models
  belongs_to :aula,
    :class_name => 'Aula',
    :foreign_key => ['aula_id']

  belongs_to :tipo_dia,
    :class_name => 'TipoDia',
    :foreign_key => ['tipo_dia_id']

  belongs_to :tipo_hora,
    :class_name => 'TipoHora',
    :foreign_key => ['tipo_hora_id']

	def descripcion_completa_del_aula

		if(tipo_dia_id != "SA")
			bloq_aula1 = BloqueAulaDisponible.where(:tipo_dia_id => tipo_dia_id, :tipo_hora_id => tipo_hora_id, :aula_id => aula_id).first

			numpareja = bloq_aula1.pareja

			bloq_aula2 = BloqueAulaDisponible.where(["tipo_dia_id != ? AND tipo_hora_id = ? AND pareja = ?", tipo_dia_id, tipo_hora_id, numpareja]).first

			aula_pareja = Aula.find(bloq_aula2.aula_id)

      #Si el aula no esta emparejada  
      if (aula_pareja.id == "BBVA")
        return aula.descripcion_completa + " / AULA SIN PAREJA"
      else
			  return aula.descripcion_completa + " / " + aula_pareja.descripcion_pareja
      end

    #Si el dia es sabado
		else

			return aula.descripcion_completa

		end

	end


  def descripcion_ubicacion

    return aula.descripcion_ubicaciones_aula

  end



end
