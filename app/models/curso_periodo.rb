# encoding: utf-8

#creada por db2models
class CursoPeriodo < ActiveRecord::Base

  #autogenerado por db2models
  set_primary_keys :periodo_id,:idioma_id,:tipo_categoria_id,:tipo_nivel_id

  #autogenerado por db2models
  belongs_to :curso,
    :class_name => 'Curso',
    :foreign_key => ['tipo_nivel_id','idioma_id','tipo_categoria_id']

  #autogenerado por db2models
  belongs_to :periodo,
    :class_name => 'Periodo',
    :foreign_key => ['periodo_id']

  has_many :detalles_facturas,
    :class_name => 'DetalleFactura',
    :foreign_key => ['periodo_id' , 'idioma_id' , 'tipo_categoria_id' , 'tipo_nivel_id']
  accepts_nested_attributes_for :detalles_facturas

  has_many :secciones,
    :class_name => 'Seccion',
    :foreign_key => ['periodo_id' , 'idioma_id' , 'tipo_categoria_id' , 'tipo_nivel_id']
  accepts_nested_attributes_for :secciones


    def preinscritos
      @periodo = ParametroGeneral.periodo_actual
      HistorialAcademico.count(:conditions => ["idioma_id = ? AND periodo_id = ? AND tipo_categoria_id = ? AND tipo_nivel_id = ?",idioma_id,@periodo.id, tipo_categoria_id,tipo_nivel_id])
    end

    def inscritos
      @periodo = ParametroGeneral.periodo_actual
      HistorialAcademico.count(:conditions => ["idioma_id = ? AND periodo_id = ? AND tipo_categoria_id = ? AND tipo_nivel_id = ? AND tipo_estado_inscripcion_id=?",idioma_id,@periodo.id,tipo_categoria_id,tipo_nivel_id,"INS"])
    end
    
    def tipo_nivel
      TipoNivel.find(tipo_nivel_id)
    end
    
    def tipo_categoria  
    	TipoCategoria.find(tipo_categoria_id)
    end

    def idioma  
    	Idioma.find(idioma_id)
    end


    def descripcion
      "Curso de #{idioma.descripcion} #{tipo_categoria.descripcion} - Nivel #{tipo_nivel.descripcion} (Periodo#{periodo.id})"
    end
end
