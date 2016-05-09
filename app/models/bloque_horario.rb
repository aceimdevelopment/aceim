# encoding: utf-8

class BloqueHorario < ActiveRecord::Base

  belongs_to :tipo_hora,
    :class_name => 'TipoHora',
    :foreign_key => ['tipo_hora_id']


  belongs_to :tipo_dia,
    :class_name => 'TipoDia',
    :foreign_key => ['tipo_dia_id1']


  belongs_to :tipo_dia,
    :class_name => 'TipoDia',
    :foreign_key => ['tipo_dia_id2']


	def descripcion_horario

		bloque_horario = BloqueHorario.find("H5")

		dia1 = bloque_horario.tipo_dia_id1
		dia2 = bloque_horario.tipo_dia_id2


		dia1_desc = TipoDia.find(dia1)

	  dia2_desc = TipoDia.find(dia2)

		puts dia1_desc.descripcion
		puts dia2_desc.descripcion
		


  end



end
