class AdministradorMailer < ActionMailer::Base
  default :from => "fundeim@ucv.ve"
  
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
    mail(:to => correo, :subject => "Aviso General - #{titulo}")
  end
  
  def enviar_correo_general(para,asunto,mensaje,adjunto)
    @mensaje = mensaje
    if adjunto
      # attachments["#{adjunto}"] = File.read("#{Rails.root}/attachments/#{adjunto}")
      # attachment :content_type => file.content_type, :body => File.read(file.full_path), :filename => file.filename
      # attachments.inline[adjunto] = File.read("#{Rails.root}/attachments/#{adjunto}")
      mail.attachments[adjunto] = File.read("#{Rails.root}/attachments/#{adjunto}")
    end
    mail(:to => para, :subject => asunto, :body => mensaje, :content_type => "text/html")
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
