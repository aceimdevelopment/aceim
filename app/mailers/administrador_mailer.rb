# encoding: utf-8

class AdministradorMailer < ActionMailer::Base
  # default :from => "fundeim@ucv.ve"
  default :from => "fundeimucv@gmail.com", :bcc => 'aceim.development@gmail.com'
  
  def enviar_notificacion(instructores)
    @instructores = instructores
    # aleidajave@yahoo.com   
    #joyce Gutiérrez Juárez <joygutierrez@hotmail.com>
    #carlos A. Saavedra A. <saavedraazuaje73@gmail.com>
    #sergiorivas@gmail.com,
    mail(:to => 'aleidajave@yahoo.com',
         :bcc => 'joygutierrez@hotmail.com,saavedraazuaje73@gmail.com,luciusdaniel@gmail.com',
         :subject => "Notificación de Pago")
  end 
  
  def aviso_general(correo,titulo,info)
    @info = info
    mail(:to => correo, :subject => "Aviso General - #{titulo}", :bcc => 'fundeimucv@gmail.com')
  end


  # def enviar_correo_general(para,asunto,mensaje,adjunto)
  #   @headers = {content_type => 'text/html'} 
  #   @to = para
  #   @subject = asunto
  #   @body = mensaje
    
  #   # attach files  
  #   if adjunto
  #     # attachments["#{adjunto}"] = File.read("#{Rails.root}/attachments/#{adjunto}")
  #     # attachment :content_type => file.content_type, :body => File.read(file.full_path), :filename => file.filename
  #     # attachments.inline[adjunto] = File.read("#{Rails.root}/attachments/#{adjunto}")
  #     attachments[adjunto] = File.read("#{Rails.root}/attachments/#{adjunto}")
  #   end
  # end

  
  def enviar_correo_general(para,asunto,mensaje,adjunto)
    # @headers = {:content_type => 'multipart/mixed'} 
    @mensaje = mensaje

    # part(:content_type => "text/html", :body => mensaje)
    #   html.body = render_message("enviar_correo_general.text.html.erb", :message => mensaje)
    # end
      
    # if adjunto
    #   # attachments["#{adjunto}"] = File.read("#{Rails.root}/attachments/#{adjunto}")
    #   # attachment :content_type => file.content_type, :body => File.read(file.full_path), :filename => file.filename
      attachments.inline[adjunto] = File.read("#{Rails.root}/attachments/#{adjunto}") if adjunto
    #   attachments[adjunto] = File.read("#{Rails.root}/attachments/#{adjunto}")
    # end
    mail(:to => para, :subject => asunto)
  end
  

  # def enviar_correo_general(para,asunto,mensaje,adjunto)
  #   @mensaje = mensaje

  #   mail(:subject => asunto,
  #   :to => para,
  #   :content_type => "multipart/mixed")

  #   part "text/html" do |html|
  #     html.body = render_message("enviar_correo_general.text.html.erb", :message => mensaje)
  #   end

  #   end

  #   if adjunto

  #     mail.attachments[adjunto] = File.read("#{Rails.root}/attachments/#{adjunto}")

  #     # attachment :content_type => "image/jpeg",
  #     #   :body => File.read("#{Rails.root}/attachments/#{adjunto}")

  #     # attachment "application/pdf" do |a|
  #     #   a.body = File.read("#{Rails.root}/attachments/#{adjunto}")
  #     # end
  #   end


  # end

end
