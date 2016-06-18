module ApplicationHelper      
  def link_to_modal(nombre, datos = {})  
    default = {
      :controller => controller_name,
      :action => nil,
      :title => "ACEIM",
      :width => 300,
      :params => nil
    }                   
    datos = default.merge datos
    raw link_to_function nombre, "aceim.modal_remota('#{url_for(:controller=>datos[:controller],:action=>datos[:action], :parametros => datos[:params])}','#{datos[:title]}','#{datos[:width]}')"
  end

  def link_to_modal_v2(nombre, datos = {}, opciones_html = {})  
    default = {
      :controller => controller_name,
      :action => nil,
      :id => nil,
      :title => "ACEIM",
      :width => 300,
      :params => nil
    }                   
    datos = default.merge datos
    raw link_to_function nombre, "aceim.modal_remota('#{url_for(:controller=>datos[:controller],:action=>datos[:action], :id => datos[:id], :parametros => datos[:params])}','#{datos[:title]}','#{datos[:width]}')", opciones_html
  end

  def button_to_modal(nombre, datos = {}, clase = {})  
    default = {
      :controller => controller_name,
      :action => nil,
      :title => "ACEIM",
      :width => 300,
      :params => nil
    }                   
    datos = default.merge datos
    raw button_to_function nombre, "aceim.modal_remota('#{url_for(:controller=>datos[:controller],:action=>datos[:action], :parametros => datos[:params])}','#{datos[:title]}','#{datos[:width]}')", :class => clase
  end

  def button_to_modal_v2(nombre, datos = {}, opciones_html = {})  
    default = {
      :controller => controller_name,
      :action => nil,
      :id => nil,
      :title => "ACEIM",
      :width => 300,
      :params => nil
    }                   
    datos = default.merge datos
    raw button_to_function nombre, "aceim.modal_remota('#{url_for(:controller=>datos[:controller],:action=>datos[:action], :id => datos[:id], :parametros => datos[:params])}','#{datos[:title]}','#{datos[:width]}')", opciones_html
  end
  
  def codigo_barra(texto)
    Rutinas.crear_codigo_barra(texto)
  end
  
  def enlace(texto,action,controller,s)
    link_to texto, :action => action,
                   :controller => controller,
                   :p => s.periodo_id, 
                   :i => s.idioma_id, 
                   :tc => s.tipo_categoria_id, 
                   :tn => s.tipo_nivel_id, 
                   :sn => s.seccion_numero    
  end    
  
end
