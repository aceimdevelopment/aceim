# encoding: utf-8

#creada por db2models
class TipoConvenio < ActiveRecord::Base
  include ActiveModel::Validations 
  #autogenerado por db2models
  
    validates :id, :presence => true
    validates :descripcion, :presence => true
    validates :monto, :presence => true
    validates :descuento, :presence => true

  def descripcion_convenio
    "#{descripcion}"
  end

end


