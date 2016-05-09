# encoding: utf-8

class PlanificacionController < ApplicationController
  before_filter :filtro_logueado
  before_filter :filtro_super_administrador

  def index

  @titulo_pagina = "Opciones del SuperAdministrador"

  end

  
end
